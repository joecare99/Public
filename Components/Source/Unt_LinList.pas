Unit Unt_LinList;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*h 1.00.00}
{*v 1.00.01 TNamedList published entfernt}
{ $define debug}

Interface

Uses Unt_Allgfunklib, variants, Unt_Stringprocs;

Type
  TLinListClass = Class Of TLinLIst;

  ///<author>C.Rosewich</author>
  ///  <since>long ago</since>
  ///  <version>1.0.0</version>
  ///  <info>Declares a linear list with some prototype functions</info>
  TLinList = Class(TObject)
  private
    { Private Deklarationen }
///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Pointer to the next Entry</info>
    FNext: TLinList;
(*
{$IFDEF debug}
    ///<author>C.Rosewich</author>
    ///  <since>long ago</since>
    ///  <version>1.0.0</version>
    ///  <info>Declares some Debug-DummyData</info>
    Debugdaten: Array[word] Of integer;
{$ENDIF}
*)
  protected

    ///<author>C.Rosewich</author>
    ///  <since>long ago</since>
    ///  <version>1.0.0</version>
    ///  <info>returns a specific item by it's number</info>
    ///  <convention>Has to be called from the first entry</convention>
    Function getItem(Const Index: variant): TLinList; virtual;
  public
    { Oeffentliche Funktionen }

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>returns a specific item by it's number</info>
///  <convention>Has to be called from the first entry</convention>
    Property Items[Const Index: variant]: TLinList read GetItem; default;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Creates a New Item</info>
    Constructor create(ZNext: TLinList = Nil); overload;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Appends a New Item</info>
    Procedure Append(ListObj: TLinList); virtual;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Appends itself to a List</info>
    Function AddTo(ListObj: TLinList): TLinList; virtual;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Returns the Last Entry</info>
    Function getLast: TLinList; virtual;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Returns the Next Entry</info>
    Function GetNext: TLinlist; virtual;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Compares the list to the given list</info>
    Function compare(ListObj: TLinLIst): TCompResult; virtual;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Returns wether the actual Entry is the Last</info>
    Function EOF: boolean;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Returns the predetor from the given entry</info>
    Function GetPred(ListObj: TLinLIst): TLinList; virtual;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Deletes an Item from the List</info>
    Function Delete(ListObj: TLinList): TLInLIst; virtual;

///<author>C.Rosewich</author>
///  <since>long ago</since>
///  <version>1.0.0</version>
///  <info>Counts Items from the List</info>
    Function Count: integer;
  End;

  TNamedList = Class(TLinLIst)
  private
    { Private Deklarationen }
    FName: String;
{$IFDEF debug}
    Debugdaten: Array[word] Of integer;
{$ENDIF}
  protected
    Function getItem(Const Index: variant): TLinList; override;
    Procedure SetName(NewName: String);

  public
    Property Name: String read FName write setName;
    //         Property Items[const Index:variant]:TLinList read GetItem;default;
             { Offentliche Funktionen }
    Constructor create(NewName: String; ZNExt: TNamedList = Nil); overload;
  End;

  TSortedList = Class(TLinList)
  private
    { Private Deklarationen }
{$IFDEF debug}
    Debugdaten: Array[word] Of integer;
{$ENDIF}
  protected

  public
    Property Items[Const Index: variant]: TLinList read GetItem; default;
    { Offentliche Funktionen }
  End;

Implementation

Constructor TLinLIst.create(Znext: TLinList);

Begin
  FNext := ZNext;
End;

Procedure TLinList.Append(ListObj: TLinList);
// Dise Funktion Fügt ein Element hinten an einer Liste An.
// Rückgabe ist nil, falls Kein VorFahr ermittelt werden Kann.

Var
  p: TLinList;

Begin
  p := self;
  While assigned(p.FNext) Do
    Begin
      p := p.FNext;
    End;
  p.FNext := ListObj;
End;

