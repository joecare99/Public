unit tst_Calc32;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$EndIF}

interface

uses
  Classes, SysUtils, Controls, {$IFNDEF FPC}TestFramework {$ELSE} fpcunit,
  testutils, testregistry {$ENDIF};

type

  { TTestCalc32 }

  TTestCalc32= class(TTestCase)
  private
    FIdleCnt: Integer;
    FSleeptime:integer;
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
    procedure EqualswithError;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    Procedure PunchIn(aValue:INteger);overload;
    procedure PunchInKey(aValue: INteger);
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

uses Forms,Frm_CALC,Frm_CalcABOUT,StrUtils;

procedure TTestCalc32.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
  FIdleCnt:=0;
end;

procedure TTestCalc32.EqualswithError;
begin
      frmCalcMain.btnEquals.Click;
end;

procedure TTestCalc32.SetUp;
begin
  if not assigned(frmCalcMain) then
  Application.CreateForm(TfrmCalcMain,frmCalcMain);
  if not assigned(frmCalcAbout) then
  Application.CreateForm(TfrmCalcAbout,frmCalcAbout);
  frmCalcMain.DecHexBinButtonClick(frmCalcMain.decButton);
  FSleepTime:=40;
end;

procedure TTestCalc32.TearDown;
begin
  frmCalcMain.btnClearClick(nil);
  frmCalcMain.hide;
  frmCalcAbout.hide;
end;

procedure TTestCalc32.PunchIn(aValue: INteger);
  Procedure Punch(aChar:Char);

  begin
    case aChar of
      '-':frmCalcMain.btnNegateClick(frmCalcMain.btnNegate);
      '0'..'9','A'..'F':frmCalcMain.ButtonDigitClick(frmCalcMain.FindComponent('btn'+aChar))
    else
    end;
    Application.ProcessMessages;
    Application.Idle(false);
    sleep(FSleepTime);
  end;

var
  lNumbers: String;
  i: Integer;
begin
  checktrue(frmCalcMain.Visible,'MainForm is not visible');
  // Check Mode
  if frmCalcMain.DecButton.down then
    begin
      lNumbers:=inttostr(aValue);
      for i := 1 to length(lNumbers) do
        Punch(lNumbers[i]);
    end
  else  if frmCalcMain.HexButton.down then
    begin
      lNumbers:=IntToHex(aValue,8);
      while (length(lNumbers)>1) and (lNumbers[1]='0') do
        delete(lNumbers,1,1);
      for i := 1 to length(lNumbers) do
        Punch(lNumbers[i]);
    end
  else  if frmCalcMain.BinButton.down then
    begin
      lNumbers:=IntTobin(aValue,32);
      while (length(lNumbers)>1) and (lNumbers[1]='0') do
        delete(lNumbers,1,1);
      for i := 1 to length(lNumbers) do
        Punch(lNumbers[i]);
    end;
end;

procedure TTestCalc32.PunchInKey(aValue: INteger);

  Procedure Punch(aChar:Char);

  begin
    case aChar of
      '-',
      '0'..'9','A'..'F':frmCalcMain.FormKeyPress(frmCalcMain,aChar);
    else
    end;
    Application.ProcessMessages;
    Application.Idle(false);
    sleep(FSleepTime);
  end;

var
  lNumbers: String;
  i: Integer;
begin
  checktrue(frmCalcMain.Visible,'MainForm is not visible');
  // Check Mode
  if frmCalcMain.DecButton.down then
    begin
      lNumbers:=inttostr(aValue);
      for i := 1 to length(lNumbers) do
        Punch(lNumbers[i]);
    end
  else  if frmCalcMain.HexButton.down then
    begin
      lNumbers:=IntToHex(aValue,8);
      while (length(lNumbers)>1) and (lNumbers[1]='0') do
        delete(lNumbers,1,1);
      for i := 1 to length(lNumbers) do
        Punch(lNumbers[i]);
    end
  else  if frmCalcMain.BinButton.down then
    begin
      lNumbers:=IntTobin(aValue,32);
      while (length(lNumbers)>1) and (lNumbers[1]='0') do
        delete(lNumbers,1,1);
      for i := 1 to length(lNumbers) do
        Punch(lNumbers[i]);
    end;
end;

procedure TTestCalc32.TestSetUp;
begin
  CheckNotNull(frmCalcMain,'Calc32 Mainform is initialized');
  CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
  CheckNotNull(frmCalcAbout,'Calc About-form is initialized');
  CheckFalse(frmCalcAbout.Visible,'About is not visible at the moment');
end;

procedure TTestCalc32.TestMainForm;
begin
  CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
  frmCalcMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmCalcMain.Visible,'MainForm is visible now');
end;

