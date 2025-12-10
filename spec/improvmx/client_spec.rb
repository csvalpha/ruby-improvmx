require 'spec_helper'
require 'improvmx'

describe Improvmx::Client do
  describe '#initialize' do
    it 'initializes with default timeout values' do
      client = described_class.new('test-api-key')

      expect(client).to be_a(described_class)
    end

    it 'initializes with custom timeout values' do
      client = described_class.new('test-api-key', {
                                     read_timeout: 120,
                                     open_timeout: 30
                                   })

      expect(client).to be_a(described_class)
    end

    it 'initializes with partial timeout configuration' do
      client = described_class.new('test-api-key', { read_timeout: 90 })

      expect(client).to be_a(described_class)
    end
  end
end
