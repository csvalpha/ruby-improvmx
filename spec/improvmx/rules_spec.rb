require 'spec_helper'
require 'improvmx'

describe Improvmx::Rules do
  let(:client) { Improvmx::Client.new(APIKEY) }
  let(:forward_to) { 'receiver@example.com' }
  let(:other_forward_to) { 'new_receiver@example.com' }
  let(:alias_name) { 'testrule' }

  describe '#create_alias_rule' do
    it 'creates an alias rule' do
      response = client.create_alias_rule(DOMAIN, alias_name, forward_to)

      expect(response).to be_a(Hash)
      expect(response['type']).to eq 'alias'
      expect(response['config']['alias']).to eq alias_name
      expect(response['id']).not_to be_nil
    end
  end

  describe '#create_regex_rule' do
    it 'creates a regex rule' do
      response = client.create_regex_rule(DOMAIN, '.*test.*', ['subject'], forward_to)

      expect(response).to be_a(Hash)
      expect(response['type']).to eq 'regex'
      expect(response['config']['regex']).to eq '.*test.*'
      expect(response['id']).not_to be_nil
    end
  end

  describe '#create_cel_rule' do
    it 'creates a CEL rule' do
      response = client.create_cel_rule(DOMAIN, 'true', forward_to)

      expect(response).to be_a(Hash)
      expect(response['type']).to eq 'cel'
      expect(response['config']['expression']).to eq 'true'
      expect(response['id']).not_to be_nil
    end
  end

  describe '#list_rules' do
    it 'shows all rules' do
      response = client.list_rules(DOMAIN)

      expect(response['rules']).to be_an(Array)
      expect(response).to have_key('success')
    end
  end

  describe '#get_rule' do
    before do
      rules = client.list_rules(DOMAIN)
      @rule_id = rules['rules'].first['id'] if rules['rules'].any?
    end

    it 'shows a specific rule' do
      skip 'No rules available' unless @rule_id

      response = client.get_rule(@rule_id, DOMAIN)

      expect(response['id']).to eq @rule_id
      expect(response['type']).not_to be_nil
    end

    it 'gives nil for invalid rule' do
      response = client.get_rule('non-existing-id', DOMAIN)

      expect(response).to eq nil
    end
  end

  describe '#update_rule' do
    before do
      rules = client.list_rules(DOMAIN)
      @rule_id = rules['rules'].first['id'] if rules['rules'].any?
      @rule_type = rules['rules'].first['type'] if rules['rules'].any?
    end

    it 'updates rule' do
      skip 'No rules available' unless @rule_id

      new_config = if @rule_type == 'alias'
                     { alias: alias_name, forward: other_forward_to }
                   elsif @rule_type == 'regex'
                     { regex: '.*updated.*', scopes: ['subject'], forward: other_forward_to }
                   else
                     { expression: 'true', forward: other_forward_to }
                   end

      response = client.update_rule(@rule_id, DOMAIN, config: new_config)

      expect(response).to be_a(Hash)
      expect(response['config']['forward']).to eq other_forward_to
    end

    it 'returns false on non-existing rule' do
      response = client.update_rule('wrong-id', DOMAIN, config: { forward: other_forward_to })

      expect(response).to eq false
    end
  end

  describe '#delete_rule' do
    before do
      rules = client.list_rules(DOMAIN)
      @rule_id = rules['rules'].first['id'] if rules['rules'].any?
    end

    it 'deletes a rule' do
      skip 'No rules available' unless @rule_id

      response = client.delete_rule(@rule_id, DOMAIN)

      expect(response).to be true
    end

    it 'returns true for non-existing rule' do
      response = client.delete_rule('wrong-id', DOMAIN)

      expect(response).to be true
    end
  end

  describe '#delete_all_rules' do
    it 'deletes all rules' do
      response = client.delete_all_rules(DOMAIN)

      expect(response).to be true
    end
  end

  describe '#bulk_modify_rules' do
    it 'adds multiple rules' do
      rules = [
        { type: 'alias', config: { alias: 'bulk1', forward: forward_to } },
        { type: 'alias', config: { alias: 'bulk2', forward: forward_to } }
      ]

      response = client.bulk_modify_rules(DOMAIN, rules, behavior: 'add')

      expect(response['success']).to be true
      expect(response['results']).to be_an(Array)
    end
  end
end
