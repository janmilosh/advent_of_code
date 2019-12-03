require 'pry'

class CrossedWires
  attr_reader :input_data, :path_1, :path_2
  attr_accessor :nodes_1, :nodes_2

  def initialize(data_file)
    data_file = data_file
    @input_data = File.read(data_file).strip.split
    @path_1, @path_2 = input_data[0].split(','), input_data[1].split(',')
    @nodes_1, @nodes_2 = [[0, 0]], [[0, 0]]
  end

  def manhattan_distance
    node = node_intersections.min do |a, b|
      a[0].abs + a[1].abs <=> b[0].abs + b[1].abs
    end
    node[0].abs + node[1].abs
  end

  def node_intersections
    nodes = build_nodes(nodes_1, path_1) & build_nodes(nodes_2, path_2)
    nodes.reject! {|e| e == [0, 0] }
    nodes
  end

  def build_nodes(start_node_array, path)
    path.each do |str|
      last_node = start_node_array.last
      start_node_array = start_node_array + new_nodes(last_node, str)
    end
    start_node_array
  end

  def new_nodes(last_node, str)
    moves = movement(str)
    nodes = []

    moves[0].times do |i|
      moves[1].times do |j|
        if moves[0] == 1
          node = [last_node[0], (last_node[1] + moves[2])]
        else
          node = [(last_node[0] + moves[2]), last_node[1]]
        end
        nodes << node
        last_node = node
      end
    end
    nodes
  end

  def movement(str)
    dir = str.slice!(0)
    dist = str.to_i
    case
    when dir == 'R' then return [dist, 1, 1]
    when dir == 'L' then return [dist, 1, -1]
    when dir == 'U' then return [1, dist, 1]
    when dir == 'D' then return [1, dist, -1]
    end
  end
end

# puts CrossedWires.new('./day_3/data/problem_1').manhattan_distance
