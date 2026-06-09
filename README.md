# Dev Containers

Simple Dockerfiles for building development container images.
Provides multiple variants that supports both arm64 and amd64 architectures, with a focus on providing a solid base for development, for instance with Playwright testing support embedded in all images.

## Available Images

### [`universal`](./universal.md)

A universal image providing **node**, **.net** and **python** capabilities.

```bash
docker pull ghcr.io/oxybot/dev-containers/universal:latest
```

See detailed documentation: [universal.md](./universal.md).

### [`node`](./node.md)

An image focused on **javascript** and **typescript** development.

```bash
docker pull ghcr.io/oxybot/dev-containers/node:latest
```

See detailed documentation: [node.md](./node.md).

## Variants and versions

Each image may have multiple variants (e.g. different Node.js versions).
Check the individual image documentation for details on available tags and their contents.

## Testing

Tests are organized under `tests/` with one script per image and Trivy integrated in the shared runner.

- `tests/images/base/test.sh`
- `tests/images/node/test.sh`
- `tests/images/universal/test.sh`
- `tests/run.sh` (shared runner including the CRITICAL Trivy gate)

Local usage:

```bash
# Run tests for a single image (build + smoke + Trivy)
./tests/run.sh base

# Run tests for all images
./tests/run.sh all

# Fast local iteration (skip Trivy)
./tests/run.sh universal --skip-trivy
```

Compatibility wrapper (legacy command style):

```bash
./test.sh universal
```

CI usage:

- The matrix workflow runs image-specific tests for each image.
- Trivy runs inside the same per-image test command before push and fails on CRITICAL findings.

## License

MIT. See `LICENSE`.
