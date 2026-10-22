unit frm_NonClientMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    Label1: TLabel;
  private
    { Private declarations }
  public
    procedure WndProc(Var Message: TMessage); override;
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

procedure TMainForm.WndProc(var Message: TMessage);
begin
  with Message do
  case Msg of
    {$IFnDEF FPC}
    wm_NCLButtonDblClk:
      ShowMessage('Nonclient left button click');  // Obsolete!
    wm_NCRButtonDblClk:
      ShowMessage('Nonclient right button click');
    {$ELSE}
    LM_NCLBUTTONDBLCLK:
      ShowMessage('Nonclient left button double click');
    LM_NCHITTEST:
      ;
    LM_NCPAINT:
      ;
    {$ENDIF}
  end;
  inherited WndProc(Message);
end;

end.
 
