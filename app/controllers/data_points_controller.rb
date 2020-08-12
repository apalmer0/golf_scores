class DataPointsController < ApplicationController
  def index
    @data_points = filtered_data_points
    @data_sources = DataSource.all
    @count_of_points = DataPoint.count
  end

  private

  def filtered_data_points
    data_points = DataPoint.joins(:data_source)

    if (params[:stat])
      data_points = data_points.where(data_sources: { stat: params[:stat] })
    end

    data_points.order(:rank).page(params[:page])
  end
end
