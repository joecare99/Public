unit Frm_CLIENT2;

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

  { TClientForm }

  TClientForm = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    SimpleIPCClient1: TSimpleIPCClient;
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure DdeClientItem1Change(Sender: TObject);
    procedure DdeClientConv1Open(Sender: TObject);
    procedure DdeClientConv1Close(Sender: TObject);
  private
    FOpen: Boolean;
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

end;

procedure TClientForm.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
    begin
      if not SimpleIPCClient1.Active then
        SimpleIPCClient1.Connect;
      SimpleIPCClient1.SendStringMessage(Edit1.text);
      key := #0
    end;
end;

procedure TClientForm.DdeClientConv1Close(Sender: TObject);
begin
  FOpen := false;
end;

procedure TClientForm.DdeClientConv1Open(Sender: TObject);
begin
  FOpen := true;
end;

procedure TClientForm.DdeClientItem1Change(Sender: TObject);
begin

end;

end.
