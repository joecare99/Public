unit LCLMainUnit;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, ComCtrls, Dialogs,
  DeDeCore, DeDeCoreServices;

type
  TDeDeLCLMainForm = class(TForm)
  private
    FInputEdit: TEdit;
    FOutputEdit: TEdit;
    FReplaceCheck: TCheckBox;
    FRunButton: TButton;
    FStatusLabel: TLabel;
    FProgressBar: TProgressBar;
    FResults: TListBox;
    FOpenDialog: TOpenDialog;
    FLastError: string;
    procedure BrowseInput(Sender: TObject);
    procedure BrowseOutput(Sender: TObject);
    procedure AnalyzeClick(Sender: TObject);
    procedure ReportProgress(const APhase, ADetail: string;
      APosition, AMaximum: Integer);
    procedure ReportWarning(const AMessage: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetPaths(const AInputFile, AOutputDirectory: string);
    function RunAnalysis: Boolean;
    property LastError: string read FLastError;
  end;

implementation

constructor TDeDeLCLMainForm.Create(AOwner: TComponent);
var
  HeaderPanel, FooterPanel: TPanel;
  InputLabel, OutputLabel: TLabel;
  BrowseInputButton, BrowseOutputButton: TButton;
begin
  inherited Create(AOwner);
  Caption := 'DeDe - PE32 analysis';
  Position := poScreenCenter;
  ClientWidth := 760;
  ClientHeight := 520;
  Constraints.MinWidth := 620;
  Constraints.MinHeight := 420;

  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 154;
  HeaderPanel.BevelOuter := bvNone;

  InputLabel := TLabel.Create(Self);
  InputLabel.Parent := HeaderPanel;
  InputLabel.Caption := 'Input binary';
  InputLabel.SetBounds(12, 10, 120, 20);

  FInputEdit := TEdit.Create(Self);
  FInputEdit.Parent := HeaderPanel;
  FInputEdit.Anchors := [akLeft, akTop, akRight];
  FInputEdit.SetBounds(12, 32, 630, 26);

  BrowseInputButton := TButton.Create(Self);
  BrowseInputButton.Parent := HeaderPanel;
  BrowseInputButton.Caption := 'Browse...';
  BrowseInputButton.Anchors := [akTop, akRight];
  BrowseInputButton.SetBounds(650, 31, 98, 28);
  BrowseInputButton.OnClick := BrowseInput;

  OutputLabel := TLabel.Create(Self);
  OutputLabel.Parent := HeaderPanel;
  OutputLabel.Caption := 'Export directory';
  OutputLabel.SetBounds(12, 66, 140, 20);

  FOutputEdit := TEdit.Create(Self);
  FOutputEdit.Parent := HeaderPanel;
  FOutputEdit.Anchors := [akLeft, akTop, akRight];
  FOutputEdit.SetBounds(12, 88, 630, 26);

  BrowseOutputButton := TButton.Create(Self);
  BrowseOutputButton.Parent := HeaderPanel;
  BrowseOutputButton.Caption := 'Browse...';
  BrowseOutputButton.Anchors := [akTop, akRight];
  BrowseOutputButton.SetBounds(650, 87, 98, 28);
  BrowseOutputButton.OnClick := BrowseOutput;

  FReplaceCheck := TCheckBox.Create(Self);
  FReplaceCheck.Parent := HeaderPanel;
  FReplaceCheck.Caption := 'Replace existing output files';
  FReplaceCheck.SetBounds(12, 122, 260, 24);

  FRunButton := TButton.Create(Self);
  FRunButton.Parent := HeaderPanel;
  FRunButton.Caption := 'Analyze and export';
  FRunButton.Anchors := [akTop, akRight];
  FRunButton.SetBounds(570, 119, 178, 30);
  FRunButton.OnClick := AnalyzeClick;

  FResults := TListBox.Create(Self);
  FResults.Parent := Self;
  FResults.Align := alClient;
  FResults.IntegralHeight := False;

  FooterPanel := TPanel.Create(Self);
  FooterPanel.Parent := Self;
  FooterPanel.Align := alBottom;
  FooterPanel.Height := 54;
  FooterPanel.BevelOuter := bvNone;

  FStatusLabel := TLabel.Create(Self);
  FStatusLabel.Parent := FooterPanel;
  FStatusLabel.Caption := 'Ready';
  FStatusLabel.Anchors := [akLeft, akTop, akRight];
  FStatusLabel.SetBounds(12, 4, 730, 18);

  FProgressBar := TProgressBar.Create(Self);
  FProgressBar.Parent := FooterPanel;
  FProgressBar.Anchors := [akLeft, akTop, akRight];
  FProgressBar.SetBounds(12, 25, 736, 18);
  FProgressBar.Min := 0;
  FProgressBar.Max := 100;

  FOpenDialog := TOpenDialog.Create(Self);
  FOpenDialog.Title := 'Select a PE32 binary';
  FOpenDialog.Filter := 'Executable files|*.exe;*.dll;*.bin|All files|*.*';
  FOpenDialog.Options := FOpenDialog.Options + [ofFileMustExist, ofPathMustExist];
end;

procedure TDeDeLCLMainForm.SetPaths(const AInputFile, AOutputDirectory: string);
begin
  FInputEdit.Text := AInputFile;
  FOutputEdit.Text := AOutputDirectory;
end;

procedure TDeDeLCLMainForm.BrowseInput(Sender: TObject);
begin
  if FOpenDialog.Execute then
    FInputEdit.Text := FOpenDialog.FileName;
end;

procedure TDeDeLCLMainForm.BrowseOutput(Sender: TObject);
var
  Directory: string;
begin
  Directory := FOutputEdit.Text;
  if SelectDirectory('Select export directory', '', Directory) then
    FOutputEdit.Text := Directory;
end;

procedure TDeDeLCLMainForm.AnalyzeClick(Sender: TObject);
begin
  if not RunAnalysis then
    MessageDlg('Analysis failed', FLastError, mtError, [mbOK], 0);
end;

procedure TDeDeLCLMainForm.ReportProgress(const APhase, ADetail: string;
  APosition, AMaximum: Integer);
var
  Position: Integer;
begin
  FStatusLabel.Caption := Trim(APhase + ' ' + ADetail);
  if AMaximum > 0 then
  begin
    Position := (APosition * 100) div AMaximum;
    if Position < FProgressBar.Min then
      Position := FProgressBar.Min;
    if Position > FProgressBar.Max then
      Position := FProgressBar.Max;
    FProgressBar.Position := Position;
  end
  else
    FProgressBar.Position := 0;
  FStatusLabel.Update;
  FProgressBar.Update;
end;

procedure TDeDeLCLMainForm.ReportWarning(const AMessage: string);
begin
  FResults.Items.Add('Warning: ' + AMessage);
end;

function TDeDeLCLMainForm.RunAnalysis: Boolean;
var
  Session: TDeDeAnalysisSession;
  Analysis: TDeDeAnalysisResult;
  Options: TDeDeExportOptions;
  Generated: TStringList;
  I: Integer;
  FailurePhase: string;
begin
  Result := False;
  FLastError := '';
  if Trim(FInputEdit.Text) = '' then
  begin
    FLastError := 'An input binary is required';
    FStatusLabel.Caption := FLastError;
    Exit;
  end;
  if Trim(FOutputEdit.Text) = '' then
  begin
    FLastError := 'An export directory is required';
    FStatusLabel.Caption := FLastError;
    Exit;
  end;

  FStatusLabel.Caption := 'Preparing analysis';
  FResults.Items.BeginUpdate;
  try
    FResults.Items.Clear;
  finally
    FResults.Items.EndUpdate;
  end;
  FProgressBar.Position := 0;
  FRunButton.Enabled := False;
  FStatusLabel.Caption := 'Creating analysis session';
  Session := TDeDeAnalysisSession.Create;
  Generated := nil;
  try
    try
      FStatusLabel.Caption := 'Configuring analysis callbacks';
      Session.OnProgress := ReportProgress;
      Session.OnWarning := ReportWarning;
      FStatusLabel.Caption := 'Analyzing ' + FInputEdit.Text;
      Analysis := Session.Analyze(FInputEdit.Text);

      FillChar(Options, SizeOf(Options), 0);
      Options.IncludeDFM := True;
      Options.IncludePAS := True;
      Options.IncludeDPR := True;
      Options.IncludeEventRVA := True;
      Options.IncludeAnalysisReport := True;
      Options.IncludeCrossReferenceReport := False;
      FStatusLabel.Caption := 'Exporting project files';
      Generated := Session.ExportProject(
        FOutputEdit.Text, Options, FReplaceCheck.Checked);

      FResults.Items.Add(Format('%s: %d classes, %d forms, %d units',
        [Analysis.CompilerVersion, Analysis.ClassCount, Analysis.FormCount,
        Analysis.UnitCount]));
      for I := 0 to Generated.Count - 1 do
        FResults.Items.Add(Generated[I]);
      FProgressBar.Position := FProgressBar.Max;
      FStatusLabel.Caption := Format('Exported %d files to %s',
        [Generated.Count, FOutputEdit.Text]);
      Result := True;
    except
      on E: Exception do
      begin
        FailurePhase := FStatusLabel.Caption;
        FLastError := E.ClassName + ': ' + E.Message;
        if FailurePhase <> '' then
          FLastError := FLastError + ' (at ' + FailurePhase + ')';
        FStatusLabel.Caption := 'Analysis/export failed';
        FResults.Items.Add('Error: ' + FLastError);
      end;
    end;
  finally
    Generated.Free;
    Session.Free;
    FRunButton.Enabled := True;
  end;
end;

end.
