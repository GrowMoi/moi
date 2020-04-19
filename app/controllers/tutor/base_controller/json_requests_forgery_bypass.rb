module Tutor
  class BaseController < ::ApplicationController
    module JsonRequestsForgeryBypass
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token,
                           if: :valid_header?
      end

      protected

      def valid_header?
        json_request = request.headers["Content-Type"].include?("application/json") if request.headers["Content-Type"].present?
        form_data = request.headers["Content-Type"].include?("multipart/form-data") if request.headers["Content-Type"].present?

        json_request || form_data
      end
    end
  end
end
