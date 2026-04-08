# better_sw_drag_for_moonlight

[English](./README.md) | [简体中文](./README.zh-CN.md)

AutoHotkey scripts for improving SolidWorks drag behavior over Moonlight streaming.

## Overview

This repository focuses on one practical problem in remote CAD workflows:

- middle-mouse drag is not always easy to trigger reliably over Moonlight
- SolidWorks reacts differently to mouse modifiers such as `Alt`, `Shift`, and `Ctrl`
- right-click gestures, context menus, and camera control can conflict with remapping logic

The project provides a small set of scripts to make those interactions easier to debug and tune.

## Included Files

- [`sw.ahk`](./sw.ahk): the main SolidWorks-only drag remap script
- [`moonlight-rbutton-probe.ahk`](./moonlight-rbutton-probe.ahk): a diagnostic probe for streamed right-button and modifier-key input
- [`CHANGELOG.md`](./CHANGELOG.md): release notes and repository history
- [`LICENSE`](./LICENSE): project license

## Current Behavior

The current `sw.ahk` script is designed for SolidWorks only.

- the remap is active only when `SLDWORKS.exe` is the foreground window
- holding right mouse button and pressing `Q` converts the action into middle-mouse drag
- the logic was tuned using real Moonlight-delivered input logs

This repository is intentionally practical rather than abstract. It documents what actually worked during iterative testing.

## Requirements

- Windows
- SolidWorks
- AutoHotkey v2
- Moonlight-based remote streaming workflow

## Quick Start

1. Install AutoHotkey v2.
2. Run [`sw.ahk`](./sw.ahk).
3. Open SolidWorks.
4. Hold right mouse button and press `Q` to trigger middle-mouse drag behavior.

## Input Debugging

Use [`moonlight-rbutton-probe.ahk`](./moonlight-rbutton-probe.ahk) when streamed input behaves unexpectedly.

Typical workflow:

1. Run the probe script.
2. Reproduce the issue in SolidWorks through Moonlight.
3. Inspect the generated log file to see which mouse and keyboard events actually reached Windows.

## Design Notes

- The scripts were developed against real Moonlight input traces, not just expected local behavior.
- Modifier keys such as `Alt` were avoided or deprioritized when they interfered with SolidWorks camera interaction semantics.
- Some versions of the script intentionally favored remote usability over perfect parity with native local mouse behavior.

## Project Status

This is a focused utility repository, not a general remapping framework.

The goal is:

- make one remote SolidWorks workflow better
- keep the scripts small and editable
- preserve enough logs and notes to continue tuning when Moonlight or SolidWorks behavior changes

## License

This project is released under the MIT License. See [`LICENSE`](./LICENSE).
