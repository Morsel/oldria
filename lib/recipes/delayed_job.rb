# Capistrano Recipes for managing delayed_job
#
# Add these callbacks to have the delayed_job process restart when the server
# is restarted:
#
#   after "deploy:stop",    "delayed_job:stop"
#   after "deploy:start",   "delayed_job:start"
#   after "deploy:restart", "delayed_job:restart"

namespace :delayed_job do
  def delayed_job_cmd
    "cd #{current_path}; Rails.env=#{Rails.env} script/delayed_job"
  end

  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "#{delayed_job_cmd} stop"
  end

  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "#{delayed_job_cmd} start"
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "#{delayed_job_cmd} restart"
  end
end