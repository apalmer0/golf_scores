class GolferFinder
  def self.find_or_create_by(name)
    new(name).find_or_create_by
  end

  def initialize(name)
    @name = name
  end

  def find_or_create_by
    golfer ? golfer : Golfer.create(name: name)
  end

  private

  attr_reader :name

  def golfer
    @golfer ||= golfers.find(name, threshold: 0.75)
  end

  def golfers
    FuzzyMatch.new(Golfer.all, read: :name)
  end
end
