# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Sts::Config do
  subject(:config) { described_class }

  setup_and_teardown = proc do
    config.issuer = nil
    config.scopes = nil
    config.service_account_id = nil
    config.user_attributes = nil
    config.private_key_path = nil
    config.base_url = nil
  end

  before(&setup_and_teardown)
  after(&setup_and_teardown)

  describe 'class attributes' do
    let(:default_sts_base_url) { 'https://staging-api.va.gov/v0/sign_in' }
    let(:issuer) { 'https://staging-api.va.gov/v0/sign_in' }
    let(:scopes) { %i[openid profile email] }
    let(:service_account_id) { '123456' }
    let(:user_attributes) { { icn: '123456' } }
    let(:private_key_path) { 'path/to/private/key' }

    context 'when no base_url is set' do
      before do
        stub_const('SignInService::Sts::Config::DEFAULT_STS_BASE_URL', default_sts_base_url)
      end

      it 'returns the default base_url' do
        expect(config.base_url).to eq(default_sts_base_url)
      end
    end

    context 'when all attributes are set' do
      before do
        config.issuer = issuer
        config.scopes = scopes
        config.service_account_id = service_account_id
        config.user_attributes = user_attributes
        config.private_key_path = private_key_path
      end

      it 'returns the set values' do
        expect(config.issuer).to eq(issuer)
        expect(config.scopes).to eq(scopes)
        expect(config.service_account_id).to eq(service_account_id)
        expect(config.user_attributes).to eq(user_attributes)
        expect(config.private_key_path).to eq(private_key_path)
      end
    end
  end
end
