unit frm_CooldemoMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  XPMan, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, StdCtrls, Buttons, ImgList, System.ImageList;

type
  TMainForm = class(TForm)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    NavigatorImages: TImageList;
    NavigatorHotImages: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    {$IFNDEF FPC}
    Animate1: TAnimate;
    DateTimePicker1: TDateTimePicker;
    XPManifest1: TXPManifest;
    {$ENDIF}
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TMainForm.BitBtn1Click(Sender: TObject);
var
  TF: Boolean;  // True or False flag
  S: String;
begin
  TF := ToolButton1.Enabled;
  ToolButton1.Enabled := not TF;
  ToolButton2.Enabled := not TF;
  if TF
    then S := 'Enable'
    else S := 'Disable';
  BitBtn1.Caption := S + ' Back and Forward Buttons';
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  {$IFNDEF FPC}
  Animate1.Active := not Animate1.Active;
  if Animate1.Active
    then Button1.Caption := 'Stop Animation'
    else Button1.Caption := 'Begin Animation';
  {$ENDIF}
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  {$IFNDEF FPC}
  Animate1.Active :=true;
  {$ENDIF}
end;

procedure TMainForm.ToolButton1Click(Sender: TObject);
begin
  with Sender as TToolButton do
    ShowMessage('Button selected: ' + Caption);
end;

end.
