# [Emoji] iOS 26.4

Adaptive emoji font module for Magisk, KernelSU, and APatch.

This repository packages `Emoji.ttf` into a flashable root module and applies an aggressive runtime repair flow to keep emoji fonts replaced across system and app data locations. The current module metadata is sourced from [`module.prop`](https://github.com/mistu01/MFFMEmoji/blob/main/module.prop).

## Current Module Info

| Field | Value |
| --- | --- |
| ID | `mffmemoji` |
| Name | `[Emoji] iOS 26.4` |
| Version | `22.04.2607` |
| Version code | `220426` |
| Author | `MFFM` |
| Description | Adaptive emoji module with aggressive data-font replacement for Magisk, KernelSU, and APatch. |

## What It Does

- Ships `Emoji.ttf` as the module font payload and stages it as `NotoColorEmoji.ttf`.
- Replaces matching system emoji fonts when full mount mode is available.
- Scans `/data/data` for font files with `emoji` in the filename and replaces them aggressively.
- Restores previously touched data font paths during `post-fs-data` on boot.
- Runs a scheduled repair service after boot, including an initial boot burst and recurring hourly checks.
- Detects updates in previously touched packages and triggers an extra repair pass when needed.
- Writes runtime logs and status files to `/sdcard/EmojiModule` for easier debugging.

## Root Solution Behavior

- `Magisk`: full system scan plus broad `/data/data` font replacement.
- `APatch`: full system scan plus broad `/data/data` font replacement.
- `KernelSU` with metamodule support: full system scan plus broad `/data/data` font replacement.
- `KernelSU` without metamodule support: automatic fallback to data-only mode.

## Runtime Notes

- The module uses an aggressive replacement strategy by design.
- During install-time flashing, it avoids touching the currently active installer host app and known Magisk, KernelSU, and APatch manager packages.
- For packages touched in `/data/data`, cache cleanup is attempted so apps restart with the updated font.
- `com.google.android.gms` is treated specially: cache cleanup is allowed, but it is not force-stopped.

## Logs and Debugging

The module creates these public runtime files:

- `/sdcard/EmojiModule/service.log`
- `/sdcard/EmojiModule/last-status.txt`
- `/sdcard/EmojiModule/README.txt`

Optional debug marker files:

- `/sdcard/EmojiModule/debug`
- `/sdcard/Android/media/EmojiModule/debug`

Verbose logging is currently enabled by default in [`targets.conf`](https://github.com/mistu01/MFFMEmoji/blob/main/targets.conf).

## Repository Layout

- [`module.prop`](https://github.com/mistu01/MFFMEmoji/blob/main/module.prop): module metadata used by Magisk-style installers and release automation.
- [`customize.sh`](https://github.com/mistu01/MFFMEmoji/blob/main/customize.sh): install-time entry point.
- [`post-fs-data.sh`](https://github.com/mistu01/MFFMEmoji/blob/main/post-fs-data.sh): early boot restore logic.
- [`service.sh`](https://github.com/mistu01/MFFMEmoji/blob/main/service.sh): background scheduler for recurring repairs.
- [`action.sh`](https://github.com/mistu01/MFFMEmoji/blob/main/action.sh): manual or scheduled repair runner.
- [`emoji-common.sh`](https://github.com/mistu01/MFFMEmoji/blob/main/emoji-common.sh): shared scan, replacement, cache cleanup, and state logic.
- [`targets.conf`](https://github.com/mistu01/MFFMEmoji/blob/main/targets.conf): behavior and debug configuration.
- [`Emoji.ttf`](https://github.com/mistu01/MFFMEmoji/blob/main/Emoji.ttf): font payload included in the final flashable module.

## Build and Release

GitHub Actions is configured in [`.github/workflows/build-release.yml`](https://github.com/mistu01/MFFMEmoji/blob/main/.github/workflows/build-release.yml) to:

- package the module into a flashable zip
- derive the release title from `module.prop` and the current commit
- name the release asset using the current module name, version, and short commit SHA
- publish a GitHub release automatically on push to `main` or `master`
- allow manual runs through `workflow_dispatch`

## Updating the Module

1. Replace [`Emoji.ttf`](https://github.com/mistu01/MFFMEmoji/blob/main/Emoji.ttf) with the new font payload.
2. Update [`module.prop`](https://github.com/mistu01/MFFMEmoji/blob/main/module.prop) if the module name, version, or description changed.
3. Commit and push to `main` or `master`, or run the workflow manually from GitHub Actions.

## License

This repository includes [`LICENSE`](https://github.com/mistu01/MFFMEmoji/blob/main/LICENSE). Review it before redistributing the module or its assets.
