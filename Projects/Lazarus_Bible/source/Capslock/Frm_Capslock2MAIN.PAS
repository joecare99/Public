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
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TMainForm = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Bevel1: TBevel;
    StatusBar1: TStatusBar;
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
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.UpdateKeyPanel;
const BevelArr:array[0..1]of TStatusPanelBevel=(pbRaised ,pbLowered);
begin
   StatusBar1.Panels[0].Bevel := BevelArr[GetKeyState(VK_CAPITAL) and 1];
   StatusBar1.Panels[1].Bevel := BevelArr[GetKeyState(VK_NUMLOCK) and 1];
   StatusBar1.Panels[2].Bevel := BevelArr[GetKeyState(VK_SCROLL) and 1];
   StatusBar1.Panels[3].Bevel := BevelArr[GetKeyState(VK_INSERT) and 1];
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

