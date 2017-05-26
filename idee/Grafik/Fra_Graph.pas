Unit Fra_Graph;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ExtDlgs, int_Graph,Menus;

Type
  TFraGraph = Class(TFrame,TintGraph)
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    BildSpeichern1: TMenuItem;
    Aktualisieren1: TMenuItem;
    N1: TMenuItem;
    Schliessen1: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    Timer1: TTimer;
    Procedure Timer1Timer(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    Procedure Aktualisieren1Click(Sender: TObject);
    Procedure BildSpeichern1Click(Sender: TObject);
    Procedure Clear1Click1(Sender: TObject);
    Procedure Schliessen1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Fbmp: TBitmap;
    FCanvas : TControlCanvas;
    FDrawColor: integer;
    FBkColor: TColor;
    FkKEY: char;
    FChanged: boolean;
    FActiveViewPort: TRect;
    Finitialized: Boolean;
  protected
    procedure PaintWindow(DC: HDC); override;
  public
    { Public-Deklarationen }
    df: Integer;
    LmousePos: TPoint;
    LShift: TShiftState;

    procedure SetVisible(val : Boolean){$ifdef FPC};override{$endif};
    procedure SetBitmap(val : TBitmap);
    function GetCanvas:TCanvas;
    property Visible;
    property Canvas:TCanvas read GetCanvas ;
    Property Bmp:TBitmap read Fbmp ;

    ///<author>Rosewich</author>
    ///  <since>01.06.2008</since>
    Procedure PutPixelA(x,y:extended;c:Tcolor);

    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetBitmap1(val : TBitmap);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    Function GetBitmap : TBitmap;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure FormResize(Sender:TObject);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetChanged : Boolean;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetChanged(val : Boolean);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetbkColor : TColor;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetbkColor(val : TColor);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetActiveViewPort : TRect;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetActiveViewPort(val : TRect);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure UpdateGraph(Sender:TObject);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetDrawColor : TColor;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetDrawColor(val : TColor);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function Getkkey : Char;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure Setkkey(val : Char);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetVisible : Boolean;
  End;

procedure Register;

Implementation

procedure Register;
begin
  RegisterComponents('Compatible', [TFraGraph]);
end;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Procedure TFraGraph.Timer1Timer(Sender: TObject);
Begin
  if not Finitialized then
    try
      FCanvas := TControlCanvas.Create;
      FCanvas.Control := Self;

    finally
      Finitialized := true;
    end;
  If FChanged Then
    Aktualisieren1Click(Sender)
End;

Procedure TFraGraph.Aktualisieren1Click(Sender: TObject);
Begin
  Canvas.StretchDraw(Canvas.ClipRect, Fbmp);
  FChanged := false;
End;

Procedure TFraGraph.BildSpeichern1Click(Sender: TObject);
Begin
  If SavePictureDialog1.execute Then
    Begin
      Fbmp.SaveToFile(SavePictureDialog1.Filename)
    End;
End;

Procedure TFraGraph.Clear1Click1(Sender: TObject);
Begin
  Fbmp.Canvas.Brush.Color := clBlack;
  Fbmp.Canvas.FillRect(Fbmp.Canvas.ClipRect);
  Invalidate;
End;

procedure TFraGraph.FrameResize(Sender: TObject);
begin

  if not assigned(FBmp)  then
     begin
      Fbmp := TBitmap.Create;
      Fbmp.PixelFormat := pf24bit;
     end;
  if df = 0 then
     df := 1;
  Fbmp.Width := Width * df;
  Fbmp.Height := Height * df;
  Fbmp.Canvas.Brush.Color := FBkColor;
  Fbmp.Canvas.FillRect(Fbmp.Canvas.ClipRect);
end;

Procedure TFraGraph.Schliessen1Click(Sender: TObject);
Begin
  //close;
End;

procedure TFraGraph.SetVisible(val : Boolean);
begin
  inherited Visible:=val;
end;

procedure TFraGraph.SetBitmap(val : TBitmap);
begin
  fbmp:=val;
end;

Function TFraGraph.Getcanvas:TCanvas;
begin
  Result :=FCanvas;
end;

procedure TFraGraph.SetBitmap1(val : TBitmap);
begin
end;

function TFraGraph.GetBitmap: TBitmap;
begin
  result:=Fbmp
end;

procedure TFraGraph.FormResize(Sender:TObject);
begin

end;

function TFraGraph.GetChanged: Boolean;
begin
  result:=FChanged;
end;

procedure TFraGraph.SetChanged(val : Boolean);
begin
  FChanged := val;
end;

function TFraGraph.GetbkColor: TColor;
begin
  result:= fBkColor;
end;

procedure TFraGraph.SetbkColor(val : TColor);
begin
  FBkColor:=val;
end;

function TFraGraph.GetActiveViewPort: TRect;
begin
  result:= FActiveViewPort;
end;

procedure TFraGraph.SetActiveViewPort(val : TRect);
begin
  FActiveViewPort := val;
end;

procedure TFraGraph.UpdateGraph(Sender:TObject);
begin
  Aktualisieren1Click(sender);
end;

function TFraGraph.GetDrawColor: TColor;
begin
  result:= FDrawColor;
end;

procedure TFraGraph.SetDrawColor(val : TColor);
begin
  FDrawColor := val;
end;

function TFraGraph.Getkkey: Char;
begin
  result:=FkKEY;
end;

procedure TFraGraph.Setkkey(val : Char);
begin
  FkKEY:=val;
end;

function TFraGraph.GetVisible: Boolean;
begin
  result:=Visible;
end;

procedure TFraGraph.PaintWindow(DC: HDC); 
begin
  inherited;
  FChanged := true;
end;

type tc=record
       r,b,g,a:byte
       end;

function Cadd(c1,c2:TColor):TColor;inline;
var lr,lg,lb:integer;

begin
  lr:=tc(c1).r+tc(c2).r;
  lg:=tc(c1).g+tc(c2).g;
  lb:=tc(c1).b+tc(c2).b;
  if lr>255 then lr:=255;
  if lg>255 then lg:=255;
  if lb>255 then lb:=255;
  result:=rgb(lr,lg,lb);
end;

function mdl(c1,c2:TColor):TColor;inline;
var lr,lg,lb:integer;

begin
  lr:=(tc(c1).r+tc(c2).r) div 2;
  lg:=(tc(c1).g+tc(c2).g) div 2;
  lb:=(tc(c1).b+tc(c2).b) div 2;
  if lr>255 then lr:=255;
  if lg>255 then lg:=255;
  if lb>255 then lb:=255;
  result:=rgb(lr,lg,lb);
end;


function CSMul(c:TColor;s:extended):TColor;inline;
var lr,lg,lb:integer;
begin
  lr:=round(tc(c).r*S);
  lg:=round(tc(c).g*S);
  lb:=round(tc(c).b*s);
  result:=rgb(lr,lg,lb);
end;

procedure TFraGraph.putpixela;
var c0,c1,c2,c3:Tcolor;
  m0,m1,m2,m3:extended;
  xx,yy:integer;
  xs,ys:extended;
begin
  xx:=trunc(x);
  yy:=trunc(y);
  xs:=x-int(x);
  ys:=y-int(y);
  m0:=(1-xs)*(1-ys)*0.5;
  m1:=(xs)*(1-ys)*0.5;
  m2:=(1-xs)*(ys)*0.5;
  m3:=(xs)*(ys)*0.5;
  c0:=csmul(c,m0);
  c1:=csmul(c,m1);
  c2:=csmul(c,m2);
  c3:=csmul(c,m3);
  Fbmp.Canvas.Pixels[xx,yy]:=Cadd(csmul(Fbmp.Canvas.Pixels[xx,yy],1-m0),c0);
  Fbmp.Canvas.Pixels[xx+1,yy]:=Cadd(csmul(Fbmp.Canvas.Pixels[xx+1,yy],1-m1),c1);
  Fbmp.Canvas.Pixels[xx,yy+1]:=Cadd(csmul(Fbmp.Canvas.Pixels[xx,yy+1],1-m2),c2);
  Fbmp.Canvas.Pixels[xx+1,yy+1]:=Cadd(csmul(Fbmp.Canvas.Pixels[xx+1,yy+1],1-m3),c3);
end;


End.
