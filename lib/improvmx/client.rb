require 'improvmx/aliases'
require 'improvmx/smtp'
require 'improvmx/response'
require 'improvmx/utils'
require 'improvmx/exceptions/exceptions'

module Improvmx
  class Client
    include Improvmx::Aliases
    include Improvmx::SMTP
    include Improvmx::Utils

    # Default timeout values in seconds
    DEFAULT_OPEN_TIMEOUT = 60
    DEFAULT_READ_TIMEOUT = 60

    # rubocop:disable Metrics/MethodLength
    def initialize(api_key = Improvmx.api_key, options = {})
      rest_client_params = {
        user: 'api',
        password: api_key,
        user_agent: "improvmx-ruby/#{Improvmx::VERSION}",
        timeout: options[:read_timeout] || DEFAULT_READ_TIMEOUT,
        open_timeout: options[:open_timeout] || DEFAULT_OPEN_TIMEOUT,
        headers: {
          content_type: 'application/json'
        }
      }

      @http_client = RestClient::Resource.new('https://api.improvmx.com/v3', rest_client_params)
    end
    # rubocop:enable Metrics/MethodLength

    def post(resource_path, data, headers = {})
      response = @http_client[resource_path].post(data.to_json, headers)
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    def get(resource_path, params = nil, accept = '*/*')
      response = @http_client[resource_path].get(params: params, accept: accept)
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    def put(resource_path, data)
      response = @http_client[resource_path].put(data.to_json)
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    def delete(resource_path)
      response = @http_client[resource_path].delete
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    private

    def communication_error(e) # rubocop:disable Metrics/AbcSize
      if e.respond_to? :response
        code = e.response.code

        return BadRequestError.new(e.message, e.response) if code == 400
        return AuthenticationError.new(e.message, e.response) if code == 401
        return NotFoundError.new(e.message, e.response) if code == 404
        return RateLimitError.new(e.message, e.response) if code == 429

        return CommunicationError.new(e.message, e.response)
      end

      CommunicationError.new(e.message)
    end
  end
end
