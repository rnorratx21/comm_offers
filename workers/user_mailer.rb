#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'community_offers_daemon')

daemon = CommunityOffersDaemon.new('user_mailer')

daemon.run do
  mq = MQ.new
  topic = mq.topic("model-change")  
  
  queue = mq.queue("user-welcome").bind(mq.topic("model-change"), :key => "User.create")
  
  queue.subscribe do |user_id|
    daemon.logger.info "sending email"
    user = User.find(user_id)
    daemon.logger.info "found the user"
    UserNotifier.deliver_mimi_welcome(user)
  end
  
end
