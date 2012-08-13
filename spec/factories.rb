# == Users ==
Factory.define :user do |f|
  f.sequence(:username) { |n| "foo#{n}" }
  f.sequence(:email)    { |n| "foo#{n}@example.com" }
  f.password 'secret'
  f.password_confirmation { |u| u.password }
  f.confirmed_at { 1.week.ago }
  f.first_name { |u| u.name.split(' ').first || "John" }
  f.last_name  { |u| u.name.split(' ').last  || "Doe" }
end

Factory.define :twitter_user, :parent => :user do |f|
  f.atoken  'fake'
  f.asecret 'fake'
end

Factory.define :facebook_user, :parent => :user do |f|
  f.facebook_id  1234567
  f.facebook_access_token 'foobar'
end

Factory.define :admin, :parent => :user do |f|
  f.username 'admin'
  f.first_name "Administrator"
  f.role 'admin'
end

Factory.define :published_user, :parent => :user do |f|
  f.visible '1'
  f.publish_profile true
  f.premium_account '1'
end

Factory.define :published_real_user_with_subscription, :parent => :published_user do |f|
  f.association :subscription
  f.last_request_at Time.now
end

Factory.define :media_user, :parent => :user do |f|
  f.publication "The Times"
  f.role 'media'
end

Factory.define :profile do |f|
  f.association :user
  f.hometown "Detroit"
  f.current_residence "NYC"
  f.cellnumber "123-456-7890"
  f.association :metropolitan_area
  f.association :james_beard_region
end

Factory.define :culinary_job do |f|
  f.association  :profile
  f.restaurant_name "Rico's Place"
  f.title        "Chef"
  f.city         "Atlanta"
  f.state        "GA"
  f.country      "United States"
  f.date_started 1.year.ago
  f.date_ended   2.months.ago
  f.chef_name    "Jorge Bergeson"
  f.cuisine      "Seafood"
end

Factory.define :nonculinary_job do |f|
  f.association  :profile
  f.company      "Johnson and Johnson"
  f.title        "COO"
  f.city         "Tucson"
  f.state        "AZ"
  f.country      "United States"
  f.date_started 3.years.ago
  f.date_ended   1.year.ago
  f.responsibilities    "Bossing people around"
  f.reason_for_leaving  "Had too much free time"
end

Factory.define :award do |f|
  f.association :profile
  f.name "Best Chef ever"
  f.year_won "2009"
  f.year_nominated "2008"
end

Factory.define :accolade do |f|
  f.accoladable { |a| a.association(:profile)}
  f.name "The Today Show"
  f.run_date 1.year.ago
  f.media_type "National television exposure"
end

Factory.define :school do |f|
  f.name         "Midwest International Culinary School"
  f.city         "Columbus"
  f.state        "OH"
  f.country      "United States"
end

Factory.define :nonculinary_school do |f|
  f.name         "Purdue"
  f.city         "West Lafayette"
  f.state        "IN"
  f.country      "United States"
end

Factory.define :enrollment do |f|
  f.association :school
  f.association :profile
  f.graduation_date 4.years.ago
end

Factory.define :competition do |f|
  f.association :profile
  f.name "International Champeenship"
  f.place "First!"
  f.year 2001
end

Factory.define :internship do |f|
  f.association :profile
  f.establishment "Restaurant B"
  f.supervisor "The Boss"
  f.start_date 1.year.ago
  f.end_date 10.months.ago
  f.comments "Some comments"
end

Factory.define :stage do |f|
  f.association :profile
  f.establishment "Restaurant B"
  f.expert "The Expert"
  f.start_date 1.year.ago
  f.end_date 10.months.ago
  f.comments "Some comments"
end

Factory.define :apprenticeship do |f|
  f.association :profile
  f.establishment "Restaurant Q"
  f.supervisor "The Chef"
  f.year 1989
end

