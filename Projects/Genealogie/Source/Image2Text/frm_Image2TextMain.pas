unit frm_Image2TextMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtDlgs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, ActnList, Menus, ShellCtrls,
  RichMemoFrame, BGRABitmap, BGRABitmapTypes, RichMemo, BGRAImageManipulation,
  BGRAVirtualScreen, BCTypes, BCButton,  BGRAImageList,
  BGRAGraphicControl, Types;

type

  { TfrmImage2TextMain }

  TfrmImage2TextMain = class(TForm)
    actFileSave: TAction;
    actViewVertical: TAction;
    actViewHorizontal: TAction;
    ActionList1: TActionList;
    BGRAImageList1: TBGRAImageList;
    BGRAVirtualScreen1: TBGRAVirtualScreen;
    btnOpen: TBitBtn;
    btnOpenDir: TButton;
    lblActDir: TLabel;
    lblImprove: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    pnlRight: TPanel;
    pnlTop: TPanel;
    pnlLeft: TPanel;
    btnViewHorizontal: TSpeedButton;
    btnViewVertical: TSpeedButton;
    RTFEditFrame1: TRTFEditFrame;
    ShellListView1: TShellListView;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ShellListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ShellListView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ShellListView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShellListView1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ShellListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ShellListView1SizeConstraintsChange(Sender: TObject);
    procedure Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;
      var Accept: Boolean);
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
    procedure UpdateListImage(Data: PtrInt);
    procedure UpdateShellImages(Data: PtrInt);
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
  OpenPictureDialog1.Filter:=rsPictureFilter;
  if OpenPictureDialog1.execute then
    begin
      FFilename:=OpenPictureDialog1.FileName;
      if       ShellListView1.Root<>ExtractFilePath(FFilename) then
         begin
//           ShellListView1.ViewStyle := vsList;
           lblActDir.Caption:=ExtractFilePath(FFilename);
           ShellListView1.items.Clear;
           BGRAImageList1.clear;
      ShellListView1.Mask:='*.jpg *.jpeg *.png';
      ShellListView1.Root:=ExtractFilePath(FFilename);
         ShellListView1.ViewStyle:=vsIcon;
         end;
    Application.ProcessMessages;
          LoadImageFile(FFilename);
    end;
end;

procedure TfrmImage2TextMain.FormCreate(Sender: TObject);
begin
   FScale := 1.0;
   RTFEditFrame1.RichMemo1.ZoomFactor:=Screen.PixelsPerInch/72;
   RTFEditFrame1.NewFile;
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

