# frozen_string_literal: true
require 'spec_helper'

describe CoinbaseCommerce::CoinbaseCommerceResponse do
  describe "from_faraday_hash" do
    it "should initialize a CoinbaseCommerceResponse object from a Hash like the kind" do
      body = '{"foo": "bar"}'
      headers = {"x-request-id" => "x-request-id"}
      http_resp = {
          body: body,
          headers: headers,
          status: 200,
      }
      resp = CoinbaseCommerce::CoinbaseCommerceResponse.from_faraday_hash(http_resp)

      expect(JSON.parse(body, symbolize_names: true)).to eq resp.data
      expect(body).to eq resp.http_body
      expect(headers).to eq resp.http_headers
      expect(200).to eq resp.http_status
      expect("x-request-id").to eq resp.request_id
    end
  end

  describe "from_faraday_response" do
    it "should initialize a CoinbaseCommerceResponse object from a Faraday HTTP response object." do
      body = '{"foo": "bar"}'
      headers = {"x-request-id" => "x-request-id"}
      env = Faraday::Env.from(
          status: 200, body: body,
          response_headers: headers
      )
      http_resp = Faraday::Response.new(env)

      resp = CoinbaseCommerce::CoinbaseCommerceResponse.from_faraday_response(http_resp)

      expect(JSON.parse(body, symbolize_names: true)).to eq resp.data
      expect(body).to eq resp.http_body
      expect(headers).to eq resp.http_headers
      expect(200).to eq resp.http_status
      expect("x-request-id").to eq resp.request_id
    end
  end
end
