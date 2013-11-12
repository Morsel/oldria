Ria::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'facebook_login' => 'user_sessions#create_from_facebook', :as => :fb_login
  match 'join_us' => 'join#index', :as => :join
  match 'soapbox/join_us' => 'join#soapbox_join', :as => :soapbox_join
  match 'register' => 'join#register', :as => :registration
  match 'soapbox_register' => 'join#soapbox_register', :as => :soapbox_registration
  match 'confirm/:id' => 'users#confirm', :as => :confirm
  match 'save_confirmation/:user_id' => 'users#save_confirmation', :as => :save_confirmation
  resources :invitations, :only => ["new", "create", "show"] do
    collection do
      get :recommend
      post :submit_recommendation
      post :redirect
    end
    member do
      get :confirm
    end  
  end

  resource :complete_registration, :only => [:show, :update] do
    collection do
      get :user_details
      get :find_restaurant
      post :find_restaurant
      post :contact_restaurant
      get :finish_without_contact
    end  
  end

  match 'dashboard_more' => 'welcome#index', :as => :dashboard_more, :is_more => true
  match 'dashboard/refresh' => 'welcome#refresh', :as => :refresh_dashboard
  match 'dashboard/require_login' => 'welcome#require_login', :as => :require_login
  match 'directory' => 'directory#index', :as => :directory
  match 'directory/restaurants' => 'directory#restaurants', :as => :restaurant_directory
  match 'directory/current_user_restaurants' => 'directory#current_user_restaurants', :as => :user_restaurants
  match 'directory/get_restaurant_url' => 'directory#get_restaurant_url', :as => :get_restaurant_url
  resource :cloudmail, :only => :create
    # match '/' => 'soapbox#index'
  namespace :soapbox do
    root :to => 'soapbox#index'
    resources :profile_questions, :only => ["index", "show"]
    match 'behind_the_line/topic/:id' => 'behind_the_line#topic', :as => :btl_topic
    match 'behind_the_line/chapter/:id' => 'behind_the_line#chapter', :as => :btl_chapter
    resources :restaurant_questions, :only => ["show"]
    resources :restaurants, :only => ["show"] do  
      member do
        get :subscribe
        post :subscribe
        post :unsubscribe
        get :confirm_subscription
      end
      resources :feature_pages, :only => ["show"]
      resources :questions do
        collection do
          get :topics
          get :chapters
          post :refresh
        end
      end
      resources :photos, :only => ["show", "index"]
      resources :accolades, :only => ["index"]
    end
    resources :restaurant_features, :only => ["show"]
    resources :features, :only => ["show"]
    resources :a_la_minute_questions, :only => ["index", "show"]
    resources :a_la_minute_answers, :only => ["show"]
    resources :front_burner, :as => "soapbox_entries",:controller => "soapbox_entries", :only => ["index", "show", "qotd", "trend"] do
      collection do
        get :qotd
        get :trend
      end
      member do
        get :comment
      end   
    end
    match 'frontburner' => 'soapbox_entries#frontburner', :as => :frontburner
    resources :promotions
    resources :menu_items, :path => 'on_the_menu'
    resources :users, :only => [] do   
      resources :profile_questions, :only => ["index", "show"]
      match 'behind_the_line/topic/:id' => 'users/behind_the_line#topic', :as => :btl_topic
      match 'behind_the_line/chapter/:id' => 'users/behind_the_line#chapter', :as => :btl_chapter
    end
    resources :newsletter_subscribers do
      collection do
        get :find_subscriber
        post :connect
      end
      member do
        get :welcome
        get :confirm        
      end   
    end
    resources :newsletter_subscriptions, :only => [:update, :destroy]
    resources :soapbox_password_resets do
      collection do
        get :resend_confirmation
      end   
    end
    match 'travel_guides' => 'soapbox#travel_guides'
    match 'directory_search' => 'soapbox#directory_search'
    match 'restaurant_search' => 'soapbox#restaurant_search'
    resource :search,:controller => 'site_search', :only => ["show"]      
  end

  match 'soapbox/profile/:username' => 'soapbox/profiles#show', :as => :soapbox_profile, :constraints => { :username => /[a-zA-Z0-9\-\_20% ]+/ }
  match 'soapbox/directory' => 'soapbox/soapbox#directory', :as => :soapbox_directory
  match 'soapbox/directory/restaurants' => 'soapbox/soapbox#restaurant_directory', :as => :soapbox_restaurant_directory
  match '/' => 'soapbox/soapbox#index', :via => 'hq#index'
  namespace :hq do
    root :to => 'hq#index'
  end

  match '/' => 'hq/hq#index', :via =>'mediafeed#index'
  namespace :mediafeed do
    root :to => 'mediafeed#index'
    match 'login' => 'user_sessions#new', :as => :login
    resources :media_users, :except => [:index, :show] do  
      member do
        get :confirm
      end
      collection do 
        get :get_selected_cities
      end    
    end
    match 'resend_confirmation' => 'media_users#resend_confirmation', :as => :resend_user_confirmation
    match 'forgot_password' => 'media_users#forgot_password', :as => :forgot_password
    resources :media_requests
    match 'directory_search' => 'mediafeed#directory_search'
    match 'media_requests/:id/:discussion_type/:discussion_id' => 'media_requests#discussion', :as => :discussion
    match 'request_information' => 'mediafeed#request_information', :as => :request_information
    match 'request_info_mail' => 'mediafeed#request_info_mail', :as => :request_information_mail
    match 'media_subscription' => 'mediafeed#media_subscription', :as => :media_subscription
    match 'unsubscribe' => 'mediafeed#media_all_unsubscribe', :as => :unsubscribe
    match 'media_opt_update' => 'mediafeed#media_opt_update', :as => :media_opt_update
    match 'get_cities' => 'media_users#get_cities', :as => :get_cities_list
  end
  
  match '/' => 'mediafeed/mediafeed#index', :via =>'mediafeed/mediafeed#directory', :as => :mediafeed_directory
  resources :quick_replies
  resources :media_request_discussions, :only => [:show, :update] do  
    member do
      put :read
    end
    resources :comments, :only => [:new, :create]
  end

  resources :solo_media_discussions, :only => [:show, :update] do  
    member do
      put :read
    end
    resources :comments, :only => [:new, :create]
  end

  resources :discussions do  
    member do
      put :read
    end
    resources :comments, :only => [:new, :create]
  end

  resources :conversations
  resources :direct_messages do
    member do
      put :read
    end
  end

  match 'profile/:username' => 'users#show', :as => :profile, :constraints => { :username => /[a-zA-Z0-9\-\_20% ]+/ }
  match 'user_profile_subscribe/:username' => 'users#user_profile_subscribe', :as => :user_profile_subscribe, :constraints => { :username => /[a-zA-Z0-9\-\_20% ]+/ }
  resources :users do
    collection do
      get :resend_confirmation
      post :resend_confirmation
      get :add_region
      post :new_james_beard_region
    end
    match 'behind_the_line' => 'users/behind_the_line#index', :as => :behind_the_line
    match 'behind_the_line/topic/:id' => 'users/behind_the_line#topic', :as => :btl_topic
    match 'behind_the_line/chapter/:id' => 'users/behind_the_line#chapter', :as => :btl_chapter
  end
  resources :users, shallow: true do 
    member do
      get :resume
      put :remove_twitter
      put :remove_avatar
      get :fb_auth
      get :fb_connect
      post :fb_connect
      get :fb_deauth
      post :fb_deauth
      post :fb_page_auth
      put :remove_editor
      post :upload
      get :edit_newsletters
      post :add_region_request
    end
    resource :profile, :only => ["create", "edit", "update"] do
      collection do
        get :toggle_publish_profile
      end
      member do
        get :edit_front_burner
        get :edit_btl
        post :add_role
        get :add_role_form
        get :complete_profile
      end
      resources :culinary_jobs
      resources :nonculinary_jobs
      resources :awards
      resources :accolades
      resources :enrollments
      resources :competitions
      resources :internships
      resources :stages
      resources :nonculinary_enrollments
      resources :apprenticeships
      resources :profile_cuisines
      resources :cookbooks
    end
    resources :statuses
    resources :direct_messages do    
      member do
        get :reply
      end    
    end
    resources :export_press_kits
    
    resources :default_employments
    resource :subscription do
      collection do
        get :bt_callback
        get :billing_history
      end   
    end
  end

  resources :users do 
    resources :profile_answers, :only => [:create, :update, :destroy]
    resources :user_visitor_email_setting
  end

  resource :search, :controller => 'site_search', :only => ['show']
  match '/features/:id' => 'features#show', :as => :feature
  resources :restaurants do
    collection do
      get :add_restaurant
      get :media_user_newsletter_subscription
    end
    member do
      get :edit_logo
      post :select_primary_photo
      get :new_manager_needed
      post :replace_manager
      post :fb_page_auth
      put :remove_twitter
      get :twitter_archive
      get :facebook_archive
      get :social_archive
      get :newsletter_subscriptions
      get :download_subscribers
      post :import_csv
      post :confirmation_screen
      get :new_media_contact
      post :replace_media_contact
      get :restaurant_visitors
      get :send_restaurant_request
      get :fb_deauth
      post :fb_deauth
      get :api
      get :media_subscribe
    end
    resources :employees, :except => [:show, :index] do
      collection do
        get :bulk_edit
      end   
    end
    resources :employments do
      collection do
        post :reorder
      end   
    end
    resource :employee_accounts, :only => [:create, :destroy]
    resource :fact_sheet, :controller => :restaurant_fact_sheets
    resources :calendars do
      collection do
        get :ria
      end   
    end
    resources :events do
      member do
        get :ria_details
        post :transfer
      end    
    end
    resources :features, :controller=>:restaurant_features do
      collection do
        get :edit_top 
        post :update_top 
      end
      member do
        post :add 
        get :bulk_edit 
      end
      resources :profile_answers, :only => [:create, :update, :destroy]
    end
    resources :feature_pages
    resources :menus do
      collection do
        post :reorder
        get :bulk_edit
      end    
    end
    resources :photos do
      collection do
        post :reorder
        get :bulk_edit
      end
      member do
        get :show_sizes
      end   
    end
    resource :logo
    resources :accolades
    resources :restaurant_answers, :only => [:show, :create, :update, :destroy]
    resources :a_la_minute_answers do
      collection do
        put :bulk_update
        get :bulk_edit
      end
      member do
        post :delete_attachment
        post :facebook_post
      end   
    end
    resource :subscription do
      collection do
        get :bt_callback
        get :billing_history
      end   
    end
    resources :promotions do
      member do
        post :delete_attachment
        post :facebook_post
        get :details
        get :preview
      end    
    end
    resources :menu_items do
      member do
        post :facebook_post
        get :details
      end    
    end
    resources :press_releases do
      collection do
        get :archive
      end   
    end
    match 'behind_the_line' => 'restaurants/behind_the_line#index', :as => :behind_the_line
    match 'behind_the_line/topic/:id' => 'restaurants/behind_the_line#topic', :as => :btl_topic
    match 'behind_the_line/chapter/:id' => 'restaurants/behind_the_line#chapter', :as => :btl_chapter
    match 'behind_the_line/question_ans_post/:id' => 'restaurants/behind_the_line#question_ans_post', :as => :btl_question_ans_post
    match 'social_posts' => 'restaurants/social_post#index', :as => :social_posts
    match 'social_posts/:page' => 'restaurants/social_post#index', :as => :social_posts_page
    resources :newsletters, :controller => 'restaurants/newsletters' do
      collection do
        post :update_settings
        get :preview
        post :approve
        get :archives
        get :get_campaign_status
        post :disapprove
      end    
    end
    match 'add_keywords' => 'menu_items#add_keywords', :as => :add_keywords
    match 'request_profile_update' => 'restaurants#request_profile_update', :as => :request_profile_update
    match 'show_notice' => 'restaurants#show_notice', :as => :show_notice
  end

  resources :user_sessions
  resources :password_resets
  resources :followings
  resources :pages
  resources :admin_conversations, :only => "show" do  
    member do
      put :read
    end
    resources :comments, :only => [:new, :create, :edit, :update, :destroy]
  end

  resources :admin_discussions, :only => "show" do
    member do
      put :read
    end
    resources :comments, :only => [:new, :create, :edit, :update, :destroy]
  end

  resources :solo_discussions, :only => "show" do
    member do
      put :read
    end
    resources :comments, :only => [:new, :create, :edit, :update]
  end

  resources :admin_messages, :only => "show" do
    member do
      put :read
    end
  end

  resources :messages do
    collection do
      get :archive
      get :ria
      get :private
      get :staff_discussions
      get :media_requests
      get :restaurant_requests
    end
  end

  match 'front_burner' => 'front_burner#index', :as => :front_burner
  match 'front_burner/user/:id' => 'front_burner#user_qotds', :as => :user_qotds
  match 'front_burner/qotd/:id' => 'front_burner#qotd', :as => :qotd
  resources :trend_questions, :only => "show" do
    collection do
      get :restaurant
    end 
  end

  resources :timelines do
    collection do
      get :people_you_follow
      get :twitter
      get :facebook
      get :activity_stream
    end 
  end

  resources :feed_entries, :only => "show" do
    member do
      put :read
    end 
  end

  resource :feeds
  resource :employment_search
  resource :twitter_authorization
  resource :friends_statuses, :only => "show"
  match 'social_media' => 'social_media#index', :as => :social_media
  match 'newsfeed' => 'spoonfeed/promotions#index', :as => :promotions
  match 'a_la_minute' => 'spoonfeed/a_la_minute#index', :as => :a_la_minute
  match 'a_la_minute/:question_id/answers' => 'spoonfeed/a_la_minute#answers', :as => :a_la_minute_answers
  match 'on_the_menu' => 'spoonfeed/menu_items#index', :as => :menu_items
  match 'menu_items' => 'spoonfeed/menu_items#index', :as => :menu_items
  match 'on_the_menu/:id' => 'spoonfeed/menu_items#show', :as => :menu_item
  namespace :spoonfeed,:as=>"profile_questions", :path => 'behind_the_line' do
    match "/" => 'profile_questions#index'#,:as => "behind_the_line"
  end
  namespace :spoonfeed,:as=>"profile_question", :path => 'behind_the_line' do
    match "/:id" => 'profile_questions#show'#,:get => "behind_the_line"
  end
  # match "profile_questions" => 'spoonfeed/profile_questions#index'#,:as => "behind_the_line"
  # match "profile_questions/:id" => 'spoonfeed/profile_question#show'#,:get => "behind_the_line"
  match 'social' => 'spoonfeed/social_updates#index', :as => :social
  match 'expire_social_update' => 'spoonfeed/social_updates#expire_social_update', :as => :expire_social_update
  match 'update_social' => 'spoonfeed/social_updates#load_updates', :as => :update_social
  match 'filter_social' => 'spoonfeed/social_updates#filter_updates', :as => :filter_social
  resources :restaurant_questions, :only => ["index", "show"]
  match 'get_keywords' => 'menu_items#get_keywords', :as => :get_keywords
  resources :page_views, :only => ["create"]
  resources :trace_keywords, :only => ["create"]
    # match '/' => 'admin#index'
  namespace :admin do
    root :to => "admin#index"
    resources :users do    
      member do
        get :impersonator
      end    
    end
    resources :pages
    resources :feeds do
      collection do
        post :sort
        put :sort
      end
    end
    resources :feed_categories
    resources :date_ranges
    resources :coached_status_updates
    resources :direct_messages
    resources :cuisines
    resources :subject_matters
    resources :restaurants
    resources :media_requests do      
      member do
        get :approve
        put :approve
        get :media_requests_list
      end    
    end
    resources :restaurant_roles, :except => [:show] do
      collection do
        put :update_category
      end
    end
    resources :holidays
    resources :calendars
    resources :events
    resources :soapbox_entries do    
      member do
        get :toggle_status
        post :toggle_status
      end   
    end
    resources :restaurant_questions do    
      member do
        get :send_notifications
      end    
    end
    resources :restaurant_chapters do
      collection do
        post :select
      end
    end
    resources :restaurant_topics
    resources :profile_questions do
      member do
        get :send_notifications        
      end
      collection do 
        post :sort
      end
    end
    resources :chapters do
      collection do
        post :select
      end
    end
    resources :topics
    resources :question_roles
    resources :schools
    resources :specialties do
      collection do
        post :sort
      end
    end
    resources :invitations do    
      member do
        get :accept
        get :archive
        get :resend
      end    
    end
    resources :a_la_minute_questions do    
      member do
        post :edit_in_place
      end   
    end    
    resources :restaurant_features, :only => [:index, :create, :destroy] do
      collection do
        post :edit_in_place
      end
    end
    resources :restaurant_feature_pages, :only => [:create, :destroy] do
      collection do
        post :edit_in_place
      end   
    end
    resources :restaurant_feature_categories, :only => [:create, :destroy] do
      collection do
        post :edit_in_place
      end
    end
    resource :complimentary_accounts, :only => [:create, :destroy]
    resources :metropolitan_areas
    resources :site_activities
    resources :otm_keywords
    resources :email_stopwords
    resources :page_views, :only => ["index"]
    resources :trace_searches, :only => ["index"] do
      collection do
        get :trace_search_for_soapbox
      end
    end
    resources :page_views, :only => ["index"] do
      collection do
        get :trace_keyword_for_soapbox
      end    
    end
    resources :featured_profiles
    resources :test_restaurants do    
      member do
        get :active
      end    
    end
    resources :messages, :only => [:index, :show, :destroy]
    resources :qotds, :except => [:index, :show, :destroy]
    resources :announcements, :except => [:index, :show, :destroy]
    resources :pr_tips, :except => [:index, :show, :destroy]
    resources :holiday_reminders, :except => [:index, :show, :destroy]
    resources :content_requests
    resources :trend_questions
    resources :soapbox_pages
    resources :hq_pages
    resources :mediafeed_pages
    resources :soapbox_slides do
      collection do
        post :sort
      end   
    end
    resources :soapbox_promos do
      collection do
        post :sort
      end   
    end
    resources :testimonials
    resources :brain_tree_webhook do
      collection do
        get :varify
        post :varify
      end   
    end
    match 'invalid_employments' => 'restaurants#invalid_employments', :as => :invalid_employments
    resources :runner
    match 'export_media_for_newsfeed' => 'runner#export_media_for_newsfeed', :as => :export_media_for_newsfeed
    match 'export_media_for_digest' => 'runner#export_media_for_digest', :as => :export_media_for_digest
    resources :invited_employees, :only => :index do   
      member do
        get :active
      end    
    end
  end

  resources :holiday_conversations, :only => ["show", "update"] do 
    resources :comments, :only => [:new, :create]
  end

  resources :holiday_discussions, :only => ["show", "update"] do  
    member do
      put :read
    end
    resources :comments, :only => [:new, :create]
  end

  resources :holiday_discussion_reminders do  
    member do
      put :read
    end  
  end
  root :to => 'welcome#index'
  # :root => 'welcome#index'
  match ':id' => 'pages#show', :as => :public_page
  match 'soapbox/:id' => 'soapbox_pages#show', :as => :soapbox_page
  match 'hq/:id' => 'hq_pages#show', :as => :hq_page
  match 'mediafeed/:id' => 'mediafeed_pages#show', :as => :mediafeed_page
  match '/:controller(/:action(/:id))', :as => :connect

  resources :ria_webservices do
    collection do
      post :register
      post :create
      post :create_psw_rst
      get :get_join_us_value
      get :soap_box_index
      get :a_la_minute_answers
      get :menu_items
      post :bulk_update
      post :create_menu
      post :create_promotions
      get :get_promotion_type
      get :new_menu_item
      get :bulk_edit_photo
      post :create_photo
      post :create_comments
      get :show_comments
      get :get_qotds
      get :get_newsfeed
      post :push_notification_user
      get :get_admin_conversation_discussions
      get :get_media_request
    end  
  end

  resources :ria_production_webservices do
    collection do
      post :register
      post :create
      post :create_psw_rst
      get :get_join_us_value
      get :soap_box_index
      get :a_la_minute_answers
      get :menu_items
      post :bulk_update
      post :create_menu
      post :create_promotions
      get :get_promotion_type
      get :new_menu_item
      get :bulk_edit_photo
      post :create_photo
      post :create_comments
      get :show_comments
      get :get_qotds
      get :get_newsfeed
      post :push_notification_user
      get :get_admin_conversation_discussions
      get :get_media_request
      post :api_register
    end  
  end

  match '/restaurants/:restaurant_id/employees/options' => 'employees#options', :as => :no_choice
  match 'restaurants/:restaurant_id/employees/new_employee' => 'employees#new_employee', :as => :new_employee
  resources :otm_keywords, :only => ["index"]
  # resources :auto_complete, :only => ["index"]
  match "auto_complete/index" => "auto_complete#index"
  resources :metropolitan_areas, :only => ["index"]
  resources :james_beard_regions, :only => ["index"]
  resources :cuisines, :only => ["index"]
  resources :specialties, :only => ["index"]
  match 'directory/search_restaurant_by_name' => 'directory#search_restaurant_by_name', :as => :search_restaurant_by_name
  match 'directory/search_user' => 'directory#search_user', :as => :search_user
  # match '/mediafeed/media_users/get_selected_cities' => 'media_users#get_selected_cities', :as => :get_selected_cities
  match '/restaurants/:restaurant_id/newsletters/get_opened_campaign/:campaign_id' => 'restaurants/newsletters#get_opened_campaign', :as => :get_opened_campaign
  match '/restaurants/:restaurant_id/newsletters/get_clicked_campaign/:campaign_id' => 'restaurants/newsletters#get_clicked_campaign', :as => :get_clicked_campaign
  match '/restaurants/:restaurant_id/newsletters/get_bounces_campaign/:campaign_id' => 'restaurants/newsletters#get_bounces_campaign', :as => :get_bounces_campaign
end
