FROM debian:latest

# Install the required packages for C development
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    libreadline-dev \
    g++ \
    git \
    make \
    valgrind \
    strace