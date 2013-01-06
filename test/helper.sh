#!/bin/sh

OLD_GEM_HOME=$GEM_HOME
OLD_GEM_PATH=$GEM_PATH
OLD_GEM_ROOT=$GEM_ROOT
OLD_GEMSET=$GEMSET
OLD_DEFAULT_GEMSET=$DEFAULT_GEMSET
OLD_GEMFILE=$GEMFILE
OLD_PATH=$PATH
OLD_PROMPT_COMMAND=$PROMPT_COMMAND

clear_env() {
  unset GEM_HOME
  unset GEM_PATH
  unset GEM_ROOT
  unset GEMSET
  unset DEFAULT_GEMSET
  unset GEMFILE
  unset PROMPT_COMMAND
}

reset_env() {
  export GEM_HOME=$OLD_GEM_HOME
  export GEM_PATH=$OLD_GEM_PATH
  export GEM_ROOT=$OLD_GEM_ROOT
  export GEMSET=$OLD_GEMSET
  export DEFAULT_GEMSET=$OLD_DEFAULT_GEMSET
  export GEMFILE=$OLD_GEMFILE
  export PATH=$OLD_PATH
  export PROMPT_COMMAND=$OLD_PROMPT_COMMAND
}

[[ -z "$SHUNIT2" ]] && SHUNIT2=/usr/share/shunit2/shunit2

. ./lib/auto-gemsets/auto-gemsets.sh



setUp() { return; }
tearDown() { return; }
oneTimeTearDown() {
  if [ "$__shunit_assertsFailed" -gt "0" ]; then
    echo
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!!------------------------------------------------ FAILURE ------------------------------------------------!!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  fi
}