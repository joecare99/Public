unit Frm_CALC;

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
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls, Buttons, ExtCtrls,
  Clipbrd, ActnList, Frm_CalcABOUT,
  ViewModelBase, PropertyChangedEventArgs, Calc32ViewModel, CalculatorModel, FormShot;

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

  { TfrmCalcMain - die View des Calculator-Demos.

    Die View enthaelt keine Rechenlogik mehr: sie leitet die Eingaben an das
    ViewModel weiter und zeigt die Anzeigetexte des ViewModels an. }

  TfrmCalcMain = class(TForm)
    BinBevel: TPanel;
    btnClose: TBitBtn;
    btnEquals: TButton;
    DecBevel: TPanel;
    HexBevel: TPanel;
    MemBevel: TPanel;
    OpBevel: TPanel;
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
    lblOpation: TLabel;
    pnlDisplay: TPanel;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    ActionList1: TActionList;
    procedure CalcExitMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure lblOpationClick(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    FViewModel: TCalc32ViewModel;
    function GetValue: Integer;
    procedure SetValue(AValue: Integer);
    function GetDecString: String;
    function GetHexString: String;
    function GetBinString: String;
    function GetOperation: TEnumOperations;
    { Uebertragt die Anzeigewerte des ViewModels auf die Bedienelemente. }
    procedure ApplyViewModel;
    procedure ViewModelPropertyChanged(Sender: TObject;
      const AArgs: TPropertyChangedEventArgs);
    { - Enable and disable buttons depending on Entry radix }
    procedure EnableButtons;
    { - Display error message }
    procedure ShowError(const Msg: String);
    { Wandelt die Nummer der Operation in die Aufzaehlung des Models. }
    function OperationOf(ATag: Integer): TCalcOperation;
  public
    { Public declarations }
    property Value: Integer read GetValue write SetValue;
    property DecString: String read GetDecString;
    property HexString: String read GetHexString;
    property BinString: String read GetBinString;
    property Operation: TEnumOperations read GetOperation;
    property ViewModel: TCalc32ViewModel read FViewModel;
  end;

var
  frmCalcMain: TfrmCalcMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  OpDisplay: array[TCalcOperation] of string =
    ('><',
     '\/',
     '/\',
     '-',
     '+',
     '/',
     '*',
     ' ');

  asciiEsc = #27; { Ascii escape control code }
  asciiEnter = #13; { Ascii enter control code }
  asciiDel = #8; { Ascii del control code }

{ - Private methods }

procedure TfrmCalcMain.FormCreate(Sender: TObject);
begin
  FViewModel := TCalc32ViewModel.Create;
  FViewModel.OnPropertyChanged := ViewModelPropertyChanged;
  EnableButtons;
  ApplyViewModel;
end;

procedure TfrmCalcMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FViewModel);
end;

procedure TfrmCalcMain.ViewModelPropertyChanged(Sender: TObject;
  const AArgs: TPropertyChangedEventArgs);
begin
  ApplyViewModel;
end;

{ - Uebertragt die Anzeigewerte des ViewModels auf die Bedienelemente. }
procedure TfrmCalcMain.ApplyViewModel;
begin
  if FViewModel = nil then
    Exit;
  lblDecimal.Caption := FViewModel.DecimalText;
  lblHex.Caption := FViewModel.HexText;
  lblBinary.Caption := FViewModel.BinaryText;
  lblMemory.Caption := IntToStr(FViewModel.MemoryText) + ' ';
  lblOpation.Caption := OpDisplay[FViewModel.OperationText];
  if FViewModel.ErrorMessage <> '' then
  begin
    ShowError(FViewModel.ErrorMessage);
    FViewModel.ErrorMessage := '';
  end;
end;

{ - Enable and disable buttons depending on entry radix }
procedure TfrmCalcMain.EnableButtons;
var
  Radix: TCalcRadix;
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
  if FViewModel = nil then
    Radix := radixDecimal
  else
    Radix := FViewModel.Model.Radix;
  if Radix in [radixDecimal, radixHex] then
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
  if Radix = radixHex then
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
  if Radix = radixDecimal then
    DecButton.Down := True
  else if Radix = radixHex then
    HexButton.Down := True
  else
    BinButton.Down := True;
end;

{ - Display error message string }
procedure TfrmCalcMain.ShowError(const Msg: String);
begin
  if IsScreenshotMode then
    Exit;
  MessageDlg(Msg, mtError, [mbOk], 0);
end;

{ - End program on selecting Close button }
procedure TfrmCalcMain.CalcExitMenuItemClick(Sender: TObject);
begin
  Close;
end;

{ - Wandelt die Nummer der Operation in die Aufzaehlung des Models. }
function TfrmCalcMain.OperationOf(ATag: Integer): TCalcOperation;
begin
  case ATag of
    -1: Result := TCalcOperation.opcMultiply;
    -2: Result := TCalcOperation.opcDivide;
    -3: Result := TCalcOperation.opcAdd;
    -4: Result := TCalcOperation.opcSubtract;
    -5: Result := TCalcOperation.opcAnd;
    -6: Result := TCalcOperation.opcOr;
    -7: Result := TCalcOperation.opcXor;
  else
    Result := TCalcOperation.opcNone;
  end;
