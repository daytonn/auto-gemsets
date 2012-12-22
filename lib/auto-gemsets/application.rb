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
      @command = @args.shift.to_sym unless @args.empty? || @args.first =~ /^-/

      parse_options
    end

    def current
      gemset = "-> #{ENV['GEMSET']}";
      gemset = "#{gemset}*" if ENV['GEMSET'] == default_gemset
      @output.puts gemset
    end

    def run
      if @command
        self.send @command, *@args
      else
        if options[:help]
          help
        elsif options[:version]
          version
        else
          self.send(:current)
        end
      end
    end

    def ls
      gemsets = Dir.glob(File.join(ENV['HOME'], '.gemsets', '*')).map do |d|
        gemset = File.basename(d)
        case gemset
        when default_gemset
          gemset = "   #{gemset}*"
        when ENV['GEMSET']
          gemset = "-> #{gemset}"
        else
          gemset = "   #{gemset}"
        end
        gemset
      end

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
      if !File.exists?(gemset_path(new_gemset))
        if FileUtils.mv(gemset_path(gemset), gemset_path(new_gemset))
          @output.puts "#{gemset} renamed to #{new_gemset}"
        end
      else
        @output.puts "#{new_gemset} already exists!"
        @output.puts "Do you really wish to replace #{new_gemset} with #{gemset}? y/n"

        confirmation = @input.gets.chomp
        if confirmation =~ /^y/i
          FileUtils.rm_rf(gemset_path(new_gemset))
          if FileUtils.mv(gemset_path(gemset), gemset_path(new_gemset))
            @output.puts "#{gemset} renamed to #{new_gemset}"
          end
        else
          @output.puts "No gemsets were harmed."
        end
      end
    end

    def rename(gemset, new_gemset)
      mv(gemset, new_gemset)
    end

    def rm(gemset)
      @output.puts "Are you sure you wish to delete the #{gemset} gemset? y/n"
      confirmation = @input.gets.chomp
      if confirmation =~ /^y/i
        if File.exists?(gemset_path(gemset)) && FileUtils.rm_rf(gemset_path(gemset))
          @output.puts "#{gemset} gemset removed!"
        end
      else
        @output.puts "No gemsets were harmed."
      end
    end

    def remove(gemset)
      rm(gemset)
    end

    def open(gemset=nil)
      if AutoGemsets::on_OSX?
        if gemset
          if File.exists?(gemset_path(gemset))
            %x{open #{gemset_path(gemset)}}
          else
            @output.puts "No gemset named #{gemset}!"
          end
        else
          %x{open #{AutoGemsets::GEMSET_ROOT}}
        end
      else
        @output.puts "currently this command is only available for OS X users"
      end
    end

    def edit
      raise "You must set $EDITOR or $TERM_EDITOR to edit Gemfiles" unless ENV['EDITOR'] || ENV['TERM_EDITOR']
      %x{#{ENV['EDITOR'] || ENV['TERM_EDITOR']} #{ENV['GEMFILE']}} if File.exists ENV['GEMFILE']
    end

    def install
      FileUtils.mkdir_p(AutoGemsets::INSTALL_ROOT) unless File.exists? AutoGemsets::INSTALL_ROOT
      script_file = File.join(AutoGemsets::ROOT, 'lib', 'auto-gemsets', 'auto_gemsets.sh')
      FileUtils.cp(script_file, AutoGemsets::INSTALL_ROOT)
      FileUtils.chmod("a+x", "#{AutoGemsets::INSTALL_ROOT}/auto_gemsets.sh")
    end

    private
      def parse_options
        @options = {}
        OptionParser.new do |opts|
          opts.on("-v", "--version", "Version info") do
            @options[:version] = true
          end

          opts.on('-h', '--help', 'Display help') do
            @options[:help] = true
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
  end

end