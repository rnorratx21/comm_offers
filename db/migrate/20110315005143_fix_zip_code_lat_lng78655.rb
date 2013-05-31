class FixZipCodeLatLng78655 < ActiveRecord::Migration
  def self.up
    ZipCode.find_by_zip_code("78665").update_attributes(:lat => "30.513692", :lng => "-97.627945")
  end

  def self.down
    ZipCode.find_by_zip_code("78665").update_attributes(:lat => "30.2198", :lng => "-98.3586")
  end
end