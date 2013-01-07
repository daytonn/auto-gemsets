When the gemset command is called with no arguments,
it simply displays the current gemset in use.
Note that the GEM environment includes both
the current and default gemset's gems.

    gemset -h/--help
    gemset -v/--version
    gemset [command] [arguments...]

Examples:
---------
    gemset list
    gemset remove mygemset
    gemset create mygemset
    gemset rename mygemset awesome-gemset
    gemset edit mygemset
    gemset help
    gemset version
    gemset open

Commands:
========

init
----
This command will copy the `auto-gemsets.sh`, and `default-gems.sh` scripts into the `/usr/local/share/auto-gemsets` folder. This is the small shell script that does the automatic switching for you and a utility for running gem commands in the context of the default gemset. Once these files are in place, simply `source` them somewhere in your profile and auto-gemsets will be activated. In addition to these scripts, a configuration file is created in `~/.auto-gemsets` that contains a simple setting to control gemset switch reproting.

ls, list
--------
    gemset ls
    gemset list

List all gemsets in your `GEMSET_ROOT`.
The gemset with the -> at the begining is the current gemset.
The gemset with the * at the end is the default gemset.
Note that the GEM environment includes both the current and default gemset's gems.

rm, remove
----------
    gemset rm (gemset)
    gemset remove (gemset)

Removes the given gemset from the `GEMSET_ROOT`.
To prevent unwanted deletions, a confirmation dialog will ask if you wish to continue.

touch, create
-------------
    gemset touch (gemset)
    gemset create (gemset)

Create a new gemset in the `GEMSET_ROOT` with the given name

mv, rename
----------
    gemset mv (gemset) (name)
    gemset rename (gemset) (name)

Renames the given gemset with the given name within the `GEMSET_ROOT`.
If the new gemset name conflicts with an existing gemset,
a confirmation dialog will ask if you wish to continue

open
----
    gemset open [gemset]

Opens the gemset directory in your file manager

version
-------

Displays the installed version of `auto-gemsets`

help
----

Displays this menu