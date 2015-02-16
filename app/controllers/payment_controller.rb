class PaymentController < ApplicationController
  
  def index
   
  end

  def get_express_checkout
    @api = PayPal::SDK::Merchant::API.new

    # Build request object
    @get_express_checkout_details = @api.build_get_express_checkout_details({
      :Token => Checkout.first.token })

    # Make API call & get response
    @get_express_checkout_details_response = @api.get_express_checkout_details(@get_express_checkout_details)

    # Access Response
    if @get_express_checkout_details_response.success?
      @order = Checkout.first 
      @order.update_attribute(:payerID,@get_express_checkout_details_response.GetExpressCheckoutDetailsResponseDetails.PayerInfo.PayerID)
      
    else
      @get_express_checkout_details_response.Errors
    end
    

  end

  def do_express_checkout
    @api = PayPal::SDK::Merchant::API.new
        # Build request object
@do_express_checkout_payment = @api.build_do_express_checkout_payment({
  :DoExpressCheckoutPaymentRequestDetails => {
    :PaymentAction => "Sale",
    :Token => Checkout.first.token,
    :PayerID => Checkout.first.payerID,
    :PaymentDetails => [{
      :OrderTotal => {
        :currencyID => "USD",
        :value => "8.27" },
      :NotifyURL => "http://blistering-vroom-16-180152.apse1.nitrousbox.com/payment/invoice" }] } })

# Make API call & get response
@do_express_checkout_payment_response = @api.do_express_checkout_payment(@do_express_checkout_payment)

# Access Response
if @do_express_checkout_payment_response.success?
  @details= @do_express_checkout_payment_response.DoExpressCheckoutPaymentResponseDetails
  if Confirmdetails.first != nil
    Confirmdetails.create(:ordertotal => @details.PaymentInfo[0].GrossAmount.value, :itemtotal =>@details.PaymentInfo[0].PaymentStatus)
  else
    Confirmdetails.create(:ordertotal => @details.PaymentInfo[0].GrossAmount.value,:itemtotal =>@details.PaymentInfo[0].PaymentStatus)
  end
  redirect_to payment_invoice_path
  
  @do_express_checkout_payment_response.FMFDetails
else
  @do_express_checkout_payment_response.Errors
end
  end

  def invoice
    
  end
  def set_express_checkout
PayPal::SDK.configure({
  :mode => "sandbox", 
  :username => "jb-us-seller_api1.paypal.com", 
  :password => "WX4WTU3S8MY44S7F", 
  :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31A7yDhhsPUU2XhtMoZXsWHFxu-RWy"
})
@api = PayPal::SDK::Merchant::API.new
  @set_express_checkout = @api.build_set_express_checkout({
 	:Version => "104.0",
	:SetExpressCheckoutRequestDetails => {
    :ReturnURL => "http://blistering-vroom-16-180152.apse1.nitrousbox.com/payment/get_express_checkout",
    :CancelURL => "http://blistering-vroom-16-180152.apse1.nitrousbox.com/payment/index",
:PaymentDetails => [{
      :OrderTotal => {
        :currencyID => "USD",
        :value => "8.27" },
      :ItemTotal => {
        :currencyID => "USD",
        :value => "5.27" },
      :ShippingTotal => {
        :currencyID => "USD",
        :value => "3.0" },
      :TaxTotal => {
        :currencyID => "USD",
        :value => "0" },
      :NotifyURL => "http://blistering-vroom-16-180152.apse1.nitrousbox.com/payment/new",
      :ShipToAddress => {
        :Name => "John Doe",
        :Street1 => "1 Main St",
        :CityName => "San Jose",
        :StateOrProvince => "CA",
        :Country => "US",
        :PostalCode => "95131" },
      :ShippingMethod => "UPSGround",
      :PaymentDetailsItem => [{
        :Name => "Apple",
        :Quantity => 1,
        :Amount => {
          :currencyID => "USD",
          :value => "5.27" },
        :ItemCategory => "Physical" }],
      :PaymentAction => "Sale" }] } })
@set_express_checkout_response = @api.set_express_checkout(@set_express_checkout)
    if Checkout.first != nil
      Checkout.delete_all
      a = Checkout.create(:token => @set_express_checkout_response.Token )
    else
      a = Checkout.create(:token => @set_express_checkout_response.Token )
    end
    if @set_express_checkout_response.success?
      redirect_to  'https://www.sandbox.paypal.com/webscr?cmd=_express-checkout&token=' + a.token
else
      redirect_to "http://blistering-vroom-16-180152.apse1.nitrousbox.com/payment/new"
end
   
  end
end
