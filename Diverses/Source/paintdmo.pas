unit Paintdmo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  WinProcs, WinTypes,
{$ELSE}
   LCLIntf,LCLType,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    btnOK: TBitBtn;
    Timer1: TTimer;
    btnUp: TButton;
    btnDown: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
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
var K,dK,DM:array[0..4] of integer;

procedure TForm1.btnOKClick(Sender: TObject);
begin
   close
end;

procedure TForm1.FormClick(Sender: TObject);
begin
   {$IFDEF FPC}
   messagedlg('Hello','test',mtInformation,[mbOK],0)
   {$ELSE}
   messagebox(0,'Hello','test',MB_Taskmodal)
   {$ENDIF}
end;

procedure TForm1.btnUpClick(Sender: TObject);
  var i:integer;
begin
  dm[0]:= 1023;
  dm[1]:= form1.width;
  dm[2]:= form1.height;
  dm[3]:= form1.width;
  dm[4]:= form1.height;
  for i := 0 to 4 do
    begin
      k[i]:=random(dm[i]);
      dk[i]:=random(11)-5
    end;
end;

procedure moveit  ;
var i:integer;
begin
   for i := 0 to 4 do
     begin
       if k[i]+dk[i] > dm[i] then
         begin
           k[i]:=dm[i]*2-k[i];
           dk[i]:=-dk[i];
           dk[((i-1) xor 1)+1]:=random(11)-5
         end;
       if k[i]+dk[i] < 0 then
         begin
           k[i]:=-k[i]     ;
           dk[i]:=-dk[i];
           dk[((i-1) xor 1)+1]:=random(11)-5
         end;
       k[i]:=k[i]+dk[i]
     end;
   if (abs(k[1]-k[3])<3) or (abs(k[2]-k[4])<3)then
  for i := 1 to 4 do
    begin
       {k[i]:=random(dm[i]);}
      dk[i]:=random(11)-5
    end;
end;

function colcirc(col:integer):byte  ;
var cc:integer  ;

begin
   cc:=(col mod 512)  ;
   colcirc:=abs(255-cc)
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 {  form1.canvas.pen.color := $ffffff;
   form1.canvas.Ellipse(k[1],k[2],k[3],k[4]);}
   moveit  ;
   form1.canvas.pen.color := {$IFDEF FPC} RGBToColor {$ELSE} rgb {$ENDIF}(colcirc(k[0]),colcirc(k[0]+171),colcirc(k[0]+342)) ;
  form1.canvas.Ellipse(k[1],k[2],k[3],k[4])
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   btnUp.Top := Form1.Height -70 ;
   btnDown.Top := Form1.Height -70;
   btnOK.Top := Form1.Height -70;
   btnOK.left := Form1.Width -100;
   dm[0]:=1023   ;
   dk[0]:=1       ;
  dm[1]:= form1.width-2;
  dm[2]:= form1.height-78;
  dm[3]:= form1.width-2;
  dm[4]:= form1.height-78;

end;

end.
