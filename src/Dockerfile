FROM debian:latest

# Install the required packages for C development
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    valgrind \
    g++ \
    git \
    make
# Uncomment the following line if you want to use readline
# RUN apt-get install libreadline-dev strace -y