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

## Playwright & Virtual Display

The container includes Playwright with Chromium and a virtual display (Xvfb) so browser automation works headlessly inside Docker.

### How it works

The `entrypoint.sh` script automatically starts:

1. **Xvfb** — virtual framebuffer on `:99` (1920×1080)
2. **Fluxbox** — lightweight window manager
3. **x11vnc** — VNC server on port 5900
4. **noVNC** — web-based VNC client on port 6080

### Viewing the browser (optional)

To watch Playwright tests run in real-time, open the noVNC client in your host browser:

```
http://localhost:6080/vnc.html
```

No password is required.

### Running Playwright tests

Inside the container:

```bash
# Run tests headlessly (default — no display needed)
npx playwright test

# Run in headed mode (visible via noVNC)
npx playwright test --headed
```

The `DISPLAY=:99` environment variable is already set, so headed mode works out of the box.

### Shared memory

`docker-compose.yml` sets `shm_size: "256m"` to prevent Chromium from crashing due to the default 64MB `/dev/shm` limit.

## Installed Tools

The container comes with the following tools pre-installed:

- **Node.js / npm** — runtime dependency for Claude Code
- **Python 3** (with pip and venv)
- **Playwright** (with Chromium)
- **Xvfb / noVNC** — virtual display and web-based VNC viewer
- **Git**
- **curl**
- **nano** and **vim-tiny**

## Volume Mounts

| Host Path   | Container Path     |
|-------------|--------------------|
| `~/Sites`   | `/workspace/Sites` |
| `~/MCP`     | `/workspace/MCP`   |

All changes to mounted directories are reflected on your host system.

## Ports

| Host              | Container | Service          |
|-------------------|-----------|------------------|
| `127.0.0.1:6080`  | `6080`    | noVNC web client |

The noVNC port is bound to localhost only for security.
