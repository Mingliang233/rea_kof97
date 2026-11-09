# KOF ’97 Arcade MVP

On Windows, double-click **Play-KOF97.cmd**, choose a picture quality, then
click **Start Game**. **Original pixels** keeps hard pixel edges, while
**HQ4x**, **Super Eagle** and **Super xBR** smooth contours. Super Eagle
keeps smaller facial details closer to the original than Super xBR in the
character select screen. The launcher remembers your choice.
MAME opens in a separate window. Press **5 / 6** to insert coins, **1 / 2** to
start the players, and **Tab** to configure keyboards or gamepads. Press
**Esc** to close the arcade window and return to the launcher.

The launcher uses MAME 0.289, the original MVS game and the Europe MVS Ver. 2
BIOS. The game keeps its original character selection, HUD and match rules.
MAME saves player settings under the launcher's Godot user data directory.
The original baseline capture remains under `baseline`.

Keep these files in their workspace locations.

- `tools/godot/Godot*_win64.exe`
- `tools/mame/mame.exe`
- `rom/kof97.zip`
- `rom/neogeo.zip`

To check the launch and return path from PowerShell:

```powershell
$godot = (Get-ChildItem tools/godot/*_win64_console.exe).FullName
& $godot --headless --path launcher -- --smoke-test
```
