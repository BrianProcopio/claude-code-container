## Environment

Running inside a Linux Docker container. Project files are mounted from the macOS host — edits are reflected on both sides.

- **Do NOT run `npm install`, `npm run build`, or any npm/node scripts** — the container lacks the correct runtime context. Suggest commands for the user to run on the host instead.
