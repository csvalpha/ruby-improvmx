lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'improvmx/version'

Gem::Specification.new do |spec|
  spec.name = 'improvmx'
  spec.version = Improvmx::VERSION
  spec.homepage = 'https://improvmx.com'
  spec.license = 'MIT'
  spec.description = 'Ruby interface for the ImprovMX API'
  spec.summary = 'Ruby interface for the ImprovMX API'
  spec.authors = ['C.S.V. Alpha', 'Matthijs Vos']
  spec.email = 'ict@csvalpha.nl'

  spec.files = %w[LICENSE README.md improvmx.gemspec] + Dir['lib/**/*.rb']
  spec.require_paths = %w[lib]

  spec.required_ruby_version = '>= 2.4'
  spec.add_dependency 'rest-client', '~> 2.0'
end
