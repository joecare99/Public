unit frmVarScope;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Edit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  name:String;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Edit1Change(Sender: TObject);
begin
  frmVarScope.name := edit1.text;
  edit2.text := frmVarScope.name;
end;

end.