Factory.define :nonculinary_enrollment do |f|
  f.association :nonculinary_school
  f.association :profile
  f.graduation_date 6.years.ago
end

Factory.define :invitation do |f|
  f.first_name "Jane"
  f.last_name "Doe"
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  f.restaurant_name "Name"
  f.association :restaurant_role
  f.subject_matters { [Factory(:subject_matter)] }
end

# == Restaurants ==
Factory.define :restaurant do |f|
  f.name    "Joe's Diner"
  f.street1 "123 S State St"
  f.city    "Chicago"
  f.state   "IL"
  f.zip     "60606"
  f.phone_number "3125555555"
  f.website "http://restaurant.example.com"
  f.description "This is a great restaurant with good Pizza offerings"
  f.management_company_name "Lettuce Entertain You"
  f.management_company_website "http://www.lettuce.com"
  f.twitter_handle "joeblow"
  f.facebook_page_url "http://www.facebook.com/joeblow"
  f.association :metropolitan_area
  f.hours "Open All Night"
  f.opening_date 1.year.ago
  f.association :media_contact, :factory => :user
  f.association :cuisine
  f.association :manager, :factory => :user
  f.is_activated true
end

Factory.define :photo do |f|
  f.sequence(:credit) { |n| "Sean Gingerbread #{n}" }
  f.sequence(:attachment_file_name) { |n| "somefile#{n}.jpg" }
  f.attachment_content_type "image/jpg"
  f.attachment_file_size 3000
  f.attachment_updated_at 2.days.ago
end

Factory.define :employment do |f|
  f.association :restaurant
  f.association :employee, :factory => :user
  f.primary false
end

Factory.define :default_employment do |f|
  f.association :employee, :factory => :user
  f.association :restaurant_role
end

Factory.define :assigned_employment, :parent => :employment do |f|
  f.subject_matters {|e| [e.association(:subject_matter)] }
  f.restaurant_role {|e|  e.association(:restaurant_role) }
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

Factory.define :event do |f|
  f.title "Summer Dinner"
  f.start_at Date.today.beginning_of_day
  f.end_at Date.today.end_of_day
  f.location "the bar"
  f.association :restaurant
  f.category "Promotion"
end

Factory.define :admin_event, :parent => "event" do |f|
  f.title "Summer Benefit"
  f.start_at Date.today.beginning_of_day
  f.end_at Date.today.end_of_day
  f.location "the restaurant"
  f.category "Charity"
end

Factory.define :topic do |f|
  f.sequence(:title) { |n| "Topic #{n}" }
  f.description "Interesting topic"
end

Factory.define :restaurant_topic do |f|
  f.sequence(:title) { |n| "Topic #{n}" }
  f.description "Interesting topic"
end

Factory.define :chapter do |f|
  f.sequence(:title) { |n| "Career #{n}" }
  f.association :topic
  f.description "Interesting chapter"
end

Factory.define :profile_question do |f|
  f.sequence(:title) { |n| "Question #{n}" }
  f.association :chapter
  f.question_roles { [Factory(:question_role), Factory(:question_role) ]}
end

Factory.define :question_role do |f|
  f.association :restaurant_role
end

Factory.define :profile_answer do |f|
  f.association :profile_question
  f.association :user
  f.sequence(:answer) { |n| "Answer #{n}!" }
end

Factory.define :restaurant_question do |f|
  f.sequence(:title) { |n| "Question #{n}" }
  f.association :chapter
  f.question_pages { [Factory(:question_page), Factory(:question_page) ]}
end

Factory.define :restaurant_answer do |f|
  f.association :restaurant_question
  f.association :restaurant
  f.answer "Yes!"
end

Factory.define :question_page do |f|
  f.association :restaurant_feature_page
end

# == Lookup Tables ==

Factory.define :cuisine do |f|
  f.name "Mexican"
end

Factory.define :restaurant_role do |f|
  f.name "Chef"
  f.category "Cuisine"
end

