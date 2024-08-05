# frozen_string_literal: true

module SignInService
  class Error < StandardError
    attr_reader :response, :response_headers, :response_body, :errors

    def self.from_response(response)
      status = response[:status].to_i

      klass = case status
              when 400 then BadRequest
              when 401 then Unauthorized
              when 403 then Forbidden
              when 404 then NotFound
              when 422 then UnprocessableEntity
              when 400..499 then ClientError
              when 500 then InternalServerError
              when 501 then NotImplemented
              when 502 then BadGateway
              when 503 then ServiceUnavailable
              when 500..599 then ServerError
              end

      klass&.new(response)
    end

    def initialize(response)
      @response = response
      @response_headers = response[:response_headers]
      @response_body = parsed_response_body
      @errors = fetch_errors
      super(error_message)
    end

    private

    def fetch_errors
      case parsed_response_body
      when Hash
        parsed_response_body[:errors]
      when String
        parsed_response_body
      end
    end

    def error_message
      case errors
      when Hash
        format_errors(errors)
      when String
        errors
      end
    end

    def format_errors(errors)
      case errors
      when Hash
        errors.flat_map do |key, values|
          values.map { |message| "#{key} #{message}" }
        end.join(', ')
      when Array
        errors.join(', ')
      when String
        errors
      end
    end

    def parsed_response_body
      @parsed_response_body ||= if response_headers['content-type'] =~ /json/
                                  begin
                                    JSON.parse(response[:body], symbolize_names: true)
                                  rescue JSON::ParserError
                                    {}
                                  end
                                else
                                  response[:body]
                                end
    end
  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when SignInService returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when SignInService returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when SignInService returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when SignInService returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when SignInService returns a 422 HTTP status code
  class UnprocessableEntity < ClientError; end

  # Raised on SignInService in the 500-599 range
  class ServerError < Error; end

  # Raised when SignInService returns a 500 HTTP status code
  class InternalServerError < ServerError; end

  # Raised when SignInService returns a 501 HTTP status code
  class NotImplemented < ServerError; end

  # Raised when SignInService returns a 502 HTTP status code
  class BadGateway < ServerError; end

  # Raised when SignInService returns a 503 HTTP status code
  class ServiceUnavailable < ServerError; end
end
