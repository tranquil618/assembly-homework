@echo off
masm LOOP.ASM,LOOP.OBJ,LOOP.LST;
if errorlevel 1 goto fail
link LOOP.OBJ;
if errorlevel 1 goto fail
masm JUMP.ASM,JUMP.OBJ,JUMP.LST;
if errorlevel 1 goto fail
link JUMP.OBJ;
if errorlevel 1 goto fail
echo LOOP result:
LOOP
echo JUMP result:
JUMP
goto end
:fail
echo Build failed. Check the error above.
:end
