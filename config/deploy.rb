require 'capistrano/ext/multistage'

set :default_stage, "dev"

set :user, "root"
set :ssh_options, { :forward_agent => true }

set :scm, :git
set :repository, "git@github.com:coffers/community-offers.git"
set :branch, ENV['branch'] || "origin/#{`git branch`.scan(/^\* (\S+)/)}"

`ssh-add`

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

def rake(task)
  run "cd #{current_path}; rake RAILS_ENV=#{rails_env} #{task}"
end

namespace :deploy do
  desc "Deploy app"
  task :default do
    update
    restart
    cleanup
  end
 
  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{releases_path}"
    run "git clone #{repository} #{current_path}"
    run "cp #{current_path}/config/database.yml.example #{shared_path}/config/database.yml"
    run "mkdir -p #{current_path}/tmp"
    run "mkdir -p #{current_path}/public/uploads"
    run "chmod -R a+w #{current_path}/public/uploads"
    run "mkdir -p #{current_path}/log"
    run "chmod a+w #{current_path}/log"
    run "chmod a+w #{current_path}/public/javascripts"
    run "chmod a+w #{current_path}/public/stylesheets"
  end
 
  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    run "rm -f #{current_path}/public/stylesheets/all.css"
    run "rm -f #{current_path}/public/javascripts/all.js"
  end

  desc "Deploy and run migrations"
  task :migrations, :except => { :no_release => true } do
    update
    migrate
    restart
    cleanup
  end

  desc "Run pending migrations on already deployed code"
  task :migrate, :except => { :no_release => true } do
    rake "db:migrate"
  end

  desc "Seeds the database"
  task :seed, :except => { :no_release => true } do
    rake "db:seed"
  end

  desc "Deploys and resets the database"
  task :reset, :except => { :no_release => true } do
    update
    
    rake "db:drop"
    rake "db:create"    
    
    migrate
    seed
    
    rake "examples:create"
    rake "affiliate_offers:load"
    rake "admins:create"

    restart
    cleanup
  end
  
  namespace :affiliate_offers do
    desc "Loads affiliate offer data"
    task :update do
      rake "affiliate_offers:load"
    end

    desc "Updates existing affiliate offer data"
    task :update do
      rake "affiliate_offers:update"
    end
  end

  
 
  namespace :rollback do
    desc "Rollback"
    task :default do
      code
    end
    
    desc "Rollback a single commit."
    task :code, :except => { :no_release => true } do
      set :branch, "HEAD^"
      default
    end
  end
    
  desc "Make all the symlinks"
  task :symlink, :roles => :app, :except => { :no_release => true } do    
    %w(config/database.yml config/authorize_net_cim.yml config/gateway.yml).each do |path|
      run "ln -fs #{shared_path}/#{path} #{current_path}/#{path}"
    end
  end
  
  # override default tasks to make capistrano happy
  desc "Kick Passenger"
  task :start do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Kick Passenger"
  task :restart do
    stop
    start
  end

  desc "Kick Passenger"
  task :stop do
  end
end


#Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
#  $: << File.join(vendored_notifier, 'lib')
#end

#require 'hoptoad_notifier/capistrano'
