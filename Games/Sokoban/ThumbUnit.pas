unit ThumbUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  XMLIntf, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
   SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, SokoEngine;

type
  TfrmThumbnails = class(TForm)
    ListView: TListView;
    LoadBut: TButton;
    CancelBut: TButton;
    LevelImages: TImageList;
    procedure LoadButClick(Sender: TObject);
    procedure CancelButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure LoadThumbNails(const Levelset:TPuzzleCollectionData);
  end;

var
  frmThumbnails: TfrmThumbnails;

implementation

uses MainUnit;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmThumbnails.LoadThumbNails;
var
  Bmp: TBitmap;
  i, x, y: integer;

  procedure FillPixels(AXPos, AYPos: integer; Color: TColor);
  var
    x, y: integer;
  begin
    for x := 0 to 1 do
      for y := 0 to 1 do
        Bmp.Canvas.Pixels[AXPos * 2 + x, AYPos * 2 + y] := Color;
  end;
begin
  Screen.Cursor := crHourGlass;
  ListView.Clear;
  LevelImages.Clear;

  Bmp := TBitmap.Create;
  Bmp.Width := 50;
  Bmp.Height := 50;
  try
    for i := 0 to Length(Levelset.FPuzzleFields) - 1 do
    begin
      Bmp.Canvas.Brush.Color := clFuchsia;
      Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));

      for y := 0 to Length(Levelset.FPuzzleFields[i][0]) - 1 do
        for x := 0 to Length(Levelset.FPuzzleFields[i]) - 1 do
        begin
          if (x > 50) or (y > 50) then
            Break;

          case Levelset.FPuzzleFields[i][x, y].FPartType of
            ptWall: FillPixels(x, y, clGray);
            ptPlayer: FillPixels(x, y, clYellow);
            ptCrate: FillPixels(x, y, clRed);
            ptNone:
              if Levelset.FPuzzleFields[i][x, y].FIsCrateTarget then
                FillPixels(x, y, clLime)
              else
                FillPixels(x, y, clWhite);
          end;
        end;

      LevelImages.AddMasked(Bmp, clFuchsia);
      ListView.Items.Add;
      ListView.Items[i].Caption := IntToStr(i + 1);
      ListView.Items[i].ImageIndex := i;
    end;
  finally
    Bmp.Free;
    Screen.Cursor := crDefault;
  end;
end;

