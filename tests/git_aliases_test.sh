#!/bin/bash -i

BASE_PROJECT_FOLDER=$(cd $(dirname "${BASH_SOURCE[0]}")/.. ; pwd)

. ${BASE_PROJECT_FOLDER}/git_aliases.sh

oneTimeSetUp() {
  GIT_PROJECT_FOLDER=${BASE_PROJECT_FOLDER}/build
  mkdir $GIT_PROJECT_FOLDER
}

oneTimeTearDown() {
  rm -rf $GIT_PROJECT_FOLDER
}

testGitGoToAliasMovesUserToGitFolderVariableHeldLocation() {
  gitGoTo
  assertEquals "${GIT_PROJECT_FOLDER}" "$(pwd)"
}

. $(which shunit2)

