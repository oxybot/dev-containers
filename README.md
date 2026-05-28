# TypeScript / Node.js with Playwright Dev Container Image

A ready-to-use dev container image that extends the official [TypeScript & Node.js dev container](https://github.com/devcontainers/images/tree/main/src/typescript-node) with full [Playwright](https://playwright.dev/) browser testing support — browsers and all system dependencies pre-installed.

## What's Included

| Component | Details |
|---|---|
| Base image | `mcr.microsoft.com/devcontainers/typescript-node:4-24` (Node.js 24) |
| Package managers | Latest `npm` and `pnpm` |
| Playwright browsers | Chromium, Firefox, WebKit (pre-installed) |
| Playwright system deps | All OS-level dependencies pre-installed |

## Supported Platforms

- `linux/amd64`
- `linux/arm64`

## Usage

Reference this image in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "My Project",
  "image": "ghcr.io/oxybot/typescript-node-with-playwright:latest"
}
```

Or use it as the base in a custom `Dockerfile`:

```dockerfile
FROM ghcr.io/oxybot/typescript-node-with-playwright:latest

# Add your own customizations
```

## Available Tags

| Tag | Description |
|---|---|
| `latest` | Latest build from the default branch |
| `4` | Node.js major version 4x series |
| `4-24` | Node.js 24, TypeScript 4x series |

## Why Use This Image?

Setting up Playwright in a dev container typically requires installing both system-level dependencies and browser binaries, which can be slow and error-prone. This image ships with everything pre-installed so your container starts ready to run Playwright tests — no extra setup steps needed.

## Update Cadence

This image is rebuilt automatically every **Tuesday at midnight** to pick up the latest base image updates, security patches, and Playwright releases.

## Vulnerability Reporting

A Trivy report is generated aside of the image.

The workflow generates `trivy-report.json` for the exact pushed manifest digest and attaches it to the image as an OCI artifact with type `application/vnd.aquasec.trivy.report.v1+json`.

- Reported severities: `HIGH`, `CRITICAL`
- Scope: OS packages and language libraries
- `--ignore-unfixed` is enabled

## License

[MIT](LICENSE)
