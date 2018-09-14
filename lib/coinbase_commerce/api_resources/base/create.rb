# frozen_string_literal: true

module CoinbaseCommerce
  module APIResources
    module Base
      # create operations mixin
      module Create
        def create(params = {})
          response = @client.request(:post, "#{self::RESOURCE_PATH}", params)
          Util.convert_to_api_object(response.data, @client, self)
        end
      end
    end
  end
end
