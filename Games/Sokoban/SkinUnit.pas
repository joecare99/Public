unit SkinUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Graphics, Classes, SysUtils, Dialogs, IniFiles;

procedure LoadSkin(AFileName: string);
procedure CreateBitmaps;
procedure FreeBitmaps;

var
  FBackground, FFullBackGround, FEmpty, FPlayerUp, FPlayerUpStore,
    FPlayerRight, FPlayerRightStore, FPlayerDown, FPlayerDownStore,
    FPlayerLeft, FPlayerLeftStore, FStore, FCrate, FCrateStore,
    FWall, FWallUp, FWallDown, FWallLeft, FWallRight, FWallUpDown,
    FWallUpLeft, FWallUpRight, FWallDownLeft, FWallDownRight,
    FWallLeftRight, FWallUpDownLeft, FWallUpDownRight, FWallUpLeftRight,
    FWallDownLeftRight, FWallUpDownLeftRight, FLowerLayer, FUpperLayer,
    FCollected: TBitmap;

implementation

uses MainUnit;

{$IFNDEF FPC}
const DirectorySeparator=PathDelim;
{$ENDIF}


procedure CreateBitmaps;
begin
  FCollected := TBitmap.Create;
  FLowerLayer := TBitmap.Create;
  FUpperLayer := TBitmap.Create;
  FBackground := TBitmap.Create;
  FFullBackGround := TBitmap.Create;
  FEmpty := TBitmap.Create;
  FPlayerUp := TBitmap.Create;
  FPlayerUpStore := TBitmap.Create;
  FPlayerRight := TBitmap.Create;
  FPlayerRightStore := TBitmap.Create;
  FPlayerDown := TBitmap.Create;
  FPlayerDownStore := TBitmap.Create;
  FPlayerLeft := TBitmap.Create;
  FPlayerLeftStore := TBitmap.Create;
  FStore := TBitmap.Create;
  FCrate := TBitmap.Create;
  FCrateStore := TBitmap.Create;
  FWall := TBitmap.Create;
  FWallUp := TBitmap.Create;
  FWallDown := TBitmap.Create;
  FWallLeft := TBitmap.Create;
  FWallRight := TBitmap.Create;
  FWallUpDown := TBitmap.Create;
  FWallUpLeft := TBitmap.Create;
  FWallUpRight := TBitmap.Create;
  FWallDownLeft := TBitmap.Create;
  FWallDownRight := TBitmap.Create;
  FWallLeftRight := TBitmap.Create;
  FWallUpDownLeft := TBitmap.Create;
  FWallUpDownRight := TBitmap.Create;
  FWallUpLeftRight := TBitmap.Create;
  FWallDownLeftRight := TBitmap.Create;
  FWallUpDownLeftRight := TBitmap.Create;
end;

procedure LoadSkin(AFileName: string);
var
  SkinIni: TIniFile;
  BackgroundFile, SkinFile, TempStr, Color: string;
  RealWidth, RealHeight, X, Y, Z: Integer;
  SkinBmp: TBitmap;
