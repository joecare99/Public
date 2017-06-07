unit Unt_MemoUnit {Allgemeiner Notitzblock };
{*e Notitzblock}

interface

{$ifdef debug}
uses win32crt,debugunt;
{$endif}

type MemoStr=string[81];
     MemoTZ=^memoT;
     MemoT=record
             first,next:LongInt;
             data:MemoStr;
           end;

     Memofile=record
               start,free:longint;
               p:Memotz;
               fs:longint;
               f:file;
             end;

var MemoF:Memofile;

{ Dateioperationen }

function MemoOpen (var f:Memofile;str:string):integer;
procedure MemoNewFile(var f:MemoFile;name:string;comment:string);
procedure MemoClose (var f:MemoFile);

{ Verwaltung }

procedure MemoNew(var F:MemoFile;var Nr:longint;str:string);
procedure MemoAdd(var F:MemoFile;SNr:longint;str:string);
procedure MemoChange(var F:MemoFile;SNr:longint;str:string);
procedure MemoDelete(var F:MemoFile;SNr:longint;str:string);

{ Abfrage }

Function MemoInitList(var F:MemoFile;Nr:LongInt):string;
Function MemoGetNext(var Snr:longint):string;

implementation

const datasize=sizeof(memoT);

var listfile,
    actuell:^MemoFile;
    strpuffer:MemoStr;
    listnext:longint;

{DiskProceduren }

{$ifdef debug}
const Fehler:string ='Fehler bei Dateizugriff';
{$endif}

function MemoOpen (var f:Memofile;str:string):integer;

var res:integer;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoOpen: Start');
  {$endif}
  {$i-}
  assign(f.f,str);
  reset(f.f,8);
  res:=ioresult;
  {$i+}
  if res = 0 then
    begin
      blockread(f.f,f,1);
      getmem(pointer(f.p),datasize);
      reset(f.f,datasize);
      f.fs:=filesize(f.f);
    end ;
  MemoOpen:=res;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoOpen: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure MemoNewFile(var f:MemoFile;name:string;comment:string);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoNewFile: Start');
  {$endif}
  {$i-}
  getmem(Pointer(f.p),datasize);
  assign(f.f,name);
  f.start:=0;
  f.free:=0;
  move (f,f.p^,8);
  if length(Comment) >datasize-10 then
    comment[81]:=#26
  else
    Comment[length(comment)+1]:=#26;
  f.p^.data:=comment;
  rewrite(f.f,datasize);
  blockwrite(f.f,f.p^,1);
  reset(f.f,datasize-8);
  f.fs:=1;
  {$i+}
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoNewFile: Start');
  dec(Stacktiefe);
  {$endif}
end;

procedure MemoClose (var f:MemoFile);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoClose: Start');
  {$endif}
  close(f.f);
  freemem(Pointer(f.p),datasize);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoClose: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure MemoRead (el:longint);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoRead(',el,')');
  writeln(debug,StackTiefe:4,'MemoRead: Start');
  flush (output);
  {$endif}
  seek(actuell^.F,el);
  BlockRead(actuell^.F,actuell^.p^,1);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoRead: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure MemoWrite (el:longint);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoWrite(',el,')');
  writeln(debug,StackTiefe:4,'MemoWrite: Start');
  flush(output);
  {$endif}
  seek(actuell^.F,el);
  blockwrite(actuell^.F,actuell^.P^,1);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoWrite: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure GetMemo (element:LongInt;var wert:Memostr);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'GetMemo(',element,',Data)');
  writeln(debug,StackTiefe:4,'GetMemo: Start');
  {$endif}
  if element<= actuell^.fs then
  begin
  MemoRead (element);
  move (actuell^.p^.data,wert,datasize-8);
  {$ifdef debug}
  {$endif}
  end
  else
    begin
      fillchar(wert,datasize-8,0) ;
  {$ifdef debug}
      Writeln (StackTiefe:4,Fehler);
  {$endif}
    end;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'GetMemo: wert:=',wert);
  writeln(debug,StackTiefe:4,'GetMemo: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure setMemo (element:LongInt;wert:memoStr);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'SetMemo(',element,',',wert,')');
  writeln(debug,StackTiefe:4,'SetMemo: Start');
  {$endif}
  MemoRead (element);
  move (wert,actuell^.P^.data,datasize-8);
  MemoWrite (element);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'SetMemo: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure setnextMemo (element,next:LongInt);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'SetNextMemo: (',element,',',next,')');
  writeln(debug,StackTiefe:4,'SetNextMemo: Start');
  {$endif}
  MemoRead (element);
  actuell^.p^.next:=next;
  MemoWrite (Element);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'SetNextMemo: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure setFirstMemo (element,first:LongInt);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'SetFirstMemo: (',element,',',first,')');
  writeln(debug,StackTiefe:4,'SetFirstMemo: Start');
  {$endif}
  MemoRead (Element);
  actuell^.p^.first:=first;
  MemoWrite (Element);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'SetFirstMemo: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure DisposeElement(var element:LongInt);

var free:longint;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'DisposeElement: (',element,')');
  writeln(debug,StackTiefe:4,'DisposeElement: Start');
  {$endif}
  free:=actuell^.free;
  setnextMemo(0,element);
  actuell^.p^.next:=free;
  actuell^.p^.first:=-1;
  fillchar(actuell^.p^.data,datasize-8,0);
  MemoWrite(element);
  actuell^.free:=element;
  element:=-1;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'DisposeElement: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure NewElement(var element:LongInt);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'NewElement: Start');
  {$endif}
  if actuell^.free <> 0 then
    begin
      element:=actuell^.free;
      MemoRead(element);
      actuell^.free:=actuell^.p^.next;
      MemoRead(0);
      actuell^.p^.next:=actuell^.free;
      MemoWrite(0);
    end
  else
    begin
      inc(actuell^.fs);
      element:=filesize(actuell^.f);
      MemoWrite(element);
      close(actuell^.f);
      reset(actuell^.f,datasize);
    end;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'NewElement: Neues Element:=',Element);
  writeln(debug,StackTiefe:4,'NewElement: Ende');
  dec(Stacktiefe);
  {$endif}
