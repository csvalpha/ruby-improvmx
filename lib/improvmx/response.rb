module Improvmx
  # Ruby representation of ImprovMX response
  class Response
    attr_accessor :body, :code

    def initialize(response)
      @body = response.body
      @code = response.code
    end

    # Return response as Ruby Hash
    #
    # @return [Hash] A standard Ruby Hash containing the HTTP result.
    def to_h
      JSON.parse(@body)
    rescue StandardError => e
      raise ParseError.new(e), e
    end

    attr_reader :headers

    def ok?
      @code == 200
    end
  end
end
