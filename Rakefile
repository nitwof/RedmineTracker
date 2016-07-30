task default: %w[run]

task :run do
  ruby 'bin/redmine_tracker.rb'
end

task :test do
  system 'rspec spec'
end

namespace :db do
  task :migrate do
    require './config/environment'
    ActiveRecord::Migrator.migrate('migrate',
                                   (ENV['VERSION'].to_i if ENV['VERSION']))
  end
end
