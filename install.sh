#!/bin/bash

# Get the absolute path of the dorker init script
DORKER_INIT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$(pwd)/init.sh")
# if the init script is already sourced in the .zshrc file, then dorker is already installed
# otherwise, add the init script to the .zshrc file
(cat ~/.zshrc | grep "source $DORKER_INIT" > /dev/null ) && echo "Dorker already installed" ||
(echo "# Dorker commands
source $DORKER_INIT" >> ~/.zshrc && echo "Dorker successfully installed")
