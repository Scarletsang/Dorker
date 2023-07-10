# **Dorker**

*Dorker* is a simple tool to help you run commands inside a dockerized linux environment

## Installation

```bash
bash install.sh
source ~/.zshrc
```

## Configure

When *Dorker* builds a docker container from a docker image, it will mount a directory of the local computer to the container.
The *Dorker* commands can only be used within this directory.
The default is set to $HOME/Documents. If you want to change it, change the "DORKER_WORKSPACE" variable defined inside src/settings.sh.

## Usage

By just add dorker in front of any command, you can run the command within the docker container

```bash
# Make sure you are within the DORKER_WORKSPACE
cd $HOME/Documents/minishell
# The command "apt-get install libreadline-dev" is getting run inside the docker container
dorker apt-get install libreadline-dev
# The command "make re" is getting run inside the docker container
dorker make re
# The command "valgrind ./minishell" is getting run inside the docker container
dorker valgrind --leak-check=full ./minishell
```

If you have want to see what commands dorker offers, just type

```bash
dorker
```

It will show you 3 more commands that the main 'dorker' command is using:

1. dorker-init: Built and start the docker container called "dorker".
2. dorker-open-docker: Open docker from the command line.
3. dorker-goinfre-docker: Setup docker inside the goinfre directory.

These 3 commands are called internally of the 'dorker' command when it sees necessary.

## Customization

If you wants to add or delete anything from the *Dorker* container, simply make changes to the Dockerfile inside src.

After making changes to the Dockerfile, or changed the DORKER_WORKSPACE variable, you must rebuilt the image and the container. (if *Dorker* have been run or is already running) The following command rebuild the docker image (if necessary) and the docker container automatically:

```bash
dorker-reload
```
