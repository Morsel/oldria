Given /^the following topics:$/ do |table|
  table.hashes.each do |row|
    Factory(:topic, :title => row['title'])
  end
end

Given /^the following chapters:$/ do |table|
  table.hashes.each do |row|
    topic = Factory(:topic, :title => row['topic'])
    Factory(:chapter, :title => row['title'], :topic => topic)
  end
end

Given /^the following questions:$/ do |table|
  table.hashes.each do |row|
    chapter = Chapter.find_by_title(row['chapter']) || Factory(:chapter, :title => row['chapter'])
    Factory(:profile_question, :title => row['title'], :chapters => [chapter])
  end
end

When /^I add a restaurant to my profile with:$/ do |table|
  visit '/profile/edit'

  within '.workexperience' do
    table.rows_hash.each do |field, value|

      if field == "Dates"
        dates = value.split(/ ?to ?/, 2)
        fill_in "Date started", :with => Date.parse(dates.first)
        fill_in "Date ended", :with => Date.parse(dates.last)
      else
        fill_in field, :with => value
      end
    end
  end

  click_button "Save"
end

Then /^I should have (\d+) restaurant on my profile$/ do |num|
  @current_user.profile.profile_restaurants.count.should == num.to_i
end
