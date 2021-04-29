module Improvmx
  # All alias related endpoints
  module Aliases
    def list_aliases(domain, params = {})
      get("/domains/#{domain}/aliases/", params).to_h
    end

    def get_alias(alias_name, domain)
      get("/domains/#{domain}/aliases/#{alias_name}")
    rescue NotFoundError
      nil
    end

    def create_alias(alias_name, forward_to, domain)
      response = post("/domains/#{domain}/aliases/", { alias: alias_name, forward: forward(forward_to) })

      response.ok?
    end

    def update_alias(alias_name, forward_to, domain)
      response = put("/domains/#{domain}/aliases/#{alias_name}", { forward: forward(forward_to) })

      response.ok?
    rescue NotFoundError
      false
    end

    def create_or_update_alias(alias_name, forward_to, domain)
      return true if update_alias(alias_name, forward_to, domain)

      create_alias(alias_name, forward_to, domain)
    end

    def delete_alias(alias_name, domain)
      response = delete("/domains/#{domain}/aliases/#{alias_name}")

      response.ok?
    rescue NotFoundError
      true
    end
  end
end
