require "resque/tasks"
require 'resque_scheduler/tasks'

task 'resque:setup' => :environment do
	Resque.schedule = YAML.load_file("config/resque_schedule.yml")
  	ENV['QUEUE'] = '*'
end	

# namespace :resque do
#   puts "Loading Rails environment for Resque"
#   task :setup => :environment do
#     ActiveRecord::Base.descendants.each { |klass|  klass.columns }
#   end
# end