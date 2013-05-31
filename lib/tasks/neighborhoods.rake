require 'fastercsv'
namespace :neighborhoods do
  desc "Load the neighborhood data"
  task :load => :environment do
    FasterCSV.foreach("#{RAILS_ROOT}/data/Maponics_Neighborhoods_Houston_wkt.txt", :col_sep => "|", :headers => true) do |row|
      Neighborhood.create! :name => row["neighborhd"], :lat => row["cenlat"], :lng => row["cenlon"], :city => "Houston", :state => "TX"
    end
  end
end