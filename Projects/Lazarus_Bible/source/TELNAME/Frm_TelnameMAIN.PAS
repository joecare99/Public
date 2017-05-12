unit Frm_TelnameMAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Mask;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    CloseBitBtn: TBitBtn;
    NamesBitBtn: TBitBtn;
    NumberBitBtn: TBitBtn;
    NameEdit: TEdit;
    NumbEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure NumberBitBtnClick(Sender: TObject);
    procedure NamesBitBtnClick(Sender: TObject);
    procedure NumbEditKeyPress(Sender: TObject; var Key: Char);
    procedure NameEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function TelNameToNum(TelName: String): String;
    procedure ListNames(TelNum: String);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

var
{ Array of telephone dialog letters }
  TelDial: array[0 .. 9] of String;

{ Return telephone digit that corresponds to C }
function DigitToLetter(C: Char): Char;
var
  I, J: Integer;
begin
  C := Upcase(C);
  for I := 0 to 9 do
    for J := 1 to 3 do
      if (C = TelDial[I][J]) then
      begin
        Result := Chr(I + Ord('0'));
        Exit;
      end;
  Result := C;  { Default }
end;

{ Return ordinal value of digit character C }
function ValueOfChar(C: Char): Integer;
begin
  Result := Ord(C) - Ord('0');
end;

{ Return number for a telephone alphabetic name }
function TMainForm.TelNameToNum(TelName: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(TelName) do
    Result := Result + DigitToLetter(TelName[I]);
end;

procedure TMainForm.ListNames(TelNum: String);
var
  S: String;  { Temporary string }

  { Find N alphabetic permutations of digits in TelNum }
  procedure Permute(N: Integer);
  var
    I, Digit: Integer;
  begin
    Digit := ValueOfChar(TelNum[N]);
    for I := 1 to 3 do
    begin
      S[N] := TelDial[Digit][I];  { Insert letter }
      if (N = Length(TelNum)) then
        ListBox1.Items.Add(S)     { Add string to ListBox }
      else
        Permute(N + 1);  { Call Permute recursively }
    end;
  end; { Permute }

begin
  if Length(TelNum) > 0 then
  begin
    S := TelNum;    { Assign to temporary string }
    Permute(1);     { Start permutations }
  end;
end;

{ Initialize global variables }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  TelDial[0] := '   ';  TelDial[1] := '   ';
  TelDial[2] := 'ABC';  TelDial[3] := 'DEF';
  TelDial[4] := 'GHI';  TelDial[5] := 'JKL';
  TelDial[6] := 'MNO';  TelDial[7] := 'PRS';
  TelDial[8] := 'TUV';  TelDial[9] := 'WXY';
end;

{ Do Number button click }
procedure TMainForm.NumberBitBtnClick(Sender: TObject);
begin
  NumbEdit.Text := TelNameToNum(NameEdit.Text);
  NumbEdit.SetFocus;
end;

{ Do Names button click }
procedure TMainForm.NamesBitBtnClick(Sender: TObject);
begin
  ListBox1.Clear;
  ListNames(NumbEdit.Text);
  ListBox1.SetFocus;
end;

{ Click Names button for Enter key in Number Edit object }
procedure TMainForm.NumbEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    NamesBitBtn.Click;
    Key := #0;
  end;
end;

{ Click Number button for Enter key in Name Edit object }
procedure TMainForm.NameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    NumberBitBtn.Click;
    Key := #0;
  end;
end;

end.
