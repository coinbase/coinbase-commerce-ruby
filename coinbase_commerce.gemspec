# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require 'coinbase_commerce/version'

Gem::Specification.new do |gem|
  gem.name          = "coinbase_commerce"
  gem.version       = CoinbaseCommerce::VERSION
  gem.license       = "MIT"
  gem.required_ruby_version = ">= 2.0.0"
  gem.authors       = ["Coinbase Commerce",]

  gem.description   = "Client library for Coinbase Commerce API"
  gem.summary       = "Client library for Coinbase Commerce API"
  gem.homepage      = "https://commerce.coinbase.com/docs/api/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("faraday", "~> 1.0.0")

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "pry-byebug"
end
