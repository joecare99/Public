program FormTest;

{-------------------------------------------------------------------------------
  FormTest - creates the main form and reports the exception of its
  OnCreate, so that a problem in the start-up path becomes visible.
-------------------------------------------------------------------------------}

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Forms, Controls, Graphics,
  Unit1 in '..\Units\Unit1.pas',
  Unit2 in '..\Units\Unit2.pas';

var
  F: TForm1;
begin
  Application.Initialize;
  try
    F := TForm1.Create(nil);
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
      WriteLn('  Adresse: ', Pointer(Integer(E.GetTypeInfo)));
      Halt(1);
    end;
  end;
end.
