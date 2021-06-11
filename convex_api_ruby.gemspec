# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convex'

Gem::Specification.new do |spec|
  spec.name          = "convex"
  spec.version       = Convex::VERSION
  spec.authors       = ["Billbsing"]
  spec.email         = ["billbsing@gmail.com"]

  spec.summary       = %q{convex api written in ruby}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/billbsing/convex-api-ruby"
  spec.license       = "Apache"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.2.18'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.3.2'
  spec.add_runtime_dependency 'http', '~> 2.2.1'
  spec.add_runtime_dependency 'openssl', '~> 2.2.0'
end
