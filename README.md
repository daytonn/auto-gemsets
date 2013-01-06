auto-gemsets
==============

Tired of typing `rbenv-rehash`, `rvm gemset use`, and `rvm gemset create` for every project? `auto-gemsets` is for you.

Any `Gemfile` you encounter will cause auto-gemsets to automatically create and switch to a gemset based on the Gemfile's parent folder. Given a `Gemfile` in a directory named `my-project`, auto-gemsets will create a `~/.gemsets/my-project` directory (if one does not exist), and set all the GEM environment variables appropriate to that gemset. This means that you can enjoy sandboxed gem environments without having to micro-manage your GEM environment.

## Installation

### Using RubyGems:

    gem install auto-gemsets
    gemset init

### Configuration:

The `gemset init` command will create a copy of `auto-gemsets.sh` into `/usr/local/share/auto-gemsets` To use auto-gemsets, you will need to source this file in your `~/.bashrc` (`~/.bash_profile` on OSX) or `~/.zshrc` file.

    source /usr/local/share/auto-gemsets/auto-gemsets.sh

That's it, reload your `.bashrc` (`source ~/.bashrc`) or open a new terminal and auto-gemsets will now be managing your ruby gems environment.

NOTE: If you've already installed `auto-gemsets` you will receive a warning asking you if you wish to overwrite this installation. You may want to do this after updating your `auto-gemsets` version

### Default Gemset:

A default gemset will be created for you based on your username. Given a username of `daytonn` on an OS X machine, the default gemset path would be `/Users/daytonn/.gemsets/daytonn`. If you wish to override this setting simply set the `DEFAULT_GEMSET` variable somewhere in your `.bashrc`, `.bash_profile`, or `.zshrc` depending on your environment:

    # auto-gemsets
    export DEFAULT_GEMSET="/custom/path/to/default_gemset"

auto-gemsets will add this gemset to your `GEM_PATH` and add it's bin directory to your `PATH`. This gemset will always be active. When another gemset is also active, installed gems will automatically belong to that gemset. When _ONLY_ the default gemset is active, installed gems will belong to the default gemset.

## Command Line

Although auto-gemsets focuses on automatic management of your gemsets, there are times when interaction is necessary. For these occaisions, auto-gemsets comes with a command line application named `gemset`.

See the [HELP](https://github.com/daytonn/auto-gemsets/blob/master/HELP.md) file for `gemset`'s Documentation.

## default-gems
The defalt-gemset command is an auto-gems utility to manage gems
in the default* gemset from within other gemsets.

### Usage:

    default-gems (command) [options]

### Examples:

    default-gems install rake
    default-gems uninstall rake -v=10.0.1
    default-gems list --local

`default-gems` accepts any valid `gem` command, with any valid arguments and options.
It is simply a pass-through to the `gem` command with the context of the default gemset.