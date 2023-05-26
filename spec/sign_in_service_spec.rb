# frozen_string_literal: true

require 'sign_in_service'
require 'pry'

RSpec.describe SignInService do
  let(:expected_base_url) { 'http://localhost:3000' }
  let(:expected_client_id) { 'sample' }
  let(:expected_auth_type) { :cookie }

  after do
    described_class.reset!
  end

  describe '.client' do
    context 'when the is no custom config' do
      it 'Creates a new client with the default config' do
        expect(described_class.client).to be_a(SignInService::Client)
        expect(described_class.client.base_url).to eq(expected_base_url)
        expect(described_class.client.client_id).to eq(expected_client_id)
        expect(described_class.client.auth_type).to eq(expected_auth_type)
      end
    end

    context 'when there is config' do
      let(:expected_base_url) { 'http://example.com' }
      let(:expected_client_id) { 'new_client' }
      let(:expected_auth_type) { :api }

      it 'Creates a new client with the default config' do
        described_class.configure do |config|
          config.base_url = expected_base_url
          config.client_id = expected_client_id
          config.auth_type = expected_auth_type
        end

        expect(described_class.client).to be_a(SignInService::Client)
        expect(described_class.client.base_url).to eq(expected_base_url)
        expect(described_class.client.client_id).to eq(expected_client_id)
        expect(described_class.client.auth_type).to eq(expected_auth_type)
      end
    end
  end

  describe '.configure' do
    context 'when there is no config' do
      it 'sets config to default_values' do
        described_class.configure

        expect(described_class.config.base_url).to eq(expected_base_url)
        expect(described_class.config.client_id).to eq(expected_client_id)
        expect(described_class.config.auth_type).to eq(expected_auth_type)
      end
    end

    context 'when there is config' do
      context 'when base_url is configured' do
        let(:expected_base_url) { 'http://example.com' }

        it 'sets base_url and others remain default' do
          described_class.configure do |config|
            config.base_url = expected_base_url
          end

          expect(described_class.config.base_url).to eq(expected_base_url)
          expect(described_class.config.client_id).to eq(expected_client_id)
          expect(described_class.config.auth_type).to eq(expected_auth_type)
        end
      end

      context 'when client_id is configured' do
        let(:expected_client_id) { 'new_client' }

        it 'sets client_id and others remain default' do
          described_class.configure do |config|
            config.client_id = expected_client_id
          end

          expect(described_class.config.base_url).to eq(expected_base_url)
          expect(described_class.config.client_id).to eq(expected_client_id)
          expect(described_class.config.auth_type).to eq(expected_auth_type)
        end
      end

      context 'when auth_type is configured' do
        let(:expected_auth_type) { :api }

        it 'sets auth_type and others remain default' do
          described_class.configure do |config|
            config.auth_type = expected_auth_type
          end

          expect(described_class.config.base_url).to eq(expected_base_url)
          expect(described_class.config.client_id).to eq(expected_client_id)
          expect(described_class.config.auth_type).to eq(expected_auth_type)
        end
      end

      context 'when all are configured' do
        let(:expected_base_url) { 'http://example.com' }
        let(:expected_client_id) { 'new_client' }
        let(:expected_auth_type) { :api }

        it 'sets auth_type and others remain default' do
          described_class.configure do |config|
            config.base_url = expected_base_url
            config.client_id = expected_client_id
            config.auth_type = expected_auth_type
          end

          expect(described_class.config.base_url).to eq(expected_base_url)
          expect(described_class.config.client_id).to eq(expected_client_id)
          expect(described_class.config.auth_type).to eq(expected_auth_type)
        end
      end
    end
  end
end
