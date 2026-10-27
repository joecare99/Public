library Colorlib;

{ Frueher eine Windows-DLL; jetzt eine plattformuebergreifende Shared
  Library (Colorlib.so unter Linux, Colorlib.dll unter Windows), die die
  Funktion FBGetColors exportiert. Testdll laedt sie zur Laufzeit. }

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  Frm_CLRFORM;

exports
  FBGetColors;

begin
  Application.Initialize;
end.
