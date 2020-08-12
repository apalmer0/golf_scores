class ScrapeLogger < ApplicationRecord
  validates :run_at, presence: true

  enum role: { tournament: 0, data: 1 }
end
