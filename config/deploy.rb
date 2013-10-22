set :application, "ria"

set :scm, :git
set :repository,  "git@github.com:RestaurantIntelligenceAgency/ria.git"
set :branch, (ENV["DEPLOY_BRANCH"] || 'master')
set :git_enable_submodules, 1
set :use_sudo, false

default_run_options[:pty] = true

##
# == Staging environment
#
# From the command line:
#   cap deploy
#
# Default to staging
set :server_ip, 'dh03172010.highlandgroupinc.com'
set :stage, 'staging'
set :nickname, (ENV["NICKNAME"] || 'cashew')
role :web, server_ip
role :app, server_ip
role :db, server_ip, :primary => true

set :Rails.env, :staging
set :deploy_to, "/srv/httpd/staging/#{nickname}/"
set :robots_file, "robots_staging.txt"

ssh_options[:port] = nil
set :user, "deployer"

##
# == Production environment
#
# From the command line:
#   cap production deploy
#   cap production deploy:migrations # Deploy to production AND run migrations
#
desc "Deploy to production instead: 'cap production deploy'"
task :production do
  set :stage, 'production'
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
  set :Rails.env, :production
  set :deploy_to, "/srv/httpd/spoonfeed.restaurantintelligenceagency.com/"
  set :robots_file, "robots_production.txt"
end

desc "Run a Rake task remotely. Set the task with RAKE_TASK='your task here'"
task :rake do
  if ENV["RAKE_TASK"]
    run "cd #{current_path} && rake Rails.env=#{Rails.env} #{ENV["RAKE_TASK"]}"
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
    run "ln -nfs #{shared_path}/email_logs/ #{release_path}/public/email_logs"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{current_path} && whenever --update-crontab #{Rails.env}"
  end

  # desc "build missing paperclip styles"
  # task :build_missing_paperclip_styles, :roles => :app do
  #   run "cd #{release_path}; Rails.env=#{Rails.env} rake paperclip:refresh class=User"
  # end

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
    run("cd #{deploy_to}/current; rake db:seed Rails.env=#{Rails.env}")
  end
end

namespace :sync do
  task :default do; db && data; end

  desc <<-DESC
  Syncs database from the selected mutli_stage environement to the local develoment environment.
  The database credentials will be read from your local config/database.yml file and a copy of the
  dump will be kept within the shared sync directory. It assumes that you're using mysql for both
  the remote and the local development environment.
  DESC
  task :db, :roles => :db, :only => { :primary => true } do

    filename = "database.#{stage}.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql.bz2"
    on_rollback { delete "#{shared_path}/sync/#{filename}" }

    # Remote DB dump
    username, password, database = database_config(stage)
    run "mysqldump -u #{username} --password='#{password}' #{database} | bzip2 -9 > #{shared_path}/sync/#{filename}" do |channel, stream, data|
      puts data
    end

    # Download dump
    download "#{shared_path}/sync/#{filename}", filename

    # Local DB import
    username, password, database = database_config('development')
    system "bzip2 -d -c #{filename} | mysql -u #{username} --password='#{password}' #{database}; rm -f #{filename}"

    logger.important "sync database from the stage '#{stage}' to local finished"
  end

  desc "Sync down system folder (avatars and uploads)"
  task :data do
    system("rsync -auvz #{user}@#{application}:#{shared_path}/system public/")
  end

  #
  # Reads the database credentials from the local config/database.yml file
  # +db+ the name of the environment to get the credentials for
  # Returns username, password, database
  #
  def database_config(db)
    database = YAML::load_file('config/database.yml')
    return database["#{db}"]['username'], database["#{db}"]['password'], database["#{db}"]['database']
  end

  #
  # Returns the actual host name to sync and port
  #
  def host_and_port
    return roles[:web].servers.first.host, ssh_options[:port] || roles[:web].servers.first.port || 22
  end
end

namespace :compass do
  desc 'Updates the stylesheets generated by Sass'
  task :compile, :roles => :app do
    invoke_command "cd #{latest_release}; Rails.env=#{Rails.env} compass compile --force"
  end

  # Generate all the stylesheets manually (from their Sass templates) before each restart.
end

task :logs, :roles => :app do 
  run "cd #{current_path}; Rails.env=#{Rails.env} tail -f log/#{Rails.env}.log"
end

task :update_robots do
  desc "Setting correct robots.txt for environment"
  run "cp #{release_path}/public/#{robots_file} #{release_path}/public/robots.txt"
end

before 'deploy:restart', 'compass:compile'
after "deploy:symlink", "deploy:update_crontab"
after 'deploy:update_code', 'deploy:symlink_shared'
# after("deploy:update_code", "deploy:build_missing_paperclip_styles")
after 'deploy:update_code', 'update_robots'

before "deploy:update_code", "bluepill:stop"
after "deploy:restart",  "bluepill:start"

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'airbrake-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'airbrake/capistrano'
