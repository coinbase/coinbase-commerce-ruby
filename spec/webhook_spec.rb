# frozen_string_literal: true
require 'spec_helper'

describe CoinbaseCommerce::Webhook do
  PAYLOAD_STR = '{"id":1, "event":{"resource":"event"}}'
  SIG_HEADER = '231055346fa57e134e8a65284147ea2a5776337f4863b62da3f90558ed027d56'
  SECRET = 'e9ff8572755fea16d15b623120bb118da275716dde2c996b54509244c13e1aa6'

  it "should create Event object when valid payload and signatures" do
    event = CoinbaseCommerce::Webhook.construct_event(PAYLOAD_STR, SIG_HEADER, SECRET)
    expect(event).is_a? CoinbaseCommerce::APIResources::Event
  end

  it "should raise ParserError when invalid payload" do
    payload = "this is not valid JSON"
    expect {CoinbaseCommerce::Webhook.construct_event(payload, SIG_HEADER, SECRET)}
        .to raise_error JSON::ParserError
  end

  it "should raise a SignatureVerificationError from a valid JSON payload and an invalid signature header" do
    header = "bad_header"
    expect {CoinbaseCommerce::Webhook.construct_event(PAYLOAD_STR, header, SECRET)}
        .to raise_error CoinbaseCommerce::Errors::SignatureVerificationError
  end

  it "should raise invalid payload error on nil params" do
    secret = nil
    expect {CoinbaseCommerce::Webhook.construct_event(PAYLOAD_STR, SIG_HEADER, secret)}
        .to raise_error CoinbaseCommerce::Errors::WebhookInvalidPayload
  end
  it "should raise invalid payload error when no event in payload " do
    payload = '{"id":1,"scheduled_for":"2017-01-31T20:50:02Z","attempt_number":1}'
    expect {CoinbaseCommerce::Webhook.construct_event(payload, SIG_HEADER, SECRET)}
        .to raise_error CoinbaseCommerce::Errors::WebhookInvalidPayload
  end
end
