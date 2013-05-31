module OffersHelper
  def service_area_zip_codes_markup(offer)
    offer.zip_codes.map { |zip_code| content_tag(:span, zip_code.zip_code, :class => "model_data") }.join(", ")
  end
  
  def zip_code_mappables_data(zip_codes)
    zip_codes.map do |zip_code|
      { 
        :zipCode => zip_code.zip_code,
        :lat => zip_code.lat, :lng => zip_code.lng, 
        :height => 10, :width => 10, 
        :markerIconUrl => @template.marker_icon(:kind => :service_area) 
      }
    end
  end
  
  def tabbed_out_image(offer)
    tabbed_out_title = "#{offer.advertiser.name} is a TabbedOut Customer"
    image_tag 'tabbedout_horiz.gif', :alt => tabbed_out_title, :title => tabbed_out_title
  end

  def offer_page_title(offer)
    "#{offer.business_name} - #{offer.headline} - #{offer.category.name} - #{offer.address.city}" rescue "#{offer.business_name} "
  end

  def payment_method(key)
    label = Offer.payment_full_text(key)
    if key == "tabbed_out"
      return link_to(label, "http://www.tabbedout.com", :target => '_blank')
    end
    label
  end
  
  def offer_label_for(attr)
    case attr
    when :headline
      "Brief Description of OFFER for Search Results Headline"
    when :title
      "Brief Description of YOUR BUSINESS for Search Results"
    when :description
      "Business Details for your Offer Page"
    when :hours
      "Business Hours"
    when :effective
      "Offer Valid Days & Hours"
    when :disclaimers
      "Offer Disclaimers"
    when :expires_on
      "Expiration Date"
    else attr.to_s.humanize.titleize
    end
  end

  def edit_advertiser_fields_instructions
    "The business information shown below is based on the initial information provided by the account holder.  
    If you would like to change the information for this offer, please click on the EDIT links below:"    
  end
  
  def offer_meta_description
    h "#{@offer.title}. #{@offer.address.city} #{@offer.category.category_type.name} - #{@offer.category.name} Deals, Discounts and Coupons."
  end
  
  def google_driving_directions_link(offer,text="See Driving Directions")
    if offer.address
      link_to text, "http://maps.google.com/maps?daddr=#{CGI::escape(offer.address.full)}", :target => '_blank'
    end
  end

  def is_tracking_offer?
    is_tracking?(@offer)
  end

  def is_tracking?(offer)
    current_consumer and current_consumer.is_tracking?(offer)
  end

  def pervasive_image_url(offer)
    "http://app.qiktag.mobi/Code/getTagGraphic.ashx?Tag=#{offer.pervasive_page_id}&Type=Product"
  end

  # def build_offer_permalink_path(offer)
  #   offer_permalink_path(
  #     :city => offer.city_as_permalink, 
  #     :category => offer.category_as_permalink, 
  #     :permalink => offer.permalink
  #   ) rescue offer_path(offer)
  # end
end
