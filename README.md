auto-gemsets
==============

Tired of typing `rbenv-rehash`, `rvm gemset use`, and `rvm gemset create` for every project? `auto-gemsets` is for you.

Any `Gemfile` you encounter will cause auto-gemsets to automatically create and switch to a gemset based on the Gemfile's parent folder. Given a `Gemfile` in a directory named `my-project`, auto-gemsets will create a `~/.gemsets/my-project` directory (if one does not exist), and set all the GEM environment variables appropriate to that gemset. This means that you can enjoy sandboxed gem environments without having to micro-manage your GEM environment.

## Installation

### Using RubyGems:

    gem install auto-gemsets
    gemset init

### Configuration:

The `gemset init` command will create a copy of `auto-gemsets.sh` and `default-gems.sh` into `/usr/local/share/auto-gemsets` To use auto-gemsets, you will need to source these files in your `~/.bashrc` (`~/.bash_profile` on OSX) or `~/.zshrc` file.

    source /usr/local/share/auto-gemsets/auto-gemsets.sh
    source /usr/local/share/auto-gemsets/default-gems.sh
    
In addition to these two scripts, `init` also creates a `~/.auto-gemsets` config file to allow for customization of `auto-gemsets`. Currently this file contains only one setting which determines whether or not auto-gemsets reports when it switches gemsets. You can turn reporting on and off by setting the `AUTO_GEMSETS_REPORTING` variable `on` or `off`

    export AUTO_GEMSETS_REPORTING=on
    export AUTO_GEMSETS_REPORTING=off
    
Once you source `.bashrc`, `.bash_profile`, or `~/.zshrc` (`source ~/.bashrc`) or open a new terminal auto-gemsets will now be active and managing your ruby gems.

Since, `auto-gemsets` creates a new default gemset, you will need to reinstall `auto-gemsets` to use the `gemset` command.

    gem install auto-gemsets

A NOTE ON UPGRADING: If you've already installed `auto-gemsets` you will receive a warning asking you if you wish to overwrite this installation. You may want to do this after updating your `auto-gemsets` version

### Default Gemset:

A default gemset will be created for you when you run `gemset init` in `~/.gemsets/default`.

If you wish to override this location simply set the `DEFAULT_GEMSET` variable somewhere in your `.bashrc`, `.bash_profile`, or `.zshrc` depending on your environment:

    # auto-gemsets
    export DEFAULT_GEMSET="/custom/path/to/default_gemset"

auto-gemsets will add this gemset to your `GEM_PATH` and add it's bin directory to your `PATH`. This gemset will always be active. When another gemset is also active, installed gems will automatically belong to that gemset. When _ONLY_ the `default` gemset is active, installed gems will belong to the `default` gemset.

## Command Line

Although auto-gemsets focuses on automatic management of your gemsets, there are times when interaction is necessary. For these occaisions, auto-gemsets comes with a command line application named `gemset`.

See the [HELP](https://github.com/daytonn/auto-gemsets/blob/master/HELP.md) file for `gemset`'s Documentation.

There is also a utility that allows you to isolate your `default` gemset when running gem commands named `default-gems`

For more documentation simply type

    default-gems

## default-gems
The defalt-gems command is an auto-gemsets utility to manage gems
in the default* gemset from within other gemsets.

Usage:
------

  default-gems (command) [options]

Examples:
---------

  default-gems install mygem
  default-gems uninstall mygem
  default-gems list

default-gems accepts any valid gem command, with any valid arguments and options.
It is simply a pass-through to the gem command with the context of the default gemset.
