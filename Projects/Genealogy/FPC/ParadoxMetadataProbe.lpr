program ParadoxMetadataProbe;

{$mode objfpc}{$H+}

uses
  Classes,
  DB,
  Paradox,
  SysUtils,
  TypInfo;

procedure RunProbe;
var
  paradoxTable: TParadox;
  fieldIndex: Integer;
begin
  if (ParamCount < 1) or (ParamCount > 2) then
  begin
    WriteLn(StdErr,
      'Usage: ParadoxMetadataProbe <table.db> [path\to\pxlib.dll]');
    ExitCode := 2;
    Exit;
  end;

  if not FileExists(ParamStr(1)) then
  begin
    WriteLn(StdErr, 'Table file not found: ', ParamStr(1));
    ExitCode := 2;
    Exit;
  end;

  paradoxTable := TParadox.Create(nil);
  try
    if ParamCount = 2 then
      paradoxTable.PXLibrary := ParamStr(2);

    paradoxTable.FileName := ParamStr(1);
    paradoxTable.Open;

    WriteLn('Table metadata');
    WriteLn('Field definitions (no records are read):');

    for fieldIndex := 0 to paradoxTable.FieldDefs.Count - 1 do
      WriteLn(
        fieldIndex + 1, #9,
        paradoxTable.FieldDefs[fieldIndex].Name, #9,
        GetEnumName(TypeInfo(TFieldType),
          Ord(paradoxTable.FieldDefs[fieldIndex].DataType)), #9,
        paradoxTable.FieldDefs[fieldIndex].Size
      );
  except
    on error: Exception do
    begin
      WriteLn(StdErr, 'Could not read Paradox table metadata: ', error.Message);
      ExitCode := 1;
    end;
  end;

  paradoxTable.Free;
end;

begin
  RunProbe;
end.
