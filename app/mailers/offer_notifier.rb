class OfferNotifier < MadMimiMailer
  def mimi_offer_approved(offer)
    subject "Your offer has been approved"
    recipients emails_for_offer(offer)
    from "customersupport@communityoffers.com"
    body :offer_title => offer.title, :offer_url => offer_url(offer)
  end

  def mimi_offer_disabled(offer)
    subject "Your offer has been disabled"
    recipients emails_for_offer(offer)
    from "customersupport@communityoffers.com"
    body :offer_title => offer.title, :offer_url => offer_url(offer)
  end

  def mimi_offer_re_enabled(offer)
    subject "Your offer has been enabled"
    recipients emails_for_offer(offer)
    from "customersupport@communityoffers.com"
    body :offer_title => offer.title, :offer_url => offer_url(offer)
  end

  def mimi_offer_change_by_admin(offer, admin_user)
    subject "Important! Your offer has been edited at communityoffers.com"
    recipients emails_for_offer(offer)
    from "customersupport@communityoffers.com"
    body :username => admin_user.email, :timestamp => Time.now.to_s(:long), :offer_url => offer_url(offer)
  end

  def mimi_signup_gold_confirmation(offer)
    subject "Congratulations! Your offer has been created at communityoffers.com"
    recipients emails_for_offer(offer)
    from "customersupport@communityoffers.com"
    body :timestamp => Time.now.to_s(:long), :offer_url => offer_url(offer)
  end

  def mimi_signup_platinum_request_confirmation(offer)
    subject "Congratulations! Your offer has been created at communityoffers.com"
    recipients emails_for_offer(offer)
    from "customersupport@communityoffers.com"
    body :timestamp => Time.now.to_s(:long), :offer_url => offer_url(offer)
  end

  private

  def emails_for_offer(offer)
    offer.users.collect(&:email)
  end

end

