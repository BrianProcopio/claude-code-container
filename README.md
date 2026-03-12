# Claude Code Docker Container

This container provides Claude Code CLI in a Docker environment based on Debian Bookworm (slim).

## Usage

1. Build and run the container:

   ```bash
   docker-compose up -d --build
   ```

2. Access the interactive terminal:
   ```bash
   docker-compose exec claude-code /bin/bash
   ```

## Authentication

You'll need to authenticate with Claude Code the first time you run it. Follow the prompts in the terminal.

### Useful Aliases (Optional)

You can set up aliases on your host system for easier access:

```bash
# Add to your ~/.bashrc or ~/.zshrc
alias claude-code='docker-compose exec claude-code /bin/bash'
```

Then you can use:

```bash
claude-code  # Enter interactive shell
```

## Stopping the Container

```bash
docker-compose down
```

## Configuration

Claude Code configuration is copied into the container at build time from the `config/` directory:

- `config/settings.json` → `/root/.claude/settings.json`
- `config/skills/` → `/root/.claude/skills/`

To update configuration, edit the files in `config/` and rebuild the container.

## Installed Tools

The container comes with the following tools pre-installed:

- **Node.js / npm** — runtime dependency for Claude Code
- **Python 3** (with pip and venv)
- **Git**
- **curl**
- **nano** and **vim-tiny**

## Volume Mounts

| Host Path | Container Path     |
| --------- | ------------------ |
| `~/Sites` | `/workspace/Sites` |
| `~/MCP`   | `/workspace/MCP`   |

All changes to mounted directories are reflected on your host system.
