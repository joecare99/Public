unit Frm_DirExMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Frm_DIRDLG, FileCtrl ;

type
  TMainForm = class(TForm)
    TestBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    btnTest2: TBitBtn;
    btnTest3: TBitBtn;
    btnTest4: TBitBtn;
    OpenDialog1: TOpenDialog;
    procedure btnTest2Click(Sender: TObject);
    procedure TestBitBtnClick(Sender: TObject);
    procedure btnTest3Click(Sender: TObject);
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

procedure TMainForm.btnTest2Click(Sender: TObject);
var
  dr: string;
begin
  GetDir(0,dr{%H-});
  if SelectDirectory(dr,[sdPrompt],0)  then
    ShowMessage('Selected Folder = ' + dr);
end;

procedure TMainForm.btnTest3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      ShowMessage('Selected file = ' + OpenDialog1.FileName);
    end;
end;

procedure TMainForm.TestBitBtnClick(Sender: TObject);
begin
  with DirDlgForm do
  if ShowModal = mrOk then
    ShowMessage('Selected file = ' + FileNameEdit.Text);
end;

end.
