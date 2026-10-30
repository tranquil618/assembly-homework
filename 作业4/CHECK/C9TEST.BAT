@echo off
wcl -za99 -bt=dos -0 -ms -od -d2 -fo=checkg.obj -fe=checkg.exe -fm=checkg.map checkg.c > CHECK\checkg.log
if errorlevel 1 goto fail
checkg > CHECK\checkg.out
wdis checkg.obj -s=checkg.c -l=checkg.dis
wcl -za99 -bt=dos -0 -ms -od -d2 -fo=checkl.obj -fe=checkl.exe -fm=checkl.map checkl.c > CHECK\checkl.log
if errorlevel 1 goto fail
checkl > CHECK\checkl.out
wdis checkl.obj -s=checkl.c -l=checkl.dis
echo SUCCESS > CHECK\C9DONE.TXT
goto end
:fail
echo FAILED > CHECK\C9DONE.TXT
:end
