#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Ria::Application.load_tasks
require 'rake'
require 'rake/testtask'
#require 'rake/rdoctask'

# require 'tasks/rails'

begin
  require 'delayed/tasks'
rescue LoadError
  STDERR.puts "Run `rake gems:install` to install delayed_job"
end

ENV['position_in_class']   = "before"
ENV['exclude_tests']       = "true"
ENV['exclude_fixtures']    = "true"
