Unit Unt_iopcc;{$mode delphi}{$H+}Interface Procedure Main;Implementation {$define _}
Type Z=Integer;Y=0..3;Const X=1024;W=39;V=22;T='|_|  _  |';L:Array[Y]Of Z=(0,-3,W
-1,-1);H:Array[Y]Of Z=(1,W,-1,-W);Var M:Array[0..X]Of Z;Function P(Var A:Z):Z;Begin
P:=A;Inc(A);End;Procedure Q(A:Z);Begin Write(Copy(T+LineEnding,A+1,2+A Div 8));End
;Procedure Main;Var U:Z=0;N:Array[0..X]Of Z;A:Array[Y]Of Z;D:Z=0;B:Z=0;C,E,G,I,S:
Z;F:Z=0;Begin Randomize;M[0]:=8;I:=W*V-1;E:=I;M[I]:=X+2;While(F<>0)Or(B>=D)Do Begin
G:=I;I:=E;C:=M[G];F:=0;For S In L Do Begin E:=H[S And 3]+G;If((E>=0)And(E<W*V)And
(S<>(E Mod W))And((C And X)<>(M[E]And X)))Then Begin A[P(F)]:=S;End;End;If(F<>0)Then
Begin S:=A[Random(F)]And 3;E:=H[S]+G;M[G]:=C Or 1 Shl S;M[E]:=M[E]Or X Or(1 Shl((
S+2)Mod 4));N[P(B)]:=E;End Else Begin If B>=D Then E:=N[P(D)];End;End;Q(6);For G:=
1 To W-1 Do Q(4);Q(9);For G:=1 To V Do Begin For E:=1 To W Do Begin Q(M[P(U)]And
6);End;Q(8);End;{$IFDEF _}Readln;{$ENDIF}End;End.








































































































