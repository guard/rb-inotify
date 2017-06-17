source 'https://rubygems.org'

# Specify your gem's dependencies in utopia.gemspec
gemspec

group :development do
	gem 'pry'
  # coolline is a runtime dependency of pry-coolline.
  # unicode_utils is a runtime dependency of coolline.
  # unicode_utils requires Ruby '> 1.9' from 1st version.
  gem 'pry-coolline' if RUBY_VERSION >= '1.9.1'
	gem 'tty-prompt'
end

group :test do
	gem 'simplecov'
	gem 'coveralls', :require => false
  # tins is a runtime dependency of coveralls.
  gem 'tins', '~> 1.6.0' if RUBY_VERSION < '2.0'
  # term-ansicolor is a runtime dependency of coveralls.
  gem 'term-ansicolor', '~> 1.3.2' if RUBY_VERSION < '2.0'
end
