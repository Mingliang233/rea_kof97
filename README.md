# KOF ’97 Arcade MVP

A Windows launcher for local two-player play using MAME 0.289 and the original
KOF ’97 MVS ROM. The Godot launcher remembers the selected picture filter.
MAME runs the original game with the Europe MVS Ver. 2 BIOS.

See [launcher setup and controls](launcher/README.md) for local dependencies.
Run `Play-KOF97.cmd` from Windows to start the launcher.

The original-game verification scripts are under `baseline/`. From PowerShell,
run `./baseline/capture.ps1` to reproduce the scripted ADVANCE match between
Kyo and Iori and capture screen and work RAM snapshots. Pass
`-Output baseline/capture-repeat` to save a second run separately.

Git tracks the launcher and capture scripts. Keep the ROMs and extracted
runtimes locally. Generated captures, emulator settings and the REA reference
checkout are local files.
