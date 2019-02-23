unit Frm_CALC64;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Mask, Windows, Actions,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls, Buttons, ExtCtrls,
  Clipbrd, ActnList, Frm_CalcABOUT ;

type
  TEnumOperations =(
opNo = 0, { Operators = button Tag properties }
opMultiply = -1,
opDivide = -2,
opAdd = -3,
opSubtract = -4,
opAnd = -5,
opOr = -6,
opXor = -7);


  { TfrmCalc64Main }

  TfrmCalc64Main = class(TForm)
    BinBevel: TPanel;
    btnEquals: TButton;
    DecBevel: TPanel;
    HexBevel: TPanel;
    MemBevel: TPanel;
    MemButton: TSpeedButton;
    DecButton: TSpeedButton;
    HexButton: TSpeedButton;
    BinButton: TSpeedButton;
    btn7: TSpeedButton;
    btn8: TSpeedButton;
    btn9: TSpeedButton;
    btn4: TSpeedButton;
    btn5: TSpeedButton;
    btn6: TSpeedButton;
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    btn3: TSpeedButton;
    btn0: TSpeedButton;
    btnPoint: TSpeedButton;
    btnNegate: TSpeedButton;
    btnA: TSpeedButton;
    btnB: TSpeedButton;
    btnC: TSpeedButton;
    btnD: TSpeedButton;
    btnE: TSpeedButton;
    btnF: TSpeedButton;
    btnDivide: TSpeedButton;
    btnMultiply: TSpeedButton;
    btnMinus: TSpeedButton;
    btnPlus: TSpeedButton;
    btnAnd: TSpeedButton;
    btnOr: TSpeedButton;
    btnXor: TSpeedButton;
    btnNot: TSpeedButton;
    CalcMainMenu: TMainMenu;
    CalcMenuItem: TMenuItem;
    CalcExitMenuItem: TMenuItem;
    lblMemory: TLabel;
    lblDecimal: TLabel;
    lblHex: TLabel;
    lblBinary: TLabel;
    LineBevel: TBevel;
    btnClear: TSpeedButton;
    btnClearEntry: TSpeedButton;
    btnBack: TSpeedButton;
    Help1: TMenuItem;
    About1: TMenuItem;
    Edit1: TMenuItem;
    pnlDisplay: TPanel;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    BitBtn1: TBitBtn;
    ActionList1: TActionList;
    procedure CalcExitMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonDigitClick(Sender: TObject);
    procedure DecHexBinButtonClick(Sender: TObject);
    procedure btnClearEntryClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OpButtonClick(Sender: TObject);
    procedure btnEqualsClick(Sender: TObject);
    procedure btnNegateClick(Sender: TObject);
    procedure btnNotClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { - Entry-radix switches. Only one can be true! }
    DecEntry, HexEntry, BinEntry: Boolean;
    { - Negate-Flage for negative Entry }
    FNegFlag :boolean;

      FAccumulator: Int64; { Current result }
  FMemAcc: Int64; { Memory result }
  FOperator: TEnumOperations; { opX constant }
  FDecString: String; { Result in decimal }
  FHexString: String; { Result in hex }
  FBinString: String; { Result in binary }

    { - Enable and disable buttons depending on Entry radix }
    procedure EnableButtons;
    function GetValue: int64;
    procedure SetValue(AValue: int64);
    { - Update Dec, Hex, and Bin Labels from Accumulator }
    procedure UpdateDisplay;
    { - Update Accumulator value from current entry string }
    procedure UpdateAccumulator;
    { - Assign value to memory (intermediate) accumulator }
    procedure SetMemAcc(V: int64);
    { - Display error message }
    procedure ShowError(const Msg: String);
  public
    { Public declarations }
    Property Value:int64 read GetValue write SetValue;
    property DecString:String read FDecString;
    property HexString:String read FHexString;
    property BinString:String read FBinString;
    property Operation:TEnumOperations read FOperator;
  end;

var
  frmCalc64Main: TfrmCalc64Main;

implementation

uses strutils{$IFnDEF FPC},StrUtilsExt{$ENDIF};

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  OpDisplay:array[TEnumOperations] of string =
  ('><',
   '\/',
   '/\',
   '-',
   '+',
   '/',
   '*',
   ' ');

  MyMaxInt64 = high(int64);

  { -2147483648 }
  maxDecDigits = 22; { Maximum number of decimal digits }
  { 7FFFFFFF }
  maxHexDigits = 16; { Maximum number of hex digits }
  { 00000000000000000000000000000000 }
  maxBinDigits = 64; { Maximum number of binary digits }

  asciiEsc = #27; { Ascii escape control code }
  asciiEnter = #13; { Ascii enter control code }
  asciiDel = #8;

