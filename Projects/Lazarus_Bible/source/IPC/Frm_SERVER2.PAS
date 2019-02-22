unit Frm_SERVER2;

interface

uses
  Windows, Messages, Classes, simpleipc, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type

  { TServerForm }

  TServerForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    BitBtn1: TBitBtn;
    SimpleIPCServer1: TSimpleIPCServer;
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SimpleIPCServer1Message(Sender: TObject);
    procedure SimpleIPCServer1MessageQueued(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerForm: TServerForm;

implementation

{$IFDEF FPC}
{$R *.LFM}
{$ELSE}
{$R *.DFM}
{$ENDIF}

procedure TServerForm.Edit1Change(Sender: TObject);
begin
//  DdeServerItem1.Text := Edit1.Text;
end;

procedure TServerForm.Button1Click(Sender: TObject);
begin
//  DdeServerItem1.CopyToClipboard;
end;

procedure TServerForm.SimpleIPCServer1Message(Sender: TObject);
begin
   edit1.Text:= SimpleIPCServer1.StringMessage;
end;

procedure TServerForm.SimpleIPCServer1MessageQueued(Sender: TObject);
begin
  edit1.Text:= 'q:';
end;

end.
