Unit Frm_Chart2Main;

Interface

Uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, sysutils, cls_2DIndex;

Type
  tChartNode = Class(Tobject)
    Gender : Boolean; (* male *)
    GivenName: String;
    Name: String;
    Info: String;
    C:array of tChartNode; //Child-Node
    sp:array of tChartNode; //Spouse-Node
    F: tChartNode;  //Father-Node
    M: tChartNode;  //Mother-Node
    next,           // Next-Node
    previl,
    nextil: tChartNode;

    Birth: TTimestamp;
    Marriage: TTimestamp;
    Death: TTimestamp;
    // visual
    idx,
    Level, Pnr, Weight: integer;
    fX,fY,fZ:double;
    mX,mY,mZ:double;
    Destructor Destroy; Override;
  End;

Type

  { TSDIAppForm }

  TSDIAppForm = Class(TForm)
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    btnFileNew: TToolButton;
    btnFileOpen: TToolButton;
    btnFileSave: TToolButton;
    btnSep1: TToolButton;
    btnEditCut: TToolButton;
    btnEditCopy: TToolButton;
    btnEdtPaste: TToolButton;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    btnGenerate: TButton;
    btnOptimize: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnOptimizeClick(Sender: TObject);
    Procedure FileNew1Execute(Sender: TObject);
    Procedure FileOpen1Execute(Sender: TObject);
    Procedure FileSave1Execute(Sender: TObject);
    Procedure FileExit1Execute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    Procedure HelpAbout1Execute(Sender: TObject);
    Procedure btnGenerateClick(Sender: TObject);
    Procedure btnShow2Click(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormCreate(Sender: TObject);
  Private
    FMaxLevel: Integer;
    F2dIndex:TwoDIndex;
    { Private-Deklarationen }
    Ftree: tChartNode;
    FNodes: array of tChartNode;
    XMul2: Double;
    YMul2: Double;

    function CreateNode:tChartNode;
    Function FindNearNode(aTree: tChartNode; X, Y: integer): tChartNode;
    procedure MoveNodes(const Node: tChartNode);
    procedure ShowBranch2(Node2, Node1: tChartNode);
    procedure ShowTree2;

  Public
    Procedure CalcTree(Node: tChartNode);
    { Public-Deklarationen }
  Published
//    Procedure ShowNode(Node: tChartNode);
    Procedure ShowNode2(Node: tChartNode);
  End;

Var
  SDIAppForm: TSDIAppForm;

Implementation

Uses frm_about, Unt_Allgfunklib, Math;

{$ifdef FPC}
{$R *.lfm}
{$ELSE ~FPC}
{$R *.lfm}
{$ENDIF ~FPC}

Const
  Lastnames: Array [0 .. 38] Of String = ('Adams', 'Abrams', 'Bechtle',
    'Becker', 'Caspar', 'Cuntzmann', 'Danzeisen', 'Daubentaler', 'Debinger',
    'Dietrich', 'Doll', 'Ebert', 'Eck', 'Edel', 'Eisenmann', 'Esser',
    'Faber', 'Fels', 'Fissler', 'Folz', 'Furrer', 'Ganz','Gebbert','Giesler','Goos','Gugler',
    'Habeck','Heckt','Hiller','Holl', 'Hutter','Ihrig','Ignatz','Isamann','Jahnosch',
    'Jeremias','Jiehl','Jogler','Just');

  GivennamesM: Array [0 .. 25] Of String = ('Adam', 'Bernd', 'Christian',
    'Dietrich', 'Emil', 'Friedrich', 'Gustav', 'Hans', 'Ingmar', 'Jürgen',
    'Karl', 'Ludwig', 'Martin', 'Norbert', 'Otto', 'Paul', 'Quint', 'Robert',
    'Samuel', 'Tim', 'Uwe', 'Viktor', 'Wolfgang', 'Xaver', 'Yrs', 'Zacharias');

  GivennamesF: Array [0 .. 25] Of String = ('Anne', 'Bertha', 'Christiene',
    'Doris', 'Elsa', 'Friederike', 'Gertrud', 'Hanne', 'Ida', 'Julia',
    'Katharina', 'Lena', 'Mina', 'Nicole', 'Ottilie', 'Paula', 'Quane', 'Ruth',
    'Salome', 'Trude', 'Ursula', 'Vivien', 'Wilma', 'Xena', 'Yvonne', 'Zalua');

  XOffset = 20;
  YOffset = 40;
  XMul = 5;
  YMul = 40;

procedure GetValProc(obj: Tobject; out val1, val2: double);
begin
  val1:= TChartNode(obj).fX;
  val2:= TChartNode(obj).fY;
end;

procedure TSDIAppForm.FileNew1Execute(Sender: TObject);
Begin
  { Nichts ausführen }
End;

procedure TSDIAppForm.btnOptimizeClick(Sender: TObject);
var
  I: Integer;
begin
//  For I := 1 To 150 Do
  MoveNodes(Ftree);
//  canvas.FillRect(canvas.ClipRect);
  ShowTree2;
end;

procedure TSDIAppForm.FileOpen1Execute(Sender: TObject);
Begin
  OpenDialog.Execute;
End;

procedure TSDIAppForm.FileSave1Execute(Sender: TObject);
Begin
  SaveDialog.Execute;
End;

procedure TSDIAppForm.FormCreate(Sender: TObject);
begin
  Ftree := nil;
end;

function TSDIAppForm.CreateNode: tChartNode;
begin
  result := tChartNode.Create;
  setlength(FNodes,high(Fnodes)+2);
  result.idx:=high(Fnodes);
  Fnodes[result.idx] := result;
end;

procedure TSDIAppForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);


   Function Bericht(n:TChartnode):String;
     var
       g: tChartNode;
     begin
       result := 'Name:  '+n.GivenName + ' ' + n.Name;
       result += LineEnding+ 'Geb:  '+DateTimeToStr(TimeStampToDateTime(n.Birth));
       // Eltern
       if assigned(n.f) then
         result += LineEnding+ 'Vater:  '+n.F.GivenName + ' ' + n.F.Name+' geb: '+DateTimeToStr(TimeStampToDateTime(n.f.Birth));
       if assigned(n.m) then
         result += LineEnding+ 'Mutter: '+n.m.GivenName + ' ' + n.m.Name+' geb: '+DateTimeToStr(TimeStampToDateTime(n.m.Birth));
       // Voll-Geschwister
       if assigned(n.m) then
         for g in n.m.c do
           begin
           if (g <> n) and (g.f = n.f) then
             result += LineEnding+ '-: '+g.GivenName + ' ' + g.Name+' geb: '+DateTimeToStr(TimeStampToDateTime(g.Birth))
           end
       else if assigned(n.f) then
         for g in n.f.c do
           if (g <> n) and (g.m = n.m) then
             result += LineEnding+ '-: '+g.GivenName + ' ' + g.Name+' geb: '+DateTimeToStr(TimeStampToDateTime(g.Birth));
       // Ehepartner
       for g in n.sp do
           result += LineEnding+ 'Partner: '+g.GivenName + ' ' + g.Name+' geb: '+DateTimeToStr(TimeStampToDateTime(g.Birth));
       // Ehepartner
       for g in n.c do
           result += LineEnding+ 'Kind: '+g.GivenName + ' ' + g.Name+' geb: '+DateTimeToStr(TimeStampToDateTime(g.Birth));
     end;

