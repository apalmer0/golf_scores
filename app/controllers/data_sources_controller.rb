class DataSourcesController < ApplicationController
  before_action :set_data_source, only: [:show, :edit, :update, :destroy]

  def index
    @data_sources = DataSource.all
  end

  def new
    @data_source = DataSource.new
  end

  def create
    @data_source = DataSource.new(data_source_params)

    if @data_source.save
      redirect_to @data_source, notice: 'Data source was successfully created. Fetching data now.'
      DataScraperWorker.perform_async
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @data_source.update(data_source_params)
      redirect_to data_sources_path, notice: 'Data source was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @data_source.destroy

    redirect_to data_sources_url, notice: 'Data source was successfully destroyed.'
  end

  private

  def data_source_params
    params.require(:data_source).permit(:stat, :pga_id, :stat_column_name)
  end

  def set_data_source
    @data_source = DataSource.find(params[:id])
  end
end
