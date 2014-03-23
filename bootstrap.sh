#!/bin/sh
set -e
if [ -z "$1" ]
then
  echo "Usage: $0 username" >&2
  exit 1
fi
username="$1"
git submodule update --init
docker rmi mwcampbell/muslbase-build-base || true
docker rmi $username/muslbase-build || true
for buildbase in debian selfhost selfhost
do
  if [ "$buildbase" = "selfhost" ]
  then
    docker tag $username/muslbase mwcampbell/muslbase-build-base
  else
    docker build --rm -t=mwcampbell/muslbase-build-base buildbase/$buildbase
  fi
  docker rmi $username/muslbase || true
  docker rmi $username/muslbase-runtime || true
  docker build --rm -t=$username/muslbase-build .
  docker run --rm $username/muslbase-build cat /rootfs.tar > rootfs/full/rootfs.tar
  docker build --rm -t=$username/muslbase rootfs/full
  rm rootfs/full/rootfs.tar
  docker run --rm $username/muslbase-build cat /runtime-rootfs.tar > rootfs/runtime/rootfs.tar
  docker build --rm -t=$username/muslbase-runtime rootfs/runtime
  rm rootfs/runtime/rootfs.tar
  docker rmi mwcampbell/muslbase-build-base
  docker rmi $username/muslbase-build
done
