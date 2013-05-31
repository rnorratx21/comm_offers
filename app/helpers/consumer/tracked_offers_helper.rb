module Consumer::TrackedOffersHelper

  def show_tracked_offer_options?
    current_consumer or !current_user
  end
  
  def row_tag_with_updated_tracked_offer_flag(tracked_offer)
    str = "<tr"
    str += " class='to_updated'" if tracked_offer and last_login and (tracked_offer.updated_at > last_login)
    str += ">"
    str
  end
end
