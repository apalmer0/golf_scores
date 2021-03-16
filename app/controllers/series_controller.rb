class SeriesController < ApplicationController
  def index
    @series_list = filtered_series_list
  end

  def show
    @series = Series.includes(:data_sources, :tournaments).find(params[:id])
    @tournaments = @series.tournaments.order(year: 'asc')
    @data_sources = @series.data_sources.sort_by { |source| -@series.average_correlation_for(source) }.uniq
  end

  private

  def filtered_series_list
    series_list = Series.all.order(name: 'asc')

    if (series_params[:pga_id])
      series_list = series_list.where(pga_id: series_params[:pga_id])
    end

    if (series_params[:search] && series_params[:search].length > 0)
      series_list = series_list.search_by_name(series_params[:search])
    end

    series_list
  end

  def series_params
    params.permit(:id, :pga_id, :name, :search)
  end
end
