#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'community_offers_daemon')

daemon = CommunityOffersDaemon.new('async_test')

daemon.run do
  mq = MQ.new
  topic = mq.topic("model-change")  
  
  queue1 = mq.queue("q1").bind(topic, :key => "Advertiser.update")
  
  queue1.subscribe do |header, msg|
    daemon.logger.info "update - #{msg}"
    advertiser = Advertiser.find(msg)
    daemon.logger.info advertiser.name
    
    # puts "update"
    # puts header.inspect
    # puts msg
  end
  
  queue2 = mq.queue("q2").bind(topic, :key => "#.#")
  
  queue2.subscribe do |header, msg|
    daemon.logger.info "everything - #{msg}"
    # puts "evertything"
    # puts header.inspect
    # puts msg
  end
end
