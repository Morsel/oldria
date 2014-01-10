# == Users ==
#require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.sequence(:username) { |n| "foo#{n}" }
    f.sequence(:email)    { |n| "foo#{n}@example.com" }
    f.password 'secret'
    f.password_confirmation { |u| u.password }
    f.confirmed_at { 1.week.ago }
    f.first_name { |u| u.name.split(' ').first || "John" }
    f.last_name  { |u| u.name.split(' ').last  || "Doe" }
  end

 
  factory :twitter_user, :parent => :user do |f|
    f.atoken  'fake'
    f.asecret 'fake'
  end

  
  factory :facebook_user, :parent => :user do |f|
    f.facebook_id  1234567
    f.facebook_access_token 'foobar'
  end

  
  factory :admin, :parent => :user do |f|
    f.username 'admin'
    f.first_name "Administrator"
    f.role 'admin'
  end

  
  factory :published_user, :parent => :user do |f|
    f.visible '1'
    f.publish_profile true
    f.premium_account '1'
  end

 
  factory :published_real_user_with_subscription, :parent => :published_user do |f|
    f.association :subscription
    f.last_request_at Time.now
  end

 
 factory :media_user, :parent => :user do |f|
  f.publication "The Times"
  f.role 'media'
  end

 
 factory :profile do |f|
  f.association :user
  f.hometown "Detroit"
  f.current_residence "NYC"
  f.cellnumber "123-456-7890"
  f.association :metropolitan_area
  f.association :james_beard_region
  f.job_start Time.now
  end

 
 factory :culinary_job do |f|
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

 
 factory :nonculinary_job do |f|
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

 
 factory :award do |f|
  f.association :profile
  f.name "Best Chef ever"
  f.year_won "2009"
  f.year_nominated "2008"
  end

 
 factory :accolade do |f|
  f.accoladable { |a| a.association(:profile)}
  f.name "The Today Show"
  f.run_date 1.year.ago
  f.media_type "National television exposure"
  end

 
 factory :school do |f|
  f.name         "Midwest International Culinary School"
  f.city         "Columbus"
  f.state        "OH"
  f.country      "United States"
  end

 
 factory :nonculinary_school do |f|
  f.name         "Purdue"
  f.city         "West Lafayette"
  f.state        "IN"
  f.country      "United States"
  end

 
 factory :enrollment do |f|
  f.association :school
  f.association :profile
  f.graduation_date 4.years.ago
  end

 
 factory :competition do |f|
  f.association :profile
  f.name "International Champeenship"
  f.place "First!"
  f.year 2001
  end

 
 factory :internship do |f|
  f.association :profile
  f.establishment "Restaurant B"
  f.supervisor "The Boss"
  f.start_date 1.year.ago
  f.end_date 10.months.ago
  f.comments "Some comments"
  end

 
 factory :stage do |f|
  f.association :profile
  f.establishment "Restaurant B"
  f.expert "The Expert"
  f.start_date 1.year.ago
  f.end_date 10.months.ago
  f.comments "Some comments"
  end

 
 factory :apprenticeship do |f|
  f.association :profile
  f.establishment "Restaurant Q"
  f.supervisor "The Chef"
  f.year 1989
  f.start_date 1.year.ago
  f.end_date 10.months.ago
 end

 
 factory :nonculinary_enrollment do |f|
  f.association :nonculinary_school
  f.association :profile
  f.graduation_date 6.years.ago
  end

 
 factory :invitation do |f|
  f.first_name "Jane"
  f.last_name "Doe"
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  f.restaurant_name "Name"
  f.association :restaurant_role
  f.subject_matters { [FactoryGirl.build(:subject_matter)] }
  end

