unit tst_Calc64;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$EndIF}

interface

uses
  Classes, SysUtils, Controls, {$IFNDEF FPC}TestFramework {$ELSE} fpcunit,
  testutils, testregistry {$ENDIF};

type

  { TTestCalc64 }

  TTestCalc64 = class(TTestCase)
  private
    FIdleCnt: Integer;
    FSleeptime: Integer;
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
    procedure EqualswithError;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure PunchIn(aValue: Int64); overload;
    procedure PunchInKey(aValue: Int64);
    procedure CheckEquals(expected, actual: Int64; Msg: string = ''); overload;
  published
    procedure TestSetUp;
    procedure TestMainForm;
    procedure TestAboutForm;
    Procedure TestValue;
    PRocedure TestEntry;
    Procedure TestEntryHex;
    Procedure TestEntrybin;
    PRocedure TestEntryKey;
    Procedure TestEntryKHex;
    Procedure TestEntryKbin;
    Procedure TestOpAdd;
    Procedure TestOpSub;
    procedure TestOpMult;
    procedure TestOpDiv;
    Procedure TestOpNot;
    Procedure TestOpAnd;
    Procedure TestOpOr;
    Procedure TestOpXor;
    Procedure TestForm;
  end;

implementation

uses Forms, Frm_CALC64, Frm_CalcABOUT, StrUtils {$IFNDEF fpc},StrUtilsExt{$ENDIF};

const
  MaxInt64 = not(Int64(1) shl 63);

procedure TTestCalc64.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
  FIdleCnt := 0;
end;

procedure TTestCalc64.EqualswithError;
begin
  frmCalc64Main.btnEquals.Click;
end;

procedure TTestCalc64.SetUp;
begin
  if not assigned(frmCalc64Main) then
    Application.CreateForm(TfrmCalc64Main, frmCalc64Main);
  if not assigned(frmCalcAbout) then
    Application.CreateForm(TfrmCalcAbout, frmCalcAbout);
  frmCalc64Main.DecHexBinButtonClick(frmCalc64Main.decButton);
  FSleeptime := 40;
end;

procedure TTestCalc64.TearDown;
begin
  frmCalc64Main.btnClearClick(nil);
  frmCalc64Main.hide;
  frmCalcAbout.hide;
end;

procedure TTestCalc64.PunchIn(aValue: Int64);
  Procedure Punch(aChar: Char);

  begin
    case aChar of
      '-':
        frmCalc64Main.btnNegateClick(frmCalc64Main.btnNegate);
      '0' .. '9', 'A' .. 'F':
        frmCalc64Main.ButtonDigitClick
          (frmCalc64Main.FindComponent('btn' + aChar))
    else
    end;
    Application.ProcessMessages;
{$IFDEF FPC}
    Application.Idle(false);
{$ENDIF}
    sleep(FSleeptime);
  end;

var
  lNumbers: String;
  i: Integer;
begin
  checktrue(frmCalc64Main.Visible, 'MainForm is not visible');
  // Check Mode
  if frmCalc64Main.decButton.down then
  begin
    lNumbers := inttostr(aValue);
    for i := 1 to length(lNumbers) do
      Punch(lNumbers[i]);
  end
  else if frmCalc64Main.HexButton.down then
  begin
    lNumbers := IntToHex(aValue, 16);
    while (length(lNumbers) > 1) and (lNumbers[1] = '0') do
      delete(lNumbers, 1, 1);
    for i := 1 to length(lNumbers) do
      Punch(lNumbers[i]);
  end
  else if frmCalc64Main.BinButton.down then
  begin
    lNumbers := IntTobin(aValue, 64);
    while (length(lNumbers) > 1) and (lNumbers[1] = '0') do
      delete(lNumbers, 1, 1);
    for i := 1 to length(lNumbers) do
      Punch(lNumbers[i]);
  end;
end;

procedure TTestCalc64.PunchInKey(aValue: Int64);

  Procedure Punch(aChar: Char);

  begin
    case aChar of
      '-', '0' .. '9', 'A' .. 'F':
        frmCalc64Main.FormKeyPress(frmCalc64Main, aChar);
    else
    end;
    Application.ProcessMessages;
        {$IFDEF FPC}
      Application.Idle(false);
    {$ENDIF}
    sleep(FSleeptime);
  end;

var
  lNumbers: String;
  i: Integer;
