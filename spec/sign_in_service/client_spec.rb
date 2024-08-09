# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Client do
  subject(:client) { described_class.new(base_url:, client_id:, auth_type:) }

  let(:base_url) { 'https://example.com/' }
  let(:client_id) { 'my_client_id' }
  let(:auth_type) { :cookie }
  let(:auth_flow) { :pkce }

  describe '#connection' do
    let(:connection) { client.connection }

    it 'returns a Faraday connection' do
      expect(connection).to be_a(Faraday::Connection)
    end

    it 'uses the base URL' do
      expect(connection.url_prefix.to_s).to eq(base_url)
    end

    it 'encodes request parameters in the JSON format' do
      expect(connection.builder.handlers).to include(Faraday::Request::Json)
    end

    it 'raises an error from the middleware' do
      stub_request(:get, "#{base_url}foo").to_return(status: 404)
      expect { connection.get('/foo') }.to raise_error(SignInService::ClientError)
    end
  end

  describe '#api_auth?' do
    subject { client.api_auth? }

    context 'when the auth_type is :api' do
      let(:auth_type) { :api }

      it { is_expected.to be true }
    end

    context 'when the auth_type is :cookie' do
      it { is_expected.to be false }
    end
  end

  describe '#cookie_auth?' do
    subject { client.cookie_auth? }

    context 'when the auth_type is :cookie' do
      it { is_expected.to be true }
    end

    context 'when the auth_type is :api' do
      let(:auth_type) { :api }

      it { is_expected.to be false }
    end
  end

  describe '.configure' do
    subject(:client) { described_class.new }

    let(:base_url) { 'https://config.com/' }
    let(:client_id) { 'config_client_id' }
    let(:auth_type) { :api }
    let(:auth_flow) { :jwt }

    it 'yields the config' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(described_class::Config)
    end

    context 'when the config is set' do
      before do
        described_class.configure do |config|
          config.base_url = base_url
          config.client_id = client_id
          config.auth_type = auth_type
          config.auth_flow = auth_flow
        end
      end

      it 'sets the configuration values' do
        expect(client.base_url).to eq(base_url)
        expect(client.client_id).to eq(client_id)
        expect(client.auth_type).to eq(auth_type)
        expect(client.auth_flow).to eq(auth_flow)
      end

      context 'when the config is overridden' do
        let(:new_base_url) { 'https://new.com/' }
        let(:new_client_id) { 'new_client_id' }
        let(:new_auth_type) { :cookie }
        let(:new_auth_flow) { :pkce }

        let(:client) do
          described_class.new(
            base_url: new_base_url,
            client_id: new_client_id,
            auth_type: new_auth_type,
            auth_flow: new_auth_flow
          )
        end

        it 'overrides the configuration values' do
          expect(described_class::Config.base_url).to eq(base_url)
          expect(described_class::Config.client_id).to eq(client_id)
          expect(described_class::Config.auth_type).to eq(auth_type)
          expect(described_class::Config.auth_flow).to eq(auth_flow)

          expect(client.base_url).to eq(new_base_url)
          expect(client.client_id).to eq(new_client_id)
          expect(client.auth_type).to eq(new_auth_type)
          expect(client.auth_flow).to eq(new_auth_flow)
        end
      end
    end

    it 'sets the configuration values' do
      described_class.configure do |config|
        config.base_url = base_url
        config.client_id = client_id
        config.auth_type = auth_type
        config.auth_flow = auth_flow
      end

      expect(client.base_url).to eq(base_url)
      expect(client.client_id).to eq(client_id)
      expect(client.auth_type).to eq(auth_type)
      expect(client.auth_flow).to eq(auth_flow)
    end
  end

  describe '.config' do
    subject(:client) { described_class }

    it 'returns the configuration' do
      expect(client.config).to eq(described_class::Config)
    end
  end
end
