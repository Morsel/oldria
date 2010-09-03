ActionController::Routing::Routes.draw do |map|
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'
  map.fb_login 'facebook_login', :controller => 'user_sessions', :action => 'create_from_facebook'

  map.directory 'directory', :controller => 'directory', :action => 'index'


  map.with_options :conditions => {:subdomain => 'soapbox'}, :controller => 'soapbox' do |soapbox|
    soapbox.root :action => 'index'
  end

  map.resources :soapbox, :only => ['index','show']

  map.resource :my_profile, :only => ['edit', 'update'], :controller => 'profiles' do |p|
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
  end

  map.profile 'profile/:username', :controller => 'users', :action => 'show', :requirements => { :username => /[a-zA-Z0-9\-\_ ]+/}
  map.profile_questions 'profile/:username/questions', :controller => 'profiles', :action => 'questions'

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
  end

  map.resources :restaurants do |restaurant|
    restaurant.media_requests 'media_requests', :controller => 'media_requests', :action => 'index'
    restaurant.resources :employees, :except => [:show]
    restaurant.resources :calendars, :collection => { "ria" => :get }
    restaurant.resources :events, :member => { "ria_details" => :get, "transfer" => :post }
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

  map.resources :admin_conversations, :only => 'show' do |admin_conversations|
    admin_conversations.resources :comments, :only => [:new, :create, :edit, :update]
  end

  map.resources :admin_discussions, :only => 'show', :member => { :read => :put } do |admin_discussions|
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
  map.resources :timelines, :collection => {
                              :people_you_follow => :get,
                              :twitter => :get,
                              :facebook => :get,
                              :activity_stream => :get
                            }

  map.resources :feed_entries, :only => 'show', :member => { :read => :put }
  map.resource :feeds
  map.resource :employment_search, :collection => { :add_user => :any, :add_restaurant => :any }

  map.resource :twitter_authorization
  map.resource :friends_statuses, :only => 'show'
  map.resources :invitations, :only => 'show', :collection => { :login => :get }
  map.resource :complete_registration, :only => [:show, :update]

  map.resource :search, :only => 'show'

  map.root :controller => 'welcome'

  map.namespace :admin do |admin|
    admin.root      :controller => 'admin'
    admin.resources :users
    admin.resources :pages
    admin.resources :feeds, :collection => { :sort => [:post, :put] }
    admin.resources :feed_categories
    admin.resources :date_ranges, :coached_status_updates, :direct_messages
    admin.resources :cuisines, :subject_matters, :restaurants
    admin.resources :media_requests, :member => { :approve => :put }
    admin.resources :restaurant_roles, :except => [:show]
    admin.resources :holidays
    admin.resources :calendars
    admin.resources :events
    admin.resources :soapbox_entries
    admin.resources :profile_questions, :collection => { :manage => :get, :sort => :post, :roles => :get, :update_role => :put }
    admin.resources :chapters, :collection => { :select => :post }
    admin.resources :topics
    admin.resources :question_roles
    admin.resources :schools
    admin.resources :specialties

    # Admin Messaging
    exclusive_routes = [:index, :show, :destroy]
    admin.resources :messages, :only => exclusive_routes
    admin.resources :qotds, :except => exclusive_routes
    admin.resources :announcements, :except => exclusive_routes
    admin.resources :pr_tips, :except => exclusive_routes
    admin.resources :holiday_reminders, :except => exclusive_routes

    admin.resources :content_requests
    admin.resources :trend_questions
  end

  map.public_page ":id", :controller => 'pages', :action => 'show'

  # Default Routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
