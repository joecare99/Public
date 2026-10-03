unit Unit15ListReportTemplateResource;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes;

/// Creates a stream over the embedded recovered Unit15 LazReport template.
function CreateUnit15ListReportTemplateStream: TStream;

implementation

uses
  SysUtils, LResources;

function CreateUnit15ListReportTemplateStream: TStream;
var
  resource: TLResource;
begin
  resource := LazarusResources.Find('Unit15ListReport', 'LRF');
  if resource = nil then
    raise EResNotFound.Create(
      'The embedded Unit15 LazReport template is unavailable.');
  Result := TLazarusResourceStream.CreateFromHandle(resource);
end;

initialization
  {$I Unit15ListReport.lrs}

end.
