Unit Frm_Chart2Main;

Interface

Uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, sysutils;

Type
  tChartNode = Class
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
    X, Y: integer;
    Level, Pnr, Weight: integer;
    Destructor Destroy; Override;
  End;

Type

  { TSDIAppForm }

  TSDIAppForm = Class(TForm)
    Label3: TLabel;
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
    Procedure HelpAbout1Execute(Sender: TObject);
    Procedure btnGenerateClick(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormCreate(Sender: TObject);
  Private
    FMaxLevel: Integer;
    { Private-Deklarationen }
    Ftree: tChartNode;

    Function FindNearNode(aTree: tChartNode; X, Y: integer): tChartNode;
    procedure MoveNodes(const Node: tChartNode; const maxLevel: integer);
  Public
    Procedure CalcTree(Node: tChartNode);
    { Public-Deklarationen }
  Published
    Procedure ShowTree(Node: tChartNode);
    Procedure ShowNode(Node: tChartNode);
    Procedure ShowBranch(Node1, Node2: tChartNode);
  End;

Var
  SDIAppForm: TSDIAppForm;

Implementation

Uses frm_about;

{$ifdef FPC}
{$R *.lfm}
{$ELSE ~FPC}
{$R *.lfm}
{$ENDIF ~FPC}

Const
  Lastnames: Array [0 .. 17] Of String = ('Adams', 'Abrams', 'Bechtle',
    'Becker', 'Caspar', 'Cuntzmann', 'Danzeisen', 'Daubentaler', 'Debinger',
    'Dietrich', 'Doll', 'Ebert', 'Eck', 'Edel', 'Eisenmann', 'Esser',
    'Faber', 'Fels');

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

procedure TSDIAppForm.FileNew1Execute(Sender: TObject);
Begin
  { Nichts ausführen }
End;

procedure TSDIAppForm.btnOptimizeClick(Sender: TObject);
begin
  MoveNodes(Ftree,FMaxLevel);
  canvas.FillRect(canvas.ClipRect);
  ShowTree(Ftree);
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

procedure TSDIAppForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  I: integer;
  Nearnode: tChartNode;
begin
  Nearnode := FindNearNode(Ftree, X, Y);
  if assigned(Nearnode) then
    begin
      Label1.caption := 'Name: '+Nearnode.GivenName + ' ' + Nearnode.Name;
      Label2.caption := 'Geb:  '+DateTimeToStr(TimeStampToDateTime(nearnode.Birth));


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

    end;
end;

procedure TSDIAppForm.FormPaint(Sender: TObject);
begin
  canvas.FillRect(canvas.ClipRect);

  ShowTree(Ftree);

end;

procedure TSDIAppForm.FormResize(Sender: TObject);
Begin
  canvas.FillRect(canvas.ClipRect);

  ShowTree(Ftree);
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
            End
        End;
  End;

  Procedure FillParents(t: tChartNode;m:integer=3);
  Begin
    if m and 1<>0 then
      begin
    t.F := tChartNode.Create;
    t.F.Name := t.Name;
    setlength(t.f.C,1);
    t.F.C[0] := t;
    filltreenode(t.F, true, t.Birth, t.M);
      end;
    if m and 2<>0 then
      begin
    t.M := tChartNode.Create;
    if not assigned(t.F) then
      t.M.Name:=t.Name;
    setlength(t.M.C,1);
    t.M.C[0] := t;
    filltreenode(t.M, false, t.Birth, t.F);
      end;
  End;

  Procedure AddChild(F,M: tChartNode);
  var
    c: tChartNode;
  Begin
    c := tChartNode.Create;
    if assigned(F) then
      begin
        setlength(F.C,high(F.C)+1);
        F.C[high(F.C)] := c;
        c.F := F;
        c.Name := F.Name;
        filltreeChild(C, F);
      end;
    if assigned(M) then
      begin
        setlength(M.C,high(M.C)+1);
        M.C[high(M.C)] := c;
        c.M := M;
        if c.Name = '' then
          c.Name := M.Name;
        filltreeChild(C, M);
      end;
  End;

Var
  n, p: tChartNode;
  I: integer;
Begin
  randomize;
//  RandSeed:=2;
  Ftree.Free;
  Ftree := tChartNode.Create;
  Ftree.Name := Lastnames[random(High(Lastnames) + 1)];
  filltreenode(Ftree, random(2) = 0, Timestamp(2000, 4, 3), Nil);
  FillParents(Ftree);
  FillParents(Ftree.F);
  FillParents(Ftree.M);

  For I := 0 To 350 Do
    Begin
      n := Ftree;
      While n <> Nil Do
        Begin
          p := n;
          case random(3) of
            0: n := n.F;
            1: n := n.M;
            2: if length(n.c)> 1 then
              n := n.c[random(length(n.c))]
             else
              n := nil;
            3: if length(n.sp)> 0 then
              n := n.sp[random(length(n.sp))]
             else
              n := nil;

          end;
        End;
      if assigned(p.M) and assigned(p.F) then
        AddChild(p.M,p.F)
      else if assigned(p.F) then
        FillParents(p,2)
      else if assigned(p.M) then
        FillParents(p,1)
      else
        FillParents(p,random(3)+1);
    End;
  CalcTree(Ftree);
  canvas.FillRect(canvas.ClipRect);
  ShowTree(Ftree);
End;

procedure TSDIAppForm.CalcTree(Node: tChartNode);
Var
  Level: integer;
  maxLevel: integer;
  Act: tChartNode;
  nodeLevels: Array Of tChartNode;
  Nodes, Weight: Array Of integer;
  maxwidth: integer;
  I: integer;

  // Level    LLS
  // 0      N
  // 1      NF
  // 2      NFF
  // 2      NFM
  // 1      NM
  // 2      NMF
  // 2      NMM

Begin
  Level := 0;
  Act := Node;
  setlength(Nodes, 2);
  setlength(nodeLevels, 2);
  setlength(Weight, 2);
  nodeLevels[Level] := Node;
  maxLevel := 1;
  // Berechne maximale Tiefe/Höhe
  While assigned(Act) Do
    Begin
      // zähle act
      If High(Nodes) - 1 < Level Then
        Begin
          setlength(Nodes, Level + 2);
          setlength(nodeLevels, maxLevel + 2);
          setlength(Weight, maxLevel + 2);
          maxLevel := Level + 1;
        End;

      Nodes[Level] := Nodes[Level] + 1;
      If Nodes[Level + 1] < Nodes[Level] * 2 div 3 Then
        Nodes[Level + 1] := Nodes[Level] * 2 div 3;
      Act.Level := Level;
      Act.Pnr := Nodes[Level];
      // gehe zu F-Tree
      If assigned(Act.F) Then
        Begin
          Act.next := Act.F;
          Act := Act.F;
          inc(Level);
          If assigned(nodeLevels[Level]) Then
            begin
              nodeLevels[Level].nextil := Act;
              act.previl := nodeLevels[Level];
            end;
          nodeLevels[Level] := Act;
        End
      Else If assigned(Act.M) Then
        Begin
          Act.next := Act.M;
          Act := Act.M;
          inc(Level);
          If assigned(nodeLevels[Level]) Then
            begin
              nodeLevels[Level].nextil := Act;
              act.previl := nodeLevels[Level];
            end;
          nodeLevels[Level] := Act;
        End
      Else
        Begin
          Act.Weight := 1;
          Weight[Level] := Weight[Level] + 1;
          Nodes[Level + 1] := Nodes[Level + 1] + 1;

          While (Level > 0) And ((nodeLevels[Level - 1].F <> nodeLevels[Level])
            Or (Not assigned(nodeLevels[Level - 1].M))) Do
            Begin
              nodeLevels[Level - 1].Weight := 1;
              If assigned(nodeLevels[Level - 1].F) Then
                nodeLevels[Level - 1].Weight := nodeLevels[Level - 1].Weight +
                  nodeLevels[Level - 1].F.Weight;
              If assigned(nodeLevels[Level - 1].M) Then
                nodeLevels[Level - 1].Weight := nodeLevels[Level - 1].Weight +
                  nodeLevels[Level - 1].M.Weight;
              Weight[Level - 1] := Weight[Level - 1] + nodeLevels
                [Level - 1].Weight;
              dec(Level);
            End;
          If (Level > 0) and assigned(nodeLevels[Level - 1].M) Then
            Begin
              Act.next := nodeLevels[Level - 1].M;
              Act := nodeLevels[Level - 1].M;
              If assigned(nodeLevels[Level]) Then
                begin
                  nodeLevels[Level].nextil := Act;
                  act.previl := nodeLevels[Level];
                end;
              nodeLevels[Level] := Act;
            End
          Else
            Act := Nil;
        End;
      // gehe zu M-Tree

    End;
  // Berechne daraus die maximale Breite
  maxwidth := 0;
  For Level := 0 To maxLevel Do
    Begin
      If Level > 0 Then
        If Nodes[Level] < Nodes[Level - 1] * 2 div 3 Then
          Nodes[Level] := Nodes[Level - 1] * 2 div 3;

      If maxwidth < Nodes[Level] Then
        maxwidth := Nodes[Level];
    End;

  // Berechne  platz der Einzelnen Elemente
  Level := 0;
  Act := Node;

  While assigned(Act) Do
    Begin
      // zähle act
      Act.X := (maxwidth * (Act.Pnr * 2 - 1)) Div (Nodes[act.Level] );
      Act.Y := Act.Level;

      act:=act.next;
    End;

  For I := 1 To 15 Do
//   if False then
     MoveNodes(Node,  maxLevel);

  FMaxLevel := maxLevel;
  // gehe zu M-Tree
  //
End;

procedure TSDIAppForm.FileExit1Execute(Sender: TObject);
Begin
  Close;
End;

procedure TSDIAppForm.HelpAbout1Execute(Sender: TObject);
Begin
  AboutBox.ShowModal;
End;

procedure TSDIAppForm.ShowNode(Node: tChartNode);
Const
  ROffs: Array [0 .. 3] Of tpoint = ((X: 0; Y: 0), (X: 1; Y: 0), (X: 1; Y: 1),
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
      Points[I].X := XOffset + (Node.X * XMul + ROffs[I].X * 8);
      Points[I].Y := YOffset + (Node.Y * YMul + ROffs[I].Y * 8);
    End;
  // Rahmen
  if node.gender then
    lCanvas.pen.Color:=clBlue
  else
    lCanvas.pen.Color:=clRed;
  lCanvas.Polygon(Points);
  // Name
  // Info
  // Bild
End;

procedure TSDIAppForm.ShowBranch(Node1, Node2: tChartNode);

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
  lCanvas.moveto(XOffset + (Node1.X) * XMul + 5, YOffset + (Node1.Y) * YMul + 8);
  lCanvas.Lineto(XOffset + (Node1.X) * XMul + 5, YOffset + (Node1.Y+Node2.Y) * YMul div 2  );
  lCanvas.Lineto(XOffset + (Node2.X) * XMul + 5, YOffset + (Node1.Y+Node2.Y) * YMul div 2 + 10 );
  lCanvas.Lineto(XOffset + (Node2.X) * XMul + 5, YOffset + (Node2.Y) * YMul );

  // Rahmen
  // Name
  // Info
  // Bild
End;

function TSDIAppForm.FindNearNode(aTree: tChartNode; X, Y: integer): tChartNode;
var
  Act: tChartNode;
begin
  result := nil;
  if assigned(aTree) then
    begin
      Act := aTree;
      while assigned(Act) do
        begin
          if abs((YOffset + Act.Y * YMul ) - Y) < YMul div 2 then
            begin
              if abs((XOffset + Act.X * XMul + XMul div 2) - X) < XMul div 2
              then
                begin
                  result := Act;
                  Act := nil;
                end
              else
                Act := Act.nextil;
            end
          else
            Act := Act.next;
        end;
    end;
end;

procedure TSDIAppForm.MoveNodes( const Node: tChartNode;
   const maxLevel: integer );
var
  mm: boolean;
  ff: boolean;
  c: integer;
  xx: integer;
  Level: integer;
  Act: tChartNode;
  nodes: Array Of tChartNode;
  NodesXPos: Array Of integer;

begin
  begin
    setlength(NodesXPos,maxLevel+1);
    SetLength(nodes,maxLevel+1);

    for Level := 0 to maxLevel do
      NodesXPos[Level] := 0;

    Act := Node;
    while Act <> nil do
      begin
        xx := Act.X;
        c := 1;
        {
        if Act.Level > 0 then
          begin
            xx := xx + NodesXPos[Act.Level - 1];
            c := c + 1;
            ff := (nodes[Act.Level - 1].F = Act);
            mm := nodes[Act.Level - 1].M = Act;
          end
        else
          begin
            ff := false;
            mm := false;
          end;
        if mm then
          begin
            xx := xx + NodesXPos[Act.Level];
            c := c + 1;
          end;

        if assigned(Act.nextil) and ff then
          begin
            xx := xx + Act.nextil.X;
            c := c + 1;
          end;
         }
        // xx:=xx div 8;

        if assigned(Act.F) then
          begin
            xx := xx + 2*Act.F.X;
            c := c + 2;
          end;

        if assigned(Act.M) then
          begin
            xx := xx + 2*Act.M.X;
            c := c + 2;
          end;

        if assigned(Act.c) then
          begin
            xx := xx + 2*Act.c[0].X;
            c := c + 2;
          end;

        if (Act.Level > 0) and false then
          begin
            C := c + 3;
            if (nodes[Act.Level - 1].F = Act) then
              xx := xx + 5*NodesXPos[Act.Level - 1]-2*nodes[Act.Level - 1].M.x
            else
              xx := xx + 5*NodesXPos[Act.Level - 1]-2*nodes[Act.Level - 1].F.x;
          end;

        if true then
          begin

        if assigned(Act.nextil)   then
          begin
            if act.nextil.c <> act.c then
              begin
              c := c + 1;
              xx :=xx+ Act.nextil.X ;
                if act.x> Act.nextil.X then
                  begin
                c := c + 5;
                xx :=xx+ 5*Act.nextil.X ;
                  end;
              end;
          end
        else if Act.Weight>10 then
          begin
            c := c + 2;
            xx :=xx+ 2*Width div XMul;
          end;

        if assigned(Act.previl)  then
          begin
            if act.previl.c <> act.c then
             begin
            c := c + 1;
            xx :=xx+  Act.previl.X;
               if act.x< Act.previl.X then
                 begin
               c := c + 5;
               xx :=xx+ 5*Act.previl.X ;
                 end;
             end;
          end
        else if Act.Weight>10 then
          begin
            c := c + 2;
          //  xx :=xx+ 0;
          end;

          end;
        xx := xx div c;

        if true then
         begin
        if assigned(Act.nextil) and (xx >= Act.nextil.X-1) then // Todo: Bedingung fehlt
          xx := Act.nextil.X-2;

        if assigned(Act.previl) and (xx <= Act.previl.X+1) then // Todo: Bedingung fehlt
          xx := Act.previl.X+2;
         end;

        Act.X := xx;

        NodesXPos[Act.Level] := xx;
        nodes[Act.Level] := Act;
        Act := Act.next;
      end;

  end;
end;

procedure TSDIAppForm.ShowTree(Node: tChartNode);
Begin
  If assigned(Node) Then
    Begin
      ShowNode(Node);
      If assigned(Node.M) Then
        Begin
          ShowBranch(Node, Node.M);
          ShowTree(Node.M);
        End;
      If assigned(Node.F) Then
        Begin
          ShowBranch(Node, Node.F);
          ShowTree(Node.F);
        End;
    End;
End;

Destructor tChartNode.Destroy;
Begin
  F.Free;
  M.Free;
  Inherited;
End;

End.