var
  I: integer;
  Nearnode, oldN: tChartNode;
begin
  oldN := Ftree;
  Nearnode := FindNearNode(Ftree, X, Y);
  if assigned(ftree) and (Nearnode <>ftree) then
    begin
      Ftree := Nearnode;
      ShowNode2(oldn);
      ShowNode2(Ftree);
    end;
  if assigned(Nearnode) and (Nearnode <>oldN) then
    begin
      Label1.caption := 'Name: '+Nearnode.GivenName + ' ' + Nearnode.Name;
      Label2.caption := 'Geb:  '+DateTimeToStr(TimeStampToDateTime(nearnode.Birth));

(*
      Label3.caption := 'X:'+inttostr(Nearnode.x);
      if assigned(Nearnode.f) then
        Label3.caption := Label3.caption+', F.x:'+IntToStr(Nearnode.F.X);
      if assigned(Nearnode.m) then
        Label3.caption := Label3.caption+ ', M.x:'+inttostr(Nearnode.m.x);
      if assigned(Nearnode.previl) then
        Label3.caption := Label3.caption+ ', P.x:'+inttostr(Nearnode.previl.x);
      if assigned(Nearnode.nextil) then
        Label3.caption := Label3.caption+ ', N.x:'+inttostr(Nearnode.nextil.x);
      if assigned(Nearnode.c) then
        Label3.caption := Label3.caption+ ', C.x:'+inttostr(Nearnode.C[0].x);
*)

      label4.Caption := bericht(Nearnode);
    end;
