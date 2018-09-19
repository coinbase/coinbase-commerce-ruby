# frozen_string_literal: true

module CoinbaseCommerce
  module Webhook
    # Analyze and construct appropriate event object based on webhook notification
    def self.construct_event(payload, sig_header, secret)
      data = JSON.parse(payload, symbolize_names: true)
      if data.key?(:event)
        WebhookSignature.verify_header(payload, sig_header, secret)
        CoinbaseCommerce::APIResources::Event.create_from(data[:event])
      else
        raise CoinbaseCommerce::Errors::WebhookInvalidPayload.new("no event in payload",
                                                                  sig_header, http_body: payload)
      end
    end

    module WebhookSignature
      def self.verify_header(payload, sig_header, secret)
        unless [payload, sig_header, secret].all?
          raise CoinbaseCommerce::Errors::WebhookInvalidPayload.new(
              "Missing payload or signature",
              sig_header, http_body: payload)
        end
        expected_sig = compute_signature(payload, secret)
        unless secure_compare(expected_sig, sig_header)
          raise CoinbaseCommerce::Errors::SignatureVerificationError.new(
              "No signatures found matching the expected signature for payload",
              sig_header, http_body: payload
          )
        end
        true
      end

      def self.secure_compare(a, b)
        return false unless a.bytesize == b.bytesize

        l = a.unpack "C#{a.bytesize}"
        res = 0
        b.each_byte {|byte| res |= byte ^ l.shift}
        res.zero?
      end

      private_class_method :secure_compare

      def self.compute_signature(payload, secret)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, payload)
      end

      private_class_method :compute_signature
    end
  end
end
