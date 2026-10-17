@echo off
setlocal
pushd "%~dp0"
if errorlevel 1 exit /b 1
if not exist "..\..\DOSBox\DOSBox-0.74-3\DOSBox.exe" goto missing
start "" "..\..\DOSBox\DOSBox-0.74-3\DOSBox.exe" -conf HW1.CONF -noconsole
goto end
:missing
echo DOSBox.exe was not found.
pause
:end
popd
endlocal
