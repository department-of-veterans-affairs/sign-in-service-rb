# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Error do
  describe '.from_response' do
    let(:response) { { status:, response_headers: {}, body: '' } }
    let(:status) { 'some-status' }

    context 'when the status code is 200' do
      let(:status) { 200 }

      it 'returns nil' do
        expect(described_class.from_response(response)).to be_nil
      end
    end

    context 'when the status code is 400' do
      let(:status) { 400 }

      it 'returns a BadRequest error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::BadRequest)
      end
    end

    context 'when the status code is 401' do
      let(:status) { 401 }

      it 'returns an Unauthorized error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::Unauthorized)
      end
    end

    context 'when the status code is 403' do
      let(:status) { 403 }

      it 'returns a Forbidden error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::Forbidden)
      end
    end

    context 'when the status code is 404' do
      let(:status) { 404 }

      it 'returns a NotFound error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::NotFound)
      end
    end

    context 'when the status code is 422' do
      let(:status) { 422 }

      it 'returns an UnprocessableEntity error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::UnprocessableEntity)
      end
    end

    context 'when the status code is 500' do
      let(:status) { 500 }

      it 'returns an InternalServerError' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::InternalServerError)
      end
    end

    context 'when the status code is 501' do
      let(:status) { 501 }

      it 'returns a NotImplemented error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::NotImplemented)
      end
    end

    context 'when the status code is 502' do
      let(:status) { 502 }

      it 'returns a BadGateway error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::BadGateway)
      end
    end

    context 'when the status code is 503' do
      let(:status) { 503 }

      it 'returns a ServiceUnavailable error' do
        expect(described_class.from_response(response)).to be_an_instance_of(SignInService::ServiceUnavailable)
      end
    end

    context 'when the status code does not exist' do
      let(:status) { 600 }

      it 'returns nil' do
        expect(described_class.from_response(response)).to be_nil
      end
    end
  end

  describe '#initialize' do
    let(:response) { { status: 404, response_headers:, body: } }
    let(:response_headers) { 'some-headers' }
    let(:body) { 'some-body' }
    let(:expected_error_message) { 'some-error-message' }

    context 'when the response contains a JSON error message' do
      let(:response_headers) { { 'content-type' => 'application/json' } }

      context 'when the response contains a message' do
        let(:body) { { errors: 'Page not found' }.to_json }
        let(:expected_error_message) { 'Page not found' }

        it 'builds an error message from the JSON response' do
          expect(described_class.new(response).message).to eq expected_error_message
        end
      end

      context 'when the response does not contain a message' do
        let(:body) { '{}' }
        let(:expected_error_message) { '' }

        it 'builds an empty error message' do
          expect(described_class.new(response).message).to eq expected_error_message
        end
      end
    end

    context 'when the response contains a plain text error message' do
      let(:response_headers) { { 'content-type' => 'text/plain' } }

      context 'when the response contains a message' do
        let(:body) { 'Page not found' }
        let(:expected_error_message) { 'Page not found' }

        it 'builds an error message from the plain text response' do
          expect(described_class.new(response).message).to eq expected_error_message
        end
      end

      context 'when the response does not contain a message' do
        let(:body) { '' }
        let(:expected_error_message) { '' }

        it 'builds an empty error message' do
          expect(described_class.new(response).message).to eq expected_error_message
        end
      end
    end
  end
end
