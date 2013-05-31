class SystemNotifier < ActionMailer::Base
  
  def notification(subject, message=nil)
    @recipients     = ["misbell@communityoffers.com", "dcarolan@communityoffers.com", "nick@communityoffers.com"]
    @from           = "support@communityoffers.com"
    @sent_on        = Time.now
    @subject        = subject
    @body[:message] = message
  end

  def developer_notification(subject, message=nil)
    @recipients     = ["nick@communityoffers.com"]
    @from           = "support@communityoffers.com"
    @sent_on        = Time.now
    @subject        = subject
    @body[:message] = message
  end
  
  def general_inquiry_notification(inquiry)
    @inquiry = inquiry
    @recipients     = ["misbell@communityoffers.com", "nick@communityoffers.com"]
    @from           = "support@communityoffers.com"
    @sent_on        = Time.now
    @subject        = "New Site Inquiry from #{inquiry.full_name}"
    # @body[:message] = message
  end
end