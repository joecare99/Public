var
  W: Word;    { Result of MessageDlgPos }
  P: TPoint;  { Coordinate X, Y record }
begin
  P.X := 0;  { Assign client X value }
  P.Y := 0;  { Assign client Y value }
  P := ClientToScreen(P);  { Convert P to screen coordinates }
  W := MessageDlgPos('Function: MessageDlg',
    mtInformation, [mbYes, mbNo, mbIgnore], 0,
    P.X, P.Y);  { Pass converted X, Y to function }
end;