begin
  checktrue(frmCalc64Main.Visible, 'MainForm is not visible');
  // Check Mode
  if frmCalc64Main.decButton.down then
  begin
    lNumbers := inttostr(aValue);
    for i := 1 to length(lNumbers) do
      Punch(lNumbers[i]);
  end
  else if frmCalc64Main.HexButton.down then
  begin
    lNumbers := IntToHex(aValue, 16);
    while (length(lNumbers) > 1) and (lNumbers[1] = '0') do
      delete(lNumbers, 1, 1);
    for i := 1 to length(lNumbers) do
      Punch(lNumbers[i]);
  end
  else if frmCalc64Main.BinButton.down then
  begin
    lNumbers := IntTobin(aValue, 64);
    while (length(lNumbers) > 1) and (lNumbers[1] = '0') do
      delete(lNumbers, 1, 1);
    for i := 1 to length(lNumbers) do
      Punch(lNumbers[i]);
  end;
end;

procedure TTestCalc64.CheckEquals(expected, actual: Int64; Msg: string);
begin
{$IFDEF FPC}
    AssertEquals(Msg, expected, actual);
{$Else}
  inherited CheckEquals(expected, actual, msg);
{$ENDIF}
end;

procedure TTestCalc64.TestSetUp;
begin
  CheckNotNull(frmCalc64Main, 'Calc32 Mainform is initialized');
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  CheckNotNull(frmCalcAbout, 'Calc About-form is initialized');
  CheckFalse(frmCalcAbout.Visible, 'About is not visible at the moment');
end;

procedure TTestCalc64.TestMainForm;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.Cascade;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.Tile;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmCalc64Main.Visible, 'MainForm is visible now');
end;

procedure TTestCalc64.TestAboutForm;
begin
  CheckFalse(frmCalcAbout.Visible, 'MainForm is not visible at the moment');
  frmCalcAbout.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalcAbout.Visible, 'MainForm is visible now');
  frmCalcAbout.Cascade;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalcAbout.Visible, 'MainForm is visible now');
  frmCalcAbout.Tile;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalcAbout.Visible, 'MainForm is visible now');
  frmCalcAbout.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmCalcAbout.Visible, 'MainForm is visible now');
end;

procedure TTestCalc64.TestValue;
var
  i: Integer;
  lTestInt: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 1234567890;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('1234567890', frmCalc64Main.DecString, 'Display: 1234567890');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('-987654321', frmCalc64Main.DecString, 'Display: -987654321');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 50000 do
  begin
    if i mod 500 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i * 2 div 3333) +
        DupeString(' ', i * 2 div 3333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
    frmCalc64Main.Value := lTestInt;
    CheckEquals(inttostr(lTestInt), frmCalc64Main.DecString,
      'Display[' + inttostr(i) + '].d: ' + inttostr(lTestInt));
    CheckEquals(IntToHex(lTestInt, 16), frmCalc64Main.HexString,
      'Display[' + inttostr(i) + '].h: $' + IntToHex(lTestInt, 16));
    CheckEquals(IntTobin(lTestInt, 64), frmCalc64Main.BinString,
      'Display[' + inttostr(i) + '].b: &' + IntTobin(lTestInt, 64));
    if i mod 100 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestEntry;
var
  i: Integer;
  lTestInt: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  PunchIn(1234567890);
  CheckEquals('1234567890', frmCalc64Main.DecString, 'Display: 1234567890');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  PunchIn(-987654321);
  CheckEquals('-987654321', frmCalc64Main.DecString, 'Display: -987654321');
  lOrgCaption := frmCalc64Main.Caption;
  FSleeptime := 5;
  for i := 0 to 1000 do
  begin
    frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 33) +
      DupeString(' ', i div 33) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if i = 30 then
      FSleeptime := 0;
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
    PunchIn(lTestInt);
    CheckEquals(inttostr(lTestInt), frmCalc64Main.DecString,
      'Display[' + inttostr(i) + ']: ' + inttostr(lTestInt));
    if abs(lTestInt) > MaxInt64 div 10 then
    begin
      PunchIn(random(10));
      // No Change
      CheckEquals(inttostr(lTestInt), frmCalc64Main.DecString,
        'Display[' + inttostr(i) + '].2n: ' + inttostr(lTestInt));
    end
    else
    begin
      PunchIn(0);
      // a Change
      CheckEquals(inttostr(lTestInt * 10), frmCalc64Main.DecString,
        'Display[' + inttostr(i) + '].2p: ' + inttostr(lTestInt * 10));
    end
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestEntryHex;

