unit Frm_MemoPadMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, FileUtil,
{$ENDIF}
  SysUtils,  Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    Save2: TMenuItem;
    Exit2: TMenuItem;
    MemoLabel: TLabel;
    Memo1: TMemo;
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject;
      var Action: TCloseAction);
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

procedure TMainForm.Save1Click(Sender: TObject);
begin
  Memo1.Lines.SaveToFile('memos.txt');
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  MessageDlg(
'Memo Pad'#13#10'© 1995,1998 by Tom Swan'#13#10'Version 1.00',
    mtInformation, [mbOk], 0);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
    if FileExists('memos.txt') then Memo1.Lines.LoadFromFile('memos.txt')
    else Memo1.Lines.SaveToFile('memos.txt');
end;

procedure TMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Memo1.Lines.SaveToFile('memos.txt');
end;

end.