end;

procedure TSDIAppForm.FormPaint(Sender: TObject);
begin
  canvas.FillRect(canvas.ClipRect);

  ShowTree2;

end;

procedure TSDIAppForm.FormResize(Sender: TObject);
Begin
  XMul2 := Width-XOffset*2;
  YMul2 := Label1.top-YOffset;

  canvas.FillRect(canvas.ClipRect);

  ShowTree2;
End;

procedure TSDIAppForm.btnGenerateClick(Sender: TObject);

  Function Timestamp(year, Month, day: integer): TTimestamp;
  Begin
    result := datetimetotimestamp(EncodeDate(year, Month, day));
  End;

  Procedure filltreenode(tn: tChartNode; ngender: boolean; chts: TTimestamp;
    sps: tChartNode);
  Begin
    If assigned(tn) Then
      With tn Do
        Begin
          gender := ngender;
          If gender Then
            GivenName := GivennamesM[random(High(GivennamesM) + 1)]
          Else
            GivenName := GivennamesF[random(High(GivennamesF) + 1)];
          If assigned(sps) Then
            Begin
              Marriage := sps.Marriage;
              Name := Lastnames[random(High(Lastnames) + 1)];
              Birth.Date := Marriage.Date - 365 * 18 - random(2000);
              if length(tn.sp) = 0 then
                begin
                  setlength(tn.sp,high(tn.sp)+2);
                  tn.sp[high(tn.sp)] := sps;
                  setlength(sps.sp,high(sps.sp)+2);
                  sps.sp[high(sps.sp)] := tn;
                end;
            End
          Else
            Begin
              Marriage.Date := chts.Date - 300 - random(400);
              Birth.Date := Marriage.Date - 365 * 18 - random(2300);
            End;

        End;
  End;

   Procedure filltreeChild(tn,pt: tChartNode);
  Begin
    If assigned(tn) Then
      With tn Do
        Begin
          gender := random(2) = 0;
          If gender Then
            GivenName := GivennamesM[random(High(GivennamesM) + 1)]
          Else
            GivenName := GivennamesF[random(High(GivennamesF) + 1)];
          If assigned(pt) Then
            Begin
              Birth.Date := pt.Marriage.Date + 365 + random(2300);
              Marriage.Date := birth.Date + 365 * 20 + random(2300);
            End
        End;
  End;

  Procedure filltreeSpouse(tn,spt: tChartNode);
  Begin
    If assigned(tn) Then
      With tn Do
        Begin
          gender := not spt.Gender;
          Name := Lastnames[random(High(Lastnames) + 1)];
          If gender Then
            begin
              GivenName := GivennamesM[random(High(GivennamesM) + 1)];
              Birth.Date := spt.Birth.Date - 365*6 + random(365*5);
              Marriage.Date := spt.Birth.Date + 365*20 - random(365*5);
              if spt.Marriage.Date = 0 then
                 spt.Marriage := Marriage;
            end
          Else
            begin
              GivenName := GivennamesF[random(High(GivennamesF) + 1)];
              Birth.Date := spt.Birth.Date + 365*6 - random(365*5);
              Marriage.Date := Birth.Date + 365*20 - random(365*5);
              if spt.Marriage.Date = 0 then
                 spt.Marriage := Marriage;
            end
        End;
  End;


  Procedure FillParents(t: tChartNode;m:integer=3);
  Begin
    if m and 1<>0 then
      begin
        t.F := CreateNode;
        t.F.Name := t.Name;
        setlength(t.f.C,1);
        t.F.C[0] := t;
        filltreenode(t.F, true, t.Birth, t.M);
      end;
    if m and 2<>0 then
      begin
        t.M := CreateNode;
        if not assigned(t.F) then
          t.M.Name:=t.Name;
        setlength(t.M.C,1);
        t.M.C[0] := t;
        filltreenode(t.M, false, t.Birth, t.F);
      end;
  End;

  Procedure AddChild(p,sp: tChartNode);
  var
    c,m,f: tChartNode;
  Begin
    c := CreateNode;
    if p.Gender then
      begin
        m:=p;
        f:= sp;
      end
    else
    begin
      f:=p;
      m:= sp;
    end;
    if assigned(F) then
      begin
        setlength(F.C,high(F.C)+2);
        F.C[high(F.C)] := c;
        c.F := F;
        c.Name := F.Name;
        filltreeChild(C, F);
      end;
    if assigned(M) then
      begin
        setlength(M.C,high(M.C)+2);
        M.C[high(M.C)] := c;
        c.M := M;
        if c.Name = '' then
          c.Name := M.Name;
        filltreeChild(C, M);
      end;
  End;

  Procedure AddSpouse(t: tChartNode);
  var
    c: tChartNode;
  Begin
    c := CreateNode;
    if assigned(t) then
      begin
        setlength(t.sp,high(t.sp)+2);
        t.sp[high(t.sp)] := c;
        setlength(c.sp,high(c.sp)+2);
        c.sp[high(c.sp)] := t;
        filltreeSpouse(C, t);
      end;
  End;

