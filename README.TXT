Terminal Velocity 1.2 - Stereo Swap Fix for Sound Blaster 16
=============================================================

PROBLEM
  On a Sound Blaster 16 (and compatibles) the game's sound effects and
  music come out of the wrong speakers: left and right are reversed.

CAUSE
  The game mixes its own sound and hands 8-bit stereo data to the DIGPAK
  driver. The mixer writes each left/right sample pair in the order
  (right, left). An SB16 always plays the first byte of a pair on the
  left, so everything is mirrored. The SB16 driver (SB16.COM/SOUNDRV.COM)
  is not at fault.

FIX
  4 bytes in GAME.EXE are changed so the mixer writes (left, right).
  Both the "Stereo" and "Surround" playback modes are fixed. File size
  is unchanged.

  Offset   Original   Patched
  0x54864  88 5D FF   88 5D FE   (stereo mixer)
  0x5486B  88 4D FE   88 4D FF   (stereo mixer)
  0x54E8D  88 18      88 08      (surround mixer)
  0x54E92  88 48 01   88 58 01   (surround mixer)

REQUIRED ORIGINAL FILE
  Terminal Velocity 1.2 (retail CD-ROM release), GAME.EXE:
  Size    624,695 bytes
  CRC32   E995B3E9
  MD5     e9e072a0682e1823bc746fa21f210be9
  SHA-256 46330d8f6e202d2da253bcb447771534eef10030de531311790eb46aa0ab21f1

  After patching: CRC32 1B58E5F5.
  Other versions are refused by TVSTEREO.BAT and left untouched.

HOW TO APPLY (choose one)
  1. In DOS (MS-DOS 5.0 or later, uses DEBUG.EXE from the DOS directory):
     Copy TVSTEREO.BAT and TVSTEREO.SCR into the game directory, then:
         TVSTEREO          apply the fix
         TVSTEREO UNDO     put the original back from GAME.ORG
     DEBUG assembles a small patcher, TVFIX.COM, from TVSTEREO.SCR (fully
     commented 8086 source; read it to see exactly what it does). The
     patcher checks the CRC32 of GAME.EXE first and aborts without
     changing anything unless it is E995B3E9. The original is backed up
     as GAME.ORG, the 4 bytes are written, and the CRC32 of the result
     is checked to be 1B58E5F5. TVFIX.COM is deleted afterwards.
     DEBUG prints "^ Error" for each comment line in TVSTEREO.SCR (it has
     no comment syntax); this is harmless, and the batch file hides it.

  2. By hand: change the bytes listed above with a hex editor.

  If you play on a card where the original game sounded correct, this
  patch will reverse it. Restore the original GAME.EXE to undo it.
