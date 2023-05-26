# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Config do
  subject(:config) { described_class.new }

  describe '#base_url' do
    it 'returns default base URL' do
      expect(config.base_url).to eq('http://localhost:3000')
    end

    it 'can be set to a custom value' do
      config.base_url = 'http://example.com'
      expect(config.base_url).to eq('http://example.com')
    end
  end

  describe '#client_id' do
    it 'returns default client ID' do
      expect(config.client_id).to eq('sample')
    end

    it 'can be set to a custom value' do
      config.client_id = 'my-client'
      expect(config.client_id).to eq('my-client')
    end
  end

  describe '#auth_type' do
    it 'returns default token type' do
      expect(config.auth_type).to eq(:cookie)
    end

    it 'can be set to api' do
      config.auth_type = :api
      expect(config.auth_type).to eq(:api)
    end

    it 'can not be set to an invalid value' do
      expect { config.auth_type = :foo }.to raise_error(ArgumentError)
    end
  end
end