{ - Global procedures -- for Xtrastuff??? }


{ Convert string S in decimal to Longint value }
  function StringToInt(const S: String): int64;
  begin
    if Length(S) = 0 then
      Result := 0
    else
      try
        Result := StrToInt64(S);
      except
        on E: Exception do
        begin
          frmCalc64Main.ShowError(E.Message);
          Result := 0;
        end;
      end;
  end;

{ Convert string S in hexadecimal to Longint value }
  function StringToHex(const S: String): Int64;
  var
    {%H-}ErrorCode: Integer;
    V: int64;
  begin
    Val('$' + S, V, ErrorCode); { Append Pascal's HEX char to S }
    Result := V; { Return V as function result }
  end;

{ Convert string S in binary to Longint value }
  function StringToBin(const S: String): int64;
  var
    V, Q: int64; { Function result value and temporary }
    I, J: Integer; { For-loop controls }
  begin
    V := 0; { Initialize result to 0 }
    J := Length(S) - 1;
    for I := 0 to J do { Shift in each digit in string }
      if S[I + 1] = '1' then
      begin
        Q := 1; { Shift in a 1 }
        V := V or (Q shl (J - I)); { Using a logical OR }
      end;
    Result := V; { Return V as function result }
  end;

{ - Private methods }

{ Enable and disable buttons depending on entry radix }
  procedure TfrmCalc64Main.EnableButtons;
  begin
    { - Assume binary radix }
    btn0.Enabled := True;
    btn1.Enabled := True;
    btn2.Enabled := False;
    btn3.Enabled := False;
    btn4.Enabled := False;
    btn5.Enabled := False;
    btn6.Enabled := False;
    btn7.Enabled := False;
    btn8.Enabled := False;
    btn9.Enabled := False;
    btnA.Enabled := False;
    btnB.Enabled := False;
    btnC.Enabled := False;
    btnD.Enabled := False;
    btnE.Enabled := False;
    btnF.Enabled := False;
    { - Add decimal buttons }
    if (DecEntry or HexEntry) then
    begin
      btn2.Enabled := True;
      btn3.Enabled := True;
      btn4.Enabled := True;
      btn5.Enabled := True;
      btn6.Enabled := True;
      btn7.Enabled := True;
      btn8.Enabled := True;
      btn9.Enabled := True;
    end;
    { - Add hex buttons }
    if HexEntry then
    begin
      btnA.Enabled := True;
      btnB.Enabled := True;
      btnC.Enabled := True;
      btnD.Enabled := True;
      btnE.Enabled := True;
      btnF.Enabled := True;
    end;
    { - Enable / disable radix selector button D, H, or B }
    DecButton.Down := False;
    HexButton.Down := False;
    BinButton.Down := False;
    if DecEntry then
      DecButton.Down := True
    else if HexEntry then
      HexButton.Down := True
    else
      BinButton.Down := True;
  end;

function TfrmCalc64Main.GetValue: int64;
begin
  Result := FAccumulator;
end;

procedure TfrmCalc64Main.SetValue(AValue: int64);
begin
  if FAccumulator = AValue then exit;
  FAccumulator := AValue;
  UpdateDisplay;
end;

{ Update global strings and Label captions from Accumulator }
  procedure TfrmCalc64Main.UpdateDisplay;
  var
    lClaption: String;
    i: Integer;
  begin
      { - Convert FAccumulator value to strings }
    if not FNegFlag or (FAccumulator<>0) then
      FDecString := IntToStr(FAccumulator)
    else
      FDecString := '-'+IntToStr(FAccumulator);

    FHexString := IntToHex(FAccumulator, maxHexDigits);
    FBinString := intTobin(FAccumulator, maxBinDigits);
    { - Assign strings to Label object Captions }
    lClaption := FDecString;
    for i := 1 to (length(inttostr(abs(FAccumulator)))-1) div 3  do
      Insert('.',lClaption,length(lClaption)+2-i*4);
    lblDecimal.Caption := lClaption+' ';
    lClaption := FHexString;
    for i := 1 to (length(FHexString)-1) div 4  do
      Insert(' ',lClaption,length(lClaption)+2-i*5);
    lblHex.Caption := lClaption+' ';
    lClaption := FBinString;
    for i := 1 to (length(FBinString)-1) div 4  do
      Insert(' ',lClaption,length(lClaption)+2-i*5);
    lblBinary.Caption := lClaption+' ';
  end;

{ - Update Accumulator value from current entry string }
  procedure TfrmCalc64Main.UpdateAccumulator;
  begin
    try
      if DecEntry then
        FAccumulator := StringToInt(FDecString)
      else if HexEntry then
        FAccumulator := StringToHex(FHexString)
      else if BinEntry then
        FAccumulator := StringToBin(FBinString);
    except
      on E: EIntError do
        ShowError(E.Message);
    end;
  end;

{ - Assign V to MemAcc and update Memory display line }
  procedure TfrmCalc64Main.SetMemAcc(V: int64);
  var
    lClaption: String;
    i: Integer;
  begin
    FMemAcc := V;
    if DecEntry then
    begin
    lClaption := IntToStr(FMemAcc);
    for i := 1 to (length(inttostr(abs(FMemAcc)))-1) div 3  do
      Insert('.',lClaption,length(lClaption)+2-i*4);
    end
    else
    begin
    lClaption:=inttohex(FMemAcc,16);
    for i := 1 to (length(FHexString)-1) div 4  do
      Insert(' ',lClaption,length(lClaption)+2-i*5);
    end;
    lblMemory.Caption := lClaption+' ';
  end;

{ - Display error message string }
  procedure TfrmCalc64Main.ShowError(const Msg: String);
  begin
    MessageDlg(Msg, mtError, [mbOk], 0);
  end;

{ - End program on selecting Close button }
  procedure TfrmCalc64Main.CalcExitMenuItemClick(Sender: TObject);
  begin
    Close;
  end;

{ - Initialize program on form's creation }
  procedure TfrmCalc64Main.FormCreate(Sender: TObject);
  begin
    FAccumulator := 0; { Zero FAccumulator }    { -2147483647 - 1; }
    FMemAcc := 0; { Zero intermediate FAccumulator }

    FOperator := opNo; { No operation in effect }
    DecEntry := True; { Assume Decimal radix initially }
    HexEntry := False; { Turn off Hex entry }
    BinEntry := False; { Turn off Binary entry }
    EnableButtons; { Enable buttons depending on radix }
    UpdateDisplay; { Update display result labels }
    end;

    { - Respond to click of a digit button 0 through F }
    procedure TfrmCalc64Main.ButtonDigitClick(Sender: TObject);
    begin
      { - Ignore button clicks if accumulators are full }
      if DecEntry  and ( -abs(FAccumulator) < -MyMaxInt64 div 10) then
        Exit;
      if hexEntry  and (( FAccumulator and $f000000000000000 )<> 0) then
        Exit;
      if binEntry  and ( FAccumulator < 0) then
        Exit;
      { - Append button tag to end of strings }
      with Sender as TSpeedButton do
      begin
        if DecEntry and not FNegFlag then
          FDecString := trim(FDecString) + IntToStr(Tag)
        else if DecEntry and FNegFlag then
          begin
            FDecString := '-' + IntToStr(Tag);
            if Tag> 0 then
              FNegFlag:=false;
          end
        else if HexEntry then
        begin
          Delete(FHexString, 1, 1);
          FHexString := trim(FHexString) + IntToHex(Tag, 1);
        end
        else if BinEntry then
        begin
          Delete(FBinString, 1, 1);
          FBinString := trim(FBinString) + IntToBin(Tag, 1);
        end;
      end;
      UpdateAccumulator; { Convert entry string to Longint value }
      UpdateDisplay; { Update display result labels }
    end;

    { - Change radix on clicking D, H, or B button }
    procedure TfrmCalc64Main.DecHexBinButtonClick(Sender: TObject);
    begin
      DecEntry := False; { Preset all entry radix switches to False }
      HexEntry := False;
      BinEntry := False;
      with Sender as TSpeedButton do
        if Name = DecButton.Name then
          DecEntry := True
        else if Name = HexButton.Name then
          HexEntry := True
        else if Name = BinButton.Name then
          BinEntry := True;
      EnableButtons; { Enable buttons depending on entry radix }
    end;

    { - Clear current entry (Accumulator) only }
    procedure TfrmCalc64Main.btnClearEntryClick(Sender: TObject);
    begin
      FAccumulator := 0;
      UpdateDisplay;
    end;

    { - Clear current entry and memory (Accumulator and MemAcc) }
    procedure TfrmCalc64Main.btnClearClick(Sender: TObject);
    begin
      FAccumulator := 0;
      UpdateDisplay;
      SetMemAcc(0);
    end;

    { Delete last digit entered }
    procedure TfrmCalc64Main.btnBackClick(Sender: TObject);
    begin
      if DecEntry then
        Delete(FDecString, Length(FDecString), 1)
      else if HexEntry then
        Delete(FHexString, Length(FHexString), 1)
      else if BinEntry then
        Delete(FBinString, Length(FBinString), 1);
      UpdateAccumulator; { Convert entry string to Longint value }
      UpdateDisplay; { Update display result labels }
    end;

    { - Translate keypresses into button clicks }
    procedure TfrmCalc64Main.FormKeyPress(Sender: TObject; var Key: Char);
    var
      Button: TGraphicControl;
    begin
      case Key of
        asciiEsc:
          begin
            btnClearEntryClick(Sender);
            key :=#0;
          end;
        asciiEnter:
          begin
            btnEqualsClick(Sender);
            key :=#0;
          end;
        '*':
          btnMultiply.Click;
        '/':
          btnDivide.Click;
        '+':
          btnPlus.Click;
        '-':if FAccumulator=0 then
          btnNegate.Click
        else
          btnMinus.Click;
      else
        begin
          Button := TGraphicControl(FindComponent('btn' + Key));
          if assigned(Button) and Button.Enabled and button.InheritsFrom(TSpeedButton) then
             TSpeedButton(Button).Click;
        end;
      end;
    end;

    { - Respond to click of an operator button (* / + - and or xor) }
    { - Start math operation }
    procedure TfrmCalc64Main.OpButtonClick(Sender: TObject);
    begin
      if FOperator <> opNo then
        btnEqualsClick(Sender);
      SetMemAcc(FAccumulator);
      if sender.InheritsFrom(TControl) then
        FOperator := TEnumOperations(TControl(Sender).Tag);
      FAccumulator := 0;
      UpdateDisplay;
      end;

      { - Respond to click of equal button. Complete math operation. }
      procedure TfrmCalc64Main.btnEqualsClick(Sender: TObject);
      begin
        try
          case FOperator of
            opMultiply:
              FAccumulator := FMemAcc * FAccumulator;
            opDivide:
              FAccumulator := FMemAcc div FAccumulator;
            opAdd:
              FAccumulator := FMemAcc + FAccumulator;
            opSubtract:
              FAccumulator := FMemAcc - FAccumulator;
            opAnd:
              FAccumulator := FMemAcc and FAccumulator;
            opOr:
              FAccumulator := FMemAcc or FAccumulator;
            opXor:
              FAccumulator := FMemAcc xor FAccumulator;
          end;
        except
          on E: EIntError do
            if E is EDivByZero then
              ShowError('Divide by zero')
            else if E is ERangeError then
              ShowError('Out of range')
            else if E is EIntOverflow then
              ShowError('Overflow');
        end;
        FOperator := opNo;
        UpdateDisplay;

        SetMemAcc(0);
        end;

        { - Respond to +/- button click }
        procedure TfrmCalc64Main.btnNegateClick(Sender: TObject);
        begin
          if FAccumulator <> 0 then
             FAccumulator := -FAccumulator
          else
             FNegFlag := not FNegFlag;
          UpdateDisplay;
        end;

        { - Respond to NOT button click }
        procedure TfrmCalc64Main.btnNotClick(Sender: TObject);
        begin
          FAccumulator:=not FAccumulator;
          UpdateDisplay;
        end;

        { - Copy current radix string to clipboard }
        procedure TfrmCalc64Main.Copy1Click(Sender: TObject);
        begin
          if DecEntry then
            Clipboard.AsText := FDecString
          else if HexEntry then
            Clipboard.AsText := FHexString
          else if BinEntry then
            Clipboard.AsText := FBinString
        end;

        { - Paste clipboard text to current radix string }
        procedure TfrmCalc64Main.Paste1Click(Sender: TObject);
        begin
          if Clipboard.HasFormat(cf_Text) then
          begin
            if DecEntry then
              FDecString := Clipboard.AsText
            else if HexEntry then
              FHexString := Clipboard.AsText
            else if BinEntry then
              FBinString := Clipboard.AsText;
            UpdateAccumulator;
            UpdateDisplay;
          end;
        end;

        procedure TfrmCalc64Main.About1Click(Sender: TObject);
        begin
          {$IFDEF FPC}
          frmCalcAbout.ApplicationName := ApplicationName;
          frmCalcAbout.VendorName := VendorName;
          {$ENDIF}
          frmCalcAbout.ProductName := Application.Title;
          frmCalcAbout.URL := 'www.jc99.de';
          frmCalcAbout.ShowModal;
        end;

end.
