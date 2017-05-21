unit shapedwindowtest;

{$mode objfpc}{$H+}

interface

uses
  Forms, Graphics, StdCtrls, LCLIntf, LCLType, LMessages, ExtCtrls, Classes;

type

  { TfrmShapedWindow }

  TfrmShapedWindow = class(TForm)
    btnClose: TButton;
    Shape1: TShape;
    Timer1: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MNCHitTest(var M: TLMNCHITTEST); message LM_NCHITTEST;
    procedure Timer1Timer(Sender: TObject);
  private
    FShapes:array of TShape;
    tmr:integer;
  public

  end; 

var
  frmShapedWindow: TfrmShapedWindow;

implementation

uses sysutils,dateutils;
{$R *.lfm}

{ TfrmShapedWindow }

procedure TfrmShapedWindow.FormShow(Sender: TObject);
{var
  Rgn: HRGN;
begin
  Rgn := LCLIntf.CreateEllipticRgn(0, 0, 200, 200);
  LCLIntf.SetWindowRgn(Handle, Rgn, False);
  LCLIntf.DeleteObject(Rgn);}
var
  Shape: TBitmap;
  i: Integer;
begin
  Shape := TBitmap.Create;
  try
    Shape.Width := 200;
    Shape.Height := 200;
    if tmr > 0 then
      Shape.Canvas.Ellipse(50, 50, 150, 150);
    for i := 0 to 23 do
       Shape.Canvas.Ellipse(90+trunc(sin(i/12*pi)*90), 90+trunc(cos(i/12*pi)*90),
       110+trunc(sin(i/12*pi)*90), 110+trunc(cos(i/12*pi)*90));
    SetShape(Shape);
  finally
    Shape.Free;
  end;
end;

procedure TfrmShapedWindow.CreateParams(var Params: TCreateParams);
  Const CS_DROPSHADOW = $00020000;

  Begin
    Inherited;
    Try
      Params.WindowClass.Style := Params.WindowClass.Style Or CS_DROPSHADOW;
    Finally

    End;
  End;

procedure TfrmShapedWindow.MNCHitTest(var M: TLMNCHITTEST);
begin
   if (M.Result = htClient) or (m.result=0) then
    M.Result := htCaption;
  tmr:=5;
  FormShow(self);
end;

procedure TfrmShapedWindow.Timer1Timer(Sender: TObject);
var
  tt: TDateTime;
  i: Integer;
begin
  if not Visible then
   exit;
  tt := ( Now);
  tt := tt-int(tt);
  for i := 0 to 23 do
  FShapes[i].brush.Color := RGBToColor(
     trunc(sqr(sqr(sqr(sqr(0.5-0.5*cos((tt*4+i/12)*pi)))))*255),
     trunc(sqr(sqr(sqr(0.5-0.5*cos((tt*2*24+i/12)*pi))))*255),
     trunc(sqr(sqr(0.5-0.5*cos((tt*2*24*60+i/12)*pi)))*255)
             );
  if tmr >0 then
    begin
      tmr := tmr -1;
      if tmr = 0 then
       FormShow(sender);
    end;
end;

procedure TfrmShapedWindow.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmShapedWindow.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  setlength(FShapes,24);
      for i := 0 to 23 do
         begin
           if i = 0 then FShapes[i] := Shape1
           else begin
             FShapes[i] := TShape.Create(Shape1.Owner);
             FShapes[i].Parent := Shape1.Parent;
             FShapes[i].Shape := Shape1.Shape;
             FShapes[i].pen.Assign( Shape1.pen);
             end;
           FShapes[i].Height := 20;
           FShapes[i].width := 20;
           FShapes[i].Left :=90+trunc(sin(i/12*pi)*90);
           FShapes[i].top :=90+trunc(cos(i/12*pi)*90);
           FShapes[i].brush.Color := RGBToColor(
             128+trunc(sin(i/12*pi)*127),
             128+trunc(sin((i+8)/12*pi)*127),
             128+trunc(sin((i-8)/12*pi)*127)
             );
           end;

end;

end.