procedure TTestCalc32.TestAboutForm;
begin
  CheckFalse(frmCalcAbout.Visible,'MainForm is not visible at the moment');
  frmCalcAbout.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcAbout.Visible,'MainForm is visible now');
  frmCalcAbout.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcAbout.Visible,'MainForm is visible now');
  frmCalcAbout.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcAbout.Visible,'MainForm is visible now');
  frmCalcAbout.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmCalcAbout.Visible,'MainForm is visible now');
end;

procedure TTestCalc32.TestValue;
var
  i: Integer;
  lTestInt: integer;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
  frmCalcMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0',frmCalcMain.DecString,'Display: 0');
  frmCalcMain.Value := 1234567890;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('1234567890',frmCalcMain.DecString,'Display: 1234567890');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0',frmCalcMain.DecString,'Display: 0');
  frmCalcMain.Value := -987654321;
  Application.ProcessMessages;
  sleep(100);
  CheckEquals('-987654321',frmCalcMain.DecString,'Display: -987654321');
  lOrgCaption:= frmCalcMain.Caption;
  for i := 0 to 50000 do
    begin
          if i mod 500 =0 then
      frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i*2 div 3333)+DupeString(' ',i*2 div 3333)+']';
      if random>0.5 then
        lTestInt:= random(MaxInt)
      else
        lTestInt:= -random(MaxInt);
      frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
      CheckEquals('0',frmCalcMain.DecString,'Display: 0');
      frmCalcMain.Value := lTestInt;
      CheckEquals(inttostr(lTestInt) ,frmCalcMain.DecString,
        'Display['+inttostr(i)+'].d: '+inttostr(lTestInt));
      CheckEquals(inttohex(lTestInt,8) ,frmCalcMain.HexString,
        'Display['+inttostr(i)+'].h: $'+inttohex(lTestInt,8));
      CheckEquals(inttobin(lTestInt,32) ,frmCalcMain.BinString,
         'Display['+inttostr(i)+'].b: &'+inttobin(lTestInt,32));
      if i mod 100 =0 then
        Application.ProcessMessages;
    end;
  frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestEntry;
var
  i: Integer;
  lTestInt: integer;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
  frmCalcMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0',frmCalcMain.DecString,'Display: 0');
  PunchIn(1234567890);
  CheckEquals('1234567890',frmCalcMain.DecString,'Display: 1234567890');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0',frmCalcMain.DecString,'Display: 0');
  PunchIn(-987654321);
  CheckEquals('-987654321',frmCalcMain.DecString,'Display: -987654321');
  lOrgCaption:= frmCalcMain.Caption;
  FSleeptime:=5;
  for i := 0 to 1000 do
    begin
      frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 33)+DupeString(' ',i div 33)+']';
      if random>0.5 then
        lTestInt:= random(MaxInt)
      else
        lTestInt:= -random(MaxInt);
      if i= 30 then FSleeptime:=0;
      frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
      CheckEquals('0',frmCalcMain.DecString,'Display: 0');
      PunchIn(lTestInt);
      CheckEquals(inttostr(lTestInt) ,frmCalcMain.DecString,
        'Display['+inttostr(i)+']: '+inttostr(lTestInt));
      if abs(lTestInt) > maxint div 10 then
        begin
          PunchIn(random(10));
          // No Change
          CheckEquals(inttostr(lTestInt) ,frmCalcMain.DecString,
            'Display['+inttostr(i)+'].2n: '+inttostr(lTestInt));
        end
      else
      begin
        PunchIn(0);
        // a Change
        CheckEquals(inttostr(lTestInt*10) ,frmCalcMain.DecString,
          'Display['+inttostr(i)+'].2p: '+inttostr(lTestInt*10));
      end
    end;
  frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestEntryHex;

var
    i: Integer;
    lTestInt: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.DecHexBinButtonClick(frmCalcMain.hexButton);
    Application.ProcessMessages;
    CheckTrue(frmCalcMain.HexButton.Down,'Hex-Mode is selected');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 00000000');
    PunchIn($12345678);
    CheckEquals(inttohex($12345678,8) ,frmCalcMain.HexString,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 00000000');
    PunchIn(longint($FEDCBA98));
    CheckEquals(inttohex($FEDCBA98,8) ,frmCalcMain.HexString,'Display: -987654321');
    lOrgCaption:= frmCalcMain.Caption;
    FSleeptime:=5;
    for i := 0 to 1000 do
      begin
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 33)+DupeString(' ',i div 33)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if i= 30 then FSleeptime:=0;
        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('00000000',frmCalcMain.HexString,'Display: 00000000');
        PunchIn(lTestInt);
        CheckEquals(inttohex(lTestInt,8) ,frmCalcMain.HexString,
          'Display['+inttostr(i)+']: $'+inttohex(lTestInt,8));
        if (lTestInt > $FFFFFFF) or (lTestInt<0)  then
          begin
            PunchIn(random(16));
            // No Change
            CheckEquals(inttohex(lTestInt,8) ,frmCalcMain.HexString,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchIn(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 4,8) ,frmCalcMain.HexString,
            'Display['+inttostr(i)+'].2p: $'+inttohex(lTestInt shl 4,8));
        end
      end;
    frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestEntrybin;
