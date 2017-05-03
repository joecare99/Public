unit Frm_CALC2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Mask, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls, Buttons, ExtCtrls,
  Clipbrd, Frm_Calc2ABOUT;

type
  TCalcForm = class(TForm)
    MemButton: TSpeedButton;
    DecButton: TSpeedButton;
    HexButton: TSpeedButton;
    BinButton: TSpeedButton;
    Button7: TSpeedButton;
    Button8: TSpeedButton;
    Button9: TSpeedButton;
    Button4: TSpeedButton;
    Button5: TSpeedButton;
    Button6: TSpeedButton;
    Button1: TSpeedButton;
    Button2: TSpeedButton;
    Button3: TSpeedButton;
    Button0: TSpeedButton;
    PlusMinusButton: TSpeedButton;
    EqualButton: TSpeedButton;
    ButtonA: TSpeedButton;
    ButtonB: TSpeedButton;
    ButtonC: TSpeedButton;
    ButtonD: TSpeedButton;
    ButtonE: TSpeedButton;
    ButtonF: TSpeedButton;
    DivButton: TSpeedButton;
    TimesButton: TSpeedButton;
    MinusButton: TSpeedButton;
    PlusButton: TSpeedButton;
    ANDButton: TSpeedButton;
    ORButton: TSpeedButton;
    XORButton: TSpeedButton;
    NOTButton: TSpeedButton;
    CalcMainMenu: TMainMenu;
    CalcMenuItem: TMenuItem;
    CalcExitMenuItem: TMenuItem;
    MemBevel: TBevel;
    MemLabel: TLabel;
    DecBevel: TBevel;
    DecLabel: TLabel;
    HexBevel: TBevel;
    HexLabel: TLabel;
    BinBevel: TBevel;
    BinLabel: TLabel;
    LineBevel: TBevel;
    ClearButton: TSpeedButton;
    ClearEntryButton: TSpeedButton;
    BackButton: TSpeedButton;
    Help1: TMenuItem;
    About1: TMenuItem;
    Edit1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    BitBtn1: TBitBtn;
    procedure CalcExitMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonDigitClick(Sender: TObject);
    procedure DecHexBinButtonClick(Sender: TObject);
    procedure ClearEntryButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OpButtonClick(Sender: TObject);
    procedure EqualButtonClick(Sender: TObject);
    procedure PlusMinusButtonClick(Sender: TObject);
    procedure NOTButtonClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
  {- Entry-radix switches. Only one can be true! }
    DecEntry, HexEntry, BinEntry: Boolean;
  {- Enable and disable buttons depending on Entry radix }
    procedure EnableButtons;
  {- Update Dec, Hex, and Bin Labels from Accumulator }
    procedure UpdateDigitLabels;
  {- Update Accumulator value from current entry string }
    procedure UpdateAccumulator;
  {- Assign value to memory (intermediate) accumulator }
    procedure SetMemAcc(V: Longint);
  {- Display error message }
    procedure ShowError(const Msg: String);
  public
    { Public declarations }
  end;

var
  CalcForm: TCalcForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const

{ -2147483648 }
  maxDecDigits = 11;   { Maximum number of decimal digits }
{ 7FFFFFFF }
  maxHexDigits = 8;    { Maximum number of hex digits }
{ 00000000000000000000000000000000 }
  maxBinDigits = 32;   { Maximum number of binary digits }

  opNo         =  0;   { Operators = button Tag properties }
  opMultiply   = -1;
  opDivide     = -2;
  opAdd        = -3;
  opSubtract   = -4;
  opAnd        = -5;
  opOr         = -6;
  opXor        = -7;

  asciiEsc     = #27;  { Ascii escape control code }
  asciiEnter   = #13;  { Ascii enter control code }

var
  Accumulator: Longint;              { Current result }
  MemAcc: Longint;                   { Memory result }
  Operator: Integer;                 { opX constant }
  DecString: String;   { Result in decimal }
  HexString: String;   { Result in hex }
  BinString: String;   { Result in binary }

{- Global procedures -- for Xtrastuff??? }

{ Convert integer Value to binary string limited to Digits }
function IntToBin(Value: Longint; Digits: Integer): String;
var
  S: String;
begin
  S := '';               { Initialize string to null }
  while Digits > 0 do
  begin
    if Odd(Value) then S := '1' + S else S := '0' + S;
    Value := Value shr 1;
    Dec(Digits);
  end;
  Result := S;         { Return S as function result }
end;

{ Convert string S in decimal to Longint value }
function StringToInt(const S: String): Longint;
begin
  if Length(S) = 0 then
    Result := 0
  else try
    Result := StrToInt(S);
  except
    on E: Exception do
    begin
      CalcForm.ShowError(E.Message);
      Result := 0;
    end;
  end;
end;

{ Convert string S in hexadecimal to Longint value }
function StringToHex(const S: String): Longint;
var
  ErrorCode: Integer;
  V: Longint;
