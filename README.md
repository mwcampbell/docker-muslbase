# Docker musl base

This is a minimal self-hosting system for Docker containers, based on [musl libc](http://www.musl-libc.org/) and [BusyBox](http://busybox.net/). It contains just enough to compile software, including itself.

## Building

First, you need to fetch the dependencies, which are in Git submodules:

    git submodule update --init

This system can be built from either itself or Debian Wheezy. To start with Debian Wheezy:

    docker build --rm -t=mwcampbell/muslbase-build-base buildbase/debian

To start with muslbase itself:

    docker build --rm -t=mwcampbell/muslbase-build-base buildbase/selfhost

Then, to run the main build process:

    docker build --rm -t=yourname/muslbase-build .

Finally, to create the actual image:

    docker run --rm yourname/muslbase-build cat /rootfs.tar > rootfs/rootfs.tar
    docker build --rm -t=yourname/muslbase rootfs

Now you can clean up:

    docker rmi mwcampbell/muslbase-build-base
    docker rmi yourname/muslbase-build
