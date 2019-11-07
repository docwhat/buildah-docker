#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
export PATH="${PWD}/bin:${PATH}"

# function buildah() {
#   docker exec buildah \
#     buildah "$@"
# }

set -x

if true; then
  buildah version

  # Create a container
  container=$(buildah from docker.io/alpine:3)

  buildah images --all

  # Labels are part of the "buildah config" command
  buildah config --label maintainer="Joe Cool <joecool@example.com>" "$container"

  buildah run "$container" /usr/bin/whoami
  buildah run "$container" /usr/bin/id

  # Grab the source code outside of the container
  docker exec buildah curl -sSfL http://ftpmirror.gnu.org/hello/hello-2.10.tar.gz -o hello-2.10.tar.gz -z hello-2.10.tar.gz

  buildah copy "$container" hello-2.10.tar.gz /tmp/hello-2.10.tar.gz

  buildah run "$container" apk add --no-cache tar gzip gcc make
  buildah run "$container" tar xvzf /tmp/hello-2.10.tar.gz -C /opt

  # Workingdir is also a "buildah config" command
  buildah config --workingdir /opt/hello-2.10 "$container"

  buildah run "$container" ./configure
  buildah run "$container" make
  buildah run "$container" make install
  buildah run "$container" hello -v

  # Entrypoint, too, is a “buildah config” command
  buildah config --entrypoint /usr/local/bin/hello "$container"

  # Finally saves the running container to an image
  buildah commit --format docker "$container" hello:latest

elif false; then
  # Create a container
  container=$(buildah from fedora:28)

  # Labels are part of the "buildah config" command
  buildah config --label maintainer="Joe Cool <joecool@example.com>" "$container"
  Buildah run "$container" /bin/sh -c whoami
  Buildah run "$container" /bin/sh -c id

  # Grab the source code outside of the container
  docker exec buildah curl -sSfL http://ftpmirror.gnu.org/hello/hello-2.10.tar.gz -o hello-2.10.tar.gz -z hello-2.10.tar.gz

  buildah copy "$container" hello-2.10.tar.gz /tmp/hello-2.10.tar.gz

  buildah run "$container" dnf install -y tar gzip gcc make
  Buildah run "$container" dnf clean all
  buildah run "$container" tar xvzf /tmp/hello-2.10.tar.gz -C /opt

  # Workingdir is also a "buildah config" command
  buildah config --workingdir /opt/hello-2.10 "$container"

  buildah run "$container" ./configure
  buildah run "$container" make
  buildah run "$container" make install
  buildah run "$container" hello -v

  # Entrypoint, too, is a “buildah config” command
  buildah config --entrypoint /usr/local/bin/hello "$container"

  # Finally saves the running container to an image
  buildah commit --format docker "$container" hello:latest
fi

# EOF
