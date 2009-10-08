When /^I create a new media request with:$/ do |table|
  mrdata = table.rows_hash
  recipient_ids = []
  if mrdata['Recipients']
    mrdata['Recipients'].split(", ").each do |username|
      recipient_ids << User.find_by_username(username).id
    end
  end
  visit new_media_request_path(:recipient_ids => recipient_ids)
  fill_in 'media_request[message]', :with => mrdata["Message"]
  click_button :submit
end
