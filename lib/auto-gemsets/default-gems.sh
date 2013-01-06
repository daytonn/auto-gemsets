function default-gems() {
  if [ -z "$1" ]; then
    cat <<EOF
The defalt-gems command is an auto-gems utility to manage gems
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
EOF
  else
    if [ ! "$GEMSET" == 'default' ]; then
      G="$GEMSET"
      ag_set_gemset 'default' > /dev/null
      gem "$@"
      ag_set_gemset "$G" > /dev/null
    else
      gem "$@"
    fi
  fi
}