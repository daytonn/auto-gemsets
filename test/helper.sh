#!/bin/sh

OLD_GEM_HOME=$GEM_HOME
OLD_GEM_PATH=$GEM_PATH
OLD_GEM_ROOT=$GEM_ROOT
OLD_GEMSET=$GEMSET
OLD_DEFAULT_GEMSET=$DEFAULT_GEMSET
OLD_GEMFILE=$GEMFILE
OLD_PATH=$PATH
OLD_PROMPT_COMMAND=$PROMPT_COMMAND
OLD_AUTO_GEMSETS_REPORTING=$AUTO_GEMSETS_REPORTING

clear_env() {
  unset GEM_HOME
  unset GEM_PATH
  unset GEM_ROOT
  unset GEMSET
  unset DEFAULT_GEMSET
  unset GEMFILE
  unset PROMPT_COMMAND
  unset AUTO_GEMSETS_REPORTING
  mv "/usr/local/share/auto-gemsets" "/usr/local/share/auto-gemsets.bak"

  if [ -f "${HOME}/.auto-gemsets" ]; then
    mv "${HOME}/.auto-gemsets" "${HOME}/.auto-gemsets.bak"
  fi
}

reset_env() {
  rm -Rf "/usr/local/share/auto-gemsets"
  mv "/usr/local/share/auto-gemsets.bak" "/usr/local/share/auto-gemsets"
  if [ -f "${HOME}/.auto-gemsets.bak" ]; then
    mv "${HOME}/.auto-gemsets.bak" "${HOME}/.auto-gemsets"
  fi
  export GEM_HOME=$OLD_GEM_HOME
  export GEM_PATH=$OLD_GEM_PATH
  export GEM_ROOT=$OLD_GEM_ROOT
  export GEMSET=$OLD_GEMSET
  export DEFAULT_GEMSET=$OLD_DEFAULT_GEMSET
  export GEMFILE=$OLD_GEMFILE
  export PATH=$OLD_PATH
  export PROMPT_COMMAND=$OLD_PROMPT_COMMAND
  export AUTO_GEMSETS_REPORTING=$OLD_AUTO_GEMSETS_REPORTING
}

[[ -z "$SHUNIT2" ]] && SHUNIT2=~/Development/shunit2C/src/shunit2

. ./lib/auto-gemsets/auto-gemsets.sh
. ~/.colors

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }