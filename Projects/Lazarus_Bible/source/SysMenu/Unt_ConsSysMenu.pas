unit Unt_ConsSysMenu;

interface

procedure Execute;

implementation

uses
  windows,
  dialogs,
  SysUtils;

const
  cm_About = $00A0;  { Define a constant for the new command }

 (*
{ Respond to selection of our new system menu command }
procedure TForm1.WMSysCommand(var Message: TWMSysCommand);
begin
  case Message.CmdType of
    cm_About: ShowMessage('About command selected!');
  else
    inherited;  { Default processing }
  end;
end;
*)
procedure Execute;

var
  MenuH: HMenu;
  Handle: THandle;

begin
  try
    Handle := GetStdHandle(STD_output_HANDLE);
    MenuH := GetSystemMenu(Handle, False);
    AppendMenu(MenuH, mf_String, cm_About, 'About...');
    ShowMessage('About command selected!');
    readln;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end;

end.
