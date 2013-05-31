module Admin::ContractsHelper
  
  def address
    advertiser.address
  end
  
  def advertiser
    @contract.advertiser
  end
  
  def offers
    @contract.offers
  end

  def salesperson_options
    User.non_consumer.by_role(Role::SALES.id, :order => "last_name asc").all.sort_by(&:name_for_sort).collect{|u| [u.display_name, u.id]}
  end

  def sales_area_options
    SalesArea.by_name.collect{|sa| [sa.name,sa.id]}
  end
  
  def suggested_sales_area
    if !@contract.sales_area and @contract.suggested_sales_area
      content_tag :div, :class => 'suggestion' do 
        "Suggested Sales Area: #{@contract.suggested_sales_area.name}"
      end
    end
  end
end
