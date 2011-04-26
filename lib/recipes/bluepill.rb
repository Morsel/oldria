# http://blog.plataformatec.com.br/2010/02/monitoring-delayed-job-with-bluepill-and-capistrano/
#
# Bluepill related tasks
#
# A line needs to be added to the sudoers file for this to work:
#
#   deploy ALL=(ALL) NOPASSWD: /usr/local/bin/bluepill
#
# Or wherever bluepill is installed. On some of our servers, it is at
#   /opt/ruby-enterprise-1.8.7-2009.10/bin/bluepill

namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    if rails_env == :production
      sudo "bluepill #{rails_env} stop"
      sudo "bluepill #{rails_env} quit"
    else
      sudo "bluepill #{nickname} stop"
      sudo "bluepill #{nickname} quit"
    end
  end

  desc "Stop processes that bluepill is monitoring"
  task :stop, :roles => [:app] do
    if rails_env == :production
      sudo "bluepill #{rails_env} stop"
    else
      sudo "bluepill #{nickname} stop"
    end
  end

  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    if rails_env == :production
      sudo "bluepill load #{current_path}/config/#{rails_env}.pill"
    else
      sudo "bluepill load #{current_path}/config/#{nickname}.pill"
    end
  end

  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    if rails_env == :production
      sudo "bluepill #{rails_env} status"
    else
      sudo "bluepill #{nickname} status"
    end
  end
end