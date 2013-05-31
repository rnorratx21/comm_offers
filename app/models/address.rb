# == Schema Information
# Schema version: 20091121003735
#
# Table name: addresses
#
#  id           :integer         not null, primary key
#  street       :string(255)
#  city         :string(255)
#  state        :string(255)
#  zip_code     :string(255)
#  phone_number :string(255)
#  lat          :float
#  lng          :float
#  created_at   :datetime
#  updated_at   :datetime
#

class Address < ActiveRecord::Base
  
  after_validation_on_update :geocode!
  after_validation_on_create :geocode!
  
  attr_accessor :lat_lng_set_manually
  
  def location
    [ lat, lng ]
  end
  
  def full
    "#{street}, #{city}, #{state} #{zip_code}"
  end
  
  def geocoded                                     
    "#{full} (#{lat}, #{lng})"
  end

  def geocode!
   # unless self.lat_lng_set_manually
      geo_loc = Geokit::Geocoders::MultiGeocoder.geocode(full)
      if validate_geo_loc geo_loc
        update_from_geo_loc geo_loc
      end
      geo_loc
   #end
  end

  def update_from_geo_loc(geo_loc)
    if self.lat_lng_set_manually == "0"
      self.lat = geo_loc.lat
      self.lng = geo_loc.lng
    end
    #self.zip_code = geo_loc.zip
    #self.street = geo_loc.street_address
  end

  def validate_geo_loc(geo_loc)
    invalid_attributes = []
    
    if geo_loc.street_address.nil?
      invalid_attributes << :street
      geo_loc.success = false    
    end
    
    if geo_loc.city.nil?
      invalid_attributes << :city
      geo_loc.success = false    
    end

    if geo_loc.state.nil?
      invalid_attributes << :state
      geo_loc.success = false    
    end

    if geo_loc.zip.nil?
      invalid_attributes << :zip_code
      geo_loc.success = false    
    end

    if geocode_failure?(invalid_attributes)
      puts "ADDING ERROR TO BASE"
      errors.add_to_base("This address #{ErrorMessages::GEOGRAPHY}")
    else
      add_errors_for invalid_attributes
    end
    
    geo_loc.success
  end
  
  def add_errors_for(invalid_attributes)
    invalid_attributes.each do |a|
      errors.add(a, ErrorMessages::GEOGRAPHY)
    end
  end

  def geocode_failure?(invalid_attributes)
    invalid_attributes.length == 4
  end
  
  validates_presence_of :street, :message => ErrorMessages::PRESENCE
  validates_presence_of :city, :message => ErrorMessages::PRESENCE
  validates_presence_of :state, :message => ErrorMessages::SELECTION
  validates_presence_of :phone_number, :message => ErrorMessages::PRESENCE

  def validate
    if zip_code.blank?
      errors.add :zip_code, ErrorMessages::PRESENCE
    elsif not zip_code =~ /^\d{5}$/
      errors.add :zip_code, ErrorMessages::ZIP_CODE
    end
  end
  
  def zip_code_obj
    ZipCode.find_by_zip_code(self.zip_code) unless self.zip_code.blank? 
  end
end
