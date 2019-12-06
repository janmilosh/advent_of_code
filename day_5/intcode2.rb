require 'pry'
class Intcode2
  attr_accessor :data_array, :current_instruction, :pointer
  attr_reader :data_file

  def initialize(data_file)
    @data_file = data_file
    @data_array = File.read(data_file).strip.split(',').map { |i| i.to_i }
    @pointer = 0
  end

  def run
    while true
      if step == false
        puts 'HALT'
        break
      end
    end
  end

  def input
    print "\nInput: "
    gets.chomp[0].to_i
  end

  def output(diagnostic_code)
    puts "#{pointer}: #{diagnostic_code}"
  end

  def process_opcode_1(instruction, p1, p2, p3)
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
    value = p1_value + p2_value
    if p3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    @pointer += instruction.length
  end

  def process_opcode_2(instruction, p1, p2, p3)
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

  def process(instruction, code_hash)
    opcode = code_hash[:opcode]
    p1 = code_hash[:p1]
    p2 = code_hash[:p2]
    p3 = code_hash[:p3]

    process_opcode_1(instruction, p1, p2, p3) if opcode == 1
    process_opcode_2(instruction, p1, p2, p3) if opcode == 2
    process_opcode_3(instruction) if opcode == 3
    process_opcode_4(instruction, p1) if opcode == 4
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
