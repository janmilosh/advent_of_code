require 'pry'
class Thrust
  attr_accessor :data_array, :current_instruction, :pointer, :input_signal,
    :phase_setting, :input_value, :max_signal, :optimal_settings
  attr_reader :data_file

  def initialize(data_file)
    @data_file = data_file
    @data_array = File.read(data_file).strip.split(',').map { |i| i.to_i }
    @pointer = 0
    @input_signal = 0
    @phase_setting = nil
    @input_value = false
    @max_signal = 0
    @optimal_settings = []
  end

  def optimize
    count = 0
    (1234..43210).each do |num|
      @phase_settings = phase_settings_array(num)
      if @phase_settings
        count += 1
        puts count
        @phase_settings.each do |setting|
          @phase_setting = setting
          run
          # puts "#{@input_signal}, #{@phase_setting} "

        end
      end
      if @input_signal > @max_signal
        @max_signal = @input_signal
        @optimal_settings = @phase_settings
      end
    end
    puts "max_signal: #{@max_signal}"
    puts "optimal_settings: #{@optimal_settings}"
    @max_signal
  end

  def phase_settings_array(num)
    num_arr = num.to_s.rjust(5, '0').split('').map { |e| e.to_i }
    test_arr = [0, 1, 2, 3, 4]
    return num_arr if (test_arr - num_arr).empty?
    return false
  end

  def run
    while true
      if step == false
        break
      end
    end
  end

  def input
    if @input_value
      @input_value = false
      puts "input a signal: #{@input_signal}"
      return @input_signal
    else
      @input_value = true
      puts "input a setting: #{@phase_setting}"
      return @phase_setting
    end
  end

  def output(diagnostic_code)
    puts "in output: #{pointer}: #{diagnostic_code}"
    @input_signal = diagnostic_code
  end

  def process_opcode_1(instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(instruction, p1, p2)
    value = p1_value + p2_value
    if p3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    @pointer += instruction.length
  end

  def process_opcode_2(instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(instruction, p1, p2)
    value = p1_value * p2_value
    if p3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    @pointer += instruction.length
  end

  def process_opcode_3(instruction)
    data_array[instruction[1]] = input
    @pointer += instruction.length
  end

  def process_opcode_4(instruction, p1)
    if p1 == 0
      output(data_array[instruction[1]])
    else
      output(data_array[pointer + 1])
    end
    @pointer += instruction.length
  end

  def process_opcode_5(instruction, p1, p2)
    p1_value, p2_value = p1_p2_values(instruction, p1, p2)
    if p1_value != 0
      @pointer = p2_value
    else
      @pointer += instruction.length
    end
  end

  def process_opcode_6(instruction, p1, p2)
    p1_value, p2_value = p1_p2_values(instruction, p1, p2)
    if p1_value == 0
      @pointer = p2_value
    else
      @pointer += instruction.length
    end
  end

  def process_opcode_7(instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(instruction, p1, p2)
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
    @pointer += instruction.length
  end

  def process_opcode_8(instruction, p1, p2, p3)
    p1_value, p2_value = p1_p2_values(instruction, p1, p2)
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
    @pointer += instruction.length
  end

  def p1_p2_values(instruction, p1, p2)
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

  def process(instruction, code_hash)
    opcode = code_hash[:opcode]
    p1 = code_hash[:p1]
    p2 = code_hash[:p2]
    p3 = code_hash[:p3]

    process_opcode_1(instruction, p1, p2, p3) if opcode == 1
    process_opcode_2(instruction, p1, p2, p3) if opcode == 2
    process_opcode_3(instruction) if opcode == 3
    process_opcode_4(instruction, p1) if opcode == 4
    process_opcode_5(instruction, p1, p2) if opcode == 5
    process_opcode_6(instruction, p1, p2) if opcode == 6
    process_opcode_7(instruction, p1, p2, p3) if opcode == 7
    process_opcode_8(instruction, p1, p2, p3) if opcode == 8
  end

  def step
    code = data_array[pointer]
    return false if code == 99
    code_hash = interpret(code)
    opcode = code_hash[:opcode]
    l = instruction_length(opcode)
    instruction = instruction_array(l)
    process(instruction, code_hash)
  end

  def instruction_array(length)
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

# Intcode2.new('./day_5/data/input').run
