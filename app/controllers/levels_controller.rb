class LevelsController < ApplicationController
  before_action :set_level, only: %i[show store results]

  def show
    session[:query] = []
  end

  def results
    # result = eval(@query["input"])
    @res = session[:query].last["input"]
    @result = eval(@res)
    @type = nil
    if @result.methods.include?(:klass) && @result.klass == Movie
      @type = Movie
    end
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
end
