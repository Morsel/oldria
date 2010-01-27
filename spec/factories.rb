Factory.define :user do |f|
  f.sequence(:username) { |n| "foo#{n}" }
  f.sequence(:email)    { |n| "foo#{n}@example.com" }
  f.password 'foobar'
  f.password_confirmation { |u| u.password }
  f.confirmed_at { Time.now }
  f.first_name { |u| u.name.split(' ').first || "John" }
  f.last_name  { |u| u.name.split(' ').last  || "Doe" }
end

Factory.define :twitter_user, :parent => :user do |f|
  f.atoken  'fake'
  f.asecret 'fake'
end

Factory.define :admin, :parent => :user do |f|
  f.username 'admin'
  f.first_name "Administrator"
  f.after_create { |user| user.has_role! :admin }
end

Factory.define :media_user, :parent => :user do |f|
  f.publication "The Times"
  f.after_create { |user| user.has_role! :media }
end


Factory.define :restaurant do |f|
  f.name    "Joe's Diner"
  f.street1 "123 S State St"
  f.city    "Chicago"
  f.state   "IL"
  f.zip     "60606"
end

Factory.define :managed_restaurant, :parent => :restaurant do |f|
  f.association :manager, :factory => :user
  f.association :cuisine
  f.association :metropolitan_area
end

Factory.define :status do |f|
  f.association :user
  f.message     "I just ate a cheeseburger"
  f.created_at { 2.days.ago }
end

Factory.define :date_range do |f|
  f.name "Holiday"
  f.start_date Date.parse('2009-01-01')
  f.end_date   Date.parse('2009-12-31')
end

Factory.define :coached_status_update do |f|
  f.message "Where was the last place you ate?"
  f.association :date_range
end

Factory.define :account_type do |f|
  f.name "Concierge"
end

Factory.define :page do |f|
  f.title   "Page Title"
  f.slug    {"page-title"}
  f.content {"This is the page content"}
end

Factory.define :direct_message do |f|
  f.association :receiver, :factory => :user
  f.association :sender, :factory => :user
  f.title "Hello there"
  f.body  "This is a message"
end

Factory.define :media_request_conversation do |f|
  f.association :media_request
  f.association :recipient, :factory => :employment
end

Factory.define :media_request do |f|
  f.association :sender, :factory => :media_user
  f.message "This is a media request message"
  f.due_date 2.days.from_now
  f.status 'draft'
  f.recipients {|mr| [mr.association(:employment)]}
end

Factory.define :sent_media_request, :parent => :media_request do |f|
  f.status 'approved'
  f.after_build {|r| Factory(:media_request_conversation, :media_request => r)}
end

Factory.define :pending_media_request, :parent => :media_request do |f|
  f.status 'pending'
  f.after_build {|r| Factory(:media_request_conversation, :media_request => r)}
end


Factory.define :media_request_conversation do |f|
  f.association :media_request
  f.association :recipient, :factory => :employment
  f.comments_count 0
end

Factory.define :cuisine do |f|
  f.name "Mexican"
end

Factory.define :restaurant_role do |f|
  f.name "Chef"
end

Factory.define :james_beard_region do |f|
  f.name "Midwest"
  f.description "IN IL OH"
end

Factory.define :metropolitan_area do |f|
  f.name "Chicago IL"
end

Factory.define :subject_matter do |f|
  f.name "Beverages"
end

Factory.define :employment do |f|
  f.association :restaurant
  f.association :employee, :factory => :user
end

Factory.define :assigned_employment, :parent => :employment do |f|
  f.subject_matters {|e| [e.association(:subject_matter)] }
  f.restaurant_role {|e|  e.association(:restaurant_role) }
end

Factory.define :feed do |f|
  f.title "Example Blog RSS"
  f.url "http://www.example.com"
  f.feed_url "http://feeds.neotericdesign.com/neotericdesign"
  f.etag "aj39ukavkl"
end

Factory.define :discussion do |f|
  f.title "My Discussion"
  f.body  "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
end
