module CoinbaseCommerce
  module APIResources
    # Class that allows you to work with Event resource
    class Event < Base::APIResource
      # class methods
      extend Base::List

      # class constants
      OBJECT_NAME = "event".freeze
      RESOURCE_PATH = "events".freeze
    end
  end
end
