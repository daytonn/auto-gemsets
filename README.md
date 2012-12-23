auto-gemsets
==============

Tired of typing `rbenv-rehash`, `rvm gemset use`, and `rvm gemset create` for every project? `auto-gemsets` is for you.

Any `Gemfile` you encounter will cause auto-gemsets to automatically create and switch to a gemset based on the Gemfile's parent folder. Given a `Gemfile` in a directory named `my-project`, auto-gemsets will create a `~/.gemsets/my-project` directory (if one does not exist), and set all the GEM environment variables appropriate to that gemset. This means that you can enjoy sandboxed gem environments without having to micro-manage your GEM environment.

## Installation

### Using RubyGems:

    gem install auto-gemsets
    gemset init

### Configuration:

The `gemset init` command will create a copy of `auto_gemsets.sh` into `/usr/local/share/auto_gemsets` To use auto-gemsets, you will need to source this file in your `~/.bashrc` (`~/.bash_profile` on OSX) or `~/.zshrc` file.

    source /usr/local/share/auto_gemsets/auto_gemsets.sh

That's it, reload your `.bashrc` (`source ~/.bashrc`) or open a new terminal and auto-gemsets will now be managing your ruby gems environment.

NOTE: If you've already installed `auto-gemsets` you will receive a warning asking you if you wish to overwrite this installation. You may want to do this after updating your `auto-gemsets` version

### Default Gemset:

If you wish to have certain gems available globally no matter what project you're in, you may set a `DEFAULT_GEMSET` variable that points to a gemset directory that will be available no matter what specific project gemset is currently in use. To set a default gemset simply add the `DEFAULT_GEMSET` variable in your `.bashrc` or `.zshrc` file (it must be a valid path):

    # auto-gemsets
    export DEFAULT_GEMSET="$HOME/.gemsets/$USER"

auto-gemsets will add this gemset to your `GEM_PATH` and add it's bin directory to your `PATH`. This gemset will always be active. When another gemset is also active, installed gems will automatically belong to that gemset. When _ONLY_ the default gemset is active, installed gems will belong to the default gemset.

## Command Line

Although auto-gemsets focuses on automatic management of your gemsets, there are times when interaction is necessary. For these occaisions, auto-gemsets comes with a command line application named `gemset`.

See the [HELP](https://github.com/daytonn/auto-gemsets/blob/master/HELP.md) file for `gemset`'s Documentation.

## default-gemset
The defalt-gemset command is an auto-gems utility to manage gems
in the default* gemset from within other gemsets.

### Usage:

    default-gemset (command) [options]

### Examples:

    default-gemset install rake
    default-gemset uninstall rake -v=10.0.1
    default-gemset list --local

`default-gemset` accepts any valid `gem` command, with any valid arguments and options.
It is simply a pass-through to the `gem` command with the context of the default gemset.