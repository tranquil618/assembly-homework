@echo off
wcl -bt=dos -0 -ms -od -d2 -fo=sumc.obj -fe=sumc.exe -fm=sumc.map sum.c
if errorlevel 1 goto fail
wcl -bt=dos -0 -ms -od -d2 -fo=sumnc.obj -fe=sumnc.exe -fm=sumnc.map sumn.c
if errorlevel 1 goto fail
echo Build succeeded. Run SUMC or SUMNC.
goto end
:fail
echo Build failed. Fix the error above before running.
:end
