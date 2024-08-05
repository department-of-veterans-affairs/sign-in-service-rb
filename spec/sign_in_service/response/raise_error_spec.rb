# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignInService::Response::RaiseError do
  subject(:middleware) { described_class.new }

  describe '#on_complete' do
    context 'when the response has an error' do
      context 'when the body is a JSON string' do
        let(:response) do
          { status: 404, body: { errors: 'Not found' }.to_json,
            response_headers: { 'content-type' => 'application/json' } }
        end

        it 'raises the error expected message' do
          expect do
            middleware.on_complete(response)
          end.to raise_error(SignInService::NotFound, 'Not found')
        end

        it 'sets the errors attribute' do
          middleware.on_complete(response)
        rescue SignInService::NotFound => e
          expect(e.errors).to eq('Not found')
        end

        context 'when there are multiple errors' do
          let(:response) do
            { status: 422, body: { errors: { email: ['is invalid'], password: ['is too short'] } }.to_json,
              response_headers: { 'content-type' => 'application/json' } }
          end

          it 'raises the error with expected message' do
            expect do
              middleware.on_complete(response)
            end.to raise_error(SignInService::UnprocessableEntity, 'email is invalid, password is too short')
          end

          it 'sets the errors attribute' do
            middleware.on_complete(response)
          rescue SignInService::UnprocessableEntity => e
            expect(e.errors).to eq({ email: ['is invalid'], password: ['is too short'] })
          end
        end
      end

      context 'when the body is a string' do
        let(:response) do
          { status: 401, body: 'Unauthorized', response_headers: { 'content-type' => 'text/plain' } }
        end

        it 'raises the error with expected message' do
          expect do
            middleware.on_complete(response)
          end.to raise_error(SignInService::Unauthorized).with_message('Unauthorized')
        end
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
