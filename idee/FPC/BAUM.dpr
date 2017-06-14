Program BAUM;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{$apptype Console}

uses
  interfaces,
  forms,
  unt_Allgfunklib ,
  int_Graph ,
  graph ,
//  Unt_TITELM3 in '..\..\Utils\source\TitelM\Unt_TITELM3.pas',
  Unt_Baum in '..\grafik\Unt_Baum.pas';

{$E EXE}


Var
  grk, grm, maxt: integer;
  faktor:real;

{$R *.res}

Begin
  grk := 0;
//  titel (50,50,triplexfont,'Bäume wie echt');
//  titel (200,200,GOTHICFONT,'also echt, wie echt !!!');
//  titel (125,0,GOTHICFONT,'un'' wenn''s net glaubst...');
//  titel (350,250,GOTHICFONT,'gug selbst !!!');
//  restorecrtmode;
  write('Welche Tiefe (2-14) : ');
  readln(maxt);
  write('Welcher Faktor (0.1-0.99) : ');
  readln(faktor);
  initgraph(grk, grm, bgipath);
  DoBaumDraw(grm,maxt,faktor,0);
{  setactivepage(page);
  page:=(page+1) mod 2;
  setvisualpage(page);
  cleardevice;
  drawbgr;
}
  Repeat
  Until keypressed;
  restorecrtmode;
  readln;
End.
//;

