unit frmRenameForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TMyWindow }

  TMyWindow = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MyWindow: TMyWindow;

implementation

{$R *.lfm}

{ TMyWindow }

procedure TMyWindow.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

