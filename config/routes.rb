ActionController::Routing::Routes.draw do |map|
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.fb_login 'facebook_login', :controller => 'user_sessions', :action => 'create_from_facebook'

  map.join 'join_us', :controller => "join", :action => "index"
  map.registration 'register', :controller => "join", :action => "register"
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'
  map.save_confirmation 'save_confirmation/:user_id', :controller => 'users', :action => 'save_confirmation'
  map.resources :invitations, :only => ['new', 'create', 'show'],
        :collection => { :recommend => :get, :submit_recommendation => :post, :redirect => :post },
        :member => { :confirm => :get }
  map.resource :complete_registration, :only => [:show, :update],
    :collection => { :user_details => :get, :find_restaurant => :any, :contact_restaurant => :post,
      :finish_without_contact => :get }

  map.dashboard_more 'dashboard_more', :controller => 'welcome', :action => 'index', :is_more => true
  map.refresh_dashboard 'dashboard/refresh', :controller => 'welcome', :action => 'refresh'
  map.require_login 'dashboard/require_login', :controller => 'welcome', :action => 'require_login'

  map.directory 'directory', :controller => 'directory', :action => 'index'
  map.restaurant_directory 'directory/restaurants', :controller => 'directory', :action => 'restaurants'

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
    soapbox.resources :promotions, :as => "newsfeed"
    soapbox.resources :menu_items, :as => "on_the_menu"

    soapbox.resources :users, :only => [] do |users|
      users.resources :profile_questions, :only => ['index', 'show'], :controller => 'users/profile_questions'
      users.btl_topic 'behind_the_line/topic/:id', :controller => 'users/behind_the_line', :action => 'topic'
      users.btl_chapter 'behind_the_line/chapter/:id', :controller => 'users/behind_the_line', :action => 'chapter'
    end

    soapbox.resources :newsletter_subscribers, :member => { :welcome => :get, :confirm => :get },
                                               :collection => { :find_subscriber => :get }
    soapbox.resources :newsletter_subscriptions, :only => [:update]

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
    mediafeed.resources :media_users, :except => [:index, :show], :member => { "confirm" => :get }
    mediafeed.resend_user_confirmation 'resend_confirmation', :controller => 'media_users', :action => 'resend_confirmation'
    mediafeed.forgot_password 'forgot_password', :controller => 'media_users', :action => 'forgot_password'
    mediafeed.resources :media_requests
    mediafeed.connect 'directory_search', :controller => 'mediafeed', :action => 'directory_search'
    mediafeed.discussion 'media_requests/:id/:discussion_type/:discussion_id', :controller => 'media_requests', :action => 'discussion'
    mediafeed.request_information 'request_information', :controller => 'mediafeed', :action => 'request_information'
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

  map.resources :users, :collection => { :resend_confirmation => :any }, :member => {
    :resume => :get,
    :remove_twitter => :put,
    :remove_avatar => :put,
    :fb_auth => :get,
    :fb_connect => :any,
    :fb_deauth => :any,
    :fb_page_auth => :post,
    :remove_editor => :put
  }, :shallow => true do |users|
    users.resource :profile, :only => ['create', 'edit', 'update'],
                   :controller => 'profiles',
                   :member => { :edit_front_burner => :get, :edit_btl => :get },
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
  end

  map.resource :search, :controller => 'site_search', :only => ['show']

  map.feature '/features/:id', :controller => 'features', :action => 'show'

  map.resources :restaurants,
                :member => { :edit_logo => :get,
                             :select_primary_photo => :post,
                             :new_manager_needed => :get,
                             :replace_manager => :post,
                             :fb_page_auth => :post,
                             :remove_twitter => :put,
                             :twitter_archive => :get,
                             :facebook_archive => :get,
                             :social_archive => :get,
                             :download_subscribers => :get
                             } do |restaurant|
    restaurant.resources :employees, :collection => { :bulk_edit => :get }, :except => [:show, :index]
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
    restaurant.resources :photos, :collection => { "reorder" => :post, "bulk_edit" => :get }, :member => { "show_sizes" => :get }
    restaurant.resource :logo
    restaurant.resources :accolades
    restaurant.resources :restaurant_answers, :only => [:show, :create, :update, :destroy]
    restaurant.resources :a_la_minute_answers, :collection => { :bulk_update => :put, :bulk_edit => :get }
    restaurant.resource :subscription, :collection => { :bt_callback => :get, :billing_history => :get },
                                       :controller => 'subscriptions'
    restaurant.resources :promotions, :member => { :delete_attachment => :post }
    restaurant.resources :menu_items, :member => { :facebook_post => :post }
    restaurant.resources :press_releases, :collection => { :archive => :get }

    restaurant.behind_the_line 'behind_the_line', :controller => 'restaurants/behind_the_line', :action => 'index'
    restaurant.btl_topic 'behind_the_line/topic/:id', :controller => 'restaurants/behind_the_line', :action => 'topic'
    restaurant.btl_chapter 'behind_the_line/chapter/:id', :controller => 'restaurants/behind_the_line', :action => 'chapter'
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
                              :media_requests => :get
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
  map.a_la_minute 'a_la_minute', :controller => "spoonfeed/a_la_minute", :action => "index"
  map.a_la_minute_answers 'a_la_minute/:question_id/answers', :controller => "spoonfeed/a_la_minute", :action => "answers"
  map.menu_items 'on_the_menu', :controller => "spoonfeed/menu_items", :action => "index"
  map.menu_item 'on_the_menu/:id', :controller => "spoonfeed/menu_items", :action => "show"
  map.resources :profile_questions, :only => ['index', 'show'], :as => "behind_the_line", :controller => 'spoonfeed/profile_questions'
  map.social 'social', :controller => "spoonfeed/social_updates", :action => "index"
  map.update_social 'update_social', :controller => "spoonfeed/social_updates", :action => "load_updates"
  map.filter_social 'filter_social', :controller => "spoonfeed/social_updates", :action => "filter_updates"
  map.resources :restaurant_questions, :only => ['index', 'show'], :as => 'restaurant_btl', :controller => 'spoonfeed/restaurant_questions'

  map.resources :page_views, :only => ['create']

  map.namespace :admin do |admin|
    admin.root      :controller => 'admin'

    admin.resources :users
    admin.resources :pages
    admin.resources :feeds, :collection => { :sort => [:post, :put] }
    admin.resources :feed_categories
    admin.resources :date_ranges, :coached_status_updates, :direct_messages
    admin.resources :cuisines, :subject_matters
    admin.resources :restaurants
    admin.resources :media_requests, :member => { :approve => :put }
    admin.resources :restaurant_roles, :except => [:show], :collection => { :update_category => :put }
    admin.resources :holidays
    admin.resources :calendars
    admin.resources :events
    admin.resources :soapbox_entries, :member => { :toggle_status => :post }

    admin.resources :restaurant_questions
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
end
