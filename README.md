# Docker musl base

This is a minimal self-hosting system for Docker containers, based on [musl libc](http://www.musl-libc.org/) and [BusyBox](http://busybox.net/). It contains just enough to compile software, including itself.

## Building

Run the bootstrap script in the top-level directory of your working copy as follows:

    ./bootstrap.sh username

Where `username` is the username you wish to use for your Docker image tags. This will often be your username on docker.io.
