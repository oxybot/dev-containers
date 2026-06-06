FROM mcr.microsoft.com/devcontainers/base:debian

ARG USERNAME=vscode
ARG NODE_VERSION=24
ARG EXTRA_PACKAGES=""

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Upgrade default packages
# Install curl, wget and the extra dependencies
USER root
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends \
    && apt-get install -y curl wget ${EXTRA_PACKAGES} --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

COPY welcome.sh /usr/local/share/dev-containers/welcome.sh
RUN chmod 755 /usr/local/share/dev-containers/welcome.sh

# Prepare user environment
USER ${USERNAME}
ENV BASH_ENV=/home/${USERNAME}/.bash_env
RUN touch $BASH_ENV \
    && echo '. "$BASH_ENV"' >> ~/.bashrc \
    && echo '[ -f /usr/local/share/dev-containers/welcome.sh ] && /usr/local/share/dev-containers/welcome.sh' >> ~/.bashrc

# Install node.js
RUN NVM_VERSION="$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p')" \
    && curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | PROFILE="$BASH_ENV" bash
RUN nvm install "$NODE_VERSION" \
    && nvm alias default "$NODE_VERSION" \
    && npm install -g npm@latest

# Install Playwright browsers and its dependencies
RUN npx -y playwright install-deps
RUN npx -y playwright install

USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV OXYBOT_CONTENT=playwright
