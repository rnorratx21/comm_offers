class OffersController < ApplicationController
  # before_filter :require_user, :only => [:print]
  
  def show
    check_referrer
    @offer = Offer.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  def find_by_permalink
    check_referrer
    @offer = Offer.find_by_permalink(params[:permalink])
    unless @offer
      # try to parse just the "id" value from the end of the permalink
      if id_tokens = params[:permalink].scan(/\d*$/)
        unless id_tokens.first.blank?
          @offer = Offer.find(id_tokens.first) 
          # correct the path
          redirect_to build_offer_permalink_path(@offer) and return false
        end
      end
      flash[:error] = "There was a problem finding the offer at the address you specified. Please search for your offer below."
      redirect_to root_path and return false
    end
    render :show
  end

  def print
    @offer = Offer.find(params[:id]) 

		if @offer.expired?
			render :text => nil, :status => 404
		else
	    render :layout => false
		end
  end
  
  def check_referrer
    if request.referrer =~ /\/search/
      @referrer = request.referrer
    end
  end

  def sms_redemption_get
    txt = params_as_msg("sms_redemption_get")
    render :text => txt
  end
  
  def sms_redemption_post
    txt = params_as_msg("sms_redemption_post")
    render :text => txt
  end

  # def sms_redemption
  #   txt = params_as_msg("sms_redemption_get")
  #   render :text => txt
  # end

  private 
  def params_as_msg(the_action)
    msg = "action #{the_action} called: \n\n"
    params.keys.each do |param|
      msg << "#{param}: #{params[param]} <br>"
    end
    subject = "OffersController - sms redemption called"
    
    tmail = SystemNotifier.deliver_developer_notification(subject,msg)
    file = File.open("#{RAILS_ROOT}/data/sms_redemption_#{notification_timestamp.gsub(":","_").gsub("/","_")}.txt", 'w') do |f| 
      msg = "#{tmail.inspect} \n\n #{tmail.body}"
      f.write(msg)
      f.close
    end
    msg
  end

end
