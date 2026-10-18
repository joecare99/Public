unit cls_fv2input;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2controls, cls_fv2canvas;

type
  TInputLine = class(TControl)
  private
    FText: string;
    FMaxLength: Integer;
    FOnChange: TNotifyEvent;
    procedure SetText(const AValue: string);
  protected
    procedure DrawSelf(ACanvas: TFvCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure HandleEvent(var Event: TFvEvent); override;
    property Text: string read FText write SetText;
    property MaxLength: Integer read FMaxLength write FMaxLength;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

constructor TInputLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxLength := 255;
end;

procedure TInputLine.SetText(const AValue: string);
begin
  if FText = AValue then
    Exit;
  FText := Copy(AValue, 1, FMaxLength);
  Invalidate;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TInputLine.HandleEvent(var Event: TFvEvent);
begin
  if Event.EventType <> feKey then
  begin
    inherited HandleEvent(Event);
    Exit;
  end;
  case Event.Code of
    8:
      if FText <> '' then
        Text := Copy(FText, 1, Length(FText) - 1);
    13:
      begin
        Event.EventType := feNone;
        Exit;
      end;
    32..255:
      if Length(FText) < FMaxLength then
        Text := FText + Chr(Event.Code);
  else
    inherited HandleEvent(Event);
    Exit;
  end;
  Event.EventType := feNone;
end;

procedure TInputLine.DrawSelf(ACanvas: TFvCanvas);
begin
  ACanvas.TextOut(0, 0, FText);
end;

end.
