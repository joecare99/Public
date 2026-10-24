unit DBPWDlg;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, DB;

type
  TPasswordDialog = class(TForm)
    GroupBox1: TGroupBox;
    Edit: TEdit;
    AddButton: TButton;
    RemoveButton: TButton;
    RemoveAllButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    procedure EditChange(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure RemoveAllButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  public
    PasswordAdded: Boolean;
    FSession: IDBSession;
  end;

function PasswordDialog(const ASession: IDBSession): Boolean;

implementation

{$R *.dfm}

function PasswordDialog(const ASession: IDBSession): Boolean;
var
  Dialog: TPasswordDialog;
begin
  Dialog := TPasswordDialog.Create(Application);
  try
    Dialog.FSession := ASession;
    Result := Dialog.ShowModal = mrOk;
  finally
    Dialog.Free;
  end;
end;

procedure TPasswordDialog.EditChange(Sender: TObject);
var
  HasPassword: Boolean;
begin
  HasPassword := Edit.Text <> '';
  AddButton.Enabled := HasPassword;
  RemoveButton.Enabled := HasPassword;
  OKButton.Enabled := HasPassword or PasswordAdded;
end;

procedure TPasswordDialog.AddButtonClick(Sender: TObject);
begin
  FSession.AddPassword(Edit.Text);
  PasswordAdded := True;
  Edit.SelectAll;
  Edit.SetFocus;
end;

procedure TPasswordDialog.RemoveButtonClick(Sender: TObject);
begin
  FSession.RemovePassword(Edit.Text);
  Edit.SelectAll;
  Edit.SetFocus;
end;

procedure TPasswordDialog.RemoveAllButtonClick(Sender: TObject);
begin
  FSession.RemoveAllPasswords;
  Edit.SelectAll;
end;

procedure TPasswordDialog.OKButtonClick(Sender: TObject);
begin
  FSession.AddPassword(Edit.Text);
end;

initialization
  DB.PasswordDialog := PasswordDialog;

end.
