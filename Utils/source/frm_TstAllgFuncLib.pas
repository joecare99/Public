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
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Memo2: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Edit2: TEdit;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Button9Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

procedure TForm2.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  setlength(AoB,208);
  for I := 0 to high(AoB) do
    AoB[i]:=random(256);
  memo1.Text := aob2string(aOb);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  setlength(aob,length(Edit1.text));
  move(edit1.text[1],aob[0],length(Edit1.text));
   memo1.Text := aob2string(aOb);
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  I: Integer;
begin
  memo2.Clear;
    if (crc64_table_empty) then
      make_crc64_table;
  for I := 0 to high(crc64_table)  do
    begin
      memo2.Text := memo2.Text +'$'+ inttohex(crc64_table[i],16)+', ';
      if i mod 4 = 3 then
        memo2.lines.add('');
    end;

end;

procedure TForm2.Button4Click(Sender: TObject);
var
  I: Integer;
begin
  memo2.Clear;
    if (crc_table_empty) then
      make_crc_table;
  for I := 0 to 255  do
    begin
      memo2.Text := memo2.Text +'$'+ inttohex(Get_crc_table(i),8)+', ';
      if i mod 8 = 7 then
        memo2.lines.add('');
    end;

end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  edit2.Text:='$'+ inttohex(crc64(0,paob(@aOb)^),16);
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  edit2.Text:='$'+ inttohex(crc32(0,paob(@aOb)^),8);
end;

procedure TForm2.Button7Click(Sender: TObject);
var gr:integer;
    crc:int64;
begin
  gr:=random(high(aob)+1);
  crc:=crc64(0,aob,gr);
  crc:=crc64(crc,aob,1+high(aob)-gr,gr);
  memo2.lines.add(inttostr(gr)+#9+'$'+ inttohex(crc,16));
end;

procedure TForm2.Button8Click(Sender: TObject);
var v:Variant;
begin
  v:=aob;
  sort_bubblesort(v);
  memo2.Text := AoB2String(v);
  edit2.Text:='$'+ inttohex(crc64(0,taob(v)),16);
end;

procedure TForm2.Button9Click(Sender: TObject);
begin
  Button9.Enabled := false;
  delay (1000);
  button9.Enabled :=true; 
end;

end.
