mods = File.read('data_1').split.map{ |m| m.to_i }

fuel = []

mods.each do |m|
  loop do
    f = (m / 3).floor - 2
    break if f < 0
    fuel << f
    m = f
  end
end

puts fuel.inject(:+)
