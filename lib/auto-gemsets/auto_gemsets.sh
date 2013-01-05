AG_SILENT="off"

ag_silent() {
  if [ -n "$1" ] && [ "$1" == "on" ]; then
    AG_SILENT="on"
  else
    AG_SILENT="off"
  fi

}

ag_set_default_gemset() {
  if [ -n "${DEFAULT_GEMSET}" ]; then
    if [ ! "$GEM_PATH" == "${DEFAULT_GEMSET}" ]; then
      DEFAULT=$( basename $DEFAULT_GEMSET )
    fi

    if [ -n "$GEMSET" ] && [ ! "$GEMSET" == "$DEFAULT" ]; then
      ag_remove_path "${GEMSET_ROOT}/${GEMSET}/bin"
    fi

    DEFAULT_BIN_PATH="${DEFAULT_GEMSET}/bin"

    export GEMSET="${DEFAULT}"
    export GEM_HOME="$DEFAULT_GEMSET"
    export GEMFILE="$DEFAULT_GEMSET"
    export GEM_ROOT="$GEM_HOME"
    export GEM_PATH="$GEM_HOME"

    ag_add_path "$DEFAULT_BIN_PATH"
    ag_using_gemset_via "*default"
  else
    export DEFAULT_GEMSET="$HOME/.gemsets/$USER"
    ag_set_default_gemset
  fi
}

ag_using_gemset_via() {
  if [ "$AG_SILENT" == "off" ]; then
    echo "Now using $GEMSET gemset via $1"
  fi
}

ag_remove_path() {
  NEW_PATH=""
  IFS=':' read -a PATHS <<< "$PATH"
  for p in "${PATHS[@]}"
  do
    if [ ! "$p" == "$1" ]; then
      if [ -z "$NEW_PATH" ]; then
        NEW_PATH="$p"
      else
        NEW_PATH="$NEW_PATH:$p"
      fi
    fi
  done
  export PATH="$NEW_PATH"
}

ag_add_path () {
  if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
     if [ "$2" = "after" ] ; then
        PATH=$PATH:$1
     else
        PATH=$1:$PATH
     fi

     export PATH
  fi
}

auto_gemsets() {
  local dir="$PWD"

  until [[ -z "$dir" ]]; do
    GEMFILE="$dir/Gemfile"
    ag_get_parent_dirname

    if [ "$GEMSET" == "$PARENT_DIR" ]; then
      break
    fi

    if [ -f "$GEMFILE" ]; then
      ag_set_gemset "$PARENT_DIR"
      break
    fi

    if [ -z "${dir%/*}" ] && [ ! "$GEMSET" == $( basename $DEFAULT_GEMSET ) ]; then
      ag_set_default_gemset
      break
    fi

    dir="${dir%/*}"
  done
}

ag_get_parent_dirname() {
  if [ ! -z "$GEMFILE" ]; then
    IFS='/' read -a gemfile_path_parts <<< "$GEMFILE"
    PARENT_DIR="${gemfile_path_parts[${#gemfile_path_parts[@]}-2]}"
  fi
}

ag_set_gemset() {
  NEW_GEMSET="$1"
  NEW_GEMSET_PATH="${GEMSET_ROOT}/${1}"
  NEW_GEMSET_BIN_PATH="${NEW_GEMSET_PATH}/bin"
  ag_remove_path "$GEMSET_BIN_PATH"
  ag_create_gemset_if_missing "$NEW_GEMSET"
  export GEMSET="$NEW_GEMSET"
  export GEM_HOME="$NEW_GEMSET_PATH"
  export GEM_ROOT="$NEW_GEMSET_PATH"
  export GEM_PATH="$NEW_GEMSET_PATH:$DEFAULT_GEMSET"

  ag_add_path "$DEFAULT_BIN_PATH"
  ag_add_path "$NEW_GEMSET_BIN_PATH"

  ag_using_gemset_via "$GEMFILE"
}

ag_create_gemset_if_missing() {
  if [ ! -d "${GEMSET_ROOT}/${1}" ]; then
    mkdir -p "${GEMSET_ROOT}/${1}" && echo "${1} created. run gem install bundler"
  fi
}

default-gems() {
  if [ -n "$1" ]; then
    ag_silent "on"
    G="$GEMSET"
    ag_set_default_gemset
    gem "$@"
    ag_set_gemset "$G"
    ag_silent "off"
  else
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

`default-gems` accepts any valid `gem` command, with any valid arguments and options.
It is simply a pass-through to the `gem` command with the context of the default gemset.
EOF

  fi
}

# Create a GEMSET_ROOT if none is set
if [ ! -n "$GEMSET_ROOT" ]; then
  export GEMSET_ROOT="${HOME}/.gemsets"
fi

# If ZSH add precommand
if [[ -n "$ZSH_VERSION" ]]; then
  precmd_functions+=("auto_gemsets")
else
  # If there's already a prompt command,
  if [ -n "$PROMPT_COMMAND" ]; then
    # check if it's already in the PROMPT
    if [ -z "$(echo $PROMPT_COMMAND | grep auto_gemsets)" ] ; then
      PROMPT_COMMAND="$PROMPT_COMMAND; auto_gemsets"
    fi
  else
    PROMPT_COMMAND="auto_gemsets"
  fi
fi