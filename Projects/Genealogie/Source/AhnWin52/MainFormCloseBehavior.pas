unit MainFormCloseBehavior;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  IMainFormCloseActions = interface
    ['{6FC860D9-70EF-40D1-B4AE-CC1F01E572A8}']
    procedure ActivateDataPage;
    procedure SaveCurrentPerson;
    procedure DeleteGeneratedReportFiles;
    function ConfirmApplicationExit: Boolean;
    procedure PostPendingPerson;
    procedure PostPendingMarriage;
    procedure CreateBackupWhenPersonExists;
    procedure CloseApplicationDataSets;
    procedure DeleteAuxiliaryTextFiles;
    procedure WriteCaptionConfiguration;
    procedure ClearCachedPasswords;
    procedure TerminateApplication;
    procedure CancelClose;
  end;

/// Executes the recovered close sequence without depending on the LCL.
function ExecuteMainFormClose(const Actions: IMainFormCloseActions): Boolean;

/// Writes the legacy 51-byte ShortString[50] window-caption configuration.
procedure WriteMainFormCaptionConfiguration(const FileName, Caption: string);

implementation

type
  TLegacyCaption = string[50];

function ExecuteMainFormClose(const Actions: IMainFormCloseActions): Boolean;
begin
  if Actions = nil then
    raise EArgumentNilException.Create('Actions');

  Actions.ActivateDataPage;
  Actions.SaveCurrentPerson;
  Actions.DeleteGeneratedReportFiles;

  if not Actions.ConfirmApplicationExit then
  begin
    Actions.CancelClose;
    Exit(False);
  end;

  Actions.PostPendingPerson;
  Actions.PostPendingMarriage;
  Actions.CreateBackupWhenPersonExists;
  Actions.CloseApplicationDataSets;
  Actions.DeleteAuxiliaryTextFiles;
  Actions.WriteCaptionConfiguration;
  Actions.ClearCachedPasswords;
  Actions.TerminateApplication;
  Result := True;
end;

procedure WriteMainFormCaptionConfiguration(const FileName, Caption: string);
var
  CaptionRecord: TLegacyCaption;
  OutputStream: TFileStream;
begin
  if FileName = '' then
    raise EArgumentException.Create('FileName must not be empty.');

  FillChar(CaptionRecord, SizeOf(CaptionRecord), 0);
  CaptionRecord := Caption;
  OutputStream := TFileStream.Create(FileName, fmCreate);
  try
    OutputStream.WriteBuffer(CaptionRecord[0], SizeOf(CaptionRecord));
  finally
    OutputStream.Free;
  end;
end;

end.