Function TLinList.AddTo(ListObj: TLinList): TlinLIst;
// Dise Funktion Fügt sich selbst Vor einer Liste Ein.
// Rückgabe ist nil, falls Kein VorFahr ermittelt werden Kann.
// Aufruf: ZList:= p.AddTo(Zlist);

Var
  p: TLinList;

Begin
  p := self;
  While assigned(p.FNext) Do
    Begin
      p := p.FNext;
    End;
  p.FNext := ListObj;
  addto := self
End;

Function TLinList.Getlast: TlinLIst;
// Dise Funktion ermittelt das Letzte Element in Einer Liste
// Rückgabe ist nil, falls Kein VorFahr ermittelt werden Kann.

Var
  p: TLinList;

Begin
  p := self;
  While assigned(p.FNext) Do
    Begin
      p := p.FNext;
    End;
  GetLast := p
End;

Function TLinList.EOF;
// Dise Funktion ermittelt das Letzte Element in Einer Liste
// Rückgabe ist nil, falls Kein VorFahr ermittelt werden Kann.

Begin
  EOF := Not assigned(FNext);
End;

Function TLinList.GetNext: TlinLIst;
// Dise Funktion ermittelt das Nächste Element in Einer Liste
// Rückgabe ist nil, falls Kein VorFahr ermittelt werden Kann.

Begin
  getNext := FNext;
End;

Function TLinList.GetPred;
// Dise Funktion ermittelt das Vorhergehende Element in Einer Liste
// Rückgabe ist nil, falls Kein VorFahr ermittelt werden Kann.
// aufruf: Pred:= actuell.getpred(List);

Var
  p: TLinList;

Begin
  If (Not assigned(ListObj)) Or (listobj = self) Then
    p := Nil
  Else
    Begin
      p := self;
      While assigned(p) And (p.FNext <> ListObj) Do
        Begin
          p := p.FNext;
        End;
    End;
  Getpred := p
End;

Function TLinList.Delete;
// Diese Funktion löscht ein Element aus der Liste
// Aufruf Zlist:=zlist.Delete(listObj);

Var
  p: TLinList;

Begin
  If (listobj = self) Then
    Begin
      Delete := FNext;
      free
    End
  Else
    Begin
      delete := self;
      p := getpred(ListObj);
      If assigned(p) Then
        Begin
          p.FNext := ListObj.FNext;
          ListObj.free;
        End
    End;
End;

Function TLinList.count;
// Diese Funktion zählt die Elemente in der Liste

Var
  p: TLinList;
  cnt: integer;

Begin
  p := self;
  cnt := 0;
  While assigned(p) Do
    Begin
      p := p.FNext;
      inc(cnt);
    End;
  count := cnt;
End;

Function TLinLIst.GetItem;

Var
  i, max: integer;
  p: TLinLIst;

Begin
  //         varEmpty    = $0000;
  Try
    max := index;
  Except
    max := 0;
  End;
  p := self;
  For i := 1 To max Do
    If assigned(p) Then
      p := p.GetNext;
  getitem := p;
End;

Function TLinLIst.compare;

Begin
  //         varEmpty    = $0000;
  Runerror(211);
  compare := cr_equal;
End;

// ------------------------------------- Methoden von TNamed LIst ----------------------

Constructor TNamedList.create(NewName: String; ZNext: TnamedList);

Begin
  Inherited Create(Znext);
  FName := NewName;
End;

Function TNamedList.getItem;

Var
  p: TNamedList;

Begin
  If vartype(index) = varstring Then
    Begin
      p := self;
      If right(index, 1) = '*' Then
        While assigned(p) And (left(upcase(p.name), length(index) - 1) + '*' <>
          upcase(String(index))) Do
          p := p.getnext As TNamedlist
      Else
        While assigned(p) And (upcase(p.name) <> upcase(String(index))) Do
          p := p.getnext As TNamedlist;
      getitem := p;
    End
  Else
    getitem := Inherited getitem(index);
End;

Procedure TNamedList.SetName;

Begin
  FName := NewName;
End;

End.

