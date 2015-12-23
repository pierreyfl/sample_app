class CallbacksController < ActionController::Base
  protect_from_forgery except: [:paypal_ipn]

  def paypal_ipn
    if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
      subscription = Subscription.where(paypal_pay_key: params[:pay_key]).first

      if subscription && !subscription.paid?
        process_paypal_order subscription 
      else
        raise "Unpaid Subscription with pay key #{params[:pay_key]} not found"
      end
    else
      # need a better way to handle this
      raise 'Invalid paypal ipn request'
    end
    
    head :ok
  end

private

  def process_paypal_order(subscription)
    params.delete :action
    params.delete :controller

    if params["transaction"]["0"][".status"] == "Completed"
      subscription.update(payment_status: 'paid')
    end
  end

end
