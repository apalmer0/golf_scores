class TournamentScraperWorker < ApplicationWorker
  sidekiq_options retry: false

  def perform
    Scraper.scrape_for_new_tournaments
  end
end
