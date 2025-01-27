FROM debian:bookworm-slim AS base

RUN apt-get update
RUN apt-get install -y git curl vim jq pkg-config libssl-dev gnupg

RUN mkdir -p /etc/apt/keyrings
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update
RUN apt-get install -y nodejs git-lfs

FROM base AS docker

RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update
RUN apt-get install -y docker-ce-cli docker-buildx-plugin

FROM base AS rust

RUN apt-get install -y build-essential

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal

ENV PATH=$PATH:/root/.cargo/bin

FROM base as go

RUN curl -fsSL https://go.dev/dl/go1.20.6.linux-amd64.tar.gz \
  | tar -C /usr/local -xz

ENV PATH=$PATH:/usr/local/go/bin

