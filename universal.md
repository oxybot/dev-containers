# Universal Dev Container Image

A general-purpose dev container image built on the [base dev container](./base.md), adding Python, pnpm, and the .NET SDK so one environment can support Node.js, Python, and .NET workflows.

## What's Included

| Component | Details |
|---|---|
| Base image | `ghcr.io/oxybot/base:latest` |
| Languages and runtimes | Node.js (from base), Python 3, .NET SDK |
| Package managers | `npm` (from base) and latest `pnpm` |
| Key tooling | Playwright and browser dependencies (from base) |

## Supported Platforms

- `linux/amd64`
- `linux/arm64`

## Usage

Reference this image in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "My Project",
  "image": "ghcr.io/oxybot/dev-containers/universal:latest"
}
```

Or use it as the base in a custom `Dockerfile`:

```dockerfile
FROM ghcr.io/oxybot/dev-containers/universal:latest

# Add your own customizations
```

## Available Tags

| Tag | Description |
|---|---|
| `latest` | Latest published universal image |

## Why Use This Image?

This image reduces setup time when projects span multiple ecosystems by combining JavaScript/TypeScript tooling, Python, and .NET support in a single preconfigured development container.

## License

[MIT](LICENSE)