## Environment

Claude Code itself is running inside a Linux Docker container, but the projects you are working on run locally on the macOS host machine — not in Docker. Project files are mounted from the macOS host — edits are reflected on both sides.

- **The applications and services in any project are running on the host machine**, not in Docker containers, unless explicitly specified otherwise.
- **Do NOT run `npm install`, `npm run build`, or any npm/node scripts** — the container lacks the correct runtime context. Suggest commands for the user to run on the host instead.
