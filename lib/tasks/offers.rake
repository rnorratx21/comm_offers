namespace :data do
  namespace :offers do
    desc "Loads test data into the database"
    task :load => :environment do
      categories = Category.all
      
      File.foreach("data/austin.txt") do |line|
        name, address, lat, lng = line.split "\t"
        address_words = address.split ' '
        address_words.reverse!
        state = address_words.shift
        city = address_words.shift
        street = address_words.reverse.join(' ')

				$stderr.puts "-- importing offer for #{name}"
        
        address = Address.create!(
          :street => street, 
          :city => city, 
          :state => "TX", 
          :lat => lat, 
          :lng => lng,
					:phone_number => "(512) 555-1212"
        )        
        advertiser = Advertiser.create!(
          :name => name,
          :address => address
        )
        address = Address.create!(
          :street => street, 
          :city => city, 
          :state => "TX", 
          :lat => lat, 
          :lng => lng,
					:phone_number => "(512) 555-1212"
        )        
        
        offer = advertiser.offers.create!(
          :category => categories.rand,
          :description => "10% off any order until DOOMSDAY", 
          :headline => "10% off", 
          :hours => "9am-5pm",
          :effective => "10am-1pm Mon-Wed",
          :expires_on => Date.today + 120.days,
          :payment_methods => "Cash, Check, VISA, AMEX",
          :address => address
        )
      end
    end
  end
end
