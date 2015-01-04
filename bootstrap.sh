#!/bin/sh

set -e

# Check if script is run correctly
if [ -z "$1" ]; then
	echo "Usage: $0 username" >&2
	exit 1
fi

username="$1"

# Download/Update all dependencies
git submodule update --init

# Clean/Remove built environment
docker rmi mwcampbell/muslbase-build-base || true
docker rmi $username/muslbase-build || true

# Build, first using glibc from debian, then musl from selfhost build environment
for buildbase in debian selfhost selfhost; do
	if [ "$buildbase" = "selfhost" ]; then
		# Next use muslbase as build environment
		docker tag $username/muslbase mwcampbell/muslbase-build-base
	else
		# Build initial debian base build environment
		docker build --rm -t=mwcampbell/muslbase-build-base buildbase/$buildbase
	fi

	# Remove earlier muslbase images
	docker rmi $username/muslbase || true
	docker rmi $username/muslbase-runtime || true
	docker rmi $username/muslbase-static-runtime || true

	# Build muslbase rootfs
	docker build --rm -t=$username/muslbase-build .

	# Build docker image: muslbase
	docker run --rm $username/muslbase-build cat /rootfs.tar > rootfs/full/rootfs.tar
	docker build --rm -t=$username/muslbase rootfs/full
	rm rootfs/full/rootfs.tar

	# Build docker image: muslbase-runtime
	docker run --rm $username/muslbase-build cat /runtime-rootfs.tar > rootfs/runtime/rootfs.tar
	docker build --rm -t=$username/muslbase-runtime rootfs/runtime
	rm rootfs/runtime/rootfs.tar

	# Build docker image: muslbase-static-runtime
	docker run --rm $username/muslbase-build cat /static-runtime-rootfs.tar > rootfs/static-runtime/rootfs.tar
	docker build --rm -t=$username/muslbase-static-runtime rootfs/static-runtime
	rm rootfs/static-runtime/rootfs.tar

	# Clean/Remove build environment
	docker rmi mwcampbell/muslbase-build-base
	docker rmi $username/muslbase-build
done
