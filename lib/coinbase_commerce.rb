# general
require "json"
require "uri"
require "faraday"
require "openssl"

# version
require "coinbase_commerce/version"

# client
require "coinbase_commerce/client"

# api response and errors
require "coinbase_commerce/api_errors"
require "coinbase_commerce/api_response"

# api base object
require "coinbase_commerce/api_resources/base/api_object"

# api resource base model
require "coinbase_commerce/api_resources/base/api_resource"

# api base operations
require "coinbase_commerce/api_resources/base/create"
require "coinbase_commerce/api_resources/base/update"
require "coinbase_commerce/api_resources/base/save"
require "coinbase_commerce/api_resources/base/list"
require "coinbase_commerce/api_resources/base/delete"

# api resources
require "coinbase_commerce/api_resources/checkout"
require "coinbase_commerce/api_resources/charge"
require "coinbase_commerce/api_resources/event"

# webhooks
require "coinbase_commerce/webhooks"

# utils
require "coinbase_commerce/util"

module CoinbaseCommerce
end
