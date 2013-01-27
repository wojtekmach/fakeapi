#!/usr/bin/env rake
require "bundler/gem_tasks"

task :test do
  system 'rspec spec/'
end

task :examples do
  system "sh -c 'cd examples/fake_bitly ; bundle exec rspec spec/ ; cd ../..'"
end

task :default => :test
