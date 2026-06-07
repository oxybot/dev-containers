FROM ghcr.io/oxybot/base:latest

# Install pnpm
RUN npm install -g pnpm@latest

# Finalize the image
ENV OXYBOT_CONTENT="node, playwright"
