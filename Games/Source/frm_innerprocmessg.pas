unit frm_InnerProcMessg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  while not Application.Terminated do
    begin
      if CheckBox1.Checked then
        Application.Terminate;
      Application.ProcessMessages;
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=true;

end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  canvas.Ellipse(0,0,200,200);
end;

end.

