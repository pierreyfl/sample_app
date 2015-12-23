require 'paypal_processor'

class SubscriptionsController < ApplicationController 
  before_action :authenticate_user!
  before_action :set_user

  def create
    @subscription = @user.subscriptions.where(subscriber: current_user).first
    @subscription = @user.subscriptions.new(subscriber: current_user) if @subscription.blank? 
    
    if @subscription.save
      process_paypal
    else
      redirect_to user_path(@user), flash: { error: 'Failed to subscribe on Author' }
    end
  end
  
  def unsubscribe 
    @subscription = @user.subscriptions.where(subscriber: current_user).first
    
    if @subscription.destroy
      redirect_to user_path(@user), flash: { notice: 'You have successfully unsubscribe to the Author' }
    else
      redirect_to user_path(@user), flash: { error: 'Failed to unsubscribe on Author' }
    end
  end


private
  def process_paypal
    processor = PaypalProcessor.new(@subscription, paypal_params)
    processor.process!

    if processor.success?
      subscriber = @subscription.subscriber
      subscriber.follow!(@user)
      redirect_to processor.redirect_url, flash: { notice: 'You have successfully subscribe to the Author' }
    else
      flash[:error] = "Unable to contact Paypal. Please try again."
      redirect_to user_path(@user)
    end
  end

  def paypal_params
    host = Rails.env.development? ? Rails.application.secrets['TUNNEL_URL'] : "#{request.protocol}#{request.host_with_port}"
    
    {
      cancel_url: "#{host}#{user_path(@user)}",
      return_url: "#{host}#{user_path(@user)}",
      user_email: @user.paypal_email,
      ipn_url: paypal_ipn_url
    }
  end

  def set_user
    @user = User.find params[:user_id]
  end
end
