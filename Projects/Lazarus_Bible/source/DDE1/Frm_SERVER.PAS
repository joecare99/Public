unit Frm_SERVER;

{ DDE1-Server als FPC-Variante: Statt DdeServerItem (Windows-only)
  nimmt das Formular Texte ueber fcl-simpleipc entgegen
  (SimpleIPCServer1, ServerID 'ddeserver1'). Der Client (Client1.dpr)
  schickt Text, das Formular zeigt ihn im Edit1. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  DdeMan, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, simpleipc, Buttons;

type
  TServerForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    BitBtn1: TBitBtn;
    SimpleIPCServer1: TSimpleIPCServer;
    procedure Edit1Change(Sender: TObject);
    procedure SimpleIPCServer1Message(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerForm: TServerForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TServerForm.Edit1Change(Sender: TObject);
begin
  { Leerer Editor - Text ueber die IPC-Queue. }
end;

procedure TServerForm.Button1Click(Sender: TObject);
begin
  { Koert zeigt Status: ServerID. }
  Edit1.Text := 'Ws:\' + SimpleIPCServer1.ServerID;
end;

procedure TServerForm.SimpleIPCServer1Message(Sender: TObject);
begin
  Edit1.Text := SimpleIPCServer1.StringMessage;
end;

end.
