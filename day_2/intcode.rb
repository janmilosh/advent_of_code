class Intcode
  attr_accessor :data_array
  attr_reader :data_file

  def initialize(data_file)
    @data_file = data_file
    @data_array = fresh_data
  end

  def fresh_data
    File.read(data_file).strip.split(',').map { |i| i.to_i }
  end

  def max_input
    data_array.size - 1 < 99 ? data_array.size - 1 : 99
  end

  def process
    data_array.each_slice(4) do |a|
      break if a[0] == 99
      if a[0] == 1
        data_array[a[3]] = data_array[a[1]] + data_array[a[2]]
      else
        data_array[a[3]] = data_array[a[1]] * data_array[a[2]]
      end
    end
    data_array
  end

  def achieved(desired_output)
    data_array[0] == desired_output
  end

  def find_noun_and_verb(desired_output)
    (0..max_input).each do |noun|
      (0..max_input).each do |verb|
        @noun, @verb = noun, verb
        @data_array = fresh_data
        data_array[1], data_array[2] = noun, verb
        process
        break if achieved desired_output
      end
      break if achieved desired_output
    end
    100 * @noun + @verb
  end

  def final_code
    process[0]
  end
end

# puts "intcode: #{Intcode.new('./day_2/data/problem_1_data').final_code}"
# puts "noun_verb: #{Intcode.new('./day_2/data/problem_2_data').find_noun_and_verb(19690720)}"
