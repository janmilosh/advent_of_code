class CrossedWires
  attr_reader :input_data, :path_1, :path_2
  attr_accessor :nodes_1, :nodes_2

  def initialize(data_file)
    data_file = data_file
    @input_data = File.read(data_file).strip.split
    @path_1, @path_2 = input_data[0].split(','), input_data[1].split(',')
    @nodes_1, @nodes_2 = [[0, 0]], [[0, 0]]
  end

  def build_nodes(start_node_array, path)
    path.each do |str|
      last_node = start_node_array.last
      start_node_array << new_node(last_node, str)
    end
    start_node_array
  end

  def new_node(last_node, str)
    move = movement(str)
    [(last_node[0] + move[0]), (last_node[1] + move[1])]
  end

  def movement(str)
    dir = str.slice!(0)
    dist = str.to_i
    case
    when dir == 'R' then return [dist, 0]
    when dir == 'L' then return [- dist, 0]
    when dir == 'U' then return [0, dist]
    when dir == 'D' then return [0, - dist]
    end
  end
end
