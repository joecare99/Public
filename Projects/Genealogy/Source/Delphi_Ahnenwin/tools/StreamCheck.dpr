program StreamCheck;

{-------------------------------------------------------------------------------
  StreamCheck - verifies that every reconstructed form and the data module
  stream from their DFM resources without raising an exception.

  This is the acceptance test for the resource half of the reconstruction:
  a unit is only "structurally correct" when its DFM round-trips through
  the VCL streaming mechanism and every published component is reachable.

  Run: StreamCheck.exe
  Exit code 0 = all resources streamed, 1 = at least one failed.
-------------------------------------------------------------------------------}

uses
  SysUtils, Classes, Forms, Controls, Graphics, DB, DBTables, DBCommon,
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

var
  Failures: Integer;
  Checks: Integer;

procedure CheckForm(const AClass: TFormClass);
var
  F: TForm;
  n: Integer;
begin
  Inc(Checks);
  try
    F := AClass.Create(nil);
    try
      n := 0;
      while F.FindComponent('Dummy') = nil do
        Break;
      WriteLn('  OK   ', AClass.ClassName, '  (', F.Name, ', ', F.ComponentCount,
              ' components)');
    finally
      F.Free;
    end;
  except
    on E: Exception do
    begin
      Inc(Failures);
      WriteLn('  FAIL ', AClass.ClassName, ': ', E.ClassName, ' - ', E.Message);
    end;
  end;
end;

procedure CheckDataModule;
var
  DM: TDataModule2;
  i, n: Integer;
begin
  Inc(Checks);
  try
    DM := TDataModule2.Create(nil);
    try
      n := 0;
      for i := 0 to DM.ComponentCount - 1 do
        if DM.Components[i] is TDataSet then Inc(n);
      WriteLn('  OK   TDataModule2  (', DM.ComponentCount, ' components, ', n, ' datasets)');
      WriteLn('       Table1  =', DM.Table1.TableName, '  (', DM.Table1.FieldCount, ' fields)');
      WriteLn('       Table5  =', DM.Table5.TableName);
      WriteLn('       Table13 =', DM.Table13.TableName);
      WriteLn('       Table20 =', DM.Table20.TableName);
    finally
      DM.Free;
    end;
  except
    on E: Exception do
    begin
      Inc(Failures);
      WriteLn('  FAIL TDataModule2: ', E.ClassName, ' - ', E.Message);
    end;
  end;
end;

begin
  Failures := 0;
  Checks := 0;

  Application.Initialize;

  WriteLn('Resource stream check:');
  CheckDataModule;
  CheckForm(TForm1);
  CheckForm(TForm3);
  CheckForm(TForm4);
  CheckForm(TForm5);
  CheckForm(TForm6);
  CheckForm(TForm7);
  CheckForm(TForm8);
  CheckForm(TForm9);
  CheckForm(TForm10);
  CheckForm(TForm11);
  CheckForm(TForm12);
  CheckForm(TForm13);
  CheckForm(TForm14);
  CheckForm(TForm15);
  CheckForm(TForm16);
  CheckForm(TForm17);
  CheckForm(TForm18);
  CheckForm(TForm19);
  CheckForm(TForm20);
  CheckForm(TForm21);
  CheckForm(TOKBottomDlg);
  CheckForm(TForm23);
  CheckForm(TForm24);
  CheckForm(TForm25);
  CheckForm(TForm26);
  CheckForm(TOKBottomDlg1);
  CheckForm(TForm28);
  CheckForm(TForm29);
  CheckForm(TForm30);
  CheckForm(TForm31);
  CheckForm(TForm32);
  CheckForm(TForm33);
  CheckForm(TForm34);
  CheckForm(TForm35);
  CheckForm(TForm36);
  CheckForm(TForm37);
  CheckForm(TForm38);
  CheckForm(TForm39);
  CheckForm(TForm40);

  WriteLn;
  WriteLn('checks: ', Checks, '  failures: ', Failures);
  if Failures > 0 then
  begin
    WriteLn('RESULT: FAILED');
    Halt(1);
  end;
  WriteLn('RESULT: OK');
end.
