# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Sts do
  let(:user_identifier) { 'user_identifier' }
  let(:issuer) { 'issuer' }
  let(:scopes) { %w[scope] }
  let(:service_account_id) { 'service_account_id' }
  let(:user_attributes) { { icn: '123456' } }
  let(:private_key_path) { 'private_key_path' }
  let(:base_url) { 'base_url' }

  describe '.configure' do
    it 'yields the config' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(described_class::Config)
    end

    context 'when the config values are set' do
      before do
        described_class.configure do |config|
          config.issuer = issuer
          config.scopes = scopes
          config.service_account_id = service_account_id
          config.user_attributes = user_attributes
          config.private_key_path = private_key_path
          config.base_url = base_url
        end
      end

      after do
        described_class.configure do |config|
          config.issuer = nil
          config.scopes = nil
          config.service_account_id = nil
          config.user_attributes = nil
          config.private_key_path = nil
          config.base_url = nil
        end
      end

      it 'sets the config values' do
        expect(described_class::Config.issuer).to eq(issuer)
        expect(described_class::Config.scopes).to eq(scopes)
        expect(described_class::Config.service_account_id).to eq(service_account_id)
        expect(described_class::Config.user_attributes).to eq(user_attributes)
        expect(described_class::Config.private_key_path).to eq(private_key_path)
        expect(described_class::Config.base_url).to eq(base_url)
      end
    end
  end

  describe '#initialize' do
    subject(:sts) do
      described_class.new(user_identifier:, issuer:, scopes:, service_account_id:,
                          user_attributes:, private_key_path:, base_url:)
    end

    context 'when the config is not set' do
      before do
        described_class::Config.issuer = nil
        described_class::Config.scopes = nil
        described_class::Config.service_account_id = nil
        described_class::Config.user_attributes = nil
        described_class::Config.private_key_path = nil
        described_class::Config.base_url = nil
      end

      context 'when the required attributes are set' do
        it 'does not raise an error' do
          expect { sts }.not_to raise_error
        end
      end

      context 'when the user_identifier is missing' do
        let(:user_identifier) { nil }
        let(:expected_error) { 'missing required attribute: user_identifier' }

        it 'raises an error' do
          expect { sts }.to raise_error(ArgumentError, expected_error)
        end
      end

      context 'when the issuer is missing' do
        let(:issuer) { nil }
        let(:expected_error) { 'missing required attribute: issuer' }

        it 'raises an error' do
          expect { sts }.to raise_error(ArgumentError, expected_error)
        end
      end

      context 'when the service_account_id is missing' do
        let(:service_account_id) { nil }
        let(:expected_error) { 'missing required attribute: service_account_id' }

        it 'raises an error' do
          expect { sts }.to raise_error(ArgumentError, expected_error)
        end
      end

      context 'when the private_key_path is missing' do
        let(:private_key_path) { nil }
        let(:expected_error) { 'missing required attribute: private_key_path' }

        it 'raises an error' do
          expect { sts }.to raise_error(ArgumentError, expected_error)
        end
      end

      context 'when the base_url is missing' do
        let(:base_url) { nil }
        let(:expected_base_url) { 'https://staging-api.va.gov/v0/sign_in' }

        it 'uses the default base_url' do
          expect(sts.base_url).to eq(expected_base_url)
        end
      end

      context 'when scopes is not an array' do
        let(:scopes) { 'scope' }
        let(:expected_error) { 'scopes must be an array' }

        it 'raises an error' do
          expect { sts }.to raise_error(ArgumentError, expected_error)
        end
      end
    end

    context 'when the config is set' do
      let(:config_issuer) { 'config_issuer' }
      let(:config_scopes) { %w[config_scope] }
      let(:config_service_account_id) { 'config_service_account_id' }
      let(:config_user_attributes) { %w[config_user_attribute] }
      let(:config_private_key_path) { 'config_private_key_path' }
      let(:config_base_url) { 'config_base_url' }

      before do
        described_class.configure do |config|
          config.issuer = config_issuer
          config.scopes = config_scopes
          config.service_account_id = config_service_account_id
          config.user_attributes = config_user_attributes
          config.private_key_path = config_private_key_path
          config.base_url = config_base_url
        end
      end

      after do
        described_class.configure do |config|
          config.issuer = nil
          config.scopes = nil
          config.service_account_id = nil
          config.user_attributes = nil
          config.private_key_path = nil
          config.base_url = nil
        end
      end

      context 'when overrides are not provided' do
        subject(:sts) { described_class.new(user_identifier:) }

        it 'does not raise an error' do
          expect { sts }.not_to raise_error
        end

        it 'sets the expected issuer' do
          expect(sts.issuer).to eq(config_issuer)
        end

        it 'sets the expected scopes' do
          expect(sts.scopes).to eq(config_scopes)
        end

        it 'sets the expected service_account_id' do
          expect(sts.service_account_id).to eq(config_service_account_id)
        end

        it 'sets the expected user_attributes' do
          expect(sts.user_attributes).to eq(config_user_attributes)
        end

        it 'sets the expected private_key_path' do
          expect(sts.private_key_path).to eq(config_private_key_path)
        end

        it 'sets the expected base_url' do
          expect(sts.base_url).to eq(config_base_url)
        end
      end
    end
  end
end
