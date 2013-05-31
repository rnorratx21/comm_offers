# See http://media.railscasts.com/videos/130_monitoring_with_god.mov

RAILS_ROOT = File.join(File.dirname(__FILE__), "..")

God.watch do |w|  
  script = File.join(RAILS_ROOT, "background", "worker.rb") 
  
  w.name = "worker"
  w.interval = 30.seconds   
  w.start = "#{script} start"
  w.stop = "#{script} stop"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.stop_grace = 60.seconds
  w.pid_file = File.join(RAILS_ROOT, "log", "worker.pid") 
  
  w.behavior(:clean_pid_file)
  
  # w.monitor
  
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end
  
  # w.restart_if do |restart|
  #   restart.condition(:memory_usage) do |c|
  #     c.above = 100.megabytes
  #     c.times = [3,5] # 3 out of 5 times
  #   end
  #   
  #   restart.condition(:cpu_usage) do |c|
  #     c.above = 80.percent
  #     c.times = 5
  #   end
  # end
  
  # w.lifecycle do |on|
  #   on.condition(:flapping) do
  #   end
  # end
end

