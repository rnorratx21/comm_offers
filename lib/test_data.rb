require File.join(File.expand_path(File.dirname(__FILE__)), 'test_data', 'test_data_factories')

class TestData
	include TestDataFactories
	
	def self.define_factories
		self.new.define_factories
	end
end