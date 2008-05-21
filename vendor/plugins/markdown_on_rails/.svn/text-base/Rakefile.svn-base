require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
begin
  require 'rubygems'
  require 'rake/gempackagetask'
rescue Exception
  nil
end


desc "Default Task"
task :default => :test

# Test Tasks ---------------------------------------------------------

desc "Run all tests"
task :test => [:test_units]
task :ta => [:test]

task :tu => [:test_units]

Rake::TestTask.new("test_units") do |t|
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end

desc "Look for Debugging print lines"
task :dbg do
  FileList['**/*.rb'].egrep /\bDBG|\bbreakpoint\b/
end

