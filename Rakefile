require 'rubygems'
require 'rake'
require 'bundler'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "state_machine-mongoid"
    gem.summary = %Q{state_machine mongoid integration}
    gem.description = %Q{a little lack of tests but it works!}
    gem.email = "marcin.ciunelis@gmail.com"
    gem.homepage = "http://github.com/martinciu/state_machine-mongoid"
    gem.authors = ["Marcin Ciunelis"]
    gem.add_bundler_dependencies
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "state_machine-mongoid #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
