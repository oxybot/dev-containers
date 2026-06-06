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

### [`typescript-node`](./typescript-node.md)

An image focused on **javascript** and **typescript** development.

```bash
docker pull ghcr.io/oxybot/dev-containers/typescript-node:latest
```

See detailed documentation: [typescript-node.md](./typescript-node.md).

## Variants and versions

Each image may have multiple variants (e.g. different Node.js versions).
Check the individual image documentation for details on available tags and their contents.

## License

MIT. See `LICENSE`.
