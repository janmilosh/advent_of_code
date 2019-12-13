require 'pry'

class IntcodeProcessor
  attr_reader :input, :opcode,
    :parameter_mode_1, :parameter_mode_2, :parameter_mode_3,
    :instruction, :parameter_1, :parameter_2
  attr_accessor :pointer, :data_array

  def initialize(pointer, data_array, input=nil)
    @pointer = pointer
    @data_array = data_array
    @input = input
    code = @data_array[@pointer]
    code_hash = interpret(code)
    @opcode = code_hash[:opcode]
    @parameter_mode_1 = code_hash[:parameter_mode_1]
    @parameter_mode_2 = code_hash[:parameter_mode_2]
    @parameter_mode_3 = code_hash[:parameter_mode_3]
    @instruction = instruction_array(@data_array, @opcode, @pointer)
    @parameter_1 = process_parameter_1(
      @data_array, @instruction, @parameter_mode_1)
    @parameter_2 = process_parameter_2(
      @data_array, @instruction, @parameter_mode_2)
  end

  def run
    output = process
    { pointer: pointer, data_array: data_array, output: output }
  end

  def process
    return process_opcode_1 if opcode == 1
    return process_opcode_2 if opcode == 2
    return process_opcode_3 if opcode == 3
    return process_opcode_4 if opcode == 4
    return process_opcode_5 if opcode == 5
    return process_opcode_6 if opcode == 6
    return process_opcode_7 if opcode == 7
    return process_opcode_8 if opcode == 8
    return process_opcode_99 if opcode == 99
  end

  def instruction_array(data_array, opcode, pointer)
    length = instruction_length(opcode)
    data_array.slice(pointer, length)
  end

  def instruction_length(opcode)
    return 1 if opcode == 99
    return 2 if opcode == 3
    return 2 if opcode == 4
    return 3 if opcode == 5
    return 3 if opcode == 6
    return 4
  end

  def interpret(code)
    code = code.to_s.rjust(5, '0')
    { opcode: code[3..4].to_i,
      parameter_mode_1: code[2].to_i,
      parameter_mode_2: code[1].to_i,
      parameter_mode_3: code[0].to_i
    }
  end

  def process_parameter_1(data_array, instruction, parameter_mode_1)
    return nil if instruction.length < 2
    if parameter_mode_1 == 0
      return data_array[instruction[1]]
    else
      return data_array[pointer + 1]
    end
  end

  def process_parameter_2(data_array, instruction, parameter_mode_2)
    return nil if instruction.length < 3
    if parameter_mode_2 == 0
      return data_array[instruction[2]]
    else
      return data_array[pointer + 2]
    end
  end

  def process_opcode_1
    value = parameter_1 + parameter_2
    if parameter_mode_3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    @pointer += instruction.length
    false
  end

  def process_opcode_2
    value = parameter_1 * parameter_2
    if parameter_mode_3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    @pointer += instruction.length
    false
  end

  def process_opcode_3
    data_array[instruction[1]] = input
    @pointer += instruction.length
    true
  end

  def process_opcode_4
    if parameter_mode_1 == 0
      output = data_array[instruction[1]]
    else
      output = data_array[pointer + 1]
    end
    @pointer += instruction.length
    output
  end

  def process_opcode_5
    if parameter_1 != 0
      @pointer = parameter_2
    else
      @pointer += instruction.length
    end
    false
  end

  def process_opcode_6
    if parameter_1 == 0
      @pointer = parameter_2
    else
      @pointer += instruction.length
    end
    false
  end

  def process_opcode_7
    if parameter_1 < parameter_2
      value = 1
    else
      value = 0
    end
    if parameter_mode_3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    @pointer += instruction.length
    false
  end

  def process_opcode_8
    if parameter_1 == parameter_2
      value = 1
    else
      value = 0
    end
    if parameter_mode_3 == 0
      data_array[instruction[3]] = value
    else
      data_array[pointer + 3] = value
    end
    @pointer += instruction.length
    false
  end

  def process_opcode_99
    @pointer += 1
    'HALT'
  end
end