begin
  Val('$' + S, V, ErrorCode);  { Append Pascal's HEX char to S }
  Result := V;                 { Return V as function result }
end;

{ Convert string S in binary to Longint value }
function StringToBin(const S: String): Longint;
var
  V, Q: Longint;   { Function result value and temporary }
  I, J: Integer;   { For-loop controls }
begin
  V := 0;                     { Initialize result to 0 }
  J := Length(S) - 1;
  for I := 0 to J do          { Shift in each digit in string }
    if S[I + 1] = '1' then
    begin
      Q := 1;                       { Shift in a 1 }
      V := V or (Q shl (J - I));    { Using a logical OR }
    end;
  Result := V;              { Return V as function result }
end;

{- Private methods }

{ Enable and disable buttons depending on entry radix }
procedure TCalcForm.EnableButtons;
begin
{- Assume binary radix }
  Button0.Enabled := True;
  Button1.Enabled := True;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button5.Enabled := False;
  Button6.Enabled := False;
  Button7.Enabled := False;
  Button8.Enabled := False;
  Button9.Enabled := False;
  ButtonA.Enabled := False;
  ButtonB.Enabled := False;
  ButtonC.Enabled := False;
  ButtonD.Enabled := False;
  ButtonE.Enabled := False;
  ButtonF.Enabled := False;
{- Add decimal buttons }
  if (DecEntry or HexEntry) then
  begin
    Button2.Enabled := True;
    Button3.Enabled := True;
    Button4.Enabled := True;
    Button5.Enabled := True;
    Button6.Enabled := True;
    Button7.Enabled := True;
    Button8.Enabled := True;
    Button9.Enabled := True;
  end;
{- Add hex buttons }
  if HexEntry then
  begin
    ButtonA.Enabled := True;
    ButtonB.Enabled := True;
    ButtonC.Enabled := True;
    ButtonD.Enabled := True;
    ButtonE.Enabled := True;
    ButtonF.Enabled := True;
  end;
{- Enable / disable radix selector button D, H, or B }
  DecButton.Down := False;
  HexButton.Down := False;
  BinButton.Down := False;
  if DecEntry then
    DecButton.Down := True else
  if HexEntry then HexButton.Down := True else
    BinButton.Down := True;
end;

{ Update global strings and Label captions from Accumulator }
procedure TCalcForm.UpdateDigitLabels;
begin
{- Convert accumulator value to strings }
  DecString := IntToStr(Accumulator);
  HexString := IntToHex(Accumulator, maxHexDigits);
  BinString := IntToBin(Accumulator, maxBinDigits);
{- Assign strings to Label object Captions }
  DecLabel.Caption := DecString;
  HexLabel.Caption := HexString;
  BinLabel.Caption := BinString;
end;

{- Update Accumulator value from current entry string }
procedure TCalcForm.UpdateAccumulator;
begin
  try
    if DecEntry then
      Accumulator := StringToInt(DecString)
    else if HexEntry then
      Accumulator := StringToHex(HexString)
    else if BinEntry then
      Accumulator := StringToBin(BinString);
  except
    on E: EIntError do
      ShowError(E.Message);
  end;
end;

{- Assign V to MemAcc and update Memory display line }
procedure TCalcForm.SetMemAcc(V: Longint);
begin
  MemAcc := V;
  MemLabel.Caption := IntToStr(MemAcc);
end;

{- Display error message string }
procedure TCalcForm.ShowError(const Msg: String);
begin
  MessageDlg(Msg, mtError, [mbOk], 0);
end;

{- End program on selecting Close button }
procedure TCalcForm.CalcExitMenuItemClick(Sender: TObject);
begin
  Close;
end;

{- Initialize program on form's creation }
procedure TCalcForm.FormCreate(Sender: TObject);
var
  I: Integer;
  BB: TSpeedButton;
  sh:Tshape;
begin
  Accumulator := 0;      { Zero accumulator }    {-2147483647 - 1;}
  MemAcc := 0;           { Zero intermediate accumulator }
  Operator := opNo;      { No operation in effect }
  DecEntry := True;      { Assume Decimal radix initially }
  HexEntry := False;     { Turn off Hex entry }
  BinEntry := False;     { Turn off Binary entry }
  EnableButtons;         { Enable buttons depending on radix }
  UpdateDigitLabels;     { Update display result labels }
  for I := 0 to Componentcount - 1 do
      if components[i].InheritsFrom(TSpeedButton)  then
        begin
          BB:=TSpeedButton(components[i]);
          sh:=Tshape.Create(bb.Owner);
          with sh do
            begin
              sh.Parent := bb.Parent;
              sh.Width := bb.Width+4;
              sh.Height := bb.Height+4;
              sh.Top := bb.Top -1;
              sh.Left := bb.Left -1;
              sh.Shape := stRoundRect;
              sh.Brush.Color := clDkGray;
              sh.Pen.Style := psClear;
              bb.BringToFront;
            end
        end;
end;

{- Respond to click of a digit button 0 through F }
procedure TCalcForm.ButtonDigitClick(Sender: TObject);
begin
{- Ignore button clicks if accumulators are full }
  if Length(DecString) = maxDecDigits then Exit;
{- Append button tag to end of strings }
  with Sender as TSpeedButton do
  begin
    if DecEntry then
      DecString := DecString + IntToStr(Tag)
    else if HexEntry then
    begin
      Delete(HexString, 1, 1);
      HexString := HexString + IntToHex(Tag, 1);
    end else if BinEntry then
    begin
      Delete(BinString, 1, 1);
      BinString := BinString + IntToBin(Tag, 1);
    end;
  end;
  UpdateAccumulator;  { Convert entry string to Longint value }
  UpdateDigitLabels;  { Update display result labels }
end;

{- Change radix on clicking D, H, or B button }
procedure TCalcForm.DecHexBinButtonClick(Sender: TObject);
begin
  DecEntry := False;  { Preset all entry radix switches to False }
  HexEntry := False;
  BinEntry := False;
  with Sender as TSpeedButton do
    if Name = DecButton.Name then DecEntry := True
    else if Name = HexButton.Name then HexEntry := True
    else if Name = BinButton.Name then BinEntry := True;
  EnableButtons;      { Enable buttons depending on entry radix }
end;

{- Clear current entry (Accumulator) only }
procedure TCalcForm.ClearEntryButtonClick(Sender: TObject);
begin
  Accumulator := 0;
  UpdateDigitLabels;
end;

{- Clear current entry and memory (Accumulator and MemAcc) }
procedure TCalcForm.ClearButtonClick(Sender: TObject);
begin
  Accumulator := 0;
  UpdateDigitLabels;
  SetMemAcc(0);
end;

{ Delete last digit entered }
procedure TCalcForm.BackButtonClick(Sender: TObject);
begin
  if DecEntry then
    Delete(DecString, Length(DecString), 1)
  else if HexEntry then
    Delete(HexString, Length(HexString), 1)
  else if BinEntry then
    Delete(BinString, Length(BinString), 1);
  UpdateAccumulator;  { Convert entry string to Longint value }
  UpdateDigitLabels;  { Update display result labels }
end;

{- Translate keypresses into button clicks }
procedure TCalcForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  Button: TButton;
begin
  case Key of
    asciiEsc: ClearButtonClick(Sender);
    asciiEnter: EqualButtonClick(Sender);
    '*': TimesButton.Click;
    '/': DivButton.Click;
    '+': PlusButton.Click;
    '-': MinusButton.Click;
    else begin
      Button := TButton(FindComponent('Button' + Key));
      if Button <> nil then
        if Button.Enabled then
          Button.Click;
    end;
  end;
end;

{- Respond to click of an operator button (* / + - and or xor) }
{- Start math operation }
procedure TCalcForm.OpButtonClick(Sender: TObject);
begin
  if Operator <> opNo then
    EqualButtonClick(Sender);
  SetMemAcc(Accumulator);
  Operator := TButton(Sender).Tag;
  Accumulator := 0;
  UpdateDigitLabels;
end;

{- Respond to click of equal button. Complete math operation. }
procedure TCalcForm.EqualButtonClick(Sender: TObject);
begin
  try
    case Operator of
      opMultiply : Accumulator := MemAcc * Accumulator;
      opDivide   : Accumulator := MemAcc div Accumulator;
      opAdd      : Accumulator := MemAcc + Accumulator;
      opSubtract : Accumulator := MemAcc - Accumulator;
      opAnd      : Accumulator := MemAcc and Accumulator;
      opOr       : Accumulator := MemAcc or Accumulator;
      opXor      : Accumulator := MemAcc xor Accumulator;
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
  UpdateDigitLabels;
  Operator := opNo;
  SetMemAcc(0);
end;

{- Respond to +/- button click }
procedure TCalcForm.PlusMinusButtonClick(Sender: TObject);
begin
  Accumulator := -Accumulator;
  UpdateDigitLabels;
end;

{- Respond to NOT button click }
procedure TCalcForm.NOTButtonClick(Sender: TObject);
begin
  Accumulator := not Accumulator;
  UpdateDigitLabels;
end;

{- Copy current radix string to clipboard }
procedure TCalcForm.Copy1Click(Sender: TObject);
begin
  if DecEntry then
    Clipboard.AsText := DecString
  else if HexEntry then
    Clipboard.AsText := HexString
  else if BinEntry then
    Clipboard.AsText := BinString
end;

{- Paste clipboard text to current radix string }
procedure TCalcForm.Paste1Click(Sender: TObject);
begin
  if Clipboard.HasFormat(cf_Text) then
  begin
    if DecEntry then
      DecString := Clipboard.AsText
    else if HexEntry then
      HexString := Clipboard.AsText
    else if BinEntry then
      BinString := Clipboard.AsText;
    UpdateAccumulator;
    UpdateDigitLabels;
  end;
end;

procedure TCalcForm.About1Click(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

end.

