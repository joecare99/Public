unit frm_TestThreadMain;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmTestThread }

  TfrmTestThread = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
      aThread: TThread;
  public
     Procedure UpdateLabel(sender:TObject);
  end;

var
  frmTestThread: TfrmTestThread;

implementation

{$R *.lfm}

type

{ TTestThread }

 TTestThread=Class(TThread)
     procedure Execute; override;
   private
     procedure UpdateLabel;
  end;

{ TfrmTestThread }

procedure TestProc;
var
  lThread: TThread;
begin
  lThread:=frmTestThread.aThread;
  while not lThread.CheckTerminated do
  with frmTestThread.Label1 do begin
    Tag:=Tag + 1;
    Caption:=inttostr(Tag);
    sleep (1);
  end;
end;

{ TTestThread }

procedure TTestThread.Execute;
begin
  while not CheckTerminated do
  with frmTestThread.Label1 do begin
    Tag:=Tag + 1;
    if tag and $3fffff =0 then
      Synchronize(UpdateLabel);

//    sleep (1);
  end;
end;

procedure TTestThread.UpdateLabel;
begin
  frmTestThread.UpdateLabel(self);
end;

procedure TfrmTestThread.Button2Click(Sender: TObject);


begin
   if not assigned(aThread) then
     begin
   aThread:= TThread.CreateAnonymousThread(TestProc);
   aThread.Suspended:=false;
   aThread.FreeOnTerminate:=false;
     end
   else
     begin
       freeandnil(aThread);
     end;
end;

procedure TfrmTestThread.Button1Click(Sender: TObject);
begin
   if not assigned(aThread) then
     begin
  aThread:= TTestThread.Create(false);
  aThread.FreeOnTerminate:=false;
     end
   else
     freeandnil(aThread);
end;

procedure TfrmTestThread.FormDestroy(Sender: TObject);
begin
  freeandnil(aThread);
end;

procedure TfrmTestThread.UpdateLabel(sender: TObject);
begin
  label1.Caption:=inttostr(label1.Tag);
end;

end.

