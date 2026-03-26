# Claude Code Docker Container

This repo defines a Docker image and compose setup that runs Claude Code CLI in an isolated Debian Bookworm (slim) environment.

## Environment Context

Claude is running inside a Linux Docker container. Any project being worked on also exists inside that container, with its files mounted from the macOS host machine. This means file edits made inside the container are immediately reflected on the host.

### Important Constraints

- **Do NOT run `npm install`, `npm run build`, or any npm/node scripts**
- Do NOT attempt to execute build steps, install dependencies, or start dev servers
- The container does not have the correct `node_modules` or runtime context to run these commands — they must be run on the host machine
- If a build or install step seems necessary, suggest the command for the user to run manually on the host machine instead
