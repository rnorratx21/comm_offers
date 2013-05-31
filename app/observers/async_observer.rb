class AsyncObserver < ActiveRecord::Observer
  observe :advertiser, :offer, :user
  
  def initialize
    $async_enabled = true if $async_enabled.nil?
    super
  end
  
  def disable!
    $async_enabled = false
  end
  
  def enable!
    $async_enabled = true
  end  
  
  def after_create(obj)
    publish(obj, "create")
  end

  def after_update(obj)
    publish(obj, "update")
  end

  def after_save(obj)
    publish(obj, "save")
  end
  
  def after_destroy(obj)
    publish(obj, "destroy")
  end
  
  private
  
  def topic
    Qusion.channel.topic("model-change")
  end
  
  def key(obj, action)
    "#{obj.class.name}.#{action}"
  end
  
  def publish(obj, action)    
    topic.publish(obj.id, :key => key(obj, action)) if $async_enabled && EM::reactor_running?    
  end
end