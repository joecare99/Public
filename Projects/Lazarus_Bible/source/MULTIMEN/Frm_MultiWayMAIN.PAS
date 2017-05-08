unit Frm_MultiWayMAIN;

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
  Forms, Dialogs, Menus;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Search1: TMenuItem;
    Replace1: TMenuItem;
    Find1: TMenuItem;
    Partialwords1: TMenuItem;
    Wholewords1: TMenuItem;
    Previous1: TMenuItem;
    Ignorecase1: TMenuItem;
    Redo1: TMenuItem;
    Undo1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
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

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.

