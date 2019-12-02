puts File.read('data_1').split.map {|m| (m.to_i / 3).floor - 2 }.inject(:+)
