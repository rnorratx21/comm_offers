class PopulateFeatures < ActiveRecord::Migration
  def self.up
    Feature.create(:title=>"Number of zips", :system_key=>'zip')  
    Feature.create(:title=>"Address and phone number for a single retail location", :system_key=>'info')  
    Feature.create(:title=>"Upload your logo", :system_key=>'logo')  
    Feature.create(:title=>"Links to your website, twitter and facebook pages", :system_key=>'link')  
    Feature.create(:title=>"Add personalized coupon offer", :system_key=>'coupon')  
    Feature.create(:title=>"Auto post your offers to Facebook", :system_key=>'facebook')  
    Feature.create(:title=>"Inclusion on our QR code with neighborhood mobile app", :system_key=>'our_qr')  
    Feature.create(:title=>"Personal QR code for your details page and marketing use plus personalized mobile app", :system_key=>'your_qr')  
    Feature.create(:title=>"Personalized, integrated push marketing campaigns with SMS text and mobile apps", :system_key=>'sms')  
    Feature.create(:title=>"Inclusion on your neighborhood loyalty card", :system_key=>'loyalty')  
  end

  def self.down
  end
end
