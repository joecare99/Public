{Sokoban 3.0, by Ben Ruyl}

unit MainUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  JPeg,  msxmldom, xmldom, ActnMan, ActnCtrls, ActnMenus, ToolWin, ImgList,
  XPStyleActnCtrls, StdStyleActnCtrls, ActnPopup, Windows,
  PlatformDefaultStyleActnCtrls, XMLIntf, XMLDoc,

{$ELSE}
  LCLIntf, LCLType,  FileUtil, ComboEx, DOM, XMLWrite,
{$ENDIF}
  Messages, Graphics, Controls, Forms,
  Buttons, ActnList, StdCtrls, Menus,
   ExtCtrls, ComCtrls, Classes,
  SysUtils, Dialogs, SokoEngine, PathFUnit;

type
  TSkinData = record
    FName, FAuthor, FCopyright, FDescription, FWebsite, FEmail: WideString;
    FTransparentColor, FBackgroundColor: TColor;
    FMustUseLayers, FMustRedrawLayer, FHasBackgroundImage: boolean;
    FSizeH, FSizeV, FMinHSize, FMinVSize: integer;
  end;


  TLevelsPlayed = record
    FLevelNumberPlayed, FBestMoves, FBestPushes: integer;
    FDataFileName: string;
  end;

  { TCanvasPanel }

  TCanvasPanel = class(TPanel)
  private
    FOnPaint: TNotifyEvent;
    FSokobanEngine: TSokobanEngine;
    FPathFinder:TPathFinder;
    FDragBoxX, FDragBoxY:integer;
    procedure PanelClick(Sender: TObject);
    procedure PanelPaint(Sender: TObject);
    procedure SetPathFinder(AValue: TPathFinder);
    procedure SetSokobanEngine(AValue: TSokobanEngine);
    procedure StopFlicker(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
  public
    Constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    Property SokobanEngine:TSokobanEngine read FSokobanEngine write SetSokobanEngine;
    Property PathFinder:TPathFinder read FPathFinder write SetPathFinder;
  end;

  { TfrmSokoban }

  TfrmSokoban = class(TForm)

    StatusBar: TStatusBar;
    OpenLevelDialog: TOpenDialog;
    SaveLevelDialog: TSaveDialog;
    {$IFNDEF FPC}
    SavedLevelDoc: TXMLDocument;
    {$ENDIF}
    LevelCB: TComboBoxEx;
    ToolImages: TImageList;
    DisToolImages: TImageList;
    HighToolImages: TImageList;
    StandardBar: TToolBar;
    tbtnPrevLevel: TToolButton;
    tbtnNextLevel: TToolButton;
    tbtnFirstLevel: TToolButton;
    tbtnLastLevel: TToolButton;
    tbtnUndoMove: TToolButton;
    tbtnRedoMove: TToolButton;
    tbtnResetLevel: TToolButton;
    tbtnSaveLevel: TToolButton;
    tbtnLoadLevel: TToolButton;
    tbtnSeparator1: TToolButton;
    tbtnSeparator2: TToolButton;
    tbtnSeparator3: TToolButton;
    tbtnSeparator4: TToolButton;
    tbtnSeparator5: TToolButton;
    OpenSkinDialog: TOpenDialog;
    {$IFDEF FPC}
//    ActionMainMenuBar1: TMainMenu;
    ActionManager1: TActionList;
     ActionMainMenuBar1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MnuInfo: TMenuItem;
    MnuView: TMenuItem;
    MnuFile: TMenuItem;
    MnuLevels: TMenuItem;
    MenuItem3: TMenuItem;
    {$ELSE}
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    {$ENDIF}
    ResetLevelAction: TAction;
    UndoMoveAction: TAction;
    PrevLevelAction: TAction;
    NextLevelAction: TAction;
    LastLevAction: TAction;
    FirstLevAction: TAction;
    LoadLevelAction: TAction;
    SaveLevelAction: TAction;
    ShowHideStandardAction: TAction;
    LoadSkinAction: TAction;
    RedoMoveAction: TAction;
    ExitAction: TAction;
    ThumbnailAction: TAction;
    ActStatusBar: TAction;
    ShowDetailsAction: TAction;
    AboutSkinAction: TAction;
    AboutAction: TAction;
    AboutLsetAction: TAction;
    CoolBar: TCoolBar;
    {$IFDEF FPC}
    OptionsMenu: TPopupMenu;
    ToolbarMenu: TPopupMenu;
    {$ELSE}
    OptionsMenu: TPopupActionBar;
    ToolbarMenu: TPopupActionBar;
    {$ENDIF}
    LoadLevel2: TMenuItem;
    SaveLevel2: TMenuItem;
    N1: TMenuItem;
    UndoMove1: TMenuItem;
    RedoMove2: TMenuItem;
    Reset1: TMenuItem;
    Pre1: TMenuItem;
    Nextlevel2: TMenuItem;
    Standard1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure LastLevActionExecute(Sender: TObject);
    procedure FirstLevActionExecute(Sender: TObject);
    procedure AboutLsetActionExecute(Sender: TObject);
    procedure ShowDetailsActionExecute(Sender: TObject);
    procedure AboutSkinActionExecute(Sender: TObject);
    procedure AboutActionExecute(Sender: TObject);
    procedure ActStatusBarExecute(Sender: TObject);
    procedure ActionManager1Update(Action: TBasicAction; var Handled: boolean);
    procedure ThumbnailActionExecute(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure ResetLevelActionExecute(Sender: TObject);
    procedure UndoMoveActionExecute(Sender: TObject);
    procedure PrevLevelActionExecute(Sender: TObject);
    procedure NextLevelActionExecute(Sender: TObject);
    procedure LevelCBSelect(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure LoadLevelActionExecute(Sender: TObject);
    procedure SaveLevelActionExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure ShowHideStandardActionExecute(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure LoadSkinActionExecute(Sender: TObject);
    procedure RedoMoveActionExecute(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
  private
    FMustDrawLevel: boolean;
    FSokobanEngine:TSokobanEngine;
    FNewXPos, FNewYPos, FNumberInLevelsPlayed: integer;
    FFieldPanel:TCanvasPanel;
    procedure CheckWon;
    function GetLevelNumber: integer;
    procedure SetLevelNumber(AValue: integer);
    procedure UpdateHMI(const LLevelNumber: Integer;
      const LCollection: TPuzzleCollectionData);
    procedure WritePlayedLevel;
    procedure UpdateStatistics;
  public
    {$IFDEF FPC}
    LevelDoc: TXMLDocument;
    SavedLevelDoc: TXMLDocument;
    {$ENDIF}
    FDragBoxX, FDragBoxY:integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MovePlayer(ANewX, ANewY: smallint);
    procedure InitLevel;
    procedure PartTogether(const Levelset: TPuzzleCollectionData);
    Property LevelNumber:integer read GetLevelNumber write SetLevelNumber;
  end;

procedure DrawTransparentBitmap(DC: TCanvas; hBmp: TBitmap; xStart: integer;
  yStart: integer; cTransparentColor: TColor);

const
  crDragBox = 1;

var
  frmSokoban: TfrmSokoban;
  AWideX, AWideY: integer;
  FSkinData: TSkinData;
  FDrawError, FIsPlaying, FInDragMode: boolean;
  FLevelFileName, FSkinFileName: string;
  FLevelsPlayed: array of TLevelsPlayed;

implementation

uses AboutUnit, ThumbUnit, SkinUnit, SkinInfoUnit, LevInfoUnit,
  DetailsUnit, Types, SettingsUnit, LoadLevelsetUnit;


{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmSokoban.InitLevel;
var
  LLevel: integer;
  LLevelSolved:Boolean;
begin
  StatusBar.Panels[2].Text := 'Best Moves: NA';
  frmSokoban.StatusBar.Panels[3].Text := 'Best Pushes: NA';
  for LLevel := 0 to Pred(Length(FLevelsPlayed)) do
  begin // Set the caption
    LLevelSolved :=
      (FLevelsPlayed[LLevel].FLevelNumberPlayed = frmSokoban.LevelNumber) and
      (LowerCase(FLevelsPlayed[LLevel].FDataFileName) =
      LowerCase(ExtractFileName(FLevelFileName)));
    if LLevelSolved then
    begin
      StatusBar.Panels[2].Text :=
        'Best Moves: ' + IntToStr(FLevelsPlayed[LLevel].FBestMoves);
      StatusBar.Panels[3].Text :=
        'Best Pushes: ' + IntToStr(FLevelsPlayed[LLevel].FBestPushes);
      FNumberInLevelsPlayed := LLevel;
      Break;
    end;
  end;

  FFieldPanel.Cursor := crDefault;

  FSokobanEngine.InitLevel(LevelNumber);

  LevelCB.ItemIndex := Pred(LevelNumber);
  FMustDrawLevel := True;
  FSkinData.FMustRedrawLayer := True;
  FIsPlaying := True;
  FInDragMode := False;

  FDrawError := False;
  StatusBar.Repaint;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.ResetLevelActionExecute(Sender: TObject);
begin
  FSokobanEngine.ResetLevel;
  FMustDrawLevel := True;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.UndoMoveActionExecute(Sender: TObject);
begin
  FSokobanEngine.Undo;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.PrevLevelActionExecute(Sender: TObject);
begin
  FSokobanEngine.InitLevel(pred(LevelNumber));
  InitLevel;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.NextLevelActionExecute(Sender: TObject);
begin
  FSokobanEngine.InitLevel(Succ(LevelNumber));
  InitLevel;
end;

//------------------------------------------------------------------------------

procedure DrawTransparentBitmap(DC: TCanvas; hBmp: TBitmap; xStart: integer;
  yStart: integer; cTransparentColor: TColor);
{ Special thank you to Serhiy Perevoznyk for this code:
http://members.chello.be/ws36637/transbmp.html}
var
  bm: BITMAP;
  cColor: COLORREF;
  bmAndBack, bmAndObject, bmAndMem, bmSave: HBITMAP;
  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBITMAP;
  hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave: HDC;
  ptSize: TPOINT;

begin
  hBmp.TransparentMode:=tmFixed;
  hBmp.TransparentColor:=cTransparentColor;
  hBmp.Transparent:=true;
  DC.StretchDraw(rect(xStart,yStart,xStart+hbmp.Width,yStart+hBmp.Height),hBmp);
 // DC.draw(xStart,yStart,xStart+hbmp.Width,yStart+hBmp.Height),hBmp,rect(0,0,hBmp.Width,hBmp.Height),cTransparentColor);
  //exit;
  //hdcTemp := CreateCompatibleDC(dc.Handle);
  //SelectObject(hdcTemp, hBmp.Handle);
  //
  //GetObject(hBmp.Handle, sizeof(BITMAP), @bm);
  //ptSize.x := bm.bmWidth;
  //ptSize.y := bm.bmHeight;
  //DPtoLP(hdcTemp, ptSize, 1);
  //
  //hdcBack := CreateCompatibleDC(dc.Handle);
  //hdcObject := CreateCompatibleDC(dc.Handle);
  //hdcMem := CreateCompatibleDC(dc.Handle);
  //hdcSave := CreateCompatibleDC(dc.Handle);
  //
  //bmAndBack := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  //
  //bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  //
  //bmAndMem := CreateCompatibleBitmap(dc.Handle, ptSize.x, ptSize.y);
  //bmSave := CreateCompatibleBitmap(dc.Handle, ptSize.x, ptSize.y);
  //
  //bmBackOld := SelectObject(hdcBack, bmAndBack);
  //bmObjectOld := SelectObject(hdcObject, bmAndObject);
  //bmMemOld := SelectObject(hdcMem, bmAndMem);
  //bmSaveOld := SelectObject(hdcSave, bmSave);
  //
  //SetMapMode(hdcTemp, GetMapMode(dc.Handle));
  //
  //BitBlt(hdcSave, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);
  //
  //cColor := SetBkColor(hdcTemp, cTransparentColor);
  //
  //BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0,
  //  SRCCOPY);
  //
  //SetBkColor(hdcTemp, cColor);
  //
  //BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0,
  //  NOTSRCCOPY);
  //
  //BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, dc.Handle, xStart, yStart,
  //  SRCCOPY);
  //
  //BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);
  //
  //BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);
  //
  //BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCPAINT);
  //
  //BitBlt(dc.Handle, xStart, yStart, ptSize.x, ptSize.y, hdcMem, 0, 0,
  //  SRCCOPY);
  //
  //// StretchBlt(dc.Handle, xStart, yStart, ptSize.X, ptSize.Y)
  //
  //BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcSave, 0, 0, SRCCOPY);
  //
  //DeleteObject(SelectObject(hdcBack, bmBackOld));
  //DeleteObject(SelectObject(hdcObject, bmObjectOld));
  //DeleteObject(SelectObject(hdcMem, bmMemOld));
  //DeleteObject(SelectObject(hdcSave, bmSaveOld));
  //
  //DeleteDC(hdcMem);
  //DeleteDC(hdcBack);
  //DeleteDC(hdcObject);
  //DeleteDC(hdcSave);
  //DeleteDC(hdcTemp);
end;

//------------------------------------------------------------------------------

procedure TCanvasPanel.PanelPaint(Sender: TObject);
var
  AXPos, AYPos, ADrawX, ADrawY, ADif: integer;
  ARect: TRect;

  procedure DrawPlayer(const Dest: TCanvas);
  var
    NewX, NewY: integer;
  begin
    NewX := {frmSokoban.FNewXPos + }(FSokobanEngine.Gamedata.FPlayerPos.X *
      FSkinData.FSizeH - (FSokobanEngine.Gamedata.FPlayerPos.X *
      (FSkinData.FSizeH - FSkinData.FMinHSize)));
    NewY := {frmSokoban.FNewYPos +}(FSokobanEngine.Gamedata.FPlayerPos.Y *
      FSkinData.FSizeV - (FSokobanEngine.Gamedata.FPlayerPos.Y *
      (FSkinData.FSizeV - FSkinData.FMinVSize)));

    case FSokobanEngine.PuzzleField[FSokobanEngine.Gamedata.FPlayerPos.X,
        FSokobanEngine.Gamedata.FPlayerPos.Y].FSkinType
      of
      stPlayerUp: DrawTransparentBitmap(Dest,
          FPlayerUp, NewX, NewY, FSkinData.FTransparentColor);
      stPlayerRight: DrawTransparentBitmap(Dest,
          FPlayerRight, NewX, NewY, FSkinData.FTransparentColor);
      stPlayerDown: DrawTransparentBitmap(Dest,
          FPlayerDown, NewX, NewY, FSkinData.FTransparentColor);
      stPlayerLeft: DrawTransparentBitmap(Dest,
          FPlayerLeft, NewX, NewY, FSkinData.FTransparentColor);
      stPlayerUpStore: DrawTransparentBitmap(Dest,
          FPlayerUpStore, NewX, NewY, FSkinData.FTransparentColor);
      stPlayerRightStore: DrawTransparentBitmap(Dest,
          FPlayerRightStore, NewX, NewY,
          FSkinData.FTransparentColor);
      stPlayerDownStore: DrawTransparentBitmap(Dest,
          FPlayerDownStore, NewX, NewY, FSkinData.FTransparentColor);
      stPlayerLeftStore: DrawTransparentBitmap(Dest,
          FPlayerLeftStore, NewX, NewY, FSkinData.FTransparentColor);
    end;
  end;

  function WhatWall(X, Y: integer): TBitmap;
  begin
{$WARNINGS OFF}// The result might be undefined
    case FSokobanEngine.PuzzleField[X, Y].FSkinType of
      stWall: Result := FWall;
      stWallUp: Result := FWallUp;
      stWallDown: Result := FWallDOwn;
      stWallLeft: Result := FWallLeft;
      stWallRight: Result := FWallRight;
      stWallUpDown: Result := FWallUpDown;
      stWallUpLeft: Result := FWallUpLeft;
      stWallUpRight: Result := FWallUpRight;
      stWallDownLeft: Result := FWallDownLeft;
      stWallDownRight: Result := FWallDownRight;
      stWallLeftRight: Result := FWallLeftRight;
      stWallUpDownLeft: Result := FWallUpDownLeft;
      stWallUpDownRight: Result := FWallUpDownRight;
      stWallUpLeftRight: Result := FWallUpLeftRight;
      stWallDownLeftRight: Result := FWallDownLeftRight;
      stWallUpDownLeftRight: Result := FWallUpDownLeftRight;
      else
        Result := FEmpty;
    end;
  end;

{$WARNINGS OFF}

  procedure MakeLayers;
  var
    X, Y: integer;
  begin
    FSkinData.FMustRedrawLayer := False;

    FLowerLayer.Width := FSokobanEngine.PuzzleWidth *
      FSkinData.FMinHSize + FSkindata.FSizeH - FSkinData.FMinHSize;
    FLowerLayer.Height := FSokobanEngine.PuzzleHeight *
      FSkinData.FMinVSize + FSkindata.FSizeV - FSkinData.FMinVSize;
    FLowerLayer.Canvas.Brush.Color := FSkinData.FTransparentColor;
    FLowerLayer.Canvas.FillRect(Rect(0, 0, FLowerLayer.Width, FLowerLayer.Height));
    if FSkinData.FMustUseLayers then
    begin
      FUpperLayer.Width := FSokobanEngine.PuzzleWidth *
        FSkinData.FSizeH;
      FUpperLayer.Height := FSokobanEngine.PuzzleHeight *
        FSkinData.FSizeV;
      FUpperLayer.Canvas.Brush.Color := FSkinData.FTransparentColor;
      FUpperLayer.Canvas.FillRect(FUpperLayer.Canvas.ClipRect);
    end;

    for Y := 0 to Pred(FSokobanEngine.PuzzleHeight) do
      for X := 0 to Pred(FSokobanEngine.PuzzleWidth) do
      begin
        ARect.Left := X * FSkinData.FSizeH -
          (X * (FSkinData.FSizeH - FSkinData.FMinHSize));
        ARect.Top := Y * FSkinData.FSizeV -
          (Y * (FSkinData.FSizeV - FSkinData.FMinVSize));
        ARect.Right := ARect.Left + FSkinData.FSizeH;
        ARect.Bottom := ARect.Top + FSkinData.FSizeV;

        if FSokobanEngine.PuzzleField[X, Y].FPartType = ptWall then
        begin
          if FSkinData.FMustUseLayers then
          begin
            DrawTransparentBitmap(FUpperLayer.Canvas,
              WhatWall(X, Y), ARect.Left, ARect.Top,
              FSkinData.FTransparentColor);
           { BitBlt(FUpperLayer.Canvas.Handle, ARect.Left, ARect.Top,
              ARect.Right,
              ARect.Bottom, WhatWall(X, Y).Canvas.Handle, 0, 0, SRCCOPY); }
            ARect.Left := X * FSkinData.FSizeH -
              (X * (FSkinData.FSizeH - FSkinData.FMinHSize)) +
              FSkinData.FSizeH - FSkinData.FMinHSize;
            ARect.Top := Y * FSkinData.FSizeV -
              (Y * (FSkinData.FSizeV - FSkinData.FMinVSize)) +
              FSkinData.FSizeV - FSkinData.FMinVSize;
            ARect.Right := ARect.Left + FSkinData.FSizeH;
            ARect.Bottom := ARect.Top + FSkinData.FSizeV;

            FLowerLayer.Canvas.CopyRect(ARect, FUpperLayer.Canvas,
              ARect);
            FUpperLayer.Canvas.Brush.Color := FSkinData.FTransparentColor;
            FUpperLayer.Canvas.FillRect(ARect);
          end
          else
            BitBlt(FLowerLayer.Canvas.Handle, ARect.Left, ARect.Top,
              ARect.Right,
              ARect.Bottom, WhatWall(X, Y).Canvas.Handle, 0, 0, SRCCOPY);
        end;

        if (FSokobanEngine.PuzzleField[X, Y].FPartType = ptNone) or
           (FPathFinder.Reachable[point(X, Y)]) or
          (FSokobanEngine.PuzzleField[X, Y].FPartType = ptPlayer) or
          (FSokobanEngine.PuzzleField[X, Y].FPartType = ptCrate) then
        begin
          if FSokobanEngine.PuzzleField[X, Y].FIsCrateTarget then
            DrawTransparentBitmap(FLowerLayer.Canvas, FStore,
              ARect.Left, ARect.Top, FSkinData.FTransparentColor)
          else
            DrawTransparentBitmap(FLowerLayer.Canvas, FEmpty,
              ARect.Left, ARect.Top, FSkinData.FTransparentColor);
        end;

        if FpathFinder.Reachable[point(X, Y)] then
        begin
          FLowerLayer.Canvas.Brush.Color := clGreen;
          ARect.Left := ARect.Left + FSkinData.FSizeH div 4;
          ARect.Top := ARect.Top + FSkinData.FSizeV div 4;
          ARect.Right := ARect.Left + FSkinData.FSizeH div 2;
          ARect.Bottom := ARect.Top + FSkinData.FSizeV div 2;
          FLowerLayer.Canvas.FillRect(ARect);
        end;
      end;
  end;

  function ResizeAndDrawBmp(bitmp: TBitmap; wid, hei: integer): boolean;
  var
    TmpBmp: TBitmap;
    ARect: TRect;
  begin
    try
      TmpBmp := TBitmap.Create;
      try
        TmpBmp.Width := wid;
        TmpBmp.Height := hei;
        ARect := Rect(0, 0, wid, hei);
        TmpBmp.Canvas.StretchDraw(ARect, Bitmp);

        DrawTransparentBitmap(self.Canvas, TmpBmp, frmSokoban.FNewXPos,
          frmSokoban.FNewYPos, FSkinData.FTransparentColor);
      finally
        TmpBmp.Free;
      end;
      Result := True;
    except
      Result := False;
    end;
  end;

begin
  try
    if (FSkinFileName <> '') and (FLevelFileName <> '') and not FDrawError then
    begin
      if frmSokoban.FMustDrawLevel then
      begin
        frmSokoban.FMustDrawLevel := False;

        FFullBackGround.Width := self.Width;
        FFullBackGround.Height := self.Height;
        FCollected.Width := FSokobanEngine.PuzzleWidth *
          FSkinData.FMinHSize + FSKindata.FSizeH - FSkinData.FMinHSize;
        FCollected.Height := FSokobanEngine.PuzzleHeight *
          FSkinData.FMinVSize + FSKindata.FSizeV - FSkinData.FMinVSize;

        if FSkinData.FHasBackgroundImage then
        begin
          for AYPos := 0 to self.Height do
            for AXPos := 0 to self.Width do
              if (AYPos mod FSkinData.FSizeV = 0) and
                (AXPos mod FSkinData.FSizeH = 0) then
                BitBlt(FFullBackGround.Canvas.Handle, AXPos, AYPos,
                  FSkinData.FSizeH, FSkinData.FSizeV,
                  FBackGround.Canvas.Handle,
                  0, 0, SRCCOPY);
        end
        else
        begin
          FFullBackGround.Canvas.Brush.Color := FSkinData.FBackgroundColor;
          FFullBackGround.Canvas.FillRect(FFullBackGround.Canvas.ClipRect);
        end;

        if FSkinData.FMustRedrawLayer then
          MakeLayers;

        AWideX := FSokobanEngine.PuzzleWidth *
          FSkinData.FMinHSize + FSKindata.FSizeH - FSkinData.FMinHSize;
        AWideY := FSokobanEngine.PuzzleHeight *
          FSkinData.FMinVSize + FSKindata.FSizeV - FSkinData.FMinVSize;

        if AWideX > self.Width then
        begin
          ADif := AWideX - self.Width;

          if AWideY > self.Height then
          begin
            if (FLowerLayer.Height / FLowerLayer.Width) * ADif <
              AWideY - self.Height then
            begin
              ADif := AWideY - self.Height;
              AWideY := AWideY - ADif;
              AWideX := Round((FLowerLayer.Width / FLowerLayer.Height) *
                AWideY);
            end
            else
            begin

              AWideX := AWideX - ADif;
              AWideY := Round((FLowerLayer.Height / FLowerLayer.Width) *
                AWideX);
            end;
          end
          else
          begin

            AWideX := AWideX - ADif;
            AWideY := Round((FLowerLayer.Height / FLowerLayer.Width) * AWideX);
          end;
        end
        else
        if AWideY > self.Height then
        begin
          ADif := AWideY - self.Height;
          AWideY := AWideY - ADif;
          AWideX := Round((FLowerLayer.Width / FLowerLayer.Height) * AWideY);
        end;
      end;

      BitBlt(self.Canvas.Handle, 0, 0,
        FFullBackGround.Width,
        FFullBackGround.Height, FFullBackGround.Canvas.Handle, 0, 0, SRCCOPY);

      FCollected.Canvas.Brush.Color := FSkinData.FTransparentColor;
      FCollected.Canvas.Brush.Style:=bsSolid;
      FCollected.Canvas.FillRect(Rect(0, 0, FCollected.Width, FCollected.Height));

      if FIsPlaying then
      begin
        frmSokoban.FNewXPos := self.Width div 2 - (AWideX div 2);

        frmSokoban.FNewYPos := self.Height div 2 - (AWideY div 2);

        DrawTransparentBitmap(FCollected.Canvas, FLowerLayer,
          0, 0, FSkinData.FTransparentColor);

        DrawPlayer(FCollected.Canvas);


        ADrawY := 0;
        for AYpos := 0 to FSokobanEngine.GameData.FLevelHeight - 1 do
        begin
          ADrawX := 0;
          for AXpos := 0 to FSokobanEngine.GameData.FLevelWidth - 1 do
          begin
            if FSokobanEngine.PuzzleField[AXPos][AYPos].FPartType =
              ptCrate then
              if FSokobanEngine.PuzzleField[AXPos,
                AYPos].FIsCrateTarget then
                DrawTransparentBitmap(FCollected.Canvas,
                  FCrateStore, ADrawX,
                  ADrawY, FSkinData.FTransparentColor)
              else
                DrawTransparentBitmap(FCollected.Canvas, FCrate,
                  ADrawX,
                  ADrawY, FSkinData.FTransparentColor);

            Inc(ADrawX, FSkinData.FMinHSize);
          end;
          Inc(ADrawY, FSkinData.FMinVSize);
        end;

        if FSkinData.FMustUseLayers then
          DrawTransparentBitmap(FCollected.Canvas, FUpperLayer,
            0, 0, FSkinData.FTransparentColor);

        ResizeAndDrawBmp(FCollected, AWideX, AWideY);

        frmSokoban.StatusBar.Panels[0].Text :=
          'Moves: ' + IntToStr(FSokobanEngine.GameData.FMoves);
        frmSokoban.StatusBar.Panels[1].Text :=
          'Pushes: ' + IntToStr(FSokobanEngine.GameData.FPushes);

        if frmGameDetails.Visible then
          frmSokoban.UpdateStatistics;
      end;
    end;
  except
    FDrawError := True; // Make sure the error doesn't repeat
    MessageBox(Handle, 'Error while drawing level!' + #13#10 +
      'Please send an e-mail to benruyl@zonnet.nl.',
      'Error', MB_OK or MB_ICONERROR);
  end;
end;

procedure TCanvasPanel.SetPathFinder(AValue: TPathFinder);
begin
  if FPathFinder=AValue then Exit;
  FPathFinder:=AValue;
end;

procedure TCanvasPanel.SetSokobanEngine(AValue: TSokobanEngine);
begin
  if FSokobanEngine=AValue then Exit;
  FSokobanEngine:=AValue;
  if Assigned(FPathFinder) then
    FPathFinder.sokobanEngine := AValue;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.LastLevActionExecute(Sender: TObject);
begin
  LevelNumber := FSokobanEngine.LastLevel;
  InitLevel;
end;

procedure TfrmSokoban.FormCreate(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.LevelCBSelect(Sender: TObject);
begin
LevelNumber := Succ(LevelCB.ItemIndex);
  InitLevel;
  ActiveControl := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.CheckWon;

  procedure ResetAndLoadLevel;
  begin
    FSokobanEngine.InitLevel(LevelNumber);
    InitLevel;
  end;

begin
  if FSokobanEngine.GameData.FCratesStoredCount =
    FSokobanEngine.GameData.FCrateTargetCount then
  begin
    WritePlayedLevel;

    if LevelNumber = LevelCB.Items.Count then // Is it the last level?
    begin
      if MessageBox(Handle, 'Congratulations!!!' + #13#10 +
        'Do you want to restart from level 1?', 'Congratulations!',
        MB_YESNO or MB_ICONINFORMATION) = idYes then
        FirstLevAction.Execute
      else
        ResetAndLoadLevel;
    end
    else
    if MessageBox(Handle, 'Congratulations!!!' + #13#10 +
      'Do you want to load the next level?', 'Congratulations!',
      MB_YESNO or MB_ICONINFORMATION) = idYes then
      NextLevelAction.Execute
    else
      ResetAndLoadLevel;
  end;
end;

function TfrmSokoban.GetLevelNumber: integer;
begin
  result := FSokobanEngine.GameData.FAktLevel;
end;

procedure TfrmSokoban.SetLevelNumber(AValue: integer);
begin
  FSokobanEngine.InitLevel(AValue);
end;

procedure TfrmSokoban.UpdateHMI(const LLevelNumber: Integer;
  const LCollection: TPuzzleCollectionData);
var
  i: Integer;
begin
  LevelCB.Clear;
  for i := 1 to FSokobanEngine.PuzzleCollection.NumberOfLevels do
    LevelCB.ItemsEx.AddItem('Level ' + IntToStr(i) + '   -   ' +
      FSokobanEngine.PuzzleCollection.Title, -1, -1, -1, 0, nil);
  LevelCB.ItemIndex := Pred(LLevelNumber);
  if FSokobanEngine.PuzzleCollection.Copyright = '' then
    StatusBar.Panels[5].Text := 'Copyright: NA'
  else
    StatusBar.Panels[5].Text := 'Copyright: ' +
      FSokobanEngine.PuzzleCollection.Copyright;
    PartTogether(LCollection);
      FMustDrawLevel := True;
  FSokobanEngine.InitLevel(1);
  FSkinData.FMustRedrawLayer := True;
  FIsPlaying := True;
  FInDragMode := False;

  FDrawError := False;
  StatusBar.Repaint;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.MovePlayer(ANewX, ANewY: smallint);
begin
  FSokobanEngine.MovePlayer(point(ANewX,ANewY));
  CheckWon;
  FFieldPanel.Repaint;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.FirstLevActionExecute(Sender: TObject);
begin
  LevelNumber := 1;
  InitLevel;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);

  procedure CheckMovePlayer(ANewX, ANewY: smallint);
  begin
    if (ANewX in [0..Pred(FSokobanEngine.PuzzleWidth)]) and
      // The p shouldn't walk
      (ANewY in [0..Pred(FSokobanEngine.PuzzleHeight)]) then
      // out of the level
      MovePlayer(ANewX, ANewY);
  end;

begin
  if FIsPlaying then
    with FSokobanEngine.GameData do
    begin
      case Key of
        VK_UP: CheckMovePlayer(FPlayerPos.X, Pred(FPlayerPos.Y));
        VK_RIGHT: CheckMovePlayer(Succ(FPlayerPos.X), FPlayerPos.Y);
        VK_DOWN: CheckMovePlayer(FPlayerPos.X, Succ(FPlayerPos.Y));
        VK_LEFT: CheckMovePlayer(Pred(FPlayerPos.X), FPlayerPos.Y);
        VK_ESCAPE:
          case MessageBox(Handle, 'Do you want to exit Sokoban?',
              'Exit?', MB_YESNO or MB_ICONQUESTION) of
            idYes: Close;
          end;
      end;
    end;
end;

//------------------------------------------------------------------------------

procedure TCanvasPanel.PanelClick(Sender: TObject); // Mouse support
var
  MousePos: TPoint;
  ADestX, ADestY, i, NewXPos, NewYPos: integer;
begin
  frmSokoban.ActiveControl := nil; // Set the focus to the form itself
  if FIsPlaying then
  begin
    MousePos := Self.ScreenToClient(Mouse.CursorPos);
    ADestX := Round((MousePos.X - frmSokoban.FNewXPos - FSkindata.FMinHSize div 2) /
      ((FSkindata.FMinHSize * AWideX) / FLowerLayer.Width));
    ADestY := Round((MousePos.Y - frmSokoban.FNewYPos - FSkindata.FMinVSize div 2) /
      ((FSkindata.FMinVSize * AWideY) / FLowerLayer.Height));

    if (ADestX < FSokobanEngine.PuzzleWidth) and
      (ADestY < FSokobanEngine.PuzzleHeight) and
      (ADestX > -1) and (ADestY > -1) then
    begin
      if FInDragMode then
      begin
        FInDragMode := False;

        if FPathFinder.Reachable[point(ADestX, ADestY)] then
        begin
         { FindBestPushPath(FDragBoxX, FDragBoxY, ADestX, ADestY,
            FSokobanEngine.PuzzleField, False);  }
          FPathFinder.MoveBox(point(FDragBoxX, FDragBoxY),point(ADestX, ADestY), FSokobanEngine);

          // DumpField;
          for i := FPathFinder.BoxPosCount - 1 downto 1 do
          begin
            NewXPos := FPathFinder.BoxPos[i].x;
            NewYPos := FPathFinder.BoxPos[i].y;
            if FPathFinder.BoxPos[i - 1].x < FPathFinder.BoxPos[i].x then
              Inc(NewXPos);
            if FPathFinder.BoxPos[i - 1].x > FPathFinder.BoxPos[i].x then
              Dec(NewXPos);
            if FPathFinder.BoxPos[i - 1].y < FPathFinder.BoxPos[i].y then
              Inc(NewYPos);
            if FPathFinder.BoxPos[i - 1].y > FPathFinder.BoxPos[i].y then
              Dec(NewYPos);


            FPathFinder.FindPath(FSokobanEngine.GameData.FPlayerPos,point(NewXPos, NewYPos),
              FSokobanEngine.PuzzleField,FSokobanEngine.MovePlayer{, True});

//            frmSokoban.CheckMovementCrate(FPathFinder.BoxPosX[i], FPathFinder.BoxPosY[i]);
          end;

          FPathfinder.Clear;
          frmSokoban.FMustDrawLevel := True;
          FSkinData.FMustRedrawLayer := True;
          self.Repaint;
        end
        else
        begin
          frmSokoban.FMustDrawLevel := True;
          FSkinData.FMustRedrawLayer := True;
          self.Repaint;
        end;

        Self.Cursor := crDefault;
        Exit;
      end;

      if FSokobanEngine.PuzzleField[ADestX, ADestY].FPartType = ptCrate then
      begin
        FPathFinder.BuildDestField(FSokobanEngine);

        if Fpathfinder.FindAllPos(point(ADestX, ADestY), FSokobanEngine.PuzzleField,FSokobanEngine.GameData) then
        begin
          FDragBoxX := ADestX;
          FDragBoxY := ADestY;
          Self.Cursor := crDragBox;
          FInDragMode := True;
        end
        else
          Beep;

        frmSokoban.FMustDrawLevel := True;
        FSkinData.FMustRedrawLayer := True;
        self.Repaint;
      end
      else
        begin
        {MovePathPlayer(FSokobanEngine.GameData.FPlayerPos.X, FGameData[FLevelNumber
          - 1].FPlayerPos.Y, ADestX, ADestY,
            FSokobanEngine.PuzzleField);  }
        Fpathfinder.FindPath(FSokobanEngine.GameData.FPlayerPos, point(ADestX, ADestY),
          FSokobanEngine.PuzzleField,FSokobanEngine.MovePlayer{, True});

        frmSokoban.FMustDrawLevel := True;
        FSkinData.FMustRedrawLayer := True;
        self.Repaint;

        end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.LoadLevelActionExecute(Sender: TObject);
var
  LCollection: TPuzzleCollectionData;
  LLevelNumber: Integer;
begin
  if OpenLevelDialog.Execute then
  begin
    FLevelFileName := OpenLevelDialog.FileName;
    try
      FIsPlaying:=false;
      LLevelNumber := 1;
      LCollection:=FSokobanEngine.PuzzleCollection;
      LoadPuzzleSet(FLevelFileName,LCollection);

      UpdateHMI(LLevelNumber, LCollection);
      LevelNumber:= LLevelNumber;
    except
      FDrawError := True;
      MessageBox(Handle, PChar('''' + ExtractFileName(FLevelFileName) +
        '''' + ' could not be loaded!' + #13#10 +
        'Please send an e-mail to benruyl@zonnet.nl.'),
        'Error', MB_OK or MB_ICONERROR);
    end;
  end;
end;

//------------------------------------------------------------------------------

constructor TfrmSokoban.Create(AOwner: TComponent);
var
  BeginOfData, EndOfData, i, k, SpaceNumber, SpacePos: integer;
  GameDataFile: TStringList;
  AParam: string;
  LPuzzleCollection: TPuzzleCollectionData;
  LLevelNumber: Integer;
// Try a Auto-Menu
//  LMItmNew: TMenuItem;
//  LMSubItmNew: TMenuItem;

begin
  inherited;
  //--------------------------------------------
 { ActionMainMenuBar1.Items.Clear;
 // ActionMainMenuBar1.Parent := TComponent();
 { CoolBar.Bands[0].Control:=TToolbar.Create(self) ;
  for i := 0 to ActionManager1.ActionCount-1 do
    begin
      LMItmNew:=ActionMainMenuBar1.items.Find(ActionManager1.Actions[i].Category);
      if not assigned(LMItmNew) then
        begin
          LMItmNew:=TMenuItem.Create(ActionMainMenuBar1);
          with LMItmNew do
            begin
              ActionMainMenuBar1.items.add (LMItmNew);
              TToolbar(CoolBar.Bands[0].Control).InsertComponent(LMItmNew);
              Caption:=ActionManager1.Actions[i].Category;
              Visible:=true;
            end;
        end;
      LMSubItmNew:=TMenuItem.Create(ActionMainMenuBar1);
      with LMSubItmNew do
        begin
          LMItmNew.Add(LMSubItmNew);
          Action:=ActionManager1.Actions[i];
        end;
    end;  }


  //---------------------------------------------
  LLevelNumber:=1;
  FSokobanEngine := TSokobanEngine.Create;
  FFieldPanel := TCanvasPanel.Create(Self);
  FFieldPanel.Parent := Self;
  FFieldPanel.Align := alClient;
  FFieldPanel.DoubleBuffered := True;
  FFieldPanel.OnPaint := FFieldPanel.PanelPaint;
  FFieldPanel.OnClick := FFieldPanel.PanelClick;
  FFieldPanel.ControlStyle := FFieldPanel.ControlStyle + [csOpaque];
  FFieldPanel.SokobanEngine := FSokobanEngine;

  FDrawError := False;

  Screen.Cursors[crDragBox] := LoadCursor(hInstance, 'DRAGBOX');

  LoadSettings;
  CreateBitmaps; // Create the skin bmps

  if not FileExists(FSkinFileName) then
    if OpenSkinDialog.Execute then
      FSkinFileName := OpenSkinDialog.FileName
    else
      FSkinFileName := '';

  if FSkinFileName <> '' then
    LoadSkin(FSkinFileName)
  else
    FDrawError := True;

  SetLength(FLevelsPlayed, 0);
  if FileExists(GetSettingsDir + 'data.sok') then
  begin
    GameDataFile := TStringList.Create; // Read what levels are completed
    try
      begin
        GameDataFile.LoadFromFile(GetSettingsDir +
          'data.sok');
        BeginOfData := Succ(GameDataFile.IndexOf('[LevelsPlayed]'));
        EndOfData := Pred(GameDataFile.IndexOf('[/LevelsPlayed]'));
        SetLength(FLevelsPlayed, EndOfData - BeginOfData + 1);

        SpacePos := 0;
        for i := BeginOfData to EndOfData do
        begin
          SpaceNumber := 1;
          for k := 1 to Length(GameDataFile[i]) do
          begin
            if GameDataFile[i][k] = ' ' then
            begin

              if SpaceNumber = 1 then
              begin
                FLevelsPlayed[i - BeginOfData].FLevelNumberPlayed :=
                  StrToInt(Copy(GameDataFile[i], 0, k - 1));
              end;

              if SpaceNumber = 2 then
              begin
                FLevelsPlayed[i - BeginOfData].FDataFileName :=
                  Copy(GameDataFile[i], SpacePos + 1, k - SpacePos - 1);
              end;

              if SpaceNumber = 3 then
              begin
                FLevelsPlayed[i - BeginOfData].FBestMoves :=
                  StrToInt(Copy(GameDataFile[i], SpacePos + 1,
                  k - SpacePos - 1));
              end;

              Inc(SpaceNumber);
              SpacePos := k;
            end;
          end;
          FLevelsPlayed[i - BeginOfData].FBestPushes :=
            StrToInt(Copy(GameDataFile[i], SpacePos + 1,
            Length(GameDataFile[i])));
        end;
      end;
    finally
      GameDataFile.Free;
    end;
  end;

  AParam := ParamStr(1);
  if AParam <> '' then
  begin
    FLevelFileName := AParam;
    AParam := ParamStr(2);
    LLevelNumber := StrToIntDef(AParam, 1);
  end;

  if not FileExists(FLevelFileName) then
    if OpenLevelDialog.Execute then
      FLevelFileName := OpenLevelDialog.FileName
    else
      FLevelFileName := '';

  if FLevelFileName <> '' then
    begin
    LPuzzleCollection:= FSokobanEngine.PuzzleCollection;
    LoadPuzzleSet(FLevelFileName,LPuzzleCollection);
    UpdateHMI(1,LPuzzleCollection);
    end;

  if assigned(FLevelsPlayed)
    and (FLevelFileName = FLevelsPlayed[high(FLevelsPlayed)].FDataFileName)
    and (FLevelsPlayed[high(FLevelsPlayed)].FLevelNumberPlayed < LPuzzleCollection.NumberOfLevels) then
      LLevelNumber:=FLevelsPlayed[high(FLevelsPlayed)].FLevelNumberPlayed+1;
  LevelNumber:=LLevelNumber;
end;

//------------------------------------------------------------------------------

destructor TfrmSokoban.Destroy;
begin
  FreeBitmaps;
  SaveSettings;
  freeandnil(FSokobanEngine);
  inherited;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.SaveLevelActionExecute(Sender: TObject);
var
  AXPos, AYPos: smallint;
  {$IFDEF FPC}
  CurrentLevel: tDomNode;
  {$ELSE}
  CurrentLevel: IXMLNode;
  {$ENDIF}
  TempStr: string;
begin
  if SaveLevelDialog.Execute then
  begin // Note that this does not log the number of moves/pushes
    {$IFNDEF FPC}
    SavedLevelDoc.Active := True;
    {$ENDIF}
    try
      SavedLevelDoc.AddChild('SokobanLevels');
      SavedLevelDoc.ChildNodes.Nodes[0].AddChild('Title');
      SavedLevelDoc.ChildNodes.Nodes[0].ChildNodes.Nodes[0].Text :=
        FSokobanEngine.PuzzleCollection.Title;
      SavedLevelDoc.ChildNodes.Nodes[0].AddChild('Description');
      SavedLevelDoc.ChildNodes.Nodes[0].ChildNodes.Nodes[1].Text :=
        'User saved level from a levelset.';

      SavedLevelDoc.ChildNodes.Nodes[0].AddChild('LevelCollection');
      CurrentLevel := SavedLevelDoc.ChildNodes.Nodes[0].ChildNodes.Nodes[2];
      CurrentLevel.SetAttributeNS('Copyright', '',
        FSokobanEngine.PuzzleCollection.Copyright);
      CurrentLevel.AddChild('Level');
      CurrentLevel := CurrentLevel.ChildNodes.Nodes[0];
      CurrentLevel.SetAttributeNS('Width', ' ',
        IntToStr(FSokobanEngine.PuzzleWidth));
      CurrentLevel.SetAttributeNS('Height', ' ',
        IntToStr(FSokobanEngine.PuzzleHeight));

      for AYPos := 0 to Pred(FSokobanEngine.PuzzleHeight) do
      begin
        for AXPos := 0 to Pred(FSokobanEngine.PuzzleWidth) do
        begin
          if FSokobanEngine.PuzzleField[AXPos, AYPos].FPartType =
            ptEmpty then
            TempStr := TempStr + ' '
          else
          if FSokobanEngine.PuzzleField[AXPos, AYPos].FPartType =
            ptWall then
            TempStr := TempStr + '#'
          else
          if FSokobanEngine.PuzzleField[AXPos, AYPos].FIsCrateTarget
          then
          begin
            if FSokobanEngine.PuzzleField[AXPos, AYPos].FPartType =
              ptNone then
              TempStr := TempStr + '.'
            else
            if FSokobanEngine.PuzzleField[AXPos, AYPos].FPartType =
              ptPlayer then
              TempStr := TempStr + '+'
            else
            if FSokobanEngine.PuzzleField[AXPos,
              AYPos].FPartType = ptCrate then
              TempStr := TempStr + '*';
          end
          else
          if FSokobanEngine.PuzzleField[AXPos, AYPos].FPartType =
            ptNone then
            TempStr := TempStr + ' '
          else
          if FSokobanEngine.PuzzleField[AXPos, AYPos].FPartType =
            ptPlayer then
            TempStr := TempStr + '@'
          else
          if FSokobanEngine.PuzzleField[AXPos,
            AYPos].FPartType = ptCrate then
            TempStr := TempStr + '$';

        end;
        CurrentLevel.AddChild('L');
        CurrentLevel.ChildNodes.Nodes[AYPos].Text := TempStr;
        TempStr := '';
      end;
      {$IFDEF FPC}
      XMLWrite.WriteXML(SavedLevelDoc,SaveLevelDialog.FileName);
      {$ELSE}
      SavedLevelDoc.SaveToFile(SaveLevelDialog.FileName);
      {$ENDIF}
    finally

    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.WritePlayedLevel;
var
  DataFile: TStringList;
  i: integer;
begin
  // Write it to the array
  if FNumberInLevelsPlayed<= high(FLevelsPlayed) then
  begin
    if FLevelsPlayed[FNumberInLevelsPlayed].FBestMoves >
      FSokobanEngine.GameData.FMoves then
      FLevelsPlayed[FNumberInLevelsPlayed].FBestMoves :=
        FSokobanEngine.GameData.FMoves;
    if FLevelsPlayed[FNumberInLevelsPlayed].FBestPushes >
      FSokobanEngine.GameData.FPushes then
      FLevelsPlayed[FNumberInLevelsPlayed].FBestPushes :=
        FSokobanEngine.GameData.FPushes;
  end
  else
  begin
    SetLength(FLevelsPlayed, Length(FLevelsPlayed) + 1);
    FLevelsPlayed[Pred(Length(FLevelsPlayed))].FLevelNumberPlayed :=
      LevelNumber;
    FLevelsPlayed[Pred(Length(FLevelsPlayed))].FDataFileName :=
      ExtractFileName(FLevelFileName);
    FLevelsPlayed[Pred(Length(FLevelsPlayed))].FBestMoves :=
      FSokobanEngine.GameData.FMoves;
    FLevelsPlayed[Pred(Length(FLevelsPlayed))].FBestPushes :=
      FSokobanEngine.GameData.FPushes;
  end;

  // Write the whole array into the data file
  DataFile := TStringList.Create;
  try
    DataFile.Add('[LevelsPlayed]');
    for i := 0 to Pred(Length(FLevelsPlayed)) do
    begin
      DataFile.Add(IntToStr(FLevelsPlayed[i].FLevelNumberPlayed) +
        ' ' + FLevelsPlayed[i].FDataFileName + ' ' +
        IntToStr(FLevelsPlayed[i].FBestMoves) + ' ' +
        IntToStr(FLevelsPlayed[i].FBestPushes));
    end;
    DataFile.Add('[/LevelsPlayed]');

    DataFile.SaveToFile(GetSettingsDir + 'data.sok');
  finally
    DataFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.FormResize(Sender: TObject);
begin
  FMustDrawLevel := True;
  FSkinData.FMustRedrawLayer := True;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if FSokobanEngine.LevelSolved then
    ToolImages.Draw(StatusBar.Canvas, Rect.Left + 3, Rect.Top, 9, True)
  else
    ToolImages.Draw(StatusBar.Canvas, Rect.Left + 3, Rect.Top, 8, True);
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.ShowHideStandardActionExecute(Sender: TObject);
begin
  StandardBar.Visible := not ShowHideStandardAction.Checked;
  ShowHideStandardAction.Checked := not ShowHideStandardAction.Checked;
  Standard1.Checked := not Standard1.Checked;

  FMustDrawLevel := True;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin
  if ActiveControl = nil then
    UndoMoveAction.Execute;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.LoadSkinActionExecute(Sender: TObject);
begin
  if OpenSkinDialog.Execute then
  begin
    LoadSkin(OpenSkinDialog.FileName);
    FMustDrawLevel := True;
    FFieldPanel.Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.RedoMoveActionExecute(Sender: TObject);
begin
  FSokobanEngine.redo;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin
  if ActiveControl = nil then
    RedoMoveAction.Execute;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.UpdateStatistics;
begin
  with frmGameDetails do
  begin
    LevelWidthLab.Caption := IntToStr(FSokobanEngine.PuzzleWidth);
    LevHeightLab.Caption := IntToStr(FSokobanEngine.PuzzleHeight);
    StoreLab.Caption := IntToStr(FSokobanEngine.GameData.FCrateTargetCount);
    CratesLab.Caption := IntToStr(FSokobanEngine.GameData.FCratesStoredCount);
    MovesLab.Caption := IntToStr(FSokobanEngine.GameData.FMoves);
    PushesLab.Caption := IntToStr(FSokobanEngine.GameData.FPushes);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.ExitActionExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.ThumbnailActionExecute(Sender: TObject);
begin
  frmThumbnails.LoadThumbNails(FSokobanEngine.PuzzleCollection);
  frmThumbnails.ShowModal;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.ActionManager1Update(Action: TBasicAction; var Handled: boolean);
begin
  if FLevelFileName <> '' then
  begin
    PrevLevelAction.Enabled := LevelNumber > 1;
    UndoMoveAction.Enabled := FSokobanEngine.EnableUndo;
    NextLevelAction.Enabled := LevelNumber < FSokobanEngine.LastLevel;
    ResetLevelAction.Enabled :=
      (FSokobanEngine.GameData.FMoves > 0) or
      (FSokobanEngine.GameData.FPushes > 0);
    SaveLevelAction.Enabled :=
      (FSokobanEngine.GameData.FMoves > 0) or
      (FSokobanEngine.GameData.FPushes > 0);
    RedoMoveAction.Enabled := FSokobanEngine.EnableRedo;
    FirstLevAction.Enabled := True;
    LastLevAction.Enabled := True;
    Handled := True;
  end
  else
  begin
    FirstLevAction.Enabled := False;
    LastLevAction.Enabled := False;
    PrevLevelAction.Enabled := False;
    UndoMoveAction.Enabled := False;
    NextLevelAction.Enabled := False;
    ResetLevelAction.Enabled := False;
    SaveLevelAction.Enabled := False;
    RedoMoveAction.Enabled := False;
    Handled := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.ActStatusBarExecute(Sender: TObject);
begin
  StatusBar.Visible := ActStatusBar.Checked;
  FFieldPanel.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.AboutActionExecute(Sender: TObject);
begin
  AboutBox.ActSkinLab.Caption := 'Active skin:          ' + FSkinData.FAuthor;
  AboutBox.ActLevLab.Caption :=
    'Active levelset:    ' + FSokobanEngine.PuzzleCollection.Copyright;
  AboutBox.Show;
  AboutBox.Hide;
  AboutBox.BringToFront;
  {$IFNDEF FPC}
  AnimateWindow(AboutBox.Handle, 1000, AW_BLEND);
  {$ENDIF}
  AboutBox.Show;
  AboutBox.OKButton.Repaint; // For some reason the button does not get painted
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.AboutLsetActionExecute(Sender: TObject);
begin
  with frmLevInfo do
  begin
    LevName.Caption := FSokobanEngine.PuzzleCollection.Title;
    DescMem.Lines.Text := FSokobanEngine.PuzzleCollection.Description;
    LevCopyright.Caption := FSokobanEngine.PuzzleCollection.Copyright;
    LevMail.Caption := FSokobanEngine.PuzzleCollection.Email;
    ShowModal;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.AboutSkinActionExecute(Sender: TObject);
begin
  with frmSkinInfo do
  begin
    SkinName.Caption := FSkinData.FName;
    SkinAuthor.Caption := FSkinData.FAuthor;
    SkinCopyright.Caption := FSkinData.FCopyright;
    SkinWebsite.Caption := FSkinData.FWebsite;
    SkinMail.Caption := FSkinData.FEmail;
    DescMem.Lines.Text := FSkinData.FDescription;
    ShowModal;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmSokoban.ShowDetailsActionExecute(Sender: TObject);
begin
  UpdateStatistics;
  frmGameDetails.Show;
end;


procedure TfrmSokoban.PartTogether(const Levelset:TPuzzleCollectionData);
var
  x, y: integer;
  FLevelSolved: Boolean;
begin

  for y := 0 to Levelset.NumberOfLevels-1 do
  begin
  for x := 0 to Pred(Length(FLevelsPlayed)) do
  begin // Set the caption
    FLevelSolved :=
      (FLevelsPlayed[x].FLevelNumberPlayed = y + 1) and
      (LowerCase(FLevelsPlayed[x].FDataFileName) =
      LowerCase(ExtractFileName(FLevelFileName)));
    if FLevelSolved then
      LevelCB.ItemsEx[y].ImageIndex := 9
    else
      LevelCB.ItemsEx[y].ImageIndex := -1;
  end;
  end;
  LevelCB.Repaint;
  InitLevel;
end;

//------------------------------------------------------------------------------

procedure TCanvasPanel.Paint;
begin
  if Assigned(FOnPaint) then
    FOnPaint(Self);
end;

constructor TCanvasPanel.Create(TheOwner: TComponent);
begin
  inherited;
  FPathFinder:= TPathFinder.Create;
end;

destructor TCanvasPanel.Destroy;
begin
  FreeAndNil(FPathFinder);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TCanvasPanel.StopFlicker(var Msg: TWMEraseBkgnd);
begin
  Msg.Result := 1;
end;

end.
