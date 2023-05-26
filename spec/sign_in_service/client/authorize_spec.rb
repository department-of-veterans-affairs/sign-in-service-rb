# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Client::Authorize do
  let(:base_url) { 'http://example.com' }
  let(:type) { 'idme' }
  let(:acr) { 'loa3' }
  let(:code_challenge) { SecureRandom.hex }
  let(:code_challenge_method) { client.code_challenge_method }

  let(:client_id) { 'sample' }
  let(:client) { SignInService::Client.new(base_url:, client_id:) }

  let(:request_uri) { 'some-uri' }
  let(:request_query) { {} }
  let(:request_body) { '' }

  let(:expected_response_body) { '' }
  let(:expected_response_status) { 'some-status' }
  let(:expected_response_headers) { {} }

  before :example, request: true do
    stub_request(request_method, "#{base_url}#{request_uri}")
      .with({ query: request_query, body: request_body }.compact)
      .to_return({ body: expected_response_body, headers: expected_response_headers,
                   status: expected_response_status }.compact)
  end

  describe '#authorize_uri' do
    it 'returns a valid authorize URI' do
      uri = URI.parse(client.authorize_uri(type:, acr:, code_challenge:))
      expect(uri.scheme).to eq('http')
      expect(uri.host).to eq('example.com')
      expect(uri.path).to eq('/v0/sign_in/authorize')
      expect(uri.query).to include("type=#{type}", "acr=#{acr}", "code_challenge=#{code_challenge}",
                                   "code_challenge_method=#{code_challenge_method}", "client_id=#{client_id}")
    end
  end

  describe '#authorize', request: true do
    let(:request_method) { :get }
    let(:request_uri) { '/v0/sign_in/authorize' }
    let(:request_query) { { type:, acr:, code_challenge:, code_challenge_method:, client_id: } }

    context 'when call is successful' do
      let(:expected_response_body) { { code: SecureRandom.hex }.to_json }
      let(:expected_response_status) { 200 }

      it 'returns the expected body and statuss' do
        response = client.authorize(type:, acr:, code_challenge:)
        expect(response.body).to eq(expected_response_body)
        expect(response.status).to eq(expected_response_status)
      end
    end

    context 'when call is unsuccessful' do
      let(:expected_response_status) { 400 }

      it 'raises an error' do
        expect { client.authorize(type:, acr:, code_challenge:) }.to raise_error(SignInService::ClientError)
      end
    end
  end

  describe '#get_token', request: true do
    let(:request_method) { :post }
    let(:request_uri) { '/v0/sign_in/token' }

    let(:request_body) { { code:, code_verifier:, grant_type: 'authorization_code' } }
    let(:code) { SecureRandom.hex }
    let(:code_verifier) { SecureRandom.hex }

    context 'when client has cookie auth_type' do
      let(:expected_response_headers) { { 'set-cookie' => 'some_tokens' } }

      context 'when call is successful' do
        let(:expected_response_status) { 200 }

        it 'exchanges the code for header cookie tokens' do
          response = client.get_token(code:, code_verifier:)
          expect(response.status).to eq(expected_response_status)
          expect(response.headers).to eq(expected_response_headers)
        end
      end

      context 'when call is unsuccessful' do
        let(:expected_response_status) { 400 }

        it 'raises an error' do
          expect { client.get_token(code:, code_verifier:) }.to raise_error(SignInService::ClientError)
        end
      end
    end

    context 'when client has api auth_type' do
      let(:expected_response_body) { { data: 'some-tokens' }.to_json }

      context 'when call is successful' do
        let(:expected_response_status) { 200 }

        it 'exchanges the code for header cookie tokens' do
          response = client.get_token(code:, code_verifier:)
          expect(response.status).to eq(expected_response_status)
          expect(response.body).to eq(expected_response_body)
        end
      end

      context 'when call is unsuccessful' do
        let(:expected_response_status) { 400 }

        it 'raises an error' do
          expect { client.get_token(code:, code_verifier:) }.to raise_error(SignInService::ClientError)
        end
      end
    end
  end
end
