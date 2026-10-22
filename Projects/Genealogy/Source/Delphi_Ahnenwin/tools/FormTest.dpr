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
begin
  SetCurrentDir(DatenVerzeichnisSetzen);
  { The BDE of Delphi 9 writes its net file into the root of the drive
    when it has no configuration; it belongs next to the data. }
  Session.NetFileDir := DatenVerzeichnis;
  Application.Initialize;
  SplashZeigen;
  try
    Application.CreateForm(TDataModule2, DataModule2);
    Application.CreateForm(TForm1, Form1);
    F := Form1;
    WriteLn('nach Create');
    WriteLn('TForm1 erzeugt, Komponenten: ', F.ComponentCount);
    WriteLn('Caption   = ', F.Caption);
    WriteLn('DataModule: Table1 = ', DataModule2.Table1.TableName,
            '  Active = ', DataModule2.Table1.Active,
            '  RecCount = ', DataModule2.Table1.RecordCount);
    F.Free;
  except
    on E: Exception do
    begin
      WriteLn('FEHLER: ', E.ClassName, ': ', E.Message);
      { ExceptAddr is the address of the instruction that raised the
        exception - for an access violation it is the faulting address. }
      WriteLn('  Adresse: ', Integer(ExceptAddr));
      Halt(1);
    end;
  end;
end.