var
  i: Integer;
  lTestInt: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.DecHexBinButtonClick(frmCalc64Main.HexButton);
  Application.ProcessMessages;
  checktrue(frmCalc64Main.HexButton.down, 'Hex-Mode is selected');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString,
    'Display: 0000000000000000');
  PunchIn($12345678);
  CheckEquals(IntToHex($12345678, 16), frmCalc64Main.HexString,
    'Display: $12345678');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString,
    'Display: 0000000000000000');
  PunchIn(Int64($FEDCBA98));
  CheckEquals(IntToHex($FEDCBA98, 16), frmCalc64Main.HexString,
    'Display: -987654321');
  lOrgCaption := frmCalc64Main.Caption;
  FSleeptime := 5;
  for i := 0 to 1000 do
  begin
    frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 33) +
      DupeString(' ', i div 33) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if i = 30 then
      FSleeptime := 0;
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0000000000000000', frmCalc64Main.HexString,
      'Display: 0000000000000000');
    PunchIn(lTestInt);
    CheckEquals(IntToHex(lTestInt, 16), frmCalc64Main.HexString,
      'Display[' + inttostr(i) + ']: $' + IntToHex(lTestInt, 16));
    if (lTestInt > $FFFFFFFFFFFFFFF) or (lTestInt < 0) then
    begin
      PunchIn(random(16));
      // No Change
      CheckEquals(IntToHex(lTestInt, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2n: $' + IntToHex(lTestInt, 16));
    end
    else
    begin
      PunchIn(0);
      // a Change
      CheckEquals(IntToHex(lTestInt shl 4, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2p: $' + IntToHex(lTestInt shl 4, 16));
    end
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestEntrybin;
var
  i: Integer;
  lTestInt: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.DecHexBinButtonClick(frmCalc64Main.BinButton);
  Application.ProcessMessages;
  checktrue(frmCalc64Main.BinButton.down, 'bin-Mode is selected');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString, 'Display: 0');
  PunchIn($12345678);
  CheckEquals(IntTobin($12345678, 64), frmCalc64Main.BinString,
    'Display: $12345678');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString, 'Display: 0');
  PunchIn(Int64($FEDCBA98));
  CheckEquals(IntTobin($FEDCBA98, 64), frmCalc64Main.BinString,
    'Display: $FEDCBA98');
  lOrgCaption := frmCalc64Main.Caption;
  FSleeptime := 5;
  for i := 0 to 1000 do
  begin
    frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 33) +
      DupeString(' ', i div 33) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if i = 30 then
      FSleeptime := 0;
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0000000000000000', frmCalc64Main.HexString, 'Display: 0');
    PunchIn(lTestInt);
    CheckEquals(IntTobin(lTestInt, 64), frmCalc64Main.BinString,
      'Display[' + inttostr(i) + ']: &' + IntTobin(lTestInt, 64));
    if lTestInt < 0 then
    begin
      PunchIn(random(2));
      // No Change
      CheckEquals(IntToHex(lTestInt, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2n: $' + IntToHex(lTestInt, 16));
    end
    else
    begin
      PunchIn(0);
      // a Change
      CheckEquals(IntToHex(lTestInt shl 1, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2p: $' + IntToHex(lTestInt, 16) +
        ' shl 1');
    end
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestEntryKey;
var
  i: Integer;
  lTestInt: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  PunchInKey(1234567890);
  CheckEquals('1234567890', frmCalc64Main.DecString, 'Display: 1234567890');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  PunchInKey(-987654321);
  CheckEquals('-987654321', frmCalc64Main.DecString, 'Display: -987654321');
  lOrgCaption := frmCalc64Main.Caption;
  FSleeptime := 5;
  for i := 0 to 1000 do
  begin
    frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 33) +
      DupeString(' ', i div 33) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if i = 30 then
      FSleeptime := 0;
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
    PunchInKey(lTestInt);
    CheckEquals(inttostr(lTestInt), frmCalc64Main.DecString,
      'Display[' + inttostr(i) + ']: ' + inttostr(lTestInt));
    if abs(lTestInt) > MaxInt64 div 10 then
    begin
      PunchInKey(random(10));
      // No Change
      CheckEquals(inttostr(lTestInt), frmCalc64Main.DecString,
        'Display[' + inttostr(i) + '].2n: ' + inttostr(lTestInt));
    end
    else
    begin
      PunchInKey(0);
      // a Change
      CheckEquals(inttostr(lTestInt * 10), frmCalc64Main.DecString,
        'Display[' + inttostr(i) + '].2p: ' + inttostr(lTestInt * 10));
    end
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestEntryKHex;
var
  i: Integer;
  lTestInt: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.DecHexBinButtonClick(frmCalc64Main.HexButton);
  Application.ProcessMessages;
  checktrue(frmCalc64Main.HexButton.down, 'Hex-Mode is selected');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString,
    'Display: 0000000000000000');
  PunchInKey($12345678);
  CheckEquals(IntToHex($12345678, 16), frmCalc64Main.HexString,
    'Display: $12345678');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString,
    'Display: 0000000000000000');
  PunchInKey(Int64($FEDCBA98));
  CheckEquals(IntToHex($FEDCBA98, 16), frmCalc64Main.HexString,
    'Display: -987654321');
  lOrgCaption := frmCalc64Main.Caption;
  FSleeptime := 5;
  for i := 0 to 1000 do
  begin
    frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 33) +
      DupeString(' ', i div 33) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if i = 30 then
      FSleeptime := 0;
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0000000000000000', frmCalc64Main.HexString,
      'Display: 0000000000000000');
    PunchInKey(lTestInt);
    CheckEquals(IntToHex(lTestInt, 16), frmCalc64Main.HexString,
      'Display[' + inttostr(i) + ']: $' + IntToHex(lTestInt, 16));
    if (lTestInt > $FFFFFFFFFFFFFFF) or (lTestInt < 0) then
    begin
      PunchInKey(random(16));
      // No Change
      CheckEquals(IntToHex(lTestInt, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2n: $' + IntToHex(lTestInt, 16));
    end
    else
    begin
      PunchInKey(0);
      // a Change
      CheckEquals(IntToHex(lTestInt shl 4, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2p: $' + IntToHex(lTestInt shl 4, 16));
    end
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestEntryKbin;
var
  i: Integer;
  lTestInt: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.DecHexBinButtonClick(frmCalc64Main.BinButton);
  Application.ProcessMessages;
  checktrue(frmCalc64Main.BinButton.down, 'bin-Mode is selected');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString, 'Display: 0');
  PunchInKey($12345678);
  CheckEquals(IntTobin($12345678, 64), frmCalc64Main.BinString,
    'Display: $12345678');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0000000000000000', frmCalc64Main.HexString, 'Display: 0');
  PunchInKey(Int64($FEDCBA98));
  CheckEquals(IntTobin($FEDCBA98, 64), frmCalc64Main.BinString,
    'Display: $FEDCBA98');
  lOrgCaption := frmCalc64Main.Caption;
  FSleeptime := 5;
  for i := 0 to 1000 do
  begin
    frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 33) +
      DupeString(' ', i div 33) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if i = 30 then
      FSleeptime := 0;
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0000000000000000', frmCalc64Main.HexString, 'Display: 0');
    PunchInKey(lTestInt);
    CheckEquals(IntTobin(lTestInt, 64), frmCalc64Main.BinString,
      'Display[' + inttostr(i) + ']: &' + IntTobin(lTestInt, 64));
    if lTestInt < 0 then
    begin
      PunchInKey(random(2));
      // No Change
      CheckEquals(IntToHex(lTestInt, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2n: $' + IntToHex(lTestInt, 16));
    end
    else
    begin
      PunchInKey(0);
      // a Change
      CheckEquals(IntToHex(lTestInt shl 1, 16), frmCalc64Main.HexString,
        'Display[' + inttostr(i) + '].2p: $' + IntToHex(lTestInt, 16) +
        ' shl 1');
    end
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestOpAdd;

var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;

begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 1234567890;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('1234567890', frmCalc64Main.DecString, 'Display: 1234567890');
  frmCalc64Main.btnPlus.Click;
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');
  frmCalc64Main.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('-987654321', frmCalc64Main.DecString, 'Display: -987654321');
  frmCalc64Main.btnEquals.Click;
  CheckEquals(246913569, frmCalc64Main.Value, 'Display: 246913569');
  CheckEquals(-987654321, frmCalc64Main.Value - 1234567890,
    'Checksum1: -987654321');
  CheckEquals(1234567890, frmCalc64Main.Value + 987654321,
    'Checksum2: 1234567890');
  CheckEquals(0, frmCalc64Main.Value + 987654321 - 1234567890, 'FullInv: 0');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if random > 0.5 then
      lTestInt2 := random(MaxInt64)
    else
      lTestInt2 := -random(MaxInt64);
    if (lTestInt < lTestInt2) and
      (abs(lTestInt div 4 + lTestInt2 div 4) > MaxInt64 div 4) then
      lTestInt2 := lTestInt2 - lTestInt
    else if (lTestInt > lTestInt2) and
      (abs(lTestInt div 4 + lTestInt2 div 4) > MaxInt64 div 4) then
      lTestInt := lTestInt - lTestInt2;
    lResult := lTestInt + lTestInt2;
    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.1]: '
      + inttostr(lTestInt));
    frmCalc64Main.btnPlus.Click;
    CheckEquals(Integer(opAdd), Integer(frmCalc64Main.Operation),
      'Operation is Plus');
    frmCalc64Main.Value := lTestInt2;
    CheckEquals(lTestInt2, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.2]: '
      + inttostr(lTestInt2));
    frmCalc64Main.btnEquals.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation ');
    CheckEquals(lResult, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: ' +
      inttostr(lResult));
    CheckEquals(lTestInt, frmCalc64Main.Value - lTestInt2,
      'Check[' + inttostr(i) + '].1: ' + inttostr(lTestInt));
    CheckEquals(lTestInt2, frmCalc64Main.Value - lTestInt,
      'Check[' + inttostr(i) + ']: ' + inttostr(lTestInt2));
    CheckEquals(0, frmCalc64Main.Value - lTestInt - lTestInt2,
      'Zero[' + inttostr(i) + ']: 0');

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := 'Calc: Error';
  frmCalc64Main.Value := MaxInt64;
  frmCalc64Main.btnPlus.Click;
  frmCalc64Main.Value := 1;
  frmCalc64Main.btnEquals.Click;
  // CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error');
  frmCalc64Main.Value := -MaxInt64 - 1;
  frmCalc64Main.btnPlus.Click;
  frmCalc64Main.Value := -1;
  frmCalc64Main.btnEquals.Click;
  // CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error 2');
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestOpSub;
var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 246913569;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('246913569', frmCalc64Main.DecString, 'Display: 246913569');
  frmCalc64Main.btnMinus.Click;
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');
  frmCalc64Main.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('-987654321', frmCalc64Main.DecString, 'Display: -987654321');
  frmCalc64Main.btnEquals.Click;
  CheckEquals(1234567890, frmCalc64Main.Value, 'Display: 1234567890');
  CheckEquals(-987654321, 246913569 - frmCalc64Main.Value,
    'Checksum1: -987654321');
  CheckEquals(246913569, frmCalc64Main.Value - 987654321,
    'Checksum2: 1234567890');
  CheckEquals(0, 246913569 - frmCalc64Main.Value + 987654321, 'FullInv: 0');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if random > 0.5 then
      lTestInt2 := random(MaxInt64)
    else
      lTestInt2 := -random(MaxInt64);

    if (lTestInt < lTestInt2) and
      (abs(lTestInt div 4 + lTestInt2 div 4) > MaxInt64 div 4) then
      lTestInt2 := lTestInt2 - lTestInt
    else if (lTestInt > lTestInt2) and
      (abs(lTestInt div 4 + lTestInt2 div 4) > MaxInt64 div 4) then
      lTestInt := lTestInt - lTestInt2;
    lResult := lTestInt + lTestInt2;

    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
    frmCalc64Main.Value := lResult;
    CheckEquals(lResult, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.1]: ' +
      inttostr(lResult));
    frmCalc64Main.btnMinus.Click;
    CheckEquals(Integer(opSubtract), Integer(frmCalc64Main.Operation),
      'Operation is Minus');
    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.2]: '
      + inttostr(lTestInt));
    frmCalc64Main.btnEquals.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation ');
    CheckEquals(lTestInt2, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: '
      + inttostr(lTestInt2));
    CheckEquals(lResult, frmCalc64Main.Value + lTestInt,
      'Check[' + inttostr(i) + '].1: ' + inttostr(lResult));
    CheckEquals(lTestInt, lResult - frmCalc64Main.Value,
      'Check[' + inttostr(i) + ']: ' + inttostr(lTestInt));
    CheckEquals(0, lResult - frmCalc64Main.Value - lTestInt,
      'Zero[' + inttostr(i) + ']: 0');

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := 'Calc: Subtr-Error';
  frmCalc64Main.Value := MaxInt64;
  frmCalc64Main.btnMinus.Click;
  frmCalc64Main.Value := -1;
  frmCalc64Main.btnEquals.Click;
  // CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error');
  frmCalc64Main.Value := -MaxInt64 - 1;
  frmCalc64Main.btnMinus.Click;
  frmCalc64Main.Value := 1;
  frmCalc64Main.btnEquals.Click;
  // CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error 2');
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestOpMult;

