unit Frm_DingXMain;

{ DingButtonXControl, plattformneutral: Aus dem ActiveX-Control-Demo wird
  ein Demo fuer ein eigenes Steuerelement. Der TDingButton ist eine
  TButton-Ableitung, die beim Klicken piept; der Knopf "Ueber..." zeigt
  den Info-Dialog. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Ctrl_DingButton, Frm_DingAbout;

type
  TMainForm = class(TForm)
    InfoLabel: TLabel;
    DingButton1: TDingButton;
    AboutBtn: TButton;
    procedure AboutBtnClick(Sender: TObject);
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

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  ShowDingButtonXAbout;
end;

end.
