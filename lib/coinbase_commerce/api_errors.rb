module CoinbaseCommerce
  module Errors
    class APIError < StandardError
      attr_reader :message

      # Response contains a CoinbaseCommerceResponse object
      attr_accessor :response

      attr_reader :http_body
      attr_reader :http_headers
      attr_reader :http_status
      attr_reader :json_body
      attr_reader :request_id

      # Initializes a API error.
      def initialize(message = nil, http_status: nil, http_body: nil,
                     json_body: nil, http_headers: nil)
        @message = message
        @http_status = http_status
        @http_body = http_body
        @http_headers = http_headers || {}
        @json_body = json_body
        @request_id = @http_headers["x-request-id"]
      end

      def to_s
        status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
        id_string = @request_id.nil? ? "" : "(Request #{@request_id}) "
        "#{status_string}#{id_string}#{@message}"
      end
    end

    # in case error connecting to coinbase commerce server
    class APIConnectionError < APIError
    end

    # Status 400
    class BadRequestError < APIError
    end

    class ParamRequiredError < APIError
    end

    class InvalidRequestError < APIError
    end

    # Status 401
    class AuthenticationError < APIError
    end

    # Status 404
    class ResourceNotFoundError < APIError
    end

    # Status 422
    class ValidationError < APIError
    end

    # Status 429
    class RateLimitExceededError < APIError
    end

    # Status 500
    class InternalServerError < APIError
    end

    # Status 503
    class ServiceUnavailableError < APIError
    end

    # Webhook errors
    class WebhookError < APIError
      attr_accessor :sig_header

      def initialize(message, sig_header, http_body: nil)
        super(message, http_body: http_body)
        @sig_header = sig_header
      end
    end

    class SignatureVerificationError < WebhookError
    end

    class WebhookInvalidPayload < WebhookError
    end

    # Errors handling
    def self.handle_error_response(http_resp)
      begin
        resp = CoinbaseCommerceResponse.from_faraday_hash(http_resp)
        error_data = resp.data[:error]

        raise APIError, "Unknown error" unless error_data
      rescue JSON::ParserError, APIError
        raise general_api_error(http_resp[:status], http_resp[:body])
      end
      error = specific_api_error(resp, error_data)
      error.response = resp
      raise(error)
    end

    def self.general_api_error(status, body)
      APIError.new("Invalid response object from API: #{body.inspect} " +
                       "(HTTP response code: #{status} http_body: #{body}")
    end

    def self.specific_api_error(resp, error_data)
      opts = {
          http_body: resp.http_body,
          http_headers: resp.http_headers,
          http_status: resp.http_status,
          json_body: resp.data,
      }
      case resp.http_status
      when 400
        # in case of known error code
        case error_data[:type]
        when 'param_required'
          ParamRequiredError.new(error_data[:message], opts)
        when 'validation_error'
          ValidationError.new(error_data[:message], opts)
        when 'invalid_request'
          InvalidRequestError.new(error_data[:message], opts)
        else
          InvalidRequestError.new(error_data[:message], opts)
        end
      when 401 then
        AuthenticationError.new(error_data[:message], opts)
      when 404
        ResourceNotFoundError.new(error_data[:message], opts)
      when 429
        RateLimitExceededError.new(error_data[:message], opts)
      when 500
        InternalServerError.new(error_data[:message], opts)
      when 503
        ServiceUnavailableError.new(error_data[:message], opts)
      else
        APIError.new(error_data[:message], opts)
      end
    end

    def self.handle_network_error(e, api_base = nil)
      api_base ||= @api_uri
      case e
      when Faraday::ConnectionFailed
        message = "Unexpected error communicating when trying to connect to Coinbase Commerce."
      when Faraday::SSLError
        message = "Could not establish a secure connection to Coinbase Commerce."
      when Faraday::TimeoutError
        message = "Could not connect to Coinbase Commerce (#{api_base})."
      else
        message = "Unexpected error communicating with Coinbase Commerce."
      end
      raise APIConnectionError, message + "\n\n(Network error: #{e.message})"
    end
  end
end
