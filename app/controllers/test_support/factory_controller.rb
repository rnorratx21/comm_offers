require 'test_data'

class TestSupport::FactoryController < ApplicationController
	def build
		make :build
	end
	
	def create
		make :create
	end
		
	def destroy_all
		Address.all.each {|m| m.destroy }
		Advertiser.all.each {|m| m.destroy }
		Offer.all.each {|m| m.destroy }
		$seq = 1
		render :text => 'destroyed addresses, advertisers, and offers'
	end
	
	def sequence
		if params[:value]
			$seq = params[:value].to_i
		end
		render :text => "sequence is #{$seq}"
	end
	
	def view
		class_name = params[:value]
		id = params[:id]
		
		if id.blank?
			objects = eval("#{class_name}.all")
			render_models objects
		else
			object = eval("#{class_name}.find #{id}")
			render_model object
		end
	end
	
	private
	def make(strategy)
		TestData.define_factories
		
		name = params[:value].downcase.to_sym
		
		if params[:attributes]
			object = Factory.send strategy, name, params[:attributes]
		else
			object = Factory.send strategy, name
		end
				
		$seq += 1
		
		render_model object
	end
	
	def render_model(object)
		class_name = object.class.name
		text = "<p class=\"#{class_name.underscore}\">#{class_name}</br>"
		object.attributes.each_pair do |k, v|
			text << "#{k}: <span id=\"#{k}\">#{v}</span></br>"
		end
		text << "</p>"		
		render :text => text
	end
	
	def render_models(objects)
		class_name = objects[0].class.name
		text = "<p>#{class_name}</p>"
		
		objects.each do |object|
			text << "<p class=\"#{class_name.underscore}\">"
			object.attributes.each_pair do |k, v|
				text << "#{k}: <span id=\"#{k}\">#{v}</span></br>"
			end
			text << "</p>"
		end
		
		render :text => text
	end
end