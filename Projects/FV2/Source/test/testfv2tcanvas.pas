unit testfv2tcanvas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, fv2drivers, fv2tCanvas;

type

  { TTestTCanvas }

  TTestTCanvas= class(TTestCase)
  Private
    FCanvas:TTCanvas;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPixels1;
    procedure TestPixels2;
    procedure TestSetvideomode;
    procedure TestRectangle;
    procedure TestOutText;
    procedure TestOutBound;
    procedure TestFillRect;
    Procedure TestLineto;
  end;

implementation

uses fv2VisConsts,Video, Dialogs;

procedure TTestTCanvas.TestPixels1;
var
  X, Y: Integer;
  Dcc:Word;
begin
  DetectVideo;
  InitVideo;
  try
  CheckNotEquals(PtrUint(nil),PtrUInt(video.VideoBuf),'VideoBuffer should be assigned');
  MoveStr(video.VideoBuf^,'This is a Test',$17,0);
  for X := 0 to FCanvas.Width do
    for Y := 0 to FCanvas.Height do
      begin
        dcc:=$1F00 or ((x+y*32) mod 256);
        FCanvas.Pixels[X,y] := dcc;
      end;
  Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);
//ToDo: Test the results
//ToDo: Test-text must not be changed
//", and in the middle are many Characters, White on blue
  CheckEquals(6, MessageDlg('Please Verify', '"This is a Test" is still readable',
    mtConfirmation, mbYesNo, 0), 'Err: Over written Backgroound');
  CheckEquals(6, MessageDlg('Please Verify', 'In the middle are many Characters in white on blue',
    mtConfirmation, mbYesNo, 0), 'Something went wrong');

  finally
  DoneVideo;
  end;
end;

procedure TTestTCanvas.TestPixels2;
var
  X, Y: Integer;
  Dcc:Word;
  vm: TVideoMode;
begin
  DetectVideo;
    InitVideo;
    try
    vm.col:=fv2drivers.ScreenMode.Col;
     vm.Row:=fv2drivers.ScreenMode.Row;
     vm.Color:=true;
     SetVideoMode(vm);
     CheckNotEquals(PtrUint(nil),PtrUInt(video.VideoBuf),'VideoBuffer should be assigned');
    MoveStr(video.VideoBuf^,'This is a Test',$17,46*ScreenMode.col);
    for X := 0 to FCanvas.Width do
      for Y := 0 to FCanvas.Height do
        begin
          case x div 16 of
            0:dcc:=word(chEmptyFill);
            1:dcc:=word(chLowFill);
            2:dcc:=word(chMiddleFill);
            3:dcc:=word(chHighFill);
            else
              dcc:=word(chFullFill);
            end;
          dcc:=dcc or (((x mod 16) +y*16) mod 256)*$100;
          FCanvas.Pixels[X,y] := dcc;
        end;
    Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);
  //ToDo: Test the results
  //ToDo: Test-text must not be changed
  //", and in the middle are many Characters, White on blue
  //DoneVideo;
    CheckEquals(6, MessageDlg('Please Verify', '"This is a Test" is still readable',
      mtConfirmation, mbYesNo, 0), 'Err: Over written Backgroound');
    CheckEquals(6, MessageDlg('Please Verify', 'In the middle are coloured blocks',
      mtConfirmation, mbYesNo, 0), 'Something went wrong');

    finally
    DoneVideo;
    end;
end;

