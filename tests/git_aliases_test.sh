#!/bin/bash -i

BASE_PROJECT_FOLDER=$(cd $(dirname "${BASH_SOURCE[0]}")/.. ; pwd)
#BUILD_PROJECT_FOLDER=${BASE_PROJECT_FOLDER}/build
BUILD_PROJECT_FOLDER=~/.gitAliasTesting

. ${BASE_PROJECT_FOLDER}/git_aliases.sh

###
# Auxiliary functions
###
cleanupTestGitProjectFolder() {
  cd $BASE_PROJECT_FOLDER
  rm -rf $BUILD_PROJECT_FOLDER
}

setUpTestGitProjectFolder() {
  cleanupTestGitProjectFolder
  mkdir -p $GIT_PROJECT_FOLDER
}

###
# Setup for each testcase
###
setUp() {
  GIT_PROJECT_FOLDER=${BUILD_PROJECT_FOLDER}/gitRepos
}

tearDown() {
  cleanupTestGitProjectFolder
}

###
# Test cases for gitGoTo
###
testGitGoToAliasEchoesErrorIfNoGitProjectFolderVariableDefined() {
  unset GIT_PROJECT_FOLDER
  local git_go_to_output="$(gitGoTo)"
  assertEquals "GIT_PROJECT_FOLDER variable is not defined." "${git_go_to_output}"
}

testGitGoToAliasEchoesErrorIfGitProjectFolderLocationDoesNotExist() {
  local git_go_to_output="$(gitGoTo)"
  assertEquals "GIT_PROJECT_FOLDER defined location does not exist or is not accessible." "${git_go_to_output}"
}

testGitGoToAliasMovesUserToGitFolderVariableHeldLocation() {
  setUpTestGitProjectFolder

  gitGoTo
  assertEquals "${GIT_PROJECT_FOLDER}" "$(pwd)"
}

###
# Test cases for gitUpdateAll
###
testGitUpdateAllAliasEchoesErrorIfNoGitProjectFolderVariableDefined() {
  unset GIT_PROJECT_FOLDER
  local git_update_output="$(gitUpdateAll)"
  assertEquals "GIT_PROJECT_FOLDER variable is not defined." "${git_update_output}"
}

testGitUpdateAllAliasEchoesErrorIfGitProjectFolderLocationDoesNotExist() {
  local git_update_output="$(gitUpdateAll)"
  assertEquals "GIT_PROJECT_FOLDER defined location does not exist or is not accessible." "${git_update_output}"
}

testGitUpdateAllAliasShouldIgnoreNonGitReposInGitProjectFolder() {
  setUpTestGitProjectFolder

  mkdir -p ${GIT_PROJECT_FOLDER}/notAGitRepo

  local git_update_output="$(gitUpdateAll)"

  assertEquals "" "${git_update_output}"
}

testGitUpdateAllAliasShouldNotPullUpdatesForGitRepositoriesWithNoRemoteForCurrentBranch() {
  setUpTestGitProjectFolder

  mkdir -p ${GIT_PROJECT_FOLDER}/localOnlyGitRepo
  (cd ${GIT_PROJECT_FOLDER}/localOnlyGitRepo &&
   git init &&
   echo "This is a test README" >> ${GIT_PROJECT_FOLDER}/localOnlyGitRepo/README.MD &&
   git add . &&
   git commit -m 'Test Readme added') > /dev/null 2>&1

  local git_update_output="$(gitUpdateAll)"

  assertEquals "Skipping update of localOnlyGitRepo as current branch (master) is not set up for remote tracking." "${git_update_output}"
}

testGitUpdateAllAliasUpdatesAllGitRepositoriesInGitProjectFolder() {
  setUpTestGitProjectFolder

  mkdir -p ${BUILD_PROJECT_FOLDER}/testGitRepoRemote
  (cd ${BUILD_PROJECT_FOLDER}/testGitRepoRemote;
   git init;
   echo "This is a test README" >> ${BUILD_PROJECT_FOLDER}/testGitRepoRemote/README.MD;
   git add .;
   git commit -m 'Test Readme added') > /dev/null 2>&1

  cp -r ${BUILD_PROJECT_FOLDER}/testGitRepoRemote ${GIT_PROJECT_FOLDER}/gitUpdateableRepo
  (cd ${GIT_PROJECT_FOLDER}/gitUpdateableRepo;
   git remote add origin ${BUILD_PROJECT_FOLDER}/testGitRepoRemote;
   git fetch;
   git branch --set-upstream-to origin/master master) > /dev/null 2>&1

  (cd ${BUILD_PROJECT_FOLDER}/testGitRepoRemote;
   echo nonsense >> .gitignore;
   git add .gitignore;
   git commit -m 'Git ignore added';) > /dev/null 2>&1

  local expected_upstream_commit_hash=$(cd ${BUILD_PROJECT_FOLDER}/testGitRepoRemote; git rev-parse HEAD)
  echo $expected_upstream_commit_hash

  (cd ${GIT_PROJECT_FOLDER}/gitUpdateableRepo; git log $expected_upstream_commit_hash --pretty=format:%H -1) > /dev/null 2>&1
  assertFalse "TEST SETUP PROBLEM: Repo to update already contains the commit hash expected to show up only after update" "[ $? -eq 0 ]"

  local git_update_output=$(gitUpdateAll)

  (cd ${GIT_PROJECT_FOLDER}/gitUpdateableRepo; git log $expected_upstream_commit_hash --pretty=format:%H -1) > /dev/null 2>&1
  assertTrue "Repo does not contain expected commit hash after update" "[ $? -eq 0 ]"

  assertContains "Output does not contain expected message about repo being updated" "${git_update_output}" "Updating testGitRepoRemote"
}

. $(which shunit2)

