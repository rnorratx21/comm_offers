require 'rubygems'
require 'daemons'
require File.join(File.dirname(__FILE__), "..", "config", 'environment')

class CommunityOffersDaemon
  def initialize(name)
    @name = name    
    @log_dir = "#{RAILS_ROOT}/log"    
  end
  
  def logger
    @logger ||= Logger.new(File.join(@log_dir, "#{@name}.log"))
  end
  
  def amqp_config
    Qusion::AmqpConfig.new.load_config_opts
  end
  
  def run(&blk)
    Daemons.run_proc(@name, :dir_mode => :normal, :dir => @log_dir) do      
      ActiveRecord::Base.logger = logger

      logger.info "start"
      
      AMQP.start(amqp_config, &blk)
    end
  end  
end