Var
  n, p: tChartNode;
  I: integer;
  r: Int64;
Begin
  for i := high(FNodes) downto 0 do
     freeandnil(Fnodes[i]);
  setlength(FNodes,0);
  freeandnil(F2dIndex);
  randomize;
//  RandSeed:=2;

  Ftree := CreateNode;
  Ftree.Name := Lastnames[random(High(Lastnames) + 1)];
  filltreenode(Ftree, random(2) = 0, Timestamp(1900, 4, 3), Nil);
  FillParents(Ftree);
  FillParents(Ftree.F);
  FillParents(Ftree.M);
  F2dIndex:=TwoDIndex.Create(0,1,0,1,1000);
  F2dIndex.GetIdxValuesProc:=@GetValProc;
  // Append Relatives
  For I := 0 To 1000 Do
    Begin
      n := Ftree;
      // Walk the path
      While n <> Nil Do
        Begin
          p := n;
          r := random(9);
          case r of
            0..2: n := n.F;
            3..5: n := n.M;
            6..7: if (length(n.c)> 1) and (sqrt(random) > 1/length(n.c)) then
              n := n.c[random(length(n.c))]
             else
              n := nil; // new Child
            8: if length(n.sp)> 0 then
              n := n.sp[random(length(n.sp))]
             else
              n := nil;
          end;
        End;

      case r of
        0..2: FillParents(p,1);
        3..5: FillParents(p,2);
        6..7: if  length(p.sp) >=1 then
          AddChild(p,p.sp[random(length(p.sp))])
          else
            AddChild(p,nil);
        8: AddSpouse(p);
      end;
    End;
  CalcTree(Ftree);
  canvas.FillRect(canvas.ClipRect);
  ShowTree2;
End;


function GetVal(const obj:Tobject):double;
begin
  result:= tChartNode(obj).fX;
end;

procedure TSDIAppForm.btnShow2Click(Sender: TObject);
var
  i: Integer;
begin
//    For I := 1 To 15 Do
//   if False then
     MoveNodes(Ftree);

  Sort_Bubblesort(TAoO(Fnodes),@GetVal);

  for i:=  0 to  high(FNodes) do
    begin
      FNodes[i].fx := i / high(Fnodes) ;
      F2dIndex.MoveObject(FNodes[i],i);
    end;

  ShowTree2;
end;

procedure TSDIAppForm.CalcTree(Node: tChartNode);

  var
    s: tChartNode;
    minb, maxb: TTimeStamp;
    i: Integer;

Begin
    if high(FNodes)>= 0 then
      begin
        minb := FNodes[0].Birth;
        maxb := FNodes[0].Birth;
        FNodes[0].fx := 0;
      end;
    for i := 1 to high(FNodes) do
      begin
        if (minb.Date > FNodes[i].Birth.Date) and  (FNodes[i].Birth.Date>15000) then
          minb := FNodes[i].Birth;
        if maxb.Date < FNodes[i].Birth.Date then
          maxb := FNodes[i].Birth;
        FNodes[i].fx := i / high(Fnodes);
      end;

    for i := 0 to high(FNodes) do
      begin
         FNodes[i].fy := (FNodes[i].Birth.Date - minb.date)/(maxb.Date-minb.Date);
         F2dIndex.AppendObject(FNodes[i],i);
      end;

//  For I := 1 To 15 Do
//   if False then
     MoveNodes(Node);
(*
  Sort_Bubblesort(TAoO(Fnodes),@GetVal);

  for i:=  0 to  high(FNodes) do
      FNodes[i].fx := i / high(Fnodes) ;

  For I := 1 To 150 Do
//   if False then
     MoveNodes(Node);

  Sort_Bubblesort(TAoO(Fnodes),@GetVal);

  for i:=  0 to  high(FNodes) do
      FNodes[i].fx := i / high(Fnodes) ;

  For I := 1 To 150 Do
//   if False then
     MoveNodes(Node);

  Sort_Bubblesort(TAoO(Fnodes),@GetVal);

  for i:=  0 to  high(FNodes) do
      FNodes[i].fx := i / high(Fnodes) ;
*)
  // gehe zu M-Tree
  //
