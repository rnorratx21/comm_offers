namespace :db do
	namespace :seeded do
	      
    task :delete_database do
      db = "db/development.sqlite3"
      rm db if File.exist? db
    end
	  
		desc "Creates seeded database"
    task :create => [:delete_database, :environment] do
      
      database = "db/development.sqlite3"      
      db_name = File.basename(database, ".sqlite3")  
      
      seeded_database = File.join "db", "#{db_name}-seeded.sqlite3"
			
      ActiveRecord::Migrator.migrate("db/migrate/", 20091107020940)
      Rake::Task['db:seed'].execute
			
      rm seeded_database if File.exist? seeded_database
			
      cp database, seeded_database
		end
		
		desc "Creates a brand new database and a seeded database to be used with restore."
		task :new => [:create, :restore] 
    
    desc "Copies seeded database over application database"
    task :restore => :environment do
			config = Rails::Configuration.new
			database = config.database_configuration[RAILS_ENV]["database"]			
			db_name = File.basename(database, ".sqlite3")  
			seeded_database = File.join "db", "#{db_name}-seeded.sqlite3"

			cp seeded_database, database
			
			Rake::Task['db:migrate'].execute
    end
  end
end
