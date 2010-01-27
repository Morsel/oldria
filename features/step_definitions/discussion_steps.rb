Given(/^there are no discussions(?: in the system)?$/) do
  Discussion.destroy_all
end

Then(/^there should be (no|\d+) discussion(?: in the system)?$/) do |num|
  num = 0 if num == 'no'
  Discussion.count.should == num.to_i
end

