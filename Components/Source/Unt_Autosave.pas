unit Unt_Autosave;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface


implementation

{$IFnDEF FPC}
uses
  windows;
{$ELSE}
uses
{$IFDEF MSWINDOWS}
 windows,
{$ENDIF}
  LCLIntf, LCLType;
{$ENDIF}

{$IFDEF MSWINDOWS}
var ///<author>Rosewich</author>
  W:HWND;

initialization
   {$IFnDEF FPC}
   W := FindWindow(NIL,'Delphi'); // heißt hier das Fenster mit dem Menü
   {$ELSE}
   W := FindWindow(NIL,'Lazarus IDE'); // heißt hier das Fenster mit dem Menü
   {$ENDIF}
   if W <> 0 then
   begin
     keybd_event(vk_shift,0,0,0);
     Keybd_Event(VK_CONTROL,0,0,0);
     Keybd_Event(ord('S'),0,0,0);
     Keybd_Event(ord('S'),0,KEYEVENTF_KEYUP,0);
     Keybd_Event(vk_Control,0,KEYEVENTF_KEYUP,0);
     Keybd_Event(vk_shift,0,KEYEVENTF_KEYUP,0);
   end;
{$ENDIF}
end.
