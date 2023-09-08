ImprovMX Ruby Gem
============

Ruby interface to connect to the ImprovMX API.

Currently still work in progress, it only contains the aliases endpoints at the moment.


Installation
------------

```ruby
gem install improvmx
```

Usage
-----
This is how you can use this gem

```ruby
require 'improvmx'

# Instantiate the Client with your API key and domain
client = Improvmx::Client.new 'your-api-key'

# List all the aliases
aliases = client.list_aliases('domain.com')

puts aliases['aliases']
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