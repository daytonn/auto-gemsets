#!/bin/sh

. ./test/helper.sh

test_it_finds_the_parent_directory_name() {
  assertEquals "it finds the parent directory name" \
    "auto-gemsets" "$(ag_parent_dir ${PWD}/Gemfile)"
}

SHUNIT_PARENT=$0 . $SHUNIT2