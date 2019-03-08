unit unt_ioccc_85_shapiro;

{$mode delphi}{$H+}

interface

procedure Main;

implementation

{ $define SingleTask}
{ $define ShowGen}
{$define WaitAtEnd}

uses
  SysUtils{$ifdef ShowGen}
, crt, math
{$endif};

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

type TValues=integer;
     TDir= 0..3;
     TPosArray=array[0..3] of Tdir;


const
  T1k = 1024;
  Cg = 39;
  {$ifdef ShowGen}
  Scc = '   ,---, '' |-''-|';
  {$endif}
  SOut = '|_|  _  |';
  DirStoppArray: array[TDir] of TValues = (0, -3, Cg - 1, -1); // former l
  Dir: array[TDir] of TValues = (1, Cg, -1, -Cg); // former m


var
  Labyrinth: array[0..T1k] of TValues;  // Former Mu

  function pp_(var aValue:TValues):TValues;
  begin
   pp_:=aValue;
   inc(AValue);
  end;

  procedure WOut(idx:TValues);
  begin
  Write(Copy(SOut+LineEnding, idx + 1, 2 + idx div 8));
  end;

const //{-1}prest:String='010011020101111010020201031210000021010020013000111211112010';
      //{-2}prest:String='11100200012111101000002122103';
      {-3}prest:String='01100020110100010100112100000012131011120100011003001111200101101211';
      sstr:string='';
      SPre=$123456789ABCDEFF;
      sInt1:QWord=$0;
      sInt2:QWord=$0;


  function GetRndDir(cnt:TValues;PosibDir:TPosArray):Tdir;

  var
    lNr: Longint;
    st:string;
    tr: byte;

  begin
//    if cnt=1 then exit(PosibDir[0]);
   {$ifdef ShowGen}
    gotoxy(1,1);
    writeln(inttohex(sint2,16),' ',inttohex(sint1,16),' ',sstr);
    write(cnt,':',PosibDir[0],', ',PosibDir[1],', ',PosibDir[2],', ',PosibDir[3],'  ');
    {$endif}
    if length(preSt)=0 then
//      readln(st)
      exit(PosibDir[random(cnt)])
    else
      begin
        st := Prest[1];
        delete(prest,1,1);
      end;
    if trystrtoint(st,lNr) and (lNr<=cnt) then
      begin
        sstr:=sstr+st;
        sint1:=RolQWord( sint1,2);
        tr:=sint1 and 3;
        sint1:=sint1 xor tr  or lNr;
        sint2:=RolQWord( sint2,2);
        sint2:=sint2 xor tr;
        exit(PosibDir[lnr])

      end
    else
      exit(PosibDir[random(cnt)]);
  end;

procedure Main;

const
  Ru: integer = 22;  // Must be writable for the out-Routine

var
  LabOutIdx: TValues = 0;             // former u
  Fifo: array[0..T1k] of TValues;     // former Nu
  PosibDir: TPosArray;    // former  a
  FifoPopIdx: TValues = 0; // Pop-Idx , former d
  FifoPushIdx: TValues = 0; // Push-Idx, former b
  {$ifdef ShowGen}
  Idx,
  {$endif}
  ActCellData, // former c
  NextCell,  // former e
  NextCellData, // former f(2)
  ActCell, // former g
  StoredCell, // former i
  ActDir: TValues; // former s
  DirCount: TValues = 0; // former f(1)
  // j become redundand !

begin
  Randomize;  // This one is defitly usefull but wasn't in the original code
  Labyrinth[0] := 2;   // Setze Endpunkt mit Ausgang
  StoredCell := Cg * Ru - 3;  // Anfangspunkt unten rechts
  NextCell := StoredCell;
  Labyrinth[StoredCell] := T1k+8; // Setze Eingang und belegt
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
      PosibDir[ActDir and 3] :=TDir(-1);
      NextCell := Dir[ActDir and 3] + ActCell;
      if ((NextCell >= 0)
        and (NextCell < Cg * Ru)
        and (ActDir <> (NextCell mod Cg))
        and ((ActCellData and T1k) <> (Labyrinth[NextCell] and T1k))) then
      begin
        PosibDir[pp_(DirCount)] := ActDir and 3;
      end;
    end;
    if (DirCount <> 0) then
    begin
    {$ifdef ShowGen}
    TextColor(14);
    TextBackground(1);
    gotoxy((ActCell mod Cg) * 2 + 1, ActCell div Cg + 1);
    Write(copy(Scc, (Labyrinth[ActCell] and $0e) + 1, 2));
    TextBackground(0);
    TextColor(7);
    {$endif}
    ActDir := GetRndDir(Dircount,PosibDir);
    {$ifdef ShowGen}
    gotoxy((ActCell mod Cg) * 2 + 1, ActCell div Cg + 1);
    Write(copy(Scc, (Labyrinth[ActCell] and $0e) + 1, 2));
    {$endif}
    end;
    if (DirCount <> 0) and (ActDir<=3) then
    begin
//      ActDir := GetRndDir(Dircount,PosibDir);  // Calc Destination Cell
      NextCell := Dir[ActDir] + ActCell;
      // Remove Wall between Cells
      Labyrinth[ActCell] := ActCellData or 1 shl ActDir;
      Labyrinth[NextCell] := Labyrinth[NextCell] or T1k or (1 shl ((ActDir + 2) mod 4));
      // Push Cell to the Fifo
      if dircount>1 then
        Fifo[pp_(FifoPushIdx)] := ActCell;
    end
    else
    begin
      // Pop Cell from the Fifo
      if FifoPushIdx >= FifoPopIdx then
         NextCell :=  Fifo[pp_(FifoPopIdx)];
    end;
    {$ifdef ShowGen}
    gotoxy((ActCell mod Cg) * 2 + 1, ActCell div Cg + 1);
    Write(copy(Scc, (Labyrinth[ActCell] and $0e) + 1, 2));
    TextColor(9);
    for Idx := FifoPopIdx+1 to FifoPushIdx-1 do
      begin
        gotoxy((Fifo[Idx] mod Cg) * 2 + 1, Fifo[Idx] div Cg + 1);
        Write(copy(Scc, (Labyrinth[Fifo[Idx]] and $0e) + 1, 2));
      end;
    TextColor(10);
    gotoxy((Fifo[FifopopIdx] mod Cg) * 2 + 1, Fifo[FifopopIdx] div Cg + 1);
    Write(copy(Scc, (Labyrinth[Fifo[FifopopIdx]] and $0e) + 1, 2));
    TextColor(7);
    sleep(30);
    {$endif}
  end;
  {$ifdef ShowGen}
  gotoxy(1, 1);
  {$endif}
  // Output Routine
  // Write the top-row separately
  Wout(6);
  for ActCell := 1 to Cg-1 do
    Wout(4);
  // Write the rest
  Wout(9);
  for ActCell := 1 to Ru do
  begin
    for NextCell := 1 to Cg do
    begin
      wout(Labyrinth[pp_(LabOutIdx)] and 6);
    end;
   wout(8); // Write the last column and the linebreak separately
  end;
 {$IFDEF WaitAtEnd}
  readln;
 {$ENDIF}
end;

end.
