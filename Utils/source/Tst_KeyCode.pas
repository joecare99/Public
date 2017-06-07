unit Tst_KeyCode;

interface

{$i jedi.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
//    procedure FormCreate(Sender: TObject);
    procedure WMGetDlgCode(var Message:TMessage); message wm_getdlgCode;
    procedure WMKeyDown(var Message:TWMKeyDown); message wm_KeyDown;
    procedure WMKeyUp(var Message:TWMKeyUP); message wm_KeyUp;
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

type TShifts =
{$ifdef Compiler14_up}
  (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble, ssTouch, ssPen, ssCommand);
{$else ~Compiler14_up}
  (ssShift, ssAlt, ssCtrl,ssLeft, ssRight, ssMiddle, ssDouble);
{$endif ~Compiler14_up}
     TTShiftstate = set of TShifts;

function ShiftState2Str(shift:TShiftState):string;

var tt :TShifts;
    ss :string;
    sststs:TTShiftstate;
begin
  ss:= '';
  move(shift,sststs,sizeof(shift));
  for tt :=  low(Tshifts) to high(Tshifts) do
    if tt in sststs then
      ss:=ss+'1' else  ss:=ss+'0';
  ShiftState2Str:= ss;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   label1.Caption := inttostr(key);
   label4.Caption := ShiftState2Str (shift);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   label2.Caption := inttostr(key);
   label4.Caption := ShiftState2Str (shift);
end;

procedure TForm1.WMKeyDown;

begin
   label1.Caption := inttostr(message.charcode);
   label3.Caption := inttostr(message.keydata);
   Panel1.Color := Panel1.color xor $ff0000;
end;

procedure TForm1.WMKeyUp;

begin
   label2.Caption := inttostr(message.charcode);
   label3.Caption := inttostr(message.keydata);
   Panel1 .Color := Panel1.color xor $00ff00;
end;

procedure TForm1.WMGetDlgCode;

begin
  message.Result := DLGC_WANTALLKEYS ;
end;

end.
