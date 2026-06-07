FROM ghcr.io/oxybot/base:latest

ARG USERNAME=vscode

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
    && rm -rf /var/lib/apt/lists/*

# Ensure latest pnpm are installed
RUN npm install -g pnpm@latest

# Install .Net sdk
USER root
RUN curl -L https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
RUN chmod +x /tmp/dotnet-install.sh
RUN DOTNET_INSTALL_DIR=/usr/share/dotnet /tmp/dotnet-install.sh --version latest

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENV OXYBOT_CONTENT="node, python, .net"
