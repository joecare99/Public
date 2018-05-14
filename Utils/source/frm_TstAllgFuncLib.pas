unit frm_TstAllgFuncLib;

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
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Unt_AllgFunkLib;

type
  TForm2 = class(TForm)
    edtInput: TMemo;
    btnRandom2AoB: TButton;
    btnText2AoB: TButton;
    edtTstText: TEdit;
    lblAoB: TLabel;
    edtOutput: TMemo;
    btnShowCRC64: TButton;
    btnShowCRC32: TButton;
    btnCalcCrc64: TButton;
    btnCalcCrc32: TButton;
    edtCrcOut: TEdit;
    btnCalcC64_2: TButton;
    btnSort1: TButton;
    btnDelay1000: TButton;
    procedure btnDelay1000Click(Sender: TObject);
    procedure btnSort1Click(Sender: TObject);
    procedure btnCalcC64_2Click(Sender: TObject);
    procedure btnCalcCrc32Click(Sender: TObject);
    procedure btnCalcCrc64Click(Sender: TObject);
    procedure btnShowCRC32Click(Sender: TObject);
    procedure btnShowCRC64Click(Sender: TObject);
    procedure btnText2AoBClick(Sender: TObject);
    procedure btnRandom2AoBClick(Sender: TObject);
  private
    AoB: TAoB;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TForm2.btnRandom2AoBClick(Sender: TObject);
var
  I: Integer;
begin
  setlength(AoB,208);
  for I := 0 to high(AoB) do
    AoB[i]:=random(256);
  edtInput.Text := aob2string(aOb);
end;

procedure TForm2.btnText2AoBClick(Sender: TObject);
begin
  setlength(aob,length(edtTstText.text));
  move(edtTstText.text[1],aob[0],length(edtTstText.text));
   edtInput.Text := aob2string(aOb);
end;

procedure TForm2.btnShowCRC64Click(Sender: TObject);
var
  I: Integer;
begin
  edtOutput.Clear;
    if (crc64_table_empty) then
      make_crc64_table;
  for I := 0 to high(crc64_table)  do
    begin
      edtOutput.Text := edtOutput.Text +'$'+ inttohex(crc64_table[i],16)+', ';
      if i mod 4 = 3 then
        edtOutput.lines.add('');
    end;

end;

procedure TForm2.btnShowCRC32Click(Sender: TObject);
var
  I: Integer;
begin
  edtOutput.Clear;
    if (crc_table_empty) then
      make_crc_table;
  for I := 0 to 255  do
    begin
      edtOutput.Text := edtOutput.Text +'$'+ inttohex(Get_crc_table(i),8)+', ';
      if i mod 8 = 7 then
        edtOutput.lines.add('');
    end;

end;

procedure TForm2.btnCalcCrc64Click(Sender: TObject);
begin
  edtCrcOut.Text:='$'+ inttohex(crc64(0,paob(@aOb)^),16);
end;

procedure TForm2.btnCalcCrc32Click(Sender: TObject);
begin
  edtCrcOut.Text:='$'+ inttohex(crc32(0,paob(@aOb)^),8);
end;

procedure TForm2.btnCalcC64_2Click(Sender: TObject);
var gr:integer;
    crc:int64;
begin
  gr:=random(high(aob)+1);
  crc:=crc64(0,aob,gr);
  crc:=crc64(crc,aob,1+high(aob)-gr,gr);
  edtOutput.lines.add(inttostr(gr)+#9+'$'+ inttohex(crc,16));
end;

procedure TForm2.btnSort1Click(Sender: TObject);
var v:Variant;
begin
  v:=aob;
  sort_bubblesort(v);
  edtOutput.Text := AoB2String(v);
  edtCrcOut.Text:='$'+ inttohex(crc64(0,taob(v)),16);
end;

procedure TForm2.btnDelay1000Click(Sender: TObject);
begin
  btnDelay1000.Enabled := false;
  delay (1000);
  btnDelay1000.Enabled :=true;
end;

end.
