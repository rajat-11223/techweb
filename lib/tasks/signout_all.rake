# namespace :resque do
#   puts "Loading Rails environment for Resque"
#   task :setup => :environment do
#     ActiveRecord::Base.descendants.each { |klass|  klass.columns }
#   end
# end

namespace :db do
    namespace :sessions do
        desc "Clear ActiveRecord sessions"
        task :clear => :environment do
            sql = 'TRUNCATE sessions;'
            ActiveRecord::Base.connection.execute(sql)
        end
    end
end