var
    i: Integer;
    lTestInt: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.DecHexBinButtonClick(frmCalcMain.binButton);
    Application.ProcessMessages;
    CheckTrue(frmCalcMain.binButton.Down,'bin-Mode is selected');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 0');
    PunchIn($12345678);
    CheckEquals(inttobin($12345678,32) ,frmCalcMain.BinString,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 0');
    PunchIn(integer($FEDCBA98));
    CheckEquals(inttobin($FEDCBA98,32) ,frmCalcMain.BinString,'Display: $FEDCBA98');
    lOrgCaption:= frmCalcMain.Caption;
    FSleeptime:=5;
    for i := 0 to 1000 do
      begin
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 33)+DupeString(' ',i div 33)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if i= 30 then FSleeptime:=0;
        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('00000000',frmCalcMain.HexString,'Display: 0');
        PunchIn(lTestInt);
        CheckEquals(inttobin(lTestInt,32) ,frmCalcMain.BinString,
          'Display['+inttostr(i)+']: &'+inttobin(lTestInt,32));
        if lTestInt < 0  then
          begin
            PunchIn(random(2));
            // No Change
            CheckEquals(inttohex(lTestInt,8) ,frmCalcMain.HexString,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchIn(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 1,8) ,frmCalcMain.HexString,
            'Display['+inttostr(i)+'].2p: $'+inttohex(lTestInt ,8)+' shl 1');
        end
      end;
    frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestEntryKey;
var
  i: Integer;
  lTestInt: integer;
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
  frmCalcMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0',frmCalcMain.DecString,'Display: 0');
  PunchInKey(1234567890);
  CheckEquals('1234567890',frmCalcMain.DecString,'Display: 1234567890');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0',frmCalcMain.DecString,'Display: 0');
  PunchInKey(-987654321);
  CheckEquals('-987654321',frmCalcMain.DecString,'Display: -987654321');
  lOrgCaption:= frmCalcMain.Caption;
  FSleeptime:=5;
  for i := 0 to 1000 do
    begin
      frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 33)+DupeString(' ',i div 33)+']';
      if random>0.5 then
        lTestInt:= random(MaxInt)
      else
        lTestInt:= -random(MaxInt);
      if i= 30 then FSleeptime:=0;
      frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
      CheckEquals('0',frmCalcMain.DecString,'Display: 0');
      PunchInKey(lTestInt);
      CheckEquals(inttostr(lTestInt) ,frmCalcMain.DecString,
        'Display['+inttostr(i)+']: '+inttostr(lTestInt));
      if abs(lTestInt) > maxint div 10 then
        begin
          PunchInKey(random(10));
          // No Change
          CheckEquals(inttostr(lTestInt) ,frmCalcMain.DecString,
            'Display['+inttostr(i)+'].2n: '+inttostr(lTestInt));
        end
      else
      begin
        PunchInKey(0);
        // a Change
        CheckEquals(inttostr(lTestInt*10) ,frmCalcMain.DecString,
          'Display['+inttostr(i)+'].2p: '+inttostr(lTestInt*10));
      end
    end;
  frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestEntryKHex;
var
    i: Integer;
    lTestInt: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.DecHexBinButtonClick(frmCalcMain.hexButton);
    Application.ProcessMessages;
    CheckTrue(frmCalcMain.HexButton.Down,'Hex-Mode is selected');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 00000000');
    PunchInKey($12345678);
    CheckEquals(inttohex($12345678,8) ,frmCalcMain.HexString,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 00000000');
    PunchInKey(longint($FEDCBA98));
    CheckEquals(inttohex($FEDCBA98,8) ,frmCalcMain.HexString,'Display: -987654321');
    lOrgCaption:= frmCalcMain.Caption;
    FSleeptime:=5;
    for i := 0 to 1000 do
      begin
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 33)+DupeString(' ',i div 33)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if i= 30 then FSleeptime:=0;
        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('00000000',frmCalcMain.HexString,'Display: 00000000');
        PunchInKey(lTestInt);
        CheckEquals(inttohex(lTestInt,8) ,frmCalcMain.HexString,
          'Display['+inttostr(i)+']: $'+inttohex(lTestInt,8));
        if (lTestInt > $FFFFFFF) or (lTestInt<0)  then
          begin
            PunchInKey(random(16));
            // No Change
            CheckEquals(inttohex(lTestInt,8) ,frmCalcMain.HexString,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchInKey(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 4,8) ,frmCalcMain.HexString,
            'Display['+inttostr(i)+'].2p: $'+inttohex(lTestInt shl 4,8));
        end
      end;
    frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestEntryKbin;