End;

procedure TSDIAppForm.FileExit1Execute(Sender: TObject);
Begin
  Close;
End;

procedure TSDIAppForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := high(FNodes) downto 0 do
     freeandnil(Fnodes[i]);
  setlength(FNodes,0);

end;

procedure TSDIAppForm.HelpAbout1Execute(Sender: TObject);
Begin
  AboutBox.ShowModal;
End;

procedure TSDIAppForm.ShowNode2(Node: tChartNode);
Const
  ROffs: Array [0 .. 3] Of tpoint =
  ((X: 0; Y: 0),
  (X: 1; Y: 0),
  (X: 1; Y: 1),
    (X: 0; Y: 1));
Var
  lCanvas: tCanvas;
  Points: Array Of tpoint;
  I: integer;
Begin
  If Not assigned(Node) Then
    exit;

  lCanvas := self.canvas;
  setlength(Points, 4);
  For I := 0 To 3 Do
    Begin
      Points[I].X := XOffset + (trunc(Node.fX * XMul2) + ROffs[I].X * 8);
      Points[I].Y := YOffset + (trunc(Node.fY * YMul2) + ROffs[I].Y * 8);
    End;
  // Rahmen
  lCanvas.pen.Width:=1;

  if node.gender then
    lCanvas.pen.Color:=clBlue
  else
    lCanvas.pen.Color:=clRed;
  lCanvas.Polygon(Points);
  if Node = Ftree then
    begin
      For I := 0 To 3 Do
        Points[I] := Points[I].Add(Roffs[(i+2)mod 4]).Subtract(Roffs[i]);
       lCanvas.Polygon(Points);
    end;
  // Name
  // Info
  // Bild
end;

procedure TSDIAppForm.ShowBranch2(Node2, Node1: tChartNode);

Var
  lCanvas: tCanvas;
  Points: Array Of tpoint;
  I: integer;
Begin
  If Not assigned(Node1) Or Not assigned(Node2) Then
    exit;

  lCanvas := self.canvas;
  lCanvas.pen.Color:= clblack;
  setlength(Points, 4);

  Points[0] := Point(XOffset + trunc(Node1.fX * XMul2) + 5,
      YOffset + trunc(Node1.fY * YMul2) + 8);
  Points[1] := Point(XOffset + trunc(Node1.fX * XMul2) + 5,
      YOffset + trunc( 0.25*(Node1.fY*3+Node2.fY) * YMul2)  );
  Points[2] := Point(XOffset + trunc(Node2.fX * XMul2) + 5,
       YOffset + trunc( 0.25*(Node1.fY+Node2.fY*3) * YMul2)  );
  Points[3] := Point(XOffset + trunc(Node2.fX * XMul2) + 5,
       YOffset + trunc(Node2.fY * YMul2) );
  lCanvas.MoveTo(Points[0]);
  lCanvas.LineTo(Point(Points[0].x,(Points[0].y+Points[1].y) div 2));
  lCanvas.LineTo(Point((Points[1].x*2+Points[2].x) div 3,(Points[1].y*2+Points[2].y) div 3));
  lCanvas.LineTo(Point((Points[1].x+Points[2].x*2) div 3,(Points[1].y+Points[2].y*2) div 3));
  lCanvas.LineTo(Point(Points[3].x,(Points[2].y+Points[3].y) div 2));
  lCanvas.LineTo(Points[3]);
End;

function TSDIAppForm.FindNearNode(aTree: tChartNode; X, Y: integer): tChartNode;
var
  Act, tn: tChartNode;
  dx, dy: ValReal;
  lst: TNearArr;
  lst2: TIndexArr;
  ix: Integer;
begin
  result := nil;
  if not assigned(aTree) then exit;
  Act := aTree;
  dx := abs((xOffset + Act.fx * xMul2 ) - x);
  dy := abs((yOffset + Act.fY * YMul2 ) - Y);
  lst := F2dIndex.GetNearest((x-xOffset)/xMul2,(y-yOffset)/yMul2);
  for lst2 in lst do
    for ix in Lst2 do
    begin
      tn := FNodes[ix];
      if  dx+dy> abs((xOffset + tn.fx * xMul2 ) - x)+ abs((yOffset + tn.fY * YMul2 ) - Y) then
        begin
          act := tn;
          dx := abs((xOffset + Act.fx * xMul2 ) - x);
          dy := abs((yOffset + Act.fY * YMul2 ) - Y);
        end;
    end;
  result := Act;
