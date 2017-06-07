unit unt_DEBUG;

interface

var StackTiefe:longint;
    debug:text;

procedure getmem(var pp:pointer;size:word);
procedure FreeMem(var Pp: Pointer; Size: Word);

implementation

type PList=^TList;
     TList=record
              pn:pointer;
              sz:word;
              next:PList;
           end;

var List:PList; 

procedure getmem(var pp:pointer;size:word);

var p:PList;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'GetMem: Start');
  {$endif}
  system.getmem(pp,size);
  new (p);
  with p^ do
    begin
      pn:=pp;
      sz:=size;
      next:=List;
    end;
  List:=p;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'getMem(',longint(pp),',',Size,')');
  writeln(debug,StackTiefe:4,'  ->    (',longint(list^.pn),',',list^.Sz,')');
  writeln(debug,StackTiefe:4,'GetMem: Ende');
  dec(Stacktiefe);
  {$endif}
end;

procedure FreeMem(var Pp: Pointer; Size: Word);

var p,q:PList;

begin
  {$ifdef debug}
  inc(Stacktiefe);
  writeln(debug,StackTiefe:4,'FreeMem: Start');
  writeln(debug,StackTiefe:4,'FreeMem(',longint(pp),',',Size,')');
  {$endif}
  if (List=nil) then
    writeln (debug,'DebugUnt:Freemem - Aufrufsfehler')
  else
    begin
      p:=List;
      q:=nil;
      while (p <> nil) and (p^.pn<>pp) do
        begin
          q:=p;
          p:=p^.next;
        end;
      if p<>nil then
        begin
          if p^.sz <> size then
            writeln (debug,'DebugUnt:Freemem - Größenfehler');
          system.freemem(pp,p^.sz);
          if q <> nil then
            q^.next:=p^.next
          else
            List:=p^.next;
          dispose(p);
        end
      else
        writeln (debug,'DebugUnt:Freemem - Pointerfehler');
    end;
  {$ifdef debug}
  writeln(debug,StackTiefe:4,'FreeMem: Ende');
  dec(Stacktiefe);
  {$endif}
end;

var i:byte;
    s:String;
    exitp:pointer;
    b,sl:Longint;
    p:PList;
    
initialization
  assign (debug,'nul');
  rewrite(debug);
  if paramcount >0 then
    for i:=1 to paramcount do
      begin
        s:=paramstr(i);
        if s[1]='/' then
          case upcase(s[2]) of
            'L':begin
                  close(debug);
                  assign (debug,copy (s,3,length(s)-2));
                  rewrite (debug);
                  writeln(debug,'Debugunt: Parameter "L" erstelle LOG-Datei')
                end;
          end;
      end;
  List:=nil;
  writeln(debug,'DebugUnt.PAS v:1.02 eingebunden');
  StackTiefe:=0;
finalization
  writeln (debug,stacktiefe:4,'DebugUnt: EXIT: Start');
  flush(debug);
  sl:=0;
  b:=0;
  p:=list;
  if p<>nil then writeln (debug,'DebugUnt: freizugebende Bereiche: ');
  while p<>nil do
    begin
      WriteLn(debug,'DebugUnt: Bereich bei (',longint(p^.pn),') mit ',p^.sz,
              ' Bytes )');
      inc(b);
      sl:=sl+p^.sz;
      p:=p^.next;
    end;
  if sl<>0 then
    begin
      writeln (debug,'DebugUnt: ',s,' Bytes zusätzlich freizugegeben in');
      writeln (debug,'DebugUnt: ',b,' Bereichen !!! ');
      flush(debug);
    end;
  p:=list;
  while p<>nil do
    begin
      system.Freemem(p^.pn,p^.sz);
      WriteLn(debug,'DebugUnt: Bereich bei (',longint(p^.pn),') mit ',p^.sz,
              ' Bytes freigegeben');
      flush (debug);
      p:=p^.next;
      dispose(list);
      list:=p;
    end;
  exitproc:=exitp;
  writeln (debug,'DebugUnt: EXIT - Ausgeführt');
  close(debug);
end.
