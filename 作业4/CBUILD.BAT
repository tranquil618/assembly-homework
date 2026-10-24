@echo off
wcl -za99 -bt=dos -0 -ms -od -d2 -fo=tablec.obj -fe=tablec.exe -fm=tablec.map table.c
if errorlevel 1 goto end
wdis TABLEC.OBJ -s=TABLE.C -l=TABLEC.DIS
:end
