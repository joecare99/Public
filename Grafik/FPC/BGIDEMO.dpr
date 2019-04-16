
{ Turbo Graphics }
{ Copyright (c) 1985, 1989 by Borland International, Inc. }

program BGIDEMO;

{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
  {$E EXE}
{$ENDIF}

(*
  Turbo Pascal 5.5 Borland Graphics Interface (BGI) demonstration
  program. This program shows how to use many features of
  the Graph unit.

  NOTE: to have this demo use the IBM8514 driver, specify a
  conditional define constant "Use8514" (using the {$DEFINE}
  directive or Options\Compiler\Conditional defines) and then
  re-compile.

*)

{$APPTYPE CONSOLE}

uses
  {$IFDEF FPC}
  interfaces,
   {$endif}
  Unt_BGIDemo;

{$R *.res}

begin
  Execute;
end.

