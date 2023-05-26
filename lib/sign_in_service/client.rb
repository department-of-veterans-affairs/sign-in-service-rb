# frozen_string_literal: true

require 'faraday'

require_relative 'client/authorize'
require_relative 'client/session'
require_relative 'response/raise_error'

module SignInService
  class Client
    include SignInService::Client::Authorize
    include SignInService::Client::Session

    attr_accessor :base_url, :client_id, :auth_type, :auth_flow

    def initialize(base_url:, client_id:, auth_type: :cookie, auth_flow: :pkce)
      @base_url = base_url
      @client_id = client_id
      @auth_type = auth_type
      @auth_flow = auth_flow
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
        conn.request :url_encoded
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

    def to_h
      {
        base_url:,
        client_id:,
        auth_type:
      }
    end
  end
end
