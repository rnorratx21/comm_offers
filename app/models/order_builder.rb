class OrderBuilder
	def make(items, options={})
		@order = Order.new(options)
		add_given_items items
		add_infered_items
		apply_price_policies
		@order
	end

	def add_given_items(items)
		items.each do |item|
			@order.add item
		end
	end
	
	def add_infered_items
		add_setup_fee if @order.item(OrderItems::PlatinumPlan)
	end

	def apply_price_policies
		first_zip_code_block_is_included if @order.item(OrderItems::GoldPlan) and @order.item(OrderItems::ZipCodeBlock)
		@order.items.each do |item|
			apply_price_policy item
		end
	end
	
	def apply_price_policy(item)
		add_default_price_policy(item) if item.price_policy.nil?
	end
	
	def first_zip_code_block_is_included
		zip_code_block = @order.item(OrderItems::ZipCodeBlock)
		zip_code_block.price_policy = PricePolicies::Included.new
	end
	
	def add_default_price_policy(item)
		item.price_policy = PricePolicies.default
	end
	
	def add_setup_fee
		@order.add OrderItems::SetupFee.new
	end
end