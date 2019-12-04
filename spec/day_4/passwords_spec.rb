require_relative '../../day_4/passwords.rb'

RSpec.describe Passwords do
  let(:input_range)   { '111110-111123' }
  let(:passwords)   { Passwords.new(input_range) }

  describe '#initialize' do
    it 'creates an instance of the range' do
      expect(passwords.range).to eq '111110-111123'
    end

    it 'sets the maximum possible password' do
      expect(passwords.max).to eq 111123
    end

    it 'sets the minimum possible password' do
      expect(passwords.min).to eq 111110
    end
  end

  describe '#check_within_range' do
    it 'returns false if the number is larger than the max' do
      expect(passwords.check_within_range(111124)).to be false
    end

    it 'returns false if the number is smaller than the min' do
      expect(passwords.check_within_range(111109)).to be false
    end

    it 'returns true if the number is within the range' do
      expect(passwords.check_within_range(111113)).to be true
    end
  end

  describe '#check_length' do
    it 'returns false if the number is more than 6 digits' do
      expect(passwords.check_length(1234567)).to be false
    end

    it 'returns false if the number is less than 6 digits' do
      expect(passwords.check_length(12345)).to be false
    end

    it 'returns true if the number is 6 digits long' do
      expect(passwords.check_length(123456)).to be true
    end
  end

  describe '#check_increasing' do
    it 'returns true if the subsequent digits increase' do
      expect(passwords.check_increasing(111123)).to be true
    end

    it 'returns false if the subsequent digits decrease' do
      expect(passwords.check_increasing(111121)).to be false
    end
  end

  describe '#check_double' do
    it 'returns true if adjacent digits are the same' do
      expect(passwords.check_double(136223)).to be true
      expect(passwords.check_double(136233)).to be true
      expect(passwords.check_double(336233)).to be true
    end

    it 'returns true if adjacent digits are not the same' do
      expect(passwords.check_double(765432)).to be false
    end
  end

  describe '#find_possible_pwds' do
    it 'returns the correct list of passwords' do
      expect(passwords.find_possible_pwds).to eq [111111, 111112, 111113,
        111114, 111115, 111116, 111117, 111118, 111119, 111122, 111123]
    end
  end

  describe '#number_of_passwords' do
    it 'returns the correct number of passwords' do
      expect(passwords.number_of_passwords).to eq 11
    end
  end
end