end;

{----------------------------------------------}

procedure MemoNew(var F:MemoFile;var Nr:longint;str:string);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoNew: (MemoF,Nr,',str,')');
  writeln(debug,StackTiefe:4,'MemoNew: Start');
  {$endif}
   actuell:=@f;
   NewElement(nr);
   actuell^.p^.data:=Str;
   actuell^.p^.next:=-1;
   actuell^.p^.first:=nr;
   MemoWrite (nr);
   f:=actuell^;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoNew: Neue Nummer := ',nr);
  writeln(debug,StackTiefe:4,'MemoNew: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure MemoAdd(var F:MemoFile;SNr:longint;str:string);

var hp:MemoTZ;
    nr:longint;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoAdd: (memoF,',Snr,',"',str,'")');
  writeln(debug,StackTiefe:4,'MemoAdd: Start');
  {$endif}
   getmem (Pointer(hp),datasize);
   actuell:=@f;
   memoread(SNr);
   move(actuell^.p^,hp^,datasize);
   NewElement (nr);
   if (listfile=actuell) and (listnext=hp^.next) then
     listnext:=nr;
   actuell^.p^.next:=hp^.next;
   actuell^.p^.first:=hp^.first;
   actuell^.p^.data:=Str;
   MemoWrite(nr);
   move(hp^,actuell^.p^,datasize);
   actuell^.p^.next:=nr;
   MemoWrite(SNr);
   f:=actuell^;
   Freemem (pointer(hp),datasize);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoNew: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure MemoChange(var F:MemoFile;SNr:longint;str:string);

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoChange: (memoF,',Snr,',"',str,'")');
  writeln(debug,StackTiefe:4,'MemoChange: Start');
  {$endif}
   actuell:=@f;
   Memoread(Snr);
   actuell^.p^.data:=Str;
   Memowrite(Snr);
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoChange: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure MemoDelete(var F:MemoFile;SNr:longint;str:string);

var nr:longint;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoDelete: (memoF,',Snr,',"',str,'")');
  writeln(debug,StackTiefe:4,'MemoDelete: Start');
  {$endif}
   actuell:=@f;
   nr:=snr;
   Memoread(SNr);
   {$ifdef debug}
   writeln(debug,StackTiefe:4,'MemoDelete: Prüfe ob Element ',Snr,
           ' einen Nachfolger hat');
   {$endif}
   if actuell^.p^.next<>-1 then
     begin
       nr:=actuell^.p^.next;
       {$ifdef debug}
       writeln(debug,StackTiefe:4,'MemoDelete: Element ',nr,' auf Element ',Snr,
               ' kopieren');
       {$endif}
       MemoRead(nr);
       Memowrite(Snr);
     end
   else
     if actuell^.p^.first<>SNr then
       begin
         {$ifdef debug}
         writeln(debug,StackTiefe:4,'MemoDelete: Suche Vorgönger von Element',snr);
         {$endif}
         if (listfile=actuell) and (listnext=snr) then
           listnext:=-1;
         snr:=actuell^.p^.first;
         MemoRead(snr);
         while actuell^.p^.next<>nr do
           begin
             snr:=actuell^.p^.next;
             MemoRead(snr);
           end;
         actuell^.p^.next:=-1;
         MemoWrite(snr);
       end;
   {$ifdef debug}
   writeln(debug,StackTiefe:4,'MemoDelete: Element (',nr,') löschen');
   {$endif}
   disposeElement(nr);
   f:=actuell^;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoDelete: Ende');
  dec(Stacktiefe);
  {$endif}
end;


Function MemoInitList(var F:MemoFile;Nr:LongInt):string;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoInitList: Start');
  {$endif}
   listfile:=@f;
   actuell:=listfile;
   memoread(nr);
   memoinitlist:=listfile^.p^.data;
   listnext:=listfile^.p^.next;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoInitList: Ende');
  dec(Stacktiefe);
  {$endif}
end;

Function MemoGetNext(var Snr:longint):string;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'MemoGetNext(MFile,',Snr,')');
  writeln(debug,StackTiefe:4,'MemoGetNext: Start');
  {$endif}
   actuell:=listfile;
   sNr:=listnext;
   if snr > 0 then
     begin
       memoread (snr);
       memoGetNext:=listfile^.p^.data;
       if listfile^.p^.data = '' then
         memoGetNext:=' ';
       listnext:=listfile^.p^.next
     end
   else
     begin
       {$ifdef debug}
       if listnext=0 then
         writeln(debug,StackTiefe:4,'MemoGetNext: Fehler !!!! ',
                 'Zuerst MemoInitList aufrufen');
       {$endif}
       memoGetNext:='';
       listnext:=0;
     end;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'MemoGetNext: Ende');
  dec(Stacktiefe);
  {$endif}
end;

begin
  {$ifdef debug}
  listnext:=0;
  writeln(debug,'MemoUnit.PAS v0.92 eingebunden');
  {$endif}
end.

