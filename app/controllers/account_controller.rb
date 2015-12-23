require 'paypal_permission'

class AccountController < ApplicationController
  before_action :set_user
  before_action :check_if_author

  def index
  end

  def update 
    if current_user.update user_params
      redirect_to account_index_path, flash: { notice: 'Subscription settings has been updated' }
    else
      redirect_to account_index_path, flash: { error: 'An error occur while updating subscription setting' }
    end
    
  end
  
  # Paypal setup for Authors
  #
  def payment_setup
    api = PaypalPermission.new ['ACCESS_BASIC_PERSONAL_DATA'], request_access_account_url(@user)
    response = api.request_token

    if response.success?
      redirect_to Rails.application.secrets['PAYPAL_PERMISSION_URL'] + response.token
    else
      flash[:error] = 'Unable to get Paypal token. Please try again.'
      redirect_to account_index_path
    end
  end

  def request_access
    response = PaypalPermission.new.request_access_token params

    if response.success?
      save_paypal_email_from response
    else
      flash[:error] = "Unable to get Paypal token. Please try again."
    end

    redirect_to account_index_path 
  end

private
  def set_user
    @user = current_user || User.find(params[:id])
  end
  
  def user_params
    params.require(:author).permit(:subscription_fee, :needs_subscription)
  end


  def check_if_author
    return redirect_to(root_path), flash: { error: 'Unable to access page' } unless @user.author?
  end

  def save_paypal_email_from(response)
    email = PaypalPermission.new.request_email response.token, response.token_secret

    if @user.update_attributes(paypal_email: email, paypal_token: response.token, paypal_token_secret: response.token_secret, paypal_scope: response.scope.join(' '))
      return flash[:notice] = 'Paypal account is now set up'
    else
      return flash[:error] = 'Failed to setup Paypal account'
    end
  end

end
