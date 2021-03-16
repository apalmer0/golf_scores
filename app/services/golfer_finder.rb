class GolferFinder
  def self.find_or_create_by(name, all_names)
    new(name, all_names).find_or_create_by
  end

  def initialize(name, all_names)
    @name = name
    @all_names = all_names
  end

  def find_or_create_by
    golfer ? golfer : name
  end

  private

  attr_reader :all_names, :name

  def golfer
    @golfer ||= golfers.find(name, threshold: 0.75)
  end

  def golfers
    FuzzyMatch.new(all_names)
  end
end
