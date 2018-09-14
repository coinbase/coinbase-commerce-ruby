# frozen_string_literal: true
require 'spec_helper'

describe CoinbaseCommerce do
  before :all do
    @client = CoinbaseCommerce::Client.new(api_key: 'api_key')
  end

  it "should get appropriate error when invalid response object" do
    stub_request(:get, /.*/).to_return(body: {errors: [{id: "boo", message: "foo"}]}.to_json, status: 400)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::APIError
  end

  it "should handle invalid request general" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "invalid_request", message: "test"}}.to_json, status: 400)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::InvalidRequestError
  end

  it "should handle param required" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "param_required", message: "param_required"}}.to_json, status: 400)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::ParamRequiredError
  end

  it "should handle validation error" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "validation_error", message: "validation_error"}}.to_json, status: 400)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::ValidationError
  end

  it "should handle param_required" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "invalid_request", message: "invalid_request"}}.to_json, status: 400)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::InvalidRequestError
  end

  it "should handle authentication error" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "auth_error", message: "auth_error"}}.to_json, status: 401)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::AuthenticationError
  end

  it "should handle resource not found error" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "not_found", message: "not_found"}}.to_json, status: 404)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::ResourceNotFoundError
  end

  it "should handle rate limit exceeded error" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "rate_limit_exceeded", message: "rate_limit_exceeded"}}.to_json, status: 429)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::RateLimitExceededError
  end

  it "should handle internal server error" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "internal_error", message: "internal_error"}}.to_json, status: 500)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::InternalServerError
  end

  it "should handle service unavailable error" do
    stub_request(:get, /.*/).to_return(body: {error: {type: "service_unavailable", message: "service_unavailable"}}.to_json, status: 503)
    expect {@client.checkout.list}.to raise_error CoinbaseCommerce::Errors::ServiceUnavailableError
  end
end
