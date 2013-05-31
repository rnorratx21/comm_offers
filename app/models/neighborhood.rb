class Neighborhood < ActiveRecord::Base
  
  def location
    [ lat, lng ]
  end  

end