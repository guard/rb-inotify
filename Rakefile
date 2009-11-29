require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rb-inotify"
    gem.summary = "A Ruby wrapper for Linux's inotify, using FFI"
    gem.description = gem.summary
    gem.email = "nex342@gmail.com"
    gem.homepage = "http://github.com/nex3/rb-notify"
    gem.authors = ["Nathan Weizenbaum"]
    gem.add_dependency "ffi", ">= 0.5.0"
    gem.add_development_dependency "yard"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
