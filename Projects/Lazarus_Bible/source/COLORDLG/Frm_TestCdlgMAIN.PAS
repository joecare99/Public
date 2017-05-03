unit Frm_TestCdlgMAIN;

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
  Forms, Dialogs, COLORDLG, Buttons;

type
  TMainForm = class(TForm)
    CloseBitBtn: TBitBtn;
    TestBitBtn: TBitBtn;
    procedure TestBitBtnClick(Sender: TObject);
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

procedure TMainForm.TestBitBtnClick(Sender: TObject);
begin
  with ColorDlgForm do
  if ShowModal = mrOk then
    ShowMessage(Format('Color value = $%-.6x', [ColorResult]));
end;

end.
