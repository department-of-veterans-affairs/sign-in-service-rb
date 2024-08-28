# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Sts::Token do
  let(:base_url) { 'https://staging-api.va.gov' }
  let(:issuer) { 'http://localhost:4000' }
  let(:scope_path) { '/sign_in/client_configs' }
  let(:scopes) { ["#{base_url}#{scope_path}"] }
  let(:service_account_id) { '01b8ebaac5215f84640ade756b645f28' }
  let(:private_key_path) { 'spec/fixtures/files/keys/sis_sts_private_key.pem' }
  let(:user_identifier) { 'test@email.com' }
  let(:user_attributes) { { 'icn' => '123456' } }

  before do
    allow(SignInService::Sts::Config).to receive_messages(issuer:, scopes:, service_account_id:,
                                                          user_attributes:, private_key_path:, base_url:)
  end

  describe '#token' do
    let(:sts) { SignInService::Sts.new(user_identifier:) }

    context 'when the call is successful' do
      let(:expected_issuer) { 'va.gov sign in' }
      let(:expected_audience) { issuer }
      let(:expected_subject) { user_identifier }
      let(:expected_scopes) { scopes }
      let(:expected_service_account_id) { service_account_id }
      let(:expected_user_attributes) { user_attributes }

      it 'returns a JWT token with expected attributes' do
        VCR.use_cassette('sts_token/success') do
          decoded_token = JWT.decode(sts.token, nil, false).first

          expect(decoded_token['iss']).to eq(expected_issuer)
          expect(decoded_token['aud']).to eq(expected_audience)
          expect(decoded_token['sub']).to eq(expected_subject)
          expect(decoded_token['scopes']).to include(match(scope_path))
          expect(decoded_token['service_account_id']).to eq(expected_service_account_id)
          expect(decoded_token['user_attributes']).to eq(expected_user_attributes)
        end
      end
    end

    context 'when the call is unsuccessful' do
      let(:service_account_id) { 'invalid' }
      let(:expected_message) { 'Service account config not found' }

      it 'raises an error' do
        VCR.use_cassette('sts_token/failure') do
          expect { sts.token }.to raise_error(SignInService::BadRequest).with_message(expected_message)
        end
      end
    end
  end
end
