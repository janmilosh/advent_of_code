require_relative '../../day_2/intcode.rb'

RSpec.describe Intcode do
  let(:file)   { './day_2/data/test_data' }
  let(:data)   { Intcode.new(file) }
  let(:file_2) {'./day_2/data/test_data_2'}
  let(:data_2) { Intcode.new(file_2)}

  describe '#data_array' do
    it 'converts data to an array of integers' do
      expect(data.data_array).to eq [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
    end
  end

  describe '#process' do
    it 'returns the final array' do
      expect(data.process).to eq [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
    end
  end

  describe '#final_code' do
    it 'returns the final intcode' do
      expect(data.final_code).to eq 3500
    end
  end

  describe '#find_noun_and_verb' do
    it 'returns the combined noun and verb' do
      expect(data_2.find_noun_and_verb(3500)).to eq 910
    end
  end
end
