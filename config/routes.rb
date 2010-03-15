ActionController::Routing::Routes.draw do |map|
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'

  map.profile 'profile/:username', :controller => 'users', :action => 'show'

  map.resources :media_users, :except => [:index, :show]
  map.resources :media_requests, :except => [:index]
  map.resources :media_request_conversations, :only => [:show, :update] do |mrc|
    mrc.resources :comments, :only => [:new, :create]
  end

  map.resources :discussions do |discussions|
    discussions.resources :comments, :only => [:new, :create]
  end

  map.resources :users, :member => {
    :remove_twitter => :put,
    :remove_avatar => :put
  }, :shallow => true do |users|
    users.resources :statuses
    users.resources :direct_messages, :member => { :reply => :get }
  end

  map.resources :restaurants do |restaurant|
    restaurant.media_requests 'media_requests', :controller => 'media_requests', :action => 'index'
    restaurant.resources :employees, :except => [:show]
  end

  map.resources :user_sessions, :password_resets, :followings, :pages, :direct_messages

  map.resources :admin_conversations, :only => 'show' do |admin_conversations|
    admin_conversations.resources :comments, :only => [:new, :create]
  end
  map.resources :admin_messages, :only => 'show', :member => { :read => :put }
  map.resource :inbox, :only => 'show', :collection => {:archive => :get}

  map.resources :feed_entries, :only => 'show', :member => { :read => :put }
  map.resource :feeds


  map.resource :twitter_authorization
  map.resource :friend_timeline, :only => 'show'
  map.resource :friends_statuses, :only => 'show'
  map.resources :invitations, :only => 'show'

  map.resource :search, :only => 'show'

  map.root :controller => 'welcome'

  map.namespace :admin do |admin|
    admin.root      :controller => 'admin'
    admin.resources :users
    admin.resources :pages
    admin.resources :feeds, :collection => { :sort => [:post, :put] }
    admin.resources :feed_categories
    admin.resources :date_ranges, :account_types, :coached_status_updates, :direct_messages
    admin.resources :cuisines, :subject_matters, :restaurants
    admin.resources :media_requests, :member => { :approve => :put }
    admin.resources :restaurant_roles, :except => [:show]
    admin.resources :holidays

    # Admin Messaging
    exclusive_routes = [:index, :show, :destroy]
    admin.resources :messages, :only => exclusive_routes
    admin.resources :qotds, :except => exclusive_routes
    admin.resources :announcements, :except => exclusive_routes
    admin.resources :pr_tips, :except => exclusive_routes
    admin.resources :trend_questions, :except => exclusive_routes
    admin.resources :holiday_reminders, :except => exclusive_routes
    admin.resources :content_requests, :except => exclusive_routes
  end

  map.public_page ":id", :controller => 'pages', :action => 'show'

  # Default Routes
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
