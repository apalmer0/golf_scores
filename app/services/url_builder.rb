class UrlBuilder
  def self.build(source, tournament)
    new(source, tournament).build
  end

  def initialize(source, tournament)
    @source = source
    @tournament = tournament
  end

  def build
    source.results_stat? ? results_url : stats_url
  end

  private

  attr_reader :source, :tournament

  def results_url
    "https://www.pgatour.com/tournaments/#{tournament.series.sanitized_name}/past-results/jcr:content/mainParsys/pastresults.selectedYear.#{tournament.year}.html"
  end

  def stats_url
    "https://www.pgatour.com/stats/stat.#{source.pga_id}.y#{tournament.year}.eon.#{tournament.series.pga_id}.html"
  end
end
