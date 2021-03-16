class SeriesScraperWorker < ApplicationWorker
  sidekiq_options retry: false

  def perform(pga_id)
    Scraper.new.scrape_series_data(pga_id)
  end
end
