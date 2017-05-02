unit Frm_AboutExMAIN;

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
  SysUtils,  Classes, Graphics, Controls,
  Forms, Dialogs, Frm_ABOUT, StdCtrls;

type
  TfrmAboutMain = class(TForm)
    btnClickMe: TButton;
    procedure btnClickMeClick(Sender: TObject);
     private
    { Private declarations }
     public
    { Public declarations }
  end;

var
  frmAboutMain: TfrmAboutMain;

implementation
{$IFnDEF FPC}
{$R *.dfm}
 {$ELSE}
{$R *.lfm}
{$ENDIF}
procedure TfrmAboutMain.btnClickMeClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

end.
