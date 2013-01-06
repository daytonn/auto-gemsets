#!/bin/sh

. ./test/helper.sh

setUp() {
  clear_env
}

tearDown() {
  reset_env
}

test_it_removes_a_directory_from_the_path() {
  ag_remove_path '/ag/test/path'
  assertNull " it removes a path from the path" \
    "$(echo $PATH | grep "/ag/test/path")"
}

SHUNIT_PARENT=$0 . $SHUNIT2