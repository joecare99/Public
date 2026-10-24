unit FokoListReportTemplateResource;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes;

/// Creates a stream over the embedded recovered Unit23 LazReport template.
function CreateFokoListReportTemplateStream: TStream;

implementation

uses
  SysUtils, LResources;

function CreateFokoListReportTemplateStream: TStream;
var
  resource: TLResource;
begin
  resource := LazarusResources.Find('Unit23Foko', 'LRF');
  if resource = nil then
    raise EResNotFound.Create(
      'The embedded Unit23 FOKO LazReport template is unavailable.');
  Result := TLazarusResourceStream.CreateFromHandle(resource);
end;

initialization
  {$I Unit23Foko.lrs}

end.
