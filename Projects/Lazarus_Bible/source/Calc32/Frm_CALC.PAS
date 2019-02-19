unit Frm_CALC;

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

  { TfrmCalcMain }

  TfrmCalcMain = class(TForm)
    BinBevel: TPanel;
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
    btnEquals: TSpeedButton;
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
    MemLabel: TLabel;
    DecLabel: TLabel;
    HexLabel: TLabel;
    BinLabel: TLabel;
    LineBevel: TBevel;
    btnClear: TSpeedButton;
    btnClearEntry: TSpeedButton;
    btnBack: TSpeedButton;
    Help1: TMenuItem;
    About1: TMenuItem;
    Edit1: TMenuItem;
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
    { - Enable and disable buttons depending on Entry radix }
    procedure EnableButtons;
    { - Update Dec, Hex, and Bin Labels from Accumulator }
    procedure UpdateDisplay;
    { - Update Accumulator value from current entry string }
    procedure UpdateAccumulator;
    { - Assign value to memory (intermediate) accumulator }
    procedure SetMemAcc(V: Longint);
    { - Display error message }
    procedure ShowError(const Msg: String);
  public
    { Public declarations }
  end;

var
  frmCalcMain: TfrmCalcMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

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

const

  { -2147483648 }
  maxDecDigits = 11; { Maximum number of decimal digits }
  { 7FFFFFFF }
  maxHexDigits = 8; { Maximum number of hex digits }
  { 00000000000000000000000000000000 }
  maxBinDigits = 32; { Maximum number of binary digits }

  asciiEsc = #27; { Ascii escape control code }
  asciiEnter = #13; { Ascii enter control code }

var
  Accumulator: Longint; { Current result }
  MemAcc: Longint; { Memory result }
  aOperator: TEnumOperations; { opX constant }
  DecString: String; { Result in decimal }
  HexString: String; { Result in hex }
  BinString: String; { Result in binary }

{ - Global procedures -- for Xtrastuff??? }

{ Convert integer Value to binary string limited to Digits }
  function IntToBin(Value: Longint; Digits: Integer): String;
  var
    S: String;
  begin
    S := ''; { Initialize string to null }
    while Digits > 0 do
    begin
      if Odd(Value) then
        S := '1' + S
      else
        S := '0' + S;
      Value := Value shr 1;
      Dec(Digits);
    end;
    Result := S; { Return S as function result }
  end;

{ Convert string S in decimal to Longint value }
  function StringToInt(const S: String): Longint;
  begin
    if Length(S) = 0 then
      Result := 0
    else
      try
        Result := StrToInt(S);
      except
        on E: Exception do
        begin
          frmCalcMain.ShowError(E.Message);
          Result := 0;
        end;
      end;
  end;

