#!/bin/bash

dorker-open-docker() {
  if [[ -z "$(! docker stats --no-stream 2> /dev/null)" ]]; then
    printf $DORKER_GREEN"Docker is starting up..."$DORKER_WHITE
    open -g -a Docker
    # The animation to open docker inside the terminal
    while [[ -z "$(! docker stats --no-stream 2> /dev/null)" ]];
      do printf $DORKER_GREEN"."$DORKER_WHITE
      sleep 1
    done
    echo ""
  else
    echo -e $DORKER_BLUE"Docker is already running"$DORKER_WHITE
  fi
}

dorker-goinfre-docker() {
  docker_dest="/goinfre/$USER/docker"
  # Ask for docker reset if docker is found in goinfre
  if [ -d "$docker_dest" ]; then
    echo -e ${DORKER_RED}"Docker is already setup in $docker_dest, do you want to reset it? [y/N]"${DORKER_WHITE}
    read -n 1 input
    echo ""
    if [ -n "$input" ] && [ "$input" = "y" ]; then
      rm -rf $docker_dest/{com.docker.{docker,helper},.docker} &>/dev/null ;:
    fi
  fi

  # Unlinks all symlinks, if they are
  unlink ~/Library/Containers/com.docker.docker &>/dev/null ;:
  unlink ~/Library/Containers/com.docker.helper &>/dev/null ;:
  unlink ~/.docker &>/dev/null ;:

  # Delete directories if they were not symlinks
  rm -rf ~/Library/Containers/com.docker.{docker,helper} ~/.docker &>/dev/null ;:

  # Create destination directories in case they don't already exist
  mkdir -p "$docker_dest"/{com.docker.{docker,helper},.docker}

  # Make symlinks
  ln -sf "$docker_dest"/com.docker.docker ~/Library/Containers/com.docker.docker
  ln -sf "$docker_dest"/com.docker.helper ~/Library/Containers/com.docker.helper
  ln -sf "$docker_dest"/.docker ~/.docker
  echo -e $DORKER_GREEN"docker is now set up in goinfre"$DORKER_WHITE
}