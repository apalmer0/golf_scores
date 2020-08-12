class DataScraperWorker < ApplicationWorker
  sidekiq_options retry: false

  def perform
    Scraper.scrape_data
  end
end
