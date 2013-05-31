class UserNotifier < MadMimiMailer
  def mimi_welcome(user)
    subject "Welcome to CommunityOffers.com"
    recipients user.email
    from "support@communityoffers.com"
    body :username => user.email, :login_url => login_url
  end

  def mimi_password_reset_instructions(user)
    subject "Password reset on CommunityOffers.com"
    recipients user.email
    from "support@communityoffers.com"
    body :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
