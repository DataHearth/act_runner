FROM debian:bookworm-slim AS base

RUN apt-get update

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs git curl

FROM base AS docker

RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.2.tgz \
  | tar -xz --strip-components=1 -C /usr/local/bin/ docker/docker
