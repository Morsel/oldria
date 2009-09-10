ActionController::Routing::Routes.draw do |map|
  map.resources :followings

  map.resources :pages

  map.signup 'signup', :controller => 'users', :action => 'new'
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'

  map.profile 'profile/:username', :controller => 'users', :action => 'show'

  map.resources :users, :has_many => 'statuses', :member => { 
    :remove_twitter => :put,
    :remove_avatar => :put 
  }

  map.resources :user_sessions, :password_resets

  map.resource :twitter_authorization
  map.resource :friend_timeline, :only => 'show'
  
  map.resource :search, :only => 'show'

  map.root :controller => 'welcome'
  
  map.namespace :admin do |admin|
    admin.root      :controller => 'admin'
    admin.resources :users
    admin.resources :pages
    admin.resources :date_ranges, :account_types, :coached_status_updates
  end

  # Default Routes 
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
