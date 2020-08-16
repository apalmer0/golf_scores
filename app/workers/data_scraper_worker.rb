class DataScraperWorker < ApplicationWorker
  sidekiq_options retry: false

  def perform
    Scraper.scrape_data_from_all_tournaments
  end
end