var
    i: Integer;
    lTestInt: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.DecHexBinButtonClick(frmCalcMain.binButton);
    Application.ProcessMessages;
    CheckTrue(frmCalcMain.binButton.Down,'bin-Mode is selected');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 0');
    PunchInKey($12345678);
    CheckEquals(inttobin($12345678,32) ,frmCalcMain.BinString,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000',frmCalcMain.HexString,'Display: 0');
    PunchInKey(integer($FEDCBA98));
    CheckEquals(inttobin($FEDCBA98,32) ,frmCalcMain.BinString,'Display: $FEDCBA98');
    lOrgCaption:= frmCalcMain.Caption;
    FSleeptime:=5;
    for i := 0 to 1000 do
      begin
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 33)+DupeString(' ',i div 33)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if i= 30 then FSleeptime:=0;
        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('00000000',frmCalcMain.HexString,'Display: 0');
        PunchInKey(lTestInt);
        CheckEquals(inttobin(lTestInt,32) ,frmCalcMain.BinString,
          'Display['+inttostr(i)+']: &'+inttobin(lTestInt,32));
        if lTestInt < 0  then
          begin
            PunchInKey(random(2));
            // No Change
            CheckEquals(inttohex(lTestInt,8) ,frmCalcMain.HexString,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchInKey(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 1,8) ,frmCalcMain.HexString,
            'Display['+inttostr(i)+'].2p: $'+inttohex(lTestInt ,8)+' shl 1');
        end
      end;
    frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestOpAdd;

  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;

  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := 1234567890;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals('1234567890',frmCalcMain.DecString,'Display: 1234567890');
    frmCalcMain.btnPlus.Click;
    CheckEquals(0,frmCalcMain.value,'Display: 0');
    frmCalcMain.Value := -987654321;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals('-987654321',frmCalcMain.DecString,'Display: -987654321');
    frmCalcMain.btnEquals.Click;
    CheckEquals(246913569,frmCalcMain.value,'Display: 246913569');
    CheckEquals(-987654321,frmCalcMain.value-1234567890,'Checksum1: -987654321');
    CheckEquals(1234567890,frmCalcMain.value+987654321,'Checksum2: 1234567890');
    CheckEquals(0,frmCalcMain.value+987654321-1234567890,'FullInv: 0');
    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if random>0.5 then
          lTestInt2:= random(MaxInt)
        else
          lTestInt2:= -random(MaxInt);
        if (lTestInt<ltestInt2) and  (abs(lTestInt div 4 + ltestint2 div 4) > maxint div 4) then
          lTestInt2:=lTestInt2-lTestInt
        else if (lTestInt>ltestInt2) and  (abs(lTestInt div 4 + ltestint2 div 4) > maxint div 4) then
          lTestInt:=lTestInt-lTestInt2;
        lResult:=lTestInt+lTestInt2;
        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('0',frmCalcMain.DecString,'Display: 0');
        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,
           'Value['+inttostr(i)+'.1]: '+inttostr(lTestInt));
        frmCalcMain.btnPlus.Click;
        CheckEquals(integer(opAdd) ,integer(frmCalcMain.Operation),'Operation is Plus');
        frmCalcMain.Value := lTestInt2;
        CheckEquals(lTestInt2 ,frmCalcMain.Value,
           'Value['+inttostr(i)+'.2]: '+inttostr(lTestInt2));
        frmCalcMain.btnEquals.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation ');
        CheckEquals(lResult ,frmCalcMain.Value,
           'Result['+inttostr(i)+']: '+inttostr(lResult));
        CheckEquals(lTestInt ,frmCalcMain.Value-lTestInt2,
           'Check['+inttostr(i)+'].1: '+inttostr(lTestInt));
        CheckEquals(lTestInt2 ,frmCalcMain.Value-lTestInt,
           'Check['+inttostr(i)+']: '+inttostr(lTestInt2));
        CheckEquals(0 ,frmCalcMain.Value-lTestInt-lTestInt2,
           'Zero['+inttostr(i)+']: 0');

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:='Calc: Error';
    frmCalcMain.Value := maxint;
    frmCalcMain.btnPlus.Click;
    frmCalcMain.Value := 1;
    frmCalcMain.btnEquals.Click;
