# == Schema Information
#
# Table name: advertisers
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  address_id   :integer
#  logo         :string(255)
#  twitter_url  :string(255)
#  facebook_url :string(255)
#  website_url  :string(255)
#  feed_url     :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Advertiser < ActiveRecord::Base
  acts_as_audited 

  # 
  # Contracts
  # 
  has_many :contracts, :dependent => :destroy
  has_many :offers, :dependent => :destroy
  has_many :users
  belongs_to :group
  belongs_to :zip_code
  belongs_to :address, :dependent => :destroy

  validates_presence_of :name

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :offers #, :reject_if => proc {|attrs| attrs['category_id'].blank? }

  before_create :assign_default_group

  named_scope :by_name, :conditions => ["advertisers.is_draft = false"], :order => "name ASC"
  named_scope :with_open_offers, :conditions => {"offers.contract_id" => nil, "is_draft" => false}, :include => :offers
  named_scope :active, :conditions => ["advertisers.is_draft = false"]
  named_scope :with_wifi, :joins => :contracts, :conditions => ["contracts.wifi_nasid IS NOT NULL"]
  
  mount_uploader :logo, LogoUploader
  
  SIGNUP_STEPS = %w[payment offer preview]
  
  def self.default
    new do |a| 
      a.build_address
    end    
  end
  
  def first_signup_step
    need_payment_on_signup ? "payment" : "offer"
  end
  
  def need_payment_on_signup
    !self.contracts.active.any?
  end

  def offer_for_signup
    if !self.is_draft? or self.offers.active.any?
      return "It appears you've already completed signing up for an offer.  Please contact us for additional help or if you believe you've gotten this message in error." 
    end
    self.offers.draft.last || self.offers.build {|o| o.new_defaults }
  end

  def save_pending_with_contract
    if save
      update_attributes(:is_draft => true) 
      # Check contract and make sure its assigned to any offers
      save_new_default_contract if self.contracts.empty?

      true
    else 
      false
    end
  end

  def save_new_default_contract
    contract = self.contracts.build_from_defaults
    unless contract.save
      self.errors.merge! contract.errors
    else
      # Create invoices
      order = Order.new(contract)
      Contract.build_from_order(contract, order)
      contract.save
    end
    contract
  end

  def assign_default_group
    self.group ||= Group::DEFAULT
  end

  def display_name
    "#{name}"
  end
  
  def csv_excludes
    %w(is_draft group_id address_id zip_code_id)
  end
  
  def has_wifi?
    self.contracts.with_wifi.any?
  end
  
  def all_trackers_count
    self.offers.collect{|o| o.trackers.count}.inject{|sum,i|sum+i}
  end

  def male_trackers_count
    self.offers.collect{|o| o.trackers.males.count}.inject{|sum,i|sum+i}
  end

  def female_trackers_count
    self.offers.collect{|o| o.trackers.females.count}.inject{|sum,i|sum+i}
  end

  def wifi_connections_count(attr)
    self.contracts.collect{|c| c.wifi_counts(attr).size }.inject{|sum,i|sum+i}
  end

end
