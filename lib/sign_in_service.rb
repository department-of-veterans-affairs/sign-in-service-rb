# frozen_string_literal: true

require 'sign_in_service/client'
require 'sign_in_service/config'

module SignInService
  COOKIE_TOKEN_PREFIX = 'vagov'
  AUTH_TYPES = [COOKIE_AUTH = :cookie, API_AUTH = :api].freeze
  AUTH_FLOWS = [PKCE_FLOW = :pkce, JWT_FLOW = :jwt].freeze

  class << self
    attr_accessor :config

    def client
      @client = if defined?(@client) && same_config?
                  @client
                else
                  SignInService::Client.new(base_url: config.base_url,
                                            client_id: config.client_id,
                                            auth_type: config.auth_type,
                                            auth_flow: config.auth_flow)
                end
    end

    def configure
      self.config ||= Config.new
      yield(config) if block_given?
    end

    def reset!
      @client = nil
      self.config = Config.new
    end
    alias setup reset!

    private

    def same_config?
      @client.to_h == SignInService.config.to_h
    end
  end
end
SignInService.setup
