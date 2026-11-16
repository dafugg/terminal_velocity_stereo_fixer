@ECHO OFF
REM TVSTEREO.BAT - Terminal Velocity 1.2 stereo fix for Sound Blaster 16.
REM Run in the game directory:  TVSTEREO       apply the fix
REM                             TVSTEREO UNDO  restore GAME.ORG
REM DEBUG assembles a small patcher (TVFIX.COM) from TVSTEREO.SCR. It
REM checks GAME.EXE's CRC32 (original = E995B3E9), changes 4 bytes,
REM then checks the result (patched = 1B58E5F5). See README.TXT.

IF "%1"=="UNDO" GOTO UNDO
IF "%1"=="undo" GOTO UNDO
IF NOT EXIST GAME.EXE GOTO NOGAME
IF NOT EXIST TVSTEREO.SCR GOTO NOSCR

IF EXIST TVFIX.COM DEL TVFIX.COM
DEBUG < TVSTEREO.SCR > NUL
IF NOT EXIST TVFIX.COM GOTO NODEBUG

REM Check only. 0=original 1=can't open 2=unknown 3=patched 4=read error
ECHO Checking GAME.EXE...
TVFIX
IF ERRORLEVEL 4 GOTO READERR
IF ERRORLEVEL 3 GOTO ALREADY
IF ERRORLEVEL 2 GOTO UNKNOWN
IF ERRORLEVEL 1 GOTO NOOPEN

IF EXIST GAME.ORG GOTO PATCH
ECHO Backing up GAME.EXE to GAME.ORG...
COPY GAME.EXE GAME.ORG > NUL
IF NOT EXIST GAME.ORG GOTO NOBACKUP

:PATCH
ECHO Patching GAME.EXE...
TVFIX P
IF ERRORLEVEL 1 GOTO WRITEERR
DEL TVFIX.COM
ECHO Done. GAME.EXE patched: stereo channels fixed for Sound Blaster 16.
GOTO END

:UNDO
IF NOT EXIST GAME.ORG GOTO NOORG
COPY GAME.ORG GAME.EXE > NUL
ECHO GAME.EXE restored from GAME.ORG.
GOTO END

:ALREADY
DEL TVFIX.COM
ECHO GAME.EXE is already patched. Nothing to do.
GOTO END

:UNKNOWN
DEL TVFIX.COM
ECHO GAME.EXE is not Terminal Velocity 1.2 (CRC32 E995B3E9). Not changed.
GOTO END

:NOOPEN
DEL TVFIX.COM
ECHO Cannot open GAME.EXE for writing (read-only?). Not changed.
GOTO END

:READERR
DEL TVFIX.COM
ECHO Error reading GAME.EXE. Not changed.
GOTO END

:NOBACKUP
DEL TVFIX.COM
ECHO Could not create backup GAME.ORG (disk full?). Not changed.
GOTO END

:WRITEERR
DEL TVFIX.COM
ECHO Error writing or verifying GAME.EXE! Restore it with: TVSTEREO UNDO
GOTO END

:NOGAME
ECHO GAME.EXE not found. Run this in the Terminal Velocity directory.
GOTO END

:NOSCR
ECHO TVSTEREO.SCR not found. Copy it to this directory too.
GOTO END

:NOORG
ECHO GAME.ORG not found. Nothing to restore.
GOTO END

:NODEBUG
ECHO DEBUG failed to create TVFIX.COM. Is DEBUG.EXE on your PATH?

:END
