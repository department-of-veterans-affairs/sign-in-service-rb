# frozen_string_literal: true

require 'faraday'
require 'sign_in_service/error'

module SignInService
  module Response
    class RaiseError < Faraday::Middleware
      def on_complete(response)
        return unless (error = SignInService::Error.from_response(response))

        raise error
      end
    end
  end
end