var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 12345;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(12345, frmCalc64Main.Value, 'Display: 12345');
  frmCalc64Main.btnMultiply.Click;
  CheckEquals(Integer(opMultiply), Integer(frmCalc64Main.Operation),
    'Operation is Mult');
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');
  frmCalc64Main.Value := -98765;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(-98765, frmCalc64Main.Value, 'Value: -98765');
  frmCalc64Main.btnEquals.Click;
  CheckEquals(-1219253925, frmCalc64Main.Value, 'Display: -1219253925');
  CheckEquals(12345, frmCalc64Main.Value div -98765, 'Checksum1: 12345');
  CheckEquals(-98765, frmCalc64Main.Value div 12345, 'Checksum1: -98765');
  CheckEquals(1, frmCalc64Main.Value div -98765 div 12345, 'Inv1: 1');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt) + 1
    else
      lTestInt := -random(MaxInt) - 1;
    if random > 0.5 then
      lTestInt2 := random(MaxInt) + 1
    else
      lTestInt2 := -random(MaxInt) - 1;

    lResult := lTestInt * lTestInt2;

    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');

    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.1]: '
      + inttostr(lResult));
    frmCalc64Main.btnMultiply.Click;
    CheckEquals(Integer(opMultiply), Integer(frmCalc64Main.Operation),
      'Operation is Multiply');
    frmCalc64Main.Value := lTestInt2;
    CheckEquals(lTestInt2, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.2]: '
      + inttostr(lTestInt2));
    frmCalc64Main.btnEquals.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation ');
    CheckEquals(lResult, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: ' +
      inttostr(lResult));
    CheckEquals(lTestInt2, frmCalc64Main.Value div lTestInt,
      'Check[' + inttostr(i) + '].1: ' + inttostr(lTestInt2));
    CheckEquals(lTestInt, frmCalc64Main.Value div lTestInt2,
      'Check[' + inttostr(i) + '].2: ' + inttostr(lTestInt));
    CheckEquals(1, frmCalc64Main.Value div lTestInt2 div lTestInt,
      'One[' + inttostr(i) + ']: 1');

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := lOrgCaption;

