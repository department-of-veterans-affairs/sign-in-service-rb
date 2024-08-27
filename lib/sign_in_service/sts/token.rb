# frozen_string_literal: true

module SignInService
  class Sts
    module Token
      TOKEN_PATH = '/v0/sign_in/token'
      ACCESS_TOKEN_DURATION = 300
      JWT_ENCODE_ALGORITHM = 'RS256'

      def token
        params = { grant_type:, assertion: }
        response = connection.post(TOKEN_PATH, params)

        response.body.dig('data', 'access_token')
      end

      private

      def assertion
        JWT.encode(assertion_payload, private_key, JWT_ENCODE_ALGORITHM)
      end

      def assertion_payload
        {
          iss: issuer,
          sub: user_identifier,
          aud:,
          iat:,
          exp:,
          jti:,
          scopes:,
          service_account_id:,
          user_attributes:
        }.compact
      end

      def aud
        "#{base_url}#{TOKEN_PATH}"
      end

      def iat
        @iat ||= Time.now.to_i
      end

      def exp
        iat + ACCESS_TOKEN_DURATION
      end

      def jti
        SecureRandom.hex
      end
    end
  end
end
