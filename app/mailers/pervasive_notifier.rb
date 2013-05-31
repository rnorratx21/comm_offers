class PervasiveNotifier < ActionMailer::Base
  
  def notification(subject, message)
    @recipients     = ["nick@communityoffers.com"]
    @from           = "support@communityoffers.com"
    @sent_on        = Time.now
    @subject        = subject
    @body[:message] = message
  end
end