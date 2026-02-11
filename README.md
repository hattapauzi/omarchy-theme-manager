# omarchy-theme-manager

Foundation CLI for tracking Omarchy themes and restoring them across systems.

This project does not replace Omarchy's installer. It uses Omarchy commands directly (`omarchy-theme-install`) and adds lifecycle tracking (`installed` / `archived`) with a registry file.

## Goals covered (V1)

1. Sync and save installed themes on the current system.
2. Soft-delete themes you do not want right now, while keeping source URLs for restore.
3. Reinstall tracked themes on another Omarchy system without manual per-theme work.

## Safety rules

- Never writes to `~/.local/share/omarchy/`.
- Writes only to:
  - `~/.config/omarchy-theme-manager/registry.json`
  - `~/.config/omarchy/themes/` (remove operation only)
  - local export file (default `themes.lock.json`)

## Requirements

- `bash`
- `jq`
- Omarchy command available in `PATH`: `omarchy-theme-install`

## Install

From this repo:

```bash
chmod +x bin/otm
chmod +x scripts/install.sh
./scripts/install.sh
```

Optional convenience symlink:

```bash
ln -sf "$PWD/bin/otm" "$HOME/.local/bin/otm"
```

## Registry

Canonical registry path:

`~/.config/omarchy-theme-manager/registry.json`

Schema (V1):

```json
{
  "version": 1,
  "updated_at": "2026-02-11T15:30:00Z",
  "machine_id": "host-abc123",
  "themes": [
    {
      "name": "catppuccin",
      "source_url": "https://github.com/example/omarchy-catppuccin-theme.git",
      "status": "installed",
      "origin": "example",
      "installed_at": "2026-02-10T10:00:00Z",
      "removed_at": null,
      "last_action": "add"
    }
  ]
}
```

Unknown-source themes discovered by `scan` are kept as `installed` with `source_url: null`.
When a source URL is available, `origin` is set to the repository author/org.

## Commands

```bash
otm scan
otm add <git-url>
otm list [--installed|--archived|--all]
otm remove <theme>
otm restore <theme>
otm export [file]
otm apply [file]
```

### Behavior summary

- `scan`: reads local theme directories from `~/.config/omarchy/themes/` and syncs registry.
- `add`: installs via `omarchy-theme-install <url>`, then records URL + metadata.
- `remove`: soft-remove; deletes local theme directory and archives metadata.
- `restore`: reinstalls archived theme from saved URL.
- `export`: writes lock file (default `themes.lock.json`).
- `apply`: bulk install all entries with `status=installed` and `source_url` present.

## Typical flows

Track what is currently installed:

```bash
otm scan
otm list --installed
```

Install and track a new theme from GitHub:

```bash
otm add https://github.com/acme/omarchy-solarized-theme.git
```

Archive a theme now and restore later:

```bash
otm remove solarized
otm restore solarized
```

Move to another machine:

```bash
otm export themes.lock.json
# copy themes.lock.json to new system
otm apply themes.lock.json
```

## Exit codes

- `0`: success
- `1`: usage or validation error
- `2`: command execution failure (install/apply failure)
- `3`: missing dependency
