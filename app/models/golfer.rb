class Golfer < ApplicationRecord
  has_many :data_points

  validates :name, presence: true, uniqueness: true
end
