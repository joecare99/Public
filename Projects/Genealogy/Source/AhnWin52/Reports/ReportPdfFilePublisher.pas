unit ReportPdfFilePublisher;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  Classes;

procedure PublishPdfStream(const AFileName: string; APdfStream: TStream);

implementation

uses
  Windows, SysUtils, ReportPdfContracts;

const
  MoveFileWriteThroughFlag = $00000008;

procedure PublishPdfStream(const AFileName: string; APdfStream: TStream);
var
  destination: string;
  temporaryFile: string;
  fileStream: TFileStream;
  fileId: TGUID;
begin
  if APdfStream = nil then
    raise EReportPdfArgumentError.Create('APdfStream must not be nil.');
  if Trim(AFileName) = '' then
    raise EReportPdfArgumentError.Create('AFileName must not be blank.');

  destination := ExpandFileName(AFileName);
  if CreateGUID(fileId) <> 0 then
    raise EReportPdfError.Create('Could not create a unique temporary name.');
  temporaryFile := destination + '.' + GUIDToString(fileId) + '.tmp';

  try
    fileStream := TFileStream.Create(temporaryFile, fmCreate);
    try
      APdfStream.Position := 0;
      fileStream.CopyFrom(APdfStream, 0);
    finally
      fileStream.Free;
    end;

    if not MoveFileEx(PChar(temporaryFile), PChar(destination),
      MOVEFILE_REPLACE_EXISTING or MoveFileWriteThroughFlag) then
      raise EReportPdfError.CreateFmt(
        'Could not publish PDF "%s": %s',
        [destination, SysErrorMessage(GetLastError)]);
  finally
    if FileExists(temporaryFile) then
      SysUtils.DeleteFile(temporaryFile);
  end;
end;

end.
