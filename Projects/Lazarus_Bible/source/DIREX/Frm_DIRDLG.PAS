unit Frm_DIRDLG;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, EditBtn,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, FileCtrl, ComCtrls, ShellCtrls;

type

  { TDirDlgForm }

  TDirDlgForm = class(TForm)
  {$IFnDEF FPC}
    DirectoryListBox: TDirectoryListBox;
    DriveComboBox: TDriveComboBox;
    {$ELSE}
    DirectoryListBox: TShelltreeView;
    DriveComboBox: TDirectoryEdit;
    {$ENDIF}
    FilterComboBox: TFilterComboBox;
    FileNameEdit: TEdit;
    FileNameLabel: TLabel;
    DirectoriesLabel: TLabel;
    DirLabel: TLabel;
    ListFilesLabel: TLabel;
    DrivesLabel: TLabel;
    OkBitBtn: TBitBtn;
    CancelBitBtn: TBitBtn;
    StatusBar1: TStatusBar;
    FileListBox: TFileListBox;
    procedure FileListBoxDblClick(Sender: TObject);
    procedure DriveComboBoxChange(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DirDlgForm: TDirDlgForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TDirDlgForm.FileListBoxDblClick(Sender: TObject);
begin
  OkBitBtn.Click;  { Simulate OK button click }
end;

procedure TDirDlgForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  resize:=(Newheight >250) or (Newwidth > 500);
  if Newheight<250 then
     NewHeight := 250;
  if NewWidth<500 then
     NewWidth := 500;

end;

procedure TDirDlgForm.DriveComboBoxChange(Sender: TObject);
begin
  {$IFDEF FPC}
  DirectoryListBox.Path := DriveComboBox.Text;
  FileListBox.Drive := DriveComboBox.text[1];
  FileListBox.Directory := DirectoryListBox.Path;
  {$ELSE}
  DirectoryListBox.Drive := DriveComboBox.Text[1];
  FileListBox.Drive := DriveComboBox.Drive;
  FileListBox.Directory := DirectoryListBox.Directory;
  {$ENDIF}
end;

end.
