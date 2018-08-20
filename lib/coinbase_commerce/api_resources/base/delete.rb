# frozen_string_literal: true

module CoinbaseCommerce
  module APIResources
    module Base
      # delete opertaions mixin
      module Delete
        def delete
          response = @client.request(:delete, "#{self.class::RESOURCE_PATH}/#{self[:id]}")
          initialize_from(response.data)
          self
        end
      end
    end
  end
end
