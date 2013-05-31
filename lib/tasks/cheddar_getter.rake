namespace :cheddar do
  task :sync_plans => :environment do
    Plan.all.each do |plan|
      puts "Plan #{plan.id} out of sync #{plan.code} vs #{plan.customer.plan.code}" if plan.code != plan.customer.code
    end
  end
end
