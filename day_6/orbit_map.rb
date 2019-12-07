require 'pry'

class OrbitMap
  attr_reader :raw_data_array, :data_array, :data_hash

  def initialize(data_file)
    @raw_data_array = File.read(data_file).strip.split
    @data_array = raw_data_array.map { |e| e.split(')') }
    @data_hash = parse_data
  end

  def parse_data
    h = {}
    data_array.each do |e|
      h[e[1]] = e[0]
    end
    h
  end

  def minimum_orbital_transfers
    san_array = trace_map('SAN')
    you_array = trace_map('YOU')
    common = san_array & you_array
    san_length = (san_array - common).length
    you_length = (you_array - common).length
    san_length + you_length - 2
  end

  def trace_map(value)
    arr = []
    while true
      arr << value
      if data_hash.has_key? value
        value = data_hash[value]
      else
        break
      end
    end
    arr
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
# puts OrbitMap.new('./day_6/data/input').minimum_orbital_transfers
