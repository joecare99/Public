program AHNWIN51;

{-------------------------------------------------------------------------------
  AHNWIN51 - AHNENWIN 5.1, reconstructed from the IDR disassembly.

  This project is a from-scratch Delphi reconstruction of the original
  AHNENWIN 5.1 genealogy program, based exclusively on the IDR
  (Interactive Delphi Reconstructor) disassembly in
  Source\Projects_AhnenWin\.

  Structure:
    Units\                the application units (Unit1 .. Unit40)
    Forms\                the original DFM resources, unchanged
    Compat\QuickReport\   QuickReport compatibility stubs
    Compat\WPPDF\         WPPDFDelphi compatibility stubs
    tools\                StreamCheck (resource verification) and gen-unit
    docs\                 cross reference and reconstruction evidence

  Build with build.cmd (Delphi 9 / RAD Studio 3.0 + BDE 5.2).
-------------------------------------------------------------------------------}

uses
  SysUtils, Classes, Forms,
  Unit1  in 'Units\Unit1.pas',
  Unit2  in 'Units\Unit2.pas',
  Unit3  in 'Units\Unit3.pas',
  Unit4  in 'Units\Unit4.pas',
  Unit5  in 'Units\Unit5.pas',
  Unit6  in 'Units\Unit6.pas',
  Unit7  in 'Units\Unit7.pas',
  Unit8  in 'Units\Unit8.pas',
  Unit9  in 'Units\Unit9.pas',
  Unit10 in 'Units\Unit10.pas',
  Unit11 in 'Units\Unit11.pas',
  Unit12 in 'Units\Unit12.pas',
  Unit13 in 'Units\Unit13.pas',
  Unit14 in 'Units\Unit14.pas',
  Unit15 in 'Units\Unit15.pas',
  Unit16 in 'Units\Unit16.pas',
  Unit17 in 'Units\Unit17.pas',
  Unit18 in 'Units\Unit18.pas',
  Unit19 in 'Units\Unit19.pas',
  Unit20 in 'Units\Unit20.pas',
  Unit21 in 'Units\Unit21.pas',
  Unit22 in 'Units\Unit22.pas',
  Unit23 in 'Units\Unit23.pas',
  Unit24 in 'Units\Unit24.pas',
  Unit25 in 'Units\Unit25.pas',
  Unit26 in 'Units\Unit26.pas',
  Unit27 in 'Units\Unit27.pas',
  Unit28 in 'Units\Unit28.pas',
  Unit29 in 'Units\Unit29.pas',
  Unit30 in 'Units\Unit30.pas',
  Unit31 in 'Units\Unit31.pas',
  Unit32 in 'Units\Unit32.pas',
  Unit33 in 'Units\Unit33.pas',
  Unit34 in 'Units\Unit34.pas',
  Unit35 in 'Units\Unit35.pas',
  Unit36 in 'Units\Unit36.pas',
  Unit37 in 'Units\Unit37.pas',
  Unit38 in 'Units\Unit38.pas',
  Unit39 in 'Units\Unit39.pas',
  Unit40 in 'Units\Unit40.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AHNENWIN 5.1';
  Application.Run;
end.