Factory.define :james_beard_region do |f|
  f.name "Midwest"
  f.description "IN IL OH"
end

Factory.define :metropolitan_area do |f|
  f.sequence(:name) { |n| "City #{n}" }
  f.state "Illinois"
end

Factory.define :subject_matter do |f|
  f.name "Beverages"
  f.general true
end

Factory.define :type_of_request, :parent => :subject_matter do |f|
  f.name "General Request"
  f.general false
end

Factory.define :page do |f|
  f.title   "Page Title"
  f.slug    {"page-title"}
  f.content {"This is the page content"}
end

Factory.define :soapbox_page do |f|
  f.title "Title"
  f.slug "title-tastic"
  f.content "Some content here is good"
end

Factory.define :direct_message do |f|
  f.association :receiver, :factory => :user
  f.association :sender, :factory => :user
  f.body  "This is a message"
end

Factory.define :specialty do |f|
  f.name "Fish"
end

# == Media Requests ==
Factory.define :media_request do |f|
  f.association :sender, :factory => :media_user
  f.association :subject_matter, :factory => :type_of_request
  f.message "This is a media request message"
  f.due_date 2.days.from_now
  f.association :employment_search
end

Factory.define :sent_media_request, :parent => :media_request do |f|
  f.status 'approved'
end

Factory.define :pending_media_request, :parent => :media_request do |f|
  f.association :employment_search
end

Factory.define :media_request_discussion do |f|
  f.association :media_request
  f.association :restaurant
  f.comments_count 0
end

Factory.define :solo_media_discussion do |f|
  f.association :media_request
  f.association :employment
  f.comments_count 0
end

# == Feeds ==
Factory.define :feed do |f|
  f.title "Example Blog RSS"
  f.url "http://www.example.com"
  f.feed_url "http://feeds.neotericdesign.com/neotericdesign"
  f.etag "fake_etag_avkl"
  f.no_entries true
end

Factory.define :feed_category do |f|
  f.name "Food Blogs"
end

Factory.define :feed_entry do |f|
  f.sequence(:guid) { |n| "guid_#{n}" }
  f.title   "Pork is best with salmon"
  f.summary "Although pork is uncommon, lorem ipsum."
  f.url     { "http://www.example.com/posts/2" }
  f.published_at { 2.days.ago }
  f.feed    {|e| e.association(:feed) }
end

Factory.define :feed_subscription do |f|
  f.association :user
  f.association :feed
end

Factory.define :discussion do |f|
  f.title "My Discussion"
  f.body  "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
end

Factory.define :comment do |f|
  f.comment "This is my comment"
  f.user    {|c| c.association :user }
end

Factory.define :discussion_comment, :parent => :comment do |f|
  f.commentable {|c| c.association :discussion }
  f.commentable_type { "Discussion" }
end

# == Admin Messages ==
Factory.define :admin_message, :class => Admin::Message do |f|
  f.message "This is an admin message"
  f.scheduled_at { 1.day.ago }
end

Factory.define :qotd, :class => Admin::Qotd do |f|
  f.message "Today's question is: ..."
  f.scheduled_at { 1.day.ago }
end

Factory.define :announcement, :class => Admin::Announcement do |f|
  f.message "We're all taking tomorrow off."
  f.scheduled_at { 1.day.ago }
end

Factory.define :pr_tip, :class => Admin::PrTip do |f|
  f.message "Go forth and be awesome!"
  f.scheduled_at { 1.day.ago }
end

Factory.define :holiday_reminder, :class => Admin::HolidayReminder do |f|
  f.message "This is a holiday reminder"
  f.association :holiday
end

Factory.define :admin_conversation, :class => Admin::Conversation do |f|
  f.association :recipient, :factory => :user
  f.association :admin_message, :factory => :announcement
end

Factory.define :admin_discussion do |f|
  f.discussionable {|d| d.association :trend_question }
  f.discussionable_type { "TrendQuestion" }
  f.restaurant {|d| d.association :restaurant }
