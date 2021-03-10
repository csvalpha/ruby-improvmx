require 'improvmx/aliases'
require 'improvmx/response'
require 'improvmx/utils'
require 'improvmx/exceptions/exceptions'

module Improvmx
  class Client
    include Improvmx::Aliases
    include Improvmx::Utils

    def initialize(api_key = Improvmx.api_key, domain = Improvmx.domain)
      rest_client_params = {
        user: 'api',
        password: api_key,
        user_agent: "improvmx-ruby/#{Improvmx::VERSION}"
      }

      @http_client = RestClient::Resource.new('https://api.improvmx.com/v3', rest_client_params)
      @domain = domain
    end

    # Generic Improvmx POST Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with. Be sure to include your domain, where necessary.
    # @param [Hash] data This should be a standard Hash
    # containing required parameters for the requested resource.
    # @param [Hash] headers Additional headers to pass to the resource.
    # @return [Improvmx::Response] A Improvmx::Response object.
    def post(resource_path, data, headers = {})
      response = @http_client[resource_path].post(data, headers)
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    # Generic Improvmx GET Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with.
    # @param [Hash] params This should be a standard Hash
    # containing required parameters for the requested resource.
    # @param [String] accept Acceptable Content-Type of the response body.
    # @return [Improvmx::Response] A Improvmx::Response object.
    def get(resource_path, params = nil, accept = '*/*')
      response = @http_client[resource_path].get(params: params, accept: accept)
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    # Generic Improvmx PUT Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with.
    # @param [Hash] data This should be a standard Hash
    # containing required parameters for the requested resource.
    # @return [Improvmx::Response] A Improvmx::Response object.
    def put(resource_path, data)
      response = @http_client[resource_path].put(data)
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    # Generic Improvmx DELETE Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with.
    # @return [Improvmx::Response] A Improvmx::Response object.
    def delete(resource_path)
      response = @http_client[resource_path].delete
      Response.new(response)
    rescue StandardError => e
      raise communication_error e
    end

    attr_reader :domain

    private

    # Raises CommunicationError and stores response in it if present
    #
    # @param [StandardException] e upstream exception object
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
