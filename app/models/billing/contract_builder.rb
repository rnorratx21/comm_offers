module ContractBuilder
  
  def build_from_order(contract, order, options={})
    # Build the recurring invoices
    invoice = nil 
    recurrence_qty = contract.contract_plan.installments
    
    month_counter = 1
    for event in Recurrence.new(:every => :month, :on => Date.today.day, :until => Date.yesterday+recurrence_qty.months).events
      contract.invoices << invoice = Invoice.new(
        :issue_date => Date.today,
        :due_date => event,
        :period_start => event,
        :period_end => event.advance(:months => 1),
        :status => "open"
      )

      if month_counter == 1
        for item in order.items_by_recurrence(:once)
          invoice.line_items.unshift line_item = LineItem.new(
            :net_amount => item[:price],
            :description => item[:name],
            :quantity => 1,
            :ledger_item => invoice
          )
        end
      end
      
      for monthly_item in order.items_by_recurrence(:monthly)
        invoice.line_items << line_item = LineItem.new(
          :net_amount => monthly_item[:price],
          :description => monthly_item[:name],
          :quantity => 1,
          :ledger_item => invoice
        )
      end 

      if discount = order.discount and month_counter <= discount.months
        invoice.line_items << line_item = LineItem.new(
          :net_amount => discount.actual_amount(order.discountable_amount) * -1,
          :description => "#{discount.promo_code} Discount",
          :quantity => 1,
          :ledger_item => invoice
        )
      end

      month_counter += 1
    end
    return contract    
  end
end