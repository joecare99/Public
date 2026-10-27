unit Frm_SysmenuMain;

{ Sysmenu-Demo, plattformneutral: Unter Windows (Delphi) wird ein eigener
  Befehl an das Systemmenue des Fensters gehaengt und per WM_SYSCOMMAND
  behandelt. Unter Free Pascal gibt es keine portable Systemmenue-API,
  deshalb wird der Befehl als regulaerer Menueeintrag angeboten - gleiche
  Wirkung, andere Umsetzung. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 Messages,
 SysUtils,
 Classes,
 Graphics,
 Controls,
 Forms,
 Dialogs,
 StdCtrls,
{$IFnDEF FPC}
  Windows, Menus,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages,
  Menus
{$ENDIF};

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure AboutClick(Sender: TObject);
  private
    {$IFNDEF FPC}
    procedure WMSysCommand(var Message: TWMSysCommand);
      message wm_SysCommand;
    {$ENDIF}
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

const
  cm_About = $00A0;  { Define a constant for the new command }

{$IFnDEF FPC}

  {$R *.dfm}

{$ELSE}

  {$R *.lfm}

{$ENDIF}
{$IFNDEF FPC}
{ Respond to selection of our new system menu command }
procedure TForm1.WMSysCommand(var Message: TWMSysCommand);
begin
  case Message.CmdType of
    cm_About: ShowMessage('About command selected!');
  else
    inherited;  { Default processing }
  end;
end;
{$ENDIF}

procedure TForm1.AboutClick(Sender: TObject);
begin
  ShowMessage('About command selected!');
end;

{ Add a command to the window's menu. }
procedure TForm1.FormCreate(Sender: TObject);
{$IFDEF FPC}
var
  M: TMainMenu;
  Item: TMenuItem;
{$ELSE}
var
  MenuH: HMenu;
{$ENDIF}
begin
  {$IFDEF FPC}
  { Plattformneutral: der Befehl erscheint als Menueeintrag. }
  M := TMainMenu.Create(Self);
  Self.Menu := M;
  Item := TMenuItem.Create(M);
  Item.Caption := 'About...';
  Item.OnClick := AboutClick;
  M.Items.Add(Item);
  {$ELSE}
  MenuH := GetSystemMenu(Handle, False);
  AppendMenu(MenuH, mf_String, cm_About, 'About...');
  {$ENDIF}
end;

end.
