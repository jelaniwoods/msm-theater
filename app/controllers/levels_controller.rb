class LevelsController < ApplicationController
  before_action :set_level, only: %i[show store results]

  def show
    session[:query] = []
  end

  def results
    # result = eval(@query["input"])
    q = session[:query].last["input"].gsub(" ", "")
    pattern = /([A-Z][a-z]*).([a-z]*_?[a-z]*)\(?{?(:?[a-z]*):?(=?>?)(\w*)}?\)?\.?([a-z]*)\(?(\d?)\)?/
    @matched_data = q.match(pattern)
    @matched_data = @matched_data.to_a.drop 1
    @class_name = q.split(".").first
    unless ["Movie", "Director", "Actor", "Role"].include? @class_name
      @class_name = "Movie"
    end
    @column = @matched_data[2]

    # prevent deletion
    # https://stackoverflow.com/a/9622553
    if @matched_data.reject(&:empty?).any?(&"delete".method(:include?)) || @matched_data.reject(&:empty?).any?(&"destroy".method(:include?))
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
      @result = eval(q)
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
      p "idk when this would run"
    ensure
      # ensure that this code always runs, no matter what
      # does not change the final value of the block
    end


    if @result.instance_of?(relation) || @result.instance_of?(ActiveRecord::QueryMethods::WhereChain)
      @result = eval(q.gsub("()", "({})"))
      @return_type = "collection"
    elsif @result.instance_of? record
      @return_type = "record"
    elsif @result.instance_of? Array
      @return_type = "array"
    elsif @result == "Record not found" || @result == "Uh oh"
      @return_type = "error"
    else
      @return_type = "column"
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



  end

  def store
    @query = {input: params.fetch(:input).gsub(/\s+/, ""), level_id: @level.id }
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
        when "Movie"
          render_this_header = "movie_#{column}_header"
        end
      end
      return render_this_header
    end
end
