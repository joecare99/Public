unit Frm_PaletteMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, Tabs,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, ExtCtrls, StdCtrls, ComCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    First: TPage;
    Second: TPage;
    Third: TPage;
    Fourth: TPage;
    Fifth: TPage;
    {$IFNDEF FPC}
    TabSet1: TTabSet;
    {$ELSE}
    TabSet1: TTabControl;
    {$ENDIF}
    Notebook1: TNotebook;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Bevel1: TBevel;
    procedure TabSet1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
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

procedure TMainForm.TabSet1Click(Sender: TObject);
begin
  with TabSet1 do
  {$IFDEF FPC}
  NoteBook1.PageIndex := TabIndex;
  {$ELSE}
  NoteBook1.ActivePage := Tabs[TabIndex];
  {$ENDIF}
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  with Sender as TSpeedButton do
    Label1.Caption := Caption;
end;

end.
