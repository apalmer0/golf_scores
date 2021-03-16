# DataSource.destroy_all

data_sources = [
  { stat: 'SG Tee to Green', pga_id: '02674' },
  { stat: 'SG Off Tee', pga_id: '02567' },
  { stat: 'Driving Distance', pga_id: '101' },
  { stat: 'Driving Accuracy', pga_id: '102' },
  { stat: 'Ball Striking', pga_id: '158' },
  { stat: 'SG Approach', pga_id: '02568' },
  { stat: 'GIR %', pga_id: '103' },
  { stat: 'Birdie or Better', pga_id: '352' },
  { stat: 'Bogey Avoidance', pga_id: '02414' },
  { stat: 'SG Around the Green', pga_id: '02569' },
  { stat: 'Scrambling', pga_id: '130' },
  { stat: 'Par 4 Scoring', pga_id: '143' },
  { stat: 'Par 5 Scoring', pga_id: '144' },
  { stat: 'Par 3 Scoring', pga_id: '142' },
  { stat: 'SG Putting', pga_id: '02564' },
  { stat: DataSource::RESULTS },
]

data_sources.each do |source|
  DataSource.create(source)
end
