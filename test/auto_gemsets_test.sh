#!/bin/sh

. ./test/helper.sh

PROJECT_DIR="$PWD/test/project"

setUp() {
  clear_env
  if [ ! -d "${GEMSET_ROOT}/project" ]; then
    rm -Rf "${GEMSET_ROOT}/project"
  fi
}

tearDown() {
  reset_env
  if [ ! -d "${GEMSET_ROOT}/project" ]; then
    rm -Rf "${GEMSET_ROOT}/project"
  fi
}

test_it_sets_the_gemfile_environment_variable() {
  cd "$PROJECT_DIR"
  auto_gemsets > /dev/null

  assertEquals " it sets the gemfile environment variable" \
    "${PROJECT_DIR}/Gemfile" "$GEMFILE"
}

test_it_sets_the_default_gemset_when_no_gemfile_is_present() {
  cd "$HOME"
  auto_gemsets > /dev/null

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

test_it_sets_the_gemset_when_a_gemfile_is_present() {
  cd "$PROJECT_DIR"
  auto_gemsets > /dev/null

  assertEquals " it sets the gemset when a Gemfile is present" \
    "project" "$GEMSET"

  assertEquals " it sets the GEM_HOME when no Gemfile is present" \
    "${GEMSET_ROOT}/project" "$GEM_HOME"

  assertEquals " it sets the GEM_HOME when no Gemfile is present" \
    "${GEMSET_ROOT}/project" "$GEM_ROOT"

  assertEquals " it sets the GEM_PATH when no Gemfile is present" \
    "${GEMSET_ROOT}/project:${GEMSET_ROOT}/default" "$GEM_PATH"

  assertNotNull " it adds the gemset's bin directory to the path" \
    "$(echo $PATH | grep "${GEMSET_ROOT}/default/bin")"
}

test_it_doesnt_do_anything_if_the_gemset_is_active() {
  export GEMSET="project"

  assertNull " it doesnt do anything if the gemset is active" \
    "$(auto_gemsets)"
}

test_it_creates_a_gemset_directory_if_it_does_not_exist() {
  auto_gemsets > /dev/null

  assertTrue " it creates a gemset directory if it does not exist" \
    "[ -d ${GEMSET_ROOT}/project ]"
}

SHUNIT_PARENT=$0 . $SHUNIT2