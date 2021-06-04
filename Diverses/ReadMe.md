# Diverses

## Some IOPCC participants

Guess what this does:
```pascal
Unit Unt_iopcc;    {$mode         delphi}{$H+}        Interface      Procedure     Main;
Implementation   {$define _}    type L=integer      ;I=0..3;const   Z=1 shl 11;    U=$13
shl        1+1;  O=U     and    -U;D               =O shl          (O shl    O +   O);C=
' _|'      ;B=  $597B     ;l0:  array              [I]of           L=(0,     -3,U  -O,-O)

;lQ:array[I]    of L= (O,U,-O,  -U);var E:array    [0..Z]          of L; function  H(var
Q:L):L;begin    H:= Q; Inc (Q)    ;end;procedure   Q(U:L);         begin if U < D  then

Write           (C[B       shr              (H(U)  shl 1)          and       3]+C  [B shr
( U             shl         1)              and 3   ])else         Write     (Copy  (C+C+C+LineEnding,
U+O,            3));      end;   {!} Procedure       Main;  {!!!}  var        ll:  array[0.. Z] of L;
// #            This        is     Just an Dum-       my Comment   to ~      fill  the Gaps ********


                                         Hel:l=0; //LGPL 2017
                                         Wor:l=d-D; // by Joe

                                          P,A,S,CA:L; //Care
                                          _fe:l=z-z;_C,oo:l;



           l1:array            [I]of L;begin              Randomize;            E[0]:=
        d;CA:=U*U-O;A         :=CA;E[CA]:=Z+2;           while(Wor<>0)          or(_fe
        >=Hel)      do       begin       oO:=0         ;S:=CA      ;CA:=        A;_C:=
        E[S];                Wor:=0      ;for P        in(l0       )  do        begin
        A:=lQ                [P and      3]+S;         if((A       >= 0)        and(A<
        U*U)                 and(P<>     (A mod        U))and      (( _C        and Z)
        <>(E                 [A]and       Z)))         then        begin        l1[ H(
        Wor)                 ]:=P;        end;         end ;       if  (        Wor<>0
        )then                begin        P:=l1[       Random     (Wor)]        and 3;
        A:=lQ                [P]+S        ;E[S]        := _C       or  O        shl P;
        E[A]                 :=E[A]or     Z or(        O shl(      (P+2)        mod 4));ll[H(_fe)]
        :=A;end               else         begin        if _fe     >=Hel        then A:=ll[H(Hel)];
        end;end      ;        Q(d-2);     for S        :=O to     U-O do        Q(D shr O);Q(D+O);
         for S:=O to U          do  begin  for            A:=O to U do          Q(E[H(Oo)]and 6
          );Q(D);end;             {$IFDEF _}                Readln ;            {$ENDIF}End;end.
                                                                            
//         (C)ode an                (O)pen             (O)bjectoriented         (L)anguage !!!!!
```

Or That:
```pascal
       UNIT 
       { ©by
      Joe }
         
     {Care}             unt_iopcc;      interface{$H+}     uses Math;      type    l0=  0..11       ;e={}       integer; 
     {2017}           function M:e;     implementation   const l1:e =      -$CD; {This  Conct       }l3 =     LineEnding;
     ll=$5F           +$EA48A42E8EA4    shl $18+$3 shl   8;lO=$7D8E14D     +$408407080  shl(8      *3);lI    =ll and -ll;
    lQ=lI-           lI;    l=lI shl   lI;I=l shl l;Q   =I-    l-lI;{}    Function M:  e;var       Jo:e=    2017;    Ca,
    
    r:e{}               ;CONST D=#8+        ' \_/';        begin l1+=    Jo;for       Ca in       l0 do    begin Write
    {->}(            StringOfChar(D[       l],(I+Q      )-Ca));for Jo    := lQ        to(I+       I) do     for r in l0 
    do if          r<Q+(Jo mod(I-Q))      and l-0     then Write(D[((   ll xor       lO)div      round      (power(Q,((I
   +lI)*(         I-Q))-   ( ( ( ll      xor l1)     shr(((   ( ( ll    shr((        Jo and      (I+I-        lI))*(Q-lI
  
 )+Ca div(I-Q))) and((       I-Q)-   (Ca div (I+lI  )) shl     lI))    -( Q-        lI)+(l-Ca mod(I-Q))     shl     l)mod
 (Q-lI)+(I-Q))*l )and(l+lI))*(I-lI   )+r)))mod Q)+  lI]);write{##}    ;end;         readln;end;//IS#ONE     #OF#THE#BEST#
 {INTRÈGRATED#-#  DEVELOPMENT AND#   OBJECTPASCAL#  LEARNING #ENV-    IRON-          MENTS# OUT# HERE#      TO#SAY#THE#
#LEAST!!!######   #########  ####   ###}M:=lQ{###   ######  ####     #####            SO#THIS#  #IS##        THE};end.
```
## !!!New!!! Some Quines
a Quine is a program that has it's own (Source-)code as a result. (see Wikipedia)

### Quine 1
```pascal
program Q;const R=#39#44;C:array[0..8]of string=(#39,R,
'0]+C[B*2]+R+C[0]+C[B*2+1]+R);','7]);for B in[1..3]do',
'6]+C[B xor 1])end.','0]+C[8]+C[0]+C[8]);for B IN[2..5]do',
'writeln(C[','program Q;const R=#39#44;C:array[0..8]of string=(#39,R,',
');var B:byte;begin');var B:byte;begin
writeln(C[7]);for B in[1..3]do
writeln(C[0]+C[B*2]+R+C[0]+C[B*2+1]+R);
writeln(C[0]+C[8]+C[0]+C[8]);for B IN[2..5]do
writeln(C[6]+C[B xor 1])end.
```
### Quine 2
This looks more like a pascal program ...
```pascal
program prj_Quine2;
uses SysUtils;
const s='program prj_Quine2;%1:suses SysUtils;%1:sconst s=%0:s;%1:sbegin%1:s  writeln(Format(s,QuotedStr(s),LineEnding))%1:send.';
begin
  writeln(Format(s,[QuotedStr(s),LineEnding]))
end.
```
### Quine 3
Except for the programname this is (my) smallest pascal-quine
```pascal
program Q3;const r=#39;s='program Q3;const r=#39;s=';c=';begin write(s+r+s+r+#59#99#61+r+t+r+t)end.';begin write(s+r+s+r+#59#99#61+r+c+r+c)end.
```
.<br/>
.<br/>
.<br/>
### Quine 9
I like that one, If you don't know it's a Quine it's hard to figure out, what it does. 
```pascal
program Q9;const r=#39;b='*>ydu#g=fkdu>ehjlq#zulwh+f.u.e.u.*>f@*.u.f,>iru#g#lq#e#gr#zulwh+fkdu+e|wh+g,06,,hqg1';c='program Q9;const r=#39;b=';var d:char;begin write(c+r+b+r+';c='+r+c);for d in b do write(char(byte(d)-3))end.
```
### Quine 10
I this one uses something like self-encoding
```pascal
program d.w;var e,d,o,r,b:string;f:int8=-32;begin r:=(#39)+#39;o:=r[1];e:=',+"><1V9212#2k,9:Hk2#292"Z,B#"()(>?(1()#(+"><1V9d+#")V)defZ[BfZ1?)*';b:='program d.w;var e,d,o,r,b:string;f:int8=-32;begin r:=(#39)+#39;o:=r[1];e:=''';write(b,e,o,';b:=',o,b,r);for d in e do write(b[word(d[1])+f])end.
```



