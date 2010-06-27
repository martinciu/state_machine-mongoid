require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'active_model'
require 'state_machine'
require 'mongoid'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'state_machine-mongoid'
require 'spec'
require 'spec/autorun'
require 'vehicle'

Spec::Runner.configure do |config|
  
end
