module Improvmx
  # All rule related endpoints
  module Rules
    # List all rules for a domain
    # @param domain [String] The domain name
    # @param params [Hash] Optional parameters (search, page)
    # @return [Hash] Response containing rules array
    def list_rules(domain, params = {})
      get("/domains/#{domain}/rules/", params).to_h
    end

    # Get a specific rule
    # @param rule_id [String] The rule ID (UUID)
    # @param domain [String] The domain name
    # @return [Hash, nil] The rule object or nil if not found
    def get_rule(rule_id, domain)
      get("/domains/#{domain}/rules/#{rule_id}").to_h
    rescue NotFoundError
      nil
    end

    # Create an alias rule
    # @param domain [String] The domain name
    # @param alias_name [String] The alias (e.g., "richard")
    # @param forward_to [String, Array] Destination email(s)
    # @param rank [Float, nil] Optional rank for evaluation priority
    # @param active [Boolean] Whether the rule is active (default: true)
    # @param id [String, nil] Optional custom rule ID
    # @return [Hash] The created rule
    def create_alias_rule(domain, alias_name, forward_to, rank: nil, active: true, id: nil)
      data = {
        type: 'alias',
        config: {
          alias: alias_name,
          forward: forward(forward_to)
        },
        active: active
      }
      data[:rank] = rank if rank
      data[:id] = id if id

      response = post("/domains/#{domain}/rules/", data)
      response.to_h['rule']
    end

    # Create a regex rule
    # @param domain [String] The domain name
    # @param regex [String] The regular expression pattern
    # @param scopes [Array<String>] Scopes to match (sender, recipient, subject, body)
    # @param forward_to [String, Array] Destination email(s)
    # @param rank [Float, nil] Optional rank for evaluation priority
    # @param active [Boolean] Whether the rule is active (default: true)
    # @param id [String, nil] Optional custom rule ID
    # @return [Hash] The created rule
    def create_regex_rule(domain, regex, scopes, forward_to, rank: nil, active: true, id: nil)
      data = {
        type: 'regex',
        config: {
          regex: regex,
          scopes: scopes,
          forward: forward(forward_to)
        },
        active: active
      }
      data[:rank] = rank if rank
      data[:id] = id if id

      response = post("/domains/#{domain}/rules/", data)
      response.to_h['rule']
    end

    # Create a CEL rule
    # @param domain [String] The domain name
    # @param expression [String] The CEL expression
    # @param forward_to [String, Array] Destination email(s)
    # @param rank [Float, nil] Optional rank for evaluation priority
    # @param active [Boolean] Whether the rule is active (default: true)
    # @param id [String, nil] Optional custom rule ID
    # @return [Hash] The created rule
    def create_cel_rule(domain, expression, forward_to, rank: nil, active: true, id: nil)
      data = {
        type: 'cel',
        config: {
          expression: expression,
          forward: forward(forward_to)
        },
        active: active
      }
      data[:rank] = rank if rank
      data[:id] = id if id

      response = post("/domains/#{domain}/rules/", data)
      response.to_h['rule']
    end

    # Update a rule
    # @param rule_id [String] The rule ID
    # @param domain [String] The domain name
    # @param config [Hash] The config object for the rule
    # @param rank [Float, nil] Optional new rank
    # @param active [Boolean, nil] Optional active state
    # @return [Hash, false] The updated rule or false if not found
    def update_rule(rule_id, domain, config: nil, rank: nil, active: nil)
      data = {}
      data[:config] = config if config
      data[:rank] = rank if rank
      data[:active] = active unless active.nil?

      response = put("/domains/#{domain}/rules/#{rule_id}", data)
      response.to_h['rule']
    rescue NotFoundError
      false
    end

    # Delete a rule
    # @param rule_id [String] The rule ID
    # @param domain [String] The domain name
    # @return [Boolean] true if deleted or not found
    def delete_rule(rule_id, domain)
      response = delete("/domains/#{domain}/rules/#{rule_id}")
      response.ok?
    rescue NotFoundError
      true
    end

    # Delete all rules for a domain
    # @param domain [String] The domain name
    # @return [Boolean] true if successful
    def delete_all_rules(domain)
      response = delete("/domains/#{domain}/rules-all")
      response.ok?
    end

    # Bulk modify rules
    # @param domain [String] The domain name
    # @param rules [Array<Hash>] Array of rule objects
    # @param behavior [String] 'add', 'update', or 'delete' (default: 'add')
    # @return [Hash] Results of bulk operation
    def bulk_modify_rules(domain, rules, behavior: 'add')
      data = {
        rules: rules,
        behavior: behavior
      }

      response = post("/domains/#{domain}/rules/bulk", data)
      response.to_h
    end
  end
end
