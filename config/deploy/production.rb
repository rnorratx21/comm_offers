set :application, "communityoffers.com"

set :rails_env, "production"
set :deploy_to, "/var/www/www.#{application}"

role :app, "#{application}"
role :web, "#{application}"
