module CoinbaseCommerce
  module APIResources
    # Class that allows you to work with Checkout resource
    class Checkout < Base::APIResource
      # class methods
      extend Base::List
      extend Base::Create
      extend Base::Update

      # instance methods
      include Base::Save
      include Base::Delete

      # class constants
      OBJECT_NAME = "checkout".freeze
      RESOURCE_PATH = "checkouts".freeze
    end
  end
end
