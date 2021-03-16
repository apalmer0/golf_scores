class Correlation < ApplicationRecord
  belongs_to :tournament
  belongs_to :data_source

  validates :coefficient, presence: true
  validates :data_source_id, uniqueness: { scope: :tournament_id }
end
