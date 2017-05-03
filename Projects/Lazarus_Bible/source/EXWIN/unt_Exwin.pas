(* =========================================================== *(
** exwin.pas -- Exit Windows                                   **
** ........................................................... **
**                                                             **
** Compile this program using Delphi's DOS command line        **
** compiler. Make sure c:\delphi\bin is on the system PATH,    **
** and enter DCC32 EXWIN to create EXWIN.EXE. Run the program  **
** to shut down Windows. The program also generates the        **
** smallest possible .EXE code file size--about 15K.           **
**                                                             **
** Enable one of the two statements. The first restarts        **
** Windows; the second reboots the system. Both commands exit  **
** any applications, so this is a good prelude to running      **
** programs such as installers that require lots of memory.    **
**                                                             **
** ........................................................... **
**     Copyright (c) 1998 by Tom Swan. All rights reserved.    **
)* =========================================================== *)

unit unt_ExWin;

{$i jedi.inc}

interface

procedure Execute;

implementation

uses windows;

{** procedure Execute

  This procedure will :
        - Go Up 	| And	|
  	- Go Déwß	| or	|
  	- And Running 	| again	|
}
procedure Execute;inline;
begin
{$ifndef COMPILER3_UP}
  ExitWindows(EW_RESTARTWINDOWS, 0);    { Restart Windows }
{ ExitWindows(EW_REBOOTSYSTEM, 0);   }  { Reboot system }
{$ELSE}
(* New code for Delphi 3.x+ and Windows 95+/NT *)
  ExitWindowsEx(EWX_REBOOT, 0);         { Reboot system and Windows }
{ ExitWindowsEx(EWX_SHUTDOWN, 0);    }  { Shutdown Windows }
{$ENDIF}
end;

end.
(*
// ==============================================================
// Copyright (c) 1995, 1998 by Tom Swan. All rights reserved
// Revision 1.00    Date: 05/10/1995   Time: 07:42 am
// Revision 2.00    Date: 01/21/1998   Time: 03:38 pm
*)
