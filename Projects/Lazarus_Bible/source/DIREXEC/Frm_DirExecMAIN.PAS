unit Frm_DirExecMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  ShellAPI, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, Frm_DIRDLG;

type
  TMainForm = class(TForm)
    RunBitBtn: TBitBtn;
    BitBtn2: TBitBtn;
    procedure RunBitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

function ExecuteFile(const FileName, Params, Dir: String;
  ShowCmd: Integer): THandle;
begin
  Result :=  {$IFnDEF FPC}
    ShellExecute(Application.MainForm.Handle, nil,
    PChar(FileName), PChar(Params), PChar(Dir), ShowCmd);
  {$ELSE}
   smallint( OpenDocument(PChar(FileName)));{ *Converted from ShellExecute* }
  {$ENDIF}
end;

procedure TMainForm.RunBitBtnClick(Sender: TObject);
begin
  with DirDlgForm do
  if ShowModal = mrOk then
  if ExecuteFile(FileNameEdit.Text, '',
    {$IFDEF FPC} DirectoryListBox.Path {$ELSE} DirectoryListBox.Directory {$ENDIF},SW_SHOW) <= 32 then
    MessageDlg('Unable to open file or program',
      mtError, [mbOk], 0)
  else
    Application.Minimize;
end;

end.