end;

procedure TTestCalc64.TestOpDiv;
var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := -1219253925;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(-1219253925, frmCalc64Main.Value, 'Value: -1219253925');
  frmCalc64Main.btnDivide.Click;
  CheckEquals(Integer(opDivide), Integer(frmCalc64Main.Operation),
    'Operation is Divide');
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');
  frmCalc64Main.Value := 12345;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(12345, frmCalc64Main.Value, 'Display: 12345');

  frmCalc64Main.btnEquals.Click;
  CheckEquals(-98765, frmCalc64Main.Value, 'Result: -98765');
  CheckEquals(12345, -1219253925 div frmCalc64Main.Value, 'Checksum1: 12345');
  CheckEquals(-1219253925, frmCalc64Main.Value * 12345,
    'Checksum1: -1219253925');
  CheckEquals(1, -1219253925 div frmCalc64Main.Value div 12345, 'Inv1: 1');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lResult := random(MaxInt) + 1
    else
      lResult := -random(MaxInt) - 1;
    if random > 0.5 then
      lTestInt2 := random(MaxInt) + 1
    else
      lTestInt2 := -random(MaxInt) - 1;

    lTestInt := lResult * lTestInt2;

    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');

    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.1]: '
      + inttostr(lTestInt));
    frmCalc64Main.btnDivide.Click;
    CheckEquals(Integer(opDivide), Integer(frmCalc64Main.Operation),
      'Operation is Divide');
    frmCalc64Main.Value := lTestInt2;
    CheckEquals(lTestInt2, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.2]: '
      + inttostr(lTestInt2));
    frmCalc64Main.btnEquals.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation ');
    CheckEquals(lResult, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: ' +
      inttostr(lResult));
    CheckEquals(lTestInt2, lTestInt div frmCalc64Main.Value,
      'Check[' + inttostr(i) + '].1: ' + inttostr(lTestInt2));
    CheckEquals(lTestInt, frmCalc64Main.Value * lTestInt2,
      'Check[' + inttostr(i) + '].2: ' + inttostr(lTestInt));
    CheckEquals(1, lTestInt div lTestInt2 div frmCalc64Main.Value,
      'One[' + inttostr(i) + ']: 1');

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestOpNot;
var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 246913569;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(246913569, frmCalc64Main.Value, 'Value: 246913569');
  frmCalc64Main.btnNot.Click;
  CheckEquals(-246913570, frmCalc64Main.Value, 'Result: -246913570');

  frmCalc64Main.btnClearEntry.Click;
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');

  frmCalc64Main.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(-987654321, frmCalc64Main.Value, 'Value: -987654321');
  frmCalc64Main.btnNot.Click;
  CheckEquals(987654320, frmCalc64Main.Value, 'Result: 987654320');

  frmCalc64Main.Value := 1234567890;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(1234567890, frmCalc64Main.Value, 'Value: 1234567890');
  frmCalc64Main.btnNot.Click;
  CheckEquals(-1234567891, frmCalc64Main.Value, 'Value: -1234567891');

  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);

    lResult := not lTestInt;

    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + ']: ' +
      inttostr(lTestInt));
    frmCalc64Main.btnNot.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation');
    CheckEquals(lResult, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: ' +
      inttostr(lResult));
    frmCalc64Main.btnNot.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation');
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Check[' + inttostr(i) + ']: ' +
      inttostr(lTestInt));

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestOpAnd;

