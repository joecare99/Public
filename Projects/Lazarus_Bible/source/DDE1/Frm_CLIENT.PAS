unit Frm_CLIENT;

{ DDE1-Client als FPC-Variante: schickt Text an den Server1
  (SimpleIPCClient, ServerID 'ddeserver1'). Im Eingabefeld
  Enter druecken. }

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
  Messages, Classes, simpleipc, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TClientForm = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    SimpleIPCClient1: TSimpleIPCClient;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TClientForm.FormCreate(Sender: TObject);
begin
  { Beim ersten Send wird automatisch verbunden. }
end;

procedure TClientForm.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    if not SimpleIPCClient1.Active then
      SimpleIPCClient1.Connect;
    SimpleIPCClient1.SendStringMessage(Edit1.Text);
    Key := #0;
  end;
end;

end.
