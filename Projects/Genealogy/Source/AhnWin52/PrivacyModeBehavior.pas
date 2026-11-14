unit PrivacyModeBehavior;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

const
  PrivacyCaptionMarker = 'Datenschutz';
  PrivacyCaptionSuffixMarker = '(Datenschutz';
  PrivacyCaptionPrefix = '    (Datenschutz: geb. max. ';
  PrivacyCaptionSuffix = ')';
  PrivacyBirthYearFilterTemplate = 'gebjahr<=%d and taufjahr<=%d';

type
  TPrivacyDataSet = (pdsTable1, pdsTable5, pdsTable7, pdsTable8,
    pdsTable9, pdsTable17);

  IPrivacyModeActions = interface
    ['{C37357EA-0D49-43C4-93CB-8709C4A0C7E5}']
    procedure ClickDisablePrivacyCommand;
    procedure ActivateDataPage;
    function RequestMaximumBirthYear: Integer;
    procedure SetPrivacyHighlight(const Enabled: Boolean);
    procedure SetDataSetFilter(const DataSet: TPrivacyDataSet;
      const FilterText: string);
    procedure SetDataSetFiltered(const DataSet: TPrivacyDataSet;
      const Filtered: Boolean);
    procedure SetPrivacyBirthYearLimit(const Year: Integer);
    function GetWindowCaption: string;
    procedure SetWindowCaption(const Caption: string);
    function GetCurrentPersonNumber: Integer;
    procedure LocatePersonNumber(const Number: Integer);
    procedure RefreshMainView;
  end;

/// Disables privacy mode and restores the current person and normal caption.
procedure ExecutePrivacyModeDisable(const Actions: IPrivacyModeActions);

/// Starts by disabling any prior mode, then enables it for a positive year.
/// A cancelled or non-positive year leaves privacy mode disabled.
function ExecutePrivacyModeEnable(const Actions: IPrivacyModeActions): Boolean;

implementation

const
  PrivacyEnableDataSets: array[0..4] of TPrivacyDataSet =
    (pdsTable1, pdsTable7, pdsTable8, pdsTable9, pdsTable17);
  PrivacyDisableDataSets: array[0..5] of TPrivacyDataSet =
    (pdsTable1, pdsTable5, pdsTable7, pdsTable8, pdsTable9, pdsTable17);

procedure RequireActions(const Actions: IPrivacyModeActions);
begin
  if Actions = nil then
    raise EArgumentNilException.Create('Actions');
end;

procedure ExecutePrivacyModeDisable(const Actions: IPrivacyModeActions);
var
  DataSet: TPrivacyDataSet;
  PersonNumber: Integer;
  Caption: string;
  MarkerPosition: Integer;
begin
  RequireActions(Actions);

  PersonNumber := Actions.GetCurrentPersonNumber;
  Actions.ActivateDataPage;
  Actions.SetPrivacyHighlight(False);

  for DataSet in PrivacyDisableDataSets do
    Actions.SetDataSetFilter(DataSet, '');
  for DataSet in PrivacyDisableDataSets do
    Actions.SetDataSetFiltered(DataSet, False);

  Actions.SetPrivacyBirthYearLimit(0);
  Caption := Actions.GetWindowCaption;
  if Pos(PrivacyCaptionMarker, Caption) > 0 then
  begin
    MarkerPosition := Pos(PrivacyCaptionSuffixMarker, Caption);
    if MarkerPosition > 0 then
      Actions.SetWindowCaption(Copy(Caption, 1, MarkerPosition - 1))
    else
      Actions.SetWindowCaption('');
  end;

  Actions.LocatePersonNumber(PersonNumber);
  Actions.RefreshMainView;
end;

function ExecutePrivacyModeEnable(const Actions: IPrivacyModeActions): Boolean;
var
  BirthYear: Integer;
  DataSet: TPrivacyDataSet;
  FilterText: string;
  Caption: string;
begin
  RequireActions(Actions);

  Actions.ClickDisablePrivacyCommand;
  Actions.ActivateDataPage;
  BirthYear := Actions.RequestMaximumBirthYear;
  if BirthYear <= 0 then
  begin
    Actions.RefreshMainView;
    Exit(False);
  end;

  Actions.SetPrivacyHighlight(True);
  FilterText := Format(PrivacyBirthYearFilterTemplate, [BirthYear, BirthYear]);
  for DataSet in PrivacyEnableDataSets do
  begin
    Actions.SetDataSetFilter(DataSet, FilterText);
    Actions.SetDataSetFiltered(DataSet, True);
  end;

  Actions.SetPrivacyBirthYearLimit(BirthYear);
  Caption := Actions.GetWindowCaption;
  if Pos(PrivacyCaptionMarker, Caption) = 0 then
    Actions.SetWindowCaption(Caption + PrivacyCaptionPrefix +
      IntToStr(BirthYear) + PrivacyCaptionSuffix);

  Actions.RefreshMainView;
  Result := True;
end;

end.
