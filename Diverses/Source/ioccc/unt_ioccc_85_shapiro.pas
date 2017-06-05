unit unt_ioccc_85_shapiro;

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

{$ifdef C}// This is the orginal C-Code
//#define P(X)j=write(1,X,1)
//#define C 39
//int M[5000]={2},*u=M,N[5000],R=22,a[4],l[]={0,-1,C-1,-1},m[]={1,-C,-1,C},*b=N,
//*d=N,c,e,f,g,i,j,k,s;main(){for(M[i=C*R-1]=24;f|d>=b;){c=M[g=i];i=e;for(s=f=0;
//s<4;s++)if((k=m[s]+g)>=0&&k<C*R&&l[s]!=k%C&&(!M[k]||!j&&c>=16!=M[k]>=16))a[f++
//]=s;if(f){f=M[e=m[s=a[rand()/(1+2147483647/f)]]+g];j=j<f?f:j;f+=c&-16*!j;M[g]=
//c|1<<s;M[*d++=e]=f|1<<(s+2)%4;}else e=d>b++?b[-1]:e;}P(" ");for(s=C;--s;P("_")
//)P(" ");for(;P("\n"),R--;P("|"))for(e=C;e--;P("_ "+(*u++/8)%2))P("| "+(*u/4)%2
//);}
{$endif}

function iff(b: boolean; i1, i2: integer): integer;

begin
  if b then
    Result := i1
  else
    Result := i2;
end;

var
  Labyrinth: array[0..999] of integer;  // Former Mu

const
  Cg = 39;
  {$ifdef ShowGen}
  Scc = '   ''---'' , |-,-|';
  {$endif}
  DirStoppArray: array[0..3] of integer = (0, -1, Cg - 1, -1); // former l
  Dir: array[0..3] of integer = (1, -Cg, -1, Cg); // former m

procedure Main;

const
  Ru: integer = 22;  // Must be writable for the out-Routine

var
  LabOutIdx: integer = 0;             // former u
  Fifo: array[0..999] of integer;     // former Nu
  PosibDir: array[0..3] of integer;    // former  a
  FifoPopIdx: integer = 0; // Pop-Idx , former d
  FifoPushIdx: integer = 0; // Push-Idx, former b
  ActCellData, // former c
  NextCell,  // former e
  NextCellData, // former f(2)
  ActCell, // former g
  StoredCell, // former i
  ActDir: integer; // former s
  DirCount: integer = 0; // former f(1)
  // j become redundand !

begin
  Randomize;  // This one is defitly usefull but wasn't in the original code
  Labyrinth[0] := 2;   // Setze Endpunkt mit Ausgang
  StoredCell := Cg * Ru - 1;  // Anfangspunkt unten rechts
  NextCell := StoredCell;
  Labyrinth[StoredCell] := 24; // Setze Eingang und belegt
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
    ActDir := 0;
    DirCount := 0;
    while (ActDir < 4) do
    begin
      NextCell := Dir[ActDir] + ActCell;
      if ((NextCell >= 0)
        and (NextCell < Cg * Ru)
        and (DirStoppArray[ActDir] <> (NextCell mod Cg))
        and ((ActCellData and 16) <> (Labyrinth[NextCell] and 16))) then
      begin
        PosibDir[DirCount] := ActDir;
        DirCount := DirCount + 1;
      end;
      ActDir := ActDir + 1;
    end;
    if (DirCount <> 0) then
    begin
      ActDir := PosibDir[random(DirCount)];
      NextCell := Dir[ActDir] + ActCell;  // Calc Destination Cell
      NextCellData := Labyrinth[NextCell];
      NextCellData := NextCellData or 16;
      // Remove Wall between Cells
      Labyrinth[ActCell] := ActCellData or 1 shl ActDir;
      Labyrinth[NextCell] := NextCellData or (1 shl ((ActDir + 2) mod 4));
      // Push Cell to the Fifo
      Fifo[FifoPushIdx] := NextCell;
      FifoPushIdx := FifoPushIdx + 1;
    end
    else
    begin
      // Pop Cell from the Fifo
      NextCell := iff(FifoPushIdx > FifoPopIdx, Fifo[FifoPopIdx], NextCell);
      FifoPopIdx := FifoPopIdx + 1;
    end;
    {$ifdef ShowGen}
    gotoxy((ActCell mod Cg) * 2 + 1, ActCell div Cg + 1);
    Write(copy(Scc, (Labyrinth[ActCell] and $0e) + 1, 2));
    sleep(100);
    {$endif}
  end;
  {$ifdef ShowGen}
  gotoxy(1, 1);
  {$endif}
  // Output Routine
  Write('  ');
  ActDir := Cg - 1;
  while (ActDir > 0) do
  begin
    Write(' ');
    ActDir := ActDir - 1;
    Write('_');
  end;
  while (Ru > 0) do
  begin
    writeln;
    Ru := Ru - 1;
    Write('|');
    NextCell := Cg;
    while (NextCell > 0) do
    begin
      NextCell := NextCell - 1;
      Write(copy('_ ', ((Labyrinth[LabOutIdx] div 8) mod 2) + 1, 1));
      LabOutIdx := LabOutIdx + 1;
      Write(copy('| ', ((Labyrinth[LabOutIdx] div 4) mod 2) + 1, 1));
    end;
  end;
 {$IFDEF WaitAtEnd}
  readln;
 {$ENDIF}
end;

end.
