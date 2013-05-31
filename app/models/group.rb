class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :advertisers
  has_many :group_contract_plans
  has_many :zip_codes
  act_as_type
  
  after_save :update_users
  include UserList
  
  after_save :update_advertisers
  include AdvertiserList
 
  
  after_save :update_zip_codes
  include ZipCodeList
  
  DEFAULT = self.find_by_name "Default" if RAILS_ENV == 'test'
  
  named_scope :admin_checked, lambda { |group_ids| ( group_ids.index(Group::GLOBAL.id)) ? {} :  { :conditions => ["id in (?) and id != ?", group_ids, Group::DEFAULT.id] } }
  named_scope :not_self, lambda { |group_id| { :conditions => ["id != ?", group_id] } }
  
end
