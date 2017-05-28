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
  Forms, Dialogs, Menus, ActnList, StdCtrls, Buttons;

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
    procedure edtEnterQuitChange(Sender: TObject);
    procedure actDemoExitExecute(Sender: TObject);
    procedure actDemoExitUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblHintClick(Sender: TObject);
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

procedure TFrmActionsMain.edtEnterQuitChange(Sender: TObject);
begin

end;

procedure TFrmActionsMain.actDemoExitUpdate(Sender: TObject);

begin
// Set Flag True if user types Quit into edtEnterQuit
  actDemoExit.Enabled := ( Lowercase(edtEnterQuit.Text) = 'quit');
end;

procedure TFrmActionsMain.FormCreate(Sender: TObject);
begin

end;

procedure TFrmActionsMain.lblHintClick(Sender: TObject);
begin

end;

end.
