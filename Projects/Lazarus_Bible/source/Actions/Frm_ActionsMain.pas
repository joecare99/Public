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
  Forms, Dialogs, Menus, ActnList, StdCtrls, System.Actions;

type
  TFrmActionsMain = class(TForm)
    MainMenu1: TMainMenu;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    ActionList1: TActionList;
    Demo1: TMenuItem;
    Exit1: TMenuItem;
    ExitAction: TAction;
    procedure ExitActionExecute(Sender: TObject);
    procedure ExitActionUpdate(Sender: TObject);
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

procedure TFrmActionsMain.ExitActionExecute(Sender: TObject);
begin
  Close;  // Exit program
end;

procedure TFrmActionsMain.ExitActionUpdate(Sender: TObject);

begin
// Set Flag True if user types Quit into Edit1
  ExitAction.Enabled := ( Lowercase(Edit1.Text) = 'quit');
end;

end.
