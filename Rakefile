require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

task :console do
  require 'rb-inotify'
  require 'pry'
  
  binding.pry
end
