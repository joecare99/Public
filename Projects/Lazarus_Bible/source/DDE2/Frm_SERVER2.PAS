unit Frm_SERVER2;

{ DDE2-Server als FPC-Variante: Statt DdeServerItem (Windows-only) sendet
  das Formular Aenderungen des Edit1 ueber fcl-simpleipc an den Client2
  (SimpleIPCClient1, ServerID 'dde2'). Der Client2 nimmt die Texte entgegen
  und zeigt sie an. Unter Delphi bleibt die DDE-Variante erhalten. }

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
 Clipbrd,
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
  TServerForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    BitBtn1: TBitBtn;
{$IFDEF FPC}
    SimpleIPCClient1: TSimpleIPCClient;
{$ELSE}
    DdeServerItem1: TDdeServerItem;
{$ENDIF}
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

procedure TServerForm.FormCreate(Sender: TObject);
begin
  {$IFDEF FPC}
  try
    SimpleIPCClient1.Connect;
  except
    { Der Empfaenger (Client2) laeuft noch nicht - beim Tippen erneut. }
  end;
  {$ENDIF}
end;

{ Aenderung im Edit sendet den Text an den Empfaenger. }
procedure TServerForm.Edit1Change(Sender: TObject);
begin
  {$IFDEF FPC}
  try
    if not SimpleIPCClient1.Active then
      SimpleIPCClient1.Connect;
    SimpleIPCClient1.SendStringMessage(Edit1.Text);
  except
    { Empfaenger nicht erreichbar - der Text geht verloren. }
  end;
  {$ELSE}
  DdeServerItem1.Text := Edit1.Text;
  {$ENDIF}
end;

procedure TServerForm.Button1Click(Sender: TObject);
begin
  {$IFDEF FPC}
  Clipboard.AsText := Edit1.Text;
  {$ELSE}
  DdeServerItem1.CopyToClipboard;
  {$ENDIF}
end;

end.
