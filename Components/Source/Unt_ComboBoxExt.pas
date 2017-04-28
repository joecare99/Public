Unit Unt_ComboBoxExt;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*V 1.02  }
{*H 1.01  Kommentare mit Together-Modell-Tag unterstuetzung}
{*H 1.00  Neue Procedure FillListbox, Aenderung: FillXX schliest Abfrage am Ende }

Interface

Uses SysUtils, Controls, StdCtrls, DB;
///<author>Joe Care</author>
///  <user>admin</user>
///  <since>16.04.2008</since>
///  <version>1.01.00</version>
///  <info>Sucht in der Combobox nach dem Eintrag mit dem eingegebenen Text</info>
Procedure SucheComboboxWert(cbx: TComboBox; OnlyList: Boolean = true);

///<author>Joe Care</author>
///  <user>admin</user>
///  <since>16.04.2008</since>
///  <version>1.01.00</version>
///  <info>Fuellt die Combobox mit Werten der Abfrage</info>
Procedure FillCombobox(cbx: TCombobox; DS: TDataset; IDField, BezField:
  String; SubID: integer = -1; Force: boolean = false);

///<author>Joe Care</author>
///  <user>admin</user>
///  <since>16.04.2008</since>
///  <version>1.01.00</version>
///  <info>Ermittelt von der Combobox die ID des Eintrags</info>
Function GetComboboxID(cbx: TCombobox; OnlyList: Boolean = false): integer;

///<author>Joe Care</author>
///  <user>admin</user>
///  <since>16.04.2008</since>
///  <version>1.01.00</version>
///  <info>Ermittelt von der Listbox die ID des Eintrags</info>
Function GetListboxID(cbx: TListbox; OnlyList: Boolean = false): integer;

///<author>Joe Care</author>
///  <user>admin</user>
///  <since>16.04.2008</since>
///  <version>1.01.00</version>
///  <info>Setzt die ComboBox auf den Eintrag mit gleicher ID</info>
Procedure SetComboboxID(cbx: TCombobox; ID: integer);

///<author>Joe Care</author>
///  <user>admin</user>
///  <since>16.04.2008</since>
///  <version>1.01.00</version>
///  <info>Setzt die Listbox auf den Eintrag mit gleicher ID</info>
Procedure SetListboxID(cbx: TListbox; ID: integer);

Var ///<author>Joe Care</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>1.01.00</version>
  ///  <info>Lokaler Dataset zum Zwischenspeichern der Ergebnisse</info>
  DSCache: Tdataset;

Implementation

Uses Classes, variants;

Procedure SucheComboboxwert(cbx: TComboBox; OnlyList: Boolean = true);
Var
  i: integer;
