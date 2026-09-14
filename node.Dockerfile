FROM ghcr.io/oxybot/base:latest

# Install pnpm
RUN wget -qO- https://get.pnpm.io/install.sh | env ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -

# Finalize the image
ENV OXYBOT_CONTENT="node, playwright"
