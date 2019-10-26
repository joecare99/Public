unit frm_Image2TextMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtDlgs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, ActnList, Menus, ShellCtrls,
  fra_PictureList, RichMemoFrame, BGRABitmap, BGRABitmapTypes, RichMemo,
  BGRAImageManipulation, BGRAVirtualScreen, BCTypes, BCButton, BGRAImageList,
  BGRAGraphicControl, Types;

type

  { TfrmImage2TextMain }

  TfrmImage2TextMain = class(TForm)
    actFileSave: TAction;
    actViewVertical: TAction;
    actViewHorizontal: TAction;
    ActionList1: TActionList;
    BGRAVirtualScreen1: TBGRAVirtualScreen;
    btnOpen: TBitBtn;
    btnOpenDir: TButton;
    fraPictureList1: TfraPictureList;
    lblActDir: TLabel;
    lblImprove: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    pnlRight: TPanel;
    pnlTop: TPanel;
    pnlLeft: TPanel;
    btnViewHorizontal: TSpeedButton;
    btnViewVertical: TSpeedButton;
    RTFEditFrame1: TRTFEditFrame;
    SpeedButton1: TSpeedButton;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    TrackBar1: TTrackBar;
    trbImprove: TTrackBar;
    procedure actFileSaveExecute(Sender: TObject);
    procedure actFileSaveUpdate(Sender: TObject);
    procedure actViewHorizontalExecute(Sender: TObject);
    procedure actViewHorizontalUpdate(Sender: TObject);
    procedure actViewVerticalExecute(Sender: TObject);
    procedure actViewVerticalUpdate(Sender: TObject);
    procedure BCButton1Click(Sender: TObject);
    procedure BGRAVirtualScreen1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BGRAVirtualScreen1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure BGRAVirtualScreen1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure btnOpenClick(Sender: TObject);
    procedure btnOpenDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    FBgraBitmap:TBGRABitmap;
    FBgraOrgBitmap:TBGRABitmap;
    FFilename: String;
    FMpoint:TPointF;
    FDim:TPointF;
    FScale :single;
    FSavePoint: TPointF;
    procedure LoadImageFile(const lFilename: String);
    procedure PictListRenameFile(sender: TObject; Oldfile, NewFile: String);
    procedure PictListUpdate(Sender: TObject);
  public

  end;

var
  frmImage2TextMain: TfrmImage2TextMain;

implementation

uses math,BGRAReadJpeg;
{$R *.lfm}

resourcestring
  rsPictureFilter = 'JPEG-Bilder (*.jpg)|*.jpg|All Files(*.*)|*.*';
{ TfrmImage2TextMain }

procedure TfrmImage2TextMain.btnOpenClick(Sender: TObject);
var
  lFilename: String;
begin
  fraPictureList1.fileMask:='*.jpg *.jpeg *.png';
  OpenPictureDialog1.Filter:=rsPictureFilter;
  if OpenPictureDialog1.execute then
    begin
      FFilename:=OpenPictureDialog1.FileName;
      if fraPictureList1.BasePath<>ExtractFilePath(FFilename) then
         begin
//           lstPictures.ViewStyle := vsList;
           fraPictureList1.BasePath:=ExtractFilePath(FFilename);
           fraPictureList1.Select(ExtractFileName(FFilename));
           lblActDir.Caption:=ExtractFilePath(FFilename);
         end;
    Application.ProcessMessages;
          LoadImageFile(FFilename);
    end;
end;

procedure TfrmImage2TextMain.btnOpenDirClick(Sender: TObject);
begin

end;

procedure TfrmImage2TextMain.FormCreate(Sender: TObject);
begin
   FScale := 1.0;
   RTFEditFrame1.RichMemo1.ZoomFactor:=Screen.PixelsPerInch/72;
   RTFEditFrame1.NewFile;

   fraPictureList1.OnRenameFile:=@PictListRenameFile;
   fraPictureList1.OnUpdate:=@PictListUpdate;
end;

procedure TfrmImage2TextMain.FormDestroy(Sender: TObject);
begin
  freeandnil(FBgraBitmap);
  freeandnil(FBgraOrgBitmap);
