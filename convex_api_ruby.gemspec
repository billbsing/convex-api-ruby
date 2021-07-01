
Gem::Specification.new do |spec|
  spec.name          = "convex"
  spec.version       = "0.0.1"
  spec.authors       = ["billbsing"]
  spec.email         = ["billbsing@gmail.com"]

  spec.summary       = %q{convex api written in ruby}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/billbsing/convex-api-ruby"
  spec.license       = "Apache-2.0"

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

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'openssl'
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency 'http'
end
