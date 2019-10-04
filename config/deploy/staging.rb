# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role

set :branch, 'develop'
set :deploy_to, '/home/deploy/beatricetate'

role :app, %w{deploy@128.199.105.196}
role :web, %w{deploy@128.199.105.196}
role :db,  %w{deploy@128.199.105.196}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '128.199.105.196', user: 'deploy', roles: %w{web app}, my_property: :my_value

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
 set :ssh_options, {
   keys: %w('~/.ssh/id_rsa.pub')
 }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options


set :stage, :staging

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end


  task :export do
    on roles(:app) do
      execute [
        "cd #{release_path} &&",
        'export rvmsudo_secure_path=0 && ',
        "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do",
        'rvmsudo',
        'RAILS_ENV=staging bundle exec foreman export --app beatricetate --user deploy -l /var/log -f ./Procfile upstart /etc/init -c worker=1,scheduler=1 -e environments/staging.env'
      ].join(' ')
    end
  end

  task :start do 
    on roles(:app) do
      execute :sudo, "start beatricetate"
    end
  end

  task :restart do 
    on roles(:app) do
      execute :sudo, "restart beatricetate"
    end
  end


  # task :default do
  #   update
  #   assets.precompile
  #   restart
  #   cleanup
  #   # etc
  # end

  # namespace :assets do
  #  desc "Precompile assets locally and then rsync to deploy server"
  #   task :precompile, :only => { :primary => true } do
  #     run_locally "bundle exec rake assets:precompile"
  #     servers = find_servers :roles => [:app], :except => { :no_release => true }
  #     servers.each do |server|
  #       run_locally "rsync -av ./public/#{assets_prefix}/ #{user}@#{server}:#{current_path}/public/#{assets_prefix}/"
  #     end
  #     run_locally "rm -rf public/#{assets_prefix}"
  #   end
  # end

  after :finishing, :cleanup
  
  after :publishing, :export
   after :publishing, :restart

  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
end