# == Restaurants ==
 
 factory :restaurant do |f|
  f.sequence(:name){ |n| "Restaurant #{n}" }    
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
  f.association :james_beard_region
  f.hours "Open All Night"
  f.opening_date 1.year.ago
  f.association :media_contact, factory: :user
  f.association :cuisine
  f.association :manager, factory: :user
  f.is_activated true
 end

 
 factory :photo do |f|
  f.sequence(:credit) { |n| "Sean Gingerbread #{n}" }
  f.sequence(:attachment_file_name) { |n| "somefile#{n}.jpg" }
  f.attachment_content_type "image/jpg"
  f.attachment_file_size 3000
  f.attachment_updated_at 2.days.ago
  end

 
 factory :employment do |f|
  f.association :restaurant
  f.association :employee, factory: :user
  f.primary false
 end

 
 factory :default_employment do |f|
  f.association :employee, factory: :user
  f.association :restaurant_role
  end

 
 factory :assigned_employment, :parent => :employment do |f|
  f.subject_matters {|e| [e.association(:subject_matter)] }
  f.restaurant_role {|e|  e.association(:restaurant_role) }
  end

 
 factory :status do |f|
  f.association :user
  f.message     "I just ate a cheeseburger"
  f.created_at { 2.days.ago }
  end

 
 factory :date_range do |f|
  f.name "Holiday"
  f.start_date Date.parse('2009-01-01')
  f.end_date   Date.parse('2009-12-31')
  end

 
 factory :coached_status_update do |f|
  f.message "Where was the last place you ate?"
  f.association :date_range
  end

 
 factory :event do |f|
  f.title "Summer Dinner"
  f.start_at Date.today.beginning_of_day
  f.end_at Date.today.end_of_day
  f.location "the bar"
  f.association :restaurant
  f.category "Promotion"
  end

 
 factory :admin_event, :parent => "event" do |f|
  f.title "Summer Benefit"
  f.start_at Date.today.beginning_of_day
  f.end_at Date.today.end_of_day
  f.location "the restaurant"
  f.category "Charity"
  end

 
 factory :topic do |f|
  f.sequence(:title) { |n| "Topic #{n}" }
  f.description "Interesting topic"
  end

 
 factory :restaurant_topic do |f|
  f.sequence(:title) { |n| "Topic #{n}" }
  f.description "Interesting topic"
  end

 
 factory :chapter do |f|
  f.sequence(:title) { |n| "Career #{n}" }
  f.association :topic
  f.description "Interesting chapter"
  end

 
 factory :profile_question do |f|
  f.sequence(:title) { |n| "Question #{n}" }
  f.association :chapter
  f.question_roles { [FactoryGirl.build(:question_role), FactoryGirl.build(:question_role) ]}
  end

 
 factory :question_role do |f|
  f.association :restaurant_role
  end

 
 factory :profile_answer do |f|
  f.association :profile_question
  f.association :user
  f.sequence(:answer) { |n| "Answer #{n}!" }
  end

 
 factory :restaurant_question do |f|
  f.sequence(:title) { |n| "Question #{n}" }
  f.association :chapter
  f.question_pages { [FactoryGirl.build(:question_page), FactoryGirl.build(:question_page) ]}
  end

 
 factory :restaurant_answer do |f|
  f.association :restaurant_question
  f.association :restaurant
  f.answer "Yes!"
  end

 
 factory :question_page do |f|
  f.association :restaurant_feature_page
  end

# == Lookup Tables ==

 
 factory :cuisine do |f|
  f.name "Mexican"
  end

 
 factory :restaurant_role do |f|
  f.name "Chef"
  f.category "Cuisine"
  end

 
 factory :james_beard_region do |f|
  f.name "Midwest"
  f.description "IN IL OH"
  end

 
 factory :metropolitan_area do |f|
  f.sequence(:name) { |n| "City #{n}" }
  f.state "Illinois"
  end

 
 factory :subject_matter do |f|
  f.name "Beverages"
  f.general true
  end

 
 factory :type_of_request, :parent => :subject_matter do |f|
  f.name "General Request"
  f.general false
  end

 
 factory :page do |f|
  f.title   "Page Title"
  f.slug    {"page-title"}
  f.content {"This is the page content"}
  end

 
 factory :soapbox_page do |f|
  f.title "Title"
  f.slug "title-tastic"
  f.content "Some content here is good"
  end

 
 factory :direct_message do |f|
  f.association :receiver, factory:  :user
  f.association :sender, factory:  :user
  f.body  "This is a message"
  end

 
 factory :specialty do |f|
  f.name "Fish"
  end

