require 'examples'

class TestSupport::ExamplesController < ApplicationController
	def create
		Examples.create
		redirect_to '/test_support/factory/view/Offer'
	end
end