{ Code-Ansicht der Meta-App: zeigt die markierten Code-Stellen einer Demo. }

unit BibleCodeView;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Controls, Forms, StdCtrls, ComCtrls, ExtCtrls, SynEdit,
  BibleDemoInfo, BibleResources;

type
  { TBibleCodeView }
  TBibleCodeView = class(TPanel)
  private
    FEditor: TSynEdit;
    FCombo: TComboBox;
    FSourcePath: string;
    FLastFile: string;
    FDemo: TBibleDemo;
    procedure ComboChanged(Sender: TObject);
    procedure ShowUnit(Index: Integer);
    procedure ShowMarker(Index: Integer);
    procedure HighlightMarker(Line: Integer);
    function GetCodeLength: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Zeigt die Code-Stellen einer Demo. }
    procedure ShowDemo(ADemo: TBibleDemo; const ASourcePath: string);
    { Wechselt zur naechsten/vorherigen markierten Stelle. }
    procedure NextMarker;
    procedure PreviousMarker;
    { Anzahl der geladenen Code-Zeichen (fuer die Statuszeile). }
    property CodeLength: Integer read GetCodeLength;
    { Zuletzt geladene Datei (Diagnose). }
    property LastFile: string read FLastFile;
  end;

implementation


constructor TBibleCodeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditor := TSynEdit.Create(Self);
  FEditor.Parent := Self;
  FEditor.Align := alClient;
  FEditor.ReadOnly := True;
  FEditor.ScrollBars := ssBoth;
  FEditor.Gutter.Visible := True;
  FEditor.OnChange := nil;

  FCombo := TComboBox.Create(Self);
  FCombo.Parent := Self;
  FCombo.Align := alTop;
  FCombo.OnChange := ComboChanged;
end;

destructor TBibleCodeView.Destroy;
begin
  inherited Destroy;
end;

procedure TBibleCodeView.ShowDemo(ADemo: TBibleDemo; const ASourcePath: string);
var
  I: Integer;
begin
  FDemo := ADemo;
  FSourcePath := ASourcePath;
  FCombo.Clear;
  FEditor.Clear;
  FLastFile := '';
  FCombo.Visible := False;
  if ADemo = nil then
    Exit;
  if ADemo.Markers.Count > 0 then
  begin
    for I := 0 to ADemo.Markers.Count - 1 do
      FCombo.Items.Add(TBibleMarker(ADemo.Markers[I]).Title);
    FCombo.ItemIndex := 0;
    ShowMarker(0);
    Exit;
  end;
  if ADemo.Units.Count > 0 then
  begin
    FCombo.Items.AddStrings(ADemo.Units);
    FCombo.ItemIndex := 0;
    ShowUnit(0);
    FCombo.Visible := ADemo.Units.Count > 1;
  end;
end;

procedure TBibleCodeView.ComboChanged(Sender: TObject);
begin
  if FDemo = nil then
    Exit;
  if FDemo.Markers.Count > 0 then
    ShowMarker(FCombo.ItemIndex)
  else
    ShowUnit(FCombo.ItemIndex);
end;

procedure TBibleCodeView.ShowUnit(Index: Integer);
var
  FileName: string;
  SourceText: string;
  RelativeFile: string;
begin
  FEditor.Clear;
  FLastFile := '';
  if (FDemo = nil) or (Index < 0) or (Index >= FDemo.Units.Count) then
    Exit;
  RelativeFile := FDemo.Units[Index];
  if TryLoadBibleSource(FDemo.Folder, RelativeFile, SourceText) then
  begin
    FLastFile := 'Ressource: source/' + FDemo.Folder + '/' + RelativeFile;
    FEditor.Lines.Text := SourceText;
  end
  else
  begin
    if (ExtractFilePath(RelativeFile) = '') and (FDemo.Folder <> '') then
      FileName := IncludeTrailingPathDelimiter(FSourcePath) + FDemo.Folder +
        PathDelim + RelativeFile
    else
      FileName := IncludeTrailingPathDelimiter(FSourcePath) + RelativeFile;
    FLastFile := FileName;
    if FileExists(FileName) then
      FEditor.Lines.LoadFromFile(FileName)
    else
      FLastFile := FileName + ' (nicht gefunden)';
  end;
end;

{ Laedt die Unit der markierten Stelle und hebt die Stelle hervor. }
procedure TBibleCodeView.ShowMarker(Index: Integer);
var
  Marker: TBibleMarker;
  FileName: string;
  SourceText: string;
  I: Integer;
  Line: Integer;
begin
  FLastFile := '';
  if (FDemo = nil) or (Index < 0) or (Index >= FDemo.Markers.Count) then
    Exit;
  Marker := TBibleMarker(FDemo.Markers[Index]);
  if TryLoadBibleSource(FDemo.Folder, Marker.FileName, SourceText) then
  begin
    FLastFile := 'Ressource: source/' + FDemo.Folder + '/' + Marker.FileName;
    FEditor.Lines.Text := SourceText;
  end
  else
  begin
    if (ExtractFilePath(Marker.FileName) = '') and (FDemo.Folder <> '') then
      FileName := IncludeTrailingPathDelimiter(FSourcePath) + FDemo.Folder +
        PathDelim + Marker.FileName
    else
      FileName := IncludeTrailingPathDelimiter(FSourcePath) + Marker.FileName;
    FLastFile := FileName;
    if not FileExists(FileName) then
    begin
      FLastFile := FileName + ' (nicht gefunden)';
      Exit;
    end;
    FEditor.Lines.LoadFromFile(FileName);
  end;
  Line := 0;
  for I := 0 to FEditor.Lines.Count - 1 do
    if Pos(Marker.Text, FEditor.Lines[I]) > 0 then
    begin
      Line := I + 1;
      Break;
    end;
  HighlightMarker(Line);
end;

procedure TBibleCodeView.HighlightMarker(Line: Integer);
var
  StartPos, Length_: Integer;
begin
  if (Line < 1) or (Line > FEditor.Lines.Count) then
    Exit;
  FEditor.SelStart := 1;
  FEditor.SelEnd := 1 + Length(FEditor.Lines[Line - 1]);
end;

function TBibleCodeView.GetCodeLength: Integer;
begin
  Result := Length(FEditor.Text);
end;

procedure TBibleCodeView.NextMarker;
begin
  if (FCombo = nil) or (FCombo.Items.Count = 0) then
    Exit;
  FCombo.ItemIndex := (FCombo.ItemIndex + 1) mod FCombo.Items.Count;
end;

procedure TBibleCodeView.PreviousMarker;
begin
  if (FCombo = nil) or (FCombo.Items.Count = 0) then
    Exit;
  FCombo.ItemIndex := (FCombo.ItemIndex - 1 + FCombo.Items.Count) mod FCombo.Items.Count;
end;

end.
