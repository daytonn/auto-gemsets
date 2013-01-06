ag_init() {
  export GEMSET_ROOT="$HOME/.gemsets"

  if [ -z "${DEFAULT_GEMSET}" ]; then
    export DEFAULT_GEMSET="default"
  fi

  if [ -r "${HOME}/.auto-gemsets" ]; then
    source "${HOME}/.auto-gemsets"
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
}

ag_set_gemset() {
  if [ "$GEMSET" == "$1" ]; then
    return;
  fi
  export GEMSET="${1}"
  export GEM_HOME="${GEMSET_ROOT}/$GEMSET"
  export GEM_ROOT="$GEM_HOME" # for chruby
  export GEM_PATH="$GEM_HOME"
  ag_add_path "${GEM_HOME}/bin"

  if [ ! "$GEMSET" == 'default' ]; then
    ag_add_path "${GEMSET_ROOT}/default/bin"
    export GEM_PATH="${GEM_PATH}:${GEMSET_ROOT}/default"
    ag_using_gemset_via "$GEMFILE"
  else
    ag_using_gemset_via "*default"
  fi

}

ag_remove_path() {
  CLEAN_PATH=""
  IFS=':' read -a PATHS <<< "$PATH"
  # Rip through paths and build a new path without the directory
  for p in "${PATHS[@]}"
  do
    if [ ! "$p" == "$1" ]; then
      # first time through, set CLEAN_PATH
      if [ -z "$CLEAN_PATH" ]; then
        CLEAN_PATH="$p"
      else
      # append the path
        CLEAN_PATH="$CLEAN_PATH:$p"
      fi
    fi
  done
  export PATH="$CLEAN_PATH"
}

ag_using_gemset_via() {
  if [ "$AUTO_GEMSETS_REPORTING" == "on" ]; then
    echo "Now using $GEMSET gemset via $1"
  fi
}

ag_add_path() {
  if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
     export PATH="$1:$PATH"
  fi
}

ag_parent_dir() {
  if [ ! -z "$1" ]; then
    IFS='/' read -a path_parts <<< "$1"
    echo "${path_parts[${#path_parts[@]}-2]}"
  else
    echo ""
  fi
}

auto_gemsets() {
  local dir="$PWD"

  until [[ -z "$dir" ]]; do
    if [ "$GEMSET" ] && [ "$GEMSET" == "$(ag_parent_dir ${dir}/Gemfile)" ]; then
      return;
    fi

    if [ -f "$dir/Gemfile" ]; then
      export GEMFILE="$dir/Gemfile"
      ag_create_gemset_if_missing "$(ag_parent_dir $GEMFILE)"
      ag_set_gemset "$(ag_parent_dir $GEMFILE)"
      return;
    fi

    if [ -z "${dir%/*}" ]; then
      ag_set_gemset 'default'
    fi

    dir="${dir%/*}"
  done
}

ag_create_gemset_if_missing() {
  if [ ! -d "${GEMSET_ROOT}/${1}" ]; then
    mkdir -p "${GEMSET_ROOT}/${1}" && echo "${1} gemset created. run gem install bundler"
  fi
}

# Kick it
ag_init