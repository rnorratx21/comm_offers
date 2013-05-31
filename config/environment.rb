# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.

  %w(view_models observers mailers searchers).each do |dir|
    config.load_paths << File.join(RAILS_ROOT, "app", dir)
  end
  config.load_paths << File.join(RAILS_ROOT, "app", "models", "billing")

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "eventmachine", :version => "0.12.8"  # 0.12.10 is not working with rufus scheduler
  config.gem "tmm1-amqp", :lib => "amqp", :version =>"0.6.4", :source => "http://gems.github.com"
  config.gem 'will_paginate', :version => '2.3.11', :source => 'http://gemcutter.org'
  config.gem 'validatable', :version => '1.6.7'
  config.gem 'rsolr', :source => 'http://gemcutter.org'#, :version => '0.9.6'
  config.gem 'sunspot', :lib => 'sunspot'#, :version => '0.10.6'
  config.gem 'sunspot_rails', :lib => 'sunspot/rails'#, :version => '0.11.2'
  config.gem 'geokit'
  config.gem 'factory_girl', :lib => 'factory_girl', :source => 'http://gemcutter.org'
  config.gem 'faker'
  config.gem 'authlogic'
  config.gem "cancan"
  config.gem "carrierwave", :source => 'http://gemcutter.org'
  config.gem 'mad_mimi_mailer', :source => 'http://gemcutter.org'
  config.gem "aasm"
  config.gem "mousetrap", :source => 'http://gemcutter.org'
  config.gem 'acts_as_audited', :lib => false, :source => 'http://gemcutter.org'
  config.gem 'hoptoad_notifier'
  config.gem 'RedCloth'
  config.gem 'activemerchant', :lib => 'active_merchant'#, :version => '1.4.2'
  config.gem 'haml'
  config.gem 'recurrence'


  # Start AMQP after rails loads:
  config.after_initialize do
    Qusion.start # no options needed if you're using config/amqp.yml or the default settings.
  end

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  #config.active_record.observers = :geocode_observer, :async_observer, :audit_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

end
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :default => '%m/%d/%Y'
)

require 'hash'
require 'array'
require 'exceptions'
