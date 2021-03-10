require 'spec_helper'
require 'improvmx'

describe Improvmx::Aliases do
  let(:client) { Improvmx::Client.new(APIKEY) }
  let(:alias_name) { 'test' }
  let(:other_alias_name) { 'new' }
  let(:forward_to) { 'receiver@example.com' }
  let(:other_forward_to) { 'new_receiver@example.com' }

  describe '#create_alias' do
    it 'creates' do
      response = client.create_alias(alias_name, forward_to, DOMAIN)

      expect(response).to be true
    end
  end

  describe '#list_aliases' do
    it 'shows' do
      response = client.list_aliases(DOMAIN)

      expect(response.to_h['aliases'].size).to eq 1
    end
  end

  describe '#get_alias' do
    it 'shows' do
      response = client.get_alias(alias_name, DOMAIN)

      expect(response.to_h.dig('alias', 'alias')).to eq alias_name
    end

    it 'gives nil for invalid alias' do
      response = client.get_alias('non-existing', DOMAIN)

      expect(response).to eq nil
    end
  end

  describe '#update_alias' do
    it 'updates alias' do
      response = client.update_alias(alias_name, other_forward_to, DOMAIN)

      expect(response).to eq true

      aliases = client.get_alias(alias_name, DOMAIN)
      expect(aliases.to_h.dig('alias', 'forward')).to eq other_forward_to
    end

    it 'returns false on non-existing alias' do
      response = client.update_alias('wrong-name', other_forward_to, DOMAIN)

      expect(response).to eq false
    end
  end

  describe '#create_or_update_alias' do
    it 'creates when with new alias' do
      response = client.create_or_update_alias(other_alias_name, forward_to, DOMAIN)

      expect(response).to eq true

      aliases = client.get_alias(other_alias_name, DOMAIN)
      expect(aliases.to_h.dig('alias', 'forward')).to eq forward_to
    end

    it 'updates when with existing alias' do
      response = client.create_or_update_alias(alias_name, forward_to, DOMAIN)

      expect(response).to eq true

      aliases = client.get_alias(alias_name, DOMAIN)
      expect(aliases.to_h.dig('alias', 'forward')).to eq forward_to
    end
  end

  describe '#delete_alias' do
    it 'deletes' do
      client.delete_alias(other_alias_name, DOMAIN)
      client.delete_alias(alias_name, DOMAIN)

      response = client.list_aliases(DOMAIN)
      expect(response.to_h['aliases'].size).to eq 0
    end

    it 'returns true for non-existing alias' do
      response = client.delete_alias('wrong-name', DOMAIN)

      expect(response).to be true
    end
  end
end
