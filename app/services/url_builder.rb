class UrlBuilder
  def self.build(source, tournament)
    new(source, tournament).build
  end

  def initialize(source, tournament)
    @source = source
    @tournament = tournament
  end

  def build
    if source.results_stat?
      results_url
    else
      stats_url
    end
  end

  private

  attr_reader :source, :tournament

  def tournament_name
    most_recent_matching_tournament.name.gsub('& ', '').gsub(" ", "-").downcase
  end

  def most_recent_matching_tournament
    Tournament.where(pga_id: tournament.pga_id).order(year: :desc).first
  end

  def results_url
    "https://www.pgatour.com/tournaments/#{tournament_name}/past-results/jcr:content/mainParsys/pastresults.selectedYear.#{tournament.year}.html"
  end

  def stats_url
    "https://www.pgatour.com/stats/stat.#{source.pga_id}.y#{tournament.year}.eon.#{tournament.pga_id}.html"
  end
end
