# Claude Code Docker Container

This repo defines a Docker image and compose setup that runs Claude Code CLI in an isolated Debian Bookworm (slim) environment.

## Environment Context

This project is edited by Claude Code running inside a Linux Docker container, but the files live on a macOS host machine (mounted volume).

### Important Constraints

- **Do NOT run `npm install`, `npm run build`, or any npm/node scripts**
- Do NOT attempt to execute build steps, install dependencies, or start dev servers
- File edits are reflected on the host machine — the container environment does not have the correct node_modules or runtime context to run these commands
- If a build or install step seems necessary, suggest the command for the user to run manually on the host machine instead
