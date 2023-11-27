module CoinbaseCommerce
  module APIResources
    # Class that allows you to work with Charge resource
    class Charge < Base::APIResource
      # class methods
      extend Base::List
      extend Base::Create

      # class constants
      OBJECT_NAME = "charge".freeze
      RESOURCE_PATH = "charges".freeze

      def resolve
        values = serialize_params(self)
        values.delete(:id)
        resp = @client.request(:post, "#{self.class::RESOURCE_PATH}/#{self[:id]}/resolve", self)
        initialize_from(resp.data)
        self
      end
    end
  end
end
