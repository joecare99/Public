unit Frm_CLIENT2;

{ DDE2-Client als FPC-Variante: nimmt Texte ueber fcl-simpleipc entgegen
  (SimpleIPCServer1, ServerID 'dde2') und zeigt sie im Edit1. Der Server2
  sendet bei jeder Aenderung seinen Edit-Inhalt. Unter Delphi bleibt die
  DDE-Variante erhalten. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 Messages,
 Classes,
 Graphics,
 Controls,

  Forms,
 Dialogs,
 StdCtrls,
 Buttons,
{$IFnDEF FPC}
  Windows,
  DdeMan,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages,
  simpleipc
{$ENDIF};

type
  TClientForm = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
{$IFDEF FPC}
    SimpleIPCServer1: TSimpleIPCServer;
    procedure SimpleIPCServer1Message(Sender: TObject);
{$ELSE}
    DdeClientItem1: TDdeClientItem;
    DdeClientConv1: TDdeClientConv;
    procedure DdeClientItem1Change(Sender: TObject);
{$ENDIF}
    procedure FormCreate(Sender: TObject);
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
  {$IFNDEF FPC}
  if DdeClientConv1.SetLink('SERVER2', 'Server2') then
  begin
    DdeClientItem1.DdeItem := 'DdeServerItem1';
    if DdeClientConv1.ConnectMode = ddeManual then
      DdeClientConv1.OpenLink;
  end;
  {$ENDIF}
end;

{$IFDEF FPC}
{ Der Empfaenger zeigt den zuletzt empfangenen Text. }
procedure TClientForm.SimpleIPCServer1Message(Sender: TObject);
begin
  Edit1.Text := SimpleIPCServer1.StringMessage;
end;
{$ELSE}
procedure TClientForm.DdeClientItem1Change(Sender: TObject);
begin
  Edit1.Text := DdeClientItem1.Text;
end;
{$ENDIF}

end.
