class TournamentScraperWorker < ApplicationWorker
  sidekiq_options retry: false

  def perform(pga_id)
    Scraper.new.scrape_tournament_series(pga_id)
  end
end
