require 'spec_helper'
require 'improvmx'

describe Improvmx::SMTP do
  let(:client) { Improvmx::Client.new(APIKEY) }
  let(:smtp_username) { 'test' }
  let(:smtp_password) { SecureRandom.hex }
  let(:new_smtp_password) { SecureRandom.hex }

  describe '#create_smtp' do
    it 'creates' do
      response = client.create_smtp(smtp_username, smtp_password, DOMAIN)

      expect(response).to be true
    end
  end

  describe '#list_smtp' do
    it 'shows' do
      response = client.list_smtp(DOMAIN)

      expect(response.to_h['credentials'].size).to eq 1
      expect(response.to_h['credentials'][0]['username']).to eq smtp_username
    end
  end

  describe '#delete_smtp' do
    it 'deletes' do
      client.delete_smtp(smtp_username, DOMAIN)

      response = client.list_smtp(DOMAIN)
      expect(response.to_h['credentials'].size).to eq 0
    end

    it 'returns true for non-existing alias' do
      response = client.delete_smtp('wrong-name', DOMAIN)

      expect(response).to be true
    end
  end
end
