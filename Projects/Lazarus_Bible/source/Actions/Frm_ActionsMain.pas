unit Frm_ActionsMain;

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
  Forms, Dialogs, Menus, ActnList, StdCtrls, Buttons, System.Actions;

type

  { TFrmActionsMain }

  TFrmActionsMain = class(TForm)
    btnDemoQuit: TBitBtn;
    mnuMain: TMainMenu;
    edtEnterQuit: TEdit;
    lblHint: TLabel;
    alsDemoActions: TActionList;
    mniDemo: TMenuItem;
    mniDemoExit: TMenuItem;
    actDemoExit: TAction;
    procedure actDemoExitExecute(Sender: TObject);
    procedure actDemoExitUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmActionsMain: TFrmActionsMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TFrmActionsMain.actDemoExitExecute(Sender: TObject);
begin
  Close;  // Exit program
end;

procedure TFrmActionsMain.actDemoExitUpdate(Sender: TObject);

begin
// Set Flag True if user types Quit into edtEnterQuit
  actDemoExit.Enabled := ( Lowercase(edtEnterQuit.Text) = 'quit');
end;

end.
