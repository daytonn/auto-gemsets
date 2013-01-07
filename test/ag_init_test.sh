#!/bin/sh

. ./test/helper.sh

setUp() {
  clear_env
  if [ ! -f "${HOME}/.auto-gemsets" ]; then
    touch "${HOME}/.auto-gemsets"; echo "export AUTO_GEMSETS_REPORTING=on" > "${HOME}/.auto-gemsets"
  else
    mv "${HOME}/.auto-gemsets" "${HOME}/.auto-gemsets.bak"
  fi
}

tearDown() {
  reset_env
  if [ -f "${HOME}/.auto-gemsets.bak" ]; then
    rm -f "${HOME}/.auto-gemsets"
    mv "${HOME}/.auto-gemsets.bak" "${HOME}/.auto-gemsets"
  else
    rm -f "${HOME}/.auto-gemsets"
  fi
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

test_it_sources_the_auto_gemsets_file() {
  ag_init
  assertEquals " it sources the ~/.auto-gemsets file" \
    "on" "$AUTO_GEMSETS_REPORTING"
}

test_it_calls_auto_gemsets() {
  cd "$HOME"
  ag_init > /dev/null

  assertEquals " it sets the default when no Gemfile is present" \
    "default" "$GEMSET"

  assertEquals " it sets the GEM_HOME when no Gemfile is present" \
    "${GEMSET_ROOT}/default" "$GEM_HOME"

  assertEquals " it sets the GEM_HOME when no Gemfile is present" \
    "${GEMSET_ROOT}/default" "$GEM_ROOT"

  assertEquals " it sets the GEM_PATH when no Gemfile is present" \
    "${GEMSET_ROOT}/default" "$GEM_PATH"

  assertNotNull " it adds the gemset's bin directory to the path" \
    "$(echo $PATH | grep "${GEMSET_ROOT}/default/bin")"
}


SHUNIT_PARENT=$0 . $SHUNIT2