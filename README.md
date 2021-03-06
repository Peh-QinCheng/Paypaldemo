# Paypaldemo


## Introduction

I chose to use ruby on rails for the website and integration with Paypal’s express checkout api. 

The whole process consist of 3 API call:

1. SetExpressCheckout : nested in set_express_checkout method
2. GetExpressCheckout : nested in get_express_checkout method
3. DoExpressCheckout  : nested in do_express_checkout method

The models used in this website are:

1. Checkout model : stores token and payerID
2. Confirmdetails model : stores payment status and amount paid. Used in invoice. 

## API Calls

These 3 API call are nested in methods within the main controller of the website: payment_controller.rb. 

1. Upon pressing the Expresscheckout button, set_express_checkout method would be called. A token value would be received
  and stored in the checkout model.

2. The user is directed to the sandbox paypal site where he inputs his account details and confirm payments.

3. The user will then be directed to the return_url, which is directed to a confirmation page in the local site.
  get_express_checkout is executed and the payerID accessed from the api response will be stored in the Checkout model. 

4. Upon pressing 'confirm', token and payerID will be used to make the final api call, do_express_checkout, which will 
  confirm the payment and return information that can be used for invoicing. 
