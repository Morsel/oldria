set :application, "ria"

set :scm, :git
set :repository,  "git@code.neotericdesign.com:ria.git"
set :branch, 'master'
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true


##
# == Staging environment
#
# From the command line:
#   cap deploy
#
# Default to staging
set :server_ip, '174.132.251.233'
role :web, server_ip
role :app, server_ip
role :db, server_ip, :primary => true

set :rails_env, :staging
set :deploy_to, "/home/ria/staging"

ssh_options[:port] = 7822
set :user, "ria"
set :branch, "private-discussions"

##
# == Production environment
#
# From the command line:
#   cap production deploy
#   cap production deploy:migrations # Deploy to production AND run migrations
#
desc "Deploy to production instead: 'cap production deploy'"
task :production do
  unset :server_ip
  @roles.clear # Hack to empty the hash
  set :server_ip, 'dh03172010.highlandgroupinc.com'
  set :servers, nil
  role :web, server_ip
  role :app, server_ip
  role :db, server_ip, :primary => true
  ssh_options[:port] = nil

  set :user, "deployer"

  set :branch, 'production'
  set :rails_env, :production
  set :deploy_to, "/srv/httpd/spoonfeed.restaurantintelligenceagency.com/"
end


desc "Run a Rake task remotely. Set the task with RAKE_TASK='your task here'"
task :rake do
  if ENV["RAKE_TASK"]
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} #{ENV["RAKE_TASK"]}"
  else
    puts "You need to set a task with RAKE_TASK='task here'"
  end
end

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    #run "ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{current_path} && whenever --update-crontab #{rails_env}"
  end

  namespace :web do
    task :disable, :roles => :web do
      # invoke with
      # UNTIL="16:00 MST" REASON="a database upgrade" cap production deploy:web:disable

      on_rollback { rm "#{shared_path}/system/maintenance.html" }

      require 'erb'
      deadline, reason = ENV['UNTIL'], ENV['REASON']
      maintenance = ERB.new(File.read("./app/views/layouts/maintenance.html.erb")).result(binding)

      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
end

namespace :db do
  desc "Seed the database with configured seedlings"
  task :seed do
    run("cd #{deploy_to}/current; rake db:seed RAILS_ENV=#{rails_env}")
  end
end

namespace :sync do
  desc "Sync down system folder (avatars)"
  task :avatars do
    system("rsync -auvz #{user}@#{application}:#{shared_path}/system public/")
  end
end

after "deploy:symlink", "deploy:update_crontab"
after 'deploy:update_code', 'deploy:symlink_shared'

# Delayed Job callbacks:
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
