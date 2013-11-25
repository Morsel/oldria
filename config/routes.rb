ActionController::Routing::Routes.draw do |map|
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'  
  
  map.fb_login 'facebook_login', :controller => 'user_sessions', :action => 'create_from_facebook'

  map.join 'join_us', :controller => "join", :action => "index"
  map.soapbox_join 'soapbox/join_us', :controller => "join", :action => "soapbox_join"  
  map.registration 'register', :controller => "join", :action => "register"
  map.soapbox_registration 'soapbox_register', :controller => "join", :action => "soapbox_register"
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'
  map.save_confirmation 'save_confirmation/:user_id', :controller => 'users', :action => 'save_confirmation'
  map.resources :invitations, :only => ['new', 'create', 'show'],
        :collection => { :recommend => :get, :submit_recommendation => :post, :redirect => :post },
        :member => { :confirm => :get }
  map.resource :complete_registration, :only => [:show, :update],
    :collection => { :user_details => :get, :find_restaurant => :any, :contact_restaurant => :post,
      :finish_without_contact => :get, :add_employment => :get,:create_employment=>:post}

  map.dashboard_more 'dashboard_more', :controller => 'welcome', :action => 'index', :is_more => true
  map.refresh_dashboard 'dashboard/refresh', :controller => 'welcome', :action => 'refresh'
  map.require_login 'dashboard/require_login', :controller => 'welcome', :action => 'require_login'
  map.welcome 'welcome', :controller => 'welcome', :action => 'welcome'

  map.directory 'directory', :controller => 'directory', :action => 'index'
  map.restaurant_directory 'directory/restaurants', :controller => 'directory', :action => 'restaurants'
  map.user_restaurants 'directory/current_user_restaurants', :controller => 'directory', :action => 'current_user_restaurants'
  map.get_restaurant_url 'directory/get_restaurant_url', :controller => 'directory', :action => 'get_restaurant_url'
  # the callback for cloudmailin
  map.resource :cloudmail, :only => :create 

  map.namespace(:soapbox) do |soapbox|
    soapbox.resources :profile_questions, :only => ['index', 'show'], :as => "behind_the_line"
    soapbox.btl_topic 'behind_the_line/topic/:id', :controller => 'behind_the_line', :action => 'topic'
    soapbox.btl_chapter 'behind_the_line/chapter/:id', :controller => 'behind_the_line', :action => 'chapter'

    soapbox.resources :restaurant_questions, :only => ['show']

    soapbox.resources :restaurants, :only => ['show'], :member => { :subscribe => :any, :unsubscribe => :post, :confirm_subscription => :get } do |restaurants|
      restaurants.resources :feature_pages, :only => ['show']
      restaurants.resources :questions, :collection => { :topics => :get, :chapters => :get, :refresh => :post }, :controller => "restaurant_questions"
      restaurants.resources :photos, :only => ['show', 'index']
      restaurants.resources :accolades, :only => ['index']
    end
    soapbox.resources :restaurant_features, :only => ["show"]
    soapbox.resources :features, :only => ['show'], :controller => 'features'
    soapbox.resources :a_la_minute_questions, :only => ['index', 'show']
    soapbox.resources :a_la_minute_answers, :only => ['show']
    soapbox.resources :soapbox_entries, :only => ['index', 'show', 'qotd', 'trend'], :as => "front_burner",
                      :collection => { :qotd => :get, :trend => :get },
                      :member => { :comment => :get }
    soapbox.frontburner 'frontburner',:controller => 'soapbox_entries',:action=>'frontburner'

    soapbox.resources :promotions, :as => "newsfeed"
    soapbox.resources :menu_items, :as => "on_the_menu"

    soapbox.resources :users, :only => [] do |users|
      users.resources :profile_questions, :only => ['index', 'show'], :controller => 'users/profile_questions'
      users.btl_topic 'behind_the_line/topic/:id', :controller => 'users/behind_the_line', :action => 'topic'
      users.btl_chapter 'behind_the_line/chapter/:id', :controller => 'users/behind_the_line', :action => 'chapter'
    end

    soapbox.resources :newsletter_subscribers, :member => { :welcome => :get, :confirm => :get },
                                               :collection => { :find_subscriber => :get }
    soapbox.resources :newsletter_subscriptions, :only => [:update, :destroy]
    soapbox.resources :soapbox_password_resets , :collection => { :resend_confirmation => :get }

    soapbox.connect 'travel_guides', :controller => 'soapbox', :action => 'travel_guides'
    soapbox.connect 'directory_search', :controller => 'soapbox', :action => 'directory_search'
    soapbox.connect 'restaurant_search', :controller => 'soapbox', :action => 'restaurant_search'
    soapbox.resource :search, :controller => 'site_search', :only => ['show']
    soapbox.root :controller => 'soapbox', :action => 'index'
  end

  map.soapbox_profile 'soapbox/profile/:username', :controller => 'soapbox/profiles', :action => 'show',
      :requirements => { :username => /[a-zA-Z0-9\-\_ ]+/}

  map.soapbox_directory 'soapbox/directory', :controller => 'soapbox/soapbox', :action => 'directory'
  map.soapbox_restaurant_directory 'soapbox/directory/restaurants',
    :controller => 'soapbox/soapbox', :action => 'restaurant_directory'

  map.with_options :conditions => { :subdomain => 'soapbox' }, :controller => 'soapbox/soapbox' do |soapbox|
    soapbox.root :action => 'index'
  end

  map.namespace(:hq) do |hq|
    hq.root :controller => 'hq', :action => 'index'
  end

  map.with_options :conditions => { :subdomain => 'hq' }, :controller => 'hq/hq' do |hq|
    hq.root :action => 'index'
  end

  map.namespace(:mediafeed) do |mediafeed|
    mediafeed.root :controller => 'mediafeed', :action => 'index'
    mediafeed.login 'login', :controller => 'user_sessions', :action => 'new'
    mediafeed.resources :media_users, :except => [:index, :show], :member => { "confirm" => :get}
    mediafeed.resend_user_confirmation 'resend_confirmation', :controller => 'media_users', :action => 'resend_confirmation'
    mediafeed.forgot_password 'forgot_password', :controller => 'media_users', :action => 'forgot_password'
    mediafeed.resources :media_requests
    mediafeed.connect 'directory_search', :controller => 'mediafeed', :action => 'directory_search'
    mediafeed.discussion 'media_requests/:id/:discussion_type/:discussion_id', :controller => 'media_requests', :action => 'discussion'
    mediafeed.request_information 'request_information', :controller => 'mediafeed', :action => 'request_information'

    mediafeed.request_information_mail 'request_info_mail', :controller => 'mediafeed', :action => 'request_info_mail'

    mediafeed.media_subscription 'media_subscription', :controller => 'mediafeed', :action => 'media_subscription'
    mediafeed.unsubscribe 'unsubscribe', :controller => 'mediafeed', :action => 'media_all_unsubscribe'
    mediafeed.media_opt_update 'media_opt_update', :controller => 'mediafeed', :action => 'media_opt_update'
    mediafeed.get_cities_list 'get_cities', :controller => 'media_users', :action => 'get_cities'
  end

  map.with_options :conditions => { :subdomain => 'mediafeed' }, :controller => 'mediafeed/mediafeed' do |mediafeed|
    mediafeed.root :action => 'index'
  end

  map.mediafeed_directory 'mediafeed/directory', :controller => 'mediafeed/mediafeed', :action => 'directory'

  map.resources :quick_replies

  map.resources :media_request_discussions, :only => [:show, :update], :member => { :read => :put } do |mrc|
    mrc.resources :comments, :only => [:new, :create]
  end

  map.resources :solo_media_discussions, :only => [:show, :update], :member => { :read => :put } do |smd|
    smd.resources :comments, :only => [:new, :create]
  end

  map.resources :discussions, :member => { :read => :put } do |discussions|
    discussions.resources :comments, :only => [:new, :create]
  end

  map.resources :conversations

  map.resources :direct_messages, :member => { :read => :put }

  map.profile 'profile/:username', :controller => 'users', :action => 'show', :requirements => { :username => /[a-zA-Z0-9\-\_ ]+/}
  map.user_profile_subscribe 'user_profile_subscribe/:username', :controller => 'users', :action => 'user_profile_subscribe', :requirements => { :username => /[a-zA-Z0-9\-\_ ]+/}

  map.resources :users, :collection => { :resend_confirmation => :any ,:add_region =>:get ,:new_james_beard_region =>:post }, :member => {
    :resume => :get,
    :remove_twitter => :put,
    :remove_avatar => :put,
    :fb_auth => :get,
    :fb_connect => :any,
    :fb_deauth => :any,
    :fb_page_auth => :post,
    :remove_editor => :put,
    :upload =>:post,
    :edit_newsletters => :get,    
    :add_region_request=>:post  
  }, :shallow => true do |users|
    users.resource :profile, :only => ['create', 'edit', 'update'],
                   :controller => 'profiles',
                   :member => { :edit_front_burner => :get, :edit_btl => :get,:add_role =>:post ,:add_role_form =>:get,:complete_profile => :get},
                   :collection => { :toggle_publish_profile => :get } do |p|
      p.resources :culinary_jobs
      p.resources :nonculinary_jobs
      p.resources :awards
      p.resources :accolades
      p.resources :enrollments
      p.resources :competitions
      p.resources :internships
      p.resources :stages
      p.resources :nonculinary_enrollments
      p.resources :apprenticeships
      p.resources :profile_cuisines
      p.resources :cookbooks
    end
    users.resources :statuses
    users.resources :direct_messages, :member => { :reply => :get }
    users.resources :export_press_kits
    users.behind_the_line 'behind_the_line', :controller => 'users/behind_the_line', :action => 'index'
    users.btl_topic 'behind_the_line/topic/:id', :controller => 'users/behind_the_line', :action => 'topic'
    users.btl_chapter 'behind_the_line/chapter/:id', :controller => 'users/behind_the_line', :action => 'chapter'

    users.resources :default_employments
    users.resource :subscription, 
      :collection => { :bt_callback => :get, :billing_history => :get }, 
      :controller => 'subscriptions'
  end

  map.resources :users do |users|
    users.resources :profile_answers, :only => [:create, :update, :destroy]
    users.resources  :user_visitor_email_setting
  end


  map.resource :search, :controller => 'site_search', :only => ['show']

  map.feature '/features/:id', :controller => 'features', :action => 'show'

  map.resources :restaurants,
                :collection => {:add_restaurant => :get,:media_user_newsletter_subscription=>:get},
                :member => { :edit_logo => :get,
                             :select_primary_photo => :post,
                             :new_manager_needed => :get,
                             :replace_manager => :post,
                             :fb_page_auth => :post,
                             :remove_twitter => :put,
                             :twitter_archive => :get,
                             :facebook_archive => :get,
                             :social_archive => :get,
                             :newsletter_subscriptions => :get,
                             :download_subscribers => :get,
                             :import_csv =>:post,
                             :confirmation_screen =>:post,
                             :new_media_contact => :get,
                             :replace_media_contact => :post,
                             :restaurant_visitors => :get,
                             :send_restaurant_request => :get,
                             :fb_deauth => :any,
                             :api => :get,
                             :media_subscribe => :get
                             } do |restaurant|
    restaurant.resources :employees, :collection => { :bulk_edit => :get,:again_invite_new_employee => :get }, :except => [:show, :index]
    restaurant.resources :employments, :collection => { "reorder" => :post }
    restaurant.resource :employee_accounts, :only => [:create, :destroy]

    restaurant.resource :fact_sheet, :controller => "restaurant_fact_sheets"
    restaurant.resources :calendars, :collection => { "ria" => :get }
    restaurant.resources :events, :member => { "ria_details" => :get, "transfer" => :post }

    restaurant.resources :features, :controller => "restaurant_features",
                                    :member => { :add => :post, :bulk_edit => :get },
                                    :collection => { :edit_top => :get, :update_top => :post } do |features|
      features.resources :profile_answers, :only => [:create, :update, :destroy]
    end

    restaurant.resources :feature_pages
    restaurant.resources :menus, :collection => { "reorder" => :post, :bulk_edit => :get }
    restaurant.resources :photos, :collection => { "reorder" => :post, "bulk_edit" => :get }, :member => { "show_sizes" => :get,"download" => :get }
    restaurant.resource :logo
    restaurant.resources :accolades
    restaurant.resources :restaurant_answers, :only => [:show, :create, :update, :destroy]
    restaurant.resources :a_la_minute_answers, :collection => { :bulk_update => :put, :bulk_edit => :get },:member => { :delete_attachment => :post,:facebook_post => :post }
    restaurant.resource :subscription, :collection => { :bt_callback => :get, :billing_history => :get },
                                       :controller => 'subscriptions'

    restaurant.resources :promotions, :member => { :delete_attachment => :post ,:facebook_post => :post, :details => :get ,:preview => :get}
    restaurant.resources :menu_items, :member => { :facebook_post => :post, :details => :get}
    restaurant.resources :press_releases, :collection => { :archive => :get }

    restaurant.behind_the_line 'behind_the_line', :controller => 'restaurants/behind_the_line', :action => 'index'
    restaurant.btl_topic 'behind_the_line/topic/:id', :controller => 'restaurants/behind_the_line', :action => 'topic'
    restaurant.btl_chapter 'behind_the_line/chapter/:id', :controller => 'restaurants/behind_the_line', :action => 'chapter'
    restaurant.btl_question_ans_post 'behind_the_line/question_ans_post/:id', :controller => 'restaurants/behind_the_line', :action => 'question_ans_post'
    restaurant.social_posts 'social_posts', :controller => 'restaurants/social_post', :action => 'index'
    restaurant.social_posts_page 'social_posts/:page', :controller => 'restaurants/social_post', :action => 'index'

    restaurant.resources :newsletters, :controller => 'restaurants/newsletters', :collection => { :update_settings => :post, :preview => :get, :approve => :post, :archives => :get , :get_campaign_status=> :get,:disapprove => :post,:send_newsletter => :get}

    restaurant.add_keywords 'add_keywords', :controller => "menu_items", :action => "add_keywords"

    restaurant.request_profile_update 'request_profile_update', :controller => "restaurants", :action => "request_profile_update"

    restaurant.resources :visitor_emails

    restaurant.show_notice 'show_notice', :controller => "restaurants", :action => "show_notice"
    restaurant.request_profile_update 'request_profile_update', :controller => "restaurants", :action => "request_profile_update"
    
    restaurant.resources :cartes
  end
  map.resources :categories do |carte_category|
      carte_category.resources :items
  end
 
  map.resources :user_sessions, :password_resets, :followings, :pages

  map.resources :admin_conversations, :only => 'show', :member => { :read => :put } do |admin_conversations|
    admin_conversations.resources :comments, :only => [:new, :create, :edit, :update, :destroy]
  end

  map.resources :admin_discussions, :only => 'show', :member => { :read => :put } do |admin_discussions|
    admin_discussions.resources :comments, :only => [:new, :create, :edit, :update, :destroy]
  end

  map.resources :solo_discussions, :only => 'show', :member => { :read => :put } do |admin_discussions|
    admin_discussions.resources :comments, :only => [:new, :create, :edit, :update]
  end

  map.resources :admin_messages, :only => 'show', :member => { :read => :put }
  map.resources :messages, :collection => {
                              :archive => :get,
                              :ria => :get,
                              :private => :get,
                              :staff_discussions => :get,
                              :media_requests => :get,
                              :restaurant_requests => :get
  }

  map.front_burner 'front_burner', :controller => 'front_burner', :action => 'index'
  map.user_qotds 'front_burner/user/:id', :controller => 'front_burner', :action => 'user_qotds'
  map.qotd 'front_burner/qotd/:id', :controller => 'front_burner', :action => 'qotd'

  map.resources 'trend_questions', :only => 'show', :collection => { 'restaurant' => :get }

  map.resources :timelines, :collection => {
                              :people_you_follow => :get,
                              :twitter => :get,
                              :facebook => :get,
                              :activity_stream => :get
  }

  map.resources :feed_entries, :only => 'show', :member => { :read => :put }
  map.resource :feeds
  map.resource :employment_search

  map.resource :twitter_authorization
  map.resource :friends_statuses, :only => 'show'
  map.social_media 'social_media', :controller => 'social_media', :action => 'index'

  map.promotions 'newsfeed', :controller => "spoonfeed/promotions", :action => "index"
  map.promotion 'newsfeed/:id', :controller => "spoonfeed/promotions", :action => "show"
  map.a_la_minute 'a_la_minute', :controller => "spoonfeed/a_la_minute", :action => "index"
  map.a_la_minute_answers 'a_la_minute/:question_id/answers', :controller => "spoonfeed/a_la_minute", :action => "answers"
  map.menu_items 'on_the_menu', :controller => "spoonfeed/menu_items", :action => "index"
  map.menu_items 'menu_items', :controller => "spoonfeed/menu_items", :action => "index"
  map.menu_item 'on_the_menu/:id', :controller => "spoonfeed/menu_items", :action => "show"
  map.resources :profile_questions, :only => ['index', 'show'], :as => "behind_the_line", :controller => 'spoonfeed/profile_questions'
  map.social 'social', :controller => "spoonfeed/social_updates", :action => "index"
  map.expire_social_update 'expire_social_update', :controller => "spoonfeed/social_updates", :action => "expire_social_update"
  
  map.update_social 'update_social', :controller => "spoonfeed/social_updates", :action => "load_updates"
  map.filter_social 'filter_social', :controller => "spoonfeed/social_updates", :action => "filter_updates"
  map.resources :restaurant_questions, :only => ['index', 'show'], :as => 'restaurant_btl', :controller => 'spoonfeed/restaurant_questions'
  
  map.get_keywords 'get_keywords', :controller => "menu_items", :action => "get_keywords"
  

  map.resources :page_views, :only => ['create']
  map.resources :trace_keywords, :only => ['create']

  map.namespace :admin do |admin|
    admin.root      :controller => 'admin'

    admin.resources :users, :member=>{:impersonator => :get}
    admin.resources :pages
    admin.resources :feeds, :collection => { :sort => [:post, :put] }
    admin.resources :feed_categories
    admin.resources :date_ranges, :coached_status_updates, :direct_messages
    admin.resources :cuisines, :subject_matters
    admin.resources :restaurants
    admin.resources :media_requests, :member => { :approve => :put,  :media_requests_list => :get}
    admin.resources :restaurant_roles, :except => [:show], :collection => { :update_category => :put }
    admin.resources :holidays
    admin.resources :calendars
    admin.resources :events
    admin.resources :soapbox_entries, :member => { :toggle_status => :post }

    admin.resources :restaurant_questions, :member => { :send_notifications => :post }
    admin.resources :restaurant_chapters, :collection => { :select => :post }
    admin.resources :restaurant_topics

    admin.resources :profile_questions, :member => { :send_notifications => :post }
    admin.resources :chapters, :collection => { :select => :post }
    admin.resources :topics
    admin.resources :question_roles

    admin.resources :schools
    admin.resources :specialties, :collection => { :sort => :post }
    admin.resources :invitations, :member => { :accept => :get, :archive => :get, :resend => :get }
    admin.resources :a_la_minute_questions, :member => {:edit_in_place => :post}
    admin.resources :restaurant_features, :only => [:index, :create, :destroy],
        :collection => {:edit_in_place => :post}
    admin.resources :restaurant_feature_pages, :only => [:create,  :destroy],
        :collection => {:edit_in_place => :post}
    admin.resources :restaurant_feature_categories, :only => [:create,  :destroy],
        :collection => {:edit_in_place => :post}

    admin.resource :complimentary_accounts, :only => [:create, :destroy]
    admin.resources :metropolitan_areas
    admin.resources :site_activities
    admin.resources :otm_keywords
    admin.resources :email_stopwords
    admin.resources :page_views, :only => ["index"]
    admin.resources :trace_searches, :only => ["index"], :collection => {:trace_search_for_soapbox => :get}
    admin.resources :page_views, :only => ["index"],:collection => {:trace_keyword_for_soapbox => :get}
    admin.resources :featured_profiles
    admin.resources :test_restaurants, :member =>{:active => :get}

    # Admin Messaging
    exclusive_routes = [:index, :show, :destroy]
    admin.resources :messages, :only => exclusive_routes
    admin.resources :qotds, :except => exclusive_routes
    admin.resources :announcements, :except => exclusive_routes
    admin.resources :pr_tips, :except => exclusive_routes
    admin.resources :holiday_reminders, :except => exclusive_routes
    admin.resources :content_requests
    admin.resources :trend_questions

    # Homepages for SF, SB, MF
    admin.resources :soapbox_pages
    admin.resources :hq_pages
    admin.resources :mediafeed_pages

    admin.resources :soapbox_slides, :collection => { :sort => :post }
    admin.resources :soapbox_promos, :collection => { :sort => :post }

    admin.resources :testimonials
    admin.resources :brain_tree_webhook,:collection => {:varify => :any}


    admin.invalid_employments 'invalid_employments',:controller => "restaurants", :action => "invalid_employments"
    admin.resources :runner 
    admin.export_media_for_newsfeed 'export_media_for_newsfeed', :controller => 'runner', :action => 'export_media_for_newsfeed'
    admin.export_media_for_digest 'export_media_for_digest', :controller => 'runner', :action => 'export_media_for_digest'
    admin.database_info 'database_info', :controller => 'runner', :action => 'database_info'
    admin.resources :invited_employees, :only => :index, :member =>{:active => :get}
  end

  # Not in use?
  map.resources :holiday_conversations, :only => ['show','update'] do |holiday_conversations|
    holiday_conversations.resources :comments, :only => [:new, :create]
  end

  map.resources :holiday_discussions, :member => { :read => :put }, :only => ['show','update'] do |holiday_discussions|
    holiday_discussions.resources :comments, :only => [:new, :create]
  end

  map.resources :holiday_discussion_reminders, :member => { :read => :put }
  ###

  map.root :controller => 'welcome'
  map.public_page ":id", :controller => 'pages', :action => 'show'
  map.soapbox_page 'soapbox/:id', :controller => 'soapbox_pages', :action => 'show'
  map.hq_page 'hq/:id', :controller => 'hq_pages', :action => 'show'
  map.mediafeed_page 'mediafeed/:id', :controller => 'mediafeed_pages', :action => 'show'
  
  # Default Routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.resources :ria_webservices, :collection => {:register => :post,:create => :post,:create_psw_rst => :post,:get_join_us_value=>:get,:soap_box_index =>:get,:a_la_minute_answers =>:get,:menu_items =>:get,:bulk_update => :post,:create_menu=>:post,:create_promotions =>:post,:get_promotion_type=>:get,:new_menu_item=>:get,:bulk_edit_photo=>:get,:create_photo =>:post,:create_comments =>:post,:show_comments =>:get,:get_qotds=>:get,:get_newsfeed=>:get,:push_notification_user=>:post,:get_admin_conversation_discussions=>:get,:get_media_request=>:get}, :controller => "ria_webservices"
  map.resources :ria_production_webservices, :collection => {:register => :post,:create => :post,:create_psw_rst => :post,:get_join_us_value=>:get,:soap_box_index =>:get,:a_la_minute_answers =>:get,:menu_items =>:get,:bulk_update => :post,:create_menu=>:post,:create_promotions =>:post,:get_promotion_type=>:get,:new_menu_item=>:get,:bulk_edit_photo=>:get,:create_photo =>:post,:create_comments =>:post,:show_comments =>:get,:get_qotds=>:get,:get_newsfeed=>:get,:push_notification_user=>:post,:get_admin_conversation_discussions=>:get,:get_media_request=>:get,:api_register=>:post}, :controller => "ria_production_webservices"


  # for restaurant employee no condition
  map.no_choice '/restaurants/:restaurant_id/employees/options', :controller => "employees", :action => "options"
  map.new_employee 'restaurants/:restaurant_id/employees/new_employee', :controller => "employees", :action => "new_employee"  
  #for autocomplete
  map.resources :auto_complete, :only => ["index"]
  map.resources :otm_keywords, :only => ["index"]  

  #for show filter result of restaurant directory
  map.resources :metropolitan_areas, :only => ["index"]

  map.resources :james_beard_regions, :only => ["index"]
  map.resources :cuisines, :only => ["index"]
  map.resources :specialties, :only => ["index"]
  map.search_restaurant_by_name 'directory/search_restaurant_by_name', :controller => 'directory', :action => 'search_restaurant_by_name'
  map.search_user 'directory/search_user', :controller => 'directory', :action => 'search_user'
  #for get selected city
  map.get_selected_cities '/mediafeed/media_users/get_selected_cities', :controller => 'media_users', :action => 'get_selected_cities'
  #get opened campaign
  map.get_opened_campaign '/restaurants/:restaurant_id/newsletters/get_opened_campaign/:campaign_id', :controller => 'restaurants/newsletters', :action => 'get_opened_campaign'
  map.get_clicked_campaign '/restaurants/:restaurant_id/newsletters/get_clicked_campaign/:campaign_id', :controller => 'restaurants/newsletters', :action => 'get_clicked_campaign'
  map.get_bounces_campaign '/restaurants/:restaurant_id/newsletters/get_bounces_campaign/:campaign_id', :controller => 'restaurants/newsletters', :action => 'get_bounces_campaign'
  #new request of employee for restauarnt 
  map.get_feature_keywords '/items/get_feature_keywords', :controller => "items", :action => "get_feature_keywords"
  map.accept_requested_employee 'restaurants/:restaurant_id/employees/:id/accept_requested_employee', :controller => "employees", :action => "accept_requested_employee"  
  map.reject_requested_employee 'restaurants/:restaurant_id/employees/:id/reject_requested_employee', :controller => "employees", :action => "reject_requested_employee"
end
  

 

