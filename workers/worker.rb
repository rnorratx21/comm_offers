#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'community_offers_daemon')

daemon = CommunityOffersDaemon.new('worker')

daemon.run do
  MQ.queue('foo').subscribe do |msg|
    daemon.logger.info msg
  end
end
