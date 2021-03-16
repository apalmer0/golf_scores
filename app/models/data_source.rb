class DataSource < ApplicationRecord
  RESULTS = 'results'

  has_many :correlations
  has_many :tournaments, through: :correlations

  validates :pga_id, presence: true, unless: -> { self.stat == RESULTS }
  validates :pga_id, uniqueness: true
  validates :stat, presence: true
  validates :stat, uniqueness: true

  def self.not_yet_pulled_for(tournament)
    DataSource.where.not(id: tournament.data_sources)
  end

  def self.results
    DataSource.where(stat: RESULTS).first
  end

  def self.stats
    DataSource.where.not(stat: RESULTS)
  end

  def results_stat?
    stat == RESULTS
  end
end
