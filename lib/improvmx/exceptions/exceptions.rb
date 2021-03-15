module Improvmx
  class Error < StandardError
    attr_reader :object

    # Public: initialize a Improvmx:Error object
    #
    # message - a String describing the error
    # object  - an object with details about the error
    def initialize(message = nil, object = nil)
      super(message)
      @object = object
    end
  end

  # Public: Class for managing communications (eg http) response errors
  class CommunicationError < Error
    attr_reader :code

    # Public: initialization of new error given a message and/or object
    #
    # message  - a String detailing the error
    # response - a RestClient::Response object
    #
    def initialize(message = nil, response = nil)
      @response = response
      @code = response.code

      json = JSON.parse(response.body)
      api_message = json['error'] || json['errors']

      message ||= ''
      message = "#{message} #{api_message}"

      super(message, response)
    rescue NoMethodError, JSON::ParserError
      super(message, response)
    end
  end

  class BadRequestError < CommunicationError
  end

  class AuthenticationError < CommunicationError
  end

  class NotFoundError < CommunicationError
  end

  class RateLimitError < CommunicationError
    attr_reader :wait_seconds

    def initialize(message = nil, response = nil)
      super(message, response)

      if response
        reset_at = response.headers.dig(:x_ratelimit_reset) || Time.now.to_i
        @wait_seconds = reset_at.to_i - Time.now.to_i
      else
        @wait_seconds = 0
      end
    end
  end
end
