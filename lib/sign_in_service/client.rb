# frozen_string_literal: true

require 'faraday'

require_relative 'client/authorize'
require_relative 'client/session'
require_relative 'client/config'
require_relative 'response/raise_error'

module SignInService
  class Client
    include SignInService::Client::Config
    include SignInService::Client::Authorize
    include SignInService::Client::Session

    COOKIE_TOKEN_PREFIX = 'vagov'
    AUTH_TYPES = [COOKIE_AUTH = :cookie, API_AUTH = :api].freeze
    AUTH_FLOWS = [PKCE_FLOW = :pkce, JWT_FLOW = :jwt].freeze

    class << self
      def configure
        yield Config
      end

      def config
        Config
      end
    end

    attr_accessor :base_url, :client_id, :auth_type, :auth_flow

    def initialize(**options)
      @base_url = options[:base_url] || Config.base_url
      @client_id = options[:client_id] || Config.client_id
      @auth_type = options[:auth_type] || Config.auth_type
      @auth_flow = options[:auth_flow] || Config.auth_flow
    end

    def grant_type
      'authorization_code'
    end

    def code_challenge_method
      'S256'
    end

    def client_assertion_type
      'urn:ietf:params:oauth:client-assertion-type:jwt-bearer'
    end

    def connection
      @connection ||= Faraday.new(base_url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
        conn.use SignInService::Response::RaiseError
      end
    end

    def api_auth?
      auth_type.to_sym == API_AUTH
    end

    def cookie_auth?
      auth_type.to_sym == COOKIE_AUTH
    end
  end
end
