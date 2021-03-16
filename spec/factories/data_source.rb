FactoryBot.define do
  factory :data_source do
    sequence(:pga_id) { |n| "#{n}" }
    sequence(:stat) { |n| "data source #{n}" }
  end
end
