FactoryBot.define do
  factory :correlation do
    tournament
    data_source
    coefficient { 0.8383 }
  end
end
