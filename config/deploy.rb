set :application, "ria"

set :server_ip, 'spoonfeed.restaurantintelligenceagency.com'
ssh_options[:port] = 7822


role :app, server_ip
role :web, server_ip
role :db,  server_ip, :primary => true

set :user, "ria"
set :use_sudo, false

set :scm, :git
set :repository,  "git@code.neotericdesign.com:ria.git"
set :branch, 'master'
set :git_enable_submodules, 1

set :deploy_to, "/home/ria/rails"
set :deploy_via, :remote_cache

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
  end
end

namespace :db do
  desc "Seed the database with configured seedlings"
  task :seed do
    run("cd #{deploy_to}/current; /usr/bin/rake db:seed RAILS_ENV=production")
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'