begin
  SkinIni := TIniFile.Create(AFileName);
  try
    try
      BackgroundFile := SkinIni.ReadString('background', 'image', '');

      FSkinData.FName := SkinIni.ReadString('header', 'name', '');
      FSkinData.FAuthor := SkinIni.ReadString('header', 'author', '');
      FSkinData.FCopyright := SkinIni.ReadString('header', 'copyright', '');
      FSkinData.FDescription := SkinIni.ReadString('header', 'description',
        '');
      FSkinData.FWebsite := SkinIni.ReadString('header', 'website', '');
      FSkinData.FEmail := SkinIni.ReadString('header', 'email', '');

      SkinFile := SkinIni.ReadString('tiles', 'combined_file', '');
      RealHeight := SkinIni.ReadInteger('tiles', 'real_height', 40);
      RealWidth := SkinIni.ReadInteger('tiles', 'real_width', 40);
      FSkinData.FMinVSize := SkinIni.ReadInteger('tiles', 'height',
        RealHeight);
      FSkinData.FMinHSize := SkinIni.ReadInteger('tiles', 'width', RealWidth);
      FSkinData.FSizeH := RealWidth;
      FSkinData.FSizeV := RealHeight;
      FSkinData.FMustUseLayers := (FSkinData.FSizeH <>
        FSkinData.FMinHSize) or (FSkinData.FSizeV <> FSkinData.FMinVSize);
      FSkinData.FMustRedrawLayer := True;

      FSkinData.FHasBackgroundImage := True;
      if BackgroundFile = '' then
      begin
        FSkinData.FHasBackgroundImage := False;
        Color := SkinIni.ReadString('background', 'color',
          '000001');
        if Color <> '000001' then
          FSkinData.FBackgroundColor := RGB(StrToInt('$' + Copy(Color, 1, 2)),
            StrToInt('$' + Copy(Color, 3, 2)), StrToInt('$' + Copy(Color, 5,
            2)))
        else
          FSkinData.FBackgroundColor := clBlack;

        FBackground.Canvas.Brush.Color := FSkinData.FBackgroundColor;
        FBackground.Canvas.FillRect(FBackground.Canvas.ClipRect);
      end
      else
        FBackground.LoadFromFile(ExtractFilePath(AFileName) +
          DirectorySeparator + BackgroundFile);

      Color := SkinIni.ReadString('tiles', 'transparent_color',
        '000001');
      FSkinData.FTransparentColor := RGB(StrToInt('$' + Copy(Color, 1, 2)),
        StrToInt('$' + Copy(Color, 3, 2)), StrToInt('$' + Copy(Color, 5, 2)));

      SkinBmp := TBitmap.Create;
      try
        try
          SkinBmp.LoadFromFile(ExtractFilePath(AFileName) +
            DirectorySeparator + SkinFile);
        //  SkinIni.ReadInteger()
          TempStr := SkinIni.ReadString('tiles', 'ground', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FEmpty.Width := RealWidth;
          FEmpty.Height := RealHeight;
          FEmpty.TransparentColor := FSkinData.FTransparentColor;
          FEmpty.Transparent := True;
          FEmpty.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'object', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FCrate.Width := RealWidth;
          FCrate.Height := RealHeight;
          FCrate.TransparentColor := FSkinData.FTransparentColor;
          FCrate.Transparent := True;
          FCrate.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'object_store', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FCrateStore.Width := RealWidth;
          FCrateStore.Height := RealHeight;
          FCrateStore.TransparentColor := FSkinData.FTransparentColor;
          FCrateStore.Transparent := True;
          FCrateStore.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'store', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FStore.Width := RealWidth;
          FStore.Height := RealHeight;
          FStore.TransparentColor := FSkinData.FTransparentColor;
          FStore.Transparent := True;
          FStore.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_up', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerUp.Width := RealWidth;
          FPlayerUp.Height := RealHeight;
          FPlayerUp.TransparentColor := FSkinData.FTransparentColor;
          FPlayerUp.Transparent := True;
          FPlayerUp.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_left', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerLeft.Width := RealWidth;
          FPlayerLeft.Height := RealHeight;
          FPlayerLeft.TransparentColor := FSkinData.FTransparentColor;
          FPlayerLeft.Transparent := True;
          FPlayerLeft.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_right', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerRight.Width := RealWidth;
          FPlayerRight.Height := RealHeight;
          FPlayerRight.TransparentColor := FSkinData.FTransparentColor;
          FPlayerRight.Transparent := True;
          FPlayerRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_down', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerDown.Width := RealWidth;
          FPlayerDown.Height := RealHeight;
          FPlayerDown.TransparentColor := FSkinData.FTransparentColor;
          FPlayerDown.Transparent := True; ;
          FPlayerDown.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_up_store', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerUpStore.Width := RealWidth;
          FPlayerUpStore.Height := RealHeight;
          FPlayerUpStore.TransparentColor := FSkinData.FTransparentColor;
          FPlayerUpStore.Transparent := True;
          FPlayerUpStore.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_left_store', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerLeftStore.Width := RealWidth;
          FPlayerLeftStore.Height := RealHeight;
          FPlayerLeftStore.TransparentColor := FSkinData.FTransparentColor;
          FPlayerLeftStore.Transparent := True;
          FPlayerLeftStore.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_right_store', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerRightStore.Width := RealWidth;
          FPlayerRightStore.Height := RealHeight;
          FPlayerRightStore.TransparentColor := FSkinData.FTransparentColor;
          FPlayerRightStore.Transparent := True;
          FPlayerRightStore.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'mover_down_store', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FPlayerDownStore.Width := RealWidth;
          FPlayerDownStore.Height := RealHeight;
          FPlayerDownStore.TransparentColor := FSkinData.FTransparentColor;
          FPlayerDownStore.Transparent := True;
          FPlayerDownStore.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWall.Width := RealWidth;
          FWall.Height := RealHeight;
          FWall.TransparentColor := FSkinData.FTransparentColor;
          FWall.Transparent := True;
          FWall.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUp.Width := RealWidth;
          FWallUp.Height := RealHeight;
          FWallUp.TransparentColor := FSkinData.FTransparentColor;
          FWallUp.Transparent := True;
          FWallUp.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_d', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallDown.Width := RealWidth;
          FWallDown.Height := RealHeight;
          FWallDown.TransparentColor := FSkinData.FTransparentColor;
          FWallDown.Transparent := True;
          FWallDown.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_l', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallLeft.Width := RealWidth;
          FWallLeft.Height := RealHeight;
          FWallLeft.TransparentColor := FSkinData.FTransparentColor;
          FWallLeft.Transparent := True;
          FWallLeft.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallRight.Width := RealWidth;
          FWallRight.Height := RealHeight;
          FWallRight.TransparentColor := FSkinData.FTransparentColor;
          FWallRight.Transparent := True;
          FWallRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u_d', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUpDown.Width := RealWidth;
          FWallUpDown.Height := RealHeight;
          FWallUpDown.TransparentColor := FSkinData.FTransparentColor;
          FWallUpDown.Transparent := True;
          FWallUpDown.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u_l', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUpLeft.Width := RealWidth;
          FWallUpLeft.Height := RealHeight;
          FWallUpLeft.TransparentColor := FSkinData.FTransparentColor;
          FWallUpLeft.Transparent := True;
          FWallUpLeft.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUpRight.Width := RealWidth;
          FWallUpRight.Height := RealHeight;
          FWallUpRight.TransparentColor := FSkinData.FTransparentColor;
          FWallUpRight.Transparent := True;
          FWallUpRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_d_l', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallDownLeft.Width := RealWidth;
          FWallDownLeft.Height := RealHeight;
          FWallDownLeft.TransparentColor := FSkinData.FTransparentColor;
          FWallDownLeft.Transparent := True;
          FWallDownLeft.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_d_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallDownRight.Width := RealWidth;
          FWallDownRight.Height := RealHeight;
          FWallDownRight.TransparentColor := FSkinData.FTransparentColor;
          FWallDownRight.Transparent := True;
          FWallDownRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_l_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallLeftRight.Width := RealWidth;
          FWallLeftRight.Height := RealHeight;
          FWallLeftRight.TransparentColor := FSkinData.FTransparentColor;
          FWallLeftRight.Transparent := True;
          FWallLeftRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u_d_l', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUpDownLeft.Width := RealWidth;
          FWallUpDownLeft.Height := RealHeight;
          FWallUpDownLeft.TransparentColor := FSkinData.FTransparentColor;
          FWallUpDownLeft.Transparent := True;
          FWallUpDownLeft.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u_d_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUpDownRight.Width := RealWidth;
          FWallUpDownRight.Height := RealHeight;
          FWallUpDownRight.TransparentColor := FSkinData.FTransparentColor;
          FWallUpDownRight.Transparent := True;
          FWallUpDownRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u_l_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUpLeftRight.Width := RealWidth;
          FWallUpLeftRight.Height := RealHeight;
          FWallUpLeftRight.TransparentColor := FSkinData.FTransparentColor;
          FWallUpLeftRight.Transparent := True;
          FWallUpLeftRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_d_l_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallDownLeftRight.Width := RealWidth;
          FWallDownLeftRight.Height := RealHeight;
          FWallDownLeftRight.TransparentColor := FSkinData.FTransparentColor;
          FWallDownLeftRight.Transparent := True;
          FWallDownLeftRight.Canvas.CopyRect(Rect(0, 0, RealWidth, RealHeight),
            SkinBmp.Canvas, Rect(X, Y, X + RealWidth, Y + RealHeight));

          TempStr := SkinIni.ReadString('tiles', 'wall_u_d_l_r', '');
          Z := Pos(' ', TempStr);
          X := StrToInt(Copy(TempStr, 1, Z - 1));
          Y := StrToInt(Copy(TempStr, Z, Length(TempStr)));
          FWallUpDownLeftRight.Width := RealWidth;
          FWallUpDownLeftRight.Height := RealHeight;
          FWallUpDownLeftRight.TransparentColor := FSkinData.FTransparentColor;
          FWallUpDownLeftRight.Transparent := True;
          FWallUpDownLeftRight.Canvas.CopyRect(Rect(0, 0, RealWidth,
            RealHeight), SkinBmp.Canvas,
            Rect(X, Y, X + RealWidth, Y + RealHeight));

          FSkinFileName := AFileName;
        except
          MessageBox(0, 'Error loading skin!' + #13#10 +
            'Please send an e-mail to benruyl@zonnet.nl.',
            'Error', MB_OK or MB_ICONERROR);
        end;
      finally
        SkinBmp.Free;
      end;
    except
      MessageBox(0, 'Error loading skin!' + #13#10 +
        'Please send an e-mail to benruyl@zonnet.nl.',
        'Error', MB_OK or MB_ICONERROR);
    end;
  finally
    SkinIni.Free;
  end;
end;

procedure FreeBitmaps;
begin
  FreeAndNil(FCollected);
  FreeAndNil(FLowerLayer);
  FreeAndNil(FUpperLayer);
  FreeAndNil(FBackground);
  FreeAndNil(FFullBackGround);
  FreeAndNil(FEmpty);
  FreeAndNil(FPlayerUp);
  FreeAndNil(FPlayerUpStore);
  FreeAndNil(FPlayerRight);
  FreeAndNil(FPlayerRightStore);
  FreeAndNil(FPlayerDown);
  FreeAndNil(FPlayerDownStore);
  FreeAndNil(FPlayerLeft);
  FreeAndNil(FPlayerLeftStore);
  FreeAndNil(FStore);
  FreeAndNil(FCrate);
  FreeAndNil(FCrateStore);
  FreeAndNil(FWall);
  FreeAndNil(FWallUp);
  FreeAndNil(FWallDown);
  FreeAndNil(FWallLeft);
  FreeAndNil(FWallRight);
  FreeAndNil(FWallUpDown);
  FreeAndNil(FWallUpLeft);
  FreeAndNil(FWallUpRight);
  FreeAndNil(FWallDownLeft);
  FreeAndNil(FWallDownRight);
  FreeAndNil(FWallLeftRight);
  FreeAndNil(FWallUpDownLeft);
  FreeAndNil(FWallUpDownRight);
  FreeAndNil(FWallUpLeftRight);
  FreeAndNil(FWallDownLeftRight);
  FreeAndNil(FWallUpDownLeftRight);
end;

end.
