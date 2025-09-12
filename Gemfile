source 'https://rubygems.org'

# Ruby version
ruby '>= 3.0.0'

# Ruby 3.4+ compatibility gems
gem 'abbrev'
gem 'logger'
gem 'ostruct'
gem 'base64'

# CI/CD and testing
gem 'fastlane', '~> 2.228.0'
gem 'xcov'
gem 'cocoapods'

# Development tools
gem 'pry'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
