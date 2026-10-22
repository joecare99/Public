{ Code-Ansicht der Meta-App: zeigt die markierten Code-Stellen einer Demo. }

unit BibleCodeView;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Controls, Forms, StdCtrls, ComCtrls, ExtCtrls, SynEdit,
  BibleDemoInfo;

type
  { TBibleCodeView }
  TBibleCodeView = class(TPanel)
  private
    FEditor: TSynEdit;
    FCombo: TComboBox;
    FSourcePath: string;
    FDemo: TBibleDemo;
    procedure ComboChanged(Sender: TObject);
    procedure ShowMarker(Index: Integer);
    procedure HighlightMarker(Line: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Zeigt die Code-Stellen einer Demo. }
    procedure ShowDemo(ADemo: TBibleDemo; const ASourcePath: string);
    { Wechselt zur naechsten/vorherigen markierten Stelle. }
    procedure NextMarker;
    procedure PreviousMarker;
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
  FileName: string;
begin
  FDemo := ADemo;
  FSourcePath := ASourcePath;
  FCombo.Clear;
  FEditor.Clear;
  if ADemo = nil then
    Exit;
  for I := 0 to ADemo.Markers.Count - 1 do
    FCombo.Items.Add(TBibleMarker(ADemo.Markers[I]).Title);
  FCombo.ItemIndex := 0;
  if ADemo.Markers.Count > 0 then
    ShowMarker(0)
  else
    if ADemo.Units.Count > 0 then
    begin
      FileName := IncludeTrailingPathDelimiter(ASourcePath) + ADemo.Units[0];
      if FileExists(FileName) then
        FEditor.Lines.LoadFromFile(FileName);
    end;
end;

procedure TBibleCodeView.ComboChanged(Sender: TObject);
begin
  ShowMarker(FCombo.ItemIndex);
end;

{ Laedt die Unit der markierten Stelle und hebt die Stelle hervor. }
procedure TBibleCodeView.ShowMarker(Index: Integer);
var
  Marker: TBibleMarker;
  FileName: string;
  I: Integer;
  Line: Integer;
begin
  if (FDemo = nil) or (Index < 0) or (Index >= FDemo.Markers.Count) then
    Exit;
  Marker := TBibleMarker(FDemo.Markers[Index]);
  FileName := IncludeTrailingPathDelimiter(FSourcePath) + Marker.FileName;
  if not FileExists(FileName) then
    Exit;
  FEditor.Lines.LoadFromFile(FileName);
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
