FROM mcr.microsoft.com/devcontainers/typescript-node:4-24

# Upgrade default packages
USER root
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*
USER node

# Ensure latest npm and pnpm are installed
RUN npm install -g npm@latest pnpm@latest

# Install Playwright dependencies (root permissions are required for this step)
USER root
RUN npx -y playwright install-deps
USER node

# Install Playwright browsers
RUN npx -y playwright install
