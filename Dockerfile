FROM debian:bookworm-slim AS base

RUN apt-get update

RUN apt-get install -y git curl vim

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

FROM base AS docker

RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.2.tgz \
  | tar -xz --strip-components=1 -C /usr/local/bin/ docker/docker

FROM base AS rust

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal

ENV PATH=$PATH:/root/.cargo/bin
