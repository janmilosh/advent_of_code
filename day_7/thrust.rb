require 'pry'
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
      phase_settings = phase_settings_array(num, [0, 1, 2, 3, 4])
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

  def optimize_loop
    max_signal = 0
    (56789..98765).each do |num|
      phase_settings = phase_settings_array(num, [5, 6, 7, 8, 9])
      if phase_settings
        pointer = 0
        input_count = 0
        output = step(pointer, phase_settings[0]) #[pointer, output] or 99
        puts "pointer: #{pointer}, output: #{output}, input: #{phase_settings[0]}, input_count: #{input_count}"
        count = 0
        while count < 200
          if output == 99
            puts 'HALT'
            break
          elsif input_count <= 4 && output[1] == true
            input_count += 1
            input = phase_settings[input_count]
          end
          if output[1] == true && input_count == 5
            input = 0
            input_count += 1
          elsif (output[1].is_a? Integer) && input_count > 5
            input = output[1]
            @output_signal = output[1]
          end
          pointer = output[0]
          output = step(pointer, input)
          puts "pointer: #{pointer}, output: #{output}, input: #{input}, input_count: #{input_count}"
          count += 1
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

  def phase_settings_array(num, test_arr)
    num_arr = num.to_s.rjust(5, '0').split('').map { |e| e.to_i }
    return num_arr if (test_arr - num_arr).empty?
    return false
  end

  def run(phase_setting, input_signal)
    input = phase_setting
    pointer = 0
    while true
      output = step(pointer, input)
      if output == 99
        break
      elsif output[1] == true
        input = input_signal
      else
        output_signal = output[1]
      end
      pointer = output[0]
    end
    output_signal
  end

  def process_opcode_1(pointer, instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(pointer, instruction, p1, p2)
    value = p1_value + p2_value
    if p3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    [pointer += instruction.length, false]
  end

  def process_opcode_2(pointer, instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(pointer, instruction, p1, p2)
    value = p1_value * p2_value
    if p3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    [pointer += instruction.length, false]
  end

  def process_opcode_3(pointer, instruction, input)
    data_array[instruction[1]] = input
    [pointer += instruction.length, true]
  end

  def process_opcode_4(pointer, instruction, p1)
    if p1 == 0
      signal = data_array[instruction[1]]
    else
      signal = data_array[pointer + 1]
    end
    [pointer += instruction.length, signal]
  end

  def process_opcode_5(pointer, instruction, p1, p2)
    p1_value, p2_value = p1_p2_values(pointer, instruction, p1, p2)
    if p1_value != 0
      pointer = p2_value
    else
      pointer += instruction.length
    end
    [pointer, false]
  end

  def process_opcode_6(pointer, instruction, p1, p2)
    p1_value, p2_value = p1_p2_values(pointer, instruction, p1, p2)
    if p1_value == 0
      pointer = p2_value
    else
      pointer += instruction.length
    end
    [pointer, false]
  end

  def process_opcode_7(pointer, instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(pointer, instruction, p1, p2)
    if p1_value < p2_value
      value = 1
    else
      value = 0
    end
    if p3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    [pointer += instruction.length, false]
  end

  def process_opcode_8(pointer, instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(pointer, instruction, p1, p2)
    if p1_value == p2_value
      value = 1
    else
      value = 0
    end
    if p3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    [pointer += instruction.length, false]
  end

  def p1_p2_values(pointer, instruction, p1, p2)
    if p1 == 0
      p1_value = data_array[instruction[1]]
    else
      p1_value = data_array[pointer + 1]
    end
    if p2 == 0
      p2_value = data_array[instruction[2]]
    else
      p2_value = data_array[pointer + 2]
    end
    return p1_value, p2_value
  end

  def process(pointer, instruction, code_hash, input)
    opcode = code_hash[:opcode]
    p1 = code_hash[:p1]
    p2 = code_hash[:p2]
    p3 = code_hash[:p3]

    case opcode
    when 1
      return process_opcode_1(pointer, instruction, p1, p2, p3)
    when 2
      return process_opcode_2(pointer, instruction, p1, p2, p3)
    when 3
      return process_opcode_3(pointer, instruction, input)
    when 4
      return process_opcode_4(pointer, instruction, p1)
    when 5
      return process_opcode_5(pointer, instruction, p1, p2)
    when 6
      return process_opcode_6(pointer, instruction, p1, p2)
    when 7
      return process_opcode_7(pointer, instruction, p1, p2, p3)
    when 8
      return process_opcode_8(pointer, instruction, p1, p2, p3)
    end
  end

  def step(pointer, input)
    code = data_array[pointer]
    return 99 if code == 99
    code_hash = interpret(code)
    opcode = code_hash[:opcode]
    l = instruction_length(opcode)
    instruction = instruction_array(pointer, l)
    process(pointer, instruction, code_hash, input)
  end

  def instruction_array(pointer, length)
    data_array.slice(pointer, length)
  end

  def instruction_length(opcode)
    return 2 if opcode == 3
    return 2 if opcode == 4
    return 3 if opcode == 5
    return 3 if opcode == 6
    return 4
  end

  def interpret(code)
    code = code.to_s.rjust(5, '0')
    { opcode: code[3..4].to_i,
      p1: code[2].to_i,
      p2: code[1].to_i,
      p3: code[0].to_i
    }
  end
end

# Thrust.new('./day_7/data/input').optimize
