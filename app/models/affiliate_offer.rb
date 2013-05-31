# == Schema Information
#
# Table name: affiliate_offers
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  kind         :string(255)
#  logo         :string(255)
#  headline     :string(255)
#  title        :string(255)
#  website_url  :string(255)
#  view_content :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#

class AffiliateOffer < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  include AASM
  aasm_column :state

  aasm_initial_state :active
  aasm_state :draft
  aasm_state :active
  aasm_state :disabled
  
  aasm_event :enable do
    transitions :from => :disabled, :to => :active
  end

  aasm_event :disable do 
    transitions :from => :active, :to => :disabled
  end 

  def active?
    state == "active"
  end
  
  def mappable?
    false
  end
    
  def is_tabbed_out_customer?
    false
  end
    
  def exclusive?
    false
  end
  
  def mobile?
    true
  end
  
  def phone_number
    nil
  end
  
  def business_name
    self.name
  end

  def self.rand(num)
    # Uses random_finders plugin, not efficient for large datasets
    # http://github.com/collectiveidea/random_finders
    all :conditions => { :state => "active" }, :order => :random, :limit => num
  end
end
