unit Unit16PreviewActions;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

uses
  Buttons,
  Classes,
  Dialogs
{$IFDEF FPC}
  , PrintersDlgs
{$ENDIF}
  ;

type
  TUnit16ZoomAction = (uzaNoChange, uzaSet100Percent, uzaFitPage, uzaFitWidth);
  TUnit16ExportFileEvent = procedure(const FileName: string) of object;

function TryGetPreviousPageNumber(CurrentPage: Integer;
  out PageNumber: Integer): Boolean;
function TryGetNextPageNumber(CurrentPage, PageCount: Integer;
  out PageNumber: Integer): Boolean;
function BuildPageStatus(CurrentPage, PageCount: Integer): string;
function IsUnit16EscapeKey(Key: Word): Boolean;
function AdvanceUnit16ReportPage(var CurrentPage: Integer;
  PageCount: Integer): Boolean;
procedure ConfigureUnit16SaveDialog(SaveDialog: TSaveDialog);
function HasUnit16ExportFileName(const FileName: string): Boolean;
function ExecuteUnit16SaveDialog(SaveDialog: TSaveDialog;
  ExportFile: TUnit16ExportFileEvent): Boolean;
procedure ConfigureUnit16PrintDialog(PrintDialog: TPrintDialog;
  PageCount: Integer);
function ResolveUnit16ZoomAction(ComboBoxIndex: Integer): TUnit16ZoomAction;
procedure InvokeUnit16ExitButton(ExitButton: TSpeedButton);
procedure DispatchUnit16ReportAction(Action: TNotifyEvent; Sender: TObject);

implementation

uses
  SysUtils;

function TryGetPreviousPageNumber(CurrentPage: Integer;
  out PageNumber: Integer): Boolean;
begin
  PageNumber := CurrentPage;
  Result := CurrentPage > 1;
  if Result then
    Dec(PageNumber);
end;

function TryGetNextPageNumber(CurrentPage, PageCount: Integer;
  out PageNumber: Integer): Boolean;
begin
  PageNumber := CurrentPage;
  Result := CurrentPage < PageCount;
  if Result then
    Inc(PageNumber);
end;

function BuildPageStatus(CurrentPage, PageCount: Integer): string;
begin
  Result := 'Seite ' + IntToStr(CurrentPage) + ' von ' + IntToStr(PageCount);
end;

function IsUnit16EscapeKey(Key: Word): Boolean;
begin
  Result := Key = $001B;
end;

function AdvanceUnit16ReportPage(var CurrentPage: Integer;
  PageCount: Integer): Boolean;
begin
  Inc(CurrentPage);
  Result := PageCount >= CurrentPage;
end;

procedure ConfigureUnit16SaveDialog(SaveDialog: TSaveDialog);
begin
  SaveDialog.Filter := 'Text-Dateien ( *.txt)|*.txt';
  SaveDialog.DefaultExt := 'txt';
end;

function HasUnit16ExportFileName(const FileName: string): Boolean;
begin
  Result := Trim(FileName) <> '';
end;

function ExecuteUnit16SaveDialog(SaveDialog: TSaveDialog;
  ExportFile: TUnit16ExportFileEvent): Boolean;
begin
  if SaveDialog = nil then
    raise EArgumentNilException.Create('SaveDialog');
  if not Assigned(ExportFile) then
    raise EArgumentNilException.Create('ExportFile');

  ConfigureUnit16SaveDialog(SaveDialog);
  Result := SaveDialog.Execute;
  if not Result then
    Exit;
  if not HasUnit16ExportFileName(SaveDialog.FileName) then
  begin
    Result := False;
    Exit;
  end;
  ExportFile(SaveDialog.FileName);
end;

procedure ConfigureUnit16PrintDialog(PrintDialog: TPrintDialog;
  PageCount: Integer);
begin
  PrintDialog.MinPage := 1;
  PrintDialog.FromPage := 1;
  PrintDialog.MaxPage := PageCount;
end;

function ResolveUnit16ZoomAction(ComboBoxIndex: Integer): TUnit16ZoomAction;
begin
  case ComboBoxIndex of
    0: Result := uzaSet100Percent;
    1: Result := uzaFitPage;
    2: Result := uzaFitWidth;
  else
    Result := uzaNoChange;
  end;
end;

procedure InvokeUnit16ExitButton(ExitButton: TSpeedButton);
begin
  ExitButton.Click;
end;

procedure DispatchUnit16ReportAction(Action: TNotifyEvent; Sender: TObject);
begin
  Action(Sender);
end;

end.
