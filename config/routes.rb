ActionController::Routing::Routes.draw do |map|

  # map.wifi_soft_login '/portal/iimr/login.php', :controller => 'wifi_soft', :action => 'login'
  map.resource :wifi_soft, :controller => 'wifi_soft', :only => [], :member => {
    :sample => :get,
    :login => :get,
    :complete_registration => :post,
    :complete_connection => :get,
    :clear_session => :get,
    :welcome => :get,
    :udp_access => :post,
    :udp_logged => :get,
    :processing => :get
    # wifi_soft.login 'login', :action => 'login'
  } 

  map.ledger 'billing/:id/ledger', :controller => 'billing', :action => 'ledger'
  map.statement 'billing/:id/:other_id', :controller => 'billing', :action => 'statement', :id => /\d+/, :other_id => nil
  map.document 'billing/document/:id', :controller => 'billing', :action => 'document'


  map.with_options(:controller => 'home') do |home|
    home.root
    home.company 'company', :action => "company"
    home.about_team "about/team", :action => "about_team"
    home.about_philosophy "about/philosophy", :action => "about_philosophy"
    home.smart_savings "smart_savings", :action => "smart_savings"
    home.contact "contact", :action => "contact"
    home.help "help", :action => "help"
    home.terms "terms", :action => "terms"
    home.privacy "privacy", :action => "privacy"
    home.advertise "advertise", :action => "advertise"
    home.advertiser_agreement "advertiser_agreement", :action => "advertiser_agreement"
    home.pingdom "pingdom", :action => "pingdom"
    home.mobile_offers "mobile_offers", :action => "mobile_offers"
    home.sitemap_xml 'sitemap.:suffix', :action => "sitemap"
    home.sitemap 'sitemap', :action => "sitemap"
  end

  map.resources :test_payments   # For testing cheddar/authorize.net
  map.resources :test_check_payments   # For testing cheddar w/check

  map.resources :offers, :only => [:index, :show], :member => { 
    :print => :get
  }, :collection => {
    :sms_redemption_get => :get,
    :sms_redemption_post => :post# ,
    #     
    #     :sms_redemption => :post
  }
  map.resources :affiliate_offers , :only => [ :show ], :as => 'offers', :path_prefix => '/a'

  # This is the route that cheddar getter uses to callback
  # If this is changed then the cheddar getter account needs updating
  map.resources :transactions, :only => [ :create ]

  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :password_resets, :except => [ :index, :destroy, :show ]
  map.resources :facebook
  map.resources :inquiries, :only => [:new, :create]

  map.login "login", :controller => "user_sessions", :action => "new"
  map.login_ssl "login_ssl", :controller => "user_sessions", :action => "new_ssl"
  map.logout "logout", :controller => "user_sessions", :action => "destroy", :method => :delete
  map.register "register", :controller => "home", :action => "advertise"

  map.search 'search', :controller => 'search', :action => 'index'
  map.advanced_search 'search/advanced', :controller => 'search', :action => 'advanced'
  map.personalized_search 'search/personalized', :controller => 'search', :action => 'personalized'

  map.demo 'demo', :controller => 'admin/offers', :action => 'demo'

  map.resource :advertiser, :controller => "advertiser", :member => {
    :activity => :get,
    :edit_logo => :get,
    :update_logo => :put
  }


  map.namespace :advertiser do |advertiser|
    advertiser.resource :signup, :controller => 'signup', :member => {
      :new => :get,
      :create_user => :post,
      :advertiser_info => :get,
      :offer => :get,
      :plan => :get,
      :setup_plan_payment => :get,
      # :logo => :get,
      # :add_ons => :get,
      :preview => :get,
      # :agreement => :get,
      :payment => :get,
      # :previous => :put,
      :cancel => :put,
      # :apply_discount_code => :put
    }

    advertiser.resources :offers, :member => {
      :new_address => :get,
      :create_address => :put,
      :edit_address => :get,
      :update_address => :put,
      :add_zip => :get,
      :update_zip => :put,
      :delete_zip => :get,
      :edit_logo => :get,
      :update_logo => :put,
      :revert_logo => :get,
      :show_contract => :get
    }
    
    advertiser.resources :contracts, :only => [:show, :edit, :update] do |contract|
      contract.resources :invoices, :only => [:show]
    end
  end

  map.resource :merchant_dashboard, :controller => 'merchant_dashboard', :only => [], :member => {
    :offer_report => :get,
    :mobile_qr_scans => :get,
    :mobile_redemptions => :get,
    :mobile_app_views => :get,
    :web_page_views => :get,
    :web_visitors => :get,
    :badge => :get
  }

  map.namespace :admin do |admin|
    admin.root :controller => :offers, :action => "active"

    offer_state_actions = { 
      :without_plan => :get, 
      :without_contract => :get, 
      :with_contract => :get, 
      :by_zip_code => :get,
      :requesting_upgrade => :get
    }
    offer_state_actions = Offer.states.inject(offer_state_actions) { |hash, state| hash[state] = :get; hash }

    admin.resources :offers, :collection => offer_state_actions, :member => {:toggle_tabbed_out_status => :put}, :has_many => :audits, :has_one => :plan
    admin.resources :users, 
      :except => [:update],
      :collection => {:active => :get, :disabled => :get, :advertisers => :get, :unpose => :post }, 
      :member => { :pose => :post, :add_role => :post, :remove_role => :put, :activate => :put, :deactivate => :put }
    
    admin.resources :affiliate_offers, :member => { :enable => :post, :disable => :post }
    admin.resources :contracts, :member => {:credit_card => :any, :scanned_image => :get, :credit_card_destroy => :delete} do |contract|
      contract.resources :payments, :only => [:show] do |payments|
        payments.resources :credit_notes, :only => [:new, :create, :edit, :update]
      end
      contract.resources :invoices, :member => {:pay => :post, :mark_as_paid => :post}, :has_many => :payments
    end
    admin.resources :invoices, :collection => {:past_due => :get, :paid => :get}
    admin.resources :payments, :collection => { :paid_by_date => :get }
    admin.resources :advertisers, :has_many => :offers
    admin.resources :contract_plans
    admin.resources :category_types, :has_many => :categories
    admin.resources :roles 
    admin.resources :groups 
    admin.resources :features 
    admin.resources :discounts 
    admin.resources :group_contract_plans
    admin.resources :sales, :controller => :sales_reporting, :only => [:index], :collection => [:report]
    admin.resources :sales_areas, :member => {:add_zip_code => :post, :remove_zip_code => :delete }
    admin.resources :downloads, :only => [:index], 
      :collection => {
        :contracts => :get, 
        :invoices => :get, 
        :advertisers => :get, 
        :payments => :get, 
        :quickbooks_offers => :get,
        :quickbooks_invoices => :get
      }
    admin.resource :wifi, :controller => 'wifi', :member => {:for_contract => :get}
  end

  map.offer_permalink '/coupon/:city/:category/:permalink',#/:city_url/:category_url/:permalink', 
    :controller => 'offers', 
    :action => 'find_by_permalink'

  map.namespace :consumer do |consumer|
    consumer.dashboard "dashboard", :controller => 'users', :action => 'dashboard'
    consumer.resources :users, :collection => {:terms => :get} #, :collection => {:dashboard => :get}
    consumer.resource :preferences, 
      :member => {
        :add_zip_code => :post, 
        :remove_zip_code => :delete, 
        :add_category => :post, 
        :remove_category => :delete,
        # :update_email_preferences => :put
      }
    consumer.resources :tracked_offers, :collection => {:quick_add => :post}, :member => {:quick_remove => :delete}
  end

  map.resource :pervasive, :controller => 'pervasive', :only => [],
    :member => {
      :add_email_address => :post,
      :test => :get
    }

  map.namespace :partners do |partners|
    partners.resource :sessions, :only => [:new, :create, :destroy]
    partners.login 'login', :controller => 'sessions', :action => 'new'
    partners.logout 'logout', :controller => 'sessions', :action => 'destroy'
  end

  map.resources :api, :only => [:index]
  map.namespace :api do |api|
    api.namespace :partner do |partner|
      partner.resources :mappings, :only => [:new, :create, :destroy]
    end
    api.resources :offers, :only => [:index, :show],
      :collection => {
        :recently_disabled => :get,
        :attributes => :get
      },
      :member => {
        :changes => :get
      }
    api.resources :categories, :only => [:index],
      :collection => {
        :parents => :get
      }
  end

	map.namespace :test_support do |map|
	  map.connect 'settings/set/:name/:value', :controller => 'settings', :action => "set"
	  map.connect 'examples/:action', :controller => 'examples'
	  map.connect 'factory/:action', :controller => 'factory'
	  map.connect 'factory/:action/:value', :controller => 'factory'
	  map.connect 'factory/:action/:value/:id', :controller => 'factory'
	  map.connect 'offers/:action', :controller => 'offers'
	  map.connect 'offers/:action/:value', :controller => 'offers'
	end
	
end

