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
    emptied_matches = last_input.split(".").reject(&:empty?)

    allow_only = ["where", "find", "find_by", "all"]
    exclude_methods = ["delete", "delete_all", "destroy", "destroy_all", "update", "update_all", "save"]

    p "=============="
    p last_input.split(".")
    p @matched_data
    p emptied_matches
    p "=============="

    if emptied_matches.any?(&"delete".method(:include?)) || emptied_matches.any?(&"destroy".method(:include?)) || emptied_matches.any?(&"destroy_all".method(:include?)) || emptied_matches.any?(&"delete_all".method(:include?)) || emptied_matches.any?(&"update".method(:include?)) || emptied_matches.any?(&"update_all".method(:include?)) || emptied_matches.any?(&"save".method(:include?)) || emptied_matches.any?(&"create".method(:include?)) || emptied_matches.any?(&"new".method(:include?))  
      p @matched_data 
      last_input = @class_name + ".all"
      p "no deleting, destroying, saving, updating, creating"
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

    @correct = @level.valid_answer?(last_input)
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
          if history.empty?
            p "No more step"
            session[:query] =  [{input: "Movie.all"} ]
            session[:query_type] = "normal"
          end
          return
        end
      end
    end

    def get_return_type(result, relation, record, query_to_eval)
      if result.instance_of?(relation) || result.instance_of?(ActiveRecord::QueryMethods::WhereChain)
        # result = eval(query_to_eval)
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
        p "made record"
      elsif result.instance_of? Array
        return_type = "array"
      elsif result == "Record not found" || result == "Uh oh"  || result.nil?
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
      p "COMBINED"
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
      pattern = /([A-Z][a-z]*)\.([a-z]*_?[a-z]*)\(?{?(:?[a-z]*_?[a-z]*):?(=?>?)(\w*)}?\)?\.?([a-z]*)\(?(\d?)\)?/
      input.match(pattern).to_a.drop(1)
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

    def find_class_name(input)
      unless ["Movie", "Director", "Actor", "Role"].include? input
        return "Movie"
      end
      input
    end
end
