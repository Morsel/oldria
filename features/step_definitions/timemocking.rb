When(/^the date and time is "([^\"]*)"$/) do |datetime|
  time_travel_to(datetime)
end

