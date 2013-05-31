require 'faker'

module ExampleHelpers
	
	def one_of(items)
	  items.rand
	end

	def at_least(min, items)
		choices = []
		count = min + rand(items.length - min + 1)	
		while choices.length < count do
			item = one_of items
			choices << item if not choices.include? item
		end
		choices.join(" / ")
	end

	def select(items, options)
		take = num(items, options)

		choices = []
		while choices.length < take do
			item = one_of items
			choices << item if not choices.include? item
		end
		choices
	end

	def num(items, options={})
		at_most = options[:at_most] || items.length
		increments_of = options[:increments_of] || 1
		at_least = [ options[:at_least] || 1 , increments_of ].max

		n = at_least + rand(at_most-at_least+1) 

		n -= n % increments_of

		[n,at_least].max
	end

	def some_phone_number
		prefix = "#{("%-3d" % rand(999)).gsub(/ /, "0")}"
		suffix = "#{("%-4d" % rand(9999)).gsub(/ /, "0")}"
		"(512) #{prefix}-#{suffix}"
	end

	def some_headline
		one_of [
			"10% Off",
			"$15 Off",
			"Buy 1 Get 1",
			"$5 Discount",
			"Bonus Gift",
			"First Visit"
		]
	end

	def some_title
		Faker::Lorem.words(5).join(" ").capitalize
	end

	def some_description
		Faker::Lorem.words(50).join(" ").capitalize
	end

	def some_category
		category_count = 44
		Category.find(1 + rand(category_count))
	end

	def some_hours
		one_of [
			"9 am to 6 pm, Mon - Fri. 10 am to 4pm Sat & Sun",
			"Daily 9 am to 6 pm",
			"10 am to 7 pm",
			"8 am - 5 pm. Closed on Sunday."
		]
	end

	def some_effective
		one_of [
			"Monday through Wednesday",
			"Weekends",
			"5 pm to 7 pm",
			"After 12 pm",
			"First 5 customers"
		]
	end
	
	def some_twitter_url
	  one_of [
	    "http://twitter.com/scobleizer",
	    "http://twitter.com/techrunch",
	    "http://twitter.com/techrunch",
	    "http://twitter.com/mashable",
	    "http://twitter.com/zappos",
	    "http://twitter.com/lancearmstrong",
	    "http://twitter.com/garyvee",
	    "http://twitter.com/gsherman",
      nil
	  ]
  end
  
  def some_facebook_url
    one_of [
      "http://www.facebook.com/scobleizer",
      "http://www.facebook.com/pepsi",
      "http://www.facebook.com/zappos",      
      "http://www.facebook.com/techcrunch",
      nil
    ]
  end

  def some_facebook_url
    one_of [
      "http://www.facebook.com/scobleizer",
      "http://www.facebook.com/pepsi",
      "http://www.facebook.com/zappos",      
      "http://www.facebook.com/techcrunch",
      nil
    ]
  end

  def some_feed_url
    one_of [
      "http://http://feedproxy.google.com/TechCrunch",
      "http://feeds2.feedburner.com/Mashable",
      nil
    ]
  end
  
  def some_website_url
    one_of [
      "http://mashable.com",
      "http://techcrunch.com",
      "http://calcendon.com",
      "http://ampgt.com",
      "http://marcusirven.com",
      nil
    ]
  end

	def payment_methods
		[
			"Cash",
			"Check",
			"MasterCard",
			one_of(["Visa", "VISA"]),
			one_of(["American Express", "AMEX"]),
			"Diners Club"
		]
	end
	
	def zip_codes
		raw_zip_codes = select(austin_zip_codes, :at_least => 10, :at_most => 20, :increment_of => 10)
		zip_codes = []
		raw_zip_codes.each do |raw|
			zip_codes << zip_code(raw)
		end
		zip_codes
	end
	
	def zip_code(code)
		zip_code = ZipCode.first :conditions => {:zip_code => code}
	end
	
	def austin_zip_codes
		[
			"78701",
			"78702",
			"78703",
			"78704",
			"78705",
			"78708",
			"78709",
			"78710",
			"78711",
			"78712",
			"78713",
			"78714",
			"78715",
			"78716",
			"78717",
			"78718",
			"78719",
			"78720",
			"78721",
			"78722",
			"78723",
			"78724",
			"78725",
			"78726",
			"78727",
			"78728",
			"78729",
			"78730",
			"78731",
			"78732",
			"78733",
			"78734",
			"78735",
			"78736",
			"78737",
			"78738",
			"78739",
			"78741",
			"78742",
			"78744",
			"78745",
			"78746",
			"78747",
			"78748",
			"78749",
			"78750",
			"78751",
			"78752",
			"78753",
			"78754",
			"78755",
			"78756",
			"78757",
			"78758",
			"78759",
			"78760",
			"78761",
			"78762",
			"78763",
			"78764",
			"78765",
			"78766",
			"78767",
			"78768",
			"78769",
			"78771",
			"78772",
			"78773",
			"78774",
			"78778",
			"78779",
			"78780",
			"78781",
			"78782",
			"78783",
			"78785",
			"78786",
			"78787",
			"78788",
			"78789",
		]
	end

end