//    CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error');
    frmCalcMain.Value := -maxint-1;
    frmCalcMain.btnPlus.Click;
    frmCalcMain.Value := -1;
    frmCalcMain.btnEquals.Click;
//    CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error 2');
    frmCalcMain.Caption:=lOrgCaption;
  end;


procedure TTestCalc32.TestOpSub;
  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := 246913569;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals('246913569',frmCalcMain.DecString,'Display: 246913569');
    frmCalcMain.btnMinus.Click;
    CheckEquals(0,frmCalcMain.value,'Display: 0');
    frmCalcMain.Value := -987654321;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals('-987654321',frmCalcMain.DecString,'Display: -987654321');
    frmCalcMain.btnEquals.Click;
    CheckEquals(1234567890,frmCalcMain.value,'Display: 1234567890');
    CheckEquals(-987654321,246913569-frmCalcMain.value,'Checksum1: -987654321');
    CheckEquals(246913569,frmCalcMain.value-987654321,'Checksum2: 1234567890');
    CheckEquals(0,246913569-frmCalcMain.value+987654321,'FullInv: 0');
    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if random>0.5 then
          lTestInt2:= random(MaxInt)
        else
          lTestInt2:= -random(MaxInt);

        if (lTestInt<ltestInt2) and  (abs(lTestInt div 4 + ltestint2 div 4) > maxint div 4) then
          lTestInt2:=lTestInt2-lTestInt
        else if (lTestInt>ltestInt2) and  (abs(lTestInt div 4 + ltestint2 div 4) > maxint div 4) then
          lTestInt:=lTestInt-lTestInt2;
        lResult:=lTestInt+lTestInt2;

        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('0',frmCalcMain.DecString,'Display: 0');
        frmCalcMain.Value := lResult;
        CheckEquals(lResult ,frmCalcMain.Value,
           'Value['+inttostr(i)+'.1]: '+inttostr(lResult));
        frmCalcMain.btnMinus.Click;
        CheckEquals(integer(opSubtract) ,integer(frmCalcMain.Operation),'Operation is Minus');
        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,
           'Value['+inttostr(i)+'.2]: '+inttostr(lTestInt));
        frmCalcMain.btnEquals.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation ');
        CheckEquals(lTestInt2 ,frmCalcMain.Value,
           'Result['+inttostr(i)+']: '+inttostr(lTestInt2));
        CheckEquals(lResult ,frmCalcMain.Value+lTestInt,
           'Check['+inttostr(i)+'].1: '+inttostr(lResult));
        CheckEquals(lTestInt ,lResult-frmCalcMain.Value,
           'Check['+inttostr(i)+']: '+inttostr(lTestInt));
        CheckEquals(0 ,lResult-frmCalcMain.Value-lTestInt,
           'Zero['+inttostr(i)+']: 0');

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:='Calc: Subtr-Error';
    frmCalcMain.Value := maxint;
    frmCalcMain.btnMinus.Click;
    frmCalcMain.Value := -1;
    frmCalcMain.btnEquals.Click;
//    CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error');
    frmCalcMain.Value := -maxint-1;
    frmCalcMain.btnMinus.Click;
    frmCalcMain.Value := 1;
    frmCalcMain.btnEquals.Click;
//    CheckException(@EqualswithError,ERangeError,'Expect a Rangecheck-Error 2');
    frmCalcMain.Caption:=lOrgCaption;
  end;

procedure TTestCalc32.TestOpMult;

  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := 12345;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(12345,frmCalcMain.Value,'Display: 12345');
    frmCalcMain.btnMultiply.Click;
    CheckEquals(integer(opMultiply) ,integer(frmCalcMain.Operation),'Operation is Mult');
    CheckEquals(0,frmCalcMain.value,'Display: 0');
    frmCalcMain.Value := -98765;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(-98765,frmCalcMain.Value,'Value: -98765');
    frmCalcMain.btnEquals.Click;
    CheckEquals(-1219253925,frmCalcMain.value,'Display: -1219253925');
    CheckEquals(12345,frmCalcMain.value div -98765,'Checksum1: 12345');
    CheckEquals(-98765,frmCalcMain.value div 12345,'Checksum1: -98765');
    CheckEquals(1,frmCalcMain.value div -98765 div 12345,'Inv1: 1');
    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lTestInt:= random(maxSmallint)+1
        else
          lTestInt:= -random(maxSmallint)-1;
        if random>0.5 then
          lTestInt2:= random(maxSmallint)+1
        else
          lTestInt2:= -random(maxSmallint)-1;

        lResult:=lTestInt * lTestInt2;

        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('0',frmCalcMain.DecString,'Display: 0');

        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,'Value['+inttostr(i)+'.1]: '+inttostr(lResult));
        frmCalcMain.btnMultiply.Click;
        CheckEquals(integer(opMultiply) ,integer(frmCalcMain.Operation),'Operation is Multiply');
        frmCalcMain.Value := lTestInt2;
        CheckEquals(lTestInt2 ,frmCalcMain.Value,'Value['+inttostr(i)+'.2]: '+inttostr(lTestInt2));
        frmCalcMain.btnEquals.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation ');
        CheckEquals(lResult ,frmCalcMain.Value,'Result['+inttostr(i)+']: '+inttostr(lResult));
        CheckEquals(lTestInt2 ,frmCalcMain.Value div lTestInt,'Check['+inttostr(i)+'].1: '+inttostr(lTestInt2));
        CheckEquals(lTestInt ,frmCalcMain.Value div lTestInt2,'Check['+inttostr(i)+'].2: '+inttostr(lTestInt));
        CheckEquals(1 ,frmCalcMain.Value div lTestInt2 div lTestInt,'One['+inttostr(i)+']: 1');

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:=lOrgCaption;

