Given /^the following coached status messages:$/ do |table|
  table.hashes.each do |row|
    if row['season']
      date_range = DateRange.find_by_name(row['season'])
      FactoryGirl.create(:coached_status_update, :date_range => date_range, :message => row['message'])
    else
      FactoryGirl.create(:coached_status_update, row)
    end
  end
end
