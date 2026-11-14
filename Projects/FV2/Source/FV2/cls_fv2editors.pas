unit cls_fv2editors;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, cls_fv2controls, cls_fv2canvas;

type
  TFvEditorKeyEvent = procedure(Sender: TObject; var Event: TFvEvent) of object;

  TEditor = class(TControl)
  private
    FLines: TStringList;
    FOnKey: TFvEditorKeyEvent;
    FCaretX: Integer;
    FCaretY: Integer;
    FTopLine: Integer;
    FOnChange: TNotifyEvent;
    procedure SetText(const AValue: string);
    function GetText: string;
  protected
    procedure DrawSelf(ACanvas: TFvCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HandleEvent(var Event: TFvEvent); override;
    procedure InsertText(const AText: string);
    procedure DeletePrevious;
    property Lines: TStringList read FLines;
    property Text: string read GetText write SetText;
    property CaretX: Integer read FCaretX;
    property CaretY: Integer read FCaretY;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnKey: TFvEditorKeyEvent read FOnKey write FOnKey;
  end;

  TMemo = class(TEditor);

implementation

constructor TEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TStringList.Create;
  FLines.Add('');
  FCaretX := 1;
  FCaretY := 0;
end;

destructor TEditor.Destroy;
begin
  FreeAndNil(FLines);
  inherited Destroy;
end;

function TEditor.GetText: string;
begin
  Result := FLines.Text;
end;

procedure TEditor.SetText(const AValue: string);
begin
  FLines.Text := AValue;
  if FLines.Count = 0 then
    FLines.Add('');
  FCaretY := FLines.Count - 1;
  FCaretX := Length(FLines[FCaretY]) + 1;
  Invalidate;
end;

procedure TEditor.InsertText(const AText: string);
var
  I: Integer;
  LLine: string;
  LSuffix: string;
begin
  if AText = '' then
    Exit;
  for I := 1 to Length(AText) do
  begin
    if AText[I] = #13 then
      Continue;
    LLine := FLines[FCaretY];
    if AText[I] = #10 then
    begin
      LSuffix := Copy(LLine, FCaretX, MaxInt);
      FLines[FCaretY] := Copy(LLine, 1, FCaretX - 1);
      Inc(FCaretY);
      FLines.Insert(FCaretY, LSuffix);
      FCaretX := 1;
    end
    else
    begin
      Insert(AText[I], LLine, FCaretX);
      FLines[FCaretY] := LLine;
      Inc(FCaretX);
    end;
  end;
  Invalidate;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TEditor.DeletePrevious;
var
  LLine: string;
begin
  if (FCaretX > 1) and (FCaretY < FLines.Count) then
  begin
    LLine := FLines[FCaretY];
    Delete(LLine, FCaretX - 1, 1);
    FLines[FCaretY] := LLine;
    Dec(FCaretX);
    Invalidate;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TEditor.HandleEvent(var Event: TFvEvent);
var
  LLine: string;
begin
  if Assigned(FOnKey) then
    FOnKey(Self, Event);
  if Event.EventType = feNone then
    Exit;
  if Event.EventType <> feKey then
  begin
    inherited HandleEvent(Event);
    Exit;
  end;
  case Event.Code of
    8:
      DeletePrevious;
    13:
      begin
        LLine := FLines[FCaretY];
        FLines[FCaretY] := Copy(LLine, 1, FCaretX - 1);
        FLines.Insert(FCaretY + 1, Copy(LLine, FCaretX, MaxInt));
        Inc(FCaretY);
        FCaretX := 1;
        Invalidate;
        if Assigned(FOnChange) then
          FOnChange(Self);
      end;
    32..255:
      InsertText(Chr(Event.Code));
  else
    inherited HandleEvent(Event);
    Exit;
  end;
  Event.EventType := feNone;
end;

procedure TEditor.DrawSelf(ACanvas: TFvCanvas);
var
  I: Integer;
begin
  for I := 0 to Bounds.Bottom - Bounds.Top - 1 do
  begin
    if FTopLine + I < FLines.Count then
      ACanvas.TextOut(0, I, FLines[FTopLine + I]);
  end;
end;

end.
