class LevelsController < ApplicationController
  before_action :set_level, only: %i[show store results]

  def show
    session[:query] = []
  end

  def results
    # result = eval(@query["input"])
    q = session[:query].last["input"].gsub(" ", "")
    @class_name = q.split(".").first
    @column = q.split(".").last
    @return_type = "column"
    @res = session[:query].last["input"]
    @result = eval(q)
    @correct = @level.valid_answer?(q)
    @type = nil
    if @result.methods.include?(:klass) && @result.klass == Movie
      @type = Movie
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
        render_this_header = "movie_header"

      when "array"

      when "column"
        case class_name
        when "Movie"
          render_this_header = "movie_#{column}_header"
        end
      end
      return render_this_header
    end
end
