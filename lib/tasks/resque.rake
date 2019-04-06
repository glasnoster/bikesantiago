# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup_schedule => :setup do
    require 'resque-scheduler'
    require 'resque/server'
    require 'resque/scheduler/server'
    require 'active_scheduler'

    yaml_schedule    = YAML.load_file("#{Rails.root}/config/resque_schedule.yml") || {}
    wrapped_schedule = ActiveScheduler::ResqueWrapper.wrap yaml_schedule
    Resque.schedule  = wrapped_schedule
  end

  task :scheduler => :setup_schedule
end