require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AutoGemsets do

  before do
    @root = File.expand_path('../', SPEC_ROOT)
  end

  it "has a ROOT directory" do
    expect(AutoGemsets::ROOT).to eq(@root)
  end

  it "has a GEMSET_ROOT" do
    expect(AutoGemsets::GEMSET_ROOT).to eq(File.join(ENV['HOME'], '.gemsets'))
  end

  it "has a VERSION" do
    expect(AutoGemsets::VERSION).to match(/\d+\.\d+\.\d+/)
  end

  it "has a HELP file" do
    expect(AutoGemsets::HELP).not_to be_empty
  end

  it "can tell if it's running on osx" do
    expect(AutoGemsets::on_osx?).to eq(RUBY_PLATFORM[/darwin/] != nil)
  end

  it "can tell if it's running on windows" do
    expect(AutoGemsets::on_windows?).to eq(RUBY_PLATFORM[/cygwin|mswin|mingw|bccwin|wince|emx/] == true)
  end

  it "can tell if it's running on linux" do
    expect(AutoGemsets::on_linux?).to eq(
      RUBY_PLATFORM[/cygwin|mswin|mingw|bccwin|wince|emx/] == nil &&
      RUBY_PLATFORM[/darwin/] == nil
    )
  end

  it "can tell if it's running on unix" do
    expect(AutoGemsets::on_unix?).to eq(RUBY_PLATFORM[/cygwin|mswin|mingw|bccwin|wince|emx/] == nil)
  end

end
