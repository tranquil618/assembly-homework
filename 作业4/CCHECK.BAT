@echo off
wcl -za99 -bt=dos -0 -ms -od -d2 -fo=checkg.obj -fe=checkg.exe -fm=checkg.map checkg.c
if errorlevel 1 goto fail
wdis checkg.obj -s=checkg.c -l=checkg.dis
if errorlevel 1 goto fail
wcl -za99 -bt=dos -0 -ms -od -d2 -fo=checkl.obj -fe=checkl.exe -fm=checkl.map checkl.c
if errorlevel 1 goto fail
wdis checkl.obj -s=checkl.c -l=checkl.dis
if errorlevel 1 goto fail
echo Build succeeded. Run CHECKG or CHECKL.
goto end
:fail
echo Build failed.
:end
