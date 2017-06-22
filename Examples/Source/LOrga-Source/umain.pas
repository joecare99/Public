unit umain;

{$mode objfpc}{$H+}
// /usr/lib/gcc/x86_64-pc-linux-gnu/7.1.1/
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Spin, ExtCtrls, ucaldata;

type

  { TFmain }

  TFmain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    SpinEdit1: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Fmain: TFmain;
//  Fcaldata : TFcaldata;
implementation

{$R *.lfm}

{ TFmain }

procedure TFmain.FormClose(Sender: TObject; var CloseAction: TCloseAction);

begin
  Fcaldata.SaveFile();
end;

procedure TFmain.Button1Click(Sender: TObject);
begin
  Fcaldata.AddEventData(Date());
end;

procedure TFmain.Button2Click(Sender: TObject);
var
  item: Integer;
begin
  item:=Fcaldata.CountEvents;
  If item>0 then
    Fcaldata.EditEventData(SpinEdit1.Value);
end;

end.

