@echo off
setlocal
for %%G in ("%~dp0tools\godot\Godot*_win64.exe") do (
    if exist "%%~fG" (
        start "" "%%~fG" --path "%~dp0launcher"
        exit /b 0
    )
)
echo Godot Windows executable not found in tools\godot.
pause
exit /b 1
