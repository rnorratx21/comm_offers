#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'community_offers_daemon')
require 'rufus/scheduler'

daemon = CommunityOffersDaemon.new('cron')

daemon.run do
  scheduler = Rufus::Scheduler.start_new

  scheduler.every '5s' do
    MQ.queue('foo').publish('marcus@marcusirven.com')
  end
end

# TODO, create a dsl like this for publishing messages
# scheduler do |sched|
#   sched.every '1m', :queue => "foo"
#   sched.every '5s', :topic => "abc", :key => 'foo.abc'
#   sched.every '5s', :topic => "abc", :key => 'foo.abc'
#   sched.every '5s', :fanout => "bar"
# end