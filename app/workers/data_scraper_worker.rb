class DataScraperWorker < ApplicationWorker
  sidekiq_options retry: false

  def perform
    Scraper.scrape_tournament_data
  end
end
