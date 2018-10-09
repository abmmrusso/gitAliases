#!/bin/bash -i

BASE_PROJECT_FOLDER=$(cd $(dirname "${BASH_SOURCE[0]}")/.. ; pwd)

. ${BASE_PROJECT_FOLDER}/git_aliases.sh

setUp() {
  cd $BASE_PROJECT_FOLDER
  GIT_PROJECT_FOLDER=${BASE_PROJECT_FOLDER}/build
  rm -rf $GIT_PROJECT_FOLDER
  mkdir $GIT_PROJECT_FOLDER
}

tearDown() {
  cd $BASE_PROJECT_FOLDER
  rm -rf $GIT_PROJECT_FOLDER
}

testGitGoToAliasEchoesErrorIfNoGitProjectFolderVariableDefined() {
  unset GIT_PROJECT_FOLDER
  local alias_output="$(gitGoTo)"
  assertEquals "GIT_PROJECT_FOLDER variable is not defined." "${alias_output}"
}

testGitGoToAliasEchoesErrorIfGitProjectFolderLocationDoesNotExist() {
  GIT_PROJECT_FOLDER=${GIT_PROJECT_FOLDER}/doesNotExist
  local alias_output="$(gitGoTo)"
  assertEquals "GIT_PROJECT_FOLDER defined location does not exist or is not accessible." "${alias_output}"
}

testGitGoToAliasMovesUserToGitFolderVariableHeldLocation() {
  GIT_PROJECT_FOLDER=${GIT_PROJECT_FOLDER}
  gitGoTo
  assertEquals "${GIT_PROJECT_FOLDER}" "$(pwd)"
}

. $(which shunit2)

