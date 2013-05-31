require File.join(File.expand_path(File.dirname(__FILE__)), 'example_helpers')

module ExampleFactories
	include ExampleHelpers

	def define_factories
    Factory.sequence(:email) { |n| "person#{n}@example.com" }

		Factory.define :example_user, :class => :user do |user|
			user.email { Factory.next :email }
      user.password "secret"
      user.password_confirmation "secret"
		end

		Factory.define :example_address, :class => :address do |address|
			address.city "Austin"
			address.state "Texas"
			address.zip_code "78704"
			address.phone_number { some_phone_number }
			address.after_build { |a| a.geocode! }
		end

		Factory.define :example_advertiser, :class => :advertiser do |advertiser|
		  advertiser.feed_url { some_feed_url }
		  advertiser.twitter_url { some_twitter_url }
		  advertiser.facebook_url { some_facebook_url }
		  advertiser.website_url { some_website_url }
		end

		Factory.define :example_offer, :class => :offer do |offer|
			offer.category { some_category }
		  offer.title { some_title }
		  offer.description { some_description }
		  offer.headline { some_headline }
		  offer.hours { some_hours }
		  offer.effective { some_effective }
		  offer.expires_on { rand(60).days.from_now }
		  offer.payment_methods { select(payment_methods, :at_least => 3, :at_most => 5).join(" / ") }
			offer.state "active"
		end

		Factory.define :example_affiliate_offer, :class => :affiliate_offer do |offer|
		  offer.title { some_title }
		  offer.description { some_description }
		  offer.headline { some_headline }
		end

		Factory.define :example_service_offer, :parent => :example_offer do |offer|
			offer.zip_codes { zip_codes }
		end
	end
end
