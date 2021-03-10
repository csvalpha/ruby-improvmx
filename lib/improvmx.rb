require 'rest_client'
require 'json'

require 'improvmx/client'
require 'improvmx/version'
require 'improvmx/exceptions/exceptions'

# Module for interaction with Improvmx
module Improvmx
  class << self
    attr_accessor :api_key, :domain

    def configure
      yield self
      true
    end
  end
end
