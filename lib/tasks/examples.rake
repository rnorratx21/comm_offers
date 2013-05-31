require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'examples')

namespace :examples do
	task :create => :environment do
		Examples.create
	end
end
