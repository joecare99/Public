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

uses
  LResources, BibleExplorerEmbeddedData;

function NormalizeBibleResourceName(const AName: string): string;
begin
  Result := LowerCase(StringReplace(AName, '\', '/', [rfReplaceAll]));
end;

function TryLoadBibleResourceText(const AName: string; out AText: string): Boolean;
var
  Resource: TLResource;
begin
  AText := '';
  Resource := LazarusResources.Find(NormalizeBibleResourceName(AName), 'RCDATA');
  Result := Resource <> nil;
  if Result then
    AText := Resource.Value;
end;

function TryLoadBibleSource(const ADemoFolder, ARelativeFile: string;
  out AText: string): Boolean;
begin
  Result := TryLoadBibleResourceText('source/' + ADemoFolder + '/' +
    ARelativeFile, AText);
end;

end.
