unit testfv2Driver;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  { TTestFV2Drivers }

  TTestFV2Drivers = class(TTestCase)
  published
    procedure TestDetectVideo;
    procedure TestCStrLen;
    procedure TestMoveChar;
    procedure TestMoveStr;
  end;

implementation

uses fv2drivers, fv2VisConsts, Dialogs;

procedure TTestFV2Drivers.TestDetectVideo;
begin
  DetectVideo;
  CheckEquals(80, fv2drivers.ScreenMode.Col, 'Detected Screenwidth: 80');
  CheckEquals(63, fv2drivers.ScreenMode.Row, 'Detected ScreenHeight: 63');
  CheckEquals(True, fv2drivers.ScreenMode.Color, 'Detected Screencolor: true');
end;

procedure TTestFV2Drivers.TestCStrLen;
begin
  CheckEquals(5, CStrLen('Hallo'), 'Normal Length');
  CheckEquals(4, CStrLen('~T~est'), 'Test Length');
  CheckEquals(13, CStrLen('Tes~t~ of T~h~eme'), 'Test Length 2');
  CheckEquals(4, CStrLen('~T~es~t'), 'Test Length 3');
  CheckEquals(5, CStrLen('~T~ilde~~'), 'Test Length 5');
end;

procedure TTestFV2Drivers.TestMoveChar;

var
  LBuffer: PVideoBuf;
  i: integer;
begin
  InitVideo;
  CheckNotEquals(ptrint(nil), ptrint(VideoBuf),
    'VideoBuffer should be assigned now');
  LBuffer := VideoBuf;
  for i := 0 to fv2drivers.ScreenMode.Row - 1 do
    MoveChar(LBuffer^, chMiddleFill, $17, fv2drivers.ScreenMode.Col, i *
      fv2drivers.ScreenMode.Col);
  UpdateScreen(False);
  CheckEquals(6, MessageDlg('Please Verify', 'Is the Screen now gray-filled ?',
    mtConfirmation, mbYesNo, 0), 'Something went wrong');
  DoneVideo;
end;

procedure TTestFV2Drivers.TestMoveStr;
var
  LBuffer: PVideoBuf;
  i, dd: integer;
begin
  DetectVideo;
  initVideo;
  CheckNotEquals(ptrint(nil), ptrint(VideoBuf),
    'VideoBuffer should be assigned now');
  LBuffer := VideoBuf;
  for i := 0 to fv2drivers.ScreenMode.Row - 1 do
    MoveChar(LBuffer^, chMiddleFill, $71, fv2drivers.ScreenMode.Col, i *
      fv2drivers.ScreenMode.Col);
  dd := 10;
  for i := 0 to dd - 1 do
  begin
    MoveChar(LBuffer^, chMiddleFill, $08, 50, (i+6) *
      fv2drivers.ScreenMode.Col+7);
    if i = 0 then
    begin
      MoveChar(LBuffer^, FrameChars_437[InitFrame[0]], $17, 1,
        (i + 5) * fv2drivers.ScreenMode.Col + 5);
      MoveChar(LBuffer^, FrameChars_437[InitFrame[1]], $17, 48,
        (i + 5) * fv2drivers.ScreenMode.Col + 6);
      MoveChar(LBuffer^, FrameChars_437[InitFrame[2]], $17, 1,
        (i + 5) * fv2drivers.ScreenMode.Col + 54);
    end
    else if i <> dd - 1 then
    begin
      MoveChar(LBuffer^, FrameChars_437[InitFrame[3]], $17, 1,
        (i + 5) * fv2drivers.ScreenMode.Col + 5);
      MoveChar(LBuffer^, FrameChars_437[InitFrame[4]], $17, 48,
        (i + 5) * fv2drivers.ScreenMode.Col + 6);
      MoveChar(LBuffer^, FrameChars_437[InitFrame[5]], $17, 1,
        (i + 5) * fv2drivers.ScreenMode.Col + 54);
    end
    else
    begin
      MoveChar(LBuffer^, FrameChars_437[InitFrame[6]], $17, 1,
        (i + 5) * fv2drivers.ScreenMode.Col + 5);
      MoveChar(LBuffer^, FrameChars_437[InitFrame[7]], $17, 48,
        (i + 5) * fv2drivers.ScreenMode.Col + 6);
      MoveChar(LBuffer^, FrameChars_437[InitFrame[8]], $17, 1,
        (i + 5) * fv2drivers.ScreenMode.Col + 54);
    end;
  end;
  MoveStr(LBuffer^,' Testfenster ',$17, 5 * fv2drivers.ScreenMode.Col + 15);
  MoveCStr(LBuffer^,'[~'#254'~]',$1a17, 5 * fv2drivers.ScreenMode.Col + 7);
  MoveCStr(LBuffer^,'[~'+chArrowUp+'~]',$1a17, 5 * fv2drivers.ScreenMode.Col + 50);
  MoveCStr(LBuffer^,'    O~k~    ',$2c2e, 12 * fv2drivers.ScreenMode.Col + 42);
  MoveChar(LBuffer^,chHalfBlockU,$01,10, 13 * fv2drivers.ScreenMode.Col + 43);
  MoveChar(LBuffer^,chHalfBlockU,$10,1, 12 * fv2drivers.ScreenMode.Col + 52);
  MoveCStr(LBuffer^,'  ~C~ancel  ',$2c2e, 12 * fv2drivers.ScreenMode.Col + 30);
  MoveChar(LBuffer^,chHalfBlockU,$01,10, 13 * fv2drivers.ScreenMode.Col + 31);
  MoveChar(LBuffer^,chHalfBlockU,$10,1, 12 * fv2drivers.ScreenMode.Col + 40);
  UpdateScreen(False);
    CheckEquals(6, MessageDlg('Please Verify', 'Is the Dialog ''Testfenster'' visible ?',
    mtConfirmation, mbYesNo, 0), 'Something went wrong');
  DoneVideo;
end;



initialization

  RegisterTest(TTestFV2Drivers);
end.
