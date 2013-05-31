class TestSupport::OffersController < TestSupport::FactoryController		
	def exclusive
	  offers = relavent_offers
	  
		offers.each do |offer|
			offer.update_attributes :exclusive => true
		end
		
		render :text => "exclusive #{offers.length} offers"
	end
	
	def mobile
	  offers = relavent_offers	  
	  
		relavent_offers.each do |offer|
			offer.update_attributes :mobile => true
		end
		
		render :text => "mobilized #{offers.length} offers"
	end
	
	def relavent_offers
	  offer_id = params[:value].to_i
		count = params[:i] or 1
		
		if offer_id
			Offer.find :all, :conditions => { :id => offer_id }
		else
			Offer.find :all, :limit => count
		end		
  end
	
	def reindex
		Offer.reindex
		render :text => "reindexed"
	end

	def delete
		id = params[:id]
		
		offer = Offer.find :first, :conditions => { :id => id }
		
		if offer.blank?
			render :text => "offer #{id} not found"
		else
			address_id = offer.advertiser.address.id
			offer.advertiser.address.destroy
			offer.advertiser.destroy
			offer.address.destroy if Address.exists?(address_id)
			offer.destroy
			render :text => "offer #{id} deleted"
		end
	end
end