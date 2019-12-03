require_relative '../../day_3/crossed_wires.rb'

RSpec.describe CrossedWires do
  let(:file)   { './day_3/data/test' }
  let(:crossed_wires)   { CrossedWires.new(file) }

  describe '#initialize' do
    it 'imports data into a 2 element array' do
      expect(crossed_wires.input_data).to eq ["R8,U5,L5,D3", "U7,R6,D4,L4"]
    end

    it 'separates data into two arrays representing each wire path' do
      expect(crossed_wires.path_1).to eq ['R8', 'U5', 'L5', 'D3']
      expect(crossed_wires.path_2).to eq ['U7', 'R6', 'D4', 'L4']
    end

    it 'initializes a node array for each wire' do
      expect(crossed_wires.nodes_1).to eq [[0, 0]]
      expect(crossed_wires.nodes_2).to eq [[0, 0]]
    end
  end

  describe '#movement' do
    it 'returns an array describing +x movement' do
      expect(crossed_wires.movement('R3')).to eq [3, 0]
    end

    it 'returns an array describing -x movement' do
      expect(crossed_wires.movement('L7')).to eq [-7, 0]
    end

    it 'returns an array describing +y movement' do
      expect(crossed_wires.movement('U450')).to eq [0, 450]
    end

    it 'returns an array describing -y movement' do
      expect(crossed_wires.movement('D17')).to eq [0, -17]
    end
  end

  describe '#new_node' do
    it 'creates next node given original node and movement' do
      expect(crossed_wires.new_node([27, -49], 'U9')).to eq [27, -40]
      expect(crossed_wires.new_node([-32, -2], 'L970')).to eq [-1002, -2]
      expect(crossed_wires.new_node([0, 0], 'D43')).to eq [0, -43]
      expect(crossed_wires.new_node([14, 7], 'R62')).to eq [76, 7]
    end
  end

end
