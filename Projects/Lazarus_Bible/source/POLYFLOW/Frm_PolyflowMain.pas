UNIT Frm_PolyflowMain;

INTERFACE

{$I jedi.inc}


USES
  {$IFnDEF FPC}
    Windows,
  {$ELSE}
    LCLIntf, LCLType, LMessages,
  {$ENDIF}
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  Menus;

CONST
  maxIndex     = 30;                   { Maximum number of lines visible }
{$IFDEF SUPPORTS_DEFAULTPARAMS}
VAR
{$ENDIF}
  dx1          : Integer = 4;           { "Delta" values for controlling }
  dy1          : Integer = 10;          {  the animation's personality.  }
  dx2          : Integer = 3;
  dy2          : Integer = 9;

TYPE
  LineRec = RECORD                      { Line ends and color }
    X1, Y1, X2, Y2: Integer;
    Color: TColor;
  END;

TYPE
  TMainForm = CLASS(TForm)
    MainMenu1: TMainMenu;
    Demo1: TMenuItem;
    Exit1: TMenuItem;
    Timer1: TTimer;
    PROCEDURE Exit1Click(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Timer1Timer(Sender: TObject);
    PROCEDURE FormPaint(Sender: TObject);
    PROCEDURE FormResize(Sender: TObject);
  Protected
    PROCEDURE CreateParams(VAR Params: TCreateParams); Override;
  Private
    LineArray: ARRAY[0..maxIndex - 1] OF LineRec;
      Index: Integer;                   { Index for LineArray }
    Erasing: Boolean;                   { True if erasing old lines }
    FUNCTION Sign(N: Integer): Integer;
    PROCEDURE InitLineArray;
    PROCEDURE MakeNewLine(R: TRect; Index: Integer);
    PROCEDURE DrawLine(Index: Integer);
  Public
    { Public declarations }
  END;

VAR
  MainForm     : TMainForm;

IMPLEMENTATION

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

PROCEDURE TMainForm.CreateParams(VAR Params: TCreateParams);
BEGIN
  INHERITED CreateParams(params);
  WITH Params.WindowClass DO
    {- Repaint the window automatically when resized }
    Style := Style OR cs_HRedraw OR cs_VRedraw;
END;

{- Return -1 if n < 0 or +1 if n >= 0 }

FUNCTION TMainForm.Sign(N: Integer): Integer;
BEGIN
  IF N < 0 THEN
    Sign := -1
  ELSE
    Sign := 1;
END;

{- Erase LineArray and set X1 to -1 as "no line" flag }

PROCEDURE TMainForm.InitLineArray;
VAR
  I            : Integer;
BEGIN
  Index := 0;
  Erasing := False;
  FillChar(LineArray, SizeOf(LineArray), 0);
  FOR I := 0 TO maxIndex - 1 DO
    LineArray[I].X1 := -1;
END;

{- Create new line, direction, and color }

PROCEDURE TMainForm.MakeNewLine(R: TRect; Index: Integer);
  PROCEDURE NewCoord(VAR C, Change: Integer; Max: Integer;
    VAR Color: TColor);
  VAR
    Temp       : Integer;
  BEGIN
    Temp := C + Change;
    IF (Temp < 0) OR (Temp > Max) THEN
      BEGIN
        Change := Sign(-Change) * (3 + Random(12));
        REPEAT
          Color := RGB(Random(256), Random(256), Random(256));
         {$IFNDEF FPC}  Color := GetNearestColor(Canvas.Handle, Color) {$ENDIF}
        UNTIL Color <> TColor(GetBkColor(Canvas.Handle));
      END
    ELSE
      C := Temp;
  END;
BEGIN
  WITH LineArray[Index] DO
    BEGIN
      NewCoord(X1, dx1, R.Right, Color);
      NewCoord(Y1, dy1, R.Bottom, Color);
      NewCoord(X2, dx2, R.Right, Color);
      NewCoord(Y2, dy2, R.Bottom, Color)
    END
END;

{- Draw or erase a line identified by Index }

PROCEDURE TMainForm.DrawLine(Index: Integer);
BEGIN
  if LineArray[Index].X1>=0 then
  WITH Canvas, LineArray[Index] DO
    BEGIN
      Pen.Color := Color;
      MoveTo(X1, Y1);
      LineTo(X2, Y2);
    END;
END;

{- Draw some lines at each timer interval }

PROCEDURE TMainForm.Timer1Timer(Sender: TObject);
VAR
  R            : TRect;
  I, OldIndex  : Integer;
BEGIN
  R := GetClientRect;
  FOR I := 1 TO 2 DO                   { 10 = number of lines }
    BEGIN
      OldIndex := Index;
      Inc(Index);
      IF Index = maxIndex - 1 THEN
        BEGIN
          Index := 0;                   { Wrap Index around to start }
          Erasing := True;              { True until window size changes }
        END;
      IF Erasing THEN
        DrawLine(Index);                { Erase old line }
      LineArray[Index] := LineArray[OldIndex];
      MakeNewLine(R, Index);
      DrawLine(Index);                  { Draw new line }
    END;
END;

{- Paint or repaint screen using data in LineArray }

PROCEDURE TMainForm.FormPaint(Sender: TObject);
VAR
  I            : Integer;
BEGIN
  WITH Canvas DO
    FOR I := 0 TO maxIndex - 1 DO
      IF LineArray[I].X1 >= 0 THEN      { Draw non-flagged lines }
        DrawLine(I);
END;

{- Start new lines when window size changes }

PROCEDURE TMainForm.FormResize(Sender: TObject);
BEGIN
  InitLineArray;                        { Erase LineArray and reset globals }
END;

{- Initialize globals and LineArray }

PROCEDURE TMainForm.FormCreate(Sender: TObject);
BEGIN
  WITH Canvas.Pen DO
    BEGIN
      Style := psSolid;
      Width := 1;
      Mode := pmXor;
    END;
  Randomize;
  InitLineArray;
END;

{- End program }

PROCEDURE TMainForm.Exit1Click(Sender: TObject);
BEGIN
  Close;
END;

END.

(*
// ==============================================================
// Copyright (c) 1991,1993,1995 by Tom Swan. All rights reserved
// Revision 1.00    Date: 3/1/1993   Time: 12:00 pm
// Revision 2.00    Date: 6/13/1995  Time:  6:00 pm
// - Fixed bug in timer proc that sometimes failed to erase a line
// - Erase LineArray to zero bytes at startup and on window resize
// Revision 2.01    Date: 2/16/1998  Time:  4:45 pm
// - Updated for Delphi 3
// Revision 2.02    Date: 5/14/2010  Time:  4:45 pm
// - Updated for Delphi 2010 +
*)

