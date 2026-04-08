# better_sw_drag_for_moonlight

AutoHotkey scripts for making SolidWorks camera drag work better over Moonlight streaming.

## What this project does

This project focuses on one annoying remote-workflow problem:

- native middle-mouse drag is not always easy to trigger reliably through Moonlight
- SolidWorks reacts differently to modifier keys such as `Alt`, `Shift`, and `Ctrl`
- right-click gestures and context-menu behavior can conflict with drag remapping

The current solution provides:

- a SolidWorks-only AutoHotkey script: [`sw.ahk`](./sw.ahk)
- an input probe script for debugging streamed mouse and keyboard events: [`moonlight-rbutton-probe.ahk`](./moonlight-rbutton-probe.ahk)

## Current key behavior

In the current `sw.ahk` script:

- the remap is active only when `SLDWORKS.exe` is the foreground window
- holding right mouse button and pressing `Q` converts the action into middle-mouse drag
- this is intended for view rotation in SolidWorks over Moonlight

The script was tuned specifically around Moonlight-delivered input behavior observed during testing.

## Files

- [`sw.ahk`](./sw.ahk): main SolidWorks drag remap script
- [`moonlight-rbutton-probe.ahk`](./moonlight-rbutton-probe.ahk): diagnostic logger for right-button and modifier-key behavior over streaming

## Requirements

- AutoHotkey v2
- SolidWorks on Windows
- Moonlight streaming workflow

## Usage

1. Install AutoHotkey v2.
2. Run `sw.ahk`.
3. Open SolidWorks.
4. Hold right mouse button and press `Q` to trigger middle-mouse drag behavior.

For debugging streamed input:

1. Run `moonlight-rbutton-probe.ahk`.
2. Reproduce the input issue in SolidWorks.
3. Inspect the generated log file to see which mouse and modifier events actually reached Windows.

## Notes

- The script was developed experimentally against real Moonlight input logs.
- Some design choices intentionally prioritize remote-control stability over perfectly native local mouse behavior.
- Modifier keys such as `Alt` were avoided because they interfere with SolidWorks interaction semantics.
