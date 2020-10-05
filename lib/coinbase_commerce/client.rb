# frozen_string_literal: true

module CoinbaseCommerce
  BASE_API_URL = "https://api.commerce.coinbase.com/"
  API_VERSION = "2018-03-22"

  class Client
    # API Client for the Coinbase API.
    # Entry point for making requests to the Coinbase API.
    # Full API docs available here: https://commerce.coinbase.com/docs/api/

    def initialize(options = {})
      # set API key and API URL
      check_api_key!(options[:api_key])
      @api_key = options[:api_key]
      @api_uri = URI.parse(options[:api_url] || BASE_API_URL)
      @api_ver = options[:api_ver] || API_VERSION
      # create client obj
      @conn = Faraday.new do |c|
        c.use Faraday::Request::Multipart
        c.use Faraday::Request::UrlEncoded
        c.use Faraday::Response::RaiseError
        c.adapter Faraday.default_adapter
      end
    end

    # Set client-resource relations with all API resources
    # provide client instance to each resource
    def charge
      APIResources::Charge.client = self
      APIResources::Charge
    end

    def checkout
      APIResources::Checkout.client = self
      APIResources::Checkout
    end

    def event
      APIResources::Event.client = self
      APIResources::Event
    end

    def api_url(url = "", api_base = nil)
      (api_base || CoinbaseCommerce::BASE_API_URL) + url
    end

    def request_headers(api_key)
      {
          "User-Agent" => "CoinbaseCommerce/#{CoinbaseCommerce::VERSION}",
          "Accept" => "application/json",
          "X-CC-Api-Key" => api_key,
          "X-CC-Version" => @api_ver,
          "Content-Type" => "application/json",
      }
    end

    def check_api_key!(api_key)
      raise AuthenticationError, "No API key provided" unless api_key
    end

    # request section
    def request(method, path, params = {})
      @last_response = nil
      url = api_url(path, @api_uri)
      headers = request_headers(@api_key)

      body = nil
      query_params = nil

      case method.to_s.downcase.to_sym
      when :get, :head, :delete
        query_params = params
      else
        body = params.to_json
      end

      u = URI.parse(path)
      unless u.query.nil?
        query_params ||= {}
        query_params = Hash[URI.decode_www_form(u.query)].merge(query_params)
      end


      http_resp = execute_request_with_rescues(@api_uri) do
        @conn.run_request(method, url, body, headers) do |req|
          req.params = query_params unless query_params.nil?
        end
      end

      begin
        resp = CoinbaseCommerceResponse.from_faraday_response(http_resp)
      rescue JSON::ParserError
        raise Errors.general_api_error(http_resp.status, http_resp.body)
      end

      @last_response = resp
      resp
    end

    # сollect errors during request execution if they occurred
    def execute_request_with_rescues(api_base)
      begin
        resp = yield
      rescue StandardError => e
        case e
        when Faraday::ClientError, Faraday::ServerError
          if e.response
            Errors.handle_error_response(e.response)
          else
            Errors.handle_network_error(e, api_base)
          end
        else
          raise
        end
      end
      resp
    end
  end
end
