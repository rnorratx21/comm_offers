class AffiliateOffersController < ApplicationController

  def show
    if params[:id] =~ /^\d+$/
      @offer = AffiliateOffer.find(params[:id])
    else
      @offer = AffiliateOffer.find_by_kind(params[:id])
    end
    raise ActiveRecord::RecordNotFound if @offer && !@offer.active?
  end
end
