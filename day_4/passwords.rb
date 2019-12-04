class Passwords
  attr_reader :range, :min, :max

  def initialize(range)
    @range = range
    @max = range.split('-').last.to_i
    @min = range.split('-').first.to_i
  end

  def number_of_passwords
    find_possible_pwds.size
  end

  def find_possible_pwds
    possible_pwds = []
    (min..max).each do |p|
      if check_within_range(p) && check_length(p) &&
         check_increasing(p) && check_double(p)
        possible_pwds << p
      end
    end
    possible_pwds
  end

  def check_within_range(num)
    num <= max && num >= min
  end

  def check_length(num)
    num.to_s.length == 6
  end

  def check_increasing(num)
    nums = num_arry(num)
    (nums.size - 1).times do |i|
      return false if nums[i] > nums[i+1]
    end
    true
  end

  def check_double(num)
    nums = num_arry(num)
    (nums.size - 1).times do |i|
      return true if nums[i] == nums[i+1]
    end
    false
  end

  def num_arry(num)
    num.to_s.split('').map { |e| e.to_i }
  end
end

# puts Passwords.new('353096-843212').number_of_passwords
#579
