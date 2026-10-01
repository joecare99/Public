# AhnWin52 FPCUnit test sources

This directory contains the registered FPCUnit suites for the reconstructed
AhnWin52 code. The project file is kept separately at
`FPC\AhnWin52Tests.lpi`, alongside the other FreePascal/Lazarus projects.
Each suite imports `fpcunit`, `testutils`, and `testregistry`, following the
structure of `Source\Test_Gen\tst_GedComFile.pas`.

Build and run the full suite from the Genealogie project root:

```powershell
C:\Lazarus\lazbuild.exe FPC\AhnWin52Tests.lpi
.\bin\x86_64-win64\AhnWin52Tests.exe --all --format=plain
```

The suites use synthetic in-memory datasets and temporary files only. They do
not open genealogy databases or launch the application.
