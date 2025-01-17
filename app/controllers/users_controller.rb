class UsersController < ApplicationController
  if ENV["RAILS_ENV"] == "production"
    ssl_required :new, :create, :show, :edit, :update   
  end

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default user_dashboard_url(@user)
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
    if @user.advertiser
      @advertiser = @user.advertiser
      @all_offers = @advertiser.offers
      if @advertiser.offers.size == 1
        @offer = @advertiser.offers.last
      end
    end
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
