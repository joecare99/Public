# Unit1 BMP-to-JPEG output-name helper

## Recovered contract

Unit1's retained listing at `005FCB74` takes an input path and output string.
It calls `ExtractFileName`, deletes the final character three times, then
appends the lowercase literal `jpg`. It does not validate the source extension
or preserve the input directory. For example,
`C:\incoming\Family.BMP` becomes `Family.jpg`; a two-character basename
becomes `jpg`.

The caller `TForm1.bmpjpg1Click` invokes this helper after selecting a BMP,
then combines the returned basename with its destination directory and calls
`SaveToFile`. That dialog, directory mutation, image loading/conversion, and
file write remain outside this reconstruction.

## Current Pascal and tests

The current FPC implementation already exists as
`TForm1.Proc_005FBFD8` in `Source\AhnWin52\frmAhnenWinMain.pas`; it preserves
the three repeated `Delete` operations. Added synthetic tests to
`tst_AHW52_MainFormPureHelperTests` for basename extraction, unvalidated
extension truncation, short names, and empty input. These invoke only the
helper on an in-memory string and do not execute the menu handler or access
files. The FPCUnit test project builds, and the focused class passes 3/3.
