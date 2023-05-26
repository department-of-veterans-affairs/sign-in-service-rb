# frozen_string_literal: true

module SignInService
  class Config
    DEFAULT_BASE_URL = 'http://localhost:3000'
    DEFAULT_CLIENT_ID = 'sample'
    DEFAULT_AUTH_TYPE = :cookie
    DEFAULT_AUTH_FLOW = :pkce

    attr_accessor :base_url, :client_id
    attr_reader :auth_type, :auth_flow

    def initialize
      @base_url = DEFAULT_BASE_URL
      @client_id = DEFAULT_CLIENT_ID
      @auth_type = DEFAULT_AUTH_TYPE
      @auth_flow = DEFAULT_AUTH_FLOW
    end

    def auth_type=(value)
      raise ArgumentError, "invalid auth type: #{value}" unless AUTH_TYPES.include?(value)

      @auth_type = value
    end

    def auth_flow=(value)
      raise ArgumentError, "invalid auth flow: #{value}" unless AUTH_FLOWS.include?(value)

      @auth_flow = value
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
