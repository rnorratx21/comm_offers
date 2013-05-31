module HomeHelper
  def checkapro_offer
    Offer.find_by_id(191)
  end

  def link_for_featured_partner(img_name, path)
    link_to image_tag("home/featured_partners/#{img_name}"), path, :target => '_blank'
  end

  def sitemap_page(path, xml)
    xml.url do
      xml.loc "http://#{request.host}#{path}"
      xml.lastmod Date.today.strftime("%Y-%m-%d")
      xml.changefreq "monthly"
      xml.priority 0.8
    end

  end
  
  def offer_logo_for_home(offer)
    url = if offer.alternate_logo and !offer.alternate_logo.blank?
      offer.alternate_logo.normal.url
    elsif !offer.logo.blank?
      offer.logo.normal.url
    end
    image_tag(url, :width => 108, :height => 108) if url
  end

end