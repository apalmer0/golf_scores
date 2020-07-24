class DataSourcesController < ApplicationController
  def index
    @data_sources = DataSource.all
  end

  def new
  end

  def create
  end

  def edit
    @data_source = DataSource.find(params[:id])
  end

  def update
    @data_source = DataSource.find(params[:id])

    if @data_source.update(data_source_params)
      redirect_to data_sources_path, notice: 'Data source was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
  end

  def data_source_params
    params
      .require(:data_source)
      .permit(
        :data_types,
        :destination_column_names,
        :golfer_column_name,
        :last_fetched,
        :source_column_names,
        :source,
        :stat,
        :table_location,
        :url,
        :year,
      )
  end
end
