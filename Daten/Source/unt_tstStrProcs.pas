unit unt_tstStrProcs;

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
  SysUtils, Classes, Graphics, Controls, Forms,
  Unt_Stringprocs, StdCtrls, Dialogs;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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

procedure TForm1.Button1Click(Sender: TObject);

var tst:string;

begin
  tst := '';
  memo1.text:=inttostr(TryFunctionMatching(edit1.text,edit2.text,tst));
  memo1.lines.add(tst);
end;

end.