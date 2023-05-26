# frozen_string_literal: true

module SignInService
  class Client
    module Session
      INTROSPECT_PATH = '/v0/sign_in/introspect'
      LOGOUT_PATH = '/v0/sign_in/logout'
      REFRESH_PATH = '/v0/sign_in/refresh'
      REVOKE_PATH = '/v0/sign_in/revoke'
      REVOKE_ALL_PATH = '/v0/sign_in/revoke_all_sessions'

      ##
      # Get user data of associated user
      #
      # @param access_token [String] Access token for associated user
      #
      # @return [Faraday::Response] User attributs in JSON body
      #
      def introspect(access_token:)
        connection.get(INTROSPECT_PATH) do |req|
          req.headers = if cookie_auth?
                          cookie_header({ access_token: })
                        else
                          api_header(access_token)
                        end
        end
      end

      ##
      # Destroys the user session associated with the access token.
      #
      # @param access_token [String] Access token of session to logout of
      # @param anti_csrf_token [String] Optional token if enabled on client
      #
      # @return [Faraday::Response] Empty body with a 200 status
      #
      def logout(access_token:, anti_csrf_token: nil)
        connection.get(LOGOUT_PATH) do |req|
          req.params[:client_id] = client_id
          if cookie_auth?
            req.headers = cookie_header({ access_token:, anti_csrf_token: })
          else
            req.params[:anti_csrf_token] = anti_csrf_token
            req.headers = api_header(access_token)
          end
        end
      end

      ##
      # Refresh session tokens
      #
      # @param refresh_token [String] URI-encoded refresh token
      # @param anti_csrf_token [String] Optional token if enabled on client
      #
      # @return [Faraday::Response] Response with tokens in header or body
      #
      def refresh_token(refresh_token:, anti_csrf_token: nil)
        connection.post(REFRESH_PATH) do |req|
          if cookie_auth?
            req.headers = cookie_header({ refresh_token:, anti_csrf_token: })
          else
            req.params[:refresh_token] = refresh_token
            req.params[:anti_csrf_token] = anti_csrf_token if anti_csrf_token
          end
        end
      end

      ##
      # Revokes a user session
      #
      # @param refresh_token [String] URI-encoded refresh token
      # @param anti_csrf_token [String] Optional token if enabled on client
      #
      # @return [Faraday::Response] Empty body with a 200 status
      #
      def revoke_token(refresh_token:, anti_csrf_token:)
        connection.post(REVOKE_PATH) do |req|
          req.params[:refresh_token] = CGI.escape(refresh_token)
          req.params[:anti_csrf_token] = CGI.escape(anti_csrf_token)
        end
      end

      ##
      # Revokes all sessions associated with a user
      #
      # @param access_token [String] Access token of session
      #
      # @return [Faraday::Response] Empty body with a 200 status
      #
      def revoke_all_sessions(access_token:)
        connection.get(REVOKE_ALL_PATH) do |req|
          req.headers = if cookie_auth?
                          cookie_header({ access_token: })
                        else
                          api_header(access_token)
                        end
        end
      end

      private

      def cookie_header(tokens)
        {
          Cookie: tokens.map do |name, value|
                    "#{COOKIE_TOKEN_PREFIX}_#{name}=#{CGI.escape(value)}" unless value.nil?
                  end.join(';')
        }
      end

      def api_header(access_token)
        {
          Authorization: "Bearer #{CGI.escape(access_token)}"
        }
      end
    end
  end
end