end;


procedure TSDIAppForm.MoveNodes( const Node: tChartNode );


var
  tn, s: tChartNode;
  mmx, mxx: Extended;
  i, cnt, ix, j: Integer;
  lst: TNearArr;
  lst2: TIndexArr;
  lDist: ValReal;
  lNear  :array[0..2] of integer;
  lNeard :array[0..2] of double;

begin
  for j := 0 to 2 do
      lNear[j] := 0;
  for tn in FNodes do
    begin
      tn.mX := 0;
      tn.my := 0;
      cnt := 1;
      If assigned(tn.M) Then
        Begin
          inc(cnt,2);
          tn.mx := tn.mx+(tn.M.fx-tn.fx)*2
        End;
      If assigned(tn.F) Then
        Begin
          inc(cnt,2);
          tn.mx := tn.mx+ (tn.F.fx-tn.fx)*2
        End;
      for s in tn.sp do
        Begin
          inc(cnt,2);
          tn.mx := tn.mx+ (s.fx-tn.fx)*2
        End;
      for s in tn.c do
          Begin
            inc(cnt);
            tn.mx := tn.mx+ (s.fx-tn.fx)
          End;
      for j := 0 to 2 do
        lNeard[j] := 1;
      lst := F2dIndex.GetNearest(tn.fX,tn.fY);
      for lst2 in lst do
        for ix in Lst2 do
          if FNodes[ix] <> tn then
          begin
          lDist := sqrt(sqr(FNodes[ix].fx - tn.fx) + sqr(FNodes[ix].fy - tn.fy));
          if lNeard[0] > ldist then
            begin
              lNeard[2] := lNeard[1];
              lNeard[1] := lNeard[0];
              lNeard[0] := ldist;
              lNear[2]  := lNear[1];
              lNear[1]  := lNear[0];
              lNear[0]  := ix;
            end
          else if lNeard[1] > ldist  then
            begin
              lNeard[2] := lNeard[1];
              lNeard[1] := ldist;
              lNear[2]  := lNear[1];
              lNear[1]  := ix;
            end
          else if lNeard[2] > ldist then
            begin
              lNeard[2] := ldist;
              lNear[2]  := ix;
            end;
        end;
      for j := 0 to 2 do
          begin
            lDist := sqrt(sqr(FNodes[lNear[j]].fx -tn.fX)+sqr(FNodes[lNear[j]].fy -tn.fy));
            inc(cnt);
            lDist := math.max(0.003,ldist);
            tn.mx := tn.mx-(FNodes[lNear[j]].fx-tn.fx)/(lDist*(lDist));
          end;
      tn.mx :=tn.mx /cnt
    end;

  mmx := 0.5;
  mxx := 0.5;
  for tn in FNodes do
    begin
      tn.fx := tn.fx + tn.mx *0.5;
      if tn.fx < mmx then
        mmx := tn.fx;
      if tn.fx > mxx then
        mxx := tn.fx;
    end;

  //Normalize
  for ix:= 0 to high(FNodes) do
     begin
       FNodes[ix].fx := (FNodes[ix].fx-mmx)/(mxx-mmx) ;
       F2dIndex.MoveObject(FNodes[ix],ix);
     end
end;

procedure TSDIAppForm.ShowTree2;
var
  s: tChartNode;
  minb, maxb: TTimeStamp;
  i: Integer;
Begin
  canvas.FillRect(canvas.ClipRect);
  for i := 0 to high(FNodes) do
    begin
      ShowNode2(FNodes[i]);
      If assigned(FNodes[i].M) Then
        Begin
          ShowBranch2(FNodes[i], FNodes[i].M);
        End;
      If assigned(FNodes[i].F) Then
        Begin
          ShowBranch2(FNodes[i], FNodes[i].F);
        End;
      for s in FNodes[i].sp do
        Begin
          ShowBranch2(FNodes[i], s);
        End;
      for s in FNodes[i].c do
          Begin
            ShowBranch2(s, FNodes[i]);
          End;
    end
End;

Destructor tChartNode.Destroy;
Begin
  Inherited;
End;

End.
