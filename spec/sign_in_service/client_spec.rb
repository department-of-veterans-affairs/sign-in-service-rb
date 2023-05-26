# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Client do
  let(:client) do
    described_class.new(
      base_url:,
      client_id:,
      auth_type:
    )
  end
  let(:base_url) { 'https://example.com/' }
  let(:client_id) { 'my_client_id' }
  let(:auth_type) { :cookie }

  describe '#connection' do
    it 'returns a Faraday connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end

    it 'uses the base URL' do
      expect(client.connection.url_prefix.to_s).to eq(base_url)
    end

    it 'encodes request parameters in the URL-encoded format' do
      expect(client.connection.builder.handlers).to include(Faraday::Request::UrlEncoded)
    end

    it 'raises an error from the middleware' do
      stub_request(:get, "#{base_url}foo").to_return(status: 404)
      expect { client.connection.get('/foo') }.to raise_error(SignInService::ClientError)
    end
  end

  describe '#api_auth?' do
    context 'when the auth_type is :api' do
      let(:auth_type) { :api }

      it 'returns true' do
        expect(client.api_auth?).to eq(true)
      end
    end

    context 'when the auth_type is :cookie' do
      let(:auth_type) { :cookie }

      it 'returns false' do
        expect(client.api_auth?).to eq(false)
      end
    end
  end

  describe '#cookie_auth?' do
    context 'when the auth_type is :cookie' do
      let(:auth_type) { :cookie }

      it 'returns true' do
        expect(client.cookie_auth?).to eq(true)
      end
    end

    context 'when the auth_type is :api' do
      let(:auth_type) { :api }

      it 'returns false' do
        expect(client.cookie_auth?).to eq(false)
      end
    end
  end
end
