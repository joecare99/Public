{ dfm2txt - wandelt eine binare Delphi-Formulardatei (TPF0) in das
  Textformat der Delphi-IDE um. Text-DFM koennen mit einem Editor bearbeitet
  werden; Delphi selbst liest beide Formate.

  Verwendung:
    dfm2txt <Quelldatei.dfm> [Zieldatei.txt]
    dfm2txt <Quelldatei.dfm> -      (Ausgabe auf stdout)
}

program dfm2txt;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils;

var
  Source: TFileStream;
  Target: TFileStream;
  InFile, OutFile: string;

procedure Convert(const AInFile, AOutFile: string);
var
  Text: TStringStream;
  Buffer: TBytes;
  Start: Integer;
  Idx: Integer;
begin
  Source := TFileStream.Create(AInFile, fmOpenRead or fmShareDenyWrite);
  try
    { Aeltere Delphi-Formulare (bis Version 5) haben einen 16 Byte langen
      Kopf vor dem eigentlichen TPF0-Strom. Wir suchen die Marke 'TPF0'
      und beginnen dort. }
    SetLength(Buffer, Source.Size);
    Source.Position := 0;
    Source.ReadBuffer(Buffer[0], Length(Buffer));
    Start := 0;
    for Idx := 0 to Length(Buffer) - 4 do
      if (Buffer[Idx] = Ord('T')) and (Buffer[Idx + 1] = Ord('P')) and
         (Buffer[Idx + 2] = Ord('F')) and (Buffer[Idx + 3] = Ord('0')) then
      begin
        Start := Idx;
        Break;
      end;
    if (Start > 0) and (Start < Length(Buffer) - 4) then
      Source.Position := Start;
    Text := TStringStream.Create('');
    try
      ObjectBinaryToText(Source, Text);
      if AOutFile = '-' then
        Write(Text.DataString)
      else
      begin
        Target := TFileStream.Create(AOutFile, fmCreate);
        try
          Text.SaveToStream(Target);
        finally
          Target.Free;
        end;
      end;
    finally
      Text.Free;
    end;
  finally
    Source.Free;
  end;
end;

begin
  if (ParamCount < 1) or (ParamCount > 2) then
  begin
    WriteLn('Verwendung: dfm2txt <Quelldatei.dfm> [Zieldatei.txt|-]');
    Halt(1);
  end;
  InFile := ParamStr(1);
  if ParamCount = 2 then
    OutFile := ParamStr(2)
  else
    OutFile := ChangeFileExt(InFile, '.txt');
  try
    Convert(InFile, OutFile);
  except
    on E: Exception do
    begin
      WriteLn('Fehler: ', E.Message);
      Halt(1);
    end;
  end;
end.
