require 'spec_helper'
require 'improvmx/utils'

describe Improvmx::Utils do
  include described_class

  context 'when with string' do
    subject(:result) { forward('test@example.com,foo@example.com') }

    it { expect(result).to eq 'test@example.com,foo@example.com' }
  end

  context 'when with array' do
    subject(:result) { forward(%w[test@example.com foo@example.com]) }

    it { expect(result).to eq 'test@example.com,foo@example.com' }
  end
end
