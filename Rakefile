# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks

if Rails.env.development? || Rails.env.test?
  # Jasmine
  require "rspec/core/rake_task"

  desc "Build Webpack bundle"
  task :webpack do
    puts "\nRunning `webpack`"
    puts `./node_modules/.bin/webpack`
    puts "Webpack finished building\n\n"
  end

  desc "Run eslint"
  task :eslint do
    puts
    puts "Running eslint..."
    output = `standard`
    if output.blank?
      puts "eslint complete"
    else
      puts output
      exit 1
    end
  end

  namespace :spec do
    desc "runs integration tests only"
    RSpec::Core::RakeTask.new(:integration) do |t|
      t.pattern = "spec/features/**/*_spec.rb"
      t.rspec_opts = "--tag js"
    end

    desc "Run all test suites"
    task :all do
      Rake::Task["spec"].invoke
      Rake::Task["spec:integration"].invoke
      # Rake::Task["teaspoon"].invoke
    end
  end

  # Rubocop
  require "rubocop/rake_task"
  RuboCop::RakeTask.new

  # GraphQL
  desc "Generate graphql schema json"
  task graph: :environment do
    puts "\nGenerating graphql schema json"
    schema_data = GraphqlSchema.execute(GraphQL::Introspection::INTROSPECTION_QUERY)
    pretty_json = JSON.pretty_generate(schema_data)
    File.open("schema.json", "w") { |f| f.write(pretty_json) }
    puts "Finished generating graphql schema json\n"
  end

  task(:default).clear.enhance(%w[rubocop eslint graph webpack spec])
end

if Rails.env.generator?
  require "capybara/rails"
  require "capybara/dsl"
  Capybara::Screenshot.webkit_options = { width: 2550, height: 3300 }
end
