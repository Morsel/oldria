ActionController::Routing::Routes.draw do |map|
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'
  map.fb_login 'facebook_login', :controller => 'user_sessions', :action => 'create_from_facebook'
  map.social_media 'social_media', :controller => 'social_media', :action => 'index'
  map.feature '/features/:id', :controller => 'features', :action => 'show'
  map.resources :invitations, :only => ['new', 'create', 'show'],
        :collection => { :recommend => :get, :submit_recommendation => :post }
  map.resource :complete_registration, :only => [:show, :update],
    :collection => { :user_details => :get, :find_restaurant => :any, :contact_restaurant => :post,
      :finish_without_contact => :get }

  map.directory 'directory', :controller => 'directory', :action => 'index'

  map.namespace(:soapbox) do |soapbox|
    soapbox.resources :restaurants, :only => ['show'] do |restaurants|
      restaurants.resources :feature_pages, :only => ['show'] do |pages|
        pages.resources :questions, :collection => { :topics => :get, :chapters => :get, :refresh => :post }
      end
      restaurants.resources :questions, :collection => { :topics => :get, :chapters => :get, :refresh => :post }
      restaurants.resources :photos, :only => ['show', 'index']
      restaurants.resources :accolades, :only => ['index']
    end
    soapbox.resources :restaurant_features, :only => ["show"]
    soapbox.resources :a_la_minute_questions, :only => ['index', 'show']
    soapbox.resources :soapbox_entries, :only => ['index','show'], :as => "front_burner"
    soapbox.resources :users do |users|
      users.resources :questions, :collection => { :topics => :get, :chapters => :get }
    end
    soapbox.resources :questions, :only => 'show'
    soapbox.connect 'directory_search', :controller => 'soapbox', :action => 'directory_search'
    soapbox.root :controller => 'soapbox', :action => 'index'
  end

  map.soapbox_profile 'soapbox/profile/:username', :controller => 'soapbox/profiles', :action => 'show',
      :requirements => { :username => /[a-zA-Z0-9\-\_ ]+/}

  map.soapbox_directory 'soapbox/directory', :controller => 'soapbox/soapbox', :action => 'directory'

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
  end

  map.with_options :conditions => { :subdomain => 'mediafeed' }, :controller => 'mediafeed/mediafeed' do |mediafeed|
    mediafeed.root :action => 'index'
  end

  map.resource :my_profile, :only => ['create', 'edit', 'update'], :controller => 'profiles' do |p|
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

  map.profile 'profile/:username', :controller => 'users', :action => 'show', :requirements => { :username => /[a-zA-Z0-9\-\_ ]+/}

  map.resources :quick_replies
  map.resources :media_users, :except => [:index, :show]
  map.resources :media_requests, :except => [:index]
  map.resources :media_request_discussions, :only => [:show, :update] do |mrc|
    mrc.resources :comments, :only => [:new, :create]
  end

  map.resources :discussions, :member => { :read => :put } do |discussions|
    discussions.resources :comments, :only => [:new, :create]
  end

  map.resources :conversations

  map.resources :users, :collection => { :resend_confirmation => :any }, :member => {
    :remove_twitter => :put,
    :remove_avatar => :put,
    :fb_auth => :get,
    :fb_connect => :any,
    :fb_deauth => :any,
    :fb_page_auth => :post
  }, :shallow => true do |users|
    users.resources :statuses
    users.resources :direct_messages, :member => { :reply => :get }
    users.resources :questions, :collection => { :topics => :get, :chapters => :get, :refresh => :post }
    users.resources :default_employments
    users.resource :subscription, :collection => { :bt_callback => :get, :billing_history => :get }, :controller => 'subscriptions'
  end

  map.resources :users do |users|
    users.resources :profile_answers, :only => [:create, :update, :destroy]
  end

  map.resources :restaurants,
                :member => {
                        :edit_logo => :get,
                        :select_primary_photo => :post,
                        :new_manager_needed => :get,
                        :replace_manager => :post
                } do |restaurant|
    restaurant.resource :fact_sheet, :controller => "restaurant_fact_sheets"
    restaurant.media_requests 'media_requests', :controller => 'media_requests', :action => 'index'
    restaurant.resources :employees, :collection => { :bulk_edit => :get }, :except => [:show, :index]
    restaurant.resources :calendars, :collection => { "ria" => :get }
    restaurant.resources :events, :member => { "ria_details" => :get, "transfer" => :post }
    restaurant.resources :features, :controller => "restaurant_features",
                                    :member => { :add => :post, :bulk_edit => :get }, 
                                    :collection => { :edit_top => :get, :update_top => :post } do |features|
      features.resources :questions, :collection => { :topics => :get, :chapters => :get, :refresh => :post }
      features.resources :profile_answers, :only => [:create, :update, :destroy]
    end
    restaurant.resources :feature_pages
    restaurant.resources :menus, :collection => { "reorder" => :post, :bulk_edit => :get }
    restaurant.resources :photos, :collection => { "reorder" => :post, "bulk_edit" => :get }, :member => { "show_sizes" => :get }
    restaurant.resource :logo
    restaurant.resources :accolades
    restaurant.resources :questions, :collection => { :topics => :get, :chapters => :get, :refresh => :post }
    restaurant.resources :profile_answers, :only => [:create, :update, :destroy]
    restaurant.resources :employments, :collection => { "reorder" => :post }
    #todo only need these two routes
    restaurant.resources :a_la_minute_answers, :collection => { :bulk_update => :put, :bulk_edit => :get }
    restaurant.resource :subscription, :collection => { :bt_callback => :get, :billing_history => :get }, :controller => 'subscriptions'
    restaurant.resource :employee_accounts, :only => [:create, :destroy]
    restaurant.resources
  end

  map.resources :user_sessions, :password_resets, :followings, :pages

  map.resources :direct_messages, :member => { :read => :put }

  map.resources :holiday_conversations, :only => ['show','update'] do |holiday_conversations|
    holiday_conversations.resources :comments, :only => [:new, :create]
  end

  map.resources :holiday_discussions, :member => { :read => :put }, :only => ['show','update'] do |holiday_discussions|
    holiday_discussions.resources :comments, :only => [:new, :create]
  end

  map.resources :holiday_discussion_reminders, :member => { :read => :put }

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

  map.resource :search, :only => 'show'

  map.root :controller => 'welcome'

  map.namespace :admin do |admin|
    admin.root      :controller => 'admin'

    # the BTL routes need to be above the users and restaurants routes to prevent path conflicts
    admin.with_options :path_prefix => '/admin/:responder_type',
        :requirements => { :responder_type => /user|restaurant/ } do |btl|
      btl.resources :profile_questions, :collection => { :sort => :post }
      btl.resources :chapters, :collection => { :select => :post }
      btl.resources :topics
    end

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
    admin.resources :soapbox_pages
    admin.resources :hq_pages
    admin.resources :mediafeed_pages
    admin.resources :soapbox_slides, :collection => { :sort => :post }
    admin.resources :soapbox_promos, :collection => { :sort => :post }

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

    admin.resources :sf_slides, :collection => { :sort => :post }
    admin.resources :sf_promos, :collection => { :sort => :post }

    admin.resources :hq_slides, :collection => { :sort => :post }
    admin.resources :hq_promos, :collection => { :sort => :post }
    
    admin.resources :mediafeed_slides, :collection => { :sort => :post }
    admin.resources :mediafeed_promos, :collection => { :sort => :post }

    admin.resources :metropolitan_areas, :only => [:index, :edit, :update]

    # Admin Messaging
    exclusive_routes = [:index, :show, :destroy]
    admin.resources :messages, :only => exclusive_routes
    admin.resources :qotds, :except => exclusive_routes
    admin.resources :announcements, :except => exclusive_routes
    admin.resources :pr_tips, :except => exclusive_routes
    admin.resources :holiday_reminders, :except => exclusive_routes
    admin.resources :content_requests
    admin.resources :trend_questions

    admin.resource :complimentary_accounts, :only => [:create, :destroy]
  end

  map.public_page ":id", :controller => 'pages', :action => 'show'
  map.soapbox_page 'soapbox/:id', :controller => 'soapbox_pages', :action => 'show'
  map.hq_page 'hq/:id', :controller => 'hq_pages', :action => 'show'
  map.mediafeed_page 'mediafeed/:id', :controller => 'mediafeed_pages', :action => 'show'

  # Default Routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
