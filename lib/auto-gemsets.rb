module AutoGemsets
  ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  GEMSET_ROOT = ENV['GEMSET_ROOT'] || File.join(ENV['HOME'], '.gemsets')
  VERSION = File.read "#{ROOT}/VERSION"
  HELP = File.read "#{ROOT}/HELP"

  def self.on_windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def self.on_osx?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def self.on_unix?
    !on_windows?
  end

  def self.on_linux?
    on_unix? and not on_osx?
  end
end

require "auto-gemsets/application"