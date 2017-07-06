module Digicert
  module CLI
    class FilterBuilder
      attr_reader :options, :filters_hash

      def initialize(options)
        @options = options
        @filters_hash = {}
      end

      def build
        build_filters
        filters_hash
      end

      def self.build(options)
        new(options).build
      end

      private

      def build_filters
        options.each do |key, value|
          add_to_filters(key.to_s, value)
        end
      end

      def add_to_filters(key, value)
        if supported_filters.include?(key) && !value.empty?
          @filters_hash[key] = prepare_filter_value(value)
        end
      end

      def prepare_filter_value(value)
        values = value.split(",")
        build_nested_values(values) || values.first
      end

      def build_nested_values(values)
        if values.length > 1
          Hash.new.tap do |value_hash|
            values.length.times do |num|
              value_hash[num.to_s] = values[num].strip
            end
          end
        end
      end

      def supported_filters
        %w(date_created valid_till status search common_name product_name_id)
      end
    end
  end
end