end;

procedure TTestCalc32.TestOpDiv;
  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := -1219253925;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(-1219253925,frmCalcMain.Value,'Value: -1219253925');
    frmCalcMain.btnDivide.Click;
    CheckEquals(integer(opDivide) ,integer(frmCalcMain.Operation),'Operation is Divide');
    CheckEquals(0,frmCalcMain.value,'Display: 0');
    frmCalcMain.Value := 12345;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(12345,frmCalcMain.Value,'Display: 12345');

    frmCalcMain.btnEquals.Click;
    CheckEquals(-98765,frmCalcMain.value,'Result: -98765');
    CheckEquals(12345,-1219253925 div frmCalcMain.value,'Checksum1: 12345');
    CheckEquals(-1219253925,frmCalcMain.value * 12345,'Checksum1: -1219253925');
    CheckEquals(1,-1219253925 div frmCalcMain.value div 12345,'Inv1: 1');
    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lResult:= random(maxSmallint)+1
        else
          lResult:= -random(maxSmallint)-1;
        if random>0.5 then
          lTestInt2:= random(maxSmallint)+1
        else
          lTestInt2:= -random(maxSmallint)-1;

        lTestInt:=lResult * lTestInt2;

        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('0',frmCalcMain.DecString,'Display: 0');

        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,'Value['+inttostr(i)+'.1]: '+inttostr(lTestInt));
        frmCalcMain.btnDivide.Click;
        CheckEquals(integer(opDivide) ,integer(frmCalcMain.Operation),'Operation is Divide');
        frmCalcMain.Value := lTestInt2;
        CheckEquals(lTestInt2 ,frmCalcMain.Value,'Value['+inttostr(i)+'.2]: '+inttostr(lTestInt2));
        frmCalcMain.btnEquals.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation ');
        CheckEquals(lResult ,frmCalcMain.Value,'Result['+inttostr(i)+']: '+inttostr(lResult));
        CheckEquals(lTestInt2 ,lTestInt div frmCalcMain.Value  ,'Check['+inttostr(i)+'].1: '+inttostr(lTestInt2));
        CheckEquals(lTestInt ,frmCalcMain.Value * lTestInt2,'Check['+inttostr(i)+'].2: '+inttostr(lTestInt));
        CheckEquals(1 ,lTestInt div lTestInt2 div frmCalcMain.Value,'One['+inttostr(i)+']: 1');

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestOpNot;
  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := 246913569;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(246913569,frmCalcMain.Value,'Value: 246913569');
    frmCalcMain.btnNot.Click;
    CheckEquals(-246913570,frmCalcMain.Value,'Result: -246913570');

    frmCalcMain.btnClearEntry.Click;
    CheckEquals(0,frmCalcMain.value,'Display: 0');

    frmCalcMain.Value := -987654321;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(-987654321,frmCalcMain.Value,'Value: -987654321');
    frmCalcMain.btnNot.Click;
    CheckEquals(987654320,frmCalcMain.Value,'Result: 987654320');

    frmCalcMain.Value := 1234567890;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(1234567890,frmCalcMain.Value,'Value: 1234567890');
    frmCalcMain.btnNot.Click;
    CheckEquals(-1234567891,frmCalcMain.Value,'Value: -1234567891');

    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);

        lResult:= not lTestInt;

        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,'Value['+inttostr(i)+']: '+inttostr(lTestInt));
        frmCalcMain.btnNot.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation');
        CheckEquals(lResult ,frmCalcMain.Value,'Result['+inttostr(i)+']: '+inttostr(lResult));
        frmCalcMain.btnNot.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation');
        CheckEquals(lTestInt ,frmCalcMain.Value,'Check['+inttostr(i)+']: '+inttostr(lTestInt));

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:=lOrgCaption;
  end;

