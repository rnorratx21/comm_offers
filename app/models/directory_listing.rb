class DirectoryListing < ActiveRecord::Base
  belongs_to :address
  named_scope :by_zip_codes, lambda { |zip_codes| { 
  :include => [:address], 
  :order => "FIELD(`addresses`.`zip_code`,#{zip_codes.collect{|z| "'#{z}'" }.join(",")})"
}}
  
end
