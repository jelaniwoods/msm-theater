class LevelsController < ApplicationController
  before_action :set_level, only: %i[show store results]

  def show
    session[:query] = []
    session[:cleared] = false
    session[:step_query] = []
  end

  def results
    # result = eval(@query["input"])
    
    step_query_exists = session[:query_type] == "step"

    if step_query_exists
      p "CMON LES STEP"
      p params[:step]
    
    end

    @actual_query = session[:query].last["input"].strip
    query_to_eval = @actual_query.gsub("\r\n", ";")
    p "===============////////="
    p session[:query].last["input"]
    p query_to_eval
    p "=============///////////////////==="

    q = session[:query].last["input"].strip.gsub(" ", "")
    pattern = /([A-Z][a-z]*)\.([a-z]*_?[a-z]*)\(?{?(:?[a-z]*_?[a-z]*):?(=?>?)(\w*)}?\)?\.?([a-z]*)\(?(\d?)\)?/
    # pattern = /([A-Z][a-z]*).([a-z]*_?[a-z]*)\(?{?(:?[a-z]*):?(=?>?)(\w*)}?\)?\.?([a-z]*)\(?(\d?)\)?/
    @matched_data = q.match(pattern)
    @matched_data = @matched_data.to_a.drop 1
    @class_name = q.split(".").first
    unless ["Movie", "Director", "Actor", "Role"].include? @class_name
      @class_name = "Movie"
    end
    @column = @matched_data[2]

    # prevent deletion
    # https://stackoverflow.com/a/9622553
    # emptied_matches = @matched_data.reject(&:empty?)
    emptied_matches = q.split(".").reject(&:empty?)

    allow_only = ["where", "find", "find_by", "all"]
    exclude_methods = ["delete", "delete_all", "destroy", "destroy_all", "update", "update_all", "save"]
    p "=============="
    p q.split(".")
    p @matched_data
    p emptied_matches
    p "=============="
    if emptied_matches.any?(&"delete".method(:include?)) || emptied_matches.any?(&"destroy".method(:include?)) || emptied_matches.any?(&"destroy_all".method(:include?)) || emptied_matches.any?(&"delete_all".method(:include?)) || emptied_matches.any?(&"update".method(:include?)) || emptied_matches.any?(&"update_all".method(:include?)) || emptied_matches.any?(&"save".method(:include?))  
      p @matched_data 
      q = @class_name + ".all"
      # p "you fucked it"
    end

    begin
      # could also determine this from input
      relation = eval(@class_name).all.class
      record = eval(@class_name).first.class
    rescue Exception
      relation = Movie.all.class
      record = Movie
    end
    @res = session[:query].last["input"]
    begin
      if step_query_exists
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
      p @actual_query
      p @result
      p "idk when this would run"
    ensure
      # ensure that this code always runs, no matter what
      # does not change the final value of the block
    end


    if @result.instance_of?(relation) || @result.instance_of?(ActiveRecord::QueryMethods::WhereChain)
      # @result = eval(query_to_eval)
      if step_query_exists
        p "Running steps"
        @result = execute_steps
      else
        p query_to_eval
        @result = eval(query_to_eval)
      end
      @return_type = "collection"
    elsif @result.instance_of? record
      @return_type = "record"
      p "made record"
    elsif @result.instance_of? Array
      @return_type = "array"
    elsif @result == "Record not found" || @result == "Uh oh"  || @result.nil?
      @return_type = "error"
    else
      @return_type = "column"
      p "=========="
      p @result
      p @result.instance_of? record
      p "=========="
    end
    @correct = @level.valid_answer?(q)
    @type = nil
    if @result.methods.include?(:klass) && @result.klass == Movie
      @type = Movie
    elsif @result.methods.include?(:klass) && @result.klass == Director
      @type = Director
    elsif @result.methods.include?(:klass) && @result.klass == Actor
      @type = Actor
    elsif @result.methods.include?(:klass) && @result.klass == Role
      @type = Role
    end
    @header = figure_it_out(@return_type, @class_name, @column)
    
    @header_column = find_column(@matched_data)
    p @header_column
    p "----"
    unless @level.id + 1 > Level.last.id 
      @next_level = @level.id + 1
    else
      @next_level = 1
    end
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
    sess = session[:step_query]
    # session[:step_query] = sess - [sess[index]]
    p "===----==="
    p session[:query]
    p "===----==="
    sess.delete_at index
    # Remove query from list of queries
    find_and_remove_query_from_history(sess[index])
    p sess
    p "-----"
    p session[:step_query]
    redirect_back(fallback_location:"/")
  end

  private

    def find_and_remove_query_from_history(query)
      history =  session[:query].reverse
      history.each_with_index do |old_query, index|
        if old_query["input"] == query
          p "Delete this one"
          p old_query["input"]
          p "out of"
          p history
        end
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
end