{ Convert string S in hexadecimal to Longint value }
  function StringToHex(const S: String): Longint;
  var
    {%H-}ErrorCode: Integer;
    V: Longint;
  begin
    Val('$' + S, V, ErrorCode); { Append Pascal's HEX char to S }
    Result := V; { Return V as function result }
  end;

{ Convert string S in binary to Longint value }
  function StringToBin(const S: String): Longint;
  var
    V, Q: Longint; { Function result value and temporary }
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
  procedure TfrmCalcMain.EnableButtons;
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

{ Update global strings and Label captions from Accumulator }
  procedure TfrmCalcMain.UpdateDisplay;
  begin
    { - Convert accumulator value to strings }
    DecString := IntToStr(Accumulator)+' ';
    HexString := IntToHex(Accumulator, maxHexDigits)+' ';
    BinString := IntToBin(Accumulator, maxBinDigits)+' ';
    { - Assign strings to Label object Captions }
    DecLabel.Caption := DecString;
    HexLabel.Caption := HexString;
    BinLabel.Caption := BinString;
  end;

{ - Update Accumulator value from current entry string }
  procedure TfrmCalcMain.UpdateAccumulator;
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

{ - Assign V to MemAcc and update Memory display line }
  procedure TfrmCalcMain.SetMemAcc(V: Longint);
  begin
    MemAcc := V;
    MemLabel.Caption := IntToStr(MemAcc)+' ';
  end;

{ - Display error message string }
  procedure TfrmCalcMain.ShowError(const Msg: String);
  begin
    MessageDlg(Msg, mtError, [mbOk], 0);
  end;

{ - End program on selecting Close button }
  procedure TfrmCalcMain.CalcExitMenuItemClick(Sender: TObject);
  begin
    Close;
  end;

{ - Initialize program on form's creation }
  procedure TfrmCalcMain.FormCreate(Sender: TObject);
  begin
    Accumulator := 0; { Zero accumulator }    { -2147483647 - 1; }
    MemAcc := 0; { Zero intermediate accumulator }

    aOperator := opNo; { No operation in effect }
    DecEntry := True; { Assume Decimal radix initially }
    HexEntry := False; { Turn off Hex entry }
    BinEntry := False; { Turn off Binary entry }
    EnableButtons; { Enable buttons depending on radix }
    UpdateDisplay; { Update display result labels }
    end;

    { - Respond to click of a digit button 0 through F }
    procedure TfrmCalcMain.ButtonDigitClick(Sender: TObject);
    begin
      { - Ignore button clicks if accumulators are full }
      if Length(DecString) = maxDecDigits then
        Exit;
      { - Append button tag to end of strings }
      with Sender as TSpeedButton do
      begin
        if DecEntry then
          DecString := trim(DecString) + IntToStr(Tag)
        else if HexEntry then
        begin
          Delete(HexString, 1, 1);
          HexString := trim(HexString) + IntToHex(Tag, 1);
        end
        else if BinEntry then
        begin
          Delete(BinString, 1, 1);
          BinString := trim(BinString) + IntToBin(Tag, 1);
        end;
      end;
      UpdateAccumulator; { Convert entry string to Longint value }
      UpdateDisplay; { Update display result labels }
    end;

    { - Change radix on clicking D, H, or B button }
    procedure TfrmCalcMain.DecHexBinButtonClick(Sender: TObject);
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
    procedure TfrmCalcMain.btnClearEntryClick(Sender: TObject);
    begin
      Accumulator := 0;
      UpdateDisplay;
    end;

    { - Clear current entry and memory (Accumulator and MemAcc) }
    procedure TfrmCalcMain.btnClearClick(Sender: TObject);
    begin
      Accumulator := 0;
      UpdateDisplay;
      SetMemAcc(0);
    end;

    { Delete last digit entered }
    procedure TfrmCalcMain.btnBackClick(Sender: TObject);
    begin
      if DecEntry then
        Delete(DecString, Length(DecString), 1)
      else if HexEntry then
        Delete(HexString, Length(HexString), 1)
      else if BinEntry then
        Delete(BinString, Length(BinString), 1);
      UpdateAccumulator; { Convert entry string to Longint value }
      UpdateDisplay; { Update display result labels }
    end;

    { - Translate keypresses into button clicks }
    procedure TfrmCalcMain.FormKeyPress(Sender: TObject; var Key: Char);
    var
      Button: TButton;
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
        '-':
          btnMinus.Click;
      else
        begin
          Button := TButton(FindComponent('btn' + Key));
          if Button <> nil then
            if Button.Enabled then
              Button.Click;
        end;
      end;
    end;

    { - Respond to click of an operator button (* / + - and or xor) }
    { - Start math operation }
    procedure TfrmCalcMain.OpButtonClick(Sender: TObject);
    begin
      if aOperator <> opNo then
        btnEqualsClick(Sender);
      SetMemAcc(Accumulator);

      aOperator := TEnumOperations(TButton(Sender).Tag);
      Accumulator := 0;
      UpdateDisplay;
      end;

      { - Respond to click of equal button. Complete math operation. }
      procedure TfrmCalcMain.btnEqualsClick(Sender: TObject);
      begin
        try
          case aOperator of
            opMultiply:
              Accumulator := MemAcc * Accumulator;
            opDivide:
              Accumulator := MemAcc div Accumulator;
            opAdd:
              Accumulator := MemAcc + Accumulator;
            opSubtract:
              Accumulator := MemAcc - Accumulator;
            opAnd:
              Accumulator := MemAcc and Accumulator;
            opOr:
              Accumulator := MemAcc or Accumulator;
            opXor:
              Accumulator := MemAcc xor Accumulator;
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
        UpdateDisplay;

        aOperator := opNo;
        SetMemAcc(0);
        end;

        { - Respond to +/- button click }
        procedure TfrmCalcMain.btnNegateClick(Sender: TObject);
        begin
          Accumulator := -Accumulator;
          UpdateDisplay;
        end;

        { - Respond to NOT button click }
        procedure TfrmCalcMain.btnNotClick(Sender: TObject);
        begin
          Accumulator := not Accumulator;
          UpdateDisplay;
        end;

        { - Copy current radix string to clipboard }
        procedure TfrmCalcMain.Copy1Click(Sender: TObject);
        begin
          if DecEntry then
            Clipboard.AsText := DecString
          else if HexEntry then
            Clipboard.AsText := HexString
          else if BinEntry then
            Clipboard.AsText := BinString
        end;

        { - Paste clipboard text to current radix string }
        procedure TfrmCalcMain.Paste1Click(Sender: TObject);
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
            UpdateDisplay;
          end;
        end;

        procedure TfrmCalcMain.About1Click(Sender: TObject);
        begin
          frmCalcAbout.ShowModal;
        end;

end.
