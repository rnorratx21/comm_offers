class AdminNotifier < MadMimiMailer
  def mimi_new_offer(admin_email, offer)
    subject "Important! A new offer is awaiting approval at Communityoffers.com"
    recipients admin_email
    from "support@communityoffers.com"
    body :timestamp => Time.now.to_s(:long), :offer_url => admin_offer_url(offer)
  end

  def mimi_offer_change(admin_email, offer, user)
    subject "Important! An offer has been edited at communityoffers.com"
    recipients admin_email
    from "support@communityoffers.com"
    body :username => user.email, :timestamp => Time.now.to_s(:long), :offer_url => admin_offer_url(offer)
  end

  private

  def self.admin_emails
    User.admins.collect(&:email)
  end

end