# == Media Requests ==
 
 factory :media_request do |f|
  f.association :sender, factory:  :media_user
  f.association :subject_matter, factory:  :type_of_request
  f.message "This is a media request message"
  f.due_date 2.days.from_now
  f.association :employment_search
  end

 
 factory :sent_media_request, :parent => :media_request do |f|
  f.status 'approved'
  end

 
 factory :pending_media_request, :parent => :media_request do |f|
  f.association :employment_search
  end

 
 factory :media_request_discussion do |f|
  f.association :media_request
  f.association :restaurant
  f.comments_count 0
  end

 
 factory :solo_media_discussion do |f|
  f.association :media_request
  f.association :employment
  f.comments_count 0
  end

# == Feeds ==
 
 factory :feed do |f|
  f.title "Example Blog RSS"
  f.url "http://www.example.com"
  f.feed_url "http://feeds.neotericdesign.com/neotericdesign"
  f.etag "fake_etag_avkl"
  f.no_entries true
  end

 
 factory :feed_category do |f|
  f.name "Food Blogs"
  end

 
 factory :feed_entry do |f|
  f.sequence(:guid) { |n| "guid_#{n}" }
  f.title   "Pork is best with salmon"
  f.summary "Although pork is uncommon, lorem ipsum."
  f.url     { "http://www.example.com/posts/2" }
  f.published_at { 2.days.ago }
  f.feed    {|e| e.association(:feed) }
  end

 
 factory :feed_subscription do |f|
  f.association :user
  f.association :feed
  end

 
 factory :discussion do |f|
  f.title "My Discussion"
  f.body  "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
  end

 
 factory :comment do |f|
  f.comment "This is my comment"
  f.user    {|c| c.association :user }
  end

 
 factory :discussion_comment, :parent => :comment do |f|
  f.commentable {|c| c.association :discussion }
  f.commentable_type { "Discussion" }
  end

# == Admin Messages ==
 
 factory :admin_message, :class => Admin::Message do |f|
  f.message "This is an admin message"
  f.scheduled_at { 1.day.ago }
  end

 
 factory :qotd, :class => Admin::Qotd do |f|
  f.message "Today's question is: ..."
  f.scheduled_at { 1.day.ago }
  end

 
 factory :announcement, :class => Admin::Announcement do |f|
  f.message "We're all taking tomorrow off."
  f.scheduled_at { 1.day.ago }
  end

 
 factory :pr_tip, :class => Admin::PrTip do |f|
  f.message "Go forth and be awesome!"
  f.scheduled_at { 1.day.ago }
  end

 
 factory :holiday_reminder, class: Admin::HolidayReminder do |f|
  f.message "This is a holiday reminder"
  f.association :holiday
  end

 
 factory :admin_conversation, :class => Admin::Conversation do |f|
  f.association :recipient, factory:  :user
  f.association :admin_message, factory:  :announcement
  end

 
 factory :admin_discussion do |f|
  f.discussionable {|d| d.association :trend_question }
  f.discussionable_type { "TrendQuestion" }
  f.restaurant {|d| d.association :restaurant }
  end

 
 factory :solo_discussion do |f|
  f.association :employment
  f.association :trend_question
  end

# == Holidays ==
 
 factory :holiday do |f|
  f.name "Valentine's Day"
  f.date Date.today
  f.association :employment_search
  end

 
 factory :holiday_conversation do |f|
  f.association :recipient, factory:  :employment
  f.association :holiday
  end

 
 factory :holiday_discussion do |f|
  f.association :restaurant
  f.association :holiday
  f.accepted false
  end

 
 factory :holiday_discussion_reminder do |f|
  f.association :holiday_discussion
  f.association :holiday_reminder
  end

