unit Unt_OnlyOnce;

{$include 'jedi.inc'}

Interface

{*V 1.50.03 }
{*H 1.50.02 Einfuegen von Together-Tags}
{*H 1.50.01 }
{*H 1.50.00 Orginal-Anwendung wird hervorgeholt }

Uses  forms;

///<author>Joe Care</author>
///  <version>1.50.02</version>
///  <since>15.04.2008</since>
///  <info>Aktiviert die Anwendung mit dem angegebenen Namen</info>
{$ifdef DEFAULTS_WIDESTRING}
procedure SwitchToAppl(appname: PWideChar; App: TApplication);
{$else}
procedure SwitchToAppl(appname: PAnsiChar; App: TApplication);
{$endif}
///<author>Joe Care</author>
///  <version>1.50.00</version>
///  <since>15.04.2008</since>
///  <info>Prueft ob Anwendung schon gestartet ist</info>
Procedure CheckStarted(App: TApplication);

implementation

uses
{$IFnDEF FPC}
  windows, Messages;
{$ELSE}
  LCLIntf, LCLType, LMessages;
{$ENDIF}


Var
  ///<author>Joe Care</author>
  ///  <since>15.04.2008</since>
  ///  <version>1.50.00</version>
  ///  <info>ueber diesen globale MutexHandle findet die Pruefung statt</info>
 MutexHandle: THandle;

{$ifdef DEFAULTS_WIDESTRING}
procedure SwitchToAppl(appname: PWideChar; App: TApplication);
{$else}
procedure SwitchToAppl(appname: PAnsiChar; App: TApplication);
{$endif}
var
  H1: Cardinal;
  hwind: HWND;
  h2: Cardinal;
begin
    h2 := GetCurrentThreadId;
    hwind := 0;
    repeat
      hwind := Windows.FindWindowEx(0, hwind, 'TApplication', appname);
    until (hwind <> App.Handle);
    if (hwind <> 0) then
    begin
      H1 := getwindowThreadProcessID(hwind, nil);
      if isiconic(hwind) then
        sendmessage(hwind, wm_SysCommand, sc_restore, 0);
      attachThreadInput(h1, h2, true);
      try
        SetForegroundWindow(hwind);
      finally
        attachThreadInput(h1, h2, false);
      end;
    end;
end;

Procedure CheckStarted(App: TApplication);

var
 appname: PChar;
  stng: AnsiString;

begin
  stng := ansistring(app.Title) + #0;
  appname := @stng[1];
  GetWindowtext(App.Handle, appname, 255);
  If length(appname) < 1 Then
    MessageBox(0, 'Bitte dem Projekt einen Titel geben,' + #13#10 +
    ' damit "ONLYONCE" funktioniert.', 'Hinweis', 0);
  Mutexhandle := CreateMutex(Nil, FALSE, appname);
  IF GetLastError = ERROR_ALREADY_EXISTS THEN
    begin
      SwitchToAppl(appname, App);
      Halt(0);
    end;
end;

initialization
finalization
          try
ReleaseMutex(Mutexhandle);
except
end;
end.

