#!/bin/bash

__dorker-check()
{
  if [ "$1" = "$(pwd)" ]; then
    echo -e $DORKER_RED"You are not inside the workspace specified."$DORKER_WHITE
    echo -e $DORKER_BLUE"Dorker can only be ran inside the specified workspace, currently it is set to \"$DORKER_WORKSPACE\". To change it, please change it inside \"$(dirname "$(type dorker | awk '{ print $7 }')")/settings.sh\"."$DORKER_WHITE
    return 1
  fi
  # Checks if the dorker container is running
  if [ $( docker ps 2> /dev/null | grep dorker | wc -l ) -eq 0 ]; then
    # If the dorker image does not exist, then build it,
    # otherwise just run docker-init to build the image and the container
    if [ $( docker images -q dorker 2> /dev/null | wc -l ) -eq 0 ]; then
      dorker-init
    else
      docker run -itd -v $DORKER_WORKSPACE:/dorker_workspace --name=dorker dorker
    fi
  fi
  return 0
}

dorker() {
  if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    echo -e $DORKER_BLUE"
Dorker is configured to run only inside $DORKER_WORKSPACE
Change settings in $DORKER_INSTALL_DIR/src/settings.sh
Change Dockerfile in $DORKER_INSTALL_DIR/src/Dockerfile

Avaliable commands:

dorker <commands>        Execute any command inside the \"dorker\" container.
dorker-reload            Rebuild the dorker container.
dorker-init              Built and start the docker container called \"dorker\".
dorker-open-docker       Open docker from the command line.
dorker-goinfre-docker    Setup docker inside the goinfre directory.
"$DORKER_WHITE
    return
  fi
  # Gets the current path inside the docker container
  local DORKER_CURRENT_PATH=$(pwd | sed "s,^$DORKER_WORKSPACE,,g")
  # Checks if the user is inside the workspace. If not, then return
  # If dorker has not been built yet, the check will run dorker-init (aka the build command)
  __dorker-check "$DORKER_CURRENT_PATH"
  if [ $? -eq 1 ]; then
    return
  fi
  docker exec -it dorker bash -c "cd '/dorker_workspace$DORKER_CURRENT_PATH' && $*"
}

dorker-init() {
  # Asks if you want to use initialize docker inside goinfre.
  # This option is needed because one might want to use it in their personal PC  
  echo -e $DORKER_RED"Dorker wants to know if you want to setup Docker inside goinfre. Do you want to setup Docker within goinfre? [y/N]"$DORKER_WHITE
  read DORKER_USER_ANSWER
  if [ -n "$DORKER_USER_ANSWER" ] && [ "$DORKER_USER_ANSWER" = "y" ]; then
    dorker-goinfre-docker
    if [[ $? -eq 1 ]]; then
      return
    fi
  fi
  dorker-open-docker
  # Checks if the dorker image exists. If not, then build it
  if [ ! "$(docker ps -q -f name=dorker)" ]; then
    # If the conatiner is just exited, then restart it
    if [ "$(docker ps -aq -f status=exited -f name=dorker)" ]; then
      docker start dorker
    else
      local dockerfile=$(dirname "$(type $0 | awk '{ print $7 }')")/Dockerfile
      chmod 755 $dockerfile
      docker build . -t dorker -f $dockerfile &&
      docker run -itd -v $DORKER_WORKSPACE:/dorker_workspace --name=dorker dorker > /dev/null ||
        echo -e $DORKER_RED"Failed to build the dorker image"$DORKER_WHITE
    fi
  fi
  echo -e $DORKER_GREEN"Dorker is running in $DORKER_WORKSPACE"$DORKER_WHITE
}

dorker-reload() {
  dorker-open-docker
  docker build . -t dorker -f $(dirname "$(type $0 | awk '{ print $7 }')")/Dockerfile
  docker stop dorker > /dev/null
  docker rm dorker > /dev/null
  docker run -itd -v $DORKER_WORKSPACE:/dorker_workspace --name=dorker dorker > /dev/null &&
  echo -e $DORKER_GREEN"Dorker is reloaded and restarted"$DORKER_WHITE
}