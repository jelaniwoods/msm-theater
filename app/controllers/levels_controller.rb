class LevelsController < ApplicationController
  before_action :set_level, only: %i[show store results]

  def show
    session[:query] = []
  end

  def results
    # result = eval(@query["input"])
    @actual_query = session[:query].last["input"].strip
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
      @result = eval(@actual_query)
      # something which might raise an exception
    rescue ActiveRecord::RecordNotFound => some_variable
      p "error in eval"
      @result = "Record not found"
    rescue Exception => some_other_variable
      p "Any other error in eval"
      @result = "Uh oh"
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
      @result = eval(@actual_query)
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
    redirect_to "/levels/#{@level.id}/results", notice: "yup"
  end

  private
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
