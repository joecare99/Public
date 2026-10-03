unit Unit5ListReportTemplateResource;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes;

/// Creates a stream over the embedded recovered Unit5 LazReport template.
function CreateUnit5ListReportTemplateStream: TStream;

implementation

uses
  SysUtils, LResources;

function CreateUnit5ListReportTemplateStream: TStream;
var
  resource: TLResource;
begin
  resource := LazarusResources.Find('Unit5ListReport', 'LRF');
  if resource = nil then
    raise EResNotFound.Create(
      'The embedded Unit5 LazReport template is unavailable.');
  Result := TLazarusResourceStream.CreateFromHandle(resource);
end;

initialization
  {$I Unit5ListReport.lrs}

end.
