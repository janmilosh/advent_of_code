require_relative '../../day_7/thrust.rb'

RSpec.describe Thrust do
  let(:file)    { './day_7/data/test_data' }
  let(:thrust)  { Thrust.new(file) }
  let(:file2)   { './day_7/data/test_data_2' }
  let(:thrust2) { Thrust.new(file2) }

  describe '#initialize' do
    it 'initializes the data to an array of integers' do
      expect(thrust.data_array).to eq [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16,
        15, 15, 4, 15, 99, 0, 0]
    end
  end

  describe '#instruction_array' do
    it 'returns a hash indicating opcode and modes' do
      expect(thrust.instruction_array(0, 4)).to eq [3, 15, 3, 16]
    end
  end

  describe '#interpret' do
    it 'process the code to an opcode and parameters as a hash' do
      expect(thrust.interpret(1002)).to include
        ({ opcode: 2, p1: 0, p2: 1, p3: 0 })
    end
  end

  describe '#phase_settings_array' do
    it 'turns a number into an array and returns the array or false' do
      expect(thrust.phase_settings_array(1234, [0, 1, 2, 3, 4])).to eq (
        [0, 1, 2, 3, 4])
      expect(thrust.phase_settings_array(64320, [0, 1, 2, 3, 4])).to be false
      expect(thrust.phase_settings_array(13240, [0, 1, 2, 3, 4])).to eq (
        [1, 3, 2, 4, 0])
    end
  end

  describe '#optimize' do
    it 'runs the program and returns the maximum signal' do
      expect(thrust.optimize).to eq 43210
    end
  end

  describe '#optimize_loop' do
    it 'runs the program and returns the maximum signal' do
      expect(thrust2.optimize_loop).to eq 139629729
    end
  end
end
