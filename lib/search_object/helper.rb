# frozen_string_literal: true

module SearchObject
  # :api: private
  module Helper
    module_function

    def stringify_keys(hash)
      # Note(rstankov): From Rails 5+ ActionController::Parameters aren't Hash
      #   In a lot of cases `stringify_keys` is used on action params
      hash = hash.to_unsafe_h if hash.respond_to? :to_unsafe_h
      (hash || {}).map { |k, v| [k.to_s, v] }.to_h
    end

    def slice_keys(hash, keys)
      keys.each_with_object({}) do |key, memo|
        memo[key] = hash[key] if hash.key? key
      end
    end

    def camelize(text)
      text.to_s.gsub(/(?:^|_)(.)/) { Regexp.last_match[1].upcase }
    end

    def underscore(text)
      text.to_s
        .tr("::", "_")
        .gsub(/([A-Z]+)([A-Z][a-z])/) { "#{Regexp.last_match[1]}_#{Regexp.last_match[2]}" }
        .gsub(/([a-z\d])([A-Z])/) { "#{Regexp.last_match[1]}_#{Regexp.last_match[2]}" }
        .tr("-", "_")
        .downcase
    end

    def ensure_included(item, collection)
      if collection.include? item
        item
      else
        collection.first
      end
    end

    def define_module(&block)
      Module.new do
        define_singleton_method :included do |base|
          base.class_eval(&block)
        end
      end
    end

    def normalize_search_handler(handler, name, config)
      case handler
      when Symbol then ->(scope, value) { method(handler).call scope, value }
      when Proc then handler
      else
        if config[:use_like]
          ->(scope, value) { scope.where("#{name} like ? ", "%#{value}%") unless value.blank? }
        else
          ->(scope, value) { scope.where name => value unless value.blank? }
        end
      end
    end

    def deep_copy(object)
      case object
      when Array
        object.map { |element| deep_copy(element) }
      when Hash
        object.each_with_object({}) do |(key, value), result|
          result[key] = deep_copy(value)
        end
      when NilClass, FalseClass, TrueClass, Symbol, Method, Numeric
        object
      else
        object.dup
      end
    end
  end
end
