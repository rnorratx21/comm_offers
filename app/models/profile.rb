class Profile < ActiveRecord::Base
  include ProfilePreferredLists
  belongs_to :user
  belongs_to :home_zip_code, :class_name => "ZipCode", :foreign_key => "home_zip_code_id"
  
  has_many :preferred_zip_codes, :class_name => "ConsumerPreferredZipCode"
  has_many :preferred_categories, :class_name => "ConsumerPreferredCategory"
  
  attr_accessor :home_zip_code_value
  
  before_save :check_home_zip_code_value
  after_save :update_preferred_categories
  
  private
    def check_home_zip_code_value
      if self.home_zip_code_value
        zip = ZipCode.find_by_zip_code(home_zip_code_value)
        if zip
          self.home_zip_code = zip if zip
          self.preferred_zip_codes.build(:zip_code => zip)
        else
          errors.add_to_base "Zip Code #{self.home_zip_code_value} was not found in our system."
        end
      end
    end
end
