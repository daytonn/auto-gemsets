#!/bin/sh

. ./test/helper.sh

setUp() {
  clear_env
  export PATH="test:/usr/bin:/bin"
}

tearDown() {
  reset_env
}

test_it_does_not_duplicate_entries() {
  ag_add_path 'test'
  assertEquals " it doesn't duplicate entries" \
    "test:/usr/bin:/bin" "$PATH"
}

SHUNIT_PARENT=$0 . $SHUNIT2