# == Trend Questions and other content ==
 
 factory :trend_question do |f|
  f.subject "What is the haps?"
  f.body    "Boo-ya"
  f.scheduled_at { 2.days.ago }
  f.association :employment_search
  end

 #CIS
 #http://stackoverflow.com/questions/12959036/how-to-use-factorygirl-with-a-model-that-takes-a-hash-in-initialize-method
 #http://stackoverflow.com/questions/10032760/how-to-define-an-array-hash-in-factory-girl
 # Factory.define :employment_search do |f|
 #  f.conditions "--- \n:restaurant_name_like: neo\n"
 # end
 factory :employment_search do
  conditions {{
      "restaurant_name_like" => "neo"
    }}
  initialize_with  { new(attributes) }
 end

 
 factory :content_request do |f|
  f.subject "RFP"
  f.body    "Please send your proposal"
  f.scheduled_at { 1.day.ago }
  f.association :employment_search
  end

 
 factory :soapbox_entry do |f|
  f.association :featured_item, factory:  :qotd
  f.published_at Time.now
  end

 
 factory :soapbox_slide do |f|
  f.title "Title"
  f.excerpt "Some text here"
  f.link "http://linky.com"
  end

 
 factory :sf_slide do |f|
  f.title "Title"
  f.excerpt "Some text here"
  f.link "http://linky.com"
  end

 
 factory :a_la_minute_question do |f|
  f.question "Our current inspiration is"
  f.kind 'restaurant'
  end

 
 factory :a_la_minute_answer do |f|
  f.answer "Nothing"
  f.association :responder, factory:  :restaurant
  f.association :a_la_minute_question
  end

 
 factory :subscription do |f|
  f.kind "User Premium"
  f.start_date Date.today
  f.braintree_id "abcd"
  end

 
 factory :restaurant_feature_page do |f|
  f.sequence(:name) { |n| "Page #{n}" }
  end

 
 factory :restaurant_feature do |f|
  f.sequence(:value) { |n| "Feature#{n}" }
  end

 
 factory :restaurant_feature_item do |f|
  f.association :restaurant_feature
  f.association :restaurant
  end

 
 factory :pdf_remote_attachment do |f|
  f.sequence(:attachment_file_name) { |n| "menu#{n}.pdf" }
  f.attachment_content_type "application/pdf"
  f.attachment_file_size 3000
  f.attachment_updated_at 2.days.ago
  end

 
 factory :menu do |f|
  f.sequence(:name) { |n| "Menu #{n}"}
  f.change_frequency "Monthly"
  f.association :pdf_remote_attachment
  f.association :restaurant
  end

 
 factory :promotion do |f|
  f.association :promotion_type
  f.details "Special event"
  f.start_date Date.today
  f.association :restaurant
  f.headline "HEADLINE"
  end

 
 factory :promotion_type do |f|
  f.name "Event"
  end

 
 factory :otm_keyword do |f|
  f.name "pasta"
  f.category "Grain"
  end

 
 factory :menu_item do |f|
  f.name "BBQ Tofu"
  f.description "Yum yum"
  f.association :restaurant
  f.association :photo
  f.otm_keywords { [FactoryGirl.build(:otm_keyword)] }
  end

 factory :testimonial do |f|
  f.quote "This is great"
  f.person "Chef Tastic - New Place"
  f.page "RIA HQ"
  f.sequence(:photo_file_name) { |n| "image#{n}.jpg" }
  f.photo_content_type "image/jpg"
  f.photo_file_size 5000
  f.photo_updated_at 1.day.ago
 end

 factory :newsletter_subscriber do |f|
  f.email "myemail@maily.com"
  f.password "secret"
  f.password_confirmation "secret"
  end

 factory :visitor_email_setting do |f|
  f.restaurant_id 182   
  f.is_approved 0
  f.email_frequency "Daily"
  f.email_frequency_day "2013-05-02 06"
  f.last_email_at Time.now
  end

 factory :user_visitor_email_setting do |f|
  f.email_frequency "Daily"
  f.next_email_at "2013-05-02 06"
  f.last_email_at Time.now
  f.association :user
  end

 factory :user_profile_subscriber do |f|
  f.profile_subscriber_id 178   
  f.user_id   178
  f.association :user_profile_subscriber
 end  

 factory :social_post do |f|
  f.source_type "MenuItem"   
  f.source_id   "377"
  f. job_id   "36248"
  f.type   "FacebookPost"
  f.content   "test"
  f.post_at "2012-12-10 19:36:00"
  
 end  

 factory :trace_search do |f|
  f.searchable_id "685"   
  f.searchable_type   "User"
  f.count      "1"
  f.  term_name   "Adam Altnether"
  f.association :user
 end  

 factory :spoonfeed_trace_searche do |f|  
  f.searchable_id "685"   
  f.searchable_type   "User"
  f. user_id   "178"
  f.  term_name   "Adam Altnether"
  f.association :user
 end 

  factory :trace_keyword do |f|  
   # f.keywordable_id   "25"   
   # f.keywordable_type   "RestaurantFeature"
   f.count   "1"
   f.association :keywordable
   f.association :user
  end   

  factory :invalid_trace_keyword, parent: :trace_keyword do |f|
    f.keywordable_id nil
    f.keywordable_type nil
    f.user_id nil
    f.count   nil

  end

  factory :soapbox_trace_keyword do |f|  
   f.keywordable_id   "25"   
   f.keywordable_type   "RestaurantFeature"
   f.title   "Big Jones"
   f.association :keywordable
   f.association :restaurant
  end   

  factory :invalid_soapbox_trace_keyword, parent: :soapbox_trace_keyword do |f|  
   f.keywordable_id   nil 
   f.keywordable_type   nil
   f.restaurant_id   nil
   f.title   nil
  end   

  factory :spoonfeed_trace_Searche do |f|  
   f.searchable_id   "451"   
   f.searchable_type   "User"
   f.term_name "Jerald Armstrong"
   f.count   "1"
   f.association :user
  end   

  factory :tasting_menu do |f|  
   f.name   "Seven course degustation"   
   f.price   "75"
   f.wine_supplement_price   "30"
   f.restaurant_fact_sheet_id "5"
  end   

  factory :social_update do |f|  
   f.post_data   "Squash blossom | chorizo and corn http://t.co/FQ6K..."   
   f.link   "http://twitter.com/EllenMalloy/status/236252974706..."
   f.post_created_at   "2012-08-17 00:07:53 "
   f.source   "Twitter"
   f.title   "test"
   f.post_id   "236252974706458624"
   f.association :restaurant
  end 

  factory :seating_area do |f|  
   f.name   "Bar "   
   f.occupancy "50"
   f.restaurant_fact_sheet_id "14"
  end 

  factory :restaurant_employee_request do |f|  
   f.restaurant_id   "241"   
   #f. employee_id    {Faker::Number.number(2)}
   f.association :employee , factory: :user
   f.association :restaurant
  end 

  factory :regional_writer do |f|  
   f.user_id   "2626"   
   f.james_beard_region_id  "1"
   f.association :user
   f.association :james_beard_region
  end 

  factory :push_notification_user do |f|  
   f.device_tocken   "2626"   
   f.uniq_device_key  "1"
   f.association :user
  end 

  factory :profile_out_of_date do |f|  
   f.user_id   "178"   
   f.restaurant_id  "22"
   f.count :"1"
  end 

  factory :otm_keyword_notification do |f|  
   f.name   "test"   
  end 

  factory :newsletter_setting do |f|  
   f.introduction   "Indrto dunc"   
   f.subject   "This is my subject"   
  end 

  factory :newsfeed_writer do |f|  
   f.name   "National Writer"   
  # f.association :user
   # f.association :metropolitan_areas_writers
   # f.association :regional_writers
  end 

  factory :newsfeed_promotion_type do |f|  
   f.association :user
   f.association :metropolitan_areas_writers
   f.association :regional_writers
  end 

  factory :media_newsletter_setting do |f|  
   f.association :user
   f.opt_out   "1"   
  end 

  factory :mediafeed_slide do |f|  
   f.image_file_name "SpoonfeedHQ_placeholder_Kessler_35449.jpg"
   f.image_content_type   "image/jpeg"  
   f.image_file_size "112611"
   f.image_updated_at   "2010-11-11 00:39:35" 
   f.title "Speak for Yourself"
   f.excerpt   "We've built a platform so you can rise up above th..."  
   f.link "http://spoonfeed.restaurantintelligenceagency.com/.."
   f.position "1"
   f.photo_credit "Photo Credit: Grant Kessler"
   f.type "SfSlide"
  end 

  factory :mediafeed_page do |f|  
   f.title "Contact"
   f.slug   "contact"  
   f.content "<h3><strong>Wouldn&#39;t it be nice if every websi..."
  end 

  factory :meal do |f|  
   f.name "Brunch"
   f.day   "sunday"  
   f.open_at_hours "9"
   f.open_at_minutes "00"
   f.open_at_am_pm   "am"  
   f.closed_at_hours "3"
   f.closed_at_minutes "00"
   f.closed_at_am_pm   "pm"  
   f.restaurant_fact_sheet_id "5"
  end 

  factory :invited_employee do |f|  
   f.first_name "shrivatstav"
   f.last_name   "shrivatstav"  
   f.email "anand.shrivastava@cisinlabs.com"
  end 

  factory :image do |f|  
   f.association :attachable
   f.credit "   Masa Azul"
   f.position   "16"  
   f.name "Sopa de Fideo"
  end 

  factory :hq_slide do |f|  
   f.image_file_name "SpoonfeedHQ_placeholder_Kessler_35449.jpg"
   f.image_content_type "image/jpeg"
   f.image_file_size   "112611"  
   f.image_updated_at "2010-11-11 00:39:35"
   f.title "Speak for Yourself"
   f.excerpt " We've built a platform so you can rise up above th..."
   f.link   "http://spoonfeed.restaurantintelligenceagency.com/..."  
   f.position "1"
   f.photo_credit "Photo Credit: Grant Kessler"
   f.type "SfSlide"
  end 

  factory :featured_profile do |f|  
   f. feature_id  "209"
   f. feature_type   "User"
   f. start_date  "2013-01-01 12:02:00"
   f. spotlight_on "1"
   #f.association :feature
  end 


  factory :facebook_post do |f|  
   f. job_id  "45605"
   f. type "TwitterPost"
   f. content "Thisis nishsnt"
   f.post_at "  2013-09-18 11:54:00  "
   #f.association :source
  end 


  factory :digest_writer do |f|  
   f. name  "National Writer"
  end 

  factory :metropolitan_areas_writer do |f|  
   f.metropolitan_area_id "2"
   f. newsletter_subscriber_id  "1"
   f.association :area_writer
   f.association :user
   f.association :metropolitan_area
  end


  factory :media_newsletter_subscription do |f|  
   f.association :restaurant
   f.association :media_newsletter_subscriber


  end 

  factory :user_restaurant_visitor do |f|  
   f.association :restaurant
   f.association :user
  end 

  factory :cookbook do |f|  
   f.title  "The Art of Aureole"
   f.publisher "10 Speed Press"
   f.published_on "2005-10-01 05:00:00"
  end 

  factory :restaurant_fact_sheet do |f|  
   f.   venue  "615 W. Randolph St."
   f.intersection "Randolph between Jefferson and DesPlaines"
   f.neighborhood "West Loop"
   f.parking    "valet"
   f.public_transit "1 block south and 1 block west of Pink Line Clinto..."
   f.dinner_average_price "20"
   f.association :restaurant
  end 

  factory :asset do |f|  
   f.data_file_name  "Soapbox-Logo-Color-Web.jpg"
   f.data_content_type "application/octet-stream"
   f.data_file_size "52459"
   f.assetable_id    "6"
   f.assetable_type "User"
   f.type "Picture"
   f.association :user
  end 

  factory :media_request_type do |f|  
   f.name  "Photo Request"
   f.shortname   "photo"
   f.fields "Photo needed, Photo requirements, Other important ..."
   #f.association :media_requests
  end 


end

