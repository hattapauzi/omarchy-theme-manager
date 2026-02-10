# Omarchy Theme Manager

A comprehensive theme tracking and management system for Omarchy Linux.

## Features

- 📊 **Track All Themes** - Both stock and custom themes with full metadata
- 🔗 **Source Preservation** - Keeps GitHub URLs for easy reinstallation
- 🗑️ **History Tracking** - Remember themes you've uninstalled
- 💾 **Backup & Restore** - Export/import themes across machines
- 🔄 **Auto-Sync** - Automatically detects new and missing themes
- 🎨 **Interactive UI** - Beautiful terminal interface using `gum`

## Installation

The theme manager is already installed at `~/omarchy-theme-manager/`

All scripts are ready to use immediately.

## Quick Start

### Interactive Mode
```bash
~/omarchy-theme-manager/omarchy-theme-manager
```

This launches the interactive menu with options for:
- 📋 List themes
- ➕ Add theme to track
- ⬇️ Install theme
- 🗑️ Remove/uninstall theme
- 💾 Backup themes
- 📥 Restore from backup
- 🔄 Sync with system
- 📊 Statistics

### Direct Commands

```bash
# Initialize manifest (usually automatic)
~/omarchy-theme-manager/omarchy-theme-manager init

# Backup all themes
~/omarchy-theme-manager/omarchy-themes-backup

# Restore from backup
~/omarchy-theme-manager/omarchy-themes-restore /path/to/backup

# Sync with system
~/omarchy-theme-manager/omarchy-themes-sync

# Add a theme
~/omarchy-theme-manager/omarchy-theme-manager add

# Install a theme
~/omarchy-theme-manager/omarchy-theme-manager install theme-name

# Remove a theme
~/omarchy-theme-manager/omarchy-theme-manager remove theme-name
```

## Manifest Structure

The manifest (`manifest.json`) tracks each theme with:

```json
{
  "name": "theme-name",
  "display_name": "Theme Name",
  "type": "custom",        // stock or custom
  "source": "git",         // omarchy, git, or local
  "source_url": "https://github.com/user/repo",
  "status": "installed",   // installed, uninstalled, missing
  "installed_date": "2024-01-15T10:30:00Z",
  "removed_date": null,
  "last_active_date": "2024-02-10T09:00:00Z"
}
```

## Backup Format

Backups are created as directories containing:

```
omarchy-themes-backup-YYYYMMDD-HHMMSS/
├── manifest.json          # Complete theme database
├── themes/                # Custom theme files
│   ├── theme1/
│   ├── theme2/
│   └── ...
└── README.txt            # Backup information
```

## Auto-Tracking

A hook is installed at `~/.config/omarchy/hooks/theme-set` that automatically:
- Updates `last_active_date` when you switch themes
- Adds new custom themes to the manifest if they're not already tracked

## Migration to New Machine

1. **On old machine:**
   ```bash
   ~/omarchy-theme-manager/omarchy-themes-backup
   # Creates ~/omarchy-themes-backup-YYYYMMDD-HHMMSS/
   ```

2. **Transfer backup folder to new machine** (USB, cloud, etc.)

3. **On new machine:**
   ```bash
   ~/omarchy-theme-manager/omarchy-themes-restore /path/to/backup
   # Choose "Full restore" to get everything
   # Or "Merge" to combine with existing themes
   ```

## Statistics

View your theme statistics:
```bash
~/omarchy-theme-manager/omarchy-theme-manager stats
```

Shows:
- Total themes tracked
- Stock vs Custom themes
- Installed vs Uninstalled
- Currently active theme
- Last updated timestamp

## Current Themes

Your manifest currently tracks **30 themes**:
- **14 stock** themes (pre-installed with Omarchy)
- **16 custom** themes (installed from GitHub)

All with complete metadata including source URLs for easy reinstallation!
