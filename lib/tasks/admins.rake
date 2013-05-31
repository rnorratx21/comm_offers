namespace :admins do
  desc "Creates admin users"
  task :create => :environment do
    emails = %w{mirven@calcedon.com misbell@communityoffers.com mstephan@calcedon.com dcarolan@communityoffers.com}

    emails.each do |e|
      User.create! :email => e, :password => "coupons!", :password_confirmation => "coupons!", :admin => true
    end
  end
end
