require 'rspec/core/rake_task'
require 'rake/extensiontask'
require 'rdoc/task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Rake::ExtensionTask.new "account_key" do |ext|
  ext.lib_dir = "lib/convex/account_key"
end

RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("*.md", "lib/**/*.rb", "ext/**/*.c")
end
