unit cls_fv2stdctrls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2controls, cls_fv2canvas;

type
  TFvClickEvent = procedure(Sender: TObject) of object;

  TButton = class(TControl)
  private
    FCaption: string;
    FOnClick: TFvClickEvent;
    FTag: PtrInt;
    procedure SetCaption(const AValue: string);
  public
    procedure Click; virtual;
    procedure HandleEvent(var Event: TFvEvent); override;
    procedure DrawSelf(ACanvas: TFvCanvas); override;
    property Caption: string read FCaption write SetCaption;
    property Tag: PtrInt read FTag write FTag;
    property OnClick: TFvClickEvent read FOnClick write FOnClick;
  end;

  TStaticText = class(TControl)
  private
    FText: string;
    procedure SetText(const AValue: string);
  public
    procedure DrawSelf(ACanvas: TFvCanvas); override;
    property Text: string read FText write SetText;
  end;

  TLabel = class(TControl)
  private
    FCaption: string;
    procedure SetCaption(const AValue: string);
  public
    procedure DrawSelf(ACanvas: TFvCanvas); override;
    property Caption: string read FCaption write SetCaption;
  end;

  TEdit = class(TControl)
  private
    FText: string;
    procedure SetText(const AValue: string);
  public
    procedure DrawSelf(ACanvas: TFvCanvas); override;
    property Text: string read FText write SetText;
  end;

  TMemo = class(TEdit);
  TToggleBox = class(TControl)
  private
    FChecked: Boolean;
    FCaption: string;
    FOnChange: TFvClickEvent;
    procedure SetChecked(AValue: Boolean);
    procedure SetCaption(const AValue: string);
    procedure Toggle;
  public
    procedure HandleEvent(var Event: TFvEvent); override;
    procedure DrawSelf(ACanvas: TFvCanvas); override;
    property Checked: Boolean read FChecked write SetChecked;
    property Caption: string read FCaption write SetCaption;
    property OnChange: TFvClickEvent read FOnChange write FOnChange;
  end;

  TCheckBox = class(TToggleBox);
  TRadioButton = class(TToggleBox);

  TListBox = class(TControl)
  private
    FItems: TStringList;
    FItemIndex: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Items: TStringList read FItems;
    property ItemIndex: Integer read FItemIndex write FItemIndex;
  end;

  TComboBox = class(TListBox);
  TScrollBar = class(TControl);
  TGroupBox = class(TControl);

implementation

procedure TButton.SetCaption(const AValue: string);
begin
  if FCaption = AValue then
    Exit;
  FCaption := AValue;
  Invalidate;
end;

procedure TButton.Click;
begin
  if not Enabled then
    Exit;
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TButton.HandleEvent(var Event: TFvEvent);
begin
  if (Event.EventType = feCommand) and (Event.Code = 1) then
  begin
    Click;
    Event.EventType := feNone;
  end;
  inherited HandleEvent(Event);
end;

procedure TButton.DrawSelf(ACanvas: TFvCanvas);
begin
  ACanvas.TextOut(0, 0, FCaption);
end;

procedure TStaticText.SetText(const AValue: string);
begin
  if FText = AValue then
    Exit;
  FText := AValue;
  Invalidate;
end;

procedure TStaticText.DrawSelf(ACanvas: TFvCanvas);
begin
  ACanvas.TextOut(0, 0, FText);
end;

procedure TLabel.SetCaption(const AValue: string);
begin
  if FCaption = AValue then
    Exit;
  FCaption := AValue;
  Invalidate;
end;

procedure TLabel.DrawSelf(ACanvas: TFvCanvas);
begin
  ACanvas.TextOut(0, 0, FCaption);
end;

procedure TEdit.SetText(const AValue: string);
begin
  if FText = AValue then
    Exit;
  FText := AValue;
  Invalidate;
end;

procedure TEdit.DrawSelf(ACanvas: TFvCanvas);
begin
  ACanvas.TextOut(0, 0, FText);
end;

procedure TToggleBox.SetChecked(AValue: Boolean);
begin
  if FChecked = AValue then
    Exit;
  FChecked := AValue;
  Invalidate;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TToggleBox.SetCaption(const AValue: string);
begin
  if FCaption = AValue then
    Exit;
  FCaption := AValue;
  Invalidate;
end;

procedure TToggleBox.Toggle;
begin
  if Enabled then
    Checked := not Checked;
end;

procedure TToggleBox.HandleEvent(var Event: TFvEvent);
begin
  if (Event.EventType = feCommand) and (Event.Code = 1) then
  begin
    Toggle;
    Event.EventType := feNone;
  end;
  inherited HandleEvent(Event);
end;

procedure TToggleBox.DrawSelf(ACanvas: TFvCanvas);
var
  LText: string;
begin
  if Checked then
    LText := '[x] ' + Caption
  else
    LText := '[ ] ' + Caption;
  ACanvas.TextOut(0, 0, LText);
end;

constructor TListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  FItemIndex := -1;
end;

destructor TListBox.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

end.
