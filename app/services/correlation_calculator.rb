class CorrelationCalculator
  def self.calculate(tournament)
    new(tournament).calculate
  end

  def initialize(tournament)
    @tournament = tournament
  end

  def calculate
    data_sources.each_with_object({}) do |source, hash|
      hash[source.stat] = correlation(source.stat)
    end.sort_by { |_, correlations| -correlations }.to_h
  end

  private

  attr_reader :tournament

  def correlation(stat)
    Pearson.coefficient(scores, DataSource::RESULTS, stat).truncate(5)
  end

  def collect_data_for(source)
    DataPoint.includes(:golfer).where(tournament: tournament, data_source: source).each_with_object({}) do |point, hash|
      hash[point.golfer.name] = point.rank
    end
  end

  def scores
    @scores ||= data_sources.each_with_object({}) do |source, hash|
      hash[source.stat] = collect_data_for(source)
    end
  end

  def data_sources
    @data_sources ||= DataSource.all
  end
end
