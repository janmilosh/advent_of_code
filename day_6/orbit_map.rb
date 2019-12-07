require 'pry'

class OrbitMap
  attr_reader :raw_data_array, :data_array, :data_hash, :node_hash

  def initialize(data_file)
    @raw_data_array = File.read(data_file).strip.split
    @data_array = raw_data_array.map { |e| e.split(')') }
    @node_hash = parse_node_hash
    @data_hash = parse_data

  end

  def parse_node_hash
    h = {}
    data_array.each do |e|
      if h.has_key? e[0]
        h[e[0]] << e[1]
      else
        h[e[0]] = [e[1]]
      end
    end
    h
  end

  def parse_data
    h = {}
    data_array.each do |e|
      h[e[1]] = e[0]
    end
    h
  end

  def walk_map
    count = 0
    data_hash.each do |k, v|
      while true
        count += 1
        if data_hash.has_key? v
          v = data_hash[v]
        else
          break
        end
      end
    end
    count
  end
end

# puts OrbitMap.new('./day_6/data/input').walk_map
