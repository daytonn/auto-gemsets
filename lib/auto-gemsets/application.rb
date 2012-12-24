require 'optparse'
require 'fileutils'

module AutoGemsets

  class << self

    def application
      @application ||= AutoGemsets::Application.new
    end

  end

  class Application

    attr_reader :args,
                :command,
                :options

    def initialize(output = $stdout, input = $stdin, args = Array.try_convert(ARGV))
      @output = output
      @input = input
      @args = args
      @command = @args.empty? ? :current : @args.shift.to_sym unless @args.first =~ /^-/
      parse_options
    end

    def current
      gemset = "-> #{ENV['GEMSET']}";
      gemset = "#{gemset}*" if ENV['GEMSET'] == default_gemset
      @output.puts gemset
    end

    def run
      self.send @command, *@args
    end

    def ls
      gemsets = Dir.glob(File.join(ENV['HOME'], '.gemsets', '*')).map { |d| display_gemset d }
      @output.puts gemsets.join "\n"
    end

    def list
      ls
    end

    def touch(gemset)
      if !File.exists?(gemset_path(gemset)) && FileUtils.mkdir_p(gemset_path(gemset))
        @output.puts "#{gemset} gemset created"
      end
    end

    def create(gemset)
      touch(gemset)
    end

    def mv(gemset, new_gemset)
      if !File.exists?(gemset_path(new_gemset)) && FileUtils.mv(gemset_path(gemset), gemset_path(new_gemset))
        @output.puts "#{gemset} renamed to #{new_gemset}"
      else
        @output.puts "#{new_gemset} already exists!"
        confirm("Do you really wish to replace #{new_gemset} with #{gemset}?", {
          accept: -> {
            if FileUtils.rm_rf(gemset_path(new_gemset)) && FileUtils.mv(gemset_path(gemset), gemset_path(new_gemset))
              @output.puts "#{gemset} renamed to #{new_gemset}"
            end
          },
          deny: -> {
            @output.puts "No gemsets were harmed."
          }
        })
      end
    end

    def rename(gemset, new_gemset)
      mv(gemset, new_gemset)
    end

    def rm(gemset)
      confirm("Are you sure you wish to delete the #{gemset} gemset?", {
        accept: -> {
          if File.exists?(gemset_path(gemset)) && FileUtils.rm_rf(gemset_path(gemset))
            @output.puts "#{gemset} gemset removed!"
          end
        },
        deny: -> {
          @output.puts "No gemsets were harmed."
        }
      })
    end

    def remove(gemset)
      rm(gemset)
    end

    def open(gemset = nil)
      command = case
      when AutoGemsets::on_OSX?
        'open'
      when AutoGemsets::on_linux?
        'xdg-open'
      when AutoGemsets::on_windows?
        'explorer'
      end

      if gemset
        %x{#{command} #{gemset_path(gemset)}} if File.exists?(gemset_path(gemset))
        @output.puts "No gemset named #{gemset}!" unless File.exists?(gemset_path(gemset))
      else
        %x{#{command} #{AutoGemsets::GEMSET_ROOT}}
      end
    end

    def edit
      raise "You must set $EDITOR or $TERM_EDITOR to edit Gemfiles" unless ENV['EDITOR'] || ENV['TERM_EDITOR']
      %x{#{ENV['EDITOR'] || ENV['TERM_EDITOR']} #{ENV['GEMFILE']}} if File.exists ENV['GEMFILE']
    end

    def init
      if File.exists? script_file
        @output.puts "auto-gemsets is already installed!"
        confirm("Do you wish overwrite this installation?", {
          accept: -> {
            create_script
          },
          deny: -> {
            @output.puts "Existing installation preserved."
          }
        })
      else
        create_script
      end
    end

    private
      def parse_options
        @options = {}
        OptionParser.new do |opts|
          opts.on("-v", "--version", "Version info") do
            @options[:version] = true
            @command = :version
          end

          opts.on('-h', '--help', 'Display help') do
            @options[:help] = true
            @command = :help
          end
        end.parse!

        @args.reject! { |a| a =~ /^-/ }
      end

      def help
        @output.puts AutoGemsets::HELP
      end

      def version
        @output.puts "auto-gemsets #{AutoGemsets::VERSION}"
      end

      def gemset_path(gemset)
        File.join(AutoGemsets::GEMSET_ROOT, gemset)
      end

      def default_gemset
        File.basename(ENV['DEFAULT_GEMSET'])
      end

      def display_gemset(gemset_dir)
        case gemset = File.basename(gemset_dir)
        when default_gemset
          gemset = "   #{gemset}*"
        when ENV['GEMSET']
          gemset = "-> #{gemset}"
        else
          gemset = "   #{gemset}"
        end
        gemset
      end

      def confirm(question, callbacks = {})
        settings = {
          accept: -> { nil },
          deny: -> { nil }
        }.merge! callbacks

        @output.puts "#{question} y/n"
        @input.gets =~ /^y/i ? settings[:accept].call : settings[:deny].call
      end

      def script_file
        File.join(AutoGemsets::INSTALL_ROOT, "auto_gemsets.sh")
      end

      def create_script
        FileUtils.mkdir_p(AutoGemsets::INSTALL_ROOT) unless File.exists? AutoGemsets::INSTALL_ROOT
        FileUtils.cp(File.join(AutoGemsets::ROOT, 'lib', 'auto-gemsets', 'auto_gemsets.sh'), AutoGemsets::INSTALL_ROOT)
        FileUtils.chmod("a+x", File.join(AutoGemsets::INSTALL_ROOT, File.basename(script_file)))
      end
  end

end