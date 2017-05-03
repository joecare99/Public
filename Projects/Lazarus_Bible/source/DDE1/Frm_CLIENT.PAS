unit Frm_CLIENT;

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
  Forms, Dialogs, StdCtrls, Buttons;

type
  TClientForm = class(TForm)
    DdeClientItem1: TDdeClientItem;
    DdeClientConv1: TDdeClientConv;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
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
  DdeClientItem1.DdeItem := 'DdeServerItem1';
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
  Edit1.Text := DdeClientItem1.Text;
end;

end.
