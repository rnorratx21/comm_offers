#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'community_offers_daemon')

daemon = CommunityOffersDaemon.new('indexer')

# TODO: dsl ideas
# topic_daemon(:topic => "model-change", :queue => "offer-indexer", :key => "Offer.save") do |daemon, queue|
#   queue.subscribe do |offer_id|
#   end
# end
#
# mq_daemon do |daemon, mq|
#   queue = mq.queue("foo")
# end
  
daemon.run do
  mq = MQ.new
  topic = mq.topic("model-change")
  
  queue = mq.queue("offer-indexer").bind(mq.topic("model-change"), :key => "Offer.save")
  
  queue.subscribe do |offer_id|
    daemon.logger.info "indexing #{offer_id}"
    offer = Offer.find(offer_id, :include => [ :category, :address, :advertiser ])
    # offer.index!
    # use offer.remove_from_index if we want to remove items from the index
  end
end
