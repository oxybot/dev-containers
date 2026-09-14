FROM ghcr.io/oxybot/base:latest

ARG USERNAME=vscode

# Install pnpm
ENV PNPM_HOME="/home/${USERNAME}/.local/share/pnpm"
ENV PATH="${PNPM_HOME}/bin:${PATH}"
RUN wget -qO- https://get.pnpm.io/install.sh | env SHELL="$(which bash)" bash - \
    && echo "export PATH=\"${PNPM_HOME}/bin:\$PATH\"" >> "$BASH_ENV"

# Finalize the image
ENV OXYBOT_CONTENT="node, playwright"
