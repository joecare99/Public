unit FrmTestIPCClientMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, simpleipc, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    SimpleIPCClient1: TSimpleIPCClient;
    procedure BitBtn1Click(Sender: TObject);
  private
    SimpleIPCServer1: TSimpleIPCServer;
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  SimpleIPCClient1.SendStringMessage('Hello');
  SimpleIPCClient1.SendStringMessage(2,'Client'+inttostr(HINSTANCE));
end;

end.

