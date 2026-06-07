FROM mcr.microsoft.com/devcontainers/base:debian

ARG USERNAME=vscode
ARG NODE_VERSION=24

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Upgrade default packages
# Install curl, wget and the extra dependencies
USER root
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends \
    && apt-get install -y curl wget --no-install-recommends \
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
RUN NVM_VERSION="$(git ls-remote --tags --refs https://github.com/nvm-sh/nvm.git | awk -F/ '{print $3}' | sort -V | tail -n1)" \
    && curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | PROFILE="$BASH_ENV" bash
RUN nvm install "$NODE_VERSION" \
    && nvm alias default "$NODE_VERSION" \
    && npm install -g npm@latest

# Install Playwright browsers and its dependencies
RUN npx playwright install --with-deps

# Finalize the image
USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV OXYBOT_CONTENT=playwright
