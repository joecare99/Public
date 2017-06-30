unit frm_IPCServerMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, simpleipc, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    SimpleIPCServer1: TSimpleIPCServer;
    procedure SimpleIPCServer1Message(Sender: TObject);
  private
    { private declarations }
    Procedure LogEvent(Sender:TObject); overload;
    Procedure LogEvent(Sender:TObject;ID:LongInt;Msg:String);overload;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SimpleIPCServer1Message(Sender: TObject);
begin
  LogEvent(Sender,SimpleIPCServer1.MsgType,SimpleIPCServer1.StringMessage);

end;

procedure TForm1.LogEvent(Sender: TObject);
begin
  LogEvent(sender,0,'');
end;

procedure TForm1.LogEvent(Sender: TObject; ID: LongInt; Msg: String);
begin
  Memo1.Append(TimeToStr(time)+': '+sender.ClassName+'; '+inttostr(ID)+'; '+Msg);
  if Memo1.Lines.Count > 1000 then
    memo1.Lines.Delete(0);
end;

end.

