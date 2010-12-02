class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.all
  end
  
  def show
    @subscription = Subscription.find(params[:id])
  end
  
  def new
    @subscription = Subscription.new
  end
  
  def create
    @subscription = Subscription.new(params[:subscription])
    
    # Construct the credit card
    creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
    # Setup gateway
    # Provide login information
    gateway = ActiveMerchant::Billing::OgoneGateway.new(
                                                        :login     => "your_login",
                                                        :user      => "your_user",
                                                        :password  => "your_password")
    # Make transaction, the unit is in cent, so we have to * 100
    response = gateway.purchase(params[:subscription][:amount].tso_i * 100, creditcard, :order_id => "1")
    
    # Save subscription information only the transaction is success
    if response.success? &&  @subscription.save
      flash[:notice] = "Successfully created subscription. Gateway respnose:#{response.message}"
      redirect_to @subscription
    else
      flash[:error] = "Error: #{response.message}"
      render :action => 'new'
    end
  end
  
  def edit
    @subscription = Subscription.find(params[:id])
  end
  
  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = "Successfully updated subscription."
      redirect_to @subscription
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    flash[:notice] = "Successfully destroyed subscription."
    redirect_to subscriptions_url
  end
end
