FROM fedora:32

RUN dnf install \
  -y --setopt install_weak_deps=false \
  bash \
  buildah \
  && dnf clean all \
  && rm -rf /var/cache/yum

VOLUME "/var/lib/containers"

ENTRYPOINT ["/bin/buildah"]
CMD ["--help"]
