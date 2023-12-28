#!/bin/bash

DORKER_INSTALL_DIR=$(dirname ${BASH_SOURCE:-$0})
source $DORKER_INSTALL_DIR/src/settings.sh &&
source $DORKER_INSTALL_DIR/src/docker.sh &&
source $DORKER_INSTALL_DIR/src/dorker.sh &&
[[ $DORKER_ECHO_ON_STARTUP -eq 1 ]] &&
echo $DORKER_GREEN"Dorker commands successfully loaded"$DORKER_WHITE