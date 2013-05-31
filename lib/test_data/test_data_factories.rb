require File.join(File.expand_path(File.dirname(__FILE__)), 'test_data_helpers')

module TestDataFactories
	include TestDataHelpers
	
	def define_factories
		Factory.define :address do |address|
			address.sequence(:street) { "street_#{$seq}" }
			address.sequence(:city) { "city_#{$seq}" }
			address.sequence(:state) { "state_#{$seq}" }
			address.sequence(:zip_code) { "zip_code_#{$seq}" }
			address.sequence(:phone_number) { "phone_number_#{$seq}" }
			address.sequence(:lat) { $seq }
			address.sequence(:lng) { $seq }
		end

		Factory.define :austin_address, :parent => :address do |address|
			address.city "Austin"
		  address.state "TX"
			address.sequence(:zip_code) { zip_code_for 787, $seq }
		  address.sequence(:phone_number) { phone_number_for 512, 555, $seq}
			address.lat {|a| lat_for a.zip_code }
			address.lng {|a| lng_for a.zip_code }
		end
		
		Factory.define :advertiser do |advertiser|
		  advertiser.association :address
			advertiser.sequence(:name) { "advertiser_#{$seq}" }
		end

		Factory.define :austin_advertiser, :parent => :advertiser do |advertiser|
		  advertiser.association :address, :factory => :austin_address
		end
		
		Factory.define :offer do |offer|
			offer.association :advertiser
			offer.association :address
			offer.category { random_category }
		  offer.sequence(:description) { "offer_#{$seq}" }
		  offer.sequence(:headline) { "hl_#{$seq}" }
		  offer.sequence(:hours) { "hours_#{$seq}" }
		  offer.sequence(:effective) { "hours_#{$seq}" }
		  offer.sequence(:expires_on) { $seq.days.from_now }
		  offer.sequence(:payment_methods) { "payment_methods_#{$seq}" }
		  offer.sequence(:kind) { $seq%2 == 0 ? "service" : "retail" }
		end

		Factory.define :raw_offer, :class => Offer do |offer|
			offer.category { random_category }
		  offer.sequence(:description) { "offer_#{$seq}" }
		  offer.sequence(:headline) { "hl_#{$seq}" }
		  offer.sequence(:hours) { "hours_#{$seq}" }
		  offer.sequence(:effective) { "hours_#{$seq}" }
		  offer.sequence(:expires_on) { $seq.days.from_now }
		  offer.sequence(:payment_methods) { "payment_methods_#{$seq}" }
		end

		Factory.define :retail_offer, :parent => :offer do |offer|
		  offer.kind "retail"
			offer.address {|o| o.advertiser.address}
		end

		Factory.define :service_offer, :parent => :offer do |offer|
		  offer.kind "service"
		  # offer.sequence(:mobile) { $seq%4 == 0 }
		end

		Factory.define :mobile_offer, :parent => :service_offer do |offer|
		  offer.mobile true
		end

		Factory.define :austin_retail_offer, :parent => :retail_offer do |offer|
			offer.association :advertiser, :factory => :austin_advertiser
		end

		Factory.define :austin_service_offer, :parent => :service_offer do |offer|
			offer.association :advertiser, :factory => :austin_advertiser
			offer.association :address, :factory => :austin_address
		end

		Factory.define :austin_mobile_offer, :parent => :austin_service_offer do |offer|
		  offer.mobile true
		end
	end
end