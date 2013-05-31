module OrderItems
	class Default
	  attr_accessor :name
		attr_accessor :amount
		attr_accessor :price_policy
		attr_accessor :recurrence

		def initialize(params={})
			params = defaults.merge params
			params.each do |key, value|
				instance_variable_set "@#{key}", value
			end
		end
		
		def defaults
			{
				:amount => self.class.default_price,
				:price_policy => PricePolicies.default,
				:recurrence => :monthly
			}
		end
		
		def self.default_price
			0
		end

		def price
			@price_policy.price self
		end
		
		def name
			name = self.class.name.demodulize.titleize
			name << " (#{@price_policy.name})" if not @price_policy.instance_of?(PricePolicies::Default)
			name
		end
		
		def schedule
		  if recurrence == :monthly
		    @schedule ||= Recurrence.new(:every => :month, :on => Date.today.day, :until => Date.yesterday+1.year)
	    end
		end
	end

  class PlatinumPlan < Default
    cattr_accessor :default_price
  end
  
  class GoldPlan < Default
    cattr_accessor :default_price
  end
  
  class SetupFee < Default
    cattr_accessor :default_price
    
    def initialize(params={})
      super({ :recurrence => :once }.merge(params))
    end
  end
  
  class ZipCodeBlock < Default
    cattr_accessor :default_price
    cattr_accessor :zip_codes_per_block
    attr_accessor :zip_codes
  
    def self.build(zip_codes)
      number_of_blocks = (zip_codes.length / zip_codes_per_block.to_f).ceil
      zip_code_blocks = []
      number_of_blocks.times do |i|
        next_10_zip_codes = zip_codes.slice(i * zip_codes_per_block, zip_codes_per_block)
        zip_code_block = new :zip_codes => next_10_zip_codes
        zip_code_blocks << zip_code_block
      end
      zip_code_blocks
    end
  end
end
