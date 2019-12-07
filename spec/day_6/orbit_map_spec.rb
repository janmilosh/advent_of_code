require_relative '../../day_6/orbit_map.rb'

RSpec.describe OrbitMap do
  let(:file1)      { './day_6/data/test_1' }
  let(:orbit_map1) { OrbitMap.new(file1) }
  let(:file2)      { './day_6/data/test_2' }
  let(:orbit_map2) { OrbitMap.new(file2) }

  describe '#initialize' do
    it 'initializes the raw data to an array' do
      expect(orbit_map1.raw_data_array).to eq ['COM)B', 'B)C', 'C)D', 'D)E',
        'E)F', 'B)G', 'G)H', 'D)I', 'E)J', 'J)K', 'K)L']
    end

    it 'splits the raw data into an array of 2 element arrays' do
      expect(orbit_map1.data_array).to eq [['COM', 'B'], ['B', 'C'], ['C', 'D'],
        ['D', 'E'], ['E', 'F'], ['B', 'G'], ['G', 'H'], ['D', 'I'], ['E', 'J'],
        ['J', 'K'], ['K', 'L']]
    end

    it 'creates a hash representing the connections' do
      expect(orbit_map1.data_hash). to include (
        {'B'=>'COM', 'C'=>'B', 'D'=>'C', 'E'=>'D', 'F'=>'E', 'G'=>'B', 'H'=>'G',
        'I'=>'D', 'J'=>'E', 'K'=>'J', 'L'=>'K'})
    end
  end

  describe '#walk_map' do
    it 'returns the total orbits by walking the map' do
      expect(orbit_map1.walk_map).to eq 42
    end
  end

  describe '#trace_map' do
    it 'returns an array of planets along path' do
      expect(orbit_map2.trace_map('SAN')).to eq ['SAN', 'I', 'D',
        'C', 'B', 'COM']
    end
  end

  describe '#minimal_orbital_transfers' do
    it 'calculates the minumum orbital transfers' do
      expect(orbit_map2.minimum_orbital_transfers).to eq 4
    end
  end
end
