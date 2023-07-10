#!/bin/bash

source $(dirname ${BASH_SOURCE:-$0})/src/settings.sh
source $(dirname ${BASH_SOURCE:-$0})/src/docker.sh &&
source $(dirname ${BASH_SOURCE:-$0})/src/dorker.sh &&
[[ $DORKER_SHOW_LOAD_ON_STARTUP -eq 1 ]] &&
echo $DORKER_GREEN"Dorker commands successfully loaded"$DORKER_WHITE