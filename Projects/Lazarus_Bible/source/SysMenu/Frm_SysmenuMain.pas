unit Frm_SysmenuMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    procedure WMSysCommand(var Message: TWMSysCommand);
      message wm_SysCommand;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

const
  cm_About = $00A0;  { Define a constant for the new command }

{$R *.DFM}

{ Respond to selection of our new system menu command }
procedure TForm1.WMSysCommand(var Message: TWMSysCommand);
begin
  case Message.CmdType of
    cm_About: ShowMessage('About command selected!');
  else
    inherited;  { Default processing }
  end;
end;

{Add a command to the window's system menu }
procedure TForm1.FormCreate(Sender: TObject);
var
  MenuH: HMenu;
begin
  MenuH := GetSystemMenu(Handle, False);
  AppendMenu(MenuH, mf_String, cm_About, 'About...');
end;

end.
