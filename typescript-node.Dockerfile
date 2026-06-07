FROM ghcr.io/oxybot/base:latest

# Install pnpm
RUN npm install -g pnpm@latest

ENV OXYBOT_CONTENT=typescript-node
