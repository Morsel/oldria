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

  map.resources :users, :member => { 
    :remove_twitter => :put, 
    :remove_avatar => :put
  }, :shallow => true do |users|
    users.resources :statuses
    users.resources :direct_messages, :member => { :reply => :get }
  end

  map.resources :user_sessions, :password_resets, :followings, :pages, :direct_messages
  map.resource :twitter_authorization
  map.resource :friend_timeline, :only => 'show'
  
  map.resource :search, :only => 'show'

  map.root :controller => 'welcome'
  
  map.namespace :admin do |admin|
    admin.root      :controller => 'admin'
    admin.resources :users
    admin.resources :pages
    admin.resources :date_ranges, :account_types, :coached_status_updates, :direct_messages
  end

  # Default Routes 
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
