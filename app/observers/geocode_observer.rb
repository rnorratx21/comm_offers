# This can be enabled/disabled with:
#   GeocodeObserver.instance.enable! 
# or 
#   GeocodeObserver.instance.disable!

class GeocodeObserver < ActiveRecord::Observer
  observe :address
  
  def initialize
    $geocode_enabled = true if $geocode_enabled.nil?
    super
  end
  
  def disable!
    $geocode_enabled = false
  end
  
  def enable!
    $geocode_enabled = true
  end
  
  def before_save(address)
    address.geocode! if $geocode_enabled
  end
end