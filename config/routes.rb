ActionController::Routing::Routes.draw do |map|

  map.signup 'signup', :controller => 'users', :action => 'new'
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.confirm 'confirm/:id', :controller => 'users', :action => 'confirm'
  
  map.resources :users, :user_sessions

  map.root :controller => 'welcome'
  # Default Routes 
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