end;

procedure TfrmImage2TextMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=0 then ;
end;

procedure TfrmImage2TextMain.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key=#0 then ;
end;

procedure TfrmImage2TextMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 if BGRAVirtualScreen1.ClientRect.Contains(MousePos) and assigned(FBgraBitmap) then
   begin
  if WheelDelta< 0 then
     FScale := max(Fscale /1.2,1.0)
  else   if WheelDelta> 0 then
     FScale := min(Fscale *1.2,16.0);

  Fdim:=PointF(BGRAVirtualScreen1.Width,BGRAVirtualScreen1.Height)*(FBgraBitmap.Height/BGRAVirtualScreen1.Height/FScale);
  BGRAVirtualScreen1.RedrawBitmap;
   end;
end;

procedure TfrmImage2TextMain.FormResize(Sender: TObject);
begin
  if (pnlRight.Align = alRight) or (sender = actViewHorizontal) then
    begin
      pnlRight.width := round(0.5*self.ClientWidth)-Splitter1.width div 2 -pnlLeft.Width

    end
  else if (pnlRight.Align = alBottom) or (sender = actViewVertical) then
  pnlRight.height := round(0.5*self.ClientHeight)-Splitter1.height div 2-pnltop.height-StatusBar1.height;

  if assigned(FBgraBitmap) then
    Fdim:=PointF(BGRAVirtualScreen1.Width,BGRAVirtualScreen1.Height)*(FBgraBitmap.Height/BGRAVirtualScreen1.Height/FScale);
   BGRAVirtualScreen1.RedrawBitmap;
end;

procedure TfrmImage2TextMain.BGRAVirtualScreen1Redraw(Sender: TObject; Bitmap: TBGRABitmap);

var
  vPoints: array of TPointF;
  scale: Extended;
begin
  if assigned(FBgraBitmap) then
    begin
      setlength(vPoints,4);

      vPoints[0]:=FMpoint-FDim*0.5;
      vPoints[2]:=FMpoint+FDim*0.5;
      vPoints[1]:=PointF(vPoints[2].x,vPoints[0].y);
      vPoints[3]:=PointF(vPoints[0].x,vPoints[2].y);

      if Bitmap.Width/FBgraBitmap.Width < Bitmap.Height/FBgraBitmap.Height then
        scale :=Bitmap.Width/FBgraBitmap.Width
      else
        scale :=Bitmap.Height/FBgraBitmap.Height;

      Bitmap.FillPolyLinearMapping( [PointF(0,0), PointF(Bitmap.Width,0), PointF(Bitmap.Width,Bitmap.Height), PointF(0,Bitmap.Height)], FBgraBitmap,
                 vPoints, true);
    end;
end;

procedure TfrmImage2TextMain.BGRAVirtualScreen1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSavePoint:=PointF(X,Y)
end;

{ For each component, sort values to get the median }
function FilterMedian2(bmp: TBGRACustomBitmap;
  aRadius,aLevel:float): TBGRACustomBitmap;

  function ComparePixLt(p1, p2: TBGRAPixel): boolean;
  begin
    if (p1.red + p1.green + p1.blue = p2.red + p2.green + p2.blue) then
      Result := (int32or64(p1.red) shl 8) + (int32or64(p1.green) shl 16) +
        int32or64(p1.blue) < (int32or64(p2.red) shl 8) + (int32or64(p2.green) shl 16) +
        int32or64(p2.blue)
    else
      Result := (p1.red + p1.green + p1.blue) < (p2.red + p2.green + p2.blue);
  end;

var
  yb, xb:    int32or64;
  dx, dy, n, i, j, k: int32or64;
  alphas:  array of byte;
  reds:  array of byte;
  greens:  array of byte;
  bluess:  array of byte;
  tempPixel, refPixel, lPixel: TBGRAPixel;
  tempValue: byte;
  sumR, sumG, sumB, sumA, BGRAdiv, nbA: uint32or64;
  tempAlpha: word;
  bounds:    TRect;
  pdest:     PBGRAPixel;
  lRnRadius,lxDist: Integer;
  lIdx: Int64;

