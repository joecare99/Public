unit cls_fv2forms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, cls_fv2controls, cls_fv2canvas;

type
  TForm = class(TControl)
  private
    FCaption: string;
    FOnShow: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FShown: Boolean;
    FOnCloseRequest: TNotifyEvent;
    procedure SetCaption(const AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Show;
    procedure Close;
    procedure RequestClose;
    procedure Paint(ACanvas: TFvCanvas); override;
    property Caption: string read FCaption write SetCaption;
    property Shown: Boolean read FShown;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnCloseRequest: TNotifyEvent read FOnCloseRequest write FOnCloseRequest;
  end;

implementation

constructor TForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Bounds := Rect(0, 0, 80, 25);
end;

procedure TForm.SetCaption(const AValue: string);
begin
  if FCaption = AValue then
    Exit;
  FCaption := AValue;
  Invalidate;
end;

procedure TForm.Show;
begin
  if FShown then
    Exit;
  FShown := True;
  if not Visible then
    Visible := True;
  if Assigned(FOnShow) then
    FOnShow(Self);
  Invalidate;
end;

procedure TForm.Close;
begin
  if not FShown then
    Exit;
  if Assigned(FOnClose) then
    FOnClose(Self);
  FShown := False;
  Visible := False;
end;

procedure TForm.RequestClose;
begin
  if Assigned(FOnCloseRequest) then
    FOnCloseRequest(Self)
  else
    Close;
end;

procedure TForm.Paint(ACanvas: TFvCanvas);
begin
  if not FShown then
    Exit;
  inherited Paint(ACanvas);
  if Assigned(ACanvas) then
    ACanvas.TextOut(Bounds.Left, Bounds.Top, FCaption);
end;

end.

