unit unt_GetWindows;

{$mode delphi}

interface

uses
  Classes, SysUtils;

Function FindWindow(Windowname:String):THandle;
Procedure FillWindowlist(const aList:TStrings);
Function GetWindowName(aHDL:THandle):String;
Function GetClassName(aHDL:THandle):String;
Procedure ActivateWindow(aHDL:THandle);

implementation

{$ifdef MSWINDOWS}
uses windows;
function FindWindow(Windowname: String): THandle;

begin
  result := windows.FindWindow(@Windowname[1],0);
  if result =0 then
    result := windows.FindWindow(0,@Windowname[1]);
end;

{ Windows calls this function, passing in Handle a reference
  to each alive window. Param is not used in this example. }
function EnumWinProc(Handle: HWnd; {%H-}Param: lPAram): Boolean;
  Stdcall;
var
  Sz: array[0 .. 132] of Char; {Holds result of GetWindowText}
begin
  Result := True;  { Always successful }
  { Call Windows to obtain each window's caption, and then
    add the returned string to the form's ListBox. }
  if (GetWindowText(Handle, Sz, Sizeof(Sz)) <> 0) and assigned(tobject(param)) and (TObject(param).InheritsFrom(TStrings)) then
    TStrings(Tobject(Param)).AddObject(StrPas(Sz),TObject(Handle));
end;

procedure FillWindowlist(const aList: TStrings);
begin
  EnumWindows(@EnumWinProc,LPARAM(alist));
end;

function GetWindowName(aHDL: THandle): String;

var
  Sz: array[0 .. 132] of Char; {Holds result of GetWindowText}
begin
  result := '';
  if GetWindowText(aHDL, Sz, Sizeof(Sz)) <> 0 then
     result := strpas(pChar(sz));
end;

function GetClassName(aHDL: THandle): String;
var
  Sz: array[0 .. 132] of Char; {Holds result of GetWindowText}
begin
  result := '';
  if windows.GetClassName(aHDL, Sz, Sizeof(Sz)) <> 0 then
     result := strpas(pChar(sz));
end;

procedure ActivateWindow(aHDL: THandle);
begin
      ShowWindow(aHDL,SW_HIDE);
      sleep(10);
      ShowWindow(aHDL,SW_SHOWNORMAL);
end;

{$else}

uses Forms;

{ Unter Linux gibt es die WinAPI nicht - die Demo bleibt in der Lehre
  erhalten, indem sie die Formulare DES laufenden Programms aufzaehlt:
  Screen.Forms entspricht der EnumWindows-Liste, die Handles sind
  dieselben THandle-Werte, die die LCL intern fuehrt. }
function FindWindow(Windowname: String): THandle;
var
  I: Integer;
begin
  result := 0;
  for I := 0 to Screen.FormCount - 1 do
    if CompareText(Screen.Forms[i].Name, Windowname) = 0 then
      Exit(THandle(Screen.Forms[i].Handle));
end;

procedure FillWindowlist(const aList: TStrings);
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
    aList.AddObject(Screen.Forms[i].Caption,
      TObject(PtrInt(Screen.Forms[i].Handle)));
end;

function GetWindowName(aHDL: THandle): String;
var
  I: Integer;
begin
  result := '';
  for I := 0 to Screen.FormCount - 1 do
    if THandle(Screen.Forms[i].Handle) = aHDL then
      Exit(Screen.Forms[i].Caption);
end;

function GetClassName(aHDL: THandle): String;
var
  I: Integer;
begin
  result := '';
  for I := 0 to Screen.FormCount - 1 do
    if THandle(Screen.Forms[i].Handle) = aHDL then
      Exit(Screen.Forms[i].ClassName);
end;

procedure ActivateWindow(aHDL: THandle);
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
    if THandle(Screen.Forms[i].Handle) = aHDL then
      Screen.Forms[i].Show;
end;

{$endif}

end.