procedure TTestTCanvas.TestSetvideomode;
var   vm, vm2:TVideoMode;
begin
  InitVideo;
  try
  vm.col:=fv2drivers.ScreenMode.Col;
  vm.Row:=fv2drivers.ScreenMode.Row;
  vm.Color:=true;
  SetVideoMode(vm);
  MoveStr(video.VideoBuf^,'<- Top Left',$17,0*ScreenMode.col);
   MoveStr(video.VideoBuf^,'<- Bottom Left',$17,(vm.Row-1)*ScreenMode.col);
   MoveStr(video.VideoBuf^,'Top Right ->',$17,ScreenMode.col-12);
   MoveStr(video.VideoBuf^,'Bottom Right>',$17,vm.Row*ScreenMode.col-13);
    UpdateScreen(False);
  CheckEquals(6, MessageDlg('Please Verify', 'The Console is now '+inttostr(vm.Col)+'x'+inttostr(vm.Row),
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');

  vm.col:=80;
  vm.Row:=50;
  vm.Color:=true;
  SetVideoMode(vm);
  MoveStr(video.VideoBuf^,'<- Top Left',$17,0*ScreenMode.col);
  MoveStr(video.VideoBuf^,'<- Bottom Left',$17,(vm.Row-1)*ScreenMode.col);
  MoveStr(video.VideoBuf^,'Top Right ->',$17,ScreenMode.col-12);
  MoveStr(video.VideoBuf^,'Bottom Right>',$17,vm.Row*ScreenMode.col-13);
   UpdateScreen(False);
  CheckEquals(6, MessageDlg('Please Verify', 'The Console is now '+inttostr(vm.Col)+'x'+inttostr(vm.Row),
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');


  vm.col:=80;
  vm.Row:=63;
  vm.Color:=true;
  SetVideoMode(vm);

  GetVideoMode(vm2);
  MoveStr(video.VideoBuf^,'<- Top Left',$17,0*ScreenMode.col);
  MoveStr(video.VideoBuf^,'<- Bottom Left',$17,(vm.Row-1)*ScreenMode.col);
  MoveStr(video.VideoBuf^,'Top Right ->',$17,ScreenMode.col-12);
  MoveStr(video.VideoBuf^,'Bottom Right>',$17,vm.Row*ScreenMode.col-13);
   UpdateScreen(False);
  CheckEquals(6, MessageDlg('Please Verify', 'The Console is now '+inttostr(vm.Col)+'x'+inttostr(vm.Row),
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');

  vm.col:=fv2drivers.ScreenMode.Col;
  vm.Row:=fv2drivers.ScreenMode.Row;
  vm.Color:=true;
  SetVideoMode(vm);

  finally
    DoneVideo;
  end;
end;

procedure TTestTCanvas.TestRectangle;
var
  i, j: Integer;
begin
  DetectVideo;
  InitVideo;
  try
  for i := 0 to FCanvas.Height  - 1 do
  begin
    //MoveChar(LBuffer^, chMiddleFill, $08, 50, (i+6) *
    //  fv2drivers.ScreenMode.Col+7);
    if i = 0 then
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[0]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[1]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[2]]);
    end
    else if i <> FCanvas.Height  - 1 then
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[3]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[4]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[5]]);
    end
    else
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[6]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[7]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[8]]);
    end;
  end;
  Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);
  CheckEquals(6, MessageDlg('Please Verify', 'There is a blue rectangle with a white boarder',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
  finally
    DoneVideo;
  end;
end;

procedure TTestTCanvas.TestOutText;
var
  i, j: Integer;
  aFont:TFV2CustomFont;
  vm:TVideoMode;
begin
  InitVideo;
  vm.col:=fv2drivers.ScreenMode.Col;
  vm.Row:=50;
  vm.Color:=true;
  SetVideoMode(vm);
  try
  for i := 0 to FCanvas.Height  - 1 do
  begin
    //MoveChar(LBuffer^, chMiddleFill, $08, 50, (i+6) *
    //  fv2drivers.ScreenMode.Col+7);
    if i = 0 then
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[0]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[1]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[2]]);
    end
    else if i <> FCanvas.Height  - 1 then
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[3]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[4]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[5]]);
    end
    else
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[6]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[7]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[8]]);
    end;
  end;
