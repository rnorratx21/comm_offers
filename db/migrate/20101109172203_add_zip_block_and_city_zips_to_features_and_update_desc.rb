class AddZipBlockAndCityZipsToFeaturesAndUpdateDesc < ActiveRecord::Migration
  def self.up
    # Create New Add-On Features
    Feature.create(
      :title=>"Additional Block of Zip Codes", 
      :description => 'Increase your exposure by adding an additional 10 Zip Codes to your search parameters on the Community Offers web site', 
      :amount => 49,
      :system_key=>'addl_zip_block'
    )
    Feature.create(
      :title=>"City-wide Zip Codes", 
      :description => 'Ultimate, citywide exposure! Add all zips in the city to your search parameters on the Community Offers web site.',
      :amount => 99,
      :system_key=>'city_zips'
    )
    Feature.find_by_system_key("your_qr").update_attributes(
      :description => "Individual QR code with individual mobile site for your business — included in Diamond Plan",
      :amount => 99
    )
    Feature.find_by_system_key("sms").update_attributes(
      :description => "Personalized push marketing programs with opt-in email and texting opportunities—included in Diamond Plan",
      :amount => 99
    )
  end

  def self.down
    Feature.find_by_system_key("addl_zip_block").destroy if Feature.find_by_system_key("addl_zip_block")
    Feature.find_by_system_key("city_zips").destroy if Feature.find_by_system_key("city_zips")
  end
end