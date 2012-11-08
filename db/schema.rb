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

ActiveRecord::Schema.define(:version => 20121108151236) do

  create_table "a_la_minute_answers", :id => false, :force => true do |t|
    t.integer  "id",                      :null => false
    t.text     "answer"
    t.integer  "a_la_minute_question_id"
    t.integer  "responder_id"
    t.string   "responder_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "post_to_twitter_at"
    t.datetime "post_to_facebook_at"
  end

  create_table "a_la_minute_questions", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.text     "question"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "topic"
  end

  create_table "accolades", :id => false, :force => true do |t|
    t.integer  "id",                               :null => false
    t.integer  "accoladable_id"
    t.string   "name",             :default => "", :null => false
    t.string   "media_type",       :default => "", :null => false
    t.date     "run_date",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.string   "accoladable_type"
  end

  create_table "admin_conversations", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
    t.integer  "recipient_id"
    t.integer  "admin_message_id"
    t.integer  "comments_count",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_discussions", :id => false, :force => true do |t|
    t.integer  "id",                                 :null => false
    t.integer  "restaurant_id"
    t.integer  "discussionable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",      :default => 0
    t.string   "discussionable_type"
  end

  add_index "admin_discussions", ["discussionable_id", "discussionable_type"], :name => "admin_discussions_by_discussionable"
  add_index "admin_discussions", ["restaurant_id"], :name => "index_admin_discussions_on_restaurant_id"

  create_table "admin_messages", :id => false, :force => true do |t|
    t.integer  "id",              :null => false
    t.string   "type"
    t.datetime "scheduled_at"
    t.string   "status"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_message"
    t.string   "slug"
  end

  create_table "apprenticeships", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
    t.string   "establishment"
    t.string   "supervisor"
    t.integer  "year"
    t.text     "comments"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "assets", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
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

  create_table "attachments", :id => false, :force => true do |t|
    t.integer  "id",                      :null => false
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
    t.string   "name"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "index_attachments_on_attachable_id_and_attachable_type"

  create_table "awards", :id => false, :force => true do |t|
    t.integer  "id",                                          :null => false
    t.integer  "profile_id"
    t.string   "name"
    t.string   "year_won",       :limit => 4, :default => "", :null => false
    t.string   "year_nominated", :limit => 4, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backup", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "storage"
    t.string   "trigger"
    t.string   "adapter"
    t.string   "filename"
    t.string   "path"
    t.string   "bucket"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapters", :id => false, :force => true do |t|
    t.integer  "id",                         :null => false
    t.integer  "topic_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",    :default => 0
    t.string   "description"
  end

  create_table "coached_status_updates", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "date_range_id"
  end

  add_index "coached_status_updates", ["date_range_id"], :name => "index_coached_status_updates_on_date_range_id"

  create_table "comments", :id => false, :force => true do |t|
    t.integer  "id",                                             :null => false
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

  create_table "competitions", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.integer  "profile_id"
    t.string   "name"
    t.string   "place"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_requests", :id => false, :force => true do |t|
    t.integer  "id",                   :null => false
    t.string   "subject"
    t.text     "body"
    t.datetime "scheduled_at"
    t.datetime "expired_at"
    t.integer  "employment_search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_requests", ["employment_search_id"], :name => "index_content_requests_on_employment_search_id"

  create_table "cookbooks", :id => false, :force => true do |t|
    t.integer  "id",           :null => false
    t.string   "title"
    t.string   "publisher"
    t.datetime "published_on"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cuisines", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "culinary_jobs", :id => false, :force => true do |t|
    t.integer  "id",                                 :null => false
    t.integer  "profile_id",                         :null => false
    t.string   "restaurant_name", :default => "",    :null => false
    t.string   "title",           :default => "",    :null => false
    t.string   "city",            :default => "",    :null => false
    t.string   "state",           :default => "",    :null => false
    t.string   "country",         :default => "",    :null => false
    t.date     "date_started",                       :null => false
    t.date     "date_ended"
    t.string   "chef_name",       :default => "",    :null => false
    t.boolean  "chef_is_me",      :default => false, :null => false
    t.text     "cuisine",                            :null => false
    t.text     "notes",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "opening_staff",   :default => false
  end

  add_index "culinary_jobs", ["profile_id"], :name => "index_profile_restaurants_on_profile_id"

  create_table "date_ranges", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "date_ranges", ["id"], :name => "index_date_ranges_on_id", :unique => true

  create_table "delayed_jobs", :id => false, :force => true do |t|
    t.integer  "id",                        :null => false
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

  create_table "direct_messages", :id => false, :force => true do |t|
    t.integer  "id",                                        :null => false
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

  create_table "discussion_seats", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
    t.integer  "user_id"
    t.integer  "discussion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discussion_seats", ["discussion_id"], :name => "index_discussion_seats_on_discussion_id"
  add_index "discussion_seats", ["user_id"], :name => "index_discussion_seats_on_user_id"

  create_table "discussions", :id => false, :force => true do |t|
    t.integer  "id",                                  :null => false
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

  create_table "email_stopwords", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.text     "phrase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employment_searches", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.text     "conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employments", :id => false, :force => true do |t|
    t.integer  "id",                                      :null => false
    t.integer  "employee_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_role_id"
    t.boolean  "omniscient"
    t.boolean  "primary",              :default => false
    t.boolean  "public_profile",       :default => true
    t.integer  "position"
    t.string   "type"
    t.string   "solo_restaurant_name"
  end

  add_index "employments", ["employee_id"], :name => "index_employments_on_employee_id"
  add_index "employments", ["restaurant_id"], :name => "index_employments_on_restaurant_id"
  add_index "employments", ["restaurant_role_id"], :name => "index_employments_on_restaurant_role_id"

  create_table "enrollments", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
    t.integer  "school_id",                       :null => false
    t.integer  "profile_id",                      :null => false
    t.date     "graduation_date"
    t.string   "degree",          :default => "", :null => false
    t.text     "focus"
    t.text     "scholarships"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
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

  create_table "faq_category", :id => false, :force => true do |t|
    t.integer "id",                        :null => false
    t.string  "name",        :limit => 75
    t.string  "create_date", :limit => 45
  end

  create_table "faq_profile_types", :id => false, :force => true do |t|
    t.integer   "id",                         :null => false
    t.string    "name",        :limit => 100
    t.timestamp "create_date"
  end

  create_table "faq_ria", :id => false, :force => true do |t|
    t.integer   "id",                                  :null => false
    t.integer   "faq_category_id",                     :null => false
    t.integer   "faq_profile_types_id",                :null => false
    t.integer   "user_type",                           :null => false
    t.string    "question",             :limit => 500, :null => false
    t.string    "answer",               :limit => 500, :null => false
    t.timestamp "create_date",                         :null => false
  end

  create_table "featured_profiles", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
    t.integer  "feature_id"
    t.string   "feature_type"
    t.datetime "scheduled_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "spotlight_on", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_categories", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_entries", :id => false, :force => true do |t|
    t.integer  "id",           :null => false
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

  create_table "feed_subscriptions", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_subscriptions", ["feed_id"], :name => "index_feed_subscriptions_on_feed_id"
  add_index "feed_subscriptions", ["user_id"], :name => "index_feed_subscriptions_on_user_id"

  create_table "feeds", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
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

  create_table "followings", :id => false, :force => true do |t|
    t.integer  "id",          :null => false
    t.integer  "follower_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"
  add_index "followings", ["friend_id"], :name => "index_followings_on_friend_id"

  create_table "holiday_conversations", :id => false, :force => true do |t|
    t.integer  "id",                            :null => false
    t.integer  "recipient_id"
    t.integer  "holiday_id"
    t.integer  "comments_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted"
  end

  add_index "holiday_conversations", ["holiday_id"], :name => "index_holiday_conversations_on_holiday_id"
  add_index "holiday_conversations", ["recipient_id"], :name => "index_holiday_conversations_on_recipient_id"

  create_table "holiday_discussion_reminders", :id => false, :force => true do |t|
    t.integer  "id",                    :null => false
    t.integer  "holiday_discussion_id"
    t.integer  "holiday_reminder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holiday_discussion_reminders", ["holiday_discussion_id"], :name => "index_holiday_discussion_reminders_on_holiday_discussion_id"
  add_index "holiday_discussion_reminders", ["holiday_reminder_id"], :name => "index_holiday_discussion_reminders_on_holiday_reminder_id"

  create_table "holiday_discussions", :id => false, :force => true do |t|
    t.integer  "id",                                :null => false
    t.integer  "restaurant_id"
    t.integer  "holiday_id"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",       :default => false
  end

  add_index "holiday_discussions", ["holiday_id"], :name => "index_holiday_discussions_on_holiday_id"
  add_index "holiday_discussions", ["restaurant_id"], :name => "index_holiday_discussions_on_restaurant_id"

  create_table "holiday_reminders", :id => false, :force => true do |t|
    t.integer  "id",           :null => false
    t.datetime "scheduled_at"
    t.string   "status"
    t.text     "message"
    t.integer  "holiday_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", :id => false, :force => true do |t|
    t.integer  "id",                   :null => false
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employment_search_id"
  end

  add_index "holidays", ["employment_search_id"], :name => "index_holidays_on_employment_search_id"

  create_table "hq_pages", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hq_promos", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "hq_slides", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "internships", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
    t.string   "establishment"
    t.string   "supervisor"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "comments"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :id => false, :force => true do |t|
    t.integer  "id",                                    :null => false
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
    t.integer  "restaurant_role_id"
  end

  create_table "invite_responsibilities", :id => false, :force => true do |t|
    t.integer  "id",                :null => false
    t.integer  "invitation_id"
    t.integer  "subject_matter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "james_beard_regions", :id => false, :force => true do |t|
    t.integer  "id",          :null => false
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meals", :id => false, :force => true do |t|
    t.integer  "id",                       :null => false
    t.string   "name"
    t.string   "day"
    t.string   "open_at_hours"
    t.string   "open_at_minutes"
    t.string   "open_at_am_pm"
    t.string   "closed_at_hours"
    t.string   "closed_at_minutes"
    t.string   "closed_at_am_pm"
    t.integer  "restaurant_fact_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_request_discussions", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
    t.integer  "media_request_id"
    t.integer  "restaurant_id"
    t.integer  "comments_count",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_request_discussions", ["media_request_id"], :name => "index_media_request_discussions_on_media_request_id"
  add_index "media_request_discussions", ["restaurant_id"], :name => "index_media_request_discussions_on_restaurant_id"

  create_table "media_request_types", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.string   "shortname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fields"
  end

  create_table "media_requests", :id => false, :force => true do |t|
    t.integer  "id",                                      :null => false
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

  create_table "mediafeed_pages", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_item_keywords", :id => false, :force => true do |t|
    t.integer  "id",             :null => false
    t.integer  "menu_item_id"
    t.integer  "otm_keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_items", :id => false, :force => true do |t|
    t.integer  "id",                  :null => false
    t.string   "name"
    t.text     "description"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "pairing"
    t.datetime "post_to_twitter_at"
    t.datetime "post_to_facebook_at"
    t.integer  "twitter_job_id"
    t.integer  "facebook_job_id"
  end

  create_table "menus", :id => false, :force => true do |t|
    t.integer  "id",                       :null => false
    t.string   "name"
    t.string   "change_frequency"
    t.integer  "pdf_remote_attachment_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "metropolitan_areas", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "metropolitan_areas_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "metropolitan_area_id"
  end

  add_index "metropolitan_areas_users", ["metropolitan_area_id"], :name => "index_metropolitan_areas_users_on_metropolitan_area_id"
  add_index "metropolitan_areas_users", ["user_id"], :name => "index_metropolitan_areas_users_on_user_id"

  create_table "newsletter_subscribers", :id => false, :force => true do |t|
    t.integer  "id",                                      :null => false
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "confirmed_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "receive_soapbox_news", :default => true
    t.boolean  "opt_out",              :default => false
    t.string   "password_hash"
    t.string   "password_salt"
  end

  create_table "newsletter_subscriptions", :id => false, :force => true do |t|
    t.integer  "id",                                          :null => false
    t.integer  "restaurant_id"
    t.integer  "newsletter_subscriber_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "share_with_restaurant",    :default => false
  end

  create_table "nonculinary_enrollments", :id => false, :force => true do |t|
    t.integer  "id",                    :null => false
    t.integer  "nonculinary_school_id"
    t.integer  "profile_id"
    t.date     "graduation_date"
    t.string   "field_of_study"
    t.string   "degree"
    t.text     "achievements"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nonculinary_jobs", :id => false, :force => true do |t|
    t.integer  "id",                                 :null => false
    t.integer  "profile_id"
    t.string   "company",            :default => "", :null => false
    t.string   "title",              :default => "", :null => false
    t.string   "city",               :default => "", :null => false
    t.string   "state",              :default => "", :null => false
    t.string   "country",            :default => "", :null => false
    t.date     "date_started",                       :null => false
    t.date     "date_ended"
    t.text     "responsibilities",                   :null => false
    t.text     "reason_for_leaving",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nonculinary_schools", :id => false, :force => true do |t|
    t.integer  "id",                         :null => false
    t.string   "name",       :default => "", :null => false
    t.string   "city",       :default => "", :null => false
    t.string   "state",      :default => "", :null => false
    t.string   "country",    :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "otm_keywords", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_views", :id => false, :force => true do |t|
    t.integer  "id",              :null => false
    t.integer  "user_id"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_owner_id"
    t.string   "page_owner_type"
  end

  create_table "pages", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "slug"
    t.text     "content"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "preferences", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
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

  create_table "press_releases", :id => false, :force => true do |t|
    t.integer  "id",                       :null => false
    t.string   "title"
    t.integer  "pdf_remote_attachment_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_answers", :id => false, :force => true do |t|
    t.integer  "id",                  :null => false
    t.integer  "profile_question_id"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "profile_cuisines", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.integer  "profile_id"
    t.integer  "cuisine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_questions", :id => false, :force => true do |t|
    t.integer  "id",                               :null => false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",          :default => 0
    t.integer  "chapter_id"
    t.text     "roles_description"
  end

  create_table "profile_specialties", :id => false, :force => true do |t|
    t.integer  "id",           :null => false
    t.integer  "profile_id"
    t.integer  "specialty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :id => false, :force => true do |t|
    t.integer  "id",                                    :null => false
    t.integer  "user_id",                               :null => false
    t.date     "birthday"
    t.date     "job_start"
    t.string   "cellnumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "headline",              :default => ""
    t.text     "summary"
    t.string   "hometown"
    t.string   "current_residence"
    t.integer  "metropolitan_area_id"
    t.integer  "james_beard_region_id"
    t.integer  "skipp_step"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

  create_table "promos", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.integer  "position"
    t.string   "type"
    t.string   "link_text"
  end

  create_table "promotion_types", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotions", :id => false, :force => true do |t|
    t.integer  "id",                      :null => false
    t.integer  "promotion_type_id"
    t.text     "details"
    t.string   "link"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "date_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "headline"
    t.datetime "post_to_twitter_at"
    t.datetime "post_to_facebook_at"
    t.integer  "twitter_job_id"
    t.integer  "facebook_job_id"
  end

  create_table "push_notification_users", :id => false, :force => true do |t|
    t.integer  "id",              :null => false
    t.string   "device_tocken"
    t.string   "uniq_device_key"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_pages", :id => false, :force => true do |t|
    t.integer  "id",                         :null => false
    t.integer  "restaurant_question_id"
    t.integer  "restaurant_feature_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_roles", :id => false, :force => true do |t|
    t.integer  "id",                  :null => false
    t.integer  "profile_question_id"
    t.integer  "restaurant_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "readings", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
    t.string   "readable_type"
    t.integer  "readable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responsibilities", :id => false, :force => true do |t|
    t.integer  "id",                :null => false
    t.integer  "employment_id"
    t.integer  "subject_matter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responsibilities", ["employment_id"], :name => "index_responsibilities_on_employment_id"
  add_index "responsibilities", ["subject_matter_id"], :name => "index_responsibilities_on_subject_matter_id"

  create_table "restaurant_answers", :id => false, :force => true do |t|
    t.integer  "id",                     :null => false
    t.integer  "restaurant_question_id"
    t.text     "answer"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_employee_requests", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
    t.integer  "restaurant_id"
    t.integer  "employee_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_fact_sheets", :id => false, :force => true do |t|
    t.integer  "id",                                :null => false
    t.string   "venue"
    t.string   "intersection"
    t.string   "neighborhood"
    t.string   "parking"
    t.string   "public_transit"
    t.string   "dinner_average_price"
    t.string   "lunch_average_price"
    t.string   "brunch_average_price"
    t.string   "breakfast_average_price"
    t.string   "children_average_price"
    t.string   "small_plate_min_price"
    t.string   "small_plate_max_price"
    t.string   "large_plate_min_price"
    t.string   "large_plate_max_price"
    t.string   "dessert_plate_min_price"
    t.string   "dessert_plate_max_price"
    t.string   "wine_by_the_glass_count"
    t.string   "wine_by_the_glass_min_price"
    t.string   "wine_by_the_glass_max_price"
    t.string   "wine_by_the_bottle_count"
    t.string   "wine_by_the_bottle_min_price"
    t.string   "wine_by_the_bottle_max_price"
    t.text     "wine_by_the_bottle_details"
    t.string   "reservations"
    t.text     "cancellation_policy"
    t.string   "payment_methods"
    t.boolean  "byob_allowed"
    t.string   "corkage_fee"
    t.string   "dress_code"
    t.string   "delivery"
    t.string   "wheelchair_access"
    t.string   "smoking"
    t.string   "architect_name"
    t.string   "graphic_designer"
    t.string   "furniture_designer"
    t.string   "furniture_manufacturer"
    t.text     "flooring"
    t.text     "millwork"
    t.text     "china"
    t.text     "kitchen_equipment"
    t.text     "lighting"
    t.text     "draperies"
    t.string   "square_footage"
    t.integer  "restaurant_id"
    t.datetime "parking_and_directions_updated_at"
    t.datetime "pricing_updated_at"
    t.datetime "guest_relations_updated_at"
    t.datetime "design_updated_at"
    t.datetime "other_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "days_closed"
    t.string   "holidays_closed"
    t.string   "concept"
    t.string   "entertainment"
  end

  create_table "restaurant_feature_categories", :id => false, :force => true do |t|
    t.integer  "id",                         :null => false
    t.string   "name"
    t.integer  "restaurant_feature_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurant_feature_categories", ["restaurant_feature_page_id"], :name => "restaurant_feature_page_id_index"

  create_table "restaurant_feature_items", :id => false, :force => true do |t|
    t.integer "restaurant_id"
    t.integer "restaurant_feature_id"
    t.integer "id",                                       :null => false
    t.boolean "top_tag",               :default => false
  end

  add_index "restaurant_feature_items", ["restaurant_feature_id"], :name => "restaurant_feature_id_index"
  add_index "restaurant_feature_items", ["restaurant_id", "restaurant_feature_id"], :name => "_restaurant_id_restaurant_feature_id_index"
  add_index "restaurant_feature_items", ["restaurant_id"], :name => "restaurant_id_index"

  create_table "restaurant_feature_pages", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_features", :id => false, :force => true do |t|
    t.integer  "id",                             :null => false
    t.integer  "restaurant_feature_category_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurant_features", ["restaurant_feature_category_id"], :name => "restaurant_feature_category_id_index"

  create_table "restaurant_newsletters", :id => false, :force => true do |t|
    t.integer  "id",                     :null => false
    t.integer  "restaurant_id"
    t.text     "menu_item_ids"
    t.text     "restaurant_answer_ids"
    t.text     "menu_ids"
    t.text     "promotion_ids"
    t.text     "a_la_minute_answer_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_questions", :id => false, :force => true do |t|
    t.integer  "id",                :null => false
    t.string   "title"
    t.integer  "position"
    t.integer  "chapter_id"
    t.text     "pages_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_roles", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "restaurants", :id => false, :force => true do |t|
    t.integer  "id",                                                 :null => false
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
    t.string   "twitter_handle"
    t.string   "facebook_page_url"
    t.string   "hours"
    t.integer  "media_contact_id"
    t.string   "management_company_name"
    t.string   "management_company_website"
    t.integer  "logo_id"
    t.integer  "primary_photo_id"
    t.date     "opening_date"
    t.boolean  "premium_account"
    t.string   "sort_name"
    t.string   "facebook_page_id"
    t.string   "facebook_page_token"
    t.string   "atoken"
    t.string   "asecret"
    t.boolean  "is_activated",               :default => true
    t.string   "newsletter_frequency",       :default => "biweekly"
    t.datetime "last_newsletter_at"
    t.datetime "next_newsletter_at"
  end

  add_index "restaurants", ["cuisine_id"], :name => "index_restaurants_on_cuisine_id"
  add_index "restaurants", ["id"], :name => "index_restaurants_on_id", :unique => true
  add_index "restaurants", ["james_beard_region_id"], :name => "index_restaurants_on_james_beard_region_id"
  add_index "restaurants", ["manager_id"], :name => "index_restaurants_on_manager_id"
  add_index "restaurants", ["metropolitan_area_id"], :name => "index_restaurants_on_metropolitan_area_id"

  create_table "schools", :id => false, :force => true do |t|
    t.integer  "id",                         :null => false
    t.string   "name",       :default => "", :null => false
    t.string   "city",       :default => "", :null => false
    t.string   "state",      :default => "", :null => false
    t.string   "country",    :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seating_areas", :id => false, :force => true do |t|
    t.integer  "id",                       :null => false
    t.string   "name"
    t.integer  "occupancy"
    t.integer  "restaurant_fact_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_activities", :id => false, :force => true do |t|
    t.integer  "id",           :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.string   "creator_type"
    t.integer  "content_id"
    t.string   "content_type"
  end

  create_table "slides", :id => false, :force => true do |t|
    t.integer  "id",                 :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "title"
    t.text     "excerpt"
    t.string   "link"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_credit"
    t.string   "type"
  end

  create_table "slugs", :id => false, :force => true do |t|
    t.integer  "id",                                          :null => false
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "soapbox_entries", :id => false, :force => true do |t|
    t.integer  "id",                                    :null => false
    t.datetime "published_at"
    t.integer  "featured_item_id"
    t.string   "featured_item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",          :default => true
    t.boolean  "daily_feature",      :default => false
    t.text     "description"
  end

  create_table "soapbox_pages", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_updates", :id => false, :force => true do |t|
    t.integer  "id",              :null => false
    t.string   "post_data"
    t.string   "link"
    t.datetime "post_created_at"
    t.string   "source"
    t.integer  "restaurant_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_id"
  end

  create_table "solo_discussions", :id => false, :force => true do |t|
    t.integer  "id",                               :null => false
    t.integer  "employment_id"
    t.integer  "trend_question_id"
    t.integer  "comments_count",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solo_media_discussions", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
    t.integer  "media_request_id"
    t.integer  "employment_id"
    t.integer  "comments_count",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specialties", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "stages", :id => false, :force => true do |t|
    t.integer  "id",            :null => false
    t.string   "establishment"
    t.string   "expert"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "comments"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

  create_table "statuses", :id => false, :force => true do |t|
    t.integer  "id",                                         :null => false
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

  create_table "subject_matters", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "general"
    t.string   "fields"
    t.boolean  "private"
  end

  create_table "subscriptions", :id => false, :force => true do |t|
    t.integer  "id",              :null => false
    t.string   "braintree_id"
    t.date     "start_date"
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.integer  "payer_id"
    t.string   "payer_type"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "end_date"
    t.string   "status"
  end

  create_table "tasting_menus", :id => false, :force => true do |t|
    t.integer  "id",                       :null => false
    t.string   "name"
    t.string   "price"
    t.string   "wine_supplement_price"
    t.integer  "restaurant_fact_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", :id => false, :force => true do |t|
    t.integer  "id",                 :null => false
    t.string   "person"
    t.text     "quote"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "page"
  end

  create_table "topics", :id => false, :force => true do |t|
    t.integer  "id",          :null => false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "description"
    t.string   "type"
  end

  create_table "trend_questions", :id => false, :force => true do |t|
    t.integer  "id",                   :null => false
    t.string   "subject"
    t.text     "body"
    t.datetime "scheduled_at"
    t.datetime "expired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employment_search_id"
    t.string   "display_message"
    t.string   "slug"
  end

  add_index "trend_questions", ["employment_search_id"], :name => "index_trend_questions_on_employment_search_id"

  create_table "user_editors", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.integer  "user_id"
    t.integer  "editor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_types", :id => false, :force => true do |t|
    t.integer   "id",                        :null => false
    t.string    "name",        :limit => 45
    t.timestamp "create_date",               :null => false
  end

  create_table "users", :id => false, :force => true do |t|
    t.integer  "id",                                          :null => false
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "perishable_token"
    t.string   "persistence_token",                           :null => false
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
    t.string   "publication"
    t.string   "role"
    t.string   "facebook_id"
    t.string   "facebook_access_token"
    t.string   "facebook_page_id"
    t.string   "facebook_page_token"
    t.boolean  "premium_account"
    t.boolean  "visible",                   :default => true
    t.boolean  "national"
    t.boolean  "mediafeed_visible",         :default => true
    t.string   "notification_email"
    t.boolean  "publish_profile",           :default => true
    t.datetime "facebook_token_expiration"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id"], :name => "index_users_on_id", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

end
