class GolfersController < ApplicationController
  def index
    @golfers = Golfer.all

    respond_to do |format|
      format.html
      format.csv { send_data @golfers.to_csv, filename: "GolferData-#{Date.today}.csv" }
    end
  end

  def show
    @golfer = Golfer.find(params[:id])
  end
end
