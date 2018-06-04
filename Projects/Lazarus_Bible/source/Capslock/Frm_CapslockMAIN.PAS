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

  { TMainForm }

  TMainForm = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Bevel1: TBevel;
    Pnl_Shft: TPanel;
    Pnl_Ctrl: TPanel;
    Pnl_Alt: TPanel;
    StatusPanel: TPanel;
    Pnl_Num: TPanel;
    Pnl_Caps: TPanel;
    Pnl_Scrl: TPanel;
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
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.UpdateKeyPanel;
begin
  Pnl_Caps.Enabled :=
    GetKeyState(VK_CAPITAL) and 1 = 1;
  Pnl_Num.Enabled :=
    GetKeyState(VK_NUMLOCK) and 1 = 1;
  Pnl_Scrl.Enabled :=
    GetKeyState(VK_SCROLL)  and 1 = 1;
  Pnl_Ins.Enabled :=
    GetKeyState(VK_INSERT)  and 1 = 1;
  Pnl_Shft.Enabled :=
    GetKeyState(VK_SHIFT)  and 1 = 1;
  Pnl_Ctrl.Enabled :=
    GetKeyState(VK_CONTROL)  and 1 = 1;
  Pnl_Alt.Enabled :=
    GetKeyState(VK_MENU)  and 1 = 1;
  SetPanel(Pnl_Caps);
  SetPanel(Pnl_Num);
  SetPanel(Pnl_Scrl);
  SetPanel(Pnl_Ins);
  SetPanel(Pnl_Shft);
  SetPanel(Pnl_Ctrl);
  SetPanel(Pnl_Alt);
end;

procedure TMainForm.SetPanel(p: TPanel);
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

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateKeyPanel;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  UpdateKeyPanel;
end;

end.

