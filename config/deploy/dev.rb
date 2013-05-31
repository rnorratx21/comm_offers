set :application, "dev.communityoffers.com"
set :rails_env, "development"
set :deploy_to, "/var/www/#{application}"

role :app, "#{application}"
role :web, "#{application}"