end

Factory.define :solo_discussion do |f|
  f.association :employment
  f.association :trend_question
end

# == Holidays ==
Factory.define :holiday do |f|
  f.name "Valentine's Day"
  f.date Date.today
  f.association :employment_search
end

Factory.define :holiday_conversation do |f|
  f.association :recipient, :factory => :employment
  f.association :holiday
end

Factory.define :holiday_discussion do |f|
  f.association :restaurant
  f.association :holiday
  f.accepted false
end

Factory.define :holiday_discussion_reminder do |f|
  f.association :holiday_discussion
  f.association :holiday_reminder
end

# == Trend Questions and other content ==
Factory.define :trend_question do |f|
  f.subject "What is the haps?"
  f.body    "Boo-ya"
  f.scheduled_at { 2.days.ago }
  f.association :employment_search
end

Factory.define :employment_search do |f|
  f.conditions "--- \n:restaurant_name_like: neo\n"
end

Factory.define :content_request do |f|
  f.subject "RFP"
  f.body    "Please send your proposal"
  f.scheduled_at { 1.day.ago }
  f.association :employment_search
end

Factory.define :soapbox_entry do |f|
  f.association :featured_item, :factory => :qotd
  f.published_at Time.now
end

Factory.define :soapbox_slide do |f|
  f.title "Title"
  f.excerpt "Some text here"
  f.link "http://linky.com"
end

Factory.define :sf_slide do |f|
  f.title "Title"
  f.excerpt "Some text here"
  f.link "http://linky.com"
end

Factory.define :a_la_minute_question do |f|
  f.question "Our current inspiration is"
  f.kind 'restaurant'
end

Factory.define :a_la_minute_answer do |f|
  f.answer "Nothing"
  f.association :responder, :factory => :restaurant
  f.association :a_la_minute_question
end

Factory.define :subscription do |f|
  f.kind "User Premium"
  f.start_date Date.today
  f.braintree_id "abcd"
end

Factory.define :restaurant_feature_page do |f|
  f.sequence(:name) { |n| "Page #{n}" }
end

Factory.define :restaurant_feature do |f|
  f.sequence(:value) { |n| "Feature#{n}" }
end

Factory.define :restaurant_feature_item do |f|
  f.association :restaurant_feature
  f.association :restaurant
end

Factory.define :pdf_remote_attachment do |f|
  f.sequence(:attachment_file_name) { |n| "menu#{n}.pdf" }
  f.attachment_content_type "application/pdf"
  f.attachment_file_size 3000
  f.attachment_updated_at 2.days.ago
end

Factory.define :menu do |f|
  f.sequence(:name) { |n| "Menu #{n}"}
  f.change_frequency "Monthly"
  f.association :pdf_remote_attachment
  f.association :restaurant
end

Factory.define :promotion do |f|
  f.association :promotion_type
  f.details "Special event"
  f.start_date Date.today
  f.association :restaurant
  f.headline "HEADLINE"
end

Factory.define :promotion_type do |f|
  f.name "Event"
end

Factory.define :otm_keyword do |f|
  f.name "pasta"
  f.category "Grain"
end

Factory.define :menu_item do |f|
  f.name "BBQ Tofu"
  f.description "Yum yum"
  f.association :restaurant
  f.otm_keywords { [Factory(:otm_keyword)] }
end

Factory.define :testimonial do |f|
  f.quote "This is great"
  f.person "Chef Tastic - New Place"
  f.page "RIA HQ"
  f.sequence(:photo_file_name) { |n| "image#{n}.jpg" }
  f.photo_content_type "image/jpg"
  f.photo_file_size 5000
  f.photo_updated_at 1.day.ago
end

Factory.define :newsletter_subscriber do |f|
  f.email "myemail@maily.com"
  f.password "secret"
  f.password_confirmation "secret"
end
