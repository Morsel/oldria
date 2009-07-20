set :application, "ria"

set :server_ip, '174.132.251.233'
ssh_options[:port] = 7822


role :app, server_ip
role :web, server_ip
role :db,  server_ip, :primary => true

set :user, "ria"

set :scm, :git
set :repository,  "git@69.64.75.174:ria.git"
set :branch, 'master'
set :git_enable_submodules, 1

set :deploy_to, "/home/ria/railsapp"
set :deploy_via, :remote_cache

set :use_sudo, false

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'