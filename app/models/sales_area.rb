class SalesArea < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :sales_area_zip_codes, :dependent => :destroy
  has_many :zip_codes, :through => :sales_area_zip_code
  
  named_scope :by_name, :order => "name asc"

  def add_city_zips(city_param, state="TX")
    zip_objs = ZipCode.find_all_by_city_and_state(city_param, state)
    zip_objs.each do |zip|
      self.sales_area_zip_codes.create(:zip_code => zip) unless self.sales_area_zip_codes.find_by_zip_code_id(zip)
    end
  end
end
