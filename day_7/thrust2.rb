require 'pry'
class Thrust2
  attr_reader :data_file

  def initialize(data_file)
    @data_file = data_file
  end

  def fresh_data(phase_settings)
    { data_array: File.read(data_file).strip.split(',').map { |i| i.to_i },
      pointer: 0,
      inputs: phase_settings << 0,
      output: nil
    }
  end

  def optimize_loop
    (56789..98765).each do |num|
      phase_settings = phase_settings_array(num, [5, 6, 7, 8, 9])
      if phase_settings
        data = fresh_data(phase_settings)
        while true
          @new_data = step(data)
          if @new_data[:output].last == 'HALT'
            && @new_data[:inputs].length % 5 == 0
            puts 'HALT'
            break
          end
          data = @new_data
        end
      end
    end
    puts "max_signal: #{@new_data[inputs].last}"
    puts "optimal_settings: #{@new_data[inputs][0..4]}"
    return @new_data[inputs].last
  end

  def phase_settings_array(num, test_arr)
    num_arr = num.to_s.rjust(5, '0').split('').map { |e| e.to_i }
    return num_arr if (test_arr - num_arr).empty?
    return false
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

  def step(data)
    pointer = data[:pointer]
    code = data[:data_array[pointer]]
    code_hash = interpret(code)
    opcode = code_hash[:opcode]
    l = instruction_length(opcode)
    instruction = instruction_array(data[:data_array], pointer, l)
    opcode = code_hash[:opcode]
    p1 = code_hash[:p1]
    p2 = code_hash[:p2]
    p3 = code_hash[:p3]

    case opcode
    when 1
      return process_opcode_1(data, instruction, p1, p2, p3)
    when 2
      return process_opcode_2(data, instruction, p1, p2, p3)
    when 3
      return process_opcode_3(data, instruction, input)
    when 4
      return process_opcode_4(data, instruction, p1)
    when 5
      return process_opcode_5(data, instruction, p1, p2)
    when 6
      return process_opcode_6(data, instruction, p1, p2)
    when 7
      return process_opcode_7(data, instruction, p1, p2, p3)
    when 8
      return process_opcode_8(data, instruction, p1, p2, p3)
    when 99
      return process_opcode_99(data)
    end
  end

  def instruction_array(data_array, pointer, length)
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

# Thrust.new('./day_7/data/input').optimize_loop
