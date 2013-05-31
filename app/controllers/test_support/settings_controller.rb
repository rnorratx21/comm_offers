class TestSupport::SettingsController < ApplicationController
	def set
		name = params[:name]
		value = params[:value]
		expr = "$__#{name} = #{value}"
		eval(expr)
		render :text => expr
	end
end