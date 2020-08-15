class DataSource < ApplicationRecord
  RESULTS = 'results'

  has_many :data_points

  validates :pga_id, presence: true, unless: -> { self.stat == RESULTS }
  validates :pga_id, uniqueness: true
  validates :stat_column_name, presence: true, unless: -> { self.stat == RESULTS }
  validates :stat, presence: true
  validates :stat, uniqueness: true

  def self.not_yet_pulled_for(tournament)
    DataSource.all - tournament.data_sources.uniq
  end
end
