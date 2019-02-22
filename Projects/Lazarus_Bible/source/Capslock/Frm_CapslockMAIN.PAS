unit Frm_CapslockMAIN;

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
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

type

  { TfrmCapsLockMain }

  TfrmCapsLockMain = class(TForm)
    btnClose: TBitBtn;
    lblInfo: TLabel;
    bvlInfo: TBevel;
    Pnl_Shft: TPanel;
    Pnl_Ctrl: TPanel;
    Pnl_Alt: TPanel;
    pnlStatus: TPanel;
    pnl_Num: TPanel;
    pnl_Caps: TPanel;
    pnl_Scrl: TPanel;
    Pnl_Ins: TPanel;
    procedure FormKeyDown(Sender: TObject; var {%H-}Key: Word;
      {%H-}Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    procedure SetPanel(p: TPanel);
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateKeyPanel;
  end;

var
  frmCapsLockMain: TfrmCapsLockMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmCapsLockMain.UpdateKeyPanel;
begin
  pnl_Caps.Enabled :=
    GetKeyState(VK_CAPITAL) and 1 = 1;
  pnl_Num.Enabled :=
    GetKeyState(VK_NUMLOCK) and 1 = 1;
  pnl_Scrl.Enabled :=
    GetKeyState(VK_SCROLL)  and 1 = 1;
  Pnl_Ins.Enabled :=
    GetKeyState(VK_INSERT)  and 1 = 1;
  Pnl_Shft.Enabled :=
    GetKeyState(VK_SHIFT)  and 1 = 1;
  Pnl_Ctrl.Enabled :=
    GetKeyState(VK_CONTROL)  and 1 = 1;
  Pnl_Alt.Enabled :=
    GetKeyState(VK_MENU)  and 1 = 1;
  SetPanel(pnl_Caps);
  SetPanel(pnl_Num);
  SetPanel(pnl_Scrl);
  SetPanel(Pnl_Ins);
  SetPanel(Pnl_Shft);
  SetPanel(Pnl_Ctrl);
  SetPanel(Pnl_Alt);
end;

procedure TfrmCapsLockMain.SetPanel(p: TPanel);
begin
  with p do
    if Enabled then
    begin
      font.Color := clWindowText;
      font.Style := [fsbold];
      color := clCream;
      BevelOuter := bvLowered;
    end
    else
    begin
      font.Color := clDkGray;
      font.Style := [fsItalic];
      color := clBtnface;
      BevelOuter := bvNone;
    end;
end;

procedure TfrmCapsLockMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateKeyPanel;
end;

procedure TfrmCapsLockMain.FormActivate(Sender: TObject);
begin
  UpdateKeyPanel;
end;

end.

