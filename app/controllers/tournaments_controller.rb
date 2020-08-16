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
    @correlations = JSON.parse(@tournament.correlations)
  end

  private

  def filtered_tournaments
    tournaments = Tournament.includes(:data_sources).all.order(year: 'desc')

    if (tournament_params[:year])
      tournaments = tournaments.where(year: tournament_params[:year])
    end

    if (tournament_params[:pga_id])
      tournaments = tournaments.where(pga_id: tournament_params[:pga_id])
    end

    if (tournament_params[:search] && tournament_params[:search].length > 0)
      tournaments = tournaments.search_by_name(tournament_params[:search])
    end

    tournaments
  end

  def tournament_params
    params.permit(:id, :pga_id, :name, :year, :search)
  end
end
