unit unt_iopcc_Commented;

{$mode delphi}{$H+}

interface

procedure Main;

implementation

{ $define SingleTask}
{ $define ShowGen}
{$define WaitAtEnd}

{$ifdef ShowGen}
uses
    SysUtils, crt;

{$endif}

{$ifdef C}
//#define P(X)write(1,X,1)
//#define C 39
//#define E 1024
//int M[E]={2},*u=M,N[E],R=22,a[4],l[]={0,-1,C-1,-1},m[]={1,-C,-1,C},*b=N,*d=N,c,
//e,f,g,i,s;main(){for(M[e=i=C*R-1]=E|8;f|d>=b;){c=M[g=i];i=e;for(s=f=0;s<4; s++)
//if((e=m[s]+g)>=0&&e<C*R&&l[s]!=e%C&&(c&E)!=(M[e]&E))a[f++]=s;if(f){f=M[e=m[s=a[
//rand()%f]]+g];f|=E;M[g]=c|1<<s;M[*d++=e]=f|1<<(s+2)%4;}else e=d>b++?b[-1]:e;}P(
//" ");for(s=C;s--;P(" "))P("_");for(;P("\n"),R--;P("|"))for(e=C;e--;P("_ "+(*u++
///8)%2))P("| "+(*u/4)%2);}
{$endif}

type
    TValues = integer;   // All values have this Type
    TDir = 0..3;        // Enumerator for all Directions

const
    T2k = 1 shl 11; //2048 (2^11)
    CellPerDimesion = $13 shl 1 + 1; // 39 (80/2 -1)  19 * 2 + 1
    One = CellPerDimesion and -CellPerDimesion; // 1  neg ~= inv x -1 ; x and inv x =: 0 -> x and -x =: 1
    Eight = One shl (One shl One + One); // 2 ^ ( 2 + 1)
    TextOut = ' _|';  // Basic definition of all used Characters
    TextCode = $597B; // 2-Bit coded permutation index
    {$ifdef ShowGen}
    Scc = '   ''---'' , |-,-|';
    {$endif}
    DirStoppArray: array[TDir] of TValues = (0, One - 4, CellPerDimesion - One, -One); // This Array is used to stop the Driller in a specific Direction
    Dir: array[TDir] of TValues = (One, CellPerDimesion, -One, -CellPerDimesion); // This Array defines the Offset to the next Cell in a Specific Direction

var
    // Former Mu Labyrinth-Array a TValue for every Cell, In the lower bits (0..3)
    // the way to the next Cell is encoded. bit11 stores if the Cell was already
    // visited by the Driller Task.
    Labyrinth: array[0..T2k] of TValues;

// This is the Pascal-couterpart for the C: (v)++ Operation
function pp_(var AValue: TValues): TValues;
begin
    pp_ := AValue;
    Inc(AValue);
end;

procedure WOut(idx: TValues);
begin
    if idx < Eight then
        // pp_(idx)          := idx     :idx is returned but idx is incremented afterwards
        // () shl One        := idx * 2 :the returnd value is doubled by shifting
        // TextCode shr () and 3        :determins the value by shifting TextCode to the right
        //                               and at the end all unnecessary bits are masked
        //                               by the and 3 so only th lowest two bits are returned
        //  Alltogether it determins the Index of the Charater to Display
        //  this is executed Twice (the second time without the pp_ Function and then
        //  Concatenated.
        Write(TextOut[TextCode shr (pp_(idx) shl One) and 3] + TextOut[TextCode shr (idx shl One) and 3])
    else
        // The TextOut + TextOut + TextOut is a Dummy, only th last character is needed.
        Write(Copy(TextOut + TextOut + TextOut + LineEnding, idx + One, 3));
end;

procedure Main;

var
    FifoPopIdx: TValues = 0; // Pop-Idx , former Hel
    DirCount: TValues = Eight - Eight; // := 0 former Wor
    ActDir, // former P
    NextCell,  // former A
    ActCell,   // former S
    StoredCell: TValues; // former CA
    FifoPushIdx: TValues = T2k - T2k; //:= 0  Push-Idx, former _fe
    ActCellData, // former _C
    LabOutIdx: TValues;      // former oo
    Fifo: array[0..T2k] of TValues;     // former LL
    PosibDir: array[0..3] of TValues;    // former L1

begin
    Randomize;  // This one is defitly usefull but wasn't in the original code
    Labyrinth[0] := Eight;   // Setze Endpunkt mit Ausgang
    StoredCell := CellPerDimesion * CellPerDimesion - One;  // Anfangspunkt unten rechts
    NextCell := StoredCell;
    Labyrinth[StoredCell] := T2k + 2; // Setze Eingang und belegt
    while (DirCount <> 0) or (FifoPushIdx >= FifoPopIdx) do
      begin
    {$IFDEF SingleTask}
        ActCell := NextCell;
    {$ELSE}
        ActCell := StoredCell;
        StoredCell := NextCell;
    {$ENDIF}
        ActCellData := Labyrinth[ActCell];
        // Calculate Valid directions and store them in PosibDir
        DirCount := 0;
        for ActDir in DirStoppArray do
          begin
            NextCell := Dir[ActDir and 3] + ActCell;
            if ((NextCell >= 0) and (NextCell < CellPerDimesion * CellPerDimesion) and (ActDir <> (NextCell mod CellPerDimesion)) and ((ActCellData and T2k) <> (Labyrinth[NextCell] and T2k))) then
              begin
                PosibDir[pp_(DirCount)] := ActDir;
              end;
          end;
        if (DirCount <> 0) then
          begin
            ActDir := PosibDir[random(DirCount)] and 3;  // Calc Destination Cell
            NextCell := Dir[ActDir] + ActCell;
            // Remove Wall between Cells
            Labyrinth[ActCell] := ActCellData or One shl ActDir;
            Labyrinth[NextCell] := Labyrinth[NextCell] or T2k or (One shl ((ActDir + 2) mod 4));
            // Push Cell to the Fifo
            Fifo[pp_(FifoPushIdx)] := NextCell;
          end
        else
          begin
            // Pop Cell from the Fifo
            if FifoPushIdx >= FifoPopIdx then
                NextCell := Fifo[pp_(FifoPopIdx)];
          end;
    {$ifdef ShowGen}
        gotoxy((ActCell mod Cg) * 2 + One, ActCell div Cg + One);
        Write(copy(Scc, (Labyrinth[ActCell] and $0e) + One, 2));
        sleep(30);
    {$endif}
      end;
  {$ifdef ShowGen}
    gotoxy(One, One);
  {$endif}
    // Output Routine
    // Write the top-row separately
    Wout(Eight - 2);
    for ActCell := One to CellPerDimesion - One do
        Wout(Eight shr One);
    // write a Linebreak
    Wout(Eight + One);
    for ActCell := One to CellPerDimesion do
      begin
        for NextCell := One to CellPerDimesion do
            wout(Labyrinth[pp_(LabOutIdx)] and 6);
        wout(Eight); // Write the last column and the linebreak separately
      end;
 {$IFDEF WaitAtEnd}
    readln;
 {$ENDIF}
end;

end.
