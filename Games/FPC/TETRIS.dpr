Program TETRIS;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$APPTYPE Console}

uses
  sysutils,
  {$IFDEF FPC}
    interfaces,
  {$ENDIF}
  Unt_Tetris in '..\Source\Unt_Tetris.pas',
  Unt_TetEng in '..\Source\Unt_TetEng.pas';

{$E EXE}

Begin
  Execute;
End.
