unit frm_ConnectDB;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Buttons, ExtCtrls;

type

  { TfrmConnectDb }

  TfrmConnectDb = class(TForm)
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    edtHostName: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtUser: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure OkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure SetData(Server, Username, Password: string);
    procedure GetData(out Server, USername, Password: string);
  end;

var
  frmConnectDb: TfrmConnectDb;

implementation

uses
  dm_GenData, cls_Translation;

{$R *.lfm}

{ TfrmConnectDb }

procedure TfrmConnectDb.FormShow(Sender: TObject);

begin

end;

procedure TfrmConnectDb.OkClick(Sender: TObject);

begin
  ModalResult:=mrOK;
end;

procedure TfrmConnectDb.SetData(Server, Username, Password: string);
begin
  edtHostName.Text := Server;
  edtUser.Text := Username;
  edtPassword.Text := Password;
end;

procedure TfrmConnectDb.GetData(out Server, USername, Password: string);
begin
  Server := edtHostName.Text;
  Username := edtUser.Text;
  Password := edtPassword.Text;
end;



end.

