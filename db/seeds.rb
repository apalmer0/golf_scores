DataSource.destroy_all

data_sources = [
  {
    stat: 'SG Tee to Green',
    stat_column_name: 'average',
    pga_id: '02674',
  },
  {
    stat: 'SG Off Tee',
    stat_column_name: 'average',
    pga_id: '02567',
  },
  {
    stat: 'Driving Distance',
    stat_column_name: 'avg.',
    pga_id: '101',
  },
  {
    stat: 'Driving Accuracy',
    stat_column_name: '%',
    pga_id: '102',
  },
  {
    stat: 'Ball Striking',
    stat_column_name: 'value',
    pga_id: '158',
  },
  {
    stat: 'SG Approach',
    stat_column_name: 'average',
    pga_id: '02568',
  },
  {
    stat: 'GIR %',
    stat_column_name: '%',
    pga_id: '103',
  },
  {
    stat: 'Birdie or Better',
    stat_column_name: '%',
    pga_id: '352',
  },
  {
    stat: 'Bogey Avoidance',
    stat_column_name: '% makes bogey',
    pga_id: '02414',
  },
  {
    stat: 'SG Around the Green',
    stat_column_name: 'average',
    pga_id: '02569',
  },
  {
    stat: 'Scrambling',
    stat_column_name: '%',
    pga_id: '130',
  },
  {
    stat: 'Par 4 Scoring',
    stat_column_name: 'avg',
    pga_id: '143',
  },
  {
    stat: 'Par 5 Scoring',
    stat_column_name: 'avg',
    pga_id: '144',
  },
  {
    stat: 'Par 3 Scoring',
    stat_column_name: 'avg',
    pga_id: '142',
  },
  {
    stat: 'SG Putting',
    stat_column_name: 'average',
    pga_id: '02564',
  },
]

data_sources.each do |source|
  DataSource.create(source)
end
