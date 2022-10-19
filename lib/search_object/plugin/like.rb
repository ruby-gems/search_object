# frozen_string_literal: true

module SearchObject
  module Plugin
    module Like
      def self.included(base)
        base.extend ClassMethods
      end

      attr_reader :use_like

      def initialize(options = {})
        super options
      end

      private

      module ClassMethods
        def use_like(value)
          config[:use_like] = value
        end
      end
    end
  end
end
