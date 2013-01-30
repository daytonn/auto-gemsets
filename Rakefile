# encoding: utf-8
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/packagetask'
require 'jeweler'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'auto-gemsets'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "auto-gemsets #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Jeweler::Tasks.new do |gem|
  gem.name = "auto-gemsets"
  gem.homepage = "http://github.com/daytonn/auto-gemsets"
  gem.license = "Apache 2.0"
  gem.summary = %Q{Automatic, shimless, gemsets. For use with your ruby-version manager of choice.}
  gem.description = %Q{auto-gemsets creates a gemset named after the parent directory of every Gemfile you encounter. This let's you automatically scope your gems without using shims or creating gemsets. }
  gem.email = "dnolan@gmail.com"
  gem.authors = ["Dayton Nolan"]
end

Jeweler::RubygemsDotOrgTasks.new

namespace :test do
  task :sh do
    puts %x{sh test/runner}
  end

  task :all do
    Rake::Task["spec"].invoke
    Rake::Task["test:sh"].invoke
  end
end

Rake::PackageTask.new("auto-gemsets", AutoGemsets::VERSION) do |p|
  app_files = Dir.glob('**/*').reject { |d| d =~ /^(test|spec|Gemfile|pkg|Rakefile)/ }
  p.need_tar = true
  p.package_files = app_files
end

task :clean do
  pkg_dir = File.join(File.dirname(__FILE__), "pkg")
  FileUtils.rm_rf pkg_dir if File.exists? pkg_dir
end

task :build do
  Rake::Task["clean"].invoke
  Rake::Task["package"].invoke
end