module AdminHelper
  def pose_as_user_link(user, text="pose as")
    link_to text, pose_admin_user_path(user), :method => :post
  end
  
  def formatted_currency(amount, options={})
    Invoicing::CurrencyValue::Formatter.format_value("USD", amount, options)
  end
  
  def active_if(active)
    if active.is_a?(Array)
      "active" if active.include?(params[:controller])
    elsif active.is_a?(Hash)
      "active" if current_page?(active)
    else
      "active" if active == params[:controller]
    end # if active.is_a?(Array)
  end
end
