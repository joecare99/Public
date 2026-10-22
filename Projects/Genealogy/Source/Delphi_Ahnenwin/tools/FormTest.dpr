program FormTest;

{-------------------------------------------------------------------------------
  FormTest - creates the main form and reports the exception of its
  OnCreate, so that a problem in the start-up path becomes visible.
-------------------------------------------------------------------------------}

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Forms, Controls, Graphics, DBTables,
  AHNStart in '..\Units\AHNStart.pas',
  Unit1 in '..\Units\Unit1.pas',
  Unit2 in '..\Units\Unit2.pas';

var
  F: TForm1;

procedure Log(const S: string);
begin
  WriteLn(S);
  Flush(Output);
end;

begin
  SetCurrentDir(DatenVerzeichnisSetzen);
  { The BDE of Delphi 9 writes its net file into the root of the drive
    when it has no configuration; it belongs next to the data. }
  Session.NetFileDir := DatenVerzeichnis;
  Application.Initialize;
  SplashZeigen;
  Log('nach Splash');
  try
    Application.CreateForm(TDataModule2, DataModule2);
    Log('nach DataModule');
    Application.CreateForm(TForm1, Form1);
    Log('nach Create');
    F := Form1;
    Log('TForm1 erzeugt, Komponenten: ' + IntToStr(F.ComponentCount));
    Log('Caption   = ' + F.Caption);
    Log('DataModule: Table1 = ' + DataModule2.Table1.TableName +
        '  Active = ' + BoolToStr(DataModule2.Table1.Active, True) +
        '  RecCount = ' + IntToStr(DataModule2.Table1.RecordCount));
    Log('vor Free');
    F.Free;
    Log('nach Free');
  except
    on E: Exception do
    begin
      WriteLn('FEHLER: ', E.ClassName, ': ', E.Message);
      { ExceptAddr is the address of the instruction that raised the
        exception - for an access violation it is the faulting address. }
      WriteLn('  Adresse: ', Integer(ExceptAddr));
      Flush(Output);
      Halt(1);
    end;
  end;
end.

