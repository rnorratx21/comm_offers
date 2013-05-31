# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

require 'fastercsv'

$stderr.puts "Loading categories."

FasterCSV.foreach("data/categories.csv", :headers => :first_row) do |row|
  type = CategoryType.find_by_name(row["type"]) || CategoryType.create!(:name => row["type"])
  
  type.categories.create! :name => row["name"], :platinum => row["platinum"] == "Y"
end

$stderr.puts "Loading zip codes (this takes awhile...)."
ActiveRecord::Base.transaction do
  FasterCSV.foreach("data/zipcode.csv", :skip_blanks => true, :headers => :first_row) do |row|
    ZipCode.create! :zip_code => row["zip"], :city => row["city"], :state => row["state"], :lat => row["latitude"], :lng => row["longitude"]
  end
end