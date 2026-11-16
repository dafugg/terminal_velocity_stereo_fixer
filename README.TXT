Terminal Velocity - Stereo Swap Fix for Sound Blaster 16
========================================================

PROBLEM
  On a Sound Blaster 16 (and compatibles) the game's sound effects and
  music come out of the wrong speakers: left and right are reversed.

CAUSE
  The game mixes its own sound and hands 8-bit stereo data to the DIGPAK
  driver. The mixer writes each left/right sample pair in the order
  (right, left). An SB16 always plays the first byte of a pair on the
  left, so everything is mirrored. The SB16 driver (SB16.COM/SOUNDRV.COM)
  is not at fault. Every release below has the same mixer code.

FIX
  4 bytes in GAME.EXE are changed so the mixer writes (left, right).
  Both the "Stereo" and "Surround" playback modes are fixed. File size
  is unchanged.

  Full version offsets   Original   Patched
  0x54864                88 5D FF   88 5D FE   (stereo mixer)
  0x5486B                88 4D FE   88 4D FF   (stereo mixer)
  0x54E8D                88 18      88 08      (surround mixer)
  0x54E92                88 48 01   88 58 01   (surround mixer)
  In the shareware versions the same bytes are 0x20 later
  (0x54884, 0x5488B, 0x54EAD, 0x54EB2).

SUPPORTED VERSIONS (GAME.EXE)
  Version          Size      CRC32 original   CRC32 patched
  Full 1.2         624,695   E995B3E9         1B58E5F5
  Full 1.1         620,599   26794CEB         382746ED
  Shareware 1.2    620,459   DEB1ECFE         9EEBD204
  Shareware 1.1    620,459   A433F94B         E469C7B1

  Any other GAME.EXE is refused by TVSTEREO.BAT and left untouched.

HOW TO APPLY
  1. In DOS (MS-DOS 5.0 or later, uses DEBUG.EXE from the DOS directory):
     Copy TVSTEREO.BAT and TVSTEREO.SCR into the game directory, then:
         TVSTEREO          apply the fix
         TVSTEREO UNDO     put the original back from GAME.ORG
     DEBUG assembles a small patcher, TVFIX.COM, from TVSTEREO.SCR (fully
     commented 8086 source; read it to see exactly what it does). The
     patcher computes the CRC32 of GAME.EXE first and aborts without
     changing anything unless it matches one of the versions above. The
     original is backed up as GAME.ORG, the 4 bytes are written, and the
     CRC32 of the result is checked against that version's patched value.
     TVFIX.COM is deleted afterwards.
     DEBUG prints an error for each comment line in TVSTEREO.SCR (it has
     no comment syntax); this is harmless, and the batch file hides it.

  2. By hand: change the bytes listed above with a hex editor, after
     checking the CRC32 of your GAME.EXE against the table.

  If you play on a card where the original game sounded correct, this
  patch will reverse it. Restore the original GAME.EXE to undo it.
