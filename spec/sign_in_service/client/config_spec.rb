# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Client::Config do
  subject(:config) { described_class }

  before do
    config.base_url = nil
    config.client_id = nil
    config.auth_type = nil
    config.auth_flow = nil
  end

  describe '.base_url' do
    context 'when base_url is not set' do
      it 'returns the default value' do
        expect(config.base_url).to eq('http://localhost:3000')
      end
    end

    context 'when base_url is set' do
      before { config.base_url = 'http://example.com' }

      it 'returns the set value' do
        expect(config.base_url).to eq('http://example.com')
      end
    end
  end

  describe '.client_id' do
    context 'when client_id is not set' do
      it 'returns the default value' do
        expect(config.client_id).to eq('sample')
      end
    end

    context 'when client_id is set' do
      before { config.client_id = 'test' }

      it 'returns the set value' do
        expect(config.client_id).to eq('test')
      end
    end
  end

  describe '.auth_type' do
    context 'when auth_type is not set' do
      it 'returns the default value' do
        expect(config.auth_type).to eq(:cookie)
      end
    end

    context 'when auth_type is set' do
      before { config.auth_type = :api }

      it 'returns the set value' do
        expect(config.auth_type).to eq(:api)
      end
    end
  end

  describe '.auth_flow' do
    context 'when auth_flow is not set' do
      it 'returns the default value' do
        expect(config.auth_flow).to eq(:pkce)
      end
    end

    context 'when auth_flow is set' do
      before { config.auth_flow = :jwt }

      it 'returns the set value' do
        expect(config.auth_flow).to eq(:jwt)
      end
    end
  end

  describe '.to_h' do
    let(:expected_hash) do
      {
        base_url: 'http://localhost:3000',
        client_id: 'sample',
        auth_type: :cookie,
        auth_flow: :pkce
      }
    end

    it 'returns the configuration as a hash' do
      expect(config.to_h).to eq(expected_hash)
    end
  end
end
