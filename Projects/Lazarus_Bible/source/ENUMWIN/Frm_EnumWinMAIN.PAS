unit Frm_EnumWinMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}

{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type

  { TfrmEnumWinMain }

  TfrmEnumWinMain = class(TForm)
    Edit1: TEdit;
    lblInfo: TLabel;
    lbxWindows: TListBox;
    lblWinTitles: TLabel;
    btnClose: TBitBtn;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure lbxWindowsSelectionChange(Sender: TObject; User: boolean);
    procedure lbxWindowsClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnumWinMain: TfrmEnumWinMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses unt_GetWindows;

procedure TfrmEnumWinMain.FormCreate(Sender: TObject);
begin
  lbxWindows.Clear;
  FillWindowlist(lbxWindows.Items);
end;

procedure TfrmEnumWinMain.lbxWindowsClick(Sender: TObject);
begin
  lblInfo.caption:= inttostr(Longint(lbxWindows.Items.Objects[lbxWindows.ItemIndex]));
end;

procedure TfrmEnumWinMain.SpeedButton1Click(Sender: TObject);
var
  lHdl: THandle;
begin
  lHdl := FindWindow(Edit1.Text);
  lblInfo.caption:= inttostr(lHdl);
  if lHdl <> 0 then
    begin
      lblInfo.Caption:=lblInfo.Caption+' Name: '+GetWindowName(lHdl) ;
      ActivateWindow(lHdl);
    end;
end;

procedure TfrmEnumWinMain.lbxWindowsSelectionChange(Sender: TObject;
  User: boolean);
begin
  lblInfo.caption:= inttostr(PtrInt(lbxWindows.Items.Objects[lbxWindows.ItemIndex]));
  lblInfo.Caption:=lblInfo.Caption+' Class: '+GetClassName(PtrInt(lbxWindows.Items.Objects[lbxWindows.ItemIndex])) ;
  ActivateWindow(PtrInt(lbxWindows.Items.Objects[lbxWindows.ItemIndex]));
end;

end.
