class DataPoint < ApplicationRecord
  belongs_to :data_source
  belongs_to :golfer
  belongs_to :tournament

  validates :golfer, uniqueness: { scope: [:data_source, :tournament] }
  validates :value, presence: true
  validates :rank, presence: true
end
