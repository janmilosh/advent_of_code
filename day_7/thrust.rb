require 'pry'

require_relative '../intcode_processor.rb'

class Thrust
  attr_accessor :data_array
  attr_reader :data_file

  def initialize(data_file)
    @data_file = data_file
    @data_array = File.read(data_file).strip.split(',').map { |i| i.to_i }
  end

  def optimize
    max_signal = 0
    (1234..43210).each do |num|
      phase_settings = phase_settings_array(num)
      if phase_settings
        input_signal = 0
        phase_settings.each do |phase_setting|
          @output_signal = run(phase_setting, input_signal)
          input_signal = @output_signal
        end
      end
      if @output_signal > max_signal
        max_signal = @output_signal
        @optimal_settings = phase_settings
      end
    end
    puts "max_signal: #{max_signal}"
    puts "optimal_settings: #{@optimal_settings}"
    return max_signal
  end

  def phase_settings_array(num)
    num_arr = num.to_s.rjust(5, '0').split('').map { |e| e.to_i }
    test_arr = [0, 1, 2, 3, 4]
    return num_arr if (test_arr - num_arr).empty?
    return false
  end

  def run(phase_setting, input_signal)
    input = phase_setting
    pointer = 0
    while true
      result = IntcodeProcessor.new(pointer, data_array, input).run
      if result[:output] == 'HALT'
        break
      elsif result[:output] == true
        input = input_signal
      else
        output_signal = result[:output]
      end
      pointer = result[:pointer]
      data_array = result[:data_array]
    end
    output_signal
  end
end

Thrust.new('./day_7/data/input').optimize
