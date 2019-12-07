require_relative '../../day_6/orbit_map.rb'

RSpec.describe OrbitMap do
  let(:file)      { './day_6/data/test_1' }
  let(:orbit_map) { OrbitMap.new(file) }

  describe '#initialize' do
    it 'initializes the raw data to an array' do
      expect(orbit_map.raw_data_array).to eq ['COM)B', 'B)C', 'C)D', 'D)E',
        'E)F', 'B)G', 'G)H', 'D)I', 'E)J', 'J)K', 'K)L']
    end

    it 'splits the raw data into an array of 2 element arrays' do
      expect(orbit_map.data_array).to eq [['COM', 'B'], ['B', 'C'], ['C', 'D'],
        ['D', 'E'], ['E', 'F'], ['B', 'G'], ['G', 'H'], ['D', 'I'], ['E', 'J'],
        ['J', 'K'], ['K', 'L']]
    end

    it 'creates a hash showing nodes' do
      expect(orbit_map.node_hash).to include (
        { 'COM' => ['B'],
           'B' => ['C', 'G'],
           'C' => ['D'],
           'D' => ['E', 'I'],
           'E' => ['F', 'J'],
           'G' => ['H'],
           'J' => ['K'],
           'K' => ['L']
          })
    end

    it 'creates a hash representing the connections' do
      expect(orbit_map.data_hash). to include (
        {'B'=>'COM', 'C'=>'B', 'D'=>'C', 'E'=>'D', 'F'=>'E', 'G'=>'B', 'H'=>'G',
        'I'=>'D', 'J'=>'E', 'K'=>'J', 'L'=>'K'})
    end
  end

  describe '#walk_map' do
    it 'returns the total orbits by walking the map' do
      expect(orbit_map.walk_map).to eq 42
    end
  end
end
