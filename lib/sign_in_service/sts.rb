# frozen_string_literal: true

require 'faraday'
require 'jwt'

require_relative 'sts/config'
require_relative 'sts/token'

module SignInService
  class Sts
    include Config
    include Token

    REQUIRED_ATTRIBUTES = %i[user_identifier issuer service_account_id private_key_path base_url].freeze

    class << self
      def configure
        yield Config
      end
    end

    attr_reader :user_identifier, :issuer, :scopes, :service_account_id,
                :user_attributes, :private_key_path, :base_url

    def initialize(user_identifier:, **options)
      @user_identifier = user_identifier
      @issuer = options[:issuer] || Config.issuer
      @scopes = options[:scopes] || Config.scopes || []
      @service_account_id = options[:service_account_id] || Config.service_account_id
      @user_attributes = options[:user_attributes] || Config.user_attributes
      @private_key_path = options[:private_key_path] || Config.private_key_path
      @base_url = options[:base_url] || Config.base_url

      validate_arguments!
    end

    private

    def connection
      @connection ||= Faraday.new(base_url) do |conn|
        conn.adapter Faraday.default_adapter
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.use SignInService::Response::RaiseError
      end
    end

    def grant_type
      'urn:ietf:params:oauth:grant-type:jwt-bearer'
    end

    def private_key
      OpenSSL::PKey::RSA.new(File.read(private_key_path))
    end

    def validate_arguments!
      REQUIRED_ATTRIBUTES.each do |attribute|
        raise ArgumentError, "missing required attribute: #{attribute}" if send(attribute).nil?
      end

      raise ArgumentError, 'scopes must be an array' unless scopes.is_a?(Array)
    end
  end
end
