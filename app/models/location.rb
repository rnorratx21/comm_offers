class Location
  def initialize(lat, lng, city, state)
    @lat = lat
    @lng = lng
    @city = city
    @state = state
  end

  def location
    [ @lat, @lng ]
  end

  def name
    "#{@city}, #{@state}"
  end

  def self.find_by_ip_address(ip)
    result = Geokit::Geocoders::MultiGeocoder.geocode(ip)

    if result.success
      new(result.lat, result.lng, result.city, result.state)
    else
      default_address
    end
  end

  def self.default_address
    new(29.97, -95.35, "Houston", "TX")
  end
end