procedure TTestCalc32.TestOpAnd;

  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := 1234567890;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(1234567890,frmCalcMain.Value,'Display: 246913569');
    frmCalcMain.btnAnd.Click;
    CheckEquals(integer(opAnd) ,integer(frmCalcMain.Operation),'Operation is And');
    CheckEquals(0,frmCalcMain.value,'Display: 0');
    frmCalcMain.Value := -987654321;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(-987654321,frmCalcMain.Value,'Value: -987654321');
    frmCalcMain.btnEquals.Click;
    CheckEquals(1090519618,frmCalcMain.value,'Display: 1090519618');
    CheckEquals(1090519618,1234567890 and frmCalcMain.value,'Checksum1: 1090519618');
    CheckEquals(1090519618,-987654321 and frmCalcMain.value,'Checksum1: 1090519618');
    CheckEquals(0,not 1234567890 and frmCalcMain.value,'Inv1: 0');
    CheckEquals(0,not -987654321 and frmCalcMain.value,'Inv2: 0');
    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if random>0.5 then
          lTestInt2:= random(MaxInt)
        else
          lTestInt2:= -random(MaxInt);

        lResult:=lTestInt and lTestInt2;

        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('0',frmCalcMain.DecString,'Display: 0');

        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,'Value['+inttostr(i)+'.1]: '+inttostr(lResult));
        frmCalcMain.btnAnd.Click;
        CheckEquals(integer(opAnd) ,integer(frmCalcMain.Operation),'Operation is And');
        frmCalcMain.Value := lTestInt2;
        CheckEquals(lTestInt2 ,frmCalcMain.Value,'Value['+inttostr(i)+'.2]: '+inttostr(lTestInt2));
        frmCalcMain.btnEquals.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation ');
        CheckEquals(lResult ,frmCalcMain.Value,'Result['+inttostr(i)+']: '+inttostr(lTestInt2));
        CheckEquals(lResult ,frmCalcMain.Value and lTestInt,'Check['+inttostr(i)+'].1: '+inttostr(lResult));
        CheckEquals(lResult ,frmCalcMain.Value and lTestInt2,'Check['+inttostr(i)+'].2: '+inttostr(lResult));
        CheckEquals(0 ,frmCalcMain.Value and not lTestInt,'Zero['+inttostr(i)+']: 0');
        CheckEquals(0 ,frmCalcMain.Value and not lTestInt2,'Zero['+inttostr(i)+']: 0');

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:=lOrgCaption;

end;

