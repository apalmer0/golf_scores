class TournamentsController < ApplicationController
  def index
    @tournaments = filtered_tournaments
    @stats_count = DataSource.count
    @years = Scraper::YEARS
  end

  def show
    @tournament = Tournament.find(params[:id])
    @data_sources = @tournament.data_sources.uniq
    @data_points = @tournament.data_points
    @golfers = @tournament.golfers.uniq
  end

  private

  def filtered_tournaments
    tournaments = Tournament.includes(:data_sources).all.order(year: 'desc')

    if (params[:year])
      tournaments = tournaments.where(year: params[:year])
    end

    if (params[:pga_id])
      tournaments = tournaments.where(pga_id: params[:pga_id])
    end

    tournaments
  end
end
