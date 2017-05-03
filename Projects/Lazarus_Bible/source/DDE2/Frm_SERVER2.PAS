unit Frm_SERVER2;

interface

uses
  Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DdeMan, Buttons;

type
  TServerForm = class(TForm)
    DdeServerItem1: TDdeServerItem;
    Edit1: TEdit;
    Button1: TButton;
    BitBtn1: TBitBtn;
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

{$R *.DFM}

procedure TServerForm.Edit1Change(Sender: TObject);
begin
  DdeServerItem1.Text := Edit1.Text;
end;

procedure TServerForm.Button1Click(Sender: TObject);
begin
  DdeServerItem1.CopyToClipboard;
end;

end.
