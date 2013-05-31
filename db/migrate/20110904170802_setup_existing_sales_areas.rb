class SetupExistingSalesAreas < ActiveRecord::Migration
  def self.up
    houston = SalesArea.create(:name => "Houston")
    houston.add_city_zips ["Cypress", "Houston", "Katy", "Spring", "Sugar Land", "Blanco", "Portland", "Tomball", 
     "Pinehurst", "Magnolia", "Liberty", "Brenham", "Conroe", "Stafford", "Humble", 
     "League City", "Pearland", "Rye", "College Station", "Richmond", "Montgomery"]

    austin = SalesArea.create(:name => "Austin")
    austin.add_city_zips ["Austin", "Sandy", "Round Rock", "Marble Falls"]

    san_marcos = SalesArea.create(:name => "San Marcos")
    san_marcos.add_city_zips ["San Marcos"]
    
    san_antonio = SalesArea.create(:name => "San Antonio")
    san_antonio.add_city_zips ["San Antonio", "New Braunfels", "Schertz"]
  end

  def self.down
    SalesArea.all.each{|sa| sa.destroy }
  end
end
