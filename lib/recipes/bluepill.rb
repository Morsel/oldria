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


after "deploy:update", "bluepill:quit"
after "delayed_job:restart", "bluepill:start"

namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    sudo "bluepill stop"
    sudo "bluepill quit"
  end

  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    sudo "bluepill load #{current_path}/config/#{rails_env}.pill"
  end

  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    sudo "bluepill status"
  end
end