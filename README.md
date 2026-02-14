# omarchy-theme-manager

Foundation CLI for tracking Omarchy themes and restoring them across systems.

This project does not replace Omarchy's installer. It uses Omarchy commands directly (`omarchy-theme-install`) and adds lifecycle tracking (`installed` / `removed`) with a registry file.

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

Clone and install:

```bash
git clone https://github.com/hattapauzi/omarchy-theme-manager.git
cd omarchy-theme-manager
chmod +x bin/otm
chmod +x scripts/install.sh
chmod +x scripts/uninstall.sh
bash ./scripts/install.sh
```

Optional convenience symlink:

```bash
ln -sf "$PWD/bin/otm" "$HOME/.local/bin/otm"
```

## Uninstall

Remove the installed `otm` symlink:

```bash
bash ./scripts/uninstall.sh
```

Remove the symlink and delete registry data:

```bash
bash ./scripts/uninstall.sh --remove-registry
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
otm list [--installed|--removed|--all]
otm remove <theme>
otm restore <theme>
otm export [file]
otm import [file]
```

### Behavior summary

- `scan`: reads local theme directories from `~/.config/omarchy/themes/` and syncs registry.
- `add`: installs via `omarchy-theme-install <url>`, then records URL + metadata.
- `list`: includes a `TYPE` column (`official` or `community`) and shows built-in Omarchy themes even if they are not yet tracked in the registry.
- `remove`: deletes local theme directory and marks as removed in registry.
- `restore`: reinstalls removed theme from saved URL.
- `export`: writes lock file (default `themes.lock.json`).
- `import`: bulk install all entries with `status=installed` and `source_url` present.

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
otm import themes.lock.json
```

## Exit codes

- `0`: success
- `1`: usage or validation error
- `2`: command execution failure (install/import failure)
- `3`: missing dependency
