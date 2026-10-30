unit BibleResources;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

function NormalizeBibleResourceName(const AName: string): string;
function TryLoadBibleResourceText(const AName: string; out AText: string): Boolean;
function TryLoadBibleSource(const ADemoFolder, ARelativeFile: string;
  out AText: string): Boolean;

implementation

function NormalizeBibleResourceName(const AName: string): string;
begin
  Result := LowerCase(StringReplace(AName, '\', '/', [rfReplaceAll]));
end;

function TryLoadBibleResourceText(const AName: string; out AText: string): Boolean;
var
  Stream: TResourceStream;
  Lines: TStringList;
begin
  Result := False;
  AText := '';
  try
    Stream := TResourceStream.Create(HInstance,
      NormalizeBibleResourceName(AName), PChar(10));
  except
    on E: EResNotFound do
      Exit;
  end;
  Lines := TStringList.Create;
  try
    Lines.LoadFromStream(Stream);
    AText := Lines.Text;
    Result := True;
  finally
    Lines.Free;
    Stream.Free;
  end;
end;

function TryLoadBibleSource(const ADemoFolder, ARelativeFile: string;
  out AText: string): Boolean;
begin
  Result := TryLoadBibleResourceText('source/' + ADemoFolder + '/' +
    ARelativeFile, AText);
end;

end.
