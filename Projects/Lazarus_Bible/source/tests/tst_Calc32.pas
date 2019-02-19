unit tst_Calc32;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, fpcunit, testutils, testregistry;

type

  { TTestCalc32 }

  TTestCalc32= class(TTestCase)
  private
    FIdleCnt: Integer;
    FSleeptime:integer;
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    Procedure PunchIn(aValue:INteger);overload;
    procedure PunchInKey(aValue: INteger);
  published
    procedure TestSetUp;
    procedure TestMainForm;
    procedure TestAboutForm;
    PRocedure TestEntry;
    Procedure TestEntryHex;
    Procedure TestEntrybin;
    PRocedure TestEntryKey;
    Procedure TestEntryKHex;
    Procedure TestEntryKbin;
    Procedure TestForm;
  end;

implementation

uses Forms,Frm_CALC,Frm_CalcABOUT,StrUtils;

procedure TTestCalc32.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
  FIdleCnt:=0;
end;

procedure TTestCalc32.SetUp;
begin
  if not assigned(frmCalcMain) then
  Application.CreateForm(TfrmCalcMain,frmCalcMain);
  if not assigned(frmCalcAbout) then
  Application.CreateForm(TfrmCalcAbout,frmCalcAbout);
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
  CheckEquals('0 ',frmCalcMain.DecLabel.Caption,'Display: 0');
  PunchIn(1234567890);
  CheckEquals('1234567890 ',frmCalcMain.DecLabel.Caption,'Display: 1234567890');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0 ',frmCalcMain.DecLabel.Caption,'Display: 0');
  PunchIn(-987654321);
  CheckEquals('-987654321 ',frmCalcMain.DecLabel.Caption,'Display: -987654321');
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
      CheckEquals('0 ',frmCalcMain.DecLabel.Caption,'Display: 0');
      PunchIn(lTestInt);
      CheckEquals(inttostr(lTestInt)+' ',frmCalcMain.DecLabel.Caption,
        'Display['+inttostr(i)+']: '+inttostr(lTestInt));
      if abs(lTestInt) > maxint div 10 then
        begin
          PunchIn(random(10));
          // No Change
          CheckEquals(inttostr(lTestInt)+' ',frmCalcMain.DecLabel.Caption,
            'Display['+inttostr(i)+'].2n: '+inttostr(lTestInt));
        end
      else
      begin
        PunchIn(0);
        // a Change
        CheckEquals(inttostr(lTestInt*10)+' ',frmCalcMain.DecLabel.Caption,
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
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 00000000');
    PunchIn($12345678);
    CheckEquals(inttohex($12345678,8)+' ',frmCalcMain.HexLabel.Caption,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 00000000');
    PunchIn(longint($FEDCBA98));
    CheckEquals(inttohex($FEDCBA98,8)+' ',frmCalcMain.HexLabel.Caption,'Display: -987654321');
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
        CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 00000000');
        PunchIn(lTestInt);
        CheckEquals(inttohex(lTestInt,8)+' ',frmCalcMain.hexLabel.Caption,
          'Display['+inttostr(i)+']: $'+inttohex(lTestInt,8));
        if (lTestInt > $FFFFFFF) or (lTestInt<0)  then
          begin
            PunchIn(random(16));
            // No Change
            CheckEquals(inttohex(lTestInt,8)+' ',frmCalcMain.hexLabel.Caption,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchIn(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 4,8)+' ',frmCalcMain.hexLabel.Caption,
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
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 0');
    PunchIn($12345678);
    CheckEquals(inttobin($12345678,32)+' ',frmCalcMain.BinLabel.Caption,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 0');
    PunchIn(integer($FEDCBA98));
    CheckEquals(inttobin($FEDCBA98,32)+' ',frmCalcMain.binLabel.Caption,'Display: $FEDCBA98');
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
        CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 0');
        PunchIn(lTestInt);
        CheckEquals(inttobin(lTestInt,32)+' ',frmCalcMain.BinLabel.Caption,
          'Display['+inttostr(i)+']: &'+inttobin(lTestInt,32));
        if lTestInt < 0  then
          begin
            PunchIn(random(2));
            // No Change
            CheckEquals(inttohex(lTestInt,8)+' ',frmCalcMain.hexLabel.Caption,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchIn(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 1,8)+' ',frmCalcMain.hexLabel.Caption,
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
  CheckEquals('0 ',frmCalcMain.DecLabel.Caption,'Display: 0');
  PunchInKey(1234567890);
  CheckEquals('1234567890 ',frmCalcMain.DecLabel.Caption,'Display: 1234567890');
  frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
  CheckEquals('0 ',frmCalcMain.DecLabel.Caption,'Display: 0');
  PunchInKey(-987654321);
  CheckEquals('-987654321 ',frmCalcMain.DecLabel.Caption,'Display: -987654321');
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
      CheckEquals('0 ',frmCalcMain.DecLabel.Caption,'Display: 0');
      PunchInKey(lTestInt);
      CheckEquals(inttostr(lTestInt)+' ',frmCalcMain.DecLabel.Caption,
        'Display['+inttostr(i)+']: '+inttostr(lTestInt));
      if abs(lTestInt) > maxint div 10 then
        begin
          PunchInKey(random(10));
          // No Change
          CheckEquals(inttostr(lTestInt)+' ',frmCalcMain.DecLabel.Caption,
            'Display['+inttostr(i)+'].2n: '+inttostr(lTestInt));
        end
      else
      begin
        PunchInKey(0);
        // a Change
        CheckEquals(inttostr(lTestInt*10)+' ',frmCalcMain.DecLabel.Caption,
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
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 00000000');
    PunchInKey($12345678);
    CheckEquals(inttohex($12345678,8)+' ',frmCalcMain.HexLabel.Caption,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 00000000');
    PunchInKey(longint($FEDCBA98));
    CheckEquals(inttohex($FEDCBA98,8)+' ',frmCalcMain.HexLabel.Caption,'Display: -987654321');
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
        CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 00000000');
        PunchInKey(lTestInt);
        CheckEquals(inttohex(lTestInt,8)+' ',frmCalcMain.hexLabel.Caption,
          'Display['+inttostr(i)+']: $'+inttohex(lTestInt,8));
        if (lTestInt > $FFFFFFF) or (lTestInt<0)  then
          begin
            PunchInKey(random(16));
            // No Change
            CheckEquals(inttohex(lTestInt,8)+' ',frmCalcMain.hexLabel.Caption,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchInKey(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 4,8)+' ',frmCalcMain.hexLabel.Caption,
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
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 0');
    PunchInKey($12345678);
    CheckEquals(inttobin($12345678,32)+' ',frmCalcMain.BinLabel.Caption,'Display: $12345678');
    frmCalcMain.btnClearEntryClick(frmCalcMain.btnClearEntry);
    CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 0');
    PunchInKey(integer($FEDCBA98));
    CheckEquals(inttobin($FEDCBA98,32)+' ',frmCalcMain.binLabel.Caption,'Display: $FEDCBA98');
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
        CheckEquals('00000000 ',frmCalcMain.HexLabel.Caption,'Display: 0');
        PunchInKey(lTestInt);
        CheckEquals(inttobin(lTestInt,32)+' ',frmCalcMain.BinLabel.Caption,
          'Display['+inttostr(i)+']: &'+inttobin(lTestInt,32));
        if lTestInt < 0  then
          begin
            PunchInKey(random(2));
            // No Change
            CheckEquals(inttohex(lTestInt,8)+' ',frmCalcMain.hexLabel.Caption,
              'Display['+inttostr(i)+'].2n: $'+inttohex(lTestInt,8));
          end
        else
        begin
          PunchInKey(0);
          // a Change
          CheckEquals(inttohex(lTestInt shl 1,8)+' ',frmCalcMain.hexLabel.Caption,
            'Display['+inttostr(i)+'].2p: $'+inttohex(lTestInt ,8)+' shl 1');
        end
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

  RegisterTest(TTestCalc32);
end.

