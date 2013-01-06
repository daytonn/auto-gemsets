#!/bin/sh

. ./test/helper.sh

setUp() {
  clear_env
}

tearDown() {
  reset_env
}

test_it_adds_a_gemset_root_environment_variable() {
  ag_init
  assertEquals " it adds a GEMSET_ROOT environment variable" \
    "$HOME/.gemsets" "$GEMSET_ROOT"
}

test_sets_default_gemset_if_not_defined() {
  ag_init
  assertEquals " it sets the DEFAULT_GEMSET" \
    "default" "$DEFAULT_GEMSET"
}

test_ignores_default_gemset_if_defined() {
  export DEFAULT_GEMSET='test'
  ag_init
  assertEquals " it sets the DEFAULT_GEMSET" \
    "test" "$DEFAULT_GEMSET"
}

test_it_adds_auto_gemsets_to_the_prompt_command() {
  ag_init
  assertEquals " it adds auto_gemsets to the PROMPT_COMMAND" \
    "$PROMPT_COMMAND" "auto_gemsets"
}

test_it_appends_to_the_prompt_command_if_it_already_has_functions() {
  export PROMPT_COMMAND=":"
  ag_init
  assertEquals " it appends to the PROMPT_COMMAND if it already has functions" \
    ":; auto_gemsets" "$PROMPT_COMMAND"
}

test_it_doesnt_duplicate_the_prompt_command() {
  export PROMPT_COMMAND="auto_gemsets"
  ag_init
  assertEquals " it doesn't duplicate the PROMPT_COMMAND" \
    "auto_gemsets" "$PROMPT_COMMAND"
}


SHUNIT_PARENT=$0 . $SHUNIT2