ImprovMX Ruby Gem
============

Ruby interface to connect to the ImprovMX API.

Supports both aliases and rules endpoints.


Installation
------------

```ruby
gem install improvmx
```

Usage
-----
This is how you can use this gem

### Aliases

```ruby
require 'improvmx'

# Instantiate the Client with your API key
client = Improvmx::Client.new 'your-api-key'

# List all the aliases
aliases = client.list_aliases('domain.com')
puts aliases['aliases']

# Create an alias
client.create_alias('hello', 'receiver@example.com', 'domain.com')

# Get a specific alias
alias_info = client.get_alias('hello', 'domain.com')

# Update an alias
client.update_alias('hello', 'new_receiver@example.com', 'domain.com')

# Delete an alias
client.delete_alias('hello', 'domain.com')
```

### Rules

Rules provide advanced email routing based on patterns, regular expressions, or conditions.

```ruby
require 'improvmx'

client = Improvmx::Client.new 'your-api-key'

# List all rules
rules = client.list_rules('domain.com')
puts rules['rules']

# Create an alias rule (matches specific alias)
rule = client.create_alias_rule('domain.com', 'support', 'support@company.com')
puts rule['id']  # => UUID of the created rule

# Create a regex rule (matches based on regex pattern)
rule = client.create_regex_rule(
  'domain.com',
  '.*important.*',           # Regex pattern
  ['subject', 'body'],       # Scopes to match
  'urgent@company.com'       # Forward destination
)

# Create a CEL rule (matches based on CEL expression)
rule = client.create_cel_rule(
  'domain.com',
  "subject.contains('invoice')",  # CEL expression
  'billing@company.com'
)

# Create a rule with custom rank and active state
rule = client.create_alias_rule(
  'domain.com',
  'priority',
  'priority@company.com',
  rank: 1.0,      # Lower rank = higher priority
  active: true
)

# Get a specific rule by ID
rule = client.get_rule('rule-uuid', 'domain.com')

# Update a rule's config
client.update_rule(
  'rule-uuid',
  'domain.com',
  config: { alias: 'support', forward: 'newsupport@company.com' },
  active: false
)

# Delete a rule
client.delete_rule('rule-uuid', 'domain.com')

# Delete all rules
client.delete_all_rules('domain.com')

# Bulk add multiple rules
rules = [
  { type: 'alias', config: { alias: 'info', forward: 'info@company.com' } },
  { type: 'alias', config: { alias: 'sales', forward: 'sales@company.com' } }
]
client.bulk_modify_rules('domain.com', rules, behavior: 'add')
```

Improvmx has a rate limit system, to handle this you can do
```ruby
require 'improvmx'
client = Improvmx::Client.new 'your-api-key'

begin
  client.list_aliases('domain.com')
rescue Improvmx::RateLimitError => e
  sleep e.wait_seconds
  retry
end

```

Rails
-----

The library can be initialized with a Rails initializer containing similar:
```ruby
Improvmx.configure do |config|
  config.api_key = 'your-secret-api-key'
  config.domain = 'your-domain'
end
```


For usage examples on each API endpoint, head over to our official documentation
pages. Or the [Snippets](docs/Snippets.md) file.

Testing
-------

There are different test, they require you to setup an ImprovMX account with domain to run.
By default:
```
bundle exec rake spec
```
will run all the tests.

To setup the key information for testing copy `.env.example` to `.env` and fill in the details.


Deployment
------

This part is for maintaincers only. In order to deploy this gem to rubygem follow those steps:

1. Bump the version in `lib/improvmx/version.rb`
2. Build the gem using `gem build improvmx.gemspec`
3. Push it to rubygems `gem push improvmx-x.x.x.gem`