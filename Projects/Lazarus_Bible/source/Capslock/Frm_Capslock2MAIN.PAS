unit Frm_Capslock2MAIN;

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
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ActnList;

type

  { TfrmCapsLock2Main }

  TfrmCapsLock2Main = class(TForm)
    btnClose: TBitBtn;
    lblInfo: TLabel;
    bvlInfo: TBevel;
    pnlStatus: TStatusBar;
    procedure ActionList1Update(AAction: TBasicAction; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var {%H-}Key: Word;
      {%H-}Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateKeyPanel;
  end;

var
  frmCapsLock2Main: TfrmCapsLock2Main;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmCapsLock2Main.UpdateKeyPanel;
const BevelArr:array[0..1]of TStatusPanelBevel=(pbNone ,pbLowered);

begin
  with pnlStatus do
   begin
   pnlStatus.Panels[0].Bevel := BevelArr[GetKeyState(VK_CAPITAL) and 1];
   pnlStatus.Panels[1].Bevel := BevelArr[GetKeyState(VK_NUMLOCK) and 1];
   pnlStatus.Panels[2].Bevel := BevelArr[GetKeyState(VK_SCROLL) and 1];
   pnlStatus.Panels[3].Bevel := BevelArr[GetKeyState(VK_INSERT) and 1];
   pnlStatus.Panels[4].Bevel := BevelArr[GetKeyState(VK_SHIFT) and 1];
   pnlStatus.Panels[5].Bevel := BevelArr[GetKeyState(VK_CONTROL) and 1];
   pnlStatus.Panels[6].Bevel := BevelArr[GetKeyState(VK_MENU) and 1];
   end;
end;

procedure TfrmCapsLock2Main.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateKeyPanel;
end;

procedure TfrmCapsLock2Main.ActionList1Update(AAction: TBasicAction;
  var Handled: Boolean);
begin
   UpdateKeyPanel;
end;

procedure TfrmCapsLock2Main.FormActivate(Sender: TObject);
begin
  UpdateKeyPanel;
end;

end.

