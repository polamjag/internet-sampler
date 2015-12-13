# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'internet-sampler/version'

Gem::Specification.new do |spec|
  spec.name          = "internet-sampler"
  spec.version       = InternetSampler::VERSION
  spec.authors       = ["polamjag"]
  spec.email         = ["s@polamjag.info"]

  spec.summary       = %q{Internet Sampler: Collaborative Sampler for the Web}
  spec.homepage      = "http://sampler.polamjag.info/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra", "~> 1.4.6"
  spec.add_dependency "sinatra-contrib", "~> 1.4.6"
  spec.add_dependency "sinatra-websocket"
  spec.add_dependency "slim", "~> 3.0.6"
  spec.add_dependency "redis"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
