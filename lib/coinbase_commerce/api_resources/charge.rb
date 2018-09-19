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
    end
  end
end
