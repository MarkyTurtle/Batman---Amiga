# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

An original Amiga A500 platformer written from scratch in M68000 assembly. It is a new project (not a disassembly) exploring 8-way tile-map scrolling with double buffering, built using VSCode and the Amiga Assembly extension.

## Build & Run

Building and running requires the **Amiga Assembly** VSCode extension with `vasm` and `vlink` binaries configured in `amiga-assembly.binDir`.

- **Build**: `Ctrl+Shift+B` in VSCode (runs `amigaassembly: build` task), or via `.vscode/tasks.json`
- **Run/Debug**: F5 in VSCode — two launch configs in `.vscode/launch.json`:
  - `FS-UAE Debug` — Linux emulator (primary for this environment)
  - `WinUAE Debug` — Windows emulator
- The build output goes to `uae/dh0/platformer`; the emulator mounts `uae/dh0/` as `SYS:` (hard drive DH0)
- The startup sequence in `uae/dh0/s/startup-sequence` runs `platformer` on boot

Build command line (manual):
```
vasmm68k_mot -m68000 -Fhunk -linedebug platformer.s ...
vlink -bamigahunk -Bstatic -o ../uae/dh0/platformer platformer.o ...
```

## Architecture

All code lives in `platformer.s` — a single assembly file. Include files are in `include/` (Amiga system headers), and `libs/controller_ports.s` is included at the bottom of the main file.

### Display

- **4 interleaved bitplanes**, 16 colours
- Display buffer (`bitplanes`): 336×272 pixels (`BITPLANE_WIDTH_BYTES=42`, `BITPLANE_HEIGHT_LINES=272`) interleaved — one row of bitplane 1 is followed immediately by one row of bitplane 2, etc. Row stride for a single bitplane is therefore `BITPLANE_WIDTH_BYTES * 4 = 168` bytes.
- Visible area: 320×256. The extra 16 pixels/lines provide the off-screen tile column and row needed for smooth scrolling.
- `a6` is always loaded with `CUSTOM` ($DFF000) for hardware register access.

### Copper List (`copperlist`)

- Sets display window (DIWSTRT/DIWSTOP), bitplane modulo, BPLCON0/1/2/3/4.
- `copper_bpl_ptrs` — bitplane pointers for the top of the display (updated every frame by `_set_copper_display_values`).
- `copper_bpl_wrap_ptrs` — bitplane pointers used after the vertical wrap point, placed after `copper_bpl_wrap_wait` (a copper WAIT instruction at the raster line where the display buffer wraps around).
- `copper_scroll` (BPLCON1) — hardware pixel-level horizontal scroll delay.

### Tile Scroller

The scroller implements 8-way smooth tile-map scrolling. Scroll state is split into:

| Variable | Purpose |
|---|---|
| `world_window_x/y` | Current world pixel position (top-left of display window) |
| `soft_scroll_x` | BPLCON1 pixel delay value (0–15 pixels, replicated for odd/even bitplanes) |
| `hard_scroll_x` | Byte offset into display buffer for horizontal position |
| `line_scroll_y` | Raster line offset — which line of the display buffer is the top of screen |
| `split_scroll_y` | Copper WAIT raster line for the vertical buffer wrap |
| `hard_scroll_y` | Byte offset to the top of the vertical scroll position |
| `tile_scroll_y` | Tile-row index for the top of the window |

Key scroller routines:
- `scroll_initialise` — sets up scroll state from the tilemap header
- `scroll_window` — entry point; takes d0/d1 delta x/y, updates world position, calculates display offsets, updates the copper
- `_scroll_blit_column` — blits one column of new tiles when a hard-scroll step occurs (x-axis)
- `_scroll_blit_row` — blits one row of new tiles when a hard-scroll step occurs (y-axis)
- `_set_copper_display_values` — writes computed scroll values into the copper list every frame

### Double Buffering (in progress)

Data structures for double buffering are partially implemented but not yet wired up. `scrollerStructure` holds pointers to `scrollBuffer1` and `scrollBuffer2`. Each scroll buffer holds its own copy of all display-offset variables (using the `SCRBUF_*` offsets defined via `rsreset`). `initialise_scroll_buffer` initialises one buffer. The current scroller still uses flat global variables rather than these structures.

### Tile Blitter

- `blit_tile` — calculates source/dest pointers and calls `blit_16x16`
- `blit_16x16` — uses the Amiga blitter (channel A→D, minterm $09f0) to copy a 16×16 tile into the interleaved display buffer. Blitter row width is 1 word; blit size is `(64<<6)+1` (64 rows × 1 word, covering 4 interleaved bitplanes × 16 lines).
- `display_screen` — draws a full screen of tiles from an arbitrary tilemap position; used for the initial render.

### Tilemap Format

`tilemap` (from `TileMap192x42.raw.flipped`):
- Header: 2 bytes width (tiles), 2 bytes height (tiles)
- Data: `width × height` bytes of tile indices, one byte per tile
- Map is 192 tiles wide × 42 tiles tall; stored vertically flipped (hence `.flipped`)

`tilegfx` (from `TileGFX.raw`): 128 bytes per tile (`16px × 16px × 4bpl interleaved`), tiles packed sequentially.

### Input (VBL — level 3 interrupt)

The level 3 interrupt handler reads joystick port 2 via `controller_ports_read` (from `libs/controller_ports.s`) and calls `scroll_window` with ±2 pixel deltas per direction. `controller_port2_state` holds the decoded state as bit flags (`JOYSTICK_LEFT/RIGHT/UP/DOWN/BUTTON1/2/3`).

The level 3 interrupt also handles copper (bit 4), vertical blank (bit 5), and blitter (bit 6) interrupts. Scroll position update and copper reprogramming happen every VBL.

### Debug Colour Convention

`$dff180` (COLOR00) is written with debug colours during scroll processing to visualise timing on a real machine or scope: `$fff` = scroll entry, `$0ff` = display offsets calculated, `$0f00` = copper updated. These can be removed once double buffering is stable.