var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 1234567890;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(1234567890, frmCalc64Main.Value, 'Display: 246913569');
  frmCalc64Main.btnAnd.Click;
  CheckEquals(Integer(opAnd), Integer(frmCalc64Main.Operation),
    'Operation is And');
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');
  frmCalc64Main.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(-987654321, frmCalc64Main.Value, 'Value: -987654321');
  frmCalc64Main.btnEquals.Click;
  CheckEquals(1090519618, frmCalc64Main.Value, 'Display: 1090519618');
  CheckEquals(1090519618, 1234567890 and frmCalc64Main.Value,
    'Checksum1: 1090519618');
  CheckEquals(1090519618, -987654321 and frmCalc64Main.Value,
    'Checksum1: 1090519618');
  CheckEquals(0, not 1234567890 and frmCalc64Main.Value, 'Inv1: 0');
  CheckEquals(0, not-987654321 and frmCalc64Main.Value, 'Inv2: 0');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if random > 0.5 then
      lTestInt2 := random(MaxInt64)
    else
      lTestInt2 := -random(MaxInt64);

    lResult := lTestInt and lTestInt2;

    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');

    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.1]: '
      + inttostr(lResult));
    frmCalc64Main.btnAnd.Click;
    CheckEquals(Integer(opAnd), Integer(frmCalc64Main.Operation),
      'Operation is And');
    frmCalc64Main.Value := lTestInt2;
    CheckEquals(lTestInt2, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.2]: '
      + inttostr(lTestInt2));
    frmCalc64Main.btnEquals.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation ');
    CheckEquals(lResult, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: ' +
      inttostr(lTestInt2));
    CheckEquals(lResult, frmCalc64Main.Value and lTestInt,
      'Check[' + inttostr(i) + '].1: ' + inttostr(lResult));
    CheckEquals(lResult, frmCalc64Main.Value and lTestInt2,
      'Check[' + inttostr(i) + '].2: ' + inttostr(lResult));
    CheckEquals(0, frmCalc64Main.Value and not lTestInt,
      'Zero[' + inttostr(i) + ']: 0');
    CheckEquals(0, frmCalc64Main.Value and not lTestInt2,
      'Zero[' + inttostr(i) + ']: 0');

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := lOrgCaption;

