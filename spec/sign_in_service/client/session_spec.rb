# frozen_string_literal: true

require 'spec_helper'
require 'cgi'

RSpec.describe SignInService::Client::Session do
  let(:base_url) { 'http://example.com' }
  let(:client_id) { 'sample' }
  let(:auth_type) { 'some-type' }
  let(:client) { SignInService::Client.new(base_url:, client_id:, auth_type:) }

  let(:access_token) { SecureRandom.uuid }
  let(:refresh_token) { SecureRandom.uuid }
  let(:anti_csrf_token) { SecureRandom.uuid }

  let(:cookie_access_token) { "vagov_access_token=#{CGI.escape(access_token)}" }
  let(:cookie_refresh_token) { "vagov_refresh_token=#{CGI.escape(refresh_token)}" }
  let(:cookie_anti_csrf_token) { "vagov_anti_csrf_token=#{CGI.escape(anti_csrf_token)}" }

  let(:request_method) { 'some-method' }
  let(:request_uri) { 'some-uri' }
  let(:request_query) { {} }
  let(:request_body) { '' }
  let(:request_headers) { nil }

  let(:request_cookie_header) { { 'Cookie': request_cookie_tokens.join(';') } }
  let(:request_cookie_tokens) { [] }
  let(:request_auth_header) { { 'Authorization': "Bearer #{access_token}" } }

  let(:expected_response_status) { 'some-status' }
  let(:expected_response_body) { '' }
  let(:expected_response_headers) { nil }

  before do
    stub_request(request_method, "#{base_url}#{request_uri}")
      .with({ query: request_query, body: request_body, headers: request_headers }.compact)
      .to_return({ body: expected_response_body, headers: expected_response_headers,
                   status: expected_response_status }.compact)
  end

  describe '#introspect' do
    let(:request_method) { :get }
    let(:request_uri) { '/v0/sign_in/introspect' }
    let(:expected_response_body) { { user: {} }.to_json }

    context 'when using cookie auth' do
      let(:auth_type) { :cookie }
      let(:request_cookie_tokens) { [cookie_access_token] }
      let(:request_headers) { request_cookie_header }

      context 'when the access token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the access token in a cookie header and returns 200' do
          response = client.introspect(access_token:)
          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the access token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.introspect(access_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end

    context 'when using api auth' do
      let(:auth_type) { :api }
      let(:request_headers) { request_auth_header }

      context 'when the access token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the access token in an Authorization header and returns 200' do
          response = client.introspect(access_token:)

          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
          expect { JSON.parse(response.body) }.not_to raise_error
        end
      end

      context 'when the access token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.introspect(access_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end
  end

  describe '#logout' do
    let(:request_method) { :get }
    let(:request_uri) { '/v0/sign_in/logout' }
    let(:expected_response_body) { '' }

    context 'when using cookie auth' do
      let(:auth_type) { :cookie }
      let(:request_cookie_tokens) { [cookie_access_token, cookie_anti_csrf_token] }
      let(:request_headers) { request_cookie_header }
      let(:request_query) { { client_id: } }

      context 'when the access token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the access token and anti-csrf token in a cookie header and returns 200' do
          response = client.logout(access_token:, anti_csrf_token:)

          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the access token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.logout(access_token:, anti_csrf_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end

    context 'when using api auth' do
      let(:request_query) { { client_id:, anti_csrf_token: } }
      let(:auth_type) { :api }
      let(:request_headers) { request_auth_header }

      context 'when the access token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the access token and anti-csrf token in params and an Authorization header' do
          response = client.logout(access_token:, anti_csrf_token:)

          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the access token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.logout(access_token:, anti_csrf_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end
  end

  describe '#refresh_token' do
    let(:request_method) { :post }
    let(:request_uri) { '/v0/sign_in/refresh' }

    context 'when using cookie auth' do
      let(:auth_type) { :cookie }
      let(:request_headers) { request_cookie_header }
      let(:request_cookie_tokens) { [cookie_refresh_token, cookie_anti_csrf_token] }
      let(:expected_response_headers) { { 'set-cookie' => 'some_token_cookie=value' } }

      context 'when the refresh token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the refresh token and anti-csrf token in a cookie header and returns 200' do
          response = client.refresh_token(refresh_token:, anti_csrf_token:)

          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
          expect(response.headers).to eq(expected_response_headers)
        end
      end

      context 'when the refresh token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.refresh_token(refresh_token:, anti_csrf_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end

    context 'when using api auth' do
      let(:auth_type) { :api }
      let(:request_query) { { refresh_token:, anti_csrf_token: } }
      let(:expected_response_body) { { data: { some_token: 'some_token_value' } }.to_json }

      context 'when the refresh token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the refresh token and anti-csrf token in params and an Authorization header returns 200' do
          response = client.refresh_token(refresh_token:, anti_csrf_token:)
          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the refresh token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.refresh_token(refresh_token:, anti_csrf_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end
  end

  describe '#revoke_token' do
    let(:request_uri) { '/v0/sign_in/revoke' }
    let(:request_method) { :post }
    let(:request_query) { { refresh_token:, anti_csrf_token: } }

    let(:expexted_response_body) { '' }
    let(:expected_response_status) { 200 }

    context 'when using cookie auth' do
      let(:auth_type) { :cookie }

      context 'when the refresh token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the refresh token and csrf token in params' do
          response = client.revoke_token(refresh_token:, anti_csrf_token:)
          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the refresh token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.revoke_token(refresh_token:, anti_csrf_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end

    context 'when using api auth' do
      let(:auth_type) { :api }

      context 'when the refresh token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the refresh token and csrf token in params' do
          response = client.revoke_token(refresh_token:, anti_csrf_token:)

          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the refresh token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.revoke_token(refresh_token:, anti_csrf_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end
  end

  describe '#revoke_all_sessions' do
    let(:request_uri) { '/v0/sign_in/revoke_all_sessions' }
    let(:request_method) { :get }
    let(:expected_response_body) { '' }
    let(:expected_response_status) { 200 }

    context 'when using cookie auth' do
      let(:auth_type) { :cookie }
      let(:request_headers) { request_cookie_header }
      let(:request_cookie_tokens) { [cookie_access_token] }

      context 'when the access token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the access token in a cookie header and receives expected response' do
          response = client.revoke_all_sessions(access_token:)

          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the access token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.revoke_all_sessions(access_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end

    context 'when using api auth' do
      let(:auth_type) { :brearer }
      let(:request_headers) { request_auth_header }

      context 'when the access token is valid' do
        let(:expected_response_status) { 200 }

        it 'sends the access token in the auth header and receives expected response' do
          response = client.revoke_all_sessions(access_token:)

          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when the access token is invalid' do
        let(:expected_response_status) { 401 }

        it 'returns a 401 response and raises an error' do
          expect { client.revoke_all_sessions(access_token:) }.to raise_error(SignInService::Unauthorized)
        end
      end
    end
  end
end
