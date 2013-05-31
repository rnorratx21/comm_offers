# == Schema Information
#
# Table name: offers
#
#  id                    :integer         not null, primary key
#  advertiser_id         :integer
#  category_id           :integer
#  address_id            :integer
#  exclusive_zip_code_id :integer
#  headline              :string(255)
#  title                 :string(255)
#  description           :text
#  hours                 :string(255)
#  effective             :string(255)
#  expires_on            :date
#  payment_methods       :string(255)
#  mobile                :boolean         not null
#  state                 :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Offer < ActiveRecord::Base
  include Geokit::Mappable
  include AASM
  include Pervasive
  include PervasiveReporting

  acts_as_audited 

  attr_accessor :pervasive_update_flag, :payment_option_params

  belongs_to :advertiser
  belongs_to :category
  belongs_to :address  # We can't destroy the address because it might belong to an advertiser
  belongs_to :offer_address, :class_name => "Address", :foreign_key => "address_id"
  has_many :offers_zip_codes
  has_many :zip_codes, :through => :offers_zip_codes
  belongs_to :exclusive_zip_code, :class_name => "ZipCode"
#  has_one :plan, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :users, :through => :advertiser
  has_many :redeemable_timeframes, :class_name => "OfferRedeemableTimeframe"
  has_one :time_zone
  serialize :accepted_payment_types
  has_many :tracked_offers
  has_many :trackers, :through => :tracked_offers
  has_many :partner_mappings, :class_name => "PartnerOfferMapping"
  
  validates_presence_of :headline
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :hours
  validates_presence_of :effective
  # validates_presence_of :payment_methods
  validates_presence_of :category
  validates_presence_of :expires_on

  attr_accessor :new_address
  # accepts_nested_attributes_for :new_address
  accepts_nested_attributes_for :advertiser
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :offer_address # address gets overridden, so can be messy for checking changes
  accepts_nested_attributes_for :offers_zip_codes, :reject_if => proc {|a|
    a['']
  }
  accepts_nested_attributes_for :redeemable_timeframes

  API_PARAMETERS = {
    :only => [:id, :headline, :title, :description, :hours, :effective, :expires_on, :state, 
        :sms_marketing_info, :disclaimers, :category_id, :updated_at],
    :methods => [:business_name, :category_name, :category_full_name, :full_address, :payment_methods_text, :website_url, 
        :facebook_url, :twitter_url]
  }
  
  def to_json(opts=API_PARAMETERS)
    super opts
  end

  def to_xml(opts=API_PARAMETERS)
    super opts
  end
  
  def category_name
    category ? category.name : ""
  end
  
  def category_full_name
    category ? category.full_name : ""
  end
  
  def full_address
    address.full
  end

  before_save :check_permalink
  # before_validation :check_payment_option_params
  # def check_payment_option_params
  #   raise "payment opts: #{payment_option_params.inspect}, accepted_pmt_types: #{accepted_payment_types.inspect}"
  # end
  
  PAYMENT_TYPES = %w(cash check visa mc amex discover tabbed_out)
  def audits_with_advertiser
    Audit.all(:conditions => ["(auditable_type = 'Advertiser' and auditable_id = ?) or (auditable_type = 'Offer' and auditable_id = ?)", advertiser_id, id], :order => "created_at desc")
  end

  def new_defaults
    build_address
    self.disclaimers ||= "Not valid with any other offers. Limit one use per group, per day."
  end
  
  def complete_signup
    self.contract.update_attributes(:is_draft => false)
    self.approve
    save
  end

  def do_pervasive_update
    self.pervasive_update_flag = true
    self.update_pervasive
  end

  # In the event that Pervasive Tags goes down, comment out this line.
  before_save :update_pervasive
  # End comment out if Pervasive Tags goes down.
  
  def update_pervasive
    # return unless self.active?
    return if self.draft? or (self.pervasive_update_flag == false)
    return unless RAILS_ENV == 'production'
    notification_timestamp = Time.now.strftime("%Y-%m-%d_%H:%M:%S")
    
    begin
      rh = update_pervasive_page(self)
      if rh["page_uri"]
        self.mobile_uri = rh["page_uri"]
      end
      if rh["page_id"]
        self.pervasive_page_id = rh["page_id"]
        # self.advertiser.mobile_id = rh["page_id"]
        # advertiser_changed = true
      end
      if rh["mobile_org_id"]
        self.advertiser.mobile_org_id = rh["mobile_org_id"]
        advertiser_changed = true
      end
      if advertiser_changed
        self.advertiser.save
      end
      if rh["coupon_id"]
        self.mobile_id = rh["coupon_id"]
      end

      PervasiveNotifier.deliver_notification(
        "PERVASIVE - Succssful Update -- Offer #{self.id} - #{self.advertiser.name rescue ''} - #{notification_timestamp}",
        "Updated the following offer with no exceptions:\n #{self.inspect} \n\n
         ======== CHANGES: ======\n #{self.changes.inspect} \n ======= END CHANGES ======== \n\n
         ======== PERVASIVE LOGGING======\n
         #{rh['msg']}
         ======== END LOGGING ======"
      )
    rescue Exception => e
      PervasiveNotifier.deliver_notification(
        "PERVASIVE - UPDATE FAILED - Offer #{self.id} - #{self.advertiser.name rescue ''} - #{notification_timestamp} ", 
        %{UPDATING THE FOLLOWING OFFER FAILED WITH EXCEPTIONS: #{self.advertiser.name rescue ''} \n #{self.inspect} \n\n 
        ======== CHANGES: ======\n #{self.changes.inspect} \n ======= END CHANGES ======== \n\n 
        ======== PERVASIVE LOGGING======\n
        #{rh['msg'] rescue 'N/A'}
        ======== END LOGGING ======\n
        ======= EXCEPTION MSG ======:\n #{e.inspect} \n ======= END EXCEPTION MSG =======
        ======= EXCEPTION TRACE ======:\n #{e.backtrace} \n ======= END EXCEPTION TRACE =======}
      )
    end    
  end
  
  def new_pervasive
    self.update_attributes(:mobile_id => nil, :mobile_uri => nil)
  end

  def pervasive_additional_info_text
    "#{self.effective} <br> #{self.disclaimers}"
  end

  # 
  # Contracts
  # 
  belongs_to :contract
  # delegate :platinum, :to => :contract

  before_save :check_contract
  def check_contract
    if !self.contract and self.advertiser and self.advertiser.contracts.any?
      update_attributes(:contract => self.advertiser.contracts.last)
    end
  end

  def process_zip_code_block(block)
    return false unless block.valid? 
    block.zip_codes.each do |zip|
      unless self.zip_codes.find_by_zip_code(zip)
        self.offers_zip_codes.create(:zip_code => ZipCode.find_by_zip_code(zip)) 
      end
    end
    true
    #    = ZipCodeBlock.new(zip_code_params)
    # errors.add(:zip_code_block, "There were problems with some of the zip codes you added.") unless zip_code_block.valid?
    # raise "in offer, zips: #{zips}, class: #{zips.class}, valid? #{zips.valid?}, errors: #{zips.errors.inspect}"
  end
  
  def process_features(features_params)
    features_valid = true
    features = features_params[:features]
    self.contract.contract_features.destroy_all
    if features
      features.keys.each do |k|
        feature = Feature.find(k)
        self.contract.contract_features.create(:feature => feature)
        if feature.system_key == Feature::ADDL_ZIPS_KEY
          zip_block = ZipCodeBlock.new(features_params[:zip_code_block])
          # raise "foo"
          features_valid = process_zip_code_block(zip_block)
        end
        # process zip codes if system_key == Feature::ADDL_ZIPS_KEY
      end
    end
# raise "#{features_params.inspect}"
    features_valid
  end

  def remove_zip_code(zip_str)
    zip = ZipCode.find_by_zip_code(zip_str)
    # We have to use raw SQL since OffersZipCode has no id for some reason; let's please change this...
    OffersZipCode.connection.delete("DELETE FROM offers_zip_codes where offer_id = #{self.id} and zip_code_id = #{zip.id} ")
  end

  def self.random
    active.last(:order => "RAND()")
  end

  # column sorting in admin's view
  named_scope :ordered_by, lambda { |order| { 
    :include => :advertiser,
    :joins => "left join advertisers A ON offers.advertiser_id = A.id", 
    :select => 'offers.*, A.name AS advertiser_name, GREATEST(A.updated_at, offers.updated_at) AS with_advertiser_updated_at',
    :order => order
  } }
  
  named_scope :by_group, lambda { |group_ids| ( group_ids.index(Group::GLOBAL.id)) ? {} : {
    :joins => ["INNER JOIN advertisers ON advertiser_id = advertisers.id "] , :conditions => ["advertisers.group_id in (?)", group_ids]  } }

  # search in admin's view
  named_scope :title_or_advertiser_name_like, lambda { |query| { 
    :joins => [:advertiser],
  	:conditions => ["title LIKE ? OR advertisers.name LIKE ? OR (offers.advertiser_id IN (SELECT advertiser_id FROM users WHERE email LIKE ?)) OR contract_id IN (SELECT id FROM contracts WHERE notes LIKE ?)", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"] 
  	} if query && query.length > 0 
  }
  
  named_scope :by_business_name_keyword, lambda { |name|
    { :joins => :advertiser,
      :conditions => ["alternate_business_name LIKE (?) OR advertisers.name LIKE (?) ", "%#{name}%", "%#{name}%"] 
    }
  }
  named_scope :draft, :conditions => "state = 'draft'"
  named_scope :by_name, :order => "headline ASC"
  named_scope :by_title, :order => "title ASC"
  named_scope :by_plan, :order => "plans.code DESC", :joins => [:plan]
  named_scope :order_by_recent, :order => "id DESC"
  named_scope :with_category, lambda { |category| { :conditions => { :category_id => category } } }
  named_scope :non_expired, lambda { { :conditions => [ "expires_on >= ?", Date.today ] } }
  named_scope :expired, lambda { { :conditions => [ "expires_on < ?", Date.today ] } }
  named_scope :facets, :select => "category_id, count(*) as count, null as address_id", :group => :category_id
  named_scope :without_plan, :conditions => "id not in (select offer_id from plans)"
  named_scope :without_contract, :conditions => {:contract_id => nil}
  named_scope :with_contract, :conditions => "contract_id IS NOT NULL"
  named_scope :requesting_upgrade, :joins => [:contract], :conditions => ["contracts.upgrade_request_date IS NOT NULL"]
  named_scope :with_pervasive, :conditions => ["mobile_id IS NOT NULL"]

  named_scope :in_zip_codes, lambda { |address_zips, service_area_zips, randomizer| { 
    :include => [:address, :zip_codes],
    :conditions => ["addresses.zip_code in (?) or zip_codes.id in (?)", address_zips, service_area_zips.collect {|zip| zip.id }],
    :order => " RAND(#{randomizer}) "
  }}
  
  named_scope :intersects_with_service_area, lambda { |zips| { 
    :joins => :zip_codes,
    :conditions => ["zip_codes.id in (?)", zips.collect {|zip| zip.id }]
  }}
  named_scope :advertiser_name_keyword, lambda { |text|
    { :include => :advertiser,
      :conditions => ["(UPPER(advertisers.name) LIKE UPPER(?)) ", "%#{text}%"]
    }
  }
  
  named_scope :last_updated_within_days_ago, lambda { |num_days| {
    :conditions => ["updated_at >= ?", num_days.days.ago] 
  }}

  # Uses MySQL's FIELD function
  # http://lists.mysql.com/mysql/209787
  # ORDER BY FIELD(priority, 'High', 'Normal', 'Low', 'The Abyss');
  named_scope :by_zip_codes, lambda { |zip_codes| { 
    :include => [:address], 
    :order => "FIELD(`addresses`.`zip_code`,#{zip_codes.collect{|z| "'#{z}'" }.join(",")})"
  }}

  mount_uploader :alternate_logo, LogoUploader  
  
  aasm_column :state

  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :unapproved
  aasm_state :active
  aasm_state :disabled
  
  aasm_event :pending do
    transitions :from => :draft, :to => :unapproved
  end
    
  aasm_event :approve do
    transitions :from => [:unapproved, :draft], :to => :active, :on_transition => :notify_of_approval
  end

  aasm_event :re_enable do
    transitions :from => :disabled, :to => :active, :on_transition => :notify_of_re_enable
  end

  aasm_event :disable do 
    transitions :from => :active, :to => :disabled, :on_transition => :notify_of_disable
  end 

  def self.states
    aasm_states.collect(&:name)
  end

  def self.events
    aasm_events.keys
  end

  def notify_of_approval
    #OfferNotifier.deliver_mimi_offer_approved(self) if users.count > 0
  end

  def notify_of_re_enable
    if self.mobile_id #self.advertiser.mobile_id
      enable_pervasive_page(self)
    end
    #OfferNotifier.deliver_mimi_offer_re_enabled(self) if users.count > 0
  end

  def notify_of_disable
    if self.mobile_id #self.advertiser.mobile_id
      disable_pervasive_page(self)
    end
    #OfferNotifier.deliver_mimi_offer_disabled(self) if users.count > 0
  end

  def after_create
    AdminNotifier.admin_emails.each do |email|
      #AdminNotifier.deliver_mimi_new_offer(email, self) 
    end
  end

	delegate :name, :logo, :to => :advertiser
	delegate :name, :logo, :to => :advertiser, :prefix => true
		
  alias :original_address :address
  
  alias_method :optionValue, :id
  # alias_method :optionDisplay, :headline
  
  def optionDisplay
    headline
  end
  def optionValue
    self.id
  end
  
	def mappable?
	  not original_address.nil?
  end

	def uses_advertiser_address?
		address == advertiser.address
	end

  def address
    original_address || advertiser.address
  end

	def exclusive?
		not exclusive_zip_code.nil?
	end
	
  delegate :phone_number, :to => :address	
  
  def location
    if original_address
      original_address.location
    else
      zip_codes.first.location
    end
  end
  
  def business_name
    if self.alternate_business_name and !self.alternate_business_name.strip.blank?
      return alternate_business_name
    end
    self.name
  end
  
  def website_url
    return "None" if skip_website_url?
    (alternate_website_url.present?) ? alternate_website_url : advertiser.website_url
  end
  
  def facebook_url
    return "None" if skip_facebook_url?
    (alternate_facebook_url.present?) ? alternate_facebook_url : advertiser.facebook_url
  end
  
  def twitter_url
    return "None" if skip_twitter_url
    (alternate_twitter_url.present?) ? alternate_twitter_url : advertiser.twitter_url
  end
  
  def distance_from(point)
    self.class.distance_between(location, point.location)
  end
  
  def zip_codes?
    zip_codes.length > 0
  end

	def expired?
		Date.today > expires_on if expires_on
	end

  def is_tabbed_out_customer?
    return true if self.accepted_payment_types and self.accepted_payment_types.include?("tabbed_out")
    self.advertiser.is_tabbed_out_customer?
  end

  delegate :contract_plan, :to => :contract

  # def is_platinum?
  #   if contract
  #     contract.contract_plan.system_key == 'platinum'
  #   end
  #   # return true if not contract.nil? or not plan.nil?
  # end
  # alias_method :platinum?, :is_platinum?

  # def is_gold?
  #   if contract
  #     contract.contract_plan.system_key == 'gold'
  #   end
  #   # if not contract.nil? then return true if not platinum end
  #   # if not plan.nil? then return true if plan.code.downcase.include? 'gold' end
  # end

  def indexable_zip_codes
    zip_codes = self.zip_codes.collect(&:zip_code) 
    zip_codes << original_address.zip_code if original_address
    zip_codes
  end
  
  def apply_discount_code(code)
    # Check discount code
    discount = Discount.find_by_promo_code(code)
    if discount 
      # Verify that it is valid for the offer
      if gcp = self.contract.group_contract_plan
        return false unless gcp.group_contract_plan_discounts.find_by_discount_id(discount)
      end
      # Create or update
      if self.contract.contract_discount
        self.contract.contract_discount.update_attributes(:discount => discount)
      else
        self.contract.create_contract_discount(:discount => discount)
      end
    end
  end

  def payment_methods_text
    if self.accepted_payment_types and !self.accepted_payment_types.blank?
      return self.accepted_payment_types.collect{|item| self.class.payment_full_text(item) }.to_sentence
    end
    self.payment_methods
  end

  def self.payment_full_text(item)
    case item
    when "amex"
      "American Express"
    when "mc"
      "MasterCard"
    when "tabbed_out"
      "Tabbed Out"
    else item.humanize.titleize
    end
  end

=begin
  searchable(:auto_index => true) do
    text :description
    text(:name) { |offer| offer.business_name }
    text(:category) { |offer| offer.category.name }
    string(:zip_codes, :multiple => true) { |offer| offer.indexable_zip_codes }
    string :state
    boolean(:exclusive) { |offer| offer.exclusive? }
    #coordinates :location
    integer(:category_id, :references => Category) { |offer| offer.category_id }
    time :created_at
    time :expires_on
  end
=end
  def self.exclusive_available?(category_id, zip_code)
    # Remove restriction for platinum only categories
    exclusive_available_in_zip_code?(zip_code) and find_exclusive(category_id, zip_code) == nil
    #Category.find(category_id).platinum? and exclusive_available_in_zip_code?(zip_code) and find_exclusive(category_id, zip_code) == nil
  end
  
  def self.exclusive_available_in_zip_code?(zip_code)
    exclusive_count(zip_code) < $exclusive_offers_per_zip_code
  end
  
  def self.exclusive_count(zip_code)
    count :joins => :exclusive_zip_code, :conditions => { :zip_codes => { :zip_code => zip_code }, :state => "active" }
  end

	def self.find_exclusive(category_id, zip_code)
		first :joins => :exclusive_zip_code, :conditions => { :zip_codes => { :zip_code => zip_code }, :category_id => category_id, :state => "active" }
	end

  def self.find_by_customer_code(customer_code)
    match_data = customer_code.match(/OFFER_(\d+)/)
    if match_data
      offer_id = match_data.captures.first 
      find(offer_id)
    end
  end
  
  def available_group_contract_plan(contract_plan)
    self.address.zip_code_obj.group.group_contract_plans.find_by_contract_plan_id(contract_plan)
  end

  def assign_plan(plan_key)
    if self.contract and contract_plan = ContractPlan.find_by_system_key(plan_key)
      # assign contract a plan
      self.contract.update_attributes(:contract_plan => contract_plan)
      # if available, assign a GroupContractPlan
      gcp = available_group_contract_plan(contract_plan)
      self.contract.update_attributes(:group_contract_plan => gcp)
    end
  end

  def get_discount(contract_plan=self.contract.contract_plan)
    candidate = ""
    candidate = iterate_cpds(GroupContractPlanDiscount.find_all_by_group_contract_plan_id(GroupContractPlan.find_by_contract_plan_id_and_group_id(contract_plan.id,self.address.zip_code_obj.group))) 
    unless candidate
      candidate = iterate_cpds(ContractPlanDiscount.find_all_by_contract_plan_id(contract_plan.id))
    end
    return candidate
  end  
  
  def iterate_cpds(cpds)
    candidate = false
    cpds.each do |cpd|
      d = Discount.find_by_id(cpd.discount_id)
      if d.setup_display 
        if candidate
          if d.amount_off > candidate.amount_off 
            candidate = d
          end
        else
          candidate = d
        end
      end  
    end
    return candidate
  end

  def normal_logo_url
    if self.alternate_logo and !self.alternate_logo.blank? 
      self.alternate_logo.normal.url
    else
      self.logo.normal.url
    end
  end

  def check_permalink
    self.permalink = generate_permalink
  end
  
  def category_as_permalink
    url_safe self.category.name.gsub(" - ","-").gsub(" / ","-").gsub("/ ","-") rescue ""
  end

  def city_as_permalink
    url_safe self.address.city rescue ""
  end

  def generate_permalink
    "#{url_safe(self.business_name)}-#{self.id}"
  end

  # private 
  def url_safe(val)
    return "" if val.blank?
    u val.strip.delete(",").delete("'").delete(".").
        gsub(" ("," ").gsub("(","_").delete(")").
        gsub("*","_").delete("?").delete("!").
        gsub(" ","-").gsub("&", "and").gsub("/","_").
        downcase
  end

  def all_trackers_count
    self.trackers.count
  end

  def male_trackers_count
    self.trackers.males.count
  end

  def female_trackers_count
    self.trackers.females.count
  end

  def self.array_for_quickbooks
    array = [%w(offer_id contract_id contact_name company email phone website street city state zip current_status)]
    self.all.each do |offer|
      user = offer.advertiser.users.first
      array << [
        offer.id,
        offer.contract_id,
        user ? "#{user.first_name} #{user.last_name}" : "", 
        offer.business_name,
        user ? user.email : "",
        offer.address ? offer.address.phone_number : "",
        offer.website_url,
        offer.address ? offer.address.street : "",
        offer.address ? offer.address.city : "",
        offer.address ? offer.address.state : "",
        offer.address ? offer.address.zip_code : "",
        offer.state
      ]
    end
    array
  end
  
  def has_wifi?
    self.contract.has_wifi?
  end
  
  def all_trackers_count
     self.trackers.count
  end

  def male_trackers_count
    self.trackers.males.count
  end

  def female_trackers_count
    self.trackers.females.count
  end

  def wifi_connections_count(attr)
    self.contract.wifi_counts(attr).size
  end
  
  def tracker_age_report
    @trackers_by_age ||= begin
      if self.trackers.any?
        add_tracker_report_age_range(18,20)
        add_tracker_report_age_range(21,24)
        add_tracker_report_age_range(25,34)
        add_tracker_report_age_range(35,44)
        add_tracker_report_age_range(45,54)
        add_tracker_report_age_range(55,64)
      else
        []
      end
    end
  end
  
  def add_tracker_report_age_range(min,max)
    @trackers_by_age ||= []
    key = "#{min}-#{max}"
    @trackers_by_age << {key => self.trackers.by_age_range(min,max).size}
  end
  
  def twitter_handle
    if twitter_url and twitter_url != "None"
      if twitter_url.downcase.include?("twitter.com/") 
        twitter_url.match(/([^\/]*)$/).to_s # get string after last slash
      else 
        return twitter_url 
      end
    end
  end

end
