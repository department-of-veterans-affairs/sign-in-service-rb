# frozen_string_literal: true

module SignInService
  class Client
    module Config
      class << self
        DEFAULT_BASE_URL = 'http://localhost:3000'
        DEFAULT_CLIENT_ID = 'sample'
        DEFAULT_AUTH_TYPE = :cookie
        DEFAULT_AUTH_FLOW = :pkce

        attr_writer :base_url, :client_id, :auth_type, :auth_flow

        def base_url
          @base_url || DEFAULT_BASE_URL
        end

        def client_id
          @client_id || DEFAULT_CLIENT_ID
        end

        def auth_type
          @auth_type || DEFAULT_AUTH_TYPE
        end

        def auth_flow
          @auth_flow || DEFAULT_AUTH_FLOW
        end

        def to_h
          {
            base_url:,
            client_id:,
            auth_type:,
            auth_flow:
          }
        end
      end
    end
  end
end
