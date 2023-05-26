# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Response::RaiseError do
  subject(:middleware) { described_class.new }

  describe '#on_complete' do
    context 'when the response has an error' do
      let(:response) { { status: 400, body: '{"message": "Invalid credentials"}', response_headers: {} } }

      it 'raises the error' do
        expect { middleware.on_complete(response) }.to raise_error(SignInService::BadRequest)
      end
    end

    context 'when the response does not have an error' do
      let(:response) { { status: 200, body: '{"message": "OK"}', response_headers: {} } }

      it 'does not raise an error' do
        expect { middleware.on_complete(response) }.not_to raise_error
      end
    end
  end
end
