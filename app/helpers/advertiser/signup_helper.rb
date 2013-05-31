module Advertiser::SignupHelper
  def nav_step(step)
    @nav_step = step
  end

  def signup_update_form(options={}, &blk)
    form_for(@advertiser, { :url => advertiser_signup_path, :html => { :method => :put }.merge(options) }, &blk)
  end

  def signup_previous_link(form)
    link_to "Previous", previous_advertiser_signup_path, :method => :put
  end
  
  def cancel_link
    link_to("Cancel", cancel_advertiser_signup_path, :class => 'cancel', :method => :put)
  end

  def current_step_tag
    hidden_field_tag :current_step, @current_step#session[:current_step]
  end

  def category_types_for_column(column)
    types = CategoryType.by_name
    # offset_to_balance = 1
    col_length = types.length / 3 #+ types.length % 2 # + offset_to_balance
    if column == 1 
      types.slice(0, col_length)
    elsif column == 2
      types.slice(col_length+1, col_length)
    else
      types.slice((col_length*2)+1, types.length)
    end
  end

  def current_category_type_selected?(current_category_type)
    if default_offer.category
      default_offer.category.category_type == current_category_type
    end
  end

  def default_offer
    @advertiser.offers.first
  end

  def build_offers_for_advertisers
    @advertiser.offers.build if @advertiser.offers.empty?
  end

  def signup_step_tab(name, step, addl_steps=[])
    add_active = (step == @current_step) || (addl_steps.include?(@current_step))
    "<div class='#{"active " if add_active}rounded'>#{name}</div>"    
  end

  def signup_step_header(num, txt)
    "<h2 class='rounded'><span class='step_image'>#{signup_step_img(num)}</span><span class='step_txt'>#{txt}</span><span class='clear'></span></h2>"
  end

  def signup_step_img(num)
    image_tag("signup/step_#{num}.png", :alt => "Step #{num}", :title => "Step #{num}")
  end

  def selected_plan
    @sp ||= @offer.contract.contract_plan
  end

  def render_plan_benefit_checkmark(plan)
    txt = "Included in #{plan.to_s.titleize} Plan"
    image_tag 'check.png', :alt => txt, :title => txt
  end

  def show_jump_to_preview?
    return false unless @current_step == "offer"
    session[:advertiser_signup] && session[:advertiser_signup][:has_reached_preview]
  end

  def plan_summary_title(plan)
    str = "<div class='plan_title'>"
    str += image_tag("signup/plan_summary_#{plan.system_key}.png", :alt => plan.name, :title => plan.name)
    str += "</div>"
    str
  end
  
  def plan_summary_price_line(plan)
    show_general_discounts = ((plan.contract_plan_discounts.size > 0) and !@offer.available_group_contract_plan(plan))
    str = "<div class='price'>#{"<div class='base'>" if show_general_discounts}#{price_line(plan.installment_amount)}#{"</div>" if show_general_discounts}</div>"
    if show_general_discounts
      discount = plan.contract_plan_discounts.first.discount
      str += "<div class='price discount'>#{price_line(plan.installment_with_discount(discount))}</div>"
      str += "<div>for your first #{discount.months} months!</div>"
      str += discount_entry_instructions(discount)
    end
    str
  end
  
  def discount_entry_instructions(discount)
    %{<div class='discount_special_offer'>* Special price available by entering discount code 
      <span class='promo_code'>#{discount.promo_code}</span> on the agreement screen!</div>
    }
  end

  def render_group_contract_plan_discount_coupons
    str = ""
    ContractPlan.active.each do |plan|
      if group_plan = @offer.available_group_contract_plan(plan) and !group_plan.group_contract_plan_discounts.empty?
        plan_discount = group_plan.group_contract_plan_discounts.first
        str += render(:partial => "advertiser/signup/discount_coupon", :locals => {
          :discount => plan_discount.discount, 
          :plan => plan,
          :group_plan => group_plan
        })
        # str += ""
      end
    end
    str
  end
  
  def render_discount_reminder
    unless @offer.contract.contract_discount
      discount = @offer.get_discount
      locals = {:plan => @offer.contract.contract_plan, :discount => discount}
      locals.merge!(:group_plan => @offer.contract.group_contract_plan) if @offer.contract.group_contract_plan
      render(:partial => "advertiser/signup/discount_coupon", :locals => locals)
    end
  end
  
  def price_line(installment_amt)
    "<span class='dollar'>$</span>#{installment_amt}<span class='period'>/mo</span>"
  end

  def plan_selection_line(form, plan)
    str = "<div class='plan_selection_buttons'>"
    str += form.submit "Select #{plan.name}", :name => "plan[#{plan.system_key}]"
    str += "</div>"
    str
  end
  
  def render_discount_value(discount,plan)
    if (discount.percent_off == 100) || (discount.amount_off == plan.installment_amount)
      return "Free "
    end
    discount.amount_off ? "$#{discount.amount_off} Off" : "#{discount.percent_off}% Off"
  end
  
  def group_contract_plan
    @offer.contract.group_contract_plan
  end

  def addons_available_for_all_plans
    Feature.all_addon.uniq
  end
  
  def addon_options_for_selected_plan
    if group_contract_plan
      group_contract_plan.group_contract_plan_features
    else
      selected_plan.addon_features
    end
  end
  
  def feature_selected?(addon)
    @offer.contract.contract_features.find_by_feature_id(addon.feature_id)
  end
  
  def order_discount(order)
    order.discount.actual_amount(order.discountable_amount)
  end
  
  def order_monthly_total(order)
    subtotal = Order.sum_items(order.items_by_recurrence(:monthly))
    if order.discount
      subtotal - order.discountable_amount
    else
      subtotal
    end
  end
  
  def signup_arrow
    image_tag "signup/signup_arrow.png"
  end
  
  def signup_headline
    "More customers. Repeat customers. Profitable customers."
  end
  
  def agreement_text
    if contract_upgrade_requested?
      "I have read and agree to the terms and conditions of this advertising 
      agreement. I understand I am placed on the Priority Waiting List for the 
      next available Loyalty Card for my area."
    else
      "I have read and agree to the terms and conditions of this advertising agreement."
    end
  end
  
  def payment_icon(filename)
    image_path("signup/payment/#{filename}.gif")
  end
end