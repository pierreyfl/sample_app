class PaypalProcessorException < Exception; end

class PaypalProcessor
  attr_accessor :paypal_api, :params, :subscription

  SECRETS = Rails.application.secrets

  def initialize(subscription, params = {})
    @subscription = subscription 
    @params = params
  end

  def process!
    @response = paypal_api.pay(build_pay_request)

    # NOTE: Uncomment if PAYPAL_BN_CODE is ever needed
    # build_payment_options @response.payKey

    @subscription.update_attributes paypal_pay_key: @response.payKey if success?
    raise PaypalProcessorException.new(@response.error[0].message) unless success?
  end

  def success?
    @response.success?
  end

  def redirect_url
    details[:paypal][:pay_url]
  end

  def details
    params.tap do |h|
      h[:paypal] = {
        pay_key: @response.payKey,
        pay_url: paypal_api.payment_url(@response)
      }
    end
  end

  def delay_post_processing?
    true
  end

private

  def application_fees
    (subscription_amount * 0.05).round(2).to_f
  end

  def subscription_amount
    @subscription.author.subscription_fee
  end

  def paypal_api
    @paypal_api ||= PayPal::SDK::AdaptivePayments.new
  end

  def build_pay_request
    #remove_app_from_receivers(paypal_params) if application_fees.zero?
    paypal_api.build_pay(paypal_params)
  end

  def ipn_url
    Rails.env.development? ? "#{SECRETS["TUNNEL_URL"]}/callbacks/paypal_ipn" : params[:ipn_url]
  end

  #def remove_app_from_receivers(paypal_params)
    #paypal_params[:receiverList][:receiver].delete_if do |h|
      #h[:email] == SECRETS["PAYPAL_EMAIL"]
    #end

    ## Paypal will complain if there's only one receiver
    ## and it has a primary tag.
    #if paypal_params[:receiverList][:receiver].count < 2
      #paypal_params[:receiverList][:receiver].each do |i|
        #i.tap { |h| h.delete(:primary) }
      #end
    #end
  #end

  # Marketing shit. If you do not know what a PAYPAL_BN_CODE is, do not use.
  def build_payment_options(pay_key)
    opts = paypal_api.build_set_payment_options({
      payKey: pay_key,
      senderOptions: {
        referrerCode: SECRETS["PAYPAL_BN_CODE"]
      }
    })

    # insert custom option logic here

    paypal_api.set_payment_options opts
  end

  def paypal_params
    {
      actionType:         "PAY",
      cancelUrl:          params[:cancel_url],
      currencyCode:       "USD",
      feesPayer:          "SENDER",
      ipnNotificationUrl: ipn_url,
      receiverList: {
        receiver: build_receiver_list
      },
      
      returnUrl: params[:return_url]
    }
  end

  def build_receiver_list
    receivers = [
      {
        amount:  subscription_amount,
        email:   params[:user_email]
      }
    ]

    # insert custom receiver logic here

    receivers
  end

end

