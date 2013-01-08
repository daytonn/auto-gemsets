# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "auto-gemsets"
  gem.homepage = "http://github.com/daytonn/auto-gemsets"
  gem.license = "Apache 2.0"
  gem.summary = %Q{Automatic, shimless, gemsets. For use with your ruby-version manager of choice.}
  gem.description = %Q{auto-gemsets creates a gemset named after the parent directory of every Gemfile you encounter. This let's you automatically scope your gems without using shims or creating gemsets. }
  gem.email = "dnolan@gmail.com"
  gem.authors = ["Dayton Nolan"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "auto-gemsets #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


namespace :test do
  task :sh do
    puts %x{sh test/runner}
  end

  task :all do
    Rake::Task["spec"].invoke
    Rake::Task["test:sh"].invoke
  end
end