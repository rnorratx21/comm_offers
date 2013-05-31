class SalesAreaZipCode < ActiveRecord::Base
  belongs_to :sales_area
  belongs_to :zip_code
  
  validates_uniqueness_of :zip_code_id
  
  named_scope :by_zip, :joins => :zip_code, :order => 'zip_code asc'
end
