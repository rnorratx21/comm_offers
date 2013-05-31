module PricePolicies
	def self.default
		Default.new
	end
	
	class Default
		def price(item)
			item.amount
		end
		
		def name
			self.class.name.demodulize.titleize
		end
	end

	class Included < Default
		def price(item)
			0
		end
	end
end