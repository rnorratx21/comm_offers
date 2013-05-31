class Partners::SessionsController < ApplicationController
  def new
    setup_partner
  end

  def create
    partner = Partner.find_by_username(params[:partner][:username])
    if partner and partner.password_match?(params[:partner][:password])
      session[:partner_id] = partner.id
      flash[:notice] = "Logged in successfully.  Welcome <strong>#{partner.name}</strong>."
      redirect_to api_index_path
    else
      flash[:error] = "Invalid partner username or password"
      setup_partner
      render :new
    end
  end
    
  def destroy
    reset_session
    cookies.delete :auth_token
    flash[:notice] = "You've logged out successfully!"
    redirect_to partners_login_path
  end

  def setup_partner
    @partner = Partner.new(params[:partner])
  end
end
