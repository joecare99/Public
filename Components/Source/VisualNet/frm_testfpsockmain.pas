unit frm_TestFpSockMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, fpSock;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
    FTCPClient:TTCPClient;
  public
    procedure TCPClient_OnConnectionStateChange(
      Sender: TClientConnectionSocket; OldState, NewState: TConnectionState);
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  FTCPClient.Host:=Edit1.text;
  FTCPClient.Port:=inttostr(edit2.text);
  FTCPClient.OnConnectionStateChange:=@TCPClient_OnConnectionStateChange;
  FTCPClient.Active:=true;
end;

procedure TForm1.TCPClient_OnConnectionStateChange(
  Sender: TClientConnectionSocket; OldState, NewState: TConnectionState);
begin
  if NewState=connConnected then

end;

end.

