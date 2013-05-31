desc "Run cron jobs"
task :cron => :environment do

  Rake::Task['gateway:charge'].invoke

end
