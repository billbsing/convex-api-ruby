require "rspec/core/rake_task"
require "rake/extensiontask"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Rake::ExtensionTask.new "account_key" do |ext|
  ext.lib_dir = "lib/convex/account_key"
end