{procedure TfrmThumbnails.LoadThumbNails;
var
  Bmp, Mask: TBitmap;
  x, AXPos, AYPos, LevelWidth, LevelHeight, ParentX, ParentY: integer;
  FirstNode, LevelNode: IXMLNode;
  LevelRow: string;
  Canaccess: array of array of Boolean;

  procedure CheckTransparency(AXPos, AYPos: Smallint);
    function AllowNextStep(ANextX, ANextY: Smallint): Boolean;
    begin
      if (ANextX < 0) or (ANextY < 0) then
        Result := False
      else
        Result := (CanAccess[ANextX div 2, ANextY div 2]) and
          (Bmp.Canvas.Pixels[ANextX, ANextY] <> clGray);
    end;
  begin
    Mask.Canvas.Pixels[AXPos, AYPos] := clBlack;
    Mask.Canvas.Pixels[AXPos + 1, AYPos] := clBlack;
    Mask.Canvas.Pixels[AXPos, AYPos + 1] := clBlack;
    Mask.Canvas.Pixels[AXPos + 1, AYPos + 1] := clBlack;
    CanAccess[AXPos div 2, AYPos div 2] := False;

    if AllowNextStep(AXPos, AYPos - 2) then
      CheckTransparency(AXPos, AYPos - 2);
    if AllowNextStep(AXPos + 2, AYPos) then
      CheckTransparency(AXPos + 2, AYPos);
    if AllowNextStep(AXPos, AYPos + 2) then
      CheckTransparency(AXPos, AYPos + 2);
    if AllowNextStep(AXPos - 2, AYPos) then
      CheckTransparency(AXPos - 2, AYPos);
  end;

  procedure FillPixels(AXPos, AYPos: integer; Color: TColor);
  var
    x, y: integer;
  begin
    for x := 0 to 1 do
      for y := 0 to 1 do
      begin
        Bmp.Canvas.Pixels[AXPos * 2 + x,
          AYPos * 2 + y] := Color;
        if Color <> clWhite then
          Mask.Canvas.Pixels[AXPos * 2 + x,
            AYPos * 2 + y] := clBlack;
      end;
  end;
begin
  ListView.Clear;
  ParentX := 0;
  ParentY := 0;
  try
    FirstNode := frmSokoban.LevelDoc.DocumentElement.ChildNodes.
      FindNode('LevelCollection');

    Bmp := TBitmap.Create;
    Mask := TBitmap.Create;
    try
      for x := 0 to FirstNode.ChildNodes.Count - 1 do
      begin
        LevelNode := FirstNode.ChildNodes.Nodes[x];
        LevelWidth := StrToInt(LevelNode.Attributes['Width']);
        LevelHeight := StrToInt(LevelNode.Attributes['Height']);
        Bmp.Height := LevelHeight * 2;
        Bmp.Width := LevelWidth * 2;
        Mask.Height := Bmp.Height;
        Mask.Width := Bmp.Width;

        Mask.Canvas.Brush.Color := clWhite;
        Mask.Canvas.FillRect(Mask.Canvas.ClipRect);
        Bmp.Canvas.Brush.Color := clWhite;
        Bmp.Canvas.FillRect(Bmp.Canvas.ClipRect);

        for AYPos := 0 to LevelHeight - 1 do
        begin
          LevelRow := LevelNode.ChildNodes.Nodes[AYPos].Text;
          for AXPos := 1 to Length(LevelRow) do
          begin
            if LevelRow[AXPos] = '.' then
              FillPixels(AXPos - 1, AYPos, clLime);
            if LevelRow[AXPos] = '#' then
              FillPixels(AXPos - 1, AYPos, clGray);
            if (LevelRow[AXPos] = '$') or
              (LevelRow[AXPos] = '*') then
              FillPixels(AXPos - 1, AYPos, clRed);
            if LevelRow[AXPos] = ' ' then
              FillPixels(AXPos - 1, AYPos, clWhite);
            if (LevelRow[AXPos] = '@') or
              (LevelRow[AXPos] = '+') then
            begin
              FillPixels(AXPos - 1, AYPos, clYellow);
              ParentX := AXPos - 1;
              ParentY := AYPos;
            end;
          end;
        end;

        SetLength(CanAccess, LevelWidth);

        for AXPos := 0 to High(CanAccess) do
        begin
          SetLength(CanAccess[AXPos], LevelHeight);
          for AYPos := 0 to High(CanAccess[0]) do
            CanAccess[AXPos, AYPos] := True;
        end;

        CheckTransparency(ParentX * 2, ParentY * 2);
        Bmp.Width := 50;
        Bmp.Height := 50;
        Mask.Width := 50;
        Mask.Height := 50;
        LevelImages.Add(Bmp, Mask);
        ListView.Items.Add;
        ListView.Items[x].Caption := IntToStr(x + 1);
        ListView.Items[x].ImageIndex := x;
      end;
    finally
      Bmp.Free;
      Mask.Free;
    end;
  except
    MessageBox(Handle, PChar('The thumbnails could not be displayed!' + #13#10
      + 'Please send an e-mail to benruyl@zonnet.nl.'), 'Error', MB_OK or
      MB_ICONERROR);
  end;
end;    }

procedure TfrmThumbnails.LoadButClick(Sender: TObject);
begin
  if ListView.Selected <> nil then
  begin
    frmSokoban.LevelNumber := Succ(ListView.Selected.Index);
    frmSokoban.InitLevel;
    Close;
  end;
end;

procedure TfrmThumbnails.CancelButClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmThumbnails.FormCreate(Sender: TObject);
begin
  ListView.DoubleBuffered := True;
end;

end.