Procedure swap(a1,a2:byte);inline;

var
  lb: Byte;
begin
  lb := a1;
  a1:= a2;
  a2 := lb;
end;

Procedure CountingSort(var aList:array of byte;aAnz:integer);

var
  lCount  : array[byte] of integer;
  i, j, z  : integer;
begin
  fillchar(lCount,256*sizeof(integer),0);
  for i := 0 to aAnz do
    inc(lCount[ aList[ i ] ]);
    z:= 0;
  for i := 0 to 255 do
     for j := 0 to  lCount[ i  ] - 1  do
       begin
         aList[ z ] := i;
         inc( z );
       end;
end;


begin
  setlength(bluess,round(3.5*sqr(aRadius)));
  setlength(greens,round(3.5*sqr(aRadius)));
  setlength(reds,round(3.5*sqr(aRadius)));
  setlength(alphas,round(3.5*sqr(aRadius)));
  lRnRadius:=Round(aRadius);
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);

  bounds := bmp.GetImageBounds;
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;
  bounds.Left   := max(0, bounds.Left - 1);
  bounds.Top    := max(0, bounds.Top - 1);
  bounds.Right  := min(bmp.Width, bounds.Right + 1);
  bounds.Bottom := min(bmp.Height, bounds.Bottom + 1);

  for yb := bounds.Top to bounds.bottom - 1 do
  begin
    pdest := Result.scanline[yb] + bounds.left;
    for xb := bounds.left to bounds.right - 1 do
    begin
 // Get Pixels
      n := 0;
      for dy := -lRnRadius to lRnRadius do
        begin
          lxDist :=trunc(SQRT(sqr(aRadius)-sqr(dy)));
        for dx := -lxDist to lxDist do
        begin
          lPixel := bmp.GetPixel(xb + dx, yb + dy);
          if lPixel.alpha = 0 then
            lPixel := BGRAPixelTransparent;
          bluess[n] := lPixel.blue;
          greens[n] := lPixel.green;
          reds[n] := lPixel.red;
          alphas[n] := lPixel.alpha;
          Inc(n);
        end;
        end;
      lPixel := bmp.GetPixel(xb , yb);
 // Sort Pixels
      CountingSort(bluess,n);
      CountingSort(greens,n);
      CountingSort(reds,n);
//      CountingSort(alphas,n);

// Get Median
      lIdx:=trunc(aLevel*n);
      refPixel.blue :=min(lPixel.blue +250- bluess[lIdx],255);
      refPixel.green :=min(lPixel.green +250-greens[lIdx],255);
      refPixel.red := min(lPixel.red +250-reds[lIdx],255);
      refPixel.alpha := 255;
      pdest^ := refPixel;
      Inc(pdest);
    end;
  end;
end;

procedure TfrmImage2TextMain.BCButton1Click(Sender: TObject);

var lMedianImage:TBGRACustomBitmap;

begin
  FBgraOrgBitmap.draw(FBgraBitmap.Canvas,0,0);
  if trbImprove.Position> 1 then
    begin
      lMedianImage := FilterMedian2(FBgraOrgBitmap,6,0.85);
//      lMedianImage.BlendImage(0,0,FBgraOrgBitmap,boLighten);
      freeandnil(FBgraBitmap);
      TBGRACustomBitmap(FBgraBitmap):=lMedianImage;
    //  FBgraBitmap.LinearNegative;
    //  FBgraBitmap.BlendImage(0,0,FBgraBitmap,boMultiply);
    //  FBgraBitmap.BlendImage(0,0,FBgraBitmap,boMultiply);
    end;
   if trbImprove.Position> 0 then
    FBgraBitmap.InplaceNormalize(true);
  BGRAVirtualScreen1.RedrawBitmap;
end;

procedure TfrmImage2TextMain.actViewHorizontalExecute(Sender: TObject);
begin
   if pnlRight.Align<>alright then
   begin
   pnlRight.Align:=alRight;
  Splitter1.Align:=alRight;
  FormResize(sender);
   end;
end;

