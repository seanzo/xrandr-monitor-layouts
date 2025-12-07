# XRandr Monitor Layouts

This project provides a set of Bash scripts to easily save and restore X11 monitor layouts using `xrandr`. The main script `xrandr-monitor-layouts` acts as a unified interface to manage your display configurations.

## Features

*   **Save Layouts**: Capture your current monitor setup (positions, resolutions, rotations, primary display) to a named profile.
*   **Restore Layouts**: Apply a previously saved monitor layout.
*   **Unified Interface**: A single script (`xrandr-monitor-layouts`) to manage both saving and restoring.
*   **XDG Base Directory Support**: Layouts are saved in `~/.config/xrandr-monitor-layouts/` by default.

## Dependencies

This utility requires `xrandr`, which is typically available on Linux systems using the X Window System.

## Installation

1.  **Clone the repository (or download the scripts):**

    ```bash
    git clone https://github.com/seanzo/xrandr-monitor-layouts.git
    cd xrandr-monitor-layouts
    ```

2.  **Make the scripts executable:**

    ```bash
    chmod +x xrandr-monitor-layouts save-monitor-state.sh restore-monitor-state.sh
    ```

3.  **Optional: Add `xrandr-monitor-layouts` to your PATH**

    To run the script from any directory, move or link it to a directory in your `PATH` (e.g., `~/bin`):

    ```bash
    mkdir -p ~/bin
    mv xrandr-monitor-layouts ~/bin/
    # Ensure ~/bin is in your PATH. You might need to add this to your ~/.bashrc or ~/.zshrc:
    # export PATH="$HOME/bin:$PATH"
    ```

## Usage

The `xrandr-monitor-layouts` script takes a command (`list`, `save` or `restore`) and for `save` and `restore` commands, a layout name.

### List Available Layouts

To see all your currently saved monitor layouts:

```bash
xrandr-monitor-layouts list
```

### Save a Monitor Layout

To save your current monitor configuration:

```bash
xrandr-monitor-layouts save <layout-name>
```

Replace `<layout-name>` with a descriptive name for your layout (e.g., `home-office`, `dual-monitor`, `laptop-only`).

**Example:**

```bash
xrandr-monitor-layouts save home-office
```

This will create a file named `home-office` in `~/.config/xrandr-monitor-layouts/` containing the details of your current setup.

### Restore a Monitor Layout

To restore a previously saved monitor configuration:

```bash
xrandr-monitor-layouts restore <layout-name>
```

Replace `<layout-name>` with the name of the layout you wish to restore.

**Example:**

```bash
xrandr-monitor-layouts restore dual-monitor
```

If the specified layout does not exist, the script will display an error and list available layouts.

## Layout File Location

Monitor layout files are stored in:

`~/.config/xrandr-monitor-layouts/`

Each file within this directory represents a saved layout.