procedure TTestCalc32.TestOpOr;
  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := 1234567890;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(1234567890,frmCalcMain.Value,'Display: 246913569');
    frmCalcMain.btnOr.Click;
    CheckEquals(integer(opOr) ,integer(frmCalcMain.Operation),'Operation is Or');
    CheckEquals(0,frmCalcMain.value,'Display: 0');
    frmCalcMain.Value := -987654321;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(-987654321,frmCalcMain.Value,'Value: -987654321');
    frmCalcMain.btnEquals.Click;
    CheckEquals(-843606049,frmCalcMain.value,'Display: -843606049');
    CheckEquals(-843606049,1234567890 Or frmCalcMain.value,'Checksum1: -843606049');
    CheckEquals(-843606049,-987654321 Or frmCalcMain.value,'Checksum1: -843606049');
    CheckEquals(-1,not 1234567890 Or frmCalcMain.value,'Inv1: -1');
    CheckEquals(-1,not -987654321 Or frmCalcMain.value,'Inv2: -1');
    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if random>0.5 then
          lTestInt2:= random(MaxInt)
        else
          lTestInt2:= -random(MaxInt);

        lResult:=lTestInt Or lTestInt2;

        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('0',frmCalcMain.DecString,'Display: 0');

        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,'Value['+inttostr(i)+'.1]: '+inttostr(lResult));
        frmCalcMain.btnOr.Click;
        CheckEquals(integer(opOr) ,integer(frmCalcMain.Operation),'Operation is Or');
        frmCalcMain.Value := lTestInt2;
        CheckEquals(lTestInt2 ,frmCalcMain.Value,'Value['+inttostr(i)+'.2]: '+inttostr(lTestInt2));
        frmCalcMain.btnEquals.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation ');
        CheckEquals(lResult ,frmCalcMain.Value,'Result['+inttostr(i)+']: '+inttostr(lTestInt2));
        CheckEquals(lResult ,frmCalcMain.Value Or lTestInt,'Check['+inttostr(i)+'].1: '+inttostr(lResult));
        CheckEquals(lResult ,frmCalcMain.Value Or lTestInt2,'Check['+inttostr(i)+'].2: '+inttostr(lResult));
        CheckEquals(-1 ,frmCalcMain.Value Or not lTestInt,'Full['+inttostr(i)+']: -1');
        CheckEquals(-1 ,frmCalcMain.Value Or not lTestInt2,'Full['+inttostr(i)+']: -1');

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestOpXor;
  var
    i: Integer;
    lTestInt,lTestInt2, lResult: integer;
    lOrgCaption: TCaption;
  begin
    CheckFalse(frmCalcMain.Visible,'MainForm is not visible at the moment');
    frmCalcMain.Show;
    Application.ProcessMessages;
    sleep(100);
    CheckTrue(frmCalcMain.Visible,'MainForm is visible now');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('0',frmCalcMain.DecString,'Display: 0');
    frmCalcMain.Value := 1234567890;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(1234567890,frmCalcMain.Value,'Display: 246913569');
    frmCalcMain.btnXor.Click;
    CheckEquals(integer(opXor) ,integer(frmCalcMain.Operation),'Operation is Xor');
    CheckEquals(0,frmCalcMain.value,'Display: 0');
    frmCalcMain.Value := -987654321;
    Application.ProcessMessages;
    sleep(100);
    CheckEquals(-987654321,frmCalcMain.Value,'Value: -987654321');
    frmCalcMain.btnEquals.Click;
    CheckEquals(-1934125667,frmCalcMain.value,'Display: -1934125667');
    CheckEquals(-987654321,1234567890 Xor frmCalcMain.value,'Checksum1: -987654321');
    CheckEquals(1234567890,-987654321 Xor frmCalcMain.value,'Checksum1: 1234567890');
    CheckEquals(0,-987654321 Xor 1234567890 Xor frmCalcMain.value,'Zero: 0');
    lOrgCaption:= frmCalcMain.Caption;
    for i := 0 to 10000 do
      begin
            if i mod 100 =0 then
        frmCalcMain.Caption := 'Calc ['+DupeString('|',30-i div 333)+DupeString(' ',i div 333)+']';
        if random>0.5 then
          lTestInt:= random(MaxInt)
        else
          lTestInt:= -random(MaxInt);
        if random>0.5 then
          lTestInt2:= random(MaxInt)
        else
          lTestInt2:= -random(MaxInt);

        lResult:=lTestInt Xor lTestInt2;

        frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
        CheckEquals('0',frmCalcMain.DecString,'Display: 0');

        frmCalcMain.Value := lTestInt;
        CheckEquals(lTestInt ,frmCalcMain.Value,'Value['+inttostr(i)+'.1]: '+inttostr(lResult));
        frmCalcMain.btnXor.Click;
        CheckEquals(integer(opXor) ,integer(frmCalcMain.Operation),'Operation is Xor');
        frmCalcMain.Value := lTestInt2;
        CheckEquals(lTestInt2 ,frmCalcMain.Value,'Value['+inttostr(i)+'.2]: '+inttostr(lTestInt2));
        frmCalcMain.btnEquals.Click;
        CheckEquals(integer(opNo) ,integer(frmCalcMain.Operation),'No Operation ');
        CheckEquals(lResult ,frmCalcMain.Value,'Result['+inttostr(i)+']: '+inttostr(lTestInt2));
        CheckEquals(lTestInt2 ,frmCalcMain.Value Xor lTestInt,'Check['+inttostr(i)+'].1: '+inttostr(lTestInt2));
        CheckEquals(lTestInt ,frmCalcMain.Value Xor lTestInt2,'Check['+inttostr(i)+'].2: '+inttostr(lTestInt));
        CheckEquals(0 ,frmCalcMain.Value Xor lTestInt Xor  lTestInt2,'Zero['+inttostr(i)+']: 0');

        if i mod 25 =0 then
          Application.ProcessMessages;
      end;
    frmCalcMain.Caption:=lOrgCaption;
end;

procedure TTestCalc32.TestForm;
var
  lOrgCaption: TCaption;
begin
  CheckFalse(frmCalcMain.Visible, 'MainForm is not visible at the moment');
  frmCalcMain.Show;
  lOrgCaption:= frmCalcMain.Caption;
  Application.OnUserInput:=@AppUserInput;
  while frmCalcMain.Visible do
  begin
        Application.Idle(false);
        Application.ProcessMessages;
        inc(fIdleCnt);
        sleep(10);
        if fIdleCnt> 300 then
          frmCalcMain.Hide
        else
          frmCalcMain.Caption := 'Calc ['+DupeString('|',30-fIdleCnt div 10)+DupeString(' ',fIdleCnt div 10)+']';
     end;
  frmCalcMain.Caption:=lOrgCaption;
end;

initialization

  RegisterTest(TTestCalc32{$IFNDEF FPC}.Suite{$ENDIF});
end.

