require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec



Rake::ExtensionTask.new "account_key" do |ext|
  ext.lib_dir = "lib/convex/account_key"
end


task :install_dependencies do
  if ENV["USE_HTTP_RUBYGEMS_ORG"] == "1"
    Gem.sources.replace([Gem::Source.new("http://rubygems.org")])
  end

  Gem.configuration.verbose = false
  gemspec = Gem::Specification.load('convex_api_ruby.gemspec')

  gemspec.development_dependencies.each do |dep|
    print "Installing #{dep.name} (#{dep.requirement}) ... "
    installed = dep.matching_specs
    if installed.empty?
      installed = Gem.install(dep.name, dep.requirement)
      puts "#{installed[0].version}"
    else
      puts "(found #{installed[0].version})"
    end
  end
end
