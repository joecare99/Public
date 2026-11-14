program DeDeReconstructionTests;

{$APPTYPE CONSOLE}

uses
  Forms, TextTestRunner,
  ReconstructionTests in 'ReconstructionTests.pas';

begin
  Application.Initialize;
  RunRegisteredTests(rxbHaltOnFailures);
end.
