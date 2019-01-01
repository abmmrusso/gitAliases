function gitGoTo {
  if [ -z ${GIT_PROJECT_FOLDER+x} ] ;
  then
    echo "GIT_PROJECT_FOLDER variable is not defined.";
    return -1;
  elif [ ! -d "$GIT_PROJECT_FOLDER" ] ;
  then
    echo "GIT_PROJECT_FOLDER defined location does not exist or is not accessible.";
    return -2;
  else
    cd ${GIT_PROJECT_FOLDER};
  fi
  return 0
}

function gitUpdateAll {
  gitGoTo
  if [[ $? != 0 ]]
  then
    return -1
  fi

  for d in `ls -d */`
  do
    cd $d
    if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" == "true" ]]
    then
      if [[ "$(git rev-parse --abbrev-ref $(git rev-parse --abbrev-ref HEAD)@{upstream} > /dev/null 2>&1 || echo not_tracked)" == "not_tracked" ]]
      then
        echo "Skipping update of $(basename $d) as current branch ($(git rev-parse --abbrev-ref HEAD)) is not set up for remote tracking."
      else
        echo "Updating $(basename $d)"
        git pull
      fi
    fi
  done
  return 0
}
