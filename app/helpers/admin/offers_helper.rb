module Admin::OffersHelper
  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    css_class = (column.to_s == params[:c] ? "sorted" : "notsorted") + (params[:d] == 'up' ? "_asc" : "_desc") 
    css_class+=" #{options[:css]}" if options[:css]
    content_tag :th, link_to_unless(condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )), :class => css_class
  end
  
  def render_expires_date(offer)
    "<td class='no_wrap date #{'expired' if offer.expired?}'>#{date_format(offer.expires_on)}</td>"
  end
  
  def show_toggle_tabbed_out
    str = @offer.advertiser.is_tabbed_out_customer? ? "Yes" : "No" 
    str += " | "
    str += link_to("Set to #{@offer.advertiser.is_tabbed_out_customer? ? 'No' : 'Yes'}", toggle_tabbed_out_status_admin_offer_path(@offer), :method => :put)
    str
  end
  
end