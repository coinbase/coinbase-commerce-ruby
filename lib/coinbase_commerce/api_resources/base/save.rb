# frozen_string_literal: true

module CoinbaseCommerce
  module APIResources
    module Base
      # save operations mixin
      module Save
        def save
          values = serialize_params(self)
          values.delete(:id)
          resp = @client.request(:put, "#{self.class::RESOURCE_PATH}/#{self[:id]}", self)
          initialize_from(resp.data)
          self
        end
      end
    end
  end
end
