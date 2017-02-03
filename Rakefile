#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Depot::Application.load_tasks

namespace :db do
  desc "Load seed fixtures (from db/fixtures) into the current environment's database."
  task :seed => :environment do
    require 'active_record/fixtures'
    Dir.glob(Rails.root.to_s + '/db/fixtures/*.yml').each do |file|
      ActiveRecord::Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
    end
  end
end

