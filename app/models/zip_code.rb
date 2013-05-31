# == Schema Information
#
# Table name: zip_codes
#
#  id         :integer         not null, primary key
#  zip_code   :string(255)
#  city       :string(255)
#  state      :string(255)
#  lat        :float
#  lng        :float
#  created_at :datetime
#  updated_at :datetime
#

class ZipCode < ActiveRecord::Base
  acts_as_mappable
  belongs_to :group
  has_many :advertisers
  has_many :offers_zip_codes
  has_many :offers, :through => :offers_zip_codes
  has_many :exclusive_offers, :class_name => "Offer", :foreign_key => "exclusive_zip_code_id"
  named_scope :by_zip, lambda {|zip| {:conditions => ["zip_code = ?", zip]}}
  named_scope :by_group, lambda { |group_id| { :conditions => ["group_id = ?", group_id]  } }
  named_scope :with_offers, :include => [:offers], :conditions => ['id IN (SELECT zip_code_id FROM offers_zip_codes)']
  named_scope :unassigned, :conditions => "group_id IS NULL"
  has_one :sales_area_zip_code
  has_one :sales_area, :through => :sales_area_zip_code

  def self.z(zip_string)
    find_by_zip_code zip_string
  end

  def location
    [ lat, lng ]
  end  

end
