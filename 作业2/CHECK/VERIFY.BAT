@echo off
wcl -bt=dos -0 -ms -od -d2 -fo=sumc.obj -fe=sumc.exe -fm=sumc.map sum.c > CHECK\SUMC.LOG
if errorlevel 1 goto fail
wcl -bt=dos -0 -ms -od -d2 -fo=sumnc.obj -fe=sumnc.exe -fm=sumnc.map sumn.c > CHECK\SUMNC.LOG
if errorlevel 1 goto fail
if not exist SUMC.EXE goto fail
if not exist SUMNC.EXE goto fail
SUMC > CHECK\SUMC.OUT
SUMNC < CHECK\N1.IN > CHECK\N1.OUT
SUMNC < CHECK\N5.IN > CHECK\N5.OUT
SUMNC < CHECK\N100.IN > CHECK\N100.OUT
SUMNC < CHECK\N0.IN > CHECK\N0.OUT
SUMNC < CHECK\N101.IN > CHECK\N101.OUT
SUMNC < CHECK\BAD.IN > CHECK\BAD.OUT
wdis SUMC.OBJ -s=SUM.C -l=SUMC.DIS > CHECK\DIS1.LOG
wdis SUMNC.OBJ -s=SUMN.C -l=SUMNC.DIS > CHECK\DIS2.LOG
echo FINISHED > CHECK\DONE.TXT
goto end
:fail
echo FAILED > CHECK\DONE.TXT
:end
