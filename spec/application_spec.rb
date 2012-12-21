require 'auto-gemsets/application'
require 'securerandom'

describe AutoGemsets::Application do

  before do
    @output = StringIO.new
    @input = StringIO.new
    @app = AutoGemsets::Application.new @output, @input
    @gemset = SecureRandom::hex
    @random_gemset = File.join(ENV['HOME'], '.gemsets', @gemset)
    FileUtils.mkdir_p(@random_gemset)
  end

  after do
    FileUtils.rm_rf(@random_gemset) if File.exists? @random_gemset
  end

  describe 'current' do
    before do
      @env_gemset = ENV['GEMSET']
      ENV['GEMSET'] = @gemset
    end

    after do
      ENV['GEMSET'] = @env_gemset
    end

    it "shows the current gemset" do
      @output.should_receive(:puts).with("-> #{@gemset}")
      @app.current
    end

    it "shows the current gemset when called with no arguments" do
      @output.should_receive(:puts).with("-> #{@gemset}")
      app = AutoGemsets::Application.new(@output, @input, [])
      app.run
    end
  end

  describe "list" do
    it "can list all gemsets in the GEMSET_ROOT" do
      @output.should_receive(:puts) { |list| expect(list).to match(/#{@gemset}/) }
      @app.list
    end

    it "puts a star on the default gemset" do
      ENV['DEFAULT_GEMSET'] = @gemset
      @output.should_receive(:puts) { |list| expect(list).to match(/#{@gemset}\*/) }
      @app.list
    end

    it "puts an arrow on the current gemset" do
      ENV['GEMSET'] = @gemset
      @output.should_receive(:puts) { |list| expect(list).to match(/-> #{@gemset}/) }
      @app.list
    end
  end

  describe 'remove' do
    it "confirms the rm command and does nothing if the user enters anything but y" do
      @output.should_receive(:puts).once.with("Are you sure you wish to delete the #{@gemset} gemset? y/n")
      @output.should_receive(:puts).once.with("No gemsets were harmed.")
      @input.stub!(:gets) { "n" }
      @app.remove @gemset
      expect(File.exists?(@random_gemset)).to be_true
    end

    it "removes the gemset if the user enters y" do
      @output.should_receive(:puts).once.with("Are you sure you wish to delete the #{@gemset} gemset? y/n")
      @output.should_receive(:puts).once.with("#{@gemset} gemset removed!")
      @input.stub!(:gets) { "y" }
      @app.remove @gemset
      expect(File.exists?(@random_gemset)).to be_false
    end
  end

  describe 'create' do
    before do
      @name = SecureRandom::hex
      @expected_path = File.join(ENV['HOME'], '.gemsets', @name)
    end

    after do
      FileUtils.rm_rf(@expected_path) if File.exists? @expected_path
    end

    it "creates a gemset" do
      @output.should_receive(:puts).once.with("#{@name} gemset created")
      @app.create(@name)
      expect(File.exists?(@expected_path)).to be_true
    end
  end

  describe 'rename' do
    before do
      @name_a = SecureRandom::hex
      @name_b = SecureRandom::hex
      @gemset_a = File.join(ENV['HOME'], '.gemsets', @name_a)
      @gemset_b = File.join(ENV['HOME'], '.gemsets', @name_b)

      FileUtils.mkdir_p(@gemset_a)
      FileUtils.mkdir_p(@gemset_b)
    end

    after do
      FileUtils.rm_rf(@gemset_a) if File.exists? @gemset_a
      FileUtils.rm_rf(@gemset_b) if File.exists? @gemset_b
      FileUtils.rm_rf(@new_gemset) if @new_gemset && File.exists?(@new_gemset)
    end

    it "moves a gemset to a new location" do
      new_name = SecureRandom::hex
      @new_gemset = File.join(ENV['HOME'], '.gemsets', new_name)

      @output.should_receive(:puts).once.with("#{@name_a} renamed to #{new_name}")
      @app.rename(@name_a, "#{new_name}")
      expect(File.exists?(@new_gemset)).to be_true
      expect(File.exists?(@gemset_a)).to be_false
    end

    it "it asks for permission to remove an existing destination" do
      @output.should_receive(:puts).once.with("#{@name_b} already exists!")
      @output.should_receive(:puts).once.with("Do you really wish to replace #{@name_b} with #{@name_a}? y/n")
      @output.should_receive(:puts).once.with("#{@name_a} renamed to #{@name_b}")
      @input.stub!(:gets) { "y" }
      @app.rename(@name_a, @name_b)
      expect(File.exists?(@gemset_a)).to be_false
    end

  end

end