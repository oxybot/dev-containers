---
applyTo: "**/*.Dockerfile"
description: "Use when generating or updating Markdown documentation for a Dockerfile-backed image; enforce a consistent format based on typescript-node.md."
---
When creating documentation for an image defined by a Dockerfile, use a fixed structure and wording style so docs stay consistent across images.

Source of truth for layout and tone:
- Mirror the structure of `typescript-node.md`.
- Infer technical claims from the Dockerfile and repository metadata only.

Required output file rule:
- For `<name>.Dockerfile`, write docs to `<name>.md` in the repository root unless the user requests a different location.

Required section order:
1. `# <Image Name> Dev Container Image`
2. One-paragraph summary of what the image is and what it adds.
3. `## What's Included` with a 2-column table: `Component | Details`.
4. `## Supported Platforms` as bullet list (`linux/amd64`, `linux/arm64` when both are supported).
5. `## Usage` with:
   - `.devcontainer/devcontainer.json` example
   - `Dockerfile` `FROM ...` example
6. `## Available Tags` with table: `Tag | Description`.
7. `## Why Use This Image?` short rationale paragraph.
8. `## Update Cadence` with schedule statement (only if known from workflows or user input).
9. `## Vulnerability Reporting` (only if the repo workflow actually publishes scan artifacts).
10. `## License` with `[MIT](LICENSE)` when applicable.

Formatting requirements:
- Use sentence case headings exactly as shown above.
- Use Markdown tables for included components and tags.
- Use fenced code blocks with explicit language (`json`, `dockerfile`, `bash`).
- Use repository-relative links.
- Keep prose concise and factual. Avoid marketing language and unverifiable claims.

Content extraction rules:
- Base image: from `FROM` line.
- Tool/runtime versions: from pinned versions in Dockerfile and/or referenced base image tag.
- Installed capabilities: from explicit install commands in Dockerfile.
- Tags: use only tags that exist in current docs/workflows or those explicitly provided by the user.
- If a detail is unknown, omit it instead of guessing.

Template to follow:

```md
# <Display Name> Dev Container Image

<One paragraph describing the image purpose and notable additions.>

## What's Included

| Component | Details |
|---|---|
| Base image | `<base-image>` |
| Package managers | `<list>` |
| Key tooling | `<list>` |

## Supported Platforms

- `linux/amd64`
- `linux/arm64`

## Usage

Reference this image in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "My Project",
  "image": "<registry>/<image>:latest"
}
```

Or use it as the base in a custom `Dockerfile`:

```dockerfile
FROM <registry>/<image>:latest

# Add your own customizations
```

## Available Tags

| Tag | Description |
|---|---|
| `latest` | Latest build from the default branch |
| `<tag>` | <meaning> |

## Why Use This Image?

<Short factual rationale.>

## Update Cadence

<Only include when known.>

## Vulnerability Reporting

<Only include when implemented by repository workflows.>

## License

[MIT](LICENSE)
```
