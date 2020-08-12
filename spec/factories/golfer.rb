FactoryBot.define do
  factory :golfer do
    sequence(:name) { |n| "Golfer #{n}" }
  end
end
