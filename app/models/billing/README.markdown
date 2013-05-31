Billing & Contracts Summary
===========================

[Ticket # 568 in Core](http://core.calcedon.com/issues/show/568)

The billing system is set up with TrustCommerce (or Authorize.net or similar) powered by [ActiveMerchant](http://www.activemerchant.org/). Invoices use the [Ruby Invoicing Framework](http://ept.github.com/invoicing/). This billing system replaces the original Cheddar Getter system. 

A Contract has many Invoices. An Invoice has one or more LineItems. When paid, an Invoice creates a Payment record that references the original Invoice. An Invoice can be paid automatically by credit card (using Invoice#pay!) or manually by the admin by entering cheque payment information. 

Contracts generally contain 12 invoices, one a month for one year. Each invoice is hard-coded, meaning that there's no automatic recurrence. There has to be an invoice for billing to occur. The user may assign more or less than 12 invoices - it's completely up to the person negotiating the contract. 

Likewise, an Invoice has any number of LineItems. A line item may be a setup fee or a regular recurring fee, or some other fee. The description field is free-form, and the net_amount and quantity can be any integer. 

### Dependencies ###

* [Ruby Invoicing Framework](http://ept.github.com/invoicing/)
* [ActiveMerchant](http://www.activemerchant.org/)
* ActiveMerchantExtensions Plugin (in vendor/plugins)
* [Recurrence](http://github.com/fnando/recurrence)


TODO
====

* Reports (see below) 
* Method for billing credit card 
* &#10004; Cron task for automatic billing 
* &#10004; Automatically create & populate a contract when an advertiser signs up (including capturing billing information) 
* Plain-text field for salesperson 



Out-of-Scope
------------

Todo items that the client has requested that fall into the second iteration of this project: 

* Quickbooks integration
* Location/Territory/Salesperson-based permissions

* Assign contracts to salespeople


Business Rules
==============

Platinum vs. Gold. 
-----------------

Platinum offers are more expensive than Gold offers. 

A single zip code can have a maximum of 16 platinum offers. 

## Required Reports:

* Expiring contracts 
* Invoices due in the next 30 days
* Failed billing
* Payment methods
* Offers by plan and zipcode


## Invoice Payment: 

* &#10004; When payment is posted to an invoice, a Billing::Payment object is created. That invoice is then considered paid. 
* &#10004; Default automatic payment by Credit Card
* Admin interface for updating credit card information
* &#10004; Interface for entering cheque or other payment information
* &#10004; Automated billing task to bill credit cards
* &#10004; Paid invoices are not editable. 


## Payment by check and other methods

A Payment ledger item must be created to record payment by cheque or other method. 

## Actions Taken on Contract Expiration

When a contract is about to expire, it should do one of the following: 

* Renew for one entire contract cycle (year), notify
* Hard stop & yank offer
* Extend (& notify):
  * Platinum: quarterly (On the last invoice is paid, add another quarter of at the end.)
  * Gold: month-to-month

## Admin

Admin needs the ability to edit contracts: 

* Assign offers to a contract
* Update billing
* Add invoices to a contract

Admin needs the ability to edit and add invoices in contracts: 

* Add/remove/edit line items

## Advertiser Self-Service

When a user signs up themselves, the UI will work just as it does now. On the final step (Payment), we'll take the [Monthly Charges and setup fees][^1], and turn them into Invoice objects inside the contract. 

When the customer creates a new offer using self-service, the following will happen inside AdvertiserSignup class: 
* build contract
* generate 12 invoices for monthly payments
* generate 1 invoice for setup fees
* capture the credit card details and store the billing token 

## Contract model

The contract model is a big object that contains all the invoices and payments for an Offer. In fact a contract can cover one or more Offers. 


## Capturing billing info

At the end of the signup process (/advertiser/signup/payment), the advertiser will put in their credit card info. ActiveMerchant will authorize the transaction and store the token & other billing data (or check info). 

We need to make sure that the Authorize.Net account includes CIM (Customer Information Manager). THIS IS VERY IMPORTANT. CIM enables us to store the advertisers' billing info remotely and then charge arbitrary amounts at scheduled times according to the contract. We also need a CIM test account. 

[CIM Documentation][^2] can be found at [http://www.authorize.net/support/CIM_XML_guide.pdf][^2]



[^1]: http://skitch.com/ryanheneise/nhxwc/community-offers
[^2]: http://www.authorize.net/support/CIM_XML_guide.pdf