program SuDoKu;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SudokuMain in 'Frm_SudokuMain.pas' {Form1};

{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Sudoku - Lösungshilfe';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
