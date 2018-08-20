module CoinbaseCommerce
  module APIResources
    module Base
      # Base APIObject class
      # Used to work and display with all the data
      # that Coinbase Commerce API returns
      class APIObject
        include Enumerable

        def initialize(id = nil, client = nil)
          @data = {}
          @data[:id] = id if id
          @client = client
          @unsaved_values = Set.new
          @transient_values = Set.new
        end

        # Base object options section
        def [](k)
          @data[k.to_sym]
        end

        def []=(k, v)
          send(:"#{k}=", v)
        end

        def keys
          @data.keys
        end

        def values
          @data.values
        end

        def each(&blk)
          @data.each(&blk)
        end

        def to_s(*_args)
          JSON.pretty_generate(to_hash)
        end

        def to_hash
          @data.each_with_object({}) do |(key, value), output|
            case value
            when Array
              output[key] = value.map {|v| v.respond_to?(:to_hash) ? v.to_hash : v}
            else
              output[key] = value.respond_to?(:to_hash) ? value.to_hash : value
            end
          end
        end

        def to_json(*_a)
          JSON.generate(@data)
        end

        def inspect
          item_id = respond_to?(:id) && !id.nil? ? "id=#{id}" : "No ID"
          "#{self.class}: #{item_id}> Serialized: " + JSON.pretty_generate(@data)
        end

        def respond_to_missing?(symbol, include_private = false)
          @data && @data.key?(symbol) || super
        end

        def method_missing(name, *args)
          if name.to_s.end_with?("=")

            attr = name.to_s[0...-1].to_sym
            val = args.first
            add_accessors([attr], attr => val)

            begin
              mth = method(name)
            rescue NameError
              raise NoMethodError, "Cannot set #{attr} on this object."
            end

            return mth.call(args[0])

          elsif @data.key?(name)
            return @data[name]
          end

          begin
            super
          rescue NoMethodError => e
            raise unless @transient_values.include?(name)
            raise NoMethodError, e.message + " Available attributes: #{@data.keys.join(', ')}"
          end
        end

        # Object serialize section
        def serialize_params(options = {})
          update_hash = {}

          @data.each do |k, v|
            if options[:push] || @unsaved_values.include?(k) || v.is_a?(APIObject)
              push = options[:push] || @unsaved_values.include?(k)
              update_hash[k.to_sym] = serialize_params_value(@data[k], push)
            end
          end

          update_hash.reject! {|_, v| v.nil? || v.empty?}
          update_hash
        end

        def serialize_params_value(value, push)
          if value.nil?
            ""
          elsif value.is_a?(Array)
            value.map {|v| serialize_params_value(v, push)}

          elsif value.is_a?(Hash)
            Util.convert_to_api_object(value, @opts).serialize_params

          elsif value.is_a?(APIObject)
            value.serialize_params(push: push)
          else
            value
          end
        end

        # Object initialize/update section
        def self.create_from(values, client = nil)
          values = Util.symbolize_names(values)
          new(values[:id], client).send(:initialize_from, values)
        end

        def initialize_from(values, partial = false)
          removed = partial ? Set.new : Set.new(@data.keys - values.keys)
          added = Set.new(values.keys - @data.keys)

          remove_accessors(removed)
          add_accessors(added, values)

          removed.each do |k|
            @data.delete(k)
            @transient_values.add(k)
            @unsaved_values.delete(k)
          end

          update_attributes(values)
          values.each_key do |k|
            @transient_values.delete(k)
            @unsaved_values.delete(k)
          end

          self
        end

        def update_attributes(values)
          values.each do |k, v|
            add_accessors([k], values) unless metaclass.method_defined?(k.to_sym)
            @data[k] = Util.convert_to_api_object(v, @client)
            @unsaved_values.add(k)
          end
        end


        protected

        def metaclass
          class << self
            self
          end
        end

        def remove_accessors(keys)
          metaclass.instance_eval do
            keys.each do |k|
              # Remove methods for the accessor's reader and writer.
              [k, :"#{k}=", :"#{k}?"].each do |method_name|
                remove_method(method_name) if method_defined?(method_name)
              end
            end
          end
        end

        def add_accessors(keys, values)
          metaclass.instance_eval do
            keys.each do |k|
              if k == :method
                define_method(k) {|*args| args.empty? ? @data[k] : super(*args)}
              else
                define_method(k) {@data[k]}
              end

              define_method(:"#{k}=") do |v|
                if v != ""
                  @data[k] = Util.convert_to_api_object(v, @opts)
                  @unsaved_values.add(k)
                end
              end

              if [FalseClass, TrueClass].include?(values[k].class)
                define_method(:"#{k}?") {@data[k]}
              end
            end
          end
        end
      end
    end
  end
end
