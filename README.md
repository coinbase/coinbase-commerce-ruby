[![CircleCI](https://circleci.com/gh/coinbase/coinbase-commerce-ruby/tree/master.svg?style=svg)](https://circleci.com/gh/coinbase/coinbase-commerce-ruby/tree/master)

# coinbase-commerce-ruby
Coinbase Commerce Ruby Gem

# Table of contents

<!--ts-->
   * [Ruby Versions](#ruby-version)
   * [Third Party Libraries and Dependencies](#third-party-libraries-and-dependencies)
   * [Documentation](#documentation)
   * [Installation](#installation)
   * [Usage](#usage)
      * [Checkouts](#checkouts)
      * [Charges](#charges)
      * [Events](#events)
   * [Validating webhook signatures](#validating-webhook-signatures)
   * [Testing and Contributing](#testing-and-contributing)
<!--te-->

## Ruby Version
Ruby 2.3, 2.4, 2.5, 2.6RC are supported and tested.

## Third Party Libraries and Dependencies

The following libraries will be installed when you install the client library:
* [faraday](https://github.com/lostisland/faraday)

## Documentation

For more details visit [Coinbase API docs](https://commerce.coinbase.com/docs/api/).

To start using library, you need to register on [Commerce SignUp](https://commerce.coinbase.com/signup).
And get your ``API_KEY`` from user settings.

Next create a ``Client`` object for interacting with the API:
```ruby
require 'coinbase_commerce'

API_KEY = "API KEY"
client = CoinbaseCommerce::Client.new(api_key: API_KEY)

```

``Client`` contains links to an every Ruby Class representations of the API resources
``Checkout, Charge, Event``

You can call ``list, auto_paging, create, retrieve, modify`` methods from an API resource classes

```ruby
client.charge.create
client.checkout.auto_paging 
client.event.list
client.charge.retrieve
client.checkout.modify
```
as well as ``save, delete, refresh`` methods from API resource class instances.
```python
checkout = client.checkout.retrieve <id>
checkout.refresh
checkout.save
checkout.delete
```

Each API method returns an ``APIObject`` representing the JSON response from the API, all of the models are support hash and JSON representation.\
Also when the response data is parsed into Ruby objects, the appropriate ``APIObject`` subclasses will be used automatically.
All subclasses of ``APIResource`` class support ``refresh`` method. This will update their attributes and all nested data by making a fresh ``GET`` request to the relevant API endpoint.

Client support Common API Errors and Warnings handling.
All errors occuring during interaction with the API will be raised as exceptions.


| Error                    | Status Code |
|--------------------------|-------------|
| APIError                 |      *      |   
| InvalidRequestError      |     400     |   
| ParamRequiredError       |     400     |  
| ValidationError          |     400     |  
| AuthenticationError      |     401     |  
| ResourceNotFoundError    |     404     |
| RateLimitExceededError   |     429     |
| InternalServerError      |     500     |
| ServiceUnavailableError  |     503     |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coinbase_commerce'
```
Then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install coinbase_commerce
```

## Usage
```ruby
require 'coinbase_commerce'

client = CoinbaseCommerce::Client.new(api_key: 'your_api_key')
```
## Checkouts 
[Checkouts API docs](https://commerce.coinbase.com/docs/api/#checkouts)
### Retrieve
```ruby
checkout = client.checkout.retrieve <checkout_id>
```
### Create
```ruby
checkout_info = {
    "name": "The Sovereign Individual",
    "description": "Mastering the Transition to the Information Age",
    "pricing_type": "fixed_price",
    "local_price": {
        "amount": "1.00",
        "currency": "USD"
    },
    "requested_info": ["name", "email"]
}
checkout = client.checkout.create(checkout_info)

# or

checkout = client.checkout.create(:name=>'The Sovereign Individual',
                                  :description=>'Mastering the Transition to the Information Age',
                                  :pricing_type=>'fixed_price',
                                  :local_price=>{
                                          "amount": "100.00",
                                          "currency": "USD"
                                          },
                                  :requested_info=>["name", "email"])                            
```
### Update
```ruby
checkout = client.checkout.retrieve <checkout_id>
checkout.name = 'new name'
checkout.save

# or

client.checkout.modify(<checkout_id>, "local_price": {
    "amount": "10000.00",
    "currency": "USD"
})
```
### Delete
```ruby
checkout.delete
```
### List
```ruby
checkouts = client.checkout.list
```
### Paging list iterations
```ruby
client.checkout.auto_paging  do |ch|
  puts ch.id
end
```
## Charges
[Charges API docs](https://commerce.coinbase.com/docs/api/#charges)
### Retrieve
```ruby
charge = client.charge.retrieve <charge_id>
```
### Create
```ruby
charge_info = {
    "name": "The Sovereign Individual",
    "description": "Mastering the Transition to the Information Age",
    "pricing_type": "fixed_price",
    "local_price": {
        "amount": "1.00",
        "currency": "USD"
    },
    "requested_info": ["name", "email"]
}
charge = client.charge.create(charge_info)

# or

charge = client.charge.create(:name=>'The Sovereign Individual',
                              :description=>'Mastering the Transition to the Information Age',
                              :pricing_type=>'fixed_price',
                              :local_price=>{
                                  "amount": "100.00",
                                  "currency": "USD"
                              })
```
### List
```ruby
charges_list = client.charge.list
```
### Paging list iterations
```ruby
client.charge.auto_paging do |charge|
  puts charge.id
end
```
## Events
[Events API Docs](https://commerce.coinbase.com/docs/api/#events)
### Retrieve
```ruby
event = client.event.retrieve <event_id>
```
### List
```ruby
events = client.event.list
```
### Paging list iterations
```ruby
client.event.auto_paging do |event|
  puts event.id
end
```

## Validating webhook signatures
You could verify webhook signatures using our library.
To perform the verification you'll need to provide the event data, a webhook signature from request header, and the endpoint’s secret.
In case of invalid request signature or request payload, you will receive appropriate error message.
```ruby
WEBHOOK_SECRET = 'your_webhook_secret'

# Using Sinatra
post '/webhooks' do
  request_payload = request.body.read
  sig_header = request.env['HTTP_X_CC_WEBHOOK_SIGNATURE']

  begin
    event = CoinbaseCommerce::Webhook.construct_event(request_payload, sig_header, WEBHOOK_SECRET)
    # event handle
    puts "Received event id=#{event.id}, type=#{event.type}"
    status 200
  # errors handle
  rescue JSON::ParserError => e
    puts "json parse error"
    status 400
    return
  rescue CoinbaseCommerce::Errors::SignatureVerificationError => e
    puts "signature verification error"
    status 400
    return
  rescue CoinbaseCommerce::Errors::WebhookInvalidPayload => e
    puts "missing request or headers data"
    status 400
    return
  end
end
```

### Testing and Contributing
Any and all contributions are welcome! The process is simple: fork this repo, make your changes, add tests, run the test suite, and submit a pull request. Tests are run via rspec. To run the tests, clone the repository and then:

    # Install the requirements
    gem install coinbase
    rspec spec
    
    # or via Bundle
    bundle install
    bundle exec rspec spec
