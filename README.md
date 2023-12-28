# **Dorker**

*Dorker* enables you to run commands inside a dockerized linux environment for C/C++ development and testing.

## Why *Dorker*?

1. You need to test your programs with valgrind, or debug with strace, but you are developing software on MacOS. With one single command 'dorker', you can test your C/C++ programs in Docker with zero set up.

2. Build once and then never. *Dorker* will ever only be using one single docker image and container. So running the `dorker <command>` is simply running the command inside that docker container, no unnecessary building time.

3. Usable also in personal computer, not only 42 computers. When *Dorker* build the conatiner for the first time, it will asks you if you want to setup docker inside goinfre, simply type 'n' to skip setting up docker inside goinfre.

## Installation

Clone this repository to anywhere in your computer. Once you install Dorker, you should not move the Dorker directory somewhere else.

```bash
git clone https://github.com/Scarletsang/Dorker.git
cd Dorker
bash install.sh
source ~/.zshrc
```

## Configure

When *Dorker* builds a docker container from a docker image, it will mount a directory of the local computer to the container. The *Dorker* commands can only be used within this directory.

It is recommended to configure it as the directory where you can find all your projects within.

The default is set to $HOME/Documents. If you want to change it, change the "DORKER_WORKSPACE" variable defined inside src/settings.sh.

## Usage

By just add dorker in front of any command, you can run the command within the docker container. For example running minishell inside the Docker container for testing:

```bash
# Make sure you are within the DORKER_WORKSPACE
pwd
# The command "apt-get install libreadline-dev" is getting run inside the docker container. You don't need to run this command after Dorker v2.0.0
dorker apt-get install libreadline-dev
# The command "make re" is getting run inside the docker container
dorker make re
# The command "valgrind ./minishell" is getting run inside the docker container
dorker valgrind --leak-check=full ./minishell
dorker strace ./minishell
```

## Popular usage

If you actually wants to run a shell inside the docker container:

```bash
dorker bash
```

`valgrind` is avaliable automatically within the container:

```bash
dorker valgrind --leak-check=full ./minishell
```

`strace` can be used to check if you have closed the file descriptors.

```bash
dorker strace ./minishell
```

For more complicated commands, it is recommanded to write the whole commands in quotes:

```bash
dorker "echo 'echo hi' | strace ./minishell"
dorker "./my_program && echo 'program run successfully'"
```

## Customization

If you wants to add or delete anything from the *Dorker* container, simply make changes to the Dockerfile inside src. Although running `dorker apt-get install <package-name>` indeed install a package within the *Dorker* containter, such change does not stay if you accidentally deletes/exit the container. (Usually happens when you turn quit docker, turn off your computer or you reload the container via `dorker-reload`)

After making changes to the Dockerfile, or changed the DORKER_WORKSPACE variable, you must rebuilt the image and the container. (if *Dorker* have been run or is already running) The following command rebuild the docker image (if necessary) and the docker container automatically:

```bash
dorker-reload
```

By default, "Dorker commands successfully loaded" will be printed whenever you start a new terminal session. If you want to turn it off, simply set DORKER_ECHO_ON_STARTUP equals to 0 inside src/settings.sh.

## Found problems?

*Dorker* internally uses these 3 commands to streamline the building of the *Dorker* container. If you encountered a problem try running these commands in this order:

1. `dorker-goinfre-docker` Setup docker inside the goinfre directory. (Please only run this command in 42 computers)
2. `dorker-open-docker` Open docker from the command line.
3. `dorker-init` Built and start the docker container called "dorker".

These commands works standalone, so feel free to use them independently.

For 42 Heilbronn students, as of 2023 December, the school computer still has two Docker installed. *Dorker* might get stucked in opening Docker if a different Docker is still running. So if something went wrong, please quite the Docker Desktop program entirely and then run *Dorker*.

## Uninstallation

Inside your ~/.zshrc, simply delete these two lines:

```bash
# Dorker commands
source /path_where_dorker_is_installed/Dorker/init.sh
```

## Feedbacks

If you found a bug, or have any questions, don't hesitate to make pull request or to email/slack me on htsang@student.42heilbronn.de.