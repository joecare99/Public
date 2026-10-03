unit Unit25ListReportTemplateResource;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes;

/// Creates a stream over the embedded recovered Unit25 LazReport template.
function CreateUnit25ListReportTemplateStream: TStream;

implementation

uses
  SysUtils, LResources;

function CreateUnit25ListReportTemplateStream: TStream;
var
  resource: TLResource;
begin
  resource := LazarusResources.Find('Unit25ListReport', 'LRF');
  if resource = nil then
    raise EResNotFound.Create(
      'The embedded Unit25 LazReport template is unavailable.');
  Result := TLazarusResourceStream.CreateFromHandle(resource);
end;

initialization
  {$I Unit25ListReport.lrs}

end.