procedure TfrmImage2TextMain.actViewHorizontalUpdate(Sender: TObject);
begin
  actViewHorizontal.Checked:=pnlRight.Align=alRight;
end;

procedure TfrmImage2TextMain.actFileSaveUpdate(Sender: TObject);
begin
  actFileSave.Enabled:=RTFEditFrame1.Changed;
end;

procedure TfrmImage2TextMain.actFileSaveExecute(Sender: TObject);
begin
  RTFEditFrame1.Changed := false;
  RTFEditFrame1.SaveFile;
end;

procedure TfrmImage2TextMain.actViewVerticalExecute(Sender: TObject);
begin
  if pnlRight.Align<>alBottom then
    begin
  pnlRight.Align:=alBottom;
  Splitter1.Align:=alBottom;
  FormResize(Sender);
    end;
end;

procedure TfrmImage2TextMain.actViewVerticalUpdate(Sender: TObject);
begin
  actViewVertical.Checked:=pnlRight.Align=alBottom;
end;

procedure TfrmImage2TextMain.BGRAVirtualScreen1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  lDelta: TPointF;
begin
  if ssLeft in Shift then
    begin
  lDelta := PointF(X,Y)-FSavePoint;
  FSavepoint :=PointF(X,Y);
  FMpoint:=FMpoint.Subtract(lDelta*(FBgraBitmap.Height/BGRAVirtualScreen1.Height/FScale));
   BGRAVirtualScreen1.RedrawBitmap;
    end;
end;

procedure TfrmImage2TextMain.TrackBar1Change(Sender: TObject);
begin
  BGRAVirtualScreen1.Invalidate;
end;

procedure TfrmImage2TextMain.LoadImageFile(const lFilename: String);
begin
  freeandnil(FBgraBitmap);
  freeandnil(FBgraOrgBitmap);
  if RTFEditFrame1.changed then
    begin
      RTFEditFrame1.changed := false;
      RTFEditFrame1.SaveFile;
    end;
  FBgraOrgBitmap:= TBGRABitmap.Create(lFilename);
  FBgraBitmap:=TBGRABitmap.Create(FBgraOrgBitmap.Width, FBgraOrgBitmap.Height);
  FBgraOrgBitmap.FilterNormalize(true).draw(FBgraBitmap.canvas, 0, 0);
  FMpoint:=PointF(FBgraBitmap.Width, FBgraBitmap.Height)*0.5;
  Fdim:=PointF(BGRAVirtualScreen1.Width, BGRAVirtualScreen1.Height).Scale(
    FBgraBitmap.Height/BGRAVirtualScreen1.Height);
  FScale := 1.0;
  if FileExists(changeFileExt(lFilename,'.rtf')) then
    RTFEditFrame1.LoadFile(changeFileExt(lFilename,'.rtf'))
  else if FileExists(changeFileExt(lFilename,'.txt')) then
    begin
      RTFEditFrame1.RichMemo1.Lines.LoadFromFile(changeFileExt(lFilename,'.txt'));
      RTFEditFrame1.Filename:=changeFileExt(lFilename,'.rtf');
    end
  else
    RTFEditFrame1.NewFile(changeFileExt(lFilename,'.rtf'));
  //
  if fraPictureList1.data <> lFilename then
    fraPictureList1.Select(ExtractFileName(lFilename));
  RTFEditFrame1.RichMemo1.ZoomFactor:=Screen.PixelsPerInch/72;
  BCButton1Click(self);
end;

procedure TfrmImage2TextMain.PictListRenameFile(sender: TObject; Oldfile,
  NewFile: String);
begin
  RenameFile(Oldfile,NewFile);
  if FileExists(changefileext(Oldfile,'.rtf')) then
    RenameFile(changefileext(Oldfile,'.rtf'),ChangeFileExt(NewFile,'.rtf'));
  RTFEditFrame1.Filename:=ChangeFileExt(NewFile,'.rtf');
end;

procedure TfrmImage2TextMain.PictListUpdate(Sender: TObject);
begin
  LoadImageFile(fraPictureList1.Data);
end;


end.

