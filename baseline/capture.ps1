param(
    [string]$Schedule = (Join-Path $PSScriptRoot 'join-match.lua'),
    [string]$Output = (Join-Path $PSScriptRoot 'capture'),
    [int]$Seconds = 136
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$env:KOF97_INPUT_SCRIPT = (Resolve-Path -LiteralPath $Schedule).Path
$env:KOF97_CAPTURE_DIR = (New-Item -ItemType Directory -Path $Output -Force).FullName
& "$root/tools/mame/mame.exe" kof97 -rompath "$root/rom" -bios euro -noreadconfig `
    -cfg_directory "$PSScriptRoot/cfg" -nvram_directory "$PSScriptRoot/nvram" -nonvram_save `
    -video none -sound none -nothrottle -skip_gameinfo -seconds_to_run $Seconds `
    -autoboot_delay 0 -autoboot_script "$PSScriptRoot/capture.lua"
if ($LASTEXITCODE -ne 0) { throw "MAME exited with code $LASTEXITCODE" }