end;

procedure TTestCalc64.TestOpOr;
var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 1234567890;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(1234567890, frmCalc64Main.Value, 'Display: 246913569');
  frmCalc64Main.btnOr.Click;
  CheckEquals(Integer(opOr), Integer(frmCalc64Main.Operation),
    'Operation is Or');
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');
  frmCalc64Main.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(-987654321, frmCalc64Main.Value, 'Value: -987654321');
  frmCalc64Main.btnEquals.Click;
  CheckEquals(-843606049, frmCalc64Main.Value, 'Display: -843606049');
  CheckEquals(-843606049, 1234567890 Or frmCalc64Main.Value,
    'Checksum1: -843606049');
  CheckEquals(-843606049, -987654321 Or frmCalc64Main.Value,
    'Checksum1: -843606049');
  CheckEquals(-1, not 1234567890 Or frmCalc64Main.Value, 'Inv1: -1');
  CheckEquals(-1, not-987654321 Or frmCalc64Main.Value, 'Inv2: -1');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if random > 0.5 then
      lTestInt2 := random(MaxInt64)
    else
      lTestInt2 := -random(MaxInt64);

    lResult := lTestInt Or lTestInt2;

    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');

    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.1]: '
      + inttostr(lResult));
    frmCalc64Main.btnOr.Click;
    CheckEquals(Integer(opOr), Integer(frmCalc64Main.Operation),
      'Operation is Or');
    frmCalc64Main.Value := lTestInt2;
    CheckEquals(lTestInt2, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.2]: '
      + inttostr(lTestInt2));
    frmCalc64Main.btnEquals.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation ');
    CheckEquals(lResult, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: ' +
      inttostr(lTestInt2));
    CheckEquals(lResult, frmCalc64Main.Value Or lTestInt,
      'Check[' + inttostr(i) + '].1: ' + inttostr(lResult));
    CheckEquals(lResult, frmCalc64Main.Value Or lTestInt2,
      'Check[' + inttostr(i) + '].2: ' + inttostr(lResult));
    CheckEquals(-1, frmCalc64Main.Value Or not lTestInt,
      'Full[' + inttostr(i) + ']: -1');
    CheckEquals(-1, frmCalc64Main.Value Or not lTestInt2,
      'Full[' + inttostr(i) + ']: -1');

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestOpXor;
var
  i: Integer;
  lTestInt, lTestInt2, lResult: Int64;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  Application.ProcessMessages;
  sleep(100);
  checktrue(frmCalc64Main.Visible, 'MainForm is visible now');
  frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
  CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');
  frmCalc64Main.Value := 1234567890;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(1234567890, frmCalc64Main.Value, 'Display: 246913569');
  frmCalc64Main.btnXor.Click;
  CheckEquals(Integer(opXor), Integer(frmCalc64Main.Operation),
    'Operation is Xor');
  CheckEquals(0, frmCalc64Main.Value, 'Display: 0');
  frmCalc64Main.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals(-987654321, frmCalc64Main.Value, 'Value: -987654321');
  frmCalc64Main.btnEquals.Click;
  CheckEquals(-1934125667, frmCalc64Main.Value, 'Display: -1934125667');
  CheckEquals(-987654321, 1234567890 Xor frmCalc64Main.Value,
    'Checksum1: -987654321');
  CheckEquals(1234567890, -987654321 Xor frmCalc64Main.Value,
    'Checksum1: 1234567890');
  CheckEquals(0, -987654321 Xor 1234567890 Xor frmCalc64Main.Value, 'Zero: 0');
  lOrgCaption := frmCalc64Main.Caption;
  for i := 0 to 10000 do
  begin
    if i mod 100 = 0 then
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - i div 333) +
        DupeString(' ', i div 333) + ']';
    if random > 0.5 then
      lTestInt := random(MaxInt64)
    else
      lTestInt := -random(MaxInt64);
    if random > 0.5 then
      lTestInt2 := random(MaxInt64)
    else
      lTestInt2 := -random(MaxInt64);

    lResult := lTestInt Xor lTestInt2;

    frmCalc64Main.btnClearEntryClick(frmCalc64Main.btnClearEntry);
    CheckEquals('0', frmCalc64Main.DecString, 'Display: 0');

    frmCalc64Main.Value := lTestInt;
    CheckEquals(lTestInt, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.1]: '
      + inttostr(lResult));
    frmCalc64Main.btnXor.Click;
    CheckEquals(Integer(opXor), Integer(frmCalc64Main.Operation),
      'Operation is Xor');
    frmCalc64Main.Value := lTestInt2;
    CheckEquals(lTestInt2, frmCalc64Main.Value, 'Value[' + inttostr(i) + '.2]: '
      + inttostr(lTestInt2));
    frmCalc64Main.btnEquals.Click;
    CheckEquals(Integer(opNo), Integer(frmCalc64Main.Operation),
      'No Operation ');
    CheckEquals(lResult, frmCalc64Main.Value, 'Result[' + inttostr(i) + ']: ' +
      inttostr(lTestInt2));
    CheckEquals(lTestInt2, frmCalc64Main.Value Xor lTestInt,
      'Check[' + inttostr(i) + '].1: ' + inttostr(lTestInt2));
    CheckEquals(lTestInt, frmCalc64Main.Value Xor lTestInt2,
      'Check[' + inttostr(i) + '].2: ' + inttostr(lTestInt));
    CheckEquals(0, frmCalc64Main.Value Xor lTestInt Xor lTestInt2,
      'Zero[' + inttostr(i) + ']: 0');

    if i mod 25 = 0 then
      Application.ProcessMessages;
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

procedure TTestCalc64.TestForm;
var
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalc64Main.Visible, 'MainForm is not visible at the moment');
  frmCalc64Main.Show;
  lOrgCaption := frmCalc64Main.Caption;
{$IFDEF FPC}
    Application.OnUserInput := AppUserInput;
{$ENDIF}
  while frmCalc64Main.Visible do
  begin
        {$IFDEF FPC}
      Application.Idle(false);
    {$ENDIF}
    Application.ProcessMessages;
    inc(FIdleCnt);
    sleep(10);
    if FIdleCnt > 300 then
      frmCalc64Main.hide
    else
      frmCalc64Main.Caption := 'Calc [' + DupeString('|', 30 - FIdleCnt div 10)
        + DupeString(' ', FIdleCnt div 10) + ']';
  end;
  frmCalc64Main.Caption := lOrgCaption;
end;

initialization

RegisterTest(TTestCalc64{$IFNDEF FPC}.Suite{$ENDIF});

end.
