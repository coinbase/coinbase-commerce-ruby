module CoinbaseCommerce
  class CoinbaseCommerceResponse
    attr_accessor :data

    attr_accessor :http_body

    attr_accessor :http_headers

    attr_accessor :http_status

    attr_accessor :request_id

    # Initializes a CoinbaseCommerceResponse object
    # from a Hash like the kind returned as part of a Faraday exception.
    def self.from_faraday_hash(http_resp)
      resp = CoinbaseCommerceResponse.new
      resp.data = JSON.parse(http_resp[:body], symbolize_names: true)
      resp.http_body = http_resp[:body]
      resp.http_headers = http_resp[:headers]
      resp.http_status = http_resp[:status]
      resp.request_id = http_resp[:headers]["x-request-id"]
      resp
    end

    # Initializes a CoinbaseCommerceResponse object
    # from a Faraday HTTP response object.
    def self.from_faraday_response(http_resp)
      resp = CoinbaseCommerceResponse.new
      resp.data = JSON.parse(http_resp.body, symbolize_names: true)
      resp.http_body = http_resp.body
      resp.http_headers = http_resp.headers
      resp.http_status = http_resp.status
      resp.request_id = http_resp.headers["x-request-id"]

      # unpack nested data field if it exist
      if resp.data.is_a? Hash and resp.data.fetch(:data, nil).is_a? Hash
        resp.data.update(resp.data.delete(:data))
      end

      # warn in there warnings in response
      if resp.data.is_a? Hash and resp.data.fetch(:warnings, nil).is_a? Array
        warn(resp.data[:warnings].first.to_s)
      end

      resp
    end
  end
end
