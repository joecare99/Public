unit Frm_MultiFileMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Fra_CloseButtons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Frame1_1: TfraCloseButtons;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses Frm_File2,Frm_File3;
{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin
  frmDialog3.show;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  frmDialog2.show;
end;

end.

