require_relative '../../day_7/thrust2.rb'

RSpec.describe Thrust2 do
  let(:file2)   { './day_7/data/test_data_2' }
  let(:thrust2) { Thrust2.new(file2) }
  let(:phase_settings) { [9, 8, 7, 6] }
  let(:data)    { thrust2.fresh_data(phase_settings) }

  describe '#initialize' do
    it 'initializes the data to an array of integers' do
      expect(data).to include (
        { data_array: [3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27,
            26, 27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5],
          inputs: [9, 8, 7, 6, 0],
          output: nil,
          pointer: 0 }
        )
    end
  end

  describe '#instruction_array' do
    it 'returns a hash indicating opcode and modes' do
      expect(thrust2.instruction_array(data, 0, 4)).to eq [3, 15, 3, 16]
    end
  end

  describe '#interpret' do
    it 'process the code to an opcode and parameters as a hash' do
      expect(thrust2.interpret(1002)).to include
        ({ opcode: 2, p1: 0, p2: 1, p3: 0 })
    end
  end

  describe '#phase_settings_array' do
    it 'turns a number into an array and returns the array or false' do
      expect(thrust2.phase_settings_array(1234, [0, 1, 2, 3, 4])).to eq (
        [0, 1, 2, 3, 4])
      expect(thrust2.phase_settings_array(64320, [0, 1, 2, 3, 4])).to be false
      expect(thrust2.phase_settings_array(13240, [0, 1, 2, 3, 4])).to eq (
        [1, 3, 2, 4, 0])
    end
  end

  describe '#optimize_loop' do
    it 'runs the program and returns the maximum signal' do
      expect(thrust2.optimize_loop).to eq 139629729
    end
  end
end
