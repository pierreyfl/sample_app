class PaypalPermissionException < StandardError; end
class PaypalPermission

  VALID_PERMISSIONS = %w(
    EXPRESS_CHECKOUT
    DIRECT_PAYMENT
    AUTH_CAPTURE
    AIR_TRAVEL
    ACCESS_BASIC_PERSONAL_DATA
    ACCESS_ADVANCED_PERSONAL_DATA
    TRANSACTION_SEARCH
    RECURRING_PAYMENTS
    ACCOUNT_BALANCE
    ENCRYPTED_WEBSITE_PAYMENTS
    REFUND
    BILLING_AGREEMENT
    REFERENCE_TRANSACTION
    MASS_PAY
    TRANSACTION_DETAILS
    NON_REFERENCED_CREDIT
    SETTLEMENT_CONSOLIDATION
    SETTLEMENT_REPORTING
    BUTTON_MANAGER
    MANAGE_PENDING_TRANSACTION_STATUS
    RECURRING_PAYMENT_REPORT
    EXTENDED_PRO_PROCESSING_REPORT
    EXCEPTION_PROCESSING_REPORT
    ACCOUNT_MANAGEMENT_PERMISSION
    INVOICING
  )

  attr_reader :api, :scope, :url, :response, :access_api

  def initialize(scope = [], url = "")
    @scope = scope
    @url = url
    @api = PayPal::SDK::Permissions::API.new
  end

  def request_token
    fail PaypalPermissionException.new "Invalid permission" unless scope_valid?
    fail PaypalPermissionException.new "Invalid url" unless url.present?

    @response = api.request_permissions(build_request)
  end

  def request_access_token(params)
    @response = api.get_access_token build_access_token(params[:request_token], params[:verification_code])
  end


  def request_email(token, token_secret)
    @api = PayPal::SDK::Permissions::API.new token: token,
      token_secret: token_secret

    @response = @api.get_basic_personal_data attributeList: {
                  :attribute => [ "http://axschema.org/contact/email" ] }
    @response.response.personalData.first.personalDataValue
  end

private

  def build_request
    api.build_request_permissions scope: scope, callback: url
  end

  def build_access_token(token, verifier)
    api.build_get_access_token token: token, verifier: verifier
  end

  def scope_valid?
    return false if scope.blank?
    VALID_PERMISSIONS.select { |i| scope.include? i }.present?
  end

end

