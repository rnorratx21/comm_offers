xml.instruct!
xml.urlset("xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
  "xsi:schemaLocation".to_sym => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
  :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do
  sitemap_page contact_path, xml
  sitemap_page advertise_path, xml
  sitemap_page company_path, xml 
  sitemap_page mobile_offers_path, xml
  sitemap_page terms_path, xml
  sitemap_page login_path, xml
  sitemap_page search_path(:search_text => "austin,tx"), xml
  sitemap_page search_path(:search_text => "houston,tx"), xml
  sitemap_page search_path(:search_text => "san marcos,tx"), xml
  
  Offer.active.each do |offer|
  xml.url do
    xml.loc "http://#{request.host}#{build_offer_permalink_path(offer)}"
    xml.lastmod offer.updated_at.strftime("%Y-%m-%d")
    xml.changefreq "weekly"
    xml.priority 0.9
  end
  end
end
