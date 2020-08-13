class GolfersController < ApplicationController
  def index
    @golfers = filtered_golfers
  end

  def show
    @golfer = Golfer.find(params[:id])
    @tournaments = @golfer.tournaments.uniq
  end

  def filtered_golfers
    golfers = Golfer.all.order(name: 'asc')

    if (golfer_params[:search] && golfer_params[:search].length > 0)
      golfers = golfers.search_by_name(golfer_params[:search])
    end

    golfers
  end

  def golfer_params
    params.permit(:id, :pga_id, :name, :year, :search)
  end
end
