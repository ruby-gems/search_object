# frozen_string_literal: true

require "pagy"
require "spec_helper_active_record"
module SearchObject
  module Plugin
    describe Pagy do
      it_behaves_like "a paging plugin" do
        it "uses pagy gem" do
          search = search_with_page
          expect(search).to be_respond_to :pagination
        end
      end
    end
  end
end
