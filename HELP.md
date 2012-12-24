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

Commands:
========

init
----
This command will copy the auto_gemsets.sh script into the `/usr/local/share/auto_gemsets` folder. This is the small shell script that does the automatic switching for you. Once this file is in place, simply `source` it somewhere in your profile and auto-gemsets will be activated.

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

edit
----
    gemset edit (gemset)

Opens the gemset's Gemfile in your default `EDITOR` or `TERM_EDITOR`