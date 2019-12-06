require_relative '../../day_5/intcode2.rb'

RSpec.describe Intcode2 do
  let(:file)   { './day_5/data/test_data' }
  let(:intcode)   { Intcode2.new(file) }

  describe '#initialize' do
    it 'initializes the data to an array of integers' do
      expect(intcode.data_array).to eq [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
    end
  end

  describe '#instruction_array' do
    it 'returns a hash indicating opcode and modes' do
      expect(intcode.instruction_array(4)).to eq [1, 9, 10, 3]
    end
  end

  describe '#interpret' do
    it 'process the code to an opcode and parameters as a hash' do
      expect(intcode.interpret(1002)).to include
        ({ opcode: 2, p1: 0, p2: 1, p3: 0 })
    end
  end

end
