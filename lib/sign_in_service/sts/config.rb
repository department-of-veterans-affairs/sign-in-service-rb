# frozen_string_literal: true

module SignInService
  class Sts
    module Config
      class << self
        DEFAULT_STS_BASE_URL = 'https://staging-api.va.gov/v0/sign_in'

        attr_accessor :issuer, :scopes, :service_account_id, :user_attributes, :private_key_path

        attr_writer :base_url

        def base_url
          @base_url || DEFAULT_STS_BASE_URL
        end
      end
    end
  end
end
