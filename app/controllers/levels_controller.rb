class LevelsController < ApplicationController
  before_action :set_level, only: %i[show store results]

  def show
    session[:query] = []
    session[:cleared] = false
    session[:step_query] = []
  end

  def results    

    @actual_query = session[:query].last["input"].strip
    query_to_eval = @actual_query.gsub("\r\n", ";")
    last_input = @actual_query.gsub(" ", "")
    @matched_data = get_matched_data(last_input)

    @class_name = find_class_name(last_input.split(".").first)
    @column = @matched_data[2]

    # prevent deletion
    # https://stackoverflow.com/a/9622553
    # emptied_matches = @matched_data.reject(&:empty?)
    # emptied_matches = last_input.split(".").reject(&:empty?).reject(&"all".method(:include?))
    emptied_matches = @matched_data.reject(&:empty?).reject(&"all".method(:include?))

    allow_only = ["where", "find", "find_by", "all"]
    exclude_methods = ["delete", "delete_all", "destroy", "destroy_all", "update", "update_all", "save", "create", "new"]

    non_emptied_matches = last_input.split(".")
    p "=============="
    p @actual_querys
    p non_emptied_matches
    p @matched_data
    p emptied_matches
    p "=============="

    # if emptied_matches.any?(&"delete".method(:include?)) || emptied_matches.any?(&"destroy".method(:include?)) || emptied_matches.any?(&"destroy_all".method(:include?)) || emptied_matches.any?(&"delete_all".method(:include?)) || emptied_matches.any?(&"update".method(:include?)) || emptied_matches.any?(&"update_all".method(:include?)) || emptied_matches.any?(&"save".method(:include?)) || emptied_matches.any?(&"create".method(:include?)) || emptied_matches.any?(&"new".method(:include?))  
    if emptied_matches.include?("delete") || emptied_matches.include?("delete_all") || emptied_matches.include?("destroy") || emptied_matches.include?("destroy_all") || emptied_matches.include?("update") || emptied_matches.include?("update_all") || emptied_matches.include?("save") || emptied_matches.include?("create") || emptied_matches.include?("new")
      p @matched_data 
      last_input = @class_name + ".all"
      p "no deleting, destroying, saving, updating, creating"
      @actual_query, query_to_eval, session[:query].last["input"] = "\"nope, invalid\"", "\"nope, invalid\"", "\"nope, invalid\""
      @matched_data = [query_to_eval]
      if step_query_exists?
        session[:step_query] = ["\"nope, invalid\""]
      end
    end


    relation, record = get_relation(@class_name), get_record(@class_name)

    @res = @actual_query # session[:query].last["input"]

    begin
      if step_query_exists?
        p "Running steps"
        @result = execute_steps
      else
        @result = eval(query_to_eval)
      end
      # something which might raise an exception
    rescue ActiveRecord::RecordNotFound => some_variable
      p "error in eval"
      @result = "Record not found"
    rescue Exception => some_other_variable
      p "Any other error in eval"
      @result = some_other_variable.to_s
      # code that deals with some other exception
    else
      # code that runs only if *no* exception was raised
    ensure
      # ensure that this code always runs, no matter what
      # does not change the final value of the block
    end

    @return_type = get_return_type(@result, relation, record, query_to_eval)

    if step_query_exists?
      combined_steps = session[:step_query].join(";")
      @correct = @level.is_solved_by?(combined_steps)
    else
      @correct = @level.is_solved_by?(last_input)
    end
    @type = get_type(@result)

    @header = figure_it_out(@return_type, @class_name, @column)
    @header_column = find_column(@matched_data)
 
    @next_level = get_next_level(@level.id)

  end

  def store
    @query = {input: params.fetch(:input), level_id: @level.id }
    # @query = {input: params.fetch(:input).gsub(/\s+/, ""), level_id: @level.id }

    session[:query].push @query
    status = "normal"
    if params[:step].present?
      session[:step_query].push params[:input]
      status = "step"
    end
    session[:query_type] = status
    redirect_to level_results_path(id: @level.id)
  end

  def remove_step
    index = params[:index].to_i
    p sess = session[:step_query]
    # session[:step_query] = sess - [sess[index]]
    p "===----==="
    p session[:query]
    p "===----==="
    p "finding"
    find_and_remove_query_from_history(sess[index])
    sess.delete_at index
    # Remove query from list of queries
    p sess
    p "-----"
    p session[:step_query]
    p session[:query]
    redirect_back(fallback_location:"/")
  end

  private

    def find_and_remove_query_from_history(query)
      history =  session[:query].reverse
      step_history =  session[:step_query].reverse
      p history
      p "---"
      p query
      history.each_with_index do |old_query, index|
        p old_query["input"]
        p "[=========]"
        if old_query["input"] == query
          p "Delete this one"
          history.delete_at(index)
          step_history.delete_at(index)
          session[:query] = history.reverse
          session[:step_query] = step_history.reverse
          p "====="
          p history
          if history.empty? || session[:step_query].empty?
            p "No more step"
            clear_queries
          end 
          return
        end
      end
    end

    def get_return_type(result, relation, record, query_to_eval)
      if result.instance_of?(relation) || result.instance_of?(ActiveRecord::QueryMethods::WhereChain)
        if step_query_exists?
          p "Running steps"
          result = execute_steps
        else
          p query_to_eval
          result = eval(query_to_eval)
        end
        return_type = "collection"
      elsif result.instance_of? record
        return_type = "record"
      elsif result.instance_of? Array
        return_type = "array"
      elsif result == "Record not found" || result == "Uh oh"
        return_type = "error"
        p "result #{result}"
        p "---___----"
      elsif result.nil?
        return_type = "nil"
      elsif result.class == String && ( result.include?("undefined") || result.include?("error") || result.include?("uninitialized") )
        return_type = "error"
      else
        return_type = "column"
      end
      return_type
    end

    def get_type(result)
      if result.methods.include?(:klass) && result.klass == Movie
        return Movie
      elsif result.methods.include?(:klass) && result.klass == Director
        return Director
      elsif result.methods.include?(:klass) && result.klass == Actor
        return Actor
      elsif result.methods.include?(:klass) && result.klass == Role
        return Role
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_level
      if params[:id].nil?
        @level = Level.find(1) # TODO change to cookie thing maybe
      else
        @level = Level.find(params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def level_params
      params.fetch(:level, {})
    end

    def execute_steps
      combined_steps = session[:step_query].join(";")
      p "executing steps"
      p combined_steps
      eval combined_steps
    end

    def get_relation(class_name)
      begin
        # could also determine this from input
        relation = eval(class_name).all.class
        record = eval(@class_name).first.class
      rescue Exception
        relation = Movie.all.class
        record = Movie
      end
      relation
    end

    def get_record(class_name)
      begin
        record = eval(class_name).first.class
      rescue Exception
        record = Movie
      end
      record
    end

    def get_next_level(current_level)
      unless current_level + 1 > Level.last.id 
        return current_level + 1
      else
        return 1
      end
    end

    def step_query_exists?
      session[:query_type] == "step"
    end

    def get_matched_data(input)
      # pattern = /([A-Z][a-z]*)\.([a-z]*_?[a-z]*)\(?{?(:?[a-z]*_?[a-z]*):?(=?>?)(\w*)}?\)?\.?([a-z]*)\(?(\d?)\)?/
      # input.match(pattern).to_a.drop(1)
      pattern = /([a-zA-Z]+)(=?)([A-Z]*[a-z]*)\.([a-z]*_?[a-z]*)\(?{?(:?[a-z]*_?[a-z]*):?(=?>?)(\w*)}?\)?\.?([a-z]*)\(?(\d?)\)?/
      input.match(pattern).to_a
    end

    def figure_it_out(type, class_name, column)
      render_this_header = ""
      case type
      when "collection", "record"
        case class_name
        when "Movie"
          render_this_header = "movie_header"
        when "Actor"
          render_this_header = "actor_header"
        when "Role"
          render_this_header = "role_header"
        when "Director"
          render_this_header = "director_header"
        end
        
      when "array"
        render_this_header = "array_column"
      when "error"
        render_this_header = "error"
      when "nil"
        render_this_header = "nil"
      when "column"
        case class_name
        when "Movie", "Director", "Actor", "Role"
          render_this_header = "column_header"
        end
      end
      return render_this_header
    end

    def find_column(matched_data)
      class_name = matched_data.first
      emptied_matches = matched_data.reject(&:empty?)

      column = emptied_matches.last    
    end

    def clear_queries
      session[:step_query] = []
      session[:query_type] = "normal"
      session[:query] =  [{input: "Movie.all"} ]
    end

    def find_class_name(input)
      p "getting class name for #{input}"
      p input = input.split("=").last
      unless ["Movie", "Director", "Actor", "Role"].include? input
        # check step queries for variable assignment
        p "checking steps..."
        session[:step_query].each do |query|
          p query
          if query.include?("=") && query.include?(input)
            p "fpuond #{query}"
            location = session[:step_query].index query
            class_input = session[:step_query][location]
            removed_variable = class_input.split("=").last
            actual_class_name = removed_variable.split(".").first.strip
            if ["Movie", "Director", "Actor", "Role"].include? actual_class_name
              return actual_class_name.strip
            else
              p actual_class_name
              p "Not actually a valid class in Step Queries"
            end
          end
        end
        # Not a regular query and can't find variable assignment in session so
        p "Movie i guesss...//"
        input = "Movie"
      end
      input
    end
end
