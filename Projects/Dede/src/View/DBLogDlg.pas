unit DBLogDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB;

type
  TLoginDialog = class(TForm)
    Panel: TPanel;
    Bevel: TBevel;
    DatabaseName: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Password: TEdit;
    UserName: TEdit;
    procedure FormShow(Sender: TObject);
  end;

function LoginDialog(const ADatabaseName: string; var AUserName,
  APassword: string): Boolean;
function LoginDialogEx(const ADatabaseName: string; var AUserName,
  APassword: string; NameReadOnly: Boolean): Boolean;
function RemoteLoginDialog(var AUserName, APassword: string): Boolean;
procedure SetCursorType(const CurIndex: Integer);

implementation

{$R *.dfm}

uses
  VDBConsts;

function ShowLogin(const ADatabaseName: string; var AUserName,
  APassword: string; NameReadOnly, Remote: Boolean): Boolean;
var
  Dialog: TLoginDialog;
begin
  Dialog := TLoginDialog.Create(Application);
  try
    Dialog.DatabaseName.Caption := ADatabaseName;
    Dialog.UserName.Text := AUserName;
    Dialog.UserName.Enabled := not NameReadOnly;
    if Remote then
    begin
      Dialog.Caption := SRemoteLogin;
      Dialog.Bevel.Visible := False;
      Dialog.DatabaseName.Visible := False;
      Dialog.Label3.Visible := False;
      Dialog.Panel.Height := Dialog.Panel.Height - Dialog.Bevel.Height;
      Dialog.OKButton.Top := Dialog.OKButton.Top - Dialog.Bevel.Height;
      Dialog.CancelButton.Top := Dialog.CancelButton.Top - Dialog.Bevel.Height;
      Dialog.Height := Dialog.Height - Dialog.Bevel.Height;
    end;
    if AUserName = '' then
      Dialog.ActiveControl := Dialog.UserName;

    Result := Dialog.ShowModal = mrOk;
    if Result then
    begin
      AUserName := Dialog.UserName.Text;
      APassword := Dialog.Password.Text;
    end;
  finally
    Dialog.Free;
  end;
end;

function LoginDialog(const ADatabaseName: string; var AUserName,
  APassword: string): Boolean;
begin
  Result := ShowLogin(ADatabaseName, AUserName, APassword, False, False);
end;

function LoginDialogEx(const ADatabaseName: string; var AUserName,
  APassword: string; NameReadOnly: Boolean): Boolean;
begin
  Result := ShowLogin(ADatabaseName, AUserName, APassword, NameReadOnly, False);
end;

function RemoteLoginDialog(var AUserName, APassword: string): Boolean;
begin
  Result := ShowLogin('', AUserName, APassword, False, True);
end;

procedure TLoginDialog.FormShow(Sender: TObject);
begin
  if Panel.ClientWidth <= DatabaseName.Left + DatabaseName.Width then
    DatabaseName.Width := Panel.ClientWidth - DatabaseName.Left - 5;
end;

procedure SetCursorType(const CurIndex: Integer);
begin
  Screen.Cursor := CurIndex;
end;

initialization
  LoginDialogProc := LoginDialog;
  LoginDialogExProc := LoginDialogEx;
  RemoteLoginDialogProc := RemoteLoginDialog;
  ScreenCursorProc := SetCursorType;

end.
