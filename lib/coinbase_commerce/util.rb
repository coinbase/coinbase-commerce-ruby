module CoinbaseCommerce
  module Util

    def self.object_classes
      # Class mappings for api responce fetching
      @object_classes ||= {
          # API Resources
          APIResources::Checkout::OBJECT_NAME => APIResources::Checkout,
          APIResources::Charge::OBJECT_NAME => APIResources::Charge,
          APIResources::Event::OBJECT_NAME => APIResources::Event,
      }
    end


    def self.convert_to_api_object(data, client = nil, klass = nil)
      # Converts a hash of fields or an array of hashes into a
      # appropriate APIResources of APIObjects form
      case data
      when Array
        data.map {|i| convert_to_api_object(i, client, klass)}
      when Hash
        # If class received in params, create instance
        if klass
          klass.create_from(data, client)
        else
          # Try converting to a known object class.
          # If none available, fall back to generic APIObject
          klass = object_classes.fetch(data[:resource], APIResources::Base::APIObject)
          # Provide client relation only for APIResource objects
          klass != APIResources::Base::APIObject ? klass.create_from(data, client) : klass.create_from(data)
        end
      else
        data
      end
    end

    def self.symbolize_names(object)
      # Convert object key and values to symbols if its possible
      case object
      when Hash
        new_hash = {}
        object.each do |key, value|
          key = (
          begin
            key.to_sym
          rescue StandardError
            key
          end) || key
          new_hash[key] = symbolize_names(value)
        end
        new_hash
      when Array
        object.map {|value| symbolize_names(value)}
      else
        object
      end
    end
  end
end
