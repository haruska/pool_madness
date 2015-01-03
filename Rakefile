# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks

if Rails.env.development? || Rails.env.test?
  # Rubocop
  require "rubocop/rake_task"
  RuboCop::RakeTask.new

  # task(:default).clear.enhance(%w(rubocop spec))
  task(:default).clear.enhance(%w(spec))
end
