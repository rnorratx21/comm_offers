class AuditObserver < ActiveRecord::Observer
  observe :audit

  def changed_offers(auditable)
    case auditable
    when Advertiser then auditable.offers
    when Offer then [auditable]
    end
  end

  def notify_admin_of_change(offer, user)
    AdminNotifier.admin_emails.each do |email|
      #AdminNotifier.deliver_mimi_offer_change(email, offer, user)
    end
  end

  def notify_user_of_change_by_admin(offer, user)
    #OfferNotifier.deliver_mimi_offer_change_by_admin(offer, user) if offer.users.count > 0
  end
  
  def after_create(audit)
    return unless audit.action == "update"

    offers = changed_offers(audit.auditable)

    return if offers.nil?

		if audit.user # because this thing is all tight coupling and procedural programming. i appologise for this if statement having to be here.
	    if audit.user.admin?
	      offers.each { |o| notify_user_of_change_by_admin(o, audit.user) }
	    else
	      offers.each { |o| notify_admin_of_change(o, audit.user) }
	    end
		end
  end
end
