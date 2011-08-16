set :application, "mobonotes"

# Remote Server Settings
set :user, proc { Capistrano::CLI.ui.ask("DEPLOYER username:") }
set :password, proc { Capistrano::CLI.password_prompt("DEPLOYER password:") }
set :deploy_to, "/var/www/#{application}"

# Source Code Control
set :scm, :git
set :repository,  "git@smiams.beanstalkapp.com:/mobonotes.git"
# set :scm_username, proc { Capistrano::CLI.ui.ask('beanstalk username:') }
# set :scm_password, proc { Capistrano::CLI.password_prompt('beanstalk password:') }
set :copy_exclude, ".git"

default_run_options[:pty] = true

# Locations
role :app, "72.14.182.204"
role :web, "72.14.182.204"
role :db,  "72.14.182.204", :primary => true

set :deploy_via, :remote_cache

namespace :deploy do
  desc "This restarts Phusion Passenger"
  task :restart, :roles => :web do
    run "touch #{current_path}/tmp/restart.txt"
  end
end