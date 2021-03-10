require 'improvmx/aliases'
require 'improvmx/response'
require 'improvmx/exceptions/exceptions'

module Improvmx
  # Utils to help processing data
  module Utils
    # Parse the forward to parameter into a comma separated string
    def forward(forward_to)
      return forward_to.join(',') if forward_to.is_a? Array

      forward_to
    end
  end
end
