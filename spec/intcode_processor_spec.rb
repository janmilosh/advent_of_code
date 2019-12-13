require_relative '../intcode_processor.rb'

RSpec.describe IntcodeProcessor do
  let(:intcode_processor) { IntcodeProcessor.new(pointer, data_array, input) }
  let(:pointer)    { 2 }
  let(:input)      { 9 }

  describe '#initialize' do
    let(:data_array) { [3, 26, 1001, 1, 28, 6, 99] }

    it 'sets the pointer' do
      expect(intcode_processor.pointer).to eq 2
    end

    it 'sets the data_array' do
      expect(intcode_processor.data_array).to eq [3, 26, 1001, 1, 28, 6, 99]
    end

    it 'sets the input' do
      expect(intcode_processor.input).to eq 9
    end

    it 'sets the opcode' do
      expect(intcode_processor.opcode).to eq 1
    end

    it 'sets the parameter modes' do
      expect(intcode_processor.parameter_mode_1).to eq 0
      expect(intcode_processor.parameter_mode_2).to eq 1
      expect(intcode_processor.parameter_mode_3).to eq 0
    end

    it 'sets the instruction' do
      expect(intcode_processor.instruction).to eq [1001, 1, 28, 6]
    end

    context 'with parameter_mode_1 == 0 and parameter_mode_2 == 0' do
      let(:data_array) { [3, 26, 1, 2, 5, 6, 99] }

      it 'sets the parameters' do
        expect(intcode_processor.parameter_1).to eq 1
        expect(intcode_processor.parameter_2).to eq 6
      end
    end

    context 'with parameter_mode_1 == 1 and parameter_mode_2 == 0' do
      let(:data_array) { [3, 26, 101, 2, 5, 6, 99] }

      it 'sets the parameters' do
        expect(intcode_processor.parameter_1).to eq 2
        expect(intcode_processor.parameter_2).to eq 6
      end
    end

    context 'with parameter_mode_1 == 0 and parameter_mode_2 == 1' do
      let(:data_array) { [3, 26, 1001, 2, 5, 6, 99] }

      it 'sets the parameters' do
        expect(intcode_processor.parameter_1).to eq 1001
        expect(intcode_processor.parameter_2).to eq 5
      end
    end

    context 'with parameter_mode_1 == 1 and parameter_mode_2 == 1' do
      let(:data_array) { [3, 26, 1101, 2, 5, 6, 99] }

      it 'sets the parameters' do
        expect(intcode_processor.parameter_1).to eq 2
        expect(intcode_processor.parameter_2).to eq 5
      end
    end

    context 'with parameter_mode_1 == 1 and parameter_mode_2 == 1 and instruction.length < 3' do
      let(:data_array) { [3, 26, 1104, 2, 5, 6, 99] }

      it 'sets the parameters' do
        expect(intcode_processor.parameter_1).to eq 2
        expect(intcode_processor.parameter_2).to be nil
      end
    end
  end

  describe '#process_opcode_1' do
    context 'parameter_mode_3 == 0' do
      let(:data_array) { [3, 26, 1, 2, 5, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_1
        expect(intcode_processor.opcode).to eq 1
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 1, 4, 5, 3, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_mode_3 == 1' do
      let(:data_array) { [3, 26, 10001, 2, 5, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_1
        expect(intcode_processor.opcode).to eq 1
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 10001, 2, 5, 10004, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end
  end

  describe '#process_opcode_2' do
    context 'parameter_mode_3 == 0' do
      let(:data_array) { [3, 26, 2, 2, 5, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_2
        expect(intcode_processor.opcode).to eq 2
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 2, 6, 5, 3, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_mode_3 == 1' do
      let(:data_array) { [3, 26, 10002, 2, 5, 3, 99] }

      it 'returns true and alters the pointer and array' do
        result = intcode_processor.process_opcode_2
        expect(intcode_processor.opcode).to eq 2
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 10002, 2, 5, 30006, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end
  end

  describe '#process_opcode_3' do
    let(:data_array) { [3, 26, 10003, 2, 5, 3, 99] }

    it 'returns true and alters the pointer and array after taking an input' do
      result = intcode_processor.process_opcode_3
      expect(intcode_processor.opcode).to eq 3
      expect(result).to be true
      expect(intcode_processor.data_array).to eq [3, 26, 9, 2, 5, 3, 99]
      expect(intcode_processor.pointer).to eq 4
    end
  end

  describe '#process_opcode_4' do
    context 'parameter_mode_3 == 0' do
      let(:data_array) { [3, 26, 4, 1, 5, 3, 99] }

      it 'returns the output and alters the pointer without changing the array' do
        result = intcode_processor.process_opcode_4
        expect(intcode_processor.opcode).to eq 4
        expect(result).to eq 26
        expect(intcode_processor.data_array).to eq [3, 26, 4, 1, 5, 3, 99]
        expect(intcode_processor.pointer).to eq 4
      end
    end

    context 'parameter_mode_3 == 1' do
      let(:data_array) { [3, 26, 104, 2, 5, 3, 99] }

      it 'returns the output and alters the pointer without changing the array' do
        result = intcode_processor.process_opcode_4
        expect(intcode_processor.opcode).to eq 4
        expect(result).to eq 2
        expect(intcode_processor.data_array).to eq [3, 26, 104, 2, 5, 3, 99]
        expect(intcode_processor.pointer).to eq 4
      end
    end
  end

  describe '#process_opcode_5' do
    context 'parameter_1 == 0' do
      let(:data_array) { [3, 26, 1105, 0, 2, 3, 99] }

      it 'returns false and alters the pointer without changing the array' do
        result = intcode_processor.process_opcode_5
        expect(intcode_processor.opcode).to eq 5
        expect(result).to eq false
        expect(intcode_processor.data_array).to eq [3, 26, 1105, 0, 2, 3, 99]
        expect(intcode_processor.pointer).to eq 5
      end
    end

    context 'parameter_1 != 0' do
      let(:data_array) { [3, 26, 1105, 4, 2, 3, 99] }

      it 'returns false and alters the pointer without changing the array' do
        result = intcode_processor.process_opcode_5
        expect(intcode_processor.opcode).to eq 5
        expect(result).to eq false
        expect(intcode_processor.data_array).to eq [3, 26, 1105, 4, 2, 3, 99]
        expect(intcode_processor.pointer).to eq 2
      end
    end
  end

  describe '#process_opcode_6' do
    context 'parameter_1 == 0' do
      let(:data_array) { [3, 26, 1106, 0, 2, 3, 99] }

      it 'returns false and alters the pointer without changing the array' do
        result = intcode_processor.process_opcode_6
        expect(intcode_processor.opcode).to eq 6
        expect(result).to eq false
        expect(intcode_processor.data_array).to eq [3, 26, 1106, 0, 2, 3, 99]
        expect(intcode_processor.pointer).to eq 2
      end
    end

    context 'parameter_1 != 0' do
      let(:data_array) { [3, 26, 1106, 4, 5, 3, 99] }

      it 'returns false and alters the pointer without changing the array' do
        result = intcode_processor.process_opcode_6
        expect(intcode_processor.opcode).to eq 6
        expect(result).to eq false
        expect(intcode_processor.data_array).to eq [3, 26, 1106, 4, 5, 3, 99]
        expect(intcode_processor.pointer).to eq 5
      end
    end
  end

  describe '#process_opcode_7' do
    context 'parameter_1 < parameter_2 and parameter_mode_3 == 0' do
      let(:data_array) { [3, 26, 1107, 4, 5, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_7
        expect(intcode_processor.opcode).to eq 7
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 1107, 1, 5, 3, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_1 == parameter_2 and parameter_mode_3 == 0' do
      let(:data_array) { [3, 26, 1107, 3, 3, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_7
        expect(intcode_processor.opcode).to eq 7
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 1107, 0, 3, 3, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_1 < parameter_2 and parameter_mode_3 != 0' do
      let(:data_array) { [3, 26, 11107, 3, 4, 5, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_7
        expect(intcode_processor.opcode).to eq 7
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 11107, 3, 4, 1, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_1 == parameter_2 and parameter_mode_3 != 0' do
      let(:data_array) { [3, 26, 11107, 3, 3, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_7
        expect(intcode_processor.opcode).to eq 7
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 11107, 3, 3, 0, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end
  end

  describe '#process_opcode_8' do
    context 'parameter_1 < parameter_2 and parameter_mode_3 == 0' do
      let(:data_array) { [3, 26, 1108, 4, 5, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_8
        expect(intcode_processor.opcode).to eq 8
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 1108, 0, 5, 3, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_1 == parameter_2 and parameter_mode_3 == 0' do
      let(:data_array) { [3, 26, 1108, 3, 3, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_8
        expect(intcode_processor.opcode).to eq 8
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 1108, 1, 3, 3, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_1 < parameter_2 and parameter_mode_3 != 0' do
      let(:data_array) { [3, 26, 11108, 3, 4, 5, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_8
        expect(intcode_processor.opcode).to eq 8
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 11108, 3, 4, 0, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end

    context 'parameter_1 == parameter_2 and parameter_mode_3 != 0' do
      let(:data_array) { [3, 26, 11108, 3, 3, 3, 99] }

      it 'returns false and alters the pointer and array' do
        result = intcode_processor.process_opcode_8
        expect(intcode_processor.opcode).to eq 8
        expect(result).to be false
        expect(intcode_processor.data_array).to eq [3, 26, 11108, 3, 3, 1, 99]
        expect(intcode_processor.pointer).to eq 6
      end
    end
  end

  describe '#process_opcode_99' do
    let(:data_array) { [3, 26, 11108, 3, 3, 99, 0] }
    let(:pointer)    { 5 }

    it 'returns HALT and alters the pointer without changing the array' do
      result = intcode_processor.process_opcode_99
      expect(intcode_processor.opcode).to eq 99
      expect(result).to eq 'HALT'
      expect(intcode_processor.data_array).to eq [3, 26, 11108, 3, 3, 99, 0]
      expect(intcode_processor.pointer).to eq 6
    end
  end
end
