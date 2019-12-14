require_relative '../../day_7/thrust.rb'

RSpec.describe Thrust do
  let(:file)   { './day_7/data/test_data' }
  let(:thrust)   { Thrust.new(file) }

  describe '#initialize' do
    it 'initializes the data to an array of integers' do
      expect(thrust.data_array).to eq [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16,
        15, 15, 4, 15, 99, 0, 0]
    end
  end

  describe '#phase_settings_array' do
    it 'turns a number into an array and returns the array or false' do
      expect(thrust.phase_settings_array(1234)).to eq [0, 1, 2, 3, 4]
      expect(thrust.phase_settings_array(64320)).to be false
      expect(thrust.phase_settings_array(13240)).to eq [1, 3, 2, 4, 0]
    end
  end

  describe '#optimize' do
    it 'runs the program and returns the maximum signal' do
      expect(thrust.optimize).to eq 43210
    end
  end
end
