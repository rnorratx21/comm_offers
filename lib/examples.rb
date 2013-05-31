require File.join(File.expand_path(File.dirname(__FILE__)), 'examples', 'example_factories')

class Examples
	include ExampleFactories
	
	def self.create
		self.new.load_offers
	end
	
	def load_offers
		define_factories
		load Proc.new { retail }
		load Proc.new { service }
		Offer.reindex
	end
	
	def load(offers_proc)
		offers, kind = offers_and_kind_for offers_proc

		puts "#{kind.capitalize} Offers:"
		offers.each do |row|
			o = offer row[0], row[1], kind, row[2..3] 
			puts "#{o.advertiser.name}"
		end
		puts
	end

	def offer(name, address, kind, *options)
		exclusive = options[0].include? :exclusive
		mobile = options[0].include? :mobile
		expired = options[0].include? :expired
		
		advertiser_address = Factory :example_address, :street => address
		advertiser = Factory :example_advertiser, :name => name, :address => advertiser_address
    user = Factory :example_user, :advertiser => advertiser
		
		offer_sym = "example_offer".to_sym
		offer_sym = "example_service_offer".to_sym if kind == 'service'		
		
		offer_adddress = advertiser.address
		if kind == 'service' && rand(2) > 0
		  offer_adddress = nil
		end

		offer_attributes = {
			:advertiser => advertiser,
			:address => offer_adddress,
			:mobile => mobile
		}
		
		offer_attributes[:exclusive_zip_code] = zip_code(advertiser_address.zip_code) if exclusive
		offer_attributes[:expires_on] = Date.yesterday if expired
		
		offer = Factory offer_sym, offer_attributes
	end

	def retail
		offers =
		[
			["0 Degrees", "405 E 7th St.", :exclusive],
			["12th Street Books", "827 W. 12th St."],
			["Antone's Records", "2928 Guadalupe"],
			#["Pangea", "2712 B Guadalupe"],
			#["The Great Outdoors Garden Center", "2730 S. Congress"],
			["Feathers Boutique", "1700 B. S. Congress Ave.", :expired],
			["The Upper Crust Bakery", "4508 Burnet"],
			["Goodie Two Shoes", "1111 S. Congress Ave."],
			["Capra & Cavelli", "509 East 5th St."],
			["Elizabet Ney Muesuem", "304 EAst 44 Street"],
			["Austin Dogtown", "537 Woodward St."],
			["Touch of Sass", "500 N. Lamar Blvd."],
		]
		binding
	end

	def service
		offers =
		[
			["Coburn Law Firm", "100 Congress Avenue", :exclusive],
			["Massage Harmony", "4477 S. Lamar Blvd", :mobile],
			["Austin Home Search", "4106 Medical Parkway"],
			["E Events", "5100 Dull Knife Drive"],
			["Wi-Fi Texas", "815-A Brazos"],
			["Elite Weddings", "4408 C Burnet Road"],
			["Touch Screen Marketing of Texas", "1303 B Cuernavaca"],
			["Dub King", "2105 Justin Lane"],
			["Austin Area Limousines", "4822 E. Cesar Chavez St."]
		]
		binding
	end

	def current_method
	  caller[0]=~/`(.*?)'/
	  $1
	end

	def offers_and_kind_for(offers_proc)
		b = offers_proc.call
		offers = eval "offers", b
		kind = eval "current_method", b
		[offers, kind]
	end

	def fifteen_users
    firsts = %w(Bob Sally Suzy Harry Betty Johnny Maggie Stevie Anita Barry Willy Nicki Maria Larry Debbie Ruby Martina)
    lasts = %w(Jones James Johnson Aldrige Patterson Miller Hardy Baruda Fleming Martin Jackson Figgins Baker Oring Burnett Olafson Barbera)
    firsts.shuffle!
    lasts.shuffle!
    users = []
    (0..firsts.size-1).each do |i|
      first = firsts[i]
      last = lasts[i]
      u = User.create!(
        :email => "#{first.downcase}.#{last.downcase}@#{ActiveSupport::SecureRandom.hex(3).downcase}.com", 
        :first_name => first, 
        :last_name => last,
        :password => 'password', :password_confirmation => 'password', 
        :consumer => true
      )
      z_id=rand(ZipCode.count)
      u.create_profile(
        :is_male => random_boolean,
        :home_zip_code => ZipCode.find(z_id),
        :dob => (Date.today-(10000+15000*rand)),
        :do_email_offer_updates => random_boolean 
      )
      users << u
    end
    users
  end
	
	def random_offer_trackings(offer)
	  users = fifteen_users
    users.each do |user|
      offer.tracked_offers.create(:tracker => user)
    end
    offer.tracked_offers
  end

	def random_boolean
	  (rand > 0.5)
  end
end