procedure TfrmImage2TextMain.ShellListView1Change(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  NewText, NewPath: String;
  lImage: TBGRABitmap;
begin
  if (ctText = change) and (Item=ShellListView1.Selected) and assigned(Item) then
    begin
      if ExtractFileExt(item.caption) ='' then
        begin
          item.caption := item.caption + ExtractFileExt(FFileName);
          exit;
        end;
      NewPath := ShellListView1.GetPathFromItem(Item);
          if not fileexists(ShellListView1.GetPathFromItem(Item)) then
            begin
              RenameFile(FFilename,NewPath);
              if FileExists(changefileext(FFileName,'.rtf')) then
                RenameFile(changefileext(FFileName,'.rtf'),ChangeFileExt(Newpath,'.rtf'));
              RTFEditFrame1.Filename:=ChangeFileExt(Newpath,'.rtf');
            end
          else
            item.Caption:=ExtractFileName(FFileName);
    end
  else if assigned(Item) and (ctText= Change) and (item.ImageIndex=-1) then
    begin
      if (item.top < ShellListView1.Height) and (item.top>-64) then
        Application.QueueAsyncCall(@UpdateListImage, ptrint(Item));
    end;
end;

procedure TfrmImage2TextMain.ShellListView1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TfrmImage2TextMain.ShellListView1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Item: TListItem;
begin
  if ssLeft in shift then
    begin
      for Item in ShellListView1.Items do
      if (item.ImageIndex=-1) and (item.top < ShellListView1.Height) and (item.top>-64) then
        Application.QueueAsyncCall(@UpdateListImage, ptrint(Item));
    end;
end;

procedure TfrmImage2TextMain.ShellListView1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  Item: TListItem;
begin
  for Item in ShellListView1.Items do
  if (item.ImageIndex=-1) and (item.top-ShellListView1.ViewOrigin.y < ShellListView1.Height) and (item.top>shellListView1.ViewOrigin.y-64) then
    Application.QueueAsyncCall(@UpdateListImage, ptrint(Item));
end;

procedure TfrmImage2TextMain.ShellListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  lItem: TListItem;
begin
  if FFilename = ShellListView1.GetPathFromItem(Item) then
    begin
      if Item.ImageIndex = -1 then
        Application.QueueAsyncCall(@UpdateListImage, ptrint(Item));
      exit;
    end;
  FFilename := ShellListView1.GetPathFromItem(Item);
  LoadImageFile(ShellListView1.GetPathFromItem(Item));
  for lItem in ShellListView1.Items do
  if (litem.ImageIndex=-1) and (litem.top-ShellListView1.ViewOrigin.y < ShellListView1.Height) and (litem.top>shellListView1.ViewOrigin.y-64) then
    Application.QueueAsyncCall(@UpdateListImage, ptrint(lItem));
end;

procedure TfrmImage2TextMain.ShellListView1SizeConstraintsChange(Sender: TObject
  );
begin

end;

procedure TfrmImage2TextMain.Splitter1CanOffset(Sender: TObject;
  var NewOffset: Integer; var Accept: Boolean);
begin

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

procedure TfrmImage2TextMain.BCButton1Click(Sender: TObject);

var lMedianImage:TBGRACustomBitmap;

begin
  FBgraOrgBitmap.draw(FBgraBitmap.Canvas,0,0);
  if trbImprove.Position> 1 then
    begin
      lMedianImage := FBgraOrgBitmap.FilterBlurRadial(sqr(trbImprove.Position),rbFast);
      lMedianImage.BlendImage(0,0,FBgraOrgBitmap,boLighten);
      FBgraBitmap.BlendImage(0,0,lMedianImage,boLinearDifference);
      FBgraBitmap.LinearNegative;
      FBgraBitmap.BlendImage(0,0,FBgraBitmap,boMultiply);
      FBgraBitmap.BlendImage(0,0,FBgraBitmap,boMultiply);
      freeandnil(lMedianImage);
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
  ShellListView1.Selected:=  ShellListView1.Items.FindCaption(0,ExtractFileName(lFilename),false,false,false,false);
  if Assigned(ShellListView1.Selected)
    and ((ShellListView1.ViewOrigin.y+ShellListView1.height-64<ShellListView1.Selected.Top)
      or (ShellListView1.ViewOrigin.y> ShellListView1.Selected.Top)   )  then
     ShellListView1.ViewOrigin :=  Point(ShellListView1.ViewOrigin.x, ShellListView1.Selected.Top);
  RTFEditFrame1.RichMemo1.ZoomFactor:=Screen.PixelsPerInch/72;
  BCButton1Click(self);
end;

procedure TfrmImage2TextMain.UpdateListImage(Data: PtrInt);
var
  Item: TListItem;
  lImage: TBGRABitmap;
  reader:TBGRAReaderJpeg;
  NewPath: String;
  lMs: TStream;
begin
  if assigned(tObject(Data)) and tObject(Data).InheritsFrom(TListItem) then
    begin
      Item :=  TListItem(Data);
      NewPath := ShellListView1.GetPathFromItem(Item);
      if FileExists(NewPath) then
      try
      if (uppercase(ExtractFileExt(item.Caption)) = '.JPG') or
         (uppercase(ExtractFileExt(item.Caption)) = '.JPEG') then
        try
          reader:= TBGRAReaderJpeg.Create;
          lMs := TFileStream.create(ShellListView1.GetPathFromItem(item),fmOpenRead,fmShareDenyNone);
          reader.Scale:=jsEighth;
          reader.Performance:=jpBestSpeed;
          lImage:=TBGRABitmap(reader.ImageRead(lms,TBGRABitmap.Create));
        finally
          freeandnil(reader);
          freeandnil(lms);
        end
      else
        lImage:=TBGRABitmap.Create(ShellListView1.GetPathFromItem(item));
      BGRAImageList1.Add(limage.Resample(64,64,rmSimpleStretch).Bitmap,nil);
      item.ImageIndex:=BGRAImageList1.Count-1;
      finally
        freeandnil(lImage)
      end;
    end;
end;

procedure TfrmImage2TextMain.UpdateShellImages(Data: PtrInt);
begin

end;

end.