//  Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);
  for i := 1 to FCanvas.Height-2 do
    begin
      aFont.SetHighlight((i mod 7+1)*16+$f);
      aFont.SetNormal((i mod 7+1)*16+$7);
      Fcanvas.Font := aFont;
      FCanvas.TextOut(1,i,inttostr(i)+': ~T~est     ');
    end;
  Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);
  CheckEquals(6, MessageDlg('Please Verify', 'In a blue rectangle with a white boarder are coloured Numbers starting with 1 an Test with a highlight ''T''',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
  aFont.SetHighlight($4e);
  aFont.SetNormal($46);
  Fcanvas.Font := aFont;
  for i := 1 to FCanvas.Height-2 do
    FCanvas.TextOut(-30+i*2,i,'This ~text~ exeeced the ~width~ of the Canvas');
  Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);
  CheckEquals(6, MessageDlg('Please Verify', 'In a blue rectangle with a white boarder are coloured Numbers starting with 1 an Test with a highlight ''T''',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
  finally
    DoneVideo;
  end
end;

procedure TTestTCanvas.TestOutBound;
var
  i, j: Integer;
  aFont:TFV2CustomFont;
  vm:TVideoMode;
  lCanvas2:TTCanvas;
  Attrs:Word;

begin
  InitVideo;
  vm.col:=fv2drivers.ScreenMode.Col;
  vm.Row:=fv2drivers.ScreenMode.row;
  vm.Color:=true;
  SetVideoMode(vm);
  lCanvas2 := TTCanvas.Create(rect(40,10,110,30));
  try
  for i := 0 to FCanvas.Height  - 1 do
  begin
    //MoveChar(LBuffer^, chMiddleFill, $08, 50, (i+6) *
    //  fv2drivers.ScreenMode.Col+7);
    if i = 0 then
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[0]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[1]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[2]]);
    end
    else if i <> FCanvas.Height  - 1 then
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[3]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[4]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[5]]);
    end
    else
    begin
      FCanvas.Pixels[0,i]:=$1700 or byte(FrameChars_437[InitFrame[6]]);
      for j := 1 to FCanvas.Width  - 2 do
        FCanvas.Pixels[j,i]:=$1700 or byte(FrameChars_437[InitFrame[7]]);
      FCanvas.Pixels[FCanvas.Width  - 1,i]:=$1700 or byte(FrameChars_437[InitFrame[8]]);
    end;
  end;
  Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);

  with lCanvas2 do
  for i := 0 to Height  - 1 do
  begin
    //MoveChar(LBuffer^, chMiddleFill, $08, 50, (i+6) *
    //  fv2drivers.ScreenMode.Col+7);
    Attrs :=  $4e00;
    if i = 0 then
    begin
      Pixels[0,i]:=Attrs or byte(FrameChars_437[InitFrame[0]]);
      for j := 1 to Width  - 2 do
        Pixels[j,i]:=Attrs or byte(FrameChars_437[InitFrame[1]]);
      Pixels[Width  - 1,i]:=Attrs or byte(FrameChars_437[InitFrame[2]]);
    end
    else if i <> Height  - 1 then
    begin
      Pixels[0,i]:=Attrs or byte(FrameChars_437[InitFrame[3]]);
      for j := 1 to Width  - 2 do
        Pixels[j,i]:=Attrs or byte(FrameChars_437[InitFrame[4]]);
      Pixels[Width  - 1,i]:=Attrs or byte(FrameChars_437[InitFrame[5]]);
    end
    else
    begin
      Pixels[0,i]:=Attrs or byte(FrameChars_437[InitFrame[6]]);
      for j := 1 to Width  - 2 do
        Pixels[j,i]:=Attrs or byte(FrameChars_437[InitFrame[7]]);
      Pixels[Width  - 1,i]:=Attrs or byte(FrameChars_437[InitFrame[8]]);
    end;
  end;
  lCanvas2.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);
  CheckEquals(6, MessageDlg('Please Verify', 'A blue rectangle in front of a red with a yellow boarder',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
  Fcanvas.Flush(lCanvas2.ClipRect,false);
  CheckEquals(6, MessageDlg('Please Verify', 'A blue rectangle behind a red with a yellow boarder',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
  finally
    freeandnil(lCanvas2);
    DoneVideo;
  end;
//  Fcanvas.Flush(rect(0,0,ScreenMode.Col,ScreenMode.Row),false);

end;

procedure TTestTCanvas.TestFillRect;
var aBrush:TFV2CustomBrush;
  vm: TVideoMode;
  Attrs:word;
  i, t: Integer;
  OffsetDt:array[0..11,0..8] of integer ;
  po:array[0..11] of  TPoint;
begin
  for i := 0 to 11 do
   for t := 0 to 8 do
    begin
      po[i]:=point(round(cos(i/6*pi)*2.2+3.0),round(sin(i/6*pi)*2.2+3.0));
      offsetdt[i,t]:=(((t mod 3)+po[i].x ) mod 3) + (((t div 3)+po[i].y)mod 3)*3;
    end;
  InitVideo;
  try
  vm.col:=fv2drivers.ScreenMode.Col;
  vm.Row:=50;
  vm.Color:=true;
  SetVideoMode(vm);

  aBrush.BrushSize := point(3,3);
  setlength(aBrush.BrushData,9);
  Attrs := $4e00;
  for t := 0 to 50 do
  begin
  for i := 0 to 8 do
    aBrush.BrushData[i ] :=Attrs or byte(FrameChars_437[InitFrame[OffsetDt[t mod 12,i]]]);
  Fcanvas.Brush := aBrush;
  FCanvas.FillRect(rect(0,0,FCanvas.Width,FCanvas.Height));
  Fcanvas.Flush(rect(0,0,ScreenMode.col,ScreenMode.row),false);
  sleep(250);
  end;
  CheckEquals(6, MessageDlg('Please Verify', 'A red rectangle with a yellow line-shape',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
  finally
    DoneVideo;
  end;
end;

procedure TTestTCanvas.TestLineto;
var aPen:TFV2CustomPen;
  pp:Tpoint;
  vm: TVideoMode;
  Attrs:word;
  i: Integer;
begin
  InitVideo;
  try
  vm.col:=fv2drivers.ScreenMode.Col;
  vm.Row:=50;
  vm.Color:=true;
  SetVideoMode(vm);

  aPen.Width := 1;
  apen.attr := $4c;
  FCanvas.Pen := aPen;
  with FCanvas do
  for i := 0 to 1000 do
    begin
      pp:=point(random(Width-2),Random(height-1));
      if pp.x>=penpos.x then inc(pp.x);
      if pp.y>=penpos.y then inc(pp.y);
      if i= 0 then
        Moveto(pp)
      else
        begin
          LineTo(point(Penpos.x,pp.y));
          LineTo(pp);
          aPen := pen;
          apen.attr := random(254)+1;
          pen := apen;
          sleep(10);
          Fcanvas.Flush(rect(0,0,ScreenMode.col,ScreenMode.row),false);
        end;
    end;
  Fcanvas.Flush(rect(0,0,ScreenMode.col,ScreenMode.row),false);
  CheckEquals(6, MessageDlg('Please Verify', 'A Lot of colored Lines were drawn on the Screen',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
  finally
    DoneVideo;
  end;
end;

procedure TTestTCanvas.SetUp;
begin
  DetectVideo;
  FCanvas:=TTCanvas.Create(rect(3,3,77,45));
end;

procedure TTestTCanvas.TearDown;
begin
  Freeandnil(FCanvas);
end;

initialization

  RegisterTest(TTestTCanvas);
end.

