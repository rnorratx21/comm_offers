module SearchHelper
  def proximity_select_options
    [ [ 'All', nil ], [ '1 mile', 1 ], [ '5 miles', 5 ], [ '10 miles', 10 ], [ '25 miles', 25 ] ]
  end
  
  def within_select_options
    [ [ 'All', nil ], [ '1 day', 1 ], [ '7 days', 7 ], [ '30 days', 30 ], [ '120 days', 120 ] ]
  end
  	
	def category_drilldown_path(category, params)
    search_params = params.to_hash

    search_params.delete "page"    
    search_params.merge! "cat" => category
    
    url_for(search_params)
  end  
  
  def search_results_offer_class(offer)
    offer_class = "offer"
    offer_class += " mappable" if offer.mappable?
    offer_class
  end
  
  def offer_distance_from_point(offer, point)
    distance = number_with_precision(offer.distance_from(point), :precision => 1)
		distance = "0" if distance == "0.0"
		distance
  end
  
  def search_result_li(offer, &blk)
    html_options = { :id => "offer_#{offer.id}", :class => search_results_offer_class(offer), "data-featured" => offer.exclusive? }
    html_options.merge!({ "data-lat" => offer.address.lat, "data-lng" => offer.address.lng }) if offer.mappable?
    content_tag(:li, html_options, &blk)
  end

  def is_personalized_search?
    current_user and @search.is_personalized
  end
  
  def list_preferred_values(key)
    vals = current_user.profile.send("preferred_#{key}")
    vals.any? ? vals.collect {|pref| pref.value }.join(", ") : nil
  end


end
