# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101011150428) do

  create_table "a_la_minute_answers", :force => true do |t|
    t.text     "answer"
    t.integer  "a_la_minute_question_id"
    t.integer  "responder_id"
    t.string   "responder_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_as_public"
  end

  create_table "a_la_minute_questions", :force => true do |t|
    t.text     "question"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accolades", :force => true do |t|
    t.integer  "accoladable_id"
    t.string   "name",             :default => "", :null => false
    t.string   "media_type",       :default => "", :null => false
    t.date     "run_date",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.string   "accoladable_type"
  end

  create_table "admin_conversations", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "admin_message_id"
    t.integer  "comments_count",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_discussions", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "discussionable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",      :default => 0
    t.string   "discussionable_type"
  end

  add_index "admin_discussions", ["discussionable_id", "discussionable_type"], :name => "admin_discussions_by_discussionable"
  add_index "admin_discussions", ["restaurant_id"], :name => "index_admin_discussions_on_restaurant_id"

  create_table "admin_messages", :force => true do |t|
    t.string   "type"
    t.datetime "scheduled_at"
    t.string   "status"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "holiday_id"
    t.string   "display_message"
  end

  create_table "apprenticeships", :force => true do |t|
    t.string   "establishment"
    t.string   "supervisor"
    t.integer  "year"
    t.text     "comments"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 25
    t.string   "type",              :limit => 25
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["assetable_id", "assetable_type", "type"], :name => "ndx_type_assetable"
  add_index "assets", ["assetable_id", "assetable_type"], :name => "fk_assets"
  add_index "assets", ["id", "type"], :name => "index_assets_on_id_and_type"
  add_index "assets", ["user_id"], :name => "fk_user"

  create_table "attachments", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "credit"
    t.integer  "position"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "index_attachments_on_attachable_id_and_attachable_type"

  create_table "awards", :force => true do |t|
    t.integer  "profile_id"
    t.string   "name"
    t.string   "year_won",       :limit => 4, :default => "", :null => false
    t.string   "year_nominated", :limit => 4, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backup", :force => true do |t|
    t.string   "storage"
    t.string   "trigger"
    t.string   "adapter"
    t.string   "filename"
    t.string   "path"
    t.string   "bucket"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapters", :force => true do |t|
    t.integer  "topic_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   :default => 0
  end

  create_table "coached_status_updates", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "date_range_id"
  end

  add_index "coached_status_updates", ["date_range_id"], :name => "index_coached_status_updates_on_date_range_id"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "competitions", :force => true do |t|
    t.integer  "profile_id"
    t.string   "name"
    t.string   "place"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_requests", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "scheduled_at"
    t.datetime "expired_at"
    t.integer  "employment_search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_requests", ["employment_search_id"], :name => "index_content_requests_on_employment_search_id"

  create_table "cuisines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "culinary_jobs", :force => true do |t|
    t.integer  "profile_id",                                        :null => false
    t.string   "title",                          :default => "",    :null => false
    t.string   "city",                           :default => "",    :null => false
    t.string   "state",                          :default => "",    :null => false
    t.date     "date_started",                                      :null => false
    t.date     "date_ended"
    t.string   "chef_name",                      :default => "",    :null => false
    t.boolean  "chef_is_me",                     :default => false, :null => false
    t.text     "cuisine",                        :default => "",    :null => false
    t.text     "notes",                          :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "opening_staff",                  :default => false
    t.string   "restaurant_name", :limit => nil
    t.string   "country",         :limit => nil
  end

  add_index "culinary_jobs", ["profile_id"], :name => "index_profile_restaurants_on_profile_id"

  create_table "date_ranges", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "date_ranges", ["id"], :name => "index_date_ranges_on_id", :unique => true

  create_table "default_employments", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "restaurant_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "direct_messages", :force => true do |t|
    t.text     "body"
    t.integer  "sender_id",                                 :null => false
    t.integer  "receiver_id",                               :null => false
    t.integer  "in_reply_to_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "from_admin",             :default => false
  end

  add_index "direct_messages", ["in_reply_to_message_id"], :name => "index_direct_messages_on_in_reply_to_message_id"
  add_index "direct_messages", ["receiver_id"], :name => "index_direct_messages_on_receiver_id"
  add_index "direct_messages", ["sender_id"], :name => "index_direct_messages_on_sender_id"

  create_table "discussion_seats", :force => true do |t|
    t.integer  "user_id"
    t.integer  "discussion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discussion_seats", ["discussion_id"], :name => "index_discussion_seats_on_discussion_id"
  add_index "discussion_seats", ["user_id"], :name => "index_discussion_seats_on_user_id"

  create_table "discussions", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "poster_id"
    t.integer  "comments_count",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employment_search_id"
  end

  add_index "discussions", ["employment_search_id"], :name => "index_discussions_on_employment_search_id"
  add_index "discussions", ["id"], :name => "index_discussions_on_id", :unique => true
  add_index "discussions", ["poster_id"], :name => "index_discussions_on_poster_id"

  create_table "employment_searches", :force => true do |t|
    t.text     "conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employments", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_role_id"
    t.boolean  "omniscient"
    t.boolean  "primary",            :default => false
    t.boolean  "public_profile"
    t.integer  "position"
  end

  add_index "employments", ["employee_id"], :name => "index_employments_on_employee_id"
  add_index "employments", ["restaurant_id"], :name => "index_employments_on_restaurant_id"
  add_index "employments", ["restaurant_role_id"], :name => "index_employments_on_restaurant_role_id"

  create_table "enrollments", :force => true do |t|
    t.integer  "school_id",                       :null => false
    t.integer  "profile_id",                      :null => false
    t.date     "graduation_date"
    t.string   "degree",          :default => "", :null => false
    t.text     "focus"
    t.text     "scholarships"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "restaurant_id"
    t.string   "title"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "location"
    t.text     "description"
    t.string   "category"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "events", ["restaurant_id"], :name => "index_events_on_restaurant_id"

  create_table "feed_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_categories", ["id"], :name => "index_feed_categories_on_id", :unique => true

  create_table "feed_entries", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "url"
    t.text     "summary"
    t.text     "content"
    t.datetime "published_at"
    t.string   "guid"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_entries", ["feed_id"], :name => "index_feed_entries_on_feed_id"

  create_table "feed_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_subscriptions", ["feed_id"], :name => "index_feed_subscriptions_on_feed_id"
  add_index "feed_subscriptions", ["user_id"], :name => "index_feed_subscriptions_on_user_id"

  create_table "feeds", :force => true do |t|
    t.string   "url"
    t.string   "feed_url"
    t.string   "title"
    t.string   "etag"
    t.boolean  "featured"
    t.integer  "position",         :default => 0
    t.datetime "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_category_id"
  end

  add_index "feeds", ["feed_category_id"], :name => "index_feeds_on_feed_category_id"
  add_index "feeds", ["id"], :name => "index_feeds_on_id", :unique => true

  create_table "followings", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"
  add_index "followings", ["friend_id"], :name => "index_followings_on_friend_id"

  create_table "holiday_conversations", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "holiday_id"
    t.integer  "comments_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted"
  end

  add_index "holiday_conversations", ["holiday_id"], :name => "index_holiday_conversations_on_holiday_id"
  add_index "holiday_conversations", ["recipient_id"], :name => "index_holiday_conversations_on_recipient_id"

  create_table "holiday_discussion_reminders", :force => true do |t|
    t.integer  "holiday_discussion_id"
    t.integer  "holiday_reminder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holiday_discussion_reminders", ["holiday_discussion_id"], :name => "index_holiday_discussion_reminders_on_holiday_discussion_id"
  add_index "holiday_discussion_reminders", ["holiday_reminder_id"], :name => "index_holiday_discussion_reminders_on_holiday_reminder_id"

  create_table "holiday_discussions", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "holiday_id"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",       :default => false
  end

  add_index "holiday_discussions", ["holiday_id"], :name => "index_holiday_discussions_on_holiday_id"
  add_index "holiday_discussions", ["restaurant_id"], :name => "index_holiday_discussions_on_restaurant_id"

  create_table "holiday_reminders", :force => true do |t|
    t.datetime "scheduled_at"
    t.string   "status"
    t.text     "message"
    t.integer  "holiday_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employment_search_id"
  end

  add_index "holidays", ["employment_search_id"], :name => "index_holidays_on_employment_search_id"

  create_table "internships", :force => true do |t|
    t.string   "establishment"
    t.string   "supervisor"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "comments"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "title"
    t.boolean  "coworker",           :default => false
    t.integer  "restaurant_id"
    t.string   "restaurant_name"
    t.integer  "requesting_user_id"
    t.integer  "invitee_id"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",           :default => false
  end

  create_table "james_beard_regions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_request_discussions", :force => true do |t|
    t.integer  "media_request_id"
    t.integer  "restaurant_id"
    t.integer  "comments_count",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_request_discussions", ["media_request_id"], :name => "index_media_request_discussions_on_media_request_id"
  add_index "media_request_discussions", ["restaurant_id"], :name => "index_media_request_discussions_on_restaurant_id"

  create_table "media_request_types", :force => true do |t|
    t.string   "name"
    t.string   "shortname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fields"
  end

  create_table "media_requests", :force => true do |t|
    t.integer  "sender_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "due_date"
    t.integer  "subject_matter_id"
    t.text     "fields"
    t.string   "status"
    t.string   "publication"
    t.boolean  "admin",                :default => false
    t.integer  "employment_search_id"
  end

  add_index "media_requests", ["employment_search_id"], :name => "index_media_requests_on_employment_search_id"
  add_index "media_requests", ["sender_id"], :name => "index_media_requests_on_sender_id"
  add_index "media_requests", ["subject_matter_id"], :name => "index_media_requests_on_media_request_type_id"

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.string   "change_frequency"
    t.integer  "pdf_remote_attachment_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metropolitan_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nonculinary_enrollments", :force => true do |t|
    t.integer  "nonculinary_school_id"
    t.integer  "profile_id"
    t.date     "graduation_date"
    t.string   "field_of_study"
    t.string   "degree"
    t.text     "achievements"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nonculinary_jobs", :force => true do |t|
    t.integer  "profile_id"
    t.string   "company",            :default => "", :null => false
    t.string   "title",              :default => "", :null => false
    t.string   "city",               :default => "", :null => false
    t.string   "state",              :default => "", :null => false
    t.string   "country",            :default => "", :null => false
    t.date     "date_started",                       :null => false
    t.date     "date_ended"
    t.text     "responsibilities",   :default => "", :null => false
    t.text     "reason_for_leaving", :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nonculinary_schools", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "city",       :default => "", :null => false
    t.string   "state",      :default => "", :null => false
    t.string   "country",    :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "slug"
    t.text     "content"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "preferences", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "owner_id",   :null => false
    t.string   "owner_type", :null => false
    t.integer  "group_id"
    t.string   "group_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_id", "owner_type", "name", "group_id", "group_type"], :name => "index_preferences_on_owner_and_name_and_preference", :unique => true

  create_table "profile_answers", :force => true do |t|
    t.integer  "profile_question_id"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "profile_cuisines", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "cuisine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_questions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   :default => 0
    t.integer  "chapter_id"
  end

  create_table "profile_specialties", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "specialty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.date     "birthday"
    t.date     "job_start"
    t.string   "cellnumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "headline",          :default => ""
    t.text     "summary",           :default => ""
    t.string   "hometown"
    t.string   "current_residence"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

  create_table "question_roles", :force => true do |t|
    t.integer  "profile_question_id"
    t.integer  "restaurant_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "readings", :force => true do |t|
    t.string   "readable_type"
    t.integer  "readable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responsibilities", :force => true do |t|
    t.integer  "employment_id"
    t.integer  "subject_matter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_employment_id"
  end

  add_index "responsibilities", ["employment_id"], :name => "index_responsibilities_on_employment_id"
  add_index "responsibilities", ["subject_matter_id"], :name => "index_responsibilities_on_subject_matter_id"

  create_table "restaurant_feature_categories", :force => true do |t|
    t.string   "name"
    t.integer  "restaurant_feature_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurant_feature_categories", ["restaurant_feature_page_id"], :name => "restaurant_feature_page_id_index"

  create_table "restaurant_feature_pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_features", :force => true do |t|
    t.integer  "restaurant_feature_category_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurant_features", ["restaurant_feature_category_id"], :name => "restaurant_feature_category_id_index"

  create_table "restaurant_features_restaurants", :id => false, :force => true do |t|
    t.integer "restaurant_id"
    t.integer "restaurant_feature_id"
  end

  add_index "restaurant_features_restaurants", ["restaurant_feature_id"], :name => "restaurant_feature_id_index"
  add_index "restaurant_features_restaurants", ["restaurant_id", "restaurant_feature_id"], :name => "_restaurant_id_restaurant_feature_id_index"
  add_index "restaurant_features_restaurants", ["restaurant_id"], :name => "restaurant_id_index"

  create_table "restaurant_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.text     "facts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manager_id"
    t.integer  "metropolitan_area_id"
    t.integer  "james_beard_region_id"
    t.integer  "cuisine_id"
    t.datetime "deleted_at"
    t.string   "description"
    t.string   "phone_number"
    t.string   "website"
    t.string   "twitter_username"
    t.string   "facebook_page"
    t.string   "hours"
    t.integer  "media_contact_id"
    t.string   "management_company_name"
    t.string   "management_company_website"
    t.integer  "logo_id"
    t.integer  "primary_photo_id"
    t.date     "opening_date"
    t.boolean  "premium_account"
  end

  add_index "restaurants", ["cuisine_id"], :name => "index_restaurants_on_cuisine_id"
  add_index "restaurants", ["id"], :name => "index_restaurants_on_id", :unique => true
  add_index "restaurants", ["james_beard_region_id"], :name => "index_restaurants_on_james_beard_region_id"
  add_index "restaurants", ["manager_id"], :name => "index_restaurants_on_manager_id"
  add_index "restaurants", ["metropolitan_area_id"], :name => "index_restaurants_on_metropolitan_area_id"

  create_table "schools", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "city",       :default => "", :null => false
    t.string   "state",      :default => "", :null => false
    t.string   "country",    :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "soapbox_entries", :force => true do |t|
    t.datetime "published_at"
    t.integer  "featured_item_id"
    t.string   "featured_item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specialties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "stages", :force => true do |t|
    t.string   "establishment"
    t.string   "expert"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "comments"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "twitter_id"
    t.boolean  "queue_for_social_media"
    t.boolean  "queue_for_facebook"
    t.integer  "facebook_id"
    t.boolean  "queue_for_facebook_page", :default => false
    t.integer  "facebook_page_id"
  end

  add_index "statuses", ["user_id"], :name => "index_statuses_on_user_id"

  create_table "subject_matters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "general"
    t.string   "fields"
    t.boolean  "private"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "trend_questions", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "scheduled_at"
    t.datetime "expired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employment_search_id"
    t.string   "display_message"
  end

  add_index "trend_questions", ["employment_search_id"], :name => "index_trend_questions_on_employment_search_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "perishable_token"
    t.string   "persistence_token",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "confirmed_at"
    t.datetime "last_request_at"
    t.string   "atoken"
    t.string   "asecret"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "james_beard_region_id"
    t.string   "publication"
    t.string   "role"
    t.string   "facebook_id"
    t.string   "facebook_access_token"
    t.string   "facebook_page_id"
    t.string   "facebook_page_token"
    t.string   "phone_number"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id"], :name => "index_users_on_id", :unique => true
  add_index "users", ["james_beard_region_id"], :name => "index_users_on_james_beard_region_id"
  add_index "users", ["username"], :name => "index_users_on_username"

end
