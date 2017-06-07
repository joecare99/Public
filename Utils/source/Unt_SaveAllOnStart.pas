unit Unt_SaveAllOnStart;

interface

implementation

uses windows;

var w:integer;
begin
	// Alles speichern
   W := FindWindow(NIL,'CodeParamWindow'); // heißt hier das Fenster mit dem Menü
   if W <> 0 then
   begin
     Keybd_Event(vk_shift,0,0,0);
     Keybd_Event(VK_CONTROL,0,0,0);
     Keybd_Event(ord('S'),0,0,0);
     Keybd_Event(ord('S'),0,KEYEVENTF_KEYUP,0);
     Keybd_Event(vk_Control,0,KEYEVENTF_KEYUP,0);
     Keybd_Event(vk_shift,0,KEYEVENTF_KEYUP,0);
   end;
end.