end;

{ - Respond to click of a digit button 0 through F }
procedure TfrmCalcMain.ButtonDigitClick(Sender: TObject);
begin
  if Sender is TSpeedButton then
    FViewModel.Digit(TSpeedButton(Sender).Tag);
  EnableButtons;
end;

{ - Change radix on clicking D, H, or B button }
procedure TfrmCalcMain.DecHexBinButtonClick(Sender: TObject);
begin
  if Sender = DecButton then
    FViewModel.Radix(radixDecimal)
  else if Sender = HexButton then
    FViewModel.Radix(radixHex)
  else if Sender = BinButton then
    FViewModel.Radix(radixBinary);
  EnableButtons;
end;

{ - Clear current entry (Accumulator) only }
procedure TfrmCalcMain.btnClearEntryClick(Sender: TObject);
begin
  FViewModel.ClearEntry;
end;

{ - Clear current entry and memory (Accumulator and MemAcc) }
procedure TfrmCalcMain.btnClearClick(Sender: TObject);
begin
  FViewModel.ClearAll;
end;

{ Delete last digit entered }
procedure TfrmCalcMain.btnBackClick(Sender: TObject);
begin
  FViewModel.Backspace;
end;

{ - Translate keypresses into button clicks }
procedure TfrmCalcMain.FormKeyPress(Sender: TObject; var Key: Char);
var
  Button: TGraphicControl;
begin
  case Key of
    asciiEsc:
      begin
        btnClearEntryClick(Sender);
        Key := #0;
      end;
    asciiEnter:
      begin
        btnEqualsClick(Sender);
        Key := #0;
      end;
    asciiDel:
      begin
        btnBackClick(Sender);
        Key := #0;
      end;
    '*':
      btnMultiply.Click;
    '/':
      btnDivide.Click;
    '+':
      btnPlus.Click;
    '-':
      if FViewModel.Value = 0 then
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
procedure TfrmCalcMain.OpButtonClick(Sender: TObject);
begin
  if Sender.InheritsFrom(TControl) then
    FViewModel.Operator(OperationOf(TControl(Sender).Tag));
end;

{ - Respond to click of equal button. Complete math operation. }
procedure TfrmCalcMain.btnEqualsClick(Sender: TObject);
begin
  FViewModel.Equals;
end;

{ - Respond to +/- button click }
procedure TfrmCalcMain.btnNegateClick(Sender: TObject);
begin
  FViewModel.Negate;
end;

{ - Respond to NOT button click }
procedure TfrmCalcMain.btnNotClick(Sender: TObject);
begin
  FViewModel.BitwiseNot;
end;

{ - Copy current radix string to clipboard }
procedure TfrmCalcMain.Copy1Click(Sender: TObject);
begin
  Clipboard.AsText := FViewModel.CurrentText;
end;

procedure TfrmCalcMain.lblOpationClick(Sender: TObject);
begin
end;

{ - Paste clipboard text to current radix string }
procedure TfrmCalcMain.Paste1Click(Sender: TObject);
begin
  if Clipboard.HasFormat(cf_Text) then
    FViewModel.SetEntryText(Clipboard.AsText);
end;

procedure TfrmCalcMain.About1Click(Sender: TObject);
begin
  frmCalcAbout.ShowModal;
end;

function TfrmCalcMain.GetValue: Integer;
begin
  Result := FViewModel.Value;
end;

procedure TfrmCalcMain.SetValue(AValue: Integer);
begin
  FViewModel.Model.ClearAll;
  FViewModel.Model.InputDigit(AValue);
  ApplyViewModel;
end;

function TfrmCalcMain.GetDecString: String;
begin
  Result := FViewModel.Model.DecimalText;
end;

function TfrmCalcMain.GetHexString: String;
begin
  Result := FViewModel.Model.HexText;
end;

function TfrmCalcMain.GetBinString: String;
begin
  Result := FViewModel.Model.BinaryText;
end;

function TfrmCalcMain.GetOperation: TEnumOperations;
begin
  { Die Operationen des Models werden auf die Aufzaehlung der aeusseren
    (Delphi-)Schnittstelle abgebildet. }
  case FViewModel.Model.Operator of
    TCalcOperation.opcMultiply: Result := TEnumOperations.opMultiply;
    TCalcOperation.opcDivide: Result := TEnumOperations.opDivide;
    TCalcOperation.opcAdd: Result := TEnumOperations.opAdd;
    TCalcOperation.opcSubtract: Result := TEnumOperations.opSubtract;
    TCalcOperation.opcAnd: Result := TEnumOperations.opAnd;
    TCalcOperation.opcOr: Result := TEnumOperations.opOr;
    TCalcOperation.opcXor: Result := TEnumOperations.opXor;
  else
    Result := TEnumOperations.opNo;
  end;
end;

end.
