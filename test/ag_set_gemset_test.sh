#!/bin/sh

. ./test/helper.sh

setUp() {
  clear_env
  export AUTO_GEMSETS_REPORTING='off'
}

tearDown() {
  reset_env
}

test_it_sets_gem_home_to_the_gemset_path() {
  ag_set_gemset 'default'
  assertEquals " it sets the GEM_HOME to the default gemset path" \
    "${GEMSET_ROOT}/default" "$GEM_HOME"
}

test_it_sets_gem_path_to_the_default_gemset_path() {
  ag_set_gemset 'default'
  assertEquals " it sets the GEM_PATH to the default gemset path" \
    "${GEMSET_ROOT}/default" "$GEM_PATH"
}

test_it_adds_the_gemset_bin_directory_to_the_path() {
  ag_set_gemset 'default'
  assertNotNull " it adds the gemset's bin directory to the path" \
    "$(echo $PATH | grep "${GEM_HOME}/bin")"
}

test_it_adds_the_default_bin_directory_to_path_when_not_default() {
  ag_set_gemset 'some_gemset'
  assertNotNull " it adds the default gemset's bin directory to the path" \
    "$(echo $PATH | grep "${GEMSET_ROOT}/default/bin")"
}

test_it_adds_the_default_gemset_to_the_gem_path() {
  ag_set_gemset 'some_gemset'

  assertEquals " it adds the default gemset to the GEM_PATH" \
    "${GEMSET_ROOT}/some_gemset:${GEMSET_ROOT}/default" "$GEM_PATH"
}

test_it_sets_the_gemset_environment_variable() {
  ag_set_gemset 'default'
  assertEquals " it sets the GEMSET environment variable" \
    "default" "$GEMSET"
}

test_it_sets_the_gem_root_variable() {
  ag_set_gemset 'default'
  assertEquals " it sets the GEM_ROOT environment variable" \
    "${GEMSET_ROOT}/default" "$GEM_ROOT"
}

test_it_reports_the_new_gemset_change() {
  export AUTO_GEMSETS_REPORTING='on'
  assertEquals " it reports the new gemset change *default when default" \
    "Now using default gemset via *default" "$(ag_set_gemset 'default')"

  export GEMFILE="test"
  assertEquals " it reports the new gemset change with the GEMFILE when NOT default" \
    "Now using some_gemset gemset via test" "$(ag_set_gemset 'some_gemset')"
}

SHUNIT_PARENT=$0 . $SHUNIT2