# frozen_string_literal: true

module SearchObject
  module Plugin
    module Pagy
      if defined?(::Pagy)
        include ::Pagy::Backend
      end
      include Paging

      attr_accessor :pagination

      def self.included(base)
        base.extend Paging::ClassMethods
      end

      def initialize(options = {})
        super options
      end

      private

      def apply_paging(scope)
        pagy, results = pagy(scope, items: per_page, page: page > 0 ? page : 1)
        self.pagination = pagy
        results
      end
    end
  end
end
