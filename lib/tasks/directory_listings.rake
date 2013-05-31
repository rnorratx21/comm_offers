namespace :directory_listings do

  task :import => :environment do
    require 'csv'
    parsed_file=CSV::Reader.parse("/directories.csv")
    parsed_file.each  do |row|
      d = DirectoryListing.new
      d.name = row[0]
      d.phone_number = row[1]
      d.address = Address.new
      d.address.street = row[2]
      d.address.city = row[3]
      d.address.state = row[4]
      d.address.zip_code = row[5]
      d.save
    end
  end
end
