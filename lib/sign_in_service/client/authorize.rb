# frozen_string_literal: true

module SignInService
  class Client
    module Authorize
      AUTHORIZE_PATH = '/v0/sign_in/authorize'
      TOKEN_PATH = '/v0/sign_in/token'

      ##
      # Generates an authorization URI.
      # It is used in the OAuth 2.0 authorization code flow.
      #
      # @param type [String] The CSP type
      # @param acr [String] Level of authentication requested
      # @param code_challenge [String] Used by SiS to verify requests
      # @param state [String] Optional string that can be returned in callback
      #
      # @return [String] URI to authorize client
      #

      def authorize_uri(type:, acr:, code_challenge: nil, state: nil)
        uri = URI.join(base_url, AUTHORIZE_PATH)
        params = {
          type:,
          acr:,
          code_challenge:,
          code_challenge_method:,
          client_id:,
          state:
        }.compact

        uri.query = URI.encode_www_form(params)

        uri.to_s
      end

      ##
      # Makes call to authorize path.
      # For :api auth_type applications
      #
      # @param type [String] The CSP type
      # @param acr [String] Level of authentication requested
      # @param code_challenge [String] Used by SiS to verify requests
      # @param state [String] Optional string that can be returned in callback
      #
      # @return [Faraday::Response] Contains 'code' parameter used to exchange for token
      #
      def authorize(type:, acr:, code_challenge:, state: nil)
        params = {
          type:,
          acr:,
          code_challenge:,
          code_challenge_method:,
          client_id:,
          state:
        }.compact

        connection.get(AUTHORIZE_PATH, params)
      end

      ##
      # Exchange code for session tokens
      #
      # @param code [String] The code received form the authorize callback
      # @param code_verifier [String] String stored client side from code_challenge
      #
      # @return [Faraday::Response] Response with tokens in header or body
      #
      def get_token(code:, code_verifier: nil, client_assertion: nil)
        params = {
          code:,
          code_verifier:,
          grant_type:,
          client_assertion:
        }.compact

        params[:client_assertion_type] = client_assertion_type unless client_assertion.nil?

        connection.post(TOKEN_PATH, params)
      end
    end
  end
end
