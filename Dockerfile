FROM ubuntu:24.04

ARG AGENT_VERSION=4.269.0
ARG TARGETARCH

LABEL version="1.0"
LABEL release-notes="docker image for running azure devops deployment agent inside a container"
LABEL maintainer="Singam Tech Inc (https://github.com/Singam-Tech-Inc/)"
LABEL lastupdated="Akshaya Thirisangu"


# Install dependencies for Azure DevOps agent
RUN apt update && apt install -y \
    curl \
    tar \
    libicu-dev \
    libssl3t64 \
    libkrb5-3 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m agent

# Download and extract the agent matching the build architecture.
# TARGETARCH comes from Docker BuildKit (e.g. amd64, arm64).
RUN set -e; \
        case "${TARGETARCH}" in \
            amd64) AGENT_ARCH="x64" ;; \
            arm64) AGENT_ARCH="arm64" ;; \
            *) echo "Unsupported TARGETARCH: ${TARGETARCH}"; exit 1 ;; \
        esac; \
        mkdir -p /opt/agent; \
        cd /opt/agent; \
        curl -fSL -o vstsagent.tar.gz "https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/vsts-agent-linux-${AGENT_ARCH}-${AGENT_VERSION}.tar.gz"; \
        tar -zxvf vstsagent.tar.gz; \
        rm vstsagent.tar.gz

# Copy and make the script executable
COPY deployagent.sh /deployagent.sh
RUN chmod +x /deployagent.sh

# Default command
CMD ["/bin/bash", "/deployagent.sh"]