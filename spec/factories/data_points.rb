FactoryBot.define do
  factory :data_point do
    golfer
    tournament
    data_source
    value { "302.3" }
    rank { "1" }
  end
end
