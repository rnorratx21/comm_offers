class Order	
	attr_reader :items
	attr_accessor :advertiser_id
  # attr_accessor :selected_plan_key
  # attr_reader :monthly_discount

  def initialize(contract)
    plan = contract.contract_plan
    @items = [
      {:name => plan.name,
       :recurrence => :monthly,
       :price => plan.installment_amount
      }
    ]
    group_contract_plan = contract.group_contract_plan
    contract.contract_features.each do |cf|
      feature = cf.feature
      price = begin
        if group_contract_plan
          group_contract_plan.group_contract_plan_features.find_by_feature_id(feature).amount
        else
          contract.contract_plan.contract_plan_features.find_by_feature_id(feature).amount
        end
      end
      @items += [
        {:name => "Add-On: #{feature.description}",
          :recurrence => :monthly,
          :price => price
        }
      ]
    end
    if plan.setup_amount > 0
      @items += [
        {:name => "Setup Fee",
          :recurrence => :once,
          :price => plan.setup_amount
        }
      ]
    end
    if contract.contract_discount
      @discount_id = contract.contract_discount.discount_id
    end
    @selected_plan_key = plan.system_key
    # if @discount_id
    #   @monthly_discount = discount.actual_amount(self.class.subtotal(@items))
    # end

  end

  def add(item)
    @items << item        
  end
  
	def items_by_recurrence(recurrence)
		@items.select do |item| 
      puts "item :#{item.class}"
		  item[:recurrence] == recurrence
	  end
	end
	
	def discount
	  if @discount_id
      Discount.find(@discount_id) 
    end
  end

	def total
    self.class.sum_items @items
	end
	
	def discountable_amount
    discount.actual_amount(ContractPlan.find_by_system_key(@selected_plan_key).installment_amount)
  end
	
	def self.subtotal(items)
	  subtotal = (items.collect { |item| item[:price] }).inject() { |sum, price| sum + price }
  end

	def self.sum_items(items)
    (items.collect { |item| item[:price] }).inject() { |sum, price| sum + price }
	end

  # def self.derive_discount_first_month(subtotal, discount)
  #   return 0 unless discount
  #   @monthly_discount = discount.actual_amount(subtotal)
  # end

end
