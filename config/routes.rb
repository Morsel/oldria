ActionController::Routing::Routes.draw do |map|
  map.resources :date_ranges


  map.signup 'signup', :controller => 'users', :action => 'new'
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'


  map.resources :users, :has_many => 'statuses'
  map.resources :user_sessions, :password_resets

  map.resource :twitter_authorization
  map.resource :friend_timeline, :only => 'show'

  map.root :controller => 'welcome'

  # Default Routes 
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
