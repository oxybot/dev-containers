# Base Dev Container Image

A foundational dev container image built on the official Dev Containers Debian base image, with system packages upgraded and Node.js + Playwright tooling pre-installed. It is designed as a reusable starting point for language- or stack-specific images.

## What's Included

| Component | Details |
|---|---|
| Base image | `mcr.microsoft.com/devcontainers/base:debian` |
| System tools | `curl`, `wget`, plus optional `EXTRA_PACKAGES` build arg |
| Node.js | Installed via `nvm` with default `NODE_VERSION=24` |
| Package manager | Latest `npm` (global) |
| Browser tooling | Playwright browsers and OS dependencies (`playwright install-deps` and `playwright install`) |
| User setup | Shell init via `BASH_ENV`, plus startup welcome script |

## Supported Platforms

- `linux/amd64`
- `linux/arm64`

## Usage

Reference this image in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "My Project",
  "image": "ghcr.io/oxybot/dev-containers/base:latest"
}
```

Or use it as the base in a custom `Dockerfile`:

```dockerfile
FROM ghcr.io/oxybot/dev-containers/base:latest

# Add your own customizations
```

## Available Tags

| Tag | Description |
|---|---|
| `latest` | Latest build from the default branch |

## Why Use This Image?

This image centralizes common container setup tasks such as package upgrades, Node.js bootstrapping, and Playwright installation, so downstream images can stay smaller and focus on stack-specific customization.

## License

[MIT](LICENSE)
