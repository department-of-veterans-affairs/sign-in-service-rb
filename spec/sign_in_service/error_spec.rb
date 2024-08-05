# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Error do
  let(:response_headers) { { 'content-type' => 'application/json' } }

  describe '.from_response' do
    subject { described_class.from_response(response) }

    context 'when response status is 400' do
      let(:response) { { status: 400, body: '{"errors": "Bad Request"}', response_headers: } }

      it { is_expected.to be_a(SignInService::BadRequest) }
    end

    context 'when response status is 401' do
      let(:response) { { status: 401, body: '{"errors": "Unauthorized"}', response_headers: } }

      it { is_expected.to be_a(SignInService::Unauthorized) }
    end

    context 'when response status is 403' do
      let(:response) { { status: 403, body: '{"errors": "Forbidden"}', response_headers: } }

      it { is_expected.to be_a(SignInService::Forbidden) }
    end

    context 'when response status is 404' do
      let(:response) { { status: 404, body: '{"errors": "Not Found"}', response_headers: } }

      it { is_expected.to be_a(SignInService::NotFound) }
    end

    context 'when response status is 422' do
      let(:response) { { status: 422, body: '{"errors": "Unprocessable Entity"}', response_headers: } }

      it { is_expected.to be_a(SignInService::UnprocessableEntity) }
    end

    context 'when response status is 500' do
      let(:response) do
        { status: 500, body: '{"errors": "Internal Server Error"}', response_headers: }
      end

      it { is_expected.to be_a(SignInService::InternalServerError) }
    end

    context 'when response status is 501' do
      let(:response) { { status: 501, body: '{"errors": "Not Implemented"}', response_headers: } }

      it { is_expected.to be_a(SignInService::NotImplemented) }
    end

    context 'when response status is 502' do
      let(:response) { { status: 502, body: '{"errors": "Bad Gateway"}', response_headers: } }

      it { is_expected.to be_a(SignInService::BadGateway) }
    end

    context 'when response status is 503' do
      let(:response) { { status: 503, body: '{"errors": "Service Unavailable"}', response_headers: } }

      it { is_expected.to be_a(SignInService::ServiceUnavailable) }
    end

    context 'when response status is unknown client error' do
      let(:response) { { status: 418, body: '{"errors": "I\'m a teapot"}', response_headers: } }

      it { is_expected.to be_a(SignInService::ClientError) }
    end

    context 'when response status is unknown server error' do
      let(:response) { { status: 550, body: '{"errors": "Unknown Server Error"}', response_headers: } }

      it { is_expected.to be_a(SignInService::ServerError) }
    end
  end

  describe '#initialize' do
    subject(:error) { described_class.new(response) }

    let(:response) do
      {
        status: 400,
        body: '{"errors": {"name": ["is invalid"]}}',
        response_headers:
      }
    end

    it 'parses the response body' do
      expect(error.response_body).to eq(errors: { name: ['is invalid'] })
    end

    it 'fetches errors from the response body' do
      expect(error.errors).to eq(name: ['is invalid'])
    end

    it 'formats the error message correctly' do
      expect(error.message).to eq('name is invalid')
    end
  end

  describe '#format_errors' do
    subject(:error) { described_class.new(response).send(:format_errors, errors) }

    context 'when errors is a hash' do
      let(:response) do
        { status: 400, body: '{"errors": {"field": ["is required"]}}', response_headers: }
      end
      let(:errors) { { field: ['is required'] } }

      it 'formats the error message from a hash' do
        expect(error).to eq('field is required')
      end
    end

    context 'when errors is an array' do
      let(:response) do
        { status: 400, body: '{"errors": ["is required", "is too short"]}', response_headers: }
      end
      let(:errors) { ['is required', 'is too short'] }

      it 'formats the error message from an array' do
        expect(error).to eq('is required, is too short')
      end
    end

    context 'when errors is a string' do
      let(:response) { { status: 400, body: '{"errors": "invalid request"}', response_headers: } }
      let(:errors) { 'invalid request' }

      it 'formats the error message from a string' do
        expect(error).to eq('invalid request')
      end
    end
  end
end