Begin
  If (length(cbx.Text) > 0) And Not (cbx.DroppedDown) Then
    For i := 0 To cbx.Items.Count - 1 Do
      If UpperCase(copy(cbx.Items[i], 1, length(cbx.Text))) = uppercase(cbx.Text)
        Then
        Begin
          cbx.ItemIndex := i;
          break;
        End;
  If (cbx.Items.Count > 0) And OnlyList Then
    If cbx.ItemIndex = -1 Then
      cbx.itemindex := 0;
  { for i := 0 to cbx.Items.Count-1 do
        if longint(cbx.Items[i].
          }
End;

Procedure FillCombobox(cbx: TCombobox; DS: TDataset; IDField, BezField:
  String; SubID: integer = -1; Force: boolean = false);

Var
  i, ID, Idx, oldID: integer;
  Bez: String;
  OldTxt, ChID: String;
  e: exception;
  LookDB: boolean;

Begin
  assert(assigned(cbx), 'Keine ComboBox übergeben');
  Assert(assigned(DS), 'Kein Dataset übergeben');
  If Not DS.Active Then
    DS.Open;
  If cbx.inheritsfrom(TCustomComboBox) Then
    OldTxt := TComboBox(cbx).Text;
  OldID := cbx.tag;

  If subid = -1 Then
    chId := IDField
  Else
    chId := IDField + ',' + inttostr(subid);

  If assigned(dscache) And dscache.active And Not Force Then
    With DScache Do
      Begin
        filtered := false;
        i := 0;
        While Tag > 0 Do
          Begin
            Sleep(1);
            inc(i);
            If i > 1000 Then exit;
          End;
        Try
          Tag := 1;
          filter := Fields[0].FieldName + '=''' + chid + '''';
          filtered := true;
          e := Nil;
          first;
          LookDB := true;
          If Not eof Then
            Begin
              cbx.Clear;
              ID := -1;
              Idx := 0;
              cbx.AddItem('Alle', TObject(ID));
              While Not eof Do
                Begin
                  Try
                    inc(Idx);
                    id := Fields[2].value;
                    bez := vartostr(Fields[1].value);
                    cbx.AddItem(bez, TObject(ID));
                    If Bez = OldTxt Then
                      cbx.ItemIndex := Idx;
                    If (id = oldID) And (oldID <> 0) And (OldTxt = '') Then
                      cbx.ItemIndex := Idx;
                  Except
                    On ex: Exception Do e := ex;
                  End;
                  Next
                End;
              LookDB := false;
            End;
          If assigned(e) Then
            ApplicationShowException(e);
        Finally
          Filtered := false;
          Tag := 0;
        End;
      End
  Else
    LookDB := true;

  // No Cache Code
  If LookDB Then
    With DS Do
      Begin
        If assigned(DSCache) And DScache.Active Then
          With DSCache Do
            Try
              i := 0;
              While tag > 0 Do
                Begin
                  sleep(1);
                  inc(i);
                  If i > 1000 Then exit;
                End;
              tag := 1;
              Try
                While locate(Fields[0].FieldName, chid, [loCaseInsensitive]) Do
                  Try
                    DSCache.Delete
                  Except
                  End
              Finally
                tag := 0;
              End;
            Except
            End;
        e := Nil;
        first;
        cbx.Clear;
        ID := -1;
        Idx := 0;
        cbx.AddItem('Alle', TObject(ID));
        While Not eof Do
          Begin
            Try
              inc(Idx);
              id := FieldValues[IDField];
              bez := vartostr(FieldValues[BezField]);
              Try
                If assigned(DSCache) Then
                  DScache.AppendRecord([chid, bez, id]);
              Except
              End;
              cbx.AddItem(bez, TObject(ID));
              If Bez = OldTxt Then
                cbx.ItemIndex := Idx;
              If (id = oldID) And (oldID <> 0) And (OldTxt = '') Then
                cbx.ItemIndex := Idx;
            Except
              On ex: Exception Do e := ex;
            End;
            Next
          End;
        If assigned(e) Then
          ApplicationShowException(e);
        close;
      End;
End;

//Procedure FillListBox;
//
//var ID:integer;
//    Bez:string;
//    e:exception;
//begin
// if not DS.Active then
//    DS.Open;
//  with DS do
//    begin
//      e:=nil;
//      first;
//      LBx.Clear ;
//      ID:=-1;
//      LBx.AddItem('Alle',pointer(ID));
//      while not eof do
//        begin
//          try
//            id := FieldValues[IDField];
//            bez:=vartostr(FieldValues[BezField]);
//            LBx.AddItem(bez,pointer(ID) );
//          except
//            on ex:Exception do e:=ex;
//          end;
//          Next
//        end;
//      if assigned(e) then
//        ApplicationShowException(e);
//      Close;
//    end;
//end;

Function GetComboBoxID(cbx: TCombobox; OnlyList: Boolean = false): integer;

Var
  ii, cc: integer;
  Tmp: String;

Begin
  Tmp := cbx.Items[cbx.ItemIndex];

  If (cbx.ItemIndex = -1) Or
    (Tmp <> cbx.text) Then
    SucheComboboxwert(cbx, OnlyList);
  ii := cbx.ItemIndex;
  cc := cbx.Items.count;
  If (ii >= 0) And (ii < cc) Then
    Try
      result := integer(cbx.Items.Objects[II])
    Except
      result := -1;
    End
  Else
    result := -1;
End;

Function GetListBoxID(cbx: TListbox; OnlyList: Boolean = false): integer;

Var
  ii, cc: integer;

Begin
  ii := cbx.ItemIndex;
  cc := cbx.Items.Count;
  If (ii > 0) And (ii < cc) Then
    Try
      result := integer(cbx.Items.Objects[II])
    Except
      result := -1;
    End
  Else
    result := -1;
End;

Procedure SetComboboxID(cbx: TCombobox; ID: integer);

Var
  i: integer;
Begin
  For i := 0 To cbx.items.count - 1 Do
    Try
      If integer(Cbx.Items.Objects[i]) = ID Then
        Begin
          cbx.ItemIndex := i;
          cbx.text := cbx.Items[i];
          exit
        End
    Except
    End;
End;

Procedure SetListboxID(cbx: TListbox; ID: integer);
Var
  i: integer;
Begin
  For i := 0 To cbx.items.count - 1 Do
    Try
      If integer(Cbx.Items.Objects[i]) = ID Then
        Begin
          cbx.ItemIndex := i;
          exit
        End
    Except
    End;
End;

Initialization
  DSCache := Nil;

End.
