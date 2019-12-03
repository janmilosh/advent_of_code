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
      expect(crossed_wires.movement('R3')).to eq [3, 1, 1]
    end

    it 'returns an array describing -x movement' do
      expect(crossed_wires.movement('L5')).to eq [5, 1, -1]
    end

    it 'returns an array describing +y movement' do
      expect(crossed_wires.movement('U6')).to eq [1, 6, 1]
    end

    it 'returns an array describing -y movement' do
      expect(crossed_wires.movement('D4')).to eq [1, 4, -1]
    end
  end

  describe '#new_nodes' do
    it 'creates next node given original node and movement' do
      expect(crossed_wires.new_nodes([1, -3], 'U4'))
        .to eq [[1, -2], [1, -1], [1, 0], [1, 1]]
      expect(crossed_wires.new_nodes([55, 3], 'D3'))
        .to eq [[55, 2], [55, 1], [55, 0]]
      expect(crossed_wires.new_nodes([-20, -4], 'L10'))
        .to eq [[-21, -4], [-22, -4], [-23, -4], [-24, -4], [-25, -4],
                [-26, -4], [-27, -4], [-28, -4], [-29, -4], [-30, -4]]
      expect(crossed_wires.new_nodes([-4, 4], 'R1'))
        .to eq [[-4, 5]]
    end
  end

  describe '#build_nodes' do
    it 'creates array of nodes that make up wire path for wire 1' do
      start_node_array = crossed_wires.nodes_1
      path = crossed_wires.path_1
      nodes = crossed_wires.build_nodes(start_node_array, path)
      expect(nodes).to eq [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0],
        [6, 0], [7, 0], [8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5],
        [7, 5], [6, 5], [5, 5], [4, 5], [3, 5], [3, 4], [3, 3], [3, 2]]
    end

    it 'creates array of nodes that make up wire path for wire 2' do
      start_node_array = crossed_wires.nodes_2
      path = crossed_wires.path_2
      nodes = crossed_wires.build_nodes(start_node_array, path)
      expect(nodes).to eq [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5],
        [0, 6], [0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [6, 6],
        [6, 5], [6, 4], [6, 3], [5, 3], [4, 3], [3, 3], [2, 3]]
    end
  end

  describe '#node_intersections' do
    it 'finds intersections of two arrays' do
      intersections = crossed_wires.node_intersections
      expect(intersections).to include [6, 5]
      expect(intersections).to include [3, 3]
      expect(intersections).to_not include [0, 0]
    end
  end

  describe '#manhattan_distance' do
    it 'finds the Manhattan distance of two wires' do
      distance = crossed_wires.manhattan_distance
      expect(distance).to eq 6
    end
  end

end
