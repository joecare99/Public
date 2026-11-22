unit Unit17;

{-------------------------------------------------------------------------------
  Unit17 - TForm17, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit17.pas and the original resource
  Source\Projects_AhnenWin\Form17.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Buttons, ExtCtrls, StdCtrls, Forms, Controls, Grids, DB, Unit2, AHNGlobals, Unit1, StrUtils, Unit15, Unit16, QuickRpt;

type
  TForm17 = class(TForm)
  published
    BitBtn1: TBitBtn; //2F0
    BitBtn2: TBitBtn; //2F4
    Panel1: TPanel; //2F8
    Shape1: TShape; //2FC
    CheckBox1: TCheckBox; //300
    CheckBox2: TCheckBox; //304
    CheckBox3: TCheckBox; //308
    CheckBox4: TCheckBox; //30C
    CheckBox5: TCheckBox; //310
    CheckBox6: TCheckBox; //314
    CheckBox7: TCheckBox; //318
    CheckBox8: TCheckBox; //31C
    CheckBox11: TCheckBox; //320
    CheckBox12: TCheckBox; //324
    CheckBox13: TCheckBox; //328
    CheckBox14: TCheckBox; //32C
    CheckBox15: TCheckBox; //330
    CheckBox16: TCheckBox; //334
    RadioButton1: TRadioButton; //338
    RadioButton2: TRadioButton; //33C
    CheckBox9: TCheckBox; //340
    procedure RadioButton1Click(Sender: TObject); //00545014
    procedure fambeltern(AIn: AnsiString); //0053FD18
    procedure FormShow(Sender: TObject); //00545204
    procedure RadioButton2Click(Sender: TObject); //0054510C
    procedure nam2(AIn: AnsiString); //0053CC38
    procedure BitBtn1Click(Sender: TObject); //005405C4
    procedure BitBtn2Click(Sender: TObject); //005405A0
    procedure gebstvn(AIn: AnsiString; AFlag: Integer); //0053D358, AFlag (ECX): alle 4 Aufrufe übergeben 0, im Body nie gelesen (toter Parameter)
    procedure gebst(AIn: AnsiString); //0053E878
  end;

var
  Form17: TForm17;

implementation

{$R ..\Forms\Form17.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm17.RadioButton1Click(Sender: TObject);
begin
  { (00545014) "alle markieren" - every checkbox of the parameters is checked. }
  CheckBox1.Checked  := True;
  CheckBox2.Checked  := True;
  CheckBox3.Checked  := True;
  CheckBox4.Checked  := True;
  CheckBox5.Checked  := True;
  CheckBox6.Checked  := True;
  CheckBox7.Checked  := True;
  CheckBox8.Checked  := True;
  CheckBox9.Checked  := True;
  CheckBox11.Checked := True;
  CheckBox12.Checked := True;
  CheckBox13.Checked := True;
  CheckBox14.Checked := True;
  CheckBox15.Checked := True;
  CheckBox16.Checked := True;
end;

procedure sub_0053D06C(ALine: AnsiString; var AErgebnis: AnsiString);
var
  i: Integer;
  s: AnsiString;
begin
  { 0053D06C: Twin of sub_00576FF8 (Unit3) - date normalizer of the
    Familienblatt. Evaluates the prefixes ("..", "HK ", "vor...",
    "nach..."), strips leading dots/blanks, then the remaining dots. }
  AErgebnis := ALine;
  s := ALine;
  if Trim(s) = '..' then
  begin
    AErgebnis := '';
    Exit;
  end;
  if Copy(s, 1, 2) = 'HK' then
  begin
    AErgebnis := 'HK ' + Copy(s, 4, 7);
    Exit;
  end;
  if Pos('vo.r', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 1) + ' ' + RightStr(s, 4);
    Exit;
  end;
  if Pos('na.ch', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 2) + ' ' + RightStr(s, 4);
    Exit;
  end;
  if Trim(s) = '' then
    Exit;
  AErgebnis := '';
  while (Length(s) > 0) and ((s[1] = '.') or (s[1] = ' ')) do
    s := Copy(s, 2, 9);
  AErgebnis := s;
  if (Length(s) > 0) and (s[1] > '9') then
  begin
    AErgebnis := '';
    for i := 1 to Length(s) do
      if s[i] <> '.' then
        AErgebnis := AErgebnis + s[i];
    if Length(AErgebnis) > 0 then
      for i := 1 to Length(AErgebnis) do
        if AErgebnis[i] < ':' then
        begin
          Insert(' ', AErgebnis, i);
          Break;
        end;
  end;
end;

procedure TForm17.fambeltern(AIn: AnsiString);
var
  v: Integer;
  s, nn, dat: AnsiString;
begin
  { 0053FD18: Writes the parents' section of the Familienblatt into
    Table14 (Zeile [1E8]): one empty row per existing parent pair
    (then "Vater : "/"Mutter: " name lines via nam2/gebst), then walks
    Table10 ('num' index, FindKey on Table1Vater) where Epnum =
    Table1Mutter emits spouse lines 'oo (S) ', 'oo (K) ', 'oo' or
    '(o-o)' with normalized dates; unconditional Table14.Post per
    matching row. gvar_0061EFCC counts rows (+1 pair, +3 per parent). }
  if (DataModule2.Table1Vater.AsInteger > 0) or
    (DataModule2.Table1Mutter.AsInteger > 0) then
  begin
    DataModule2.Table14.Append;
    DataModule2.Table14.Post;
    Inc(gvar_0061EFCC);
  end;
  if DataModule2.Table1Vater.AsInteger > 0 then
  begin
    v := DataModule2.Table1Vater.AsInteger;
    DataModule2.Table3.FindKey([v]);
    s := AIn + 'Vater : ';                                  {0053FDC8 CatN3}
    nam2(s);
    s := AIn + '           ';                               {0053FDEA CatN3}
    gebst(s);
    Inc(gvar_0061EFCC, 3);
  end;
  DataModule2.Table10.IndexName := 'num';                   {0053FE0D}
  v := DataModule2.Table1Vater.AsInteger;
  if DataModule2.Table10.FindKey([v]) then
    while not DataModule2.Table10.Eof do                    {005403BF loop}
    begin
      if DataModule2.Table10Epnum.AsInteger =               {0053FE45..63}
        DataModule2.Table1Mutter.AsInteger then
      begin
        DataModule2.Table14.Append;                         {0053FE71}
        if Pos('Ehes', DataModule2.Table10Verbind.AsString) > 0 then {0053FE8E}
        begin
          if (DataModule2.Table10Saort.AsString <> '') or   {0053FE9B..FEAF}
            (DataModule2.Table10Sajahr.AsString <> '') then
          begin
            DataModule2.Table13.FindKey([DataModule2.Table10Saort.AsString]);
            if DataModule2.Table10Sajahr.AsString <> '' then {0053FF07}
            begin
              dat := DataModule2.Table10Satag.AsString + '.' +   {0053FF5F CatN5}
                DataModule2.Table10Samonat.AsString + '.' +
                DataModule2.Table10Sajahr.AsString;
              sub_0053D06C(dat, nn);                        {0053FF6F}
              DataModule2.Table14Zeile.AsString :=          {0053FFA8 CatN4}
                AIn + '           oo (S) ' + nn +
                TrimRight(' ' + DataModule2.Table10Saort.AsString);
            end;
          end
          else if (DataModule2.Table10Hort.AsString <> '') or  {0053FFD7/ED}
            (DataModule2.Table10Hjahr.AsString <> '') then
          begin
            DataModule2.Table13.FindKey([DataModule2.Table10Hort.AsString]);
            if DataModule2.Table10Hjahr.AsString <> '' then {0054003A}
            begin
              dat := DataModule2.Table10Htag.AsString + '.' +
                DataModule2.Table10Hmonat.AsString + '.' +
                DataModule2.Table10Hjahr.AsString;         {005400B1 CatN5}
              sub_0053D06C(dat, nn);                        {005400C1}
              if DataModule2.Table10Htag.AsString = 'HK' then {00540058}
                DataModule2.Table14Zeile.AsString :=        {005401F1 CatN4}
                  AIn + '           oo ' + nn +
                  TrimRight(' ' + DataModule2.Table10Hort.AsString)
              else
                DataModule2.Table14Zeile.AsString :=        {00540105 CatN4}
                  AIn + '           oo (K) ' + nn +
                  TrimRight(' ' + DataModule2.Table10Hort.AsString);
            end;
          end
          else
            DataModule2.Table14Zeile.AsString :=            {0054021F CatN3}
              AIn + '            oo';
        end
        else                                                {0054023F o-o}
        begin
          DataModule2.Table13.FindKey([DataModule2.Table10Hort.AsString]);
          if Trim(DataModule2.Table10Verbind.AsString) <> '' then {0054029C}
          begin
            dat := DataModule2.Table10Htag.AsString + '.' +
              DataModule2.Table10Hmonat.AsString + '.' +
              DataModule2.Table10Hjahr.AsString;             {00540305 CatN5}
            sub_0053D06C(dat, nn);                           {0054031B}
            DataModule2.Table14Zeile.AsString :=             {00540371 CatN5}
              AIn + '           (o-o ' + nn +
              TrimRight(' ' + DataModule2.Table10Hort.AsString) + ')';
          end;
        end;
        DataModule2.Table14.Post;                           {00540391 vtbl+248}
      end;
      DataModule2.Table10.Next;                             {005403A9}
    end;
  if DataModule2.Table1Mutter.AsInteger > 0 then            {005403E3}
  begin
    v := DataModule2.Table1Mutter.AsInteger;
    DataModule2.Table3.FindKey([v]);
    s := AIn + 'Mutter: ';                                  {00540422 CatN3}
    nam2(s);
    s := AIn + '           ';                               {00540445 CatN3}
    gebst(s);
    Inc(gvar_0061EFCC, 3);
  end;
end;

procedure TForm17.FormShow(Sender: TObject);
begin
  { (00545204) The table of the parameters of the family chart is opened
    with the index 'tit' and positioned on the first record. }
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
end;

procedure TForm17.RadioButton2Click(Sender: TObject);
begin
  { (0054510C) "alle l'oschen" - every checkbox of the parameters is unchecked. }
  CheckBox1.Checked  := False;
  CheckBox2.Checked  := False;
  CheckBox3.Checked  := False;
  CheckBox4.Checked  := False;
  CheckBox5.Checked  := False;
  CheckBox6.Checked  := False;
  CheckBox7.Checked  := False;
  CheckBox8.Checked  := False;
  CheckBox9.Checked  := False;
  CheckBox11.Checked := False;
  CheckBox12.Checked := False;
  CheckBox13.Checked := False;
  CheckBox14.Checked := False;
  CheckBox15.Checked := False;
  CheckBox16.Checked := False;
end;

procedure TForm17.nam2(AIn: AnsiString);
var
  s, t: AnsiString;
begin
  { 0053CC38: Builds the name output line "s" for the family sheet
    from the caller's name text AIn plus the current Table3 person,
    gated by the sheet's checkboxes; writes both strings to Table14.
    AIn is cleared in two listing-faithful edge cases (see below). }
  s := '';
  if CheckBox9.Checked then
  begin
    Form1.ucase(DataModule2.Table3Name.AsString, t);
    s := AIn + t + ' ' + DataModule2.Table3Vornamen.AsString +
      ' (DS ' + IntToStr(DataModule2.Table3Nummer.AsInteger) + ')';
  end
  else if Pos('                oo ', AIn) > 0 then
  begin
    Form1.ucase(DataModule2.Table3Name.AsString, t);
    s := AIn + #13#10 + '                    ' + t + ' ' +
      DataModule2.Table3Vornamen.AsString;
  end
  else
  begin
    Form1.ucase(DataModule2.Table3Name.AsString, t);
    s := AIn + t + ' ' + DataModule2.Table3Vornamen.AsString;
  end;
  if CheckBox1.Checked then
    if DataModule2.Table3IDNR.AsString <> '' then
      s := s + ' (ID: ' + DataModule2.Table3IDNR.AsString + ')';
  if CheckBox11.Checked then
    if DataModule2.Table3Beruf.AsString <> '' then
      s := s + ', ' + DataModule2.Table3Beruf.AsString;
  if CheckBox13.Checked then
    if DataModule2.Table3Hausname.AsString <> '' then
      s := s + ', ' + DataModule2.Table3Hausname.AsString;
  if CheckBox7.Checked then
    if DataModule2.Table3Religion.AsString <> '' then
      s := s + ', ' + DataModule2.Table3Religion.AsString;
  if Copy(AIn, 1, 5) = '     ' then
    AIn := Copy(AIn, 1, Length(AIn) - Length(TrimLeft(AIn)))
  else if Trim(AIn) <> '' then
    AIn := ''; {0053CF57: verbatim - nonempty AIn is cleared here
      (LStrClr [ebp-4]); listing-faithful. }
  if s <> '' then
  begin
    DataModule2.Table14.Append;
    DataModule2.Table14Zeile.AsString := s;
    DataModule2.Table14Nm2.AsString := AIn;
    DataModule2.Table14.Post;
  end;
end;

{ *************************************************************** }
{ TForm17.BitBtn1Click                                            }
{ AHNENWIN 5.1 - Familienblatt-Report (listenerisch nach         }
{ Projects_AhnenWin/Unit17.pas, Original 005405C4..00544A67).    }
{ Listing-faithful: Verhalten wie das Original, keine Byte-      }
{ genaue Uebersetzung; Angaben 0054xxxx = Originaladressen; }
{ Aenderungen/Quirks sind als Kommentare dokumentiert.           }
{ *************************************************************** }
procedure TForm17.BitBtn1Click(Sender: TObject);
var
  s1, s2, s3, s4, t, u: AnsiString;  { Sammelpuffer, Temp; s3/s4 neu [ebp-x aj] }
  geschH: AnsiString;                 { Geschlecht Hauptperson [ebp-0C] }
  n, nrMain, nrPartner, nrEhe, nrLP15, r, k, chI, cm, nAdop: Integer; { Loop-Zaehler/FindKeys }
  kidFlg: Integer;                      { Kind-Fundflag [ebp-2C] }
  row, nrSave: Integer;                 { Kinderschleifen-Index [edi],
                                          gespeicherte Table3-Nummer [ebp-34] }
begin
  { 005405EE: Nur wenn gvar_0253692C = 'Fbml' (Familienblatt im
    Html-Container), wird hier weitergemacht; ansonsten faellt
    dieUnit in den Html-Abruch (FamblHTML mit ModalResult 2). }
  if gvar_0253692C = 'Fbml' then
  begin
    ModalResult := 2;                        { 00540606: FModalResult[esi+24C] }
    Form1.FamblHTML;                         { 00540619: vollstaendiger Html-Weg }
    Exit;                                    { 0054061E: jmp 00544A67 }
  end;

  { 00540623: Flag gvar_0061EFD0 setzen, Formular ausblenden,
    Anzeige aktualisieren, Ausgabedatei (Table14) oeffnen. }
  gvar_0061EFD0 := 1;                        { 00540629: ds:[61EFD0] := 1 }
  Self.Visible := False;                     { 0054062D: TCustomForm.SetVisible }
  Form1.Refresh;                             { 00540640: TControl.Refresh }
  DataModule2.Table14.Open;                  { 0054064D: TDataSet.Open ([0061EF08]+0E8) }
  gvar_0061EFCC := 0;                        { 00540654: Sach-Reset (Zeilenzaehler) }
  n := 0;                                    { 0054065B: Kind-Zaehler [ebp-30] := 0 }
  s1 := '';                                  { 00540661: LStrClr [ebp-10] }
  s2 := '';                                  { 00540666: LStrClr [ebp-4] }

  nrMain := DataModule2.Table1Nummer.AsInteger;  { 00540670: Feld 534 (Table1) }
  DataModule2.Table3.IndexName := '';        { 00540685: TTable.SetIndexName('') }
  DataModule2.Table3.FindKey([nrMain]);     { 0054069E: FindKey-Schluesselpuffer [ebp-44] }
  geschH := UpperCase(DataModule2.Table3Geschlecht.AsString); { 005406A3: [ebp-0C] }
  gvar_02536930 := 'Familienblatt';          { 005406BE: @LStrAsg }

  { 005406CD: Kopfzeilen-Name; bei CheckBox9 mit DS-Nummer
    (CatN 6 Argumente), sonst kurz (CatN 3 Argumente). }
  t := '';
  Form1.ucase(DataModule2.Table3Name.AsString, t);      { 005406DF: Name (610) }
  if CheckBox9.Checked then                     { 005406D5 }
    gvar_02536934 := t + ' ' + DataModule2.Table3Vornamen.AsString +
      ' (DS ' + IntToStr(DataModule2.Table3Nummer.AsInteger) + ')'
  else                                          { 0054074F }
    gvar_02536934 := t + ' ' + DataModule2.Table3Vornamen.AsString;   { CatN 3 }

  { 0054079B / 00540801: IDNR (CB1) als " (ID: …)" anhängen. }
  if CheckBox1.Checked and
     (DataModule2.Table3IDNR.AsString <> '') then   { 005407BD: cmp String<>nil }
    gvar_02536934 := gvar_02536934 + ' (ID: ' +
      Trim(DataModule2.Table3IDNR.AsString) + ')';

  { 00540801 / 00540857: Beruf (CB11) und Hausname (CB13)
    jeweils mit Voransatz ", " anhängen. }
  if CheckBox11.Checked and
     (DataModule2.Table3Beruf.AsString <> '') then   { 00540813: Beruf (620) }
    gvar_02536934 := gvar_02536934 + ', ' + DataModule2.Table3Beruf.AsString;
  if CheckBox13.Checked and
     (DataModule2.Table3Hausname.AsString <> '') then { 00540869: Hausname (698) }
    gvar_02536934 := gvar_02536934 + ', ' + DataModule2.Table3Hausname.AsString;
  if CheckBox7.Checked and
     (DataModule2.Table3Religion.AsString <> '') then { 005408BF: Religion (61C) }
    gvar_02536934 := gvar_02536934 + ', ' + DataModule2.Table3Religion.AsString;

  { 0054090F: Klammer "(gebJahr - stJahr)":
    QUIRK: die Testbedingung liest Table1-Gebjahr (55C),
    der angehängte Wert kommt aber von Table3-Gebjahr (62C). }
  if DataModule2.Table1Gebjahr.AsString <> '' then   { 00540915: QUIRK 55C }
    gvar_02536934 := gvar_02536934 + ' (' + DataModule2.Table3Gebjahr.AsString + ' - '
  else                                       { 00540966 }
    gvar_02536934 := gvar_02536934 + ' ( - ';
  if DataModule2.Table3Stjahr.AsString <> '' then    { 00540980: Stjahr (654) }
    gvar_02536934 := gvar_02536934 + DataModule2.Table3Stjahr.AsString + ')'
  else                                       { 005409CC }
    gvar_02536934 := gvar_02536934 + ')';

  { 005409E0: Quelle (CB2): wenn die Quellennummer von
    gvar_0061EFD4 abweicht und in Table38 gefunden wird,
    wird Zeile "Qu.: <Titel>." an s2 angehaengt. }
  if CheckBox2.Checked and
     (DataModule2.Table3Quelle.AsString <> IntToStr(gvar_0061EFD4)) and
     DataModule2.Table38.FindKey([DataModule2.Table3Quelle.AsString]) then
    s2 := s2 + 'Qu.: ' + DataModule2.Table38Titel.AsString + '.' + #13#10;

  { 00540AA1: Schreibw. (CB14): "Schreibw.: <Namex>" per Zeile. }
  if CheckBox14.Checked and
     (DataModule2.Table3Namex.AsString <> '') then
    s2 := s2 + 'Schreibw.: ' + Trim(DataModule2.Table3Namex.AsString) + #13#10;

  { 00540B29: Geburtszeile: "* <Tag>.<Monat>.<Jahr>" (gekomprimiert
    ueber sub_0053D06C). QUIRK: CatN(5) wurde mit 5 der 7
    gepushten Argumente aufgerufen; die beiden uebrig
    bleibenden ("s2" und "* ") fliessen als CatN(3)-Argumente
    des naechsten Calls mit ein (siehe Original). }
  t := DataModule2.Table3Gebtag.AsString + '.' + DataModule2.Table3Gebmonat.AsString + '.' +
    DataModule2.Table3Gebjahr.AsString;
  u := '';                                     { sub-Ziel vor CatN(3) }
  sub_0053D06C(t, u);
  s2 := s2 + '* ' + u;                       { CatN(3) + Datum }

  { 00540BBA: Geburtsort (630) als Leerraum-Zusatz an s2. }
  if DataModule2.Table3Gebort.AsString <> '' then   { 00540BD4 }
    s2 := s2 + ' ' + DataModule2.Table3Gebort.AsString;

  { 00540C04: Quelle2 (CB2) mit Quelleg (670): Quelle in
    eckige Klammern, wenn Quellennummer abweicht und
    Table38-Satz gefunden wird. }
  if CheckBox2.Checked and
     (DataModule2.Table3Quelleg.AsString <> IntToStr(gvar_0061EFD4)) and
     DataModule2.Table38.FindKey([DataModule2.Table3Quelleg.AsString]) then
    s2 := s2 + ' [' + DataModule2.Table38Titel.AsString + ']';

  { 00540CBB: Table14 zuruecksetzen (Close/EmptyTable/Open) und
    den ersten Satz mit der Zeile s2 posten; Zeilenzaehler + 1. }
  DataModule2.Table14.Close;                 { 00540CC2: TDataSet.Close }
  DataModule2.Table14.EmptyTable;            { 00540CD0: TTable.EmptyTable }
  DataModule2.Table14.Open;                  { 00540CDA: TDataSet.Open }
  DataModule2.Table14.Append;                { 00540CEA: TDataSet.Append }
  DataModule2.Table14Zeile.AsString := s2;   { 00540CEF: Zeile (1E8) }
  DataModule2.Table14.Post;                  { 00540D02: TDataSet.Post }
  Inc(gvar_0061EFCC);                        { 00540D12: Zeilenzaehler }

  { 00540D2B: Taufe-Zeile, falls Tauftag oder (gehandelt) Taufort
    angegeben ist; das Datum geht durch sub_0053D06C. Die Zeile
    beginnt mit '~ ' und ueberschreibt s2 (Cat3-Quirk). }
  if (DataModule2.Table3Tauftag.AsString <> '') or
     (Trim(DataModule2.Table3Taufort.AsString) <> '') then
  begin
    t := DataModule2.Table3Tauftag.AsString + '.' + DataModule2.Table3Taufmonat.AsString +
      '.' + DataModule2.Table3Taufjahr.AsString;
    { 00540DE1: QUIRK @LStrCat3 ueberschreibt s2 vollstaendig
      (kein Anhaengen!) - Qu./Schreibzeilen stehen schon in
      Table14; s2 beginnt die neue Taufe-Zeile. }
    u := '';
    sub_0053D06C(t, u);
    s2 := '~ ' + u;
    if DataModule2.Table3Taufort.AsString <> '' then   { 00540DF4: Taufort (640) }
      s2 := s2 + ' ' + DataModule2.Table3Taufort.AsString;
  end;

  { 00540E3F: Quelle3 (CB2) mit Quelle-B-Stand; s2 += ' [Titel]'. }
  if CheckBox2.Checked and
     (DataModule2.Table3Quellet.AsString <> IntToStr(gvar_0061EFD4)) and
     DataModule2.Table38.FindKey([DataModule2.Table3Quellet.AsString]) then
    s2 := s2 + ' [' + DataModule2.Table38Titel.AsString + ']';

  { 00540EEF: Taufe-Zeile (falls aktiviert) nach Table14. }
  DataModule2.Table14.Append;                { 00540EF7: TDataSet.Append }
  DataModule2.Table14Zeile.AsString := s2;   { 00540EFE: Zeile (1E8) }
  DataModule2.Table14.Post;                  { 005411?: TDataSet.Post }
  Inc(gvar_0061EFCC);                        { TP-Zeile }

  { 00540F1F: St-Zeile (falls aktiviert) nach Table14. }
  DataModule2.Table14.Append;
  DataModule2.Table14Zeile.AsString := s2;
  DataModule2.Table14.Post;
  Inc(gvar_0061EFCC);

  { 00540F25: Taufpaten (CB4): neue Zeile "TP: <Taufpat>" (Cat3-
    Ueberschreib-Quirk) und gehaengter Table14-Satz. }
  if CheckBox4.Checked and (DataModule2.Table3Taufpat.AsString <> '') then  { 00540F4A }
  begin
    s2 := 'TP: ' + DataModule2.Table3Taufpat.AsString;       { 00540F66: @LStrCat3 (K20) }
    DataModule2.Table14.Append;                { 00540F79: TDataSet.Append }
    DataModule2.Table14Zeile.AsString := s2;   { 00540F86: Zeile (1E8) }
    DataModule2.Table14.Post;                  { 00540FA3: TDataSet.Post }
    Inc(gvar_0061EFCC);                        { 00540FA9 }
  end;

  { 00540FA F: Sterbezeile (Sterbedatum) mit Ersatzüfung Stort. }
  if (DataModule2.Table3Stjahr.AsString <> '') or
     (Trim(DataModule2.Table3Stort.AsString) <> '') then
  begin
    t := DataModule2.Table3Sttag.AsString + '.' + DataModule2.Table3Stmonat.AsString +
      '.' + DataModule2.Table3Stjahr.AsString;
      u := '';
    sub_0053D06C(t, u);
    s2 := '+ ' + u;                         { 00541080: Cat3-Quirk }
    if DataModule2.Table3Stort.AsString <> '' then  { 0054108B: Stort (658) }
      s2 := s2 + ' ' + DataModule2.Table3Stort.AsString;
  end;

  { 005410C F: Alter (CB15) und Todesursache (CB8) je in
    Klammern an s2 haengen. }
  if CheckBox15.Checked and (DataModule2.Table3Alter.AsString <> '') then
    s2 := s2 + ' (' + DataModule2.Table3Alter.AsString + ')';
  if CheckBox8.Checked and (DataModule2.Table3Todesurs.AsString <> '') then
    s2 := s2 + ' (' + DataModule2.Table3Todesurs.AsString + ')';

  { 00541191: Quelle4 (CB2) mit Quelles (678): Quelle in
    eckige Klammern an s2 haengen. }
  if CheckBox2.Checked and
     (DataModule2.Table3Quelles.AsString <> IntToStr(gvar_0061EFD4)) and
     DataModule2.Table38.FindKey([DataModule2.Table3Quelles.AsString]) then
    s2 := s2 + ' [' + DataModule2.Table38Titel.AsString + ']';

  { 00541247: Sterbezeile (falls aktiviert) nach Table14. }
  DataModule2.Table14.Append;
  DataModule2.Table14Zeile.AsString := s2;
  DataModule2.Table14.Post;
  Inc(gvar_0061EFCC);

  { 0054127E: Beerdigungszeile mit Ersatzprüfung Begort, dann
    neue Zeile "# <Datum>" (Cat3-Quirk), Beginn an Stort. }
  if (DataModule2.Table3Begjahr.AsString <> '') or
     (Trim(DataModule2.Table3Begort.AsString) <> '') then
  begin
    t := DataModule2.Table3Begtag.AsString + '.' + DataModule2.Table3Begmonat.AsString +
      '.' + DataModule2.Table3Begjahr.AsString;
    u := '';
    sub_0053D06C(t, u);
    s2 := '# ' + u;                         { 0054134A: Cat3 (K3C) }
    if DataModule2.Table3Begort.AsString <> '' then  { 00541356: Begort (66C) }
      s2 := s2 + ' ' + DataModule2.Table3Begort.AsString;
  end;

  { 0054139E: Quelle5 (CB2) mit Quelleb (67C): ' [Titel]'. }
  if CheckBox2.Checked and
     (DataModule2.Table3Quelleb.AsString <> IntToStr(gvar_0061EFD4)) and
     DataModule2.Table38.FindKey([DataModule2.Table3Quelleb.AsString]) then
    s2 := s2 + ' [' + DataModule2.Table38Titel.AsString + ']';

  { 00541455: Beerdigungszeile (falls aktiviert) nach Table14. }
  DataModule2.Table14.Append;
  DataModule2.Table14Zeile.AsString := s2;
  DataModule2.Table14.Post;
  Inc(gvar_0061EFCC);                          {apeutic }

  { 0054148B: lebt(e) in <Lebensort>-Zeile (nur bei Lebensort). }
  if Trim(DataModule2.Table3Lebensort.AsString) <> '' then
  begin
    DataModule2.Table14.Append;             { 005414BE: TDataSet.Append }
    DataModule2.Table14Zeile.AsString := 'lebt(e) in ' +
      Trim(DataModule2.Table3Lebensort.AsString);     { 005414EE: Cat3 }
    DataModule2.Table14.Post;                { 0054150E: TDataSet.Post }
    Inc(gvar_0061EFCC);                      { 00541514 }
  end;

  { 0054151A: Memo1 an der DBMemo1-Breite/ Größe ausrichten und leeren. }
  Form1.Memo1.Width := Form1.DBMemo1.Width;      { 00541531: TControl.SetWidth }
  Form1.Memo1.Font.Size := Form1.DBMemo1.Font.Size; { 0054155A: TFont.SetSize }
  Form1.Memo1.Clear;                             { 00541577: TMemo.Clear }

  { 0054157D: Kommentar-Rohzeile (CB3): ohne Umbruch, BLOESSELKommentar
    ungekuerzt ausgeben (eigener Table14-Satz). }
  if CheckBox3.Checked then
  begin
    DataModule2.Table3.FindKey([nrMain]);   { 005415A0: FindKey-Schluessel }
    if Trim(DataModule2.Table3Kommentar.AsString) <> '' then
    begin
      DataModule2.Table14.Append;             { 005415D9: TDataSet.Append }
      DataModule2.Table14Zeile.AsString := DataModule2.Table3Kommentar.AsString;
      DataModule2.Table14.Post;               { TDataSet.Post }
      Inc(gvar_0061EFCC);
    end;
  end;

  { 00541625: Adoptions-1: Zeile "adoptiert von <Vater> [und <Mutter>]"
    aus den Adoptiveltern (Table31-Zeilen Av/Am), nur wenn
    Kistat != 0. }
  s1 := '';                                  { 00541628: LStrClr [ebp-14] }
  DataModule2.Table17.Open;                   { 00541633: TDataSet.Open }
  DataModule2.Table17.IndexName := '';        { 00541644 }
  DataModule2.Table17.FindKey([nrMain]);      { 00541660 }
  if DataModule2.Table17Kistat.AsString <> '' then      { 0054167F: Kistat (9D4) }
  begin
    DataModule2.Table31.Open;                 { 0054168D }
    DataModule2.Table31.IndexName := '';      { 0054169A }
    if DataModule2.Table31.FindKey([nrMain]) then       { 005416BF: Test al }
    begin
      if DataModule2.Table17.FindKey([DataModule2.Table31Av.AsInteger]) then  { 005416D9 }
      begin
        s1 := DataModule2.Table17Name.AsString + ' ' + DataModule2.Table17Vornamen.AsString;
        if DataModule2.Table17Beruf.AsString <> '' then   { 00541751: Beruf (960) }
          s1 := s1 + ', ' + DataModule2.Table17Beruf.AsString;
      end;
      if DataModule2.Table17.FindKey([DataModule2.Table31Am.AsInteger]) then  { 00541795 }
      begin
        if s1 <> '' then
          s1 := s1 + ' und ';                 { 005417B3: nur wenn s1 nicht leer }
        s1 := s1 + DataModule2.Table17Name.AsString + ' ' +
          DataModule2.Table17Vornamen.AsString;
        if DataModule2.Table17Beruf.AsString <> '' then   { 00541823: Beruf (960) }
          s1 := s1 + ', ' + DataModule2.Table17Beruf.AsString;
      end;
      if s1 <> '' then                        { 00541857 }
      begin
        DataModule2.Table14.Append;           { 00541861 }
        { 0054186F: Cat3-Quirk: 'adoptiert von ' + s1 (kein Alt-Anhaengen) }
        DataModule2.Table14Zeile.AsString := 'adoptiert von ' + s1;
        DataModule2.Table14.Post;             { 00541897 }
        Inc(gvar_0061EFCC);                   { 0054189F }
      end;
    end;
  end;

  { 005418A9: Adoptionsschleife 2 - weitere Adoptiveltern in s1:
    Index je Geschlecht der Hauptperson (adopv/adopm), dann
    ueber Table31 Zeilen laufen und namen in s1 collects. }
  s1 := '';                                   { 005418A9 }
  DataModule2.Table31.Open;                   { 005418B5 }
  t := UpperCase(DataModule2.Table1Geschlecht.AsString);  { 548: Geschlecht }
  if t = 'M' then
    DataModule2.Table31.IndexName := 'adopv'   { 005418F8 }
  else if t = 'W' then
    DataModule2.Table31.IndexName := 'adopm';  { 00541940 }
  if DataModule2.Table31.FindKey([nrMain]) then          { 00541977 }
  begin
    nAdop := 1;                                { 0054194A }
    while not DataModule2.Table31.EOF do
    begin
      if (DataModule2.Table31Av.AsInteger = nrMain) or
         (DataModule2.Table31Am.AsInteger = nrMain) then   { 00541A72/96 }
      begin
        if DataModule2.Table17.FindKey([DataModule2.Table31Nummer.AsInteger]) then
        begin
          if nAdop > 1 then
            s1 := s1 + '; ';                   { 005419B8: Separator ab Satz 2 }
          s1 := s1 + DataModule2.Table17Name.AsString + ' ' +
            DataModule2.Table17Vornamen.AsString;
          if DataModule2.Table17Beruf.AsString <> '' then
            s1 := s1 + ', ' + DataModule2.Table17Beruf.AsString;
        end;
        nAdop := nAdop + 1;
      end;
      DataModule2.Table31.Next;                { 00541A5C }
    end;
    if s1 <> '' then                           { 00541ABA }
    begin
      DataModule2.Table14.Append;              { 00541AC4 }
      DataModule2.Table14Zeile.AsString := 'adoptierte: ' + s1;   { 00541AD6: Cat3 (CC8) }
      DataModule2.Table14.Post;                { 00541AFA }
      Inc(gvar_0061EFCC);                      { 00541B06 }
    end;
  end;

  { 00541B0C: Hauptsatz wiederfinden und Elternzeile aufrufen. }
  DataModule2.Table3.FindKey([nrMain]);       { 00541B20 }
  fambeltern('');                             { 00541B29: TForm17.fambeltern }

  { 00541B2E: Ehe-Block nur ausgeben, wenn Grid1 already belegt ist. }
  DataModule2.Table14.Open;                   { 00541B36 }
  if Trim(Form1.StringGrid1.Cells[1, 0]) <> '' then
  begin
    r := Form1.StringGrid1.RowCount;          { 00541B80..96 }
    if r > 0 then                             { 00541B8F: jl 00543FF3 }
    begin
      k := 0;                                  { 00541B99: Zeilenindex }
      while r > 0 do
      begin
        DataModule2.Table14.Append;            { 00541BA2 }
        DataModule2.Table14Zeile.AsString := '---------------------------'; { 00541BB5 }
        DataModule2.Table14.Post;              { 00541BCC }
        Inc(gvar_0061EFCC);                    { 00541BD2 }
        nrPartner := StrToInt(Form1.StringGrid1.Cells[1, k]);   { 00541BDF..04 }
        DataModule2.Table10.IndexName := 'num';                   { 00541C14 }
        DataModule2.Table10.FindKey([nrMain]);                    { 00541C30 }
        { << innere Table10-Schleife; wurde in diesem Bereich
            _decodiert und ersetzt diese Zeichenfolge >>
          Der Schleifenkopf 00542688 prueft Nummer = mainNr;
          der Rueckfall 0054269E (Partner reposition) loest die
          Ehe-/Partner-Zeile nach der Schleife aus. ⇒} 
        { Wie im Listing: nur Datensaetze der Hauptperson Nutzen. }
        while not DataModule2.Table10.EOF do
        begin
          if DataModule2.Table10Nummer.AsInteger = nrMain then
          begin
            s4 := '';                                      { 00541C3A }
            { 00541C42: nur Eheschliessungen dieses Partners }
            if DataModule2.Table10Epnum.AsInteger = nrPartner then
            begin
              if Pos('Ehes', DataModule2.Table10Verbind.AsString) > 0 then
                s4 := 'oo'
              else
                s4 := 'o-o';                  { 00541C5B/41C8C }
              { kirchliche Trauung (S) mit komprimiertem Datum }
              if (DataModule2.Table10Sajahr.AsString <> '') or
                 (Trim(DataModule2.Table10Saort.AsString) <> '') then
              begin
                u := '';
                sub_0053D06C(DataModule2.Table10Satag.AsString + '.' +
                  DataModule2.Table10Samonat.AsString + '.' +
                  DataModule2.Table10Sajahr.AsString, u);
                s4 := 'oo (S) ' + u;
              if DataModule2.Table10Saort.AsString <> '' then
                s4 := s4 + ' ' + DataModule2.Table10Saort.AsString;   { 00541E8D }
              { Trauz-Quelle: sx-CBBlock  }
              if CheckBox2.Checked and
                 (DataModule2.Table10Saqu.AsString <> IntToStr(gvar_0061EFD4)) and
                 DataModule2.Table38.FindKey([DataModule2.Table10Saqu.AsString]) then
                s4 := s4 + ' [' + DataModule2.Table38Titel.AsString + ']';
              DataModule2.Table14.Append;
              DataModule2.Table14Zeile.AsString := s4;   { Trauz- / O-Zeile }
              DataModule2.Table14.Post;              { kein Zeilenzaehler }
              { second aa Trauung (CB6): 'TZ: ' + Trauzort }
              if (Pos('Ehes', DataModule2.Table10Verbind.AsString) > 0) and
                 CheckBox6.Checked and
                 (DataModule2.Table10Satrauz.AsString <> '') then
              begin
                DataModule2.Table14.Append;
                DataModule2.Table14Zeile.AsString := 'TZ: ' +
                  DataModule2.Table10Satrauz.AsString;
                DataModule2.Table14.Post;
              end;
              { Familienzeile H/oo/o-o: Geb.platz der Familie }
              if (DataModule2.Table10Hjahr.AsString <> '') or
                 (Trim(DataModule2.Table10Hort.AsString) <> '') then
              begin
                if Pos('Ehes', DataModule2.Table10Verbind.AsString) > 0 then
                begin
                  if DataModule2.Table10Htag.AsString = 'HK' then
                  begin
                    u := '';
                    sub_0053D06C(DataModule2.Table10Htag.AsString + '.' +
                      DataModule2.Table10Hmonat.AsString + '.' +
                      DataModule2.Table10Hjahr.AsString, u);
                    s4 := 'oo (K) ' + u;
                  end
                  else
                  begin
                    u := '';
                    sub_0053D06C(DataModule2.Table10Htag.AsString + '.' +
                      DataModule2.Table10Hmonat.AsString + '.' +
                      DataModule2.Table10Hjahr.AsString, u);
                    s4 := 'oo ' + u;
                  end;
                  if Pos('ande', DataModule2.Table10Verbind.AsString) > 0 then
                  begin
                    u := '';
                    sub_0053D06C(DataModule2.Table10Htag.AsString + '.' +
                      DataModule2.Table10Hmonat.AsString + '.' +
                      DataModule2.Table10Hjahr.AsString, u);
                    s4 := 'o-o ' + u;
                  end;
                end;
                if DataModule2.Table10Hort.AsString <> '' then
                  s4 := s4 + ' ' + DataModule2.Table10Hort.AsString;
              end;
              { Trauzquelle-Hochzeit (Hqu) noch an s4 }
              if CheckBox2.Checked and
                 (DataModule2.Table10Hqu.AsString <> IntToStr(gvar_0061EFD4)) and
                 DataModule2.Table38.FindKey([DataModule2.Table10Hqu.AsString]) then
                s4 := s4 + ' [' + DataModule2.Table38Titel.AsString + ']';
              if Length(s4) <= 4 then
              begin
                DataModule2.Table14.Append;
                DataModule2.Table14Zeile.AsString := s4;
                DataModule2.Table14.Post;
              end
              else { 0054248C: Schutzeintrag der Familie }
              begin
                if (DataModule2.Table10Schjahr.AsString <> '') or
                   (Trim(DataModule2.Table10Schort.AsString) <> '') then
                begin
                  u := '';
                  sub_0053D06C(DataModule2.Table10Schtag.AsString + '.' +
                    DataModule2.Table10Schmonat.AsString + '.' +
                    DataModule2.Table10Schjahr.AsString, u);
                  s4 := 'o|o ' + u;
                  if DataModule2.Table10Schort.AsString <> '' then
                    s4 := s4 + ' ' + DataModule2.Table10Schort.AsString;
                  if CheckBox2.Checked and
                     (DataModule2.Table10Schqu.AsString <> IntToStr(gvar_0061EFD4)) and
                     DataModule2.Table38.FindKey([DataModule2.Table10Schqu.AsString]) then
                    s4 := s4 + ' [' + DataModule2.Table38Titel.AsString + ']';
                  DataModule2.Table14.Append;
                  DataModule2.Table14Zeile.AsString := s4;
                  DataModule2.Table14.Post;
                end;
              end;
            end;
          end;
          { 0054266A: Satz-Rueckfall → naechster Satz }
          DataModule2.Table10.Next;
        end;

        { 0054269E: Rueckfall der inneren Schleife: der Ehepartnersatz }
        { wird durch den Index-Rueckfall aufgehoben und die       }
        { Partnerzeile geschrieben. }
        DataModule2.Table10.IndexName := '';         { 0054269F }
        DataModule2.Table10.FindKey([nrPartner]);    { 005426AF }
        nam2('   ');                                 { 005426C4: TForm17.nam2 }
        gebst('        ');                            { 005426D2: TForm17.gebst }
        if Trim(DataModule2.Table3Lebensort.AsString) <> '' then
        begin
          DataModule2.Table14.Append;               { 0054270B }
          { 00542731: Cat3 – neun Leerzeichen + Text }
          DataModule2.Table14Zeile.AsString := '         lebt(e) in ' +
            Trim(DataModule2.Table3Lebensort.AsString);
          DataModule2.Table14.Post;                  { 00542761 }
          Inc(gvar_0061EFCC);                       { 00542767 }
        end;

        { FindKeys wieder herstellen (Uebergabe an Folgeblöcke). }
        DataModule2.Table1.FindKey([nrPartner]);    { 00542777 }
        DataModule2.Table1.FindKey([nrMain]);       { 00542790 }
        DataModule2.Table3.FindKey([nrPartner]);    { 005427A9 }

        { Anzeigen-Justage fuer den Textbereich. }
        Form1.Memo1.Clear;
        Form1.Memo1.Width := Form1.DBMemo1.Width;
        Form1.Memo1.Font.Size := Form1.DBMemo1.Font.Size;

        { 0054281B: Kommentar-Zeilen (CB3) der Partnerperson
          Zeile je Memo1.GetLines[i] ausgeben. }
        if CheckBox3.Checked and
           (DataModule2.Table3Kommentar.AsString <> '') then
        begin
          for cm := 0 to Form1.Memo1.Lines.Count - 1 do
          begin
            DataModule2.Table14.Append;             { 005428A2 }
            DataModule2.Table14Zeile.AsString := '   ' +
              Form1.Memo1.Lines[cm];                { 005428AF: Cat3 (DB0) }
            DataModule2.Table14.Post;               { 005428FE }
          end;
        end;

        { 00542914: Adoptionsblock der Partnerperson (Table17/Table31). }
        s1 := '';                                  { 00542914: LStrClr }
        DataModule2.Table17.Open;                   { 0054291E: TDataSet.Open }
        DataModule2.Table17.IndexName := '';        { 00542933: SetIndexName }
        DataModule2.Table17.FindKey([nrPartner]);  { 0054294F }
        { QUIRK: Kistat-Prufung als roher String-Leer-Vergleich (jbe). }
        if DataModule2.Table17Kistat.AsString <> '' then { 0054295C/6E }
        begin
          DataModule2.Table31.Open;                 { 0054297C: TDataSet.Open }
          DataModule2.Table31.IndexName := '';        { 00542989 }
          if DataModule2.Table31.FindKey([nrPartner]) then { 0054299A/AE, je 42B42 }
          begin
            if DataModule2.Table17.FindKey(          { 005429CB, je 42A70 }
                [DataModule2.Table31Av.AsInteger]) then
            begin
              s1 := DataModule2.Table17Name.AsString + ' ' + { 00542A13/21: CatN3 }
                DataModule2.Table17Vornamen.AsString;
              { QUIRK: Av/Am gehoeren zu Table17, nicht zu Table3. }
              if DataModule2.Table17Beruf.AsString <> '' then { 00542A26/40 }
                s1 := s1 + ', ' + DataModule2.Table17Beruf.AsString; { 00542A45/6B }
            end;
            if DataModule2.Table17.FindKey(          { 00542A84/91, je 42B42 }
                [DataModule2.Table31Am.AsInteger]) then
            begin
              if s1 <> '' then
                s1 := s1 + ' und ';               { 00542AAA..AC: LStrCat }
              s1 := s1 + DataModule2.Table17Name.AsString + ' ' + { 00542AB1: CatN4 }
                DataModule2.Table17Vornamen.AsString;
              if DataModule2.Table17Beruf.AsString <> '' then { 00542AF8/12 }
                s1 := s1 + ', ' + DataModule2.Table17Beruf.AsString; { 00542B35/3D }
            end;
            if s1 <> '' then                        { 00542B42/46 }
            begin
              DataModule2.Table14.Append;               { 00542B50 }
              DataModule2.Table14Zeile.AsString := ' '; { 00542B5D }
              DataModule2.Table14.Post;                 { 00542B74 }
              DataModule2.Table14.Append;               { 00542B82 }
              DataModule2.Table14Zeile.AsString := '   adoptiert von ' + s1; { 00542B8D/95 }
              DataModule2.Table14.Post;                 { 00542BB8 }
              Inc(gvar_0061EFCC);                       { 00542BC0 }
            end;
          end;
        end;

        { 00542BC6: Adoptierte Kinder der Partnerperson (Indizes adopv/adopm,
          Indexwahl nach Geschlecht der Partnerperson: zwei getrennte
          UpperCase-Passes, kein true-else-if ueber Mischwerte). }
        s1 := '';                                  { 00542BC6: LStrClr }
        DataModule2.Table31.Open;                   { 00542BD6: TDataSet.Open }
        DataModule2.Table17.FindKey([nrPartner]);  { 00542BE5..2BF2 }
        t := UpperCase(DataModule2.Table17Geschlecht.AsString); { 00542BF7..16 }
        if t = 'M' then
          DataModule2.Table31.IndexName := 'adopv'   { 00542C2B..3A }
        else if t = 'W' then
          DataModule2.Table31.IndexName := 'adopm';  { 00542C6E..82 }
        chI := 1;                                    { 00542C87 }
        if DataModule2.Table31.FindKey(
            [DataModule2.Table17Nummer.AsInteger]) then { 00542CA0..B2, je 42E7B }
        begin
          while not DataModule2.Table31.EOF do
          begin
            { Adoptionsfenster: blaue Zeilen nur, solange Av/Am =
              Nummer der Partnerperson; sonst Schleifenende. }
            if (DataModule2.Table31Av.AsInteger <>
                  DataModule2.Table17Nummer.AsInteger) and
               (DataModule2.Table31Am.AsInteger <>
                  DataModule2.Table17Nummer.AsInteger) then { 00542DAF..D1, Else-Aus }
              Break;
            if DataModule2.Table17.FindKey(                 { 00542CD3, je 42D91 }
                [DataModule2.Table31Nummer.AsInteger]) then
            begin
              if chI > 1 then
                s1 := s1 + '; ';                    { 00542CED/FA: LStrCat }
              s1 := s1 + DataModule2.Table17Name.AsString + ' ' + { 00542CFF/41: CatN4 }
                DataModule2.Table17Vornamen.AsString;
              if DataModule2.Table17Beruf.AsString <> '' then { 00542D56/60 }
                s1 := s1 + ', ' + DataModule2.Table17Beruf.AsString; { 00542D83/8B }
              chI := chI + 1;                       { 00542D90 }
            end;
            DataModule2.Table31.Next;               { 00542D93 }
          end;
          if s1 <> '' then                           { 00542DF7/DFB }
          begin
            DataModule2.Table14.Append;               { 00542E05 }
            DataModule2.Table14Zeile.AsString := ' '; { 00542E12 }
            DataModule2.Table14.Post;                 { 00542E27 }
            DataModule2.Table14.Append;               { 00542E37 }
            DataModule2.Table14Zeile.AsString := '   adoptierte: ' + s1; { 00542E42/4F }
            DataModule2.Table14.Post;                 { 00542E65 }
            Inc(gvar_0061EFCC);                       { 00542E75 }
          end;
        end;

        { 00542E7B: FindKeys des Partners wiederherstellen, Elternblock
          mit 5 Leerzeichen Praefix, dann eigene Ehe(n) der Partnerperson
          (Table18 'num') als oo/o-o-Zeile, posteriert. }
        DataModule2.Table1.FindKey([nrPartner]);    { 00542E85/8F }
        fambeltern('     ');                       { 00542E94/9B }
        DataModule2.Table1.FindKey([nrMain]);       { 00542EA0..EB4 }
        DataModule2.Table3.FindKey([nrPartner]);    { 00542EC6..ECD }
        DataModule2.Table18.Open;                   { 00542ED2..EDA }
        DataModule2.Table18.IndexName := 'num';     { 00542EE7/2EC }
        DataModule2.Table17.IndexName := '';         { 00542EF9/2FB }
        t := '';                                    { 00542F00/2F03: LStrClr [ebp-18] }
        if DataModule2.Table18.FindKey([nrPartner]) then { 00542F12/1F, je 43283 }
        begin
          while not DataModule2.Table18.EOF do
          begin
            { Adoptionsfenster der Ehepunkt-Verwandschaft: nur Zeilen der
              Partnerperson selbst. }
            if DataModule2.Table18Nummer.AsInteger <>        { 0054326D/77 }
                nrPartner then
              Break;
            { Hauptperson-Satz ueberspringen: Epnum = Hauptnummer
              (gemeinsame Ehe, bereits im Hauptblock abgedruckt). }
            if DataModule2.Table18Epnum.AsInteger =
                DataModule2.Table1Nummer.AsInteger then   { 00542F31..4F }
            begin
              DataModule2.Table18.Next;             { 00542F4F }
              Continue;                              { 00543251/6D }
            end;
            { Trauer-Satz (S) bevorzugt: Zeile 'ooS Datum Ort: '
              (sub_0053D06C liest Datum inkl. Marker-Vorsatz). }
            if (Trim(DataModule2.Table18Sajahr.AsString) <> '') or { 00542F55/80 }
               (Trim(DataModule2.Table18Saort.AsString) <> '') then { 00542F82/AD }
            begin
              s2 := 'ooS ' + DataModule2.Table18Satag.AsString + '.' + { 00542FB3..0D }
                DataModule2.Table18Samonat.AsString + '.' +
                DataModule2.Table18Sajahr.AsString;  { CatN5 inkl. Base }
              u := '';
              sub_0053D06C(s2, u);                    { 0054301D..29 }
              t := u + ' ' + DataModule2.Table18Saort.AsString +   { 00543034/5F: CatN5 }
                ': ';
            end
            else                                      { 00543069 }
            begin
              t := '';                              { 00543069: LStrClr }
              if Pos('Ehes', DataModule2.Table18Verbind.AsString) > 0 then { 00543071/96 }
                t := 'oo '                           { 00543098..A0: LStrLAsg }
              else if Pos('and', DataModule2.Table18Verbind.AsString) > 0 then { 005430A7/CC }
                t := 'o-o ';                         { 005430CE..D6: LStrLAsg }
              u := '';
              sub_0053D06C(t + DataModule2.Table18Htag.AsString + '.' + { 005430DB..13E }
                DataModule2.Table18Hmonat.AsString + '.' +
                DataModule2.Table18Hjahr.AsString, u); { 00543143..4F }
              t := u + ' ' + DataModule2.Table18Hort.AsString +   { 00543154/85: CatN5 }
                ': ';
            end;
            DataModule2.Table17.FindKey(             { 00543197..1AB }
              [DataModule2.Table18Epnum.AsInteger]);
            DataModule2.Table14.Append;               { 005431B8 }
            Form1.ucase(DataModule2.Table17Name.AsString, s2); { 005431DE..EB }
            DataModule2.Table14Zeile.AsString := '   [' + t + s2 + ' ' +
              DataModule2.Table17Vornamen.AsString + ']';  { 005431BD..24: CatN6 }
            DataModule2.Table14.Post;                 { 00543247 }
            DataModule2.Table18.Next;               { 00543251 }
          end;
        end;
        { 00543283: Loop-Join -> Kind(er)-Block }

        { 00543289: Ober-Gate Kind(er)-Block: nur bei gefuellter Grid-Zelle (1,0) }
        if Trim(Form1.StringGrid2.Cells[1,0])<>'' then { 005432B4: je 43FE7 }
        begin
          DataModule2.Table14.Append;                      { 005432C9 }
          DataModule2.Table14Zeile.AsString := ' ';        { 005432CE..EB }
          DataModule2.Table14.Post;                        { 005432ED }
          DataModule2.Table14.Append;                      { 005432FB }
          DataModule2.Table14Zeile.AsString := '     Kind(er): '; { 00543308..1F }
          DataModule2.Table14.Post;                        { 0054331F }
          { 00543325: Schleifenzaehler = RowCount (dec/test/jl zum Kopf) }
          for row := 0 to Form1.StringGrid2.RowCount-1 do
          begin
            { 00543349: kidFlg := 0 }
            kidFlg := 0;                                   { 0054334C }
            { 0054334C: Grid-Zahl als Table3-Schluessel }
            if DataModule2.Table3.FindKey(
              [StrToInt(Form1.StringGrid2.Cells[1,row])]) then { 0054337E..8F }
            begin
              { 00543395: M-Gate - Geschlecht/Vater/Mutter gegeneinander }
              if (UpperCase(DataModule2.Table3Geschlecht.AsString)='M') and
                 (DataModule2.Table3Vater.AsInteger=nrMain) and
                 (DataModule2.Table3Mutter.AsInteger=nrPartner) then { 005433C9..F5 }
              begin
                n := n+1;                                  { 005433F7 }
                kidFlg := 1;                               { 005433FA }
                { 00543401: '        '+Format('%2s',[IntToStr(n)])+'. ' (CatN3) }
                nam2('        '+Format('%2s',
                  [IntToStr(n)])+'. ');
                gebstvn('             ',0);                { 0054345F..66 }
              end;
            end;
            { 0054346D: W-Gate (gestartet auch ohne FindKey-Treffer: Quirk,
              liest dann den veralten Table3-Eintrag) }
            if (UpperCase(DataModule2.Table3Geschlecht.AsString)='W') and
               (DataModule2.Table3Mutter.AsInteger=nrMain) and
               (DataModule2.Table3Vater.AsInteger=nrPartner) then { 0054346D..CD }
            begin
              n := n+1;                                    { 005434D3 }
              kidFlg := 1;                                 { 005434D6 }
              nam2('        '+Format('%2s',
                [IntToStr(n)])+'. ');                      { 005434DD..29 }
              gebstvn('             ',0);                  { 0054353B..44 }
              { 00543549: CheckBox4/Taufpat - tote Cmp (Ergebnis nie getestet);
                ersetzt durch harmlose Leerschreibung (Taufpat-Feld existiert im
                Rebuild nicht) }
              if CheckBox4.Checked then
                s4 := '';
            end;
            { 00543575: kein Kind-Text geschrieben? => Zeile ueberspringen }
            if kidFlg<>1 then
              Continue;                                    { 0054357F }
            { 0054357F: Tauf-/Selbstnachweisfreigabe? => Zeile ueberspringen }
            if not CheckBox12.Checked then
              Continue;                                    { 0054357F..8F }
            { 00543595: Table15-Index auf 'num' stellen }
            DataModule2.Table15.IndexName := 'num';        { 00543595..A2 }
            { 005435A7: Zelleninhalt muss > ' ' sein (Quirk: jbe-Zeichenvergleich) }
            if Form1.StringGrid2.Cells[1,row]<=' ' then
              Continue;                                    { 005435A7..D7 }
            { 005435DD: Table15.Schluessel suchen, sonst ueberspringen }
            DataModule2.Table15.FindKey(
              [StrToInt(Form1.StringGrid2.Cells[1,row])]); { 00543605..21 }
            { 00543629: jmp 43F9B -> umbedingte while-Schleifesiehe unten }

            { 00543F9B: while-Schleife, Bedingung zuerst }
            while StrToInt(Form1.StringGrid2.Cells[1,row]) =
              DataModule2.Table15Nummer.AsInteger do          { 00543F9B }
            begin
              { 0054362E: Datum komplett zuruecksetzen }
              s3 := '';                                       { 0054362E..31 }
              { 00543636: Todes-Guard: Sajahr oder Saort, sonst Heirats-Guard }
              if (DataModule2.Table15Sajahr.AsString<>'') or
                 (Trim(DataModule2.Table15Saort.AsString)<>'') then { 0054364C..7D }
              begin
                { 00543683: Datum aus Stuecken (CatN5) }
                s2 := DataModule2.Table15Satag.AsString + '.' +
                  DataModule2.Table15Samonat.AsString + '.' +
                  DataModule2.Table15Sajahr.AsString;
                u := '';
                sub_0053D06C(s2, u);                          { 005436E8 }
                s3 := '(S) ' + u;                             { 00543702 }
                if Trim(DataModule2.Table15Saort.AsString)<>'' then
                  s3 := s3 + ' ' + DataModule2.Table15Saort.AsString; { 0054370C..66 }
                { 0054376B: jmp 438E7 }
              end
              else
              { 00543770: Heirats-Guard: Hjahr oder (Hort<>'') }
              if (DataModule2.Table15Hjahr.AsString<>'') or
                 (Trim(DataModule2.Table15Hort.AsString)<>'') then { 00543770..B7 }
              begin
                { 005437BD: Hcatn (CatN5) }
                s2 := DataModule2.Table15Htag.AsString + '.' +
                  DataModule2.Table15Hmonat.AsString + '.' +
                  DataModule2.Table15Hjahr.AsString;
                sub_0053D06C(s2, s3);                        { 0054381D+ }
                if Trim(DataModule2.Table15Hort.AsString)<>'' then
                  s3 := s3 + ' ' + DataModule2.Table15Hort.AsString; { 00543830..86 }
                if (Pos('Ehes', DataModule2.Table15Verbind.AsString)>0) and
                   (DataModule2.Table15Htag.AsString<>'HK') then { 0054388B..D5 }
                  s3 := '(K) ' + s3;                         { 005438D7..E2 }
              end;
              { 005438E7: Original-Nummer sichern, Table3-Index loeschen }
              nrSave := DataModule2.Table3Nummer.AsInteger;   { 005438ED }
              DataModule2.Table3.IndexName := '';             { 005438FE }
              DataModule2.Table3.FindKey(
                [DataModule2.Table15Epnum.AsInteger]);        { 00543905..21 }
              if Pos('Ehes', DataModule2.Table15Verbind.AsString)>0 then { 00543926..4B }
              begin                                            { oo-Zweig mit Klammern }
                nam2('                oo '+s3+': ');         { 00543951..76 }
                DataModule2.Table3.IndexName := '';           { 0054397B: Duplikat }
                DataModule2.Table3.FindKey(                   { 00543987: Duplikat }
                  [DataModule2.Table15Epnum.AsInteger]);
                if (DataModule2.Table3Vater.AsInteger>0) or
                   (DataModule2.Table3Mutter.AsInteger>0) then { 005439B7..CA }
                begin
                  { 005439D0: Vater-Anteil }
                  if DataModule2.Table3Vater.AsInteger>0 then { 005439DF }
                  begin
                    DataModule2.Table3.FindKey(              { 005439E5..A5 }
                      [DataModule2.Table3Vater.AsInteger]);
                    t := '';
                    Form1.ucase(DataModule2.Table3Name.AsString, t);
                    { 00543A08: '                   <'+ucase(Name)+' '+Vornamen (CatN4) }
                    s2 := '                   <' + t + ' ' +
                      Trim(DataModule2.Table3Vornamen.AsString);
                    if Trim(DataModule2.Table3Beruf.AsString)<>'' then
                      s2 := s2 + ', ' + Trim(DataModule2.Table3Beruf.AsString) + '/' { 43AA7 }
                    else
                      s2 := s2 + '/';                        { 00543AED..F5 }
                  end;
                  { 00543AFA: Partner wieder herstellen }
                  DataModule2.Table3.FindKey(
                    [DataModule2.Table15Epnum.AsInteger]);    { 00543AFA..B1 }
                  { 00543B1F: Mutter-Anteil }
                  if DataModule2.Table3Mutter.AsInteger>0 then { 00543B2C }
                  begin
                    DataModule2.Table3.FindKey(              { 00543B32..50 }
                      [DataModule2.Table3Mutter.AsInteger]);
                    t := '';
                    Form1.ucase(DataModule2.Table3Name.AsString, t);
                    s2 := s2 + t + ' ' +
                      Trim(DataModule2.Table3Vornamen.AsString); { 00543B55..C0 }
                    if Trim(DataModule2.Table3Beruf.AsString)<>'' then
                      s2 := s2 + ', ' + Trim(DataModule2.Table3Beruf.AsString) + '>' { 43BF2 }
                    else
                      s2 := s2 + '>';                        { 00543C38..C40 }
                  end;
                  DataModule2.Table14.Append;                 { 00543C45 }
                  DataModule2.Table14Zeile.AsString := s2;    { 00543C52..6F }
                  DataModule2.Table14.Post;                   { 00543C6D }
                  DataModule2.Table3.FindKey(                 { 00543C75 dup }
                    [DataModule2.Table15Epnum.AsInteger]);
                end;                                          { 00543C98: jmp 43F33 }
              end
              else
                begin                                          { o-o-Zweig 43C9D }
                  nam2('                o-o '+s3+': ');        { 00543C9D..CC4 }
                  DataModule2.Table3.FindKey(                 { 00543CC7..CE2 }
                    [DataModule2.Table15Epnum.AsInteger]);    { IndexName nicht zurueckgestellt }
                  if (DataModule2.Table3Vater.AsInteger>0) or
                     (DataModule2.Table3Mutter.AsInteger>0) then { 00543CF1..D0A }
                    { 00543D10: Vater-Anteil (rohe Felder) }
                    if DataModule2.Table3Vater.AsInteger>0 then { 00543D1F }
                    begin
                      DataModule2.Table3.FindKey(            { 00543D25..43 }
                        [DataModule2.Table3Vater.AsInteger]);
                      s2 := '                   <' +
                        DataModule2.Table3Name.AsString + ' ' +
                        DataModule2.Table3Vornamen.AsString; { 00543D48..D8C }
                      if Trim(DataModule2.Table3Beruf.AsString)<>'' then
                        s2 := s2 + ', ' + Trim(DataModule2.Table3Beruf.AsString) + '/' { 43D91 }
                      else
                        s2 := s2 + '/';                      { 00543E04..0C }
                    end;                                     { 43E02: jmp }
                  { 00543E11: FindKey([Epnum]) immer, Mutter danach }
                  DataModule2.Table3.FindKey(
                    [DataModule2.Table15Epnum.AsInteger]);    { 00543E1B..2F }
                  if DataModule2.Table3Mutter.AsInteger>0 then { 00543E34 }
                  begin
                    DataModule2.Table3.FindKey(              { 00543E49..67 }
                      [DataModule2.Table3Mutter.AsInteger]);
                    s2 := s2 + DataModule2.Table3Name.AsString + ' ' +
                      DataModule2.Table3Vornamen.AsString;    { raw, CatN4 }
                    if Trim(DataModule2.Table3Beruf.AsString)<>'' then
                      s2 := s2 + ', ' + Trim(DataModule2.Table3Beruf.AsString) + '>' { 43EE0 }
                    else
                      s2 := s2 + '>';                        { 00543F26..2E }
                  end;
                  { s4 tot: o-o erzeugt keine Ausgabe (kein Append/Post), Quirk } end;
              { 00543F33: gemeinsame Rueckkehr }
              DataModule2.Table3.FindKey(                    { 00543F33..51 }
                [DataModule2.Table15Epnum.AsInteger]);
              gebstvn('                   ',0);                { 00543F56..5F }
              DataModule2.Table3.FindKey([nrSave]);           { 00543F64..78 }
              DataModule2.Table15.Next;                       { 00543F7D }
              if DataModule2.Table15.EOF then
                Break;                                        { 00543F9B }
            end;                                               { 00543F9B: while Ende }
          end;                                                 { 00543FE1: for Ende }
        end;                                                   { 005432C1: Ober-Gate }
        { 00543FE7: while r>0 (Original: unten geprueft, dec r; jne 41BA0) }
        k := k+1;                                              { 00543FE7 }
        r := r-1;                                              { 00543FEA }
        end;                                                   { end: innere Table10-Schleife }
        end;                                                   { end: while r>0 }
        end;                                                   { end: if r>0 }
        end;                                                   { end: Grid-Gate StringGrid1 }

        { 00543FF3: Nicht-Ehelichen-Abschnitt: nur bei gefuellter Grid2-Zelle (1,0).
          Die restlichen Zeilen laufen aus dem married-loop heraus weiter. }
        if Trim(Form1.StringGrid2.Cells[1,0])<>'' then { 00544019: je 4475C }
        begin
          { 0054403E: 1. RowCount-Check: RowCount<=0 -> Sprung 4413B }
          if Form1.StringGrid2.RowCount>0 then        { 00544045: jl 4413B; signed-Test }
          begin
            { 00544053: Spalten-5-Scan - die erste leere Spalte-5-Zelle loest den
              Kopfblock aus; nichtleere Zeilen werden uebersprungen (jne 44131). }
            for row := 0 to Form1.StringGrid2.RowCount-1 do
              if TrimRight(Form1.StringGrid2.Cells[5,row])='' then { 0054408B: Fallin }
              begin                                          { Spacer-Block 00544091..44129 }
                { 44091/440A8: Append/Post ohne Zeile-Assignment (Quirk: Leerzeile) }
                DataModule2.Table14.Append;
                DataModule2.Table14.Post;
                DataModule2.Table14.Append;
                DataModule2.Table14Zeile.AsString := '---------------------------'; { 440CA }
                DataModule2.Table14.Post;                    { 440DA }
                DataModule2.Table14.Append;
                DataModule2.Table14Zeile.AsString := 'Nichteheliche(s) Kind(er): '; { 440FC }
                DataModule2.Table14.Post;                    { 4410C }
                { 44112/44129: Append/Post ohne Zeile-Assignment (Quirk: Leerzeile) }
                DataModule2.Table14.Append;
                DataModule2.Table14.Post;
                Break;                                       { 0054412F: Sprung nach 4413B }
              end;                                          { jne = weiter (Leerzellen-Scanner) }
          end;
          { 00544148: 2. RowCount-Check (doppelt, Quirk: der erste reichte schon) }
          if Form1.StringGrid2.RowCount>0 then        { 0054414F: jl 4475C }
          begin
            for row := 0 to Form1.StringGrid2.RowCount-1 do
            begin
              { 0054415D: Spalte-5-Scan: nichtleere Zellen ueberspringen (jne 44752) }
              if TrimRight(Form1.StringGrid2.Cells[5,row])<>'' then
                Continue;
              { 0054419B: Table3-Eintrag des Kinds: sonst ueberspringen (je 44752) }
              if not DataModule2.Table3.FindKey(
                [StrToInt(Form1.StringGrid2.Cells[1,row])]) then
                Continue;                                    { 005441DC..441DE }
              n := n+1;                                      { 005441E4: Kind-Zaehler [ebp-30] }
              { 005441EC..4421D: CatN3(544DBC='        ', IntToStr(n), 544EA4='. ') }
              nam2('        '+IntToStr(n)+'. ');
              gebstvn('               ',0);                  { 0054422B: 544F9C = 15 Leerzeichen }
              { 00544230: Mutter-Zeile nur bei Hauptperson 'M' und Mutter>0 }
              if (geschH='M') and
                 (DataModule2.Table3Mutter.AsInteger>0) then { 00544238..4424E }
              begin
                DataModule2.Table3.FindKey(
                  [DataModule2.Table3Mutter.AsInteger]);    { 0054425A..4426E }
                nam2('            Mutter: ');                 { 00544273: 544FB4 }
                gebstvn('                  ',0);               { 00544284: 544FD4 = 18 Leerzeichen }
              end;
              { 0054428B: Vater-Zeile nur bei Hauptperson 'W' und Vater>0
                (Quirk: der W-Zweig druckt das 'Vater:'-Label) }
              if (geschH='W') and
                 (DataModule2.Table3Vater.AsInteger>0) then { 00544293..442A9 }
              begin
                DataModule2.Table3.FindKey(
                  [DataModule2.Table3Vater.AsInteger]);     { 005442B5..442C9 }
                nam2('            Vater: ');                  { 005442CE: 544FF0 }
                gebstvn('                  ',0);              { 005442DF }
              end;
              { 005442E6: Tauf-/Selbstnachweisfreigabe? sonst ueberspringen }
              if not CheckBox12.Checked then
                Continue;                                    { 005442F6: je 44752 }
              DataModule2.Table15.IndexName := 'num';        { 005442FC }
              { 00544334: Zelleninhalt muss > ' ' sein (Quirk: jbe-Zeichenvergleich) }
              if Form1.StringGrid2.Cells[1,row]<=' ' then
                Continue;                                    { 0054433E: jbe 44752 }
              { 00544344: Table15-Schluessel suchen, sonst ueberspringen }
              if not DataModule2.Table15.FindKey(
                [StrToInt(Form1.StringGrid2.Cells[1,row])]) then
                Continue;                                    { 0054438A: je 44752 }
              { 00544710: Schleifenbedingung - Gleichheit Tabelle/Position }
            while StrToInt(Form1.StringGrid2.Cells[1,row]) =
              DataModule2.Table15Nummer.AsInteger do          { 00544710: je 44395 }

            begin                                            { 00544395 }
              s3 := '';                                      { 00544398: @LStrClr [ebp-8] }
              { 005443C9: Sterbe-Guard: Sajahr oder Saort, sonst Heirats-Guard }
              if (DataModule2.Table15Sajahr.AsString<>'') or
                 (Trim(DataModule2.Table15Saort.AsString)<>'') then { 005443AD..443E4 }
              begin
                { 005443EA..4444F: Datum aus Stuecken (CatN5: 488+48C+490 mit '.') }
                s2 := DataModule2.Table15Satag.AsString + '.' +
                  DataModule2.Table15Samonat.AsString + '.' +
                  DataModule2.Table15Sajahr.AsString;
                u := '';                                     { sub-Ziel vor CatN(3) }
                sub_0053D06C(s2, u);                        { 00544455 }
                s3 := '(S) ' + u;                           { 00544466: @LStrCat3 }
                if Trim(DataModule2.Table15Saort.AsString)<>'' then
                  s3 := s3 + ' ' + DataModule2.Table15Saort.AsString; { 00544486..444CD }
                { 005444D2: jmp 44629 }
              end
              else
              { 005444D7: Heirats-Guard: Hjahr oder (Trim Hort<>'') }
              if (DataModule2.Table15Hjahr.AsString<>'') or
                 (Trim(DataModule2.Table15Hort.AsString)<>'') then { 005444D7..4451E }
              begin
                s2 := DataModule2.Table15Htag.AsString + '.' +
                  DataModule2.Table15Hmonat.AsString + '.' +
                  DataModule2.Table15Hjahr.AsString;         { 00544524..44584: CatN5 }
                sub_0053D06C(s2, s3);                       { 0054458F }
                if Trim(DataModule2.Table15Hort.AsString)<>'' then
                  s3 := s3 + ' ' + DataModule2.Table15Hort.AsString; { 005445A7..445ED }
                if Pos('Ehes', DataModule2.Table15Verbind.AsString)>0 then { 005445F8..44617 }
                  s3 := '(K) ' + s3;                        { 00544619: @LStrCat3, kein HK-Vorgriff }
              end;
              nrSave := DataModule2.Table3Nummer.AsInteger; { 00544631 }
              DataModule2.Table3.FindKey(
                [DataModule2.Table15Epnum.AsInteger]);       { 00544643..44657 }
              if Pos('Ehes', DataModule2.Table15Verbind.AsString)>0 then { 00544662..44681 }
              begin                                          { oo-Zweig }
                nam2('                oo '+s3+': ');         { 00544683..446A8: CatN3 544EE8 }
                { 005446AD: jmp 446D9 }
              end
              else
                begin                                        { o-o-Zweig @446AF }
                  nam2('                o-o '+s3+': ');       { 005446B4..446D4: CatN3 544F3C }
                end;
              DataModule2.Table3.FindKey([nrSave]);          { 005446D9..446ED }
              DataModule2.Table15.Next;                      { 005446F2 }
              if DataModule2.Table15.EOF then
                Break;                                       { 0054470E: jne 44752 - Eof-Break }
            end;                                             { 00544710: while Ende }
          end;                                               { 00544756: for row Ende }
        end;                                                 { 0054414F: 2. RowCount-Check }
        end;                                                 { 0054402B: Gate Nicht-Ehelichen }
        { 0054475C: Abschluss-Leerzeile }
        DataModule2.Table14.Append;
        DataModule2.Table14.Post;                          { 00544773: TOC+248 }
        Form1.QRDefault;                                   { 00544780 }
        Form15.QRMemo1.Visible := True;                    { 00544796: SetVisible(dl=1) }
        Form15.QRMemo1.Left := 5;                          { 005447AB: SetLeft }
        Form15.QRMemo1.Width := Form1.DBMemo1.Width;       { 005447CD: SetWidth }
        Form15.QRMemo1.Font.Size := Form1.Memo1.Font.Size; { 005447F9: SetSize }
        Form15.QRMemo1.Lines.Clear;                        { 00544813: TStrings.Clear }
        { 00544816..44890: Table14-Zeilen in QRMemo1 uebernehmen }
        DataModule2.Table14.Open;                          { 0054481E }
        DataModule2.Table14.First;                         { 0054482B }
        while not DataModule2.Table14.EOF do
        begin
          Form15.QRMemo1.Lines.Add(
            DataModule2.Table14Zeile.AsString);           { 0054483A..44860 }
          DataModule2.Table14.Next;                        { 0054486B }
        end;                                               { 00544878..44890: eof-Check }
        DataModule2.Table14.Close;                         { 0054489A }
        DataModule2.Table14.TableName := 'outp.db';        { 005448AC: TTable.SetTableName }
        Form15.QuickRep1.DataSet := nil;                   { 005448C0: TQuickRep.SetDataSet }
        Form15.QRBand1.Height := 55;                       { 005448D7: SetHeight(37h) }
        Form15.QRBand3.Height := 20;                       { 005448EE: SetHeight(14h) }
        Form15.QRBand4.Height := 24;                       { 00544905: SetHeight(18h) }
        Form15.QRShape1.Visible := True;                   { 0054491B: SetVisible(dl=1) }
        Form15.QRShape3.Visible := True;                   { 0054492F: SetVisible(dl=1) }
        Form15.QRDBText1.Visible := False;                 { 00544943: SetVisible(dl=0) }
        Form15.QRDBText2.Visible := False;                 { 00544957: SetVisible(dl=0) }
        Form15.QRLabel1.Caption := gvar_02536930;          { 0054496F: TQRLabel.SetCaption }
        Form15.QRLabel1.Show;                              { 00544981: TControl.Show }
        Form15.QRLabel2.Show;                              { 00544993: TControl.Show }
        t := Trim(gvar_02536934);                          { 0054499E: Trim }
        if t<>'' then                                       { 005449B1: jbe 449CD }
          Form15.QRLabel2.Caption := gvar_02536934;        { 005449C8: SetCaption (ungetrimmt, Quirk) }
        DataModule2.Table14.Open;                          { 005449D5 }
        Form16.Label5.Visible := True;                     { 005449E9: SetVisible(dl=1) }
        Form16.Button9.Visible := True;                    { 005449FD: SetVisible(dl=1) }
        Form16.Button5.Visible := True;                    { 00544A11: SetVisible(dl=1) }
        Form16.SpeedButton3.Visible := True;               { 00544A25: SetVisible(dl=1) }
        Form16.SpeedButton6.Visible := False;              { 00544A39: SetVisible(dl=0) }
        Form15.QuickRep1.Page.Columns := 1;                { 00544A56: TQRPage.SetColumns }
        Form16.Show;                                       { 00544A62: TCustomForm.Show }
end;  { TForm17.BitBtn1Click - Ende (kein Epilogue uebernommen) }


procedure TForm17.BitBtn2Click(Sender: TObject);
begin
  { (005405A0) "Abbruch" - the form is closed with the value 2 in
    TCustomForm.FModalResult (mrCancel); the flag that the family chart
    was requested is cleared; the person is shown again. }
  ModalResult := 2;
  gvar_0061EFD0 := 0;
  Form1.anzeigen;
end;

procedure TForm17.gebstvn(AIn: AnsiString; AFlag: Integer);
var
  s, dat, nn: AnsiString;
begin
  { 0053D358: Schreibt die Geburts-, Tauf-, Taufpaten-, Sterbe- und
    Beerdigungszeilen der aktuellen Table3-Person nach Table14
    (Zeile [1E8]); angehängt wird nur, wenn s > AIn ist. AIn ([ebp-4])
    ist der Namenspräfix des Aufrufers (alle 4 Aufrufe stehen in
    BitBtn1Click), s = [ebp-8]; AFlag = 2. Registerparameter (ECX),
    Prolog sichert ihn per push ecx vor der Frame-Nullschleife und holt
    ihn per xchg ecx,[ebp-4] zurück - danach wird ECX nur noch
    selbst gesetzt (xor ecx,ecx / VMT-Load), der Eingabewert nie
    gelesen; alle Aufrufer übergeben xor ecx,ecx (toter Parameter);
    ESI = Self, EBX = DataModule2.
    Der erste Abschnitt (" Qu.: "/" Schreibweisen: ") läuft immer, die
    Zeilenblöcke nur bei gvar_02536930 = 'Familienblatt' und CheckBox15.
    Dort hängt der Familienblatt-Zweig die Geburtszeile an (s := s + ...),
    der andere Zweig überschreibt s; die Taufzeile überschreibt s in
    beiden Zweigen. }
  s := '';                                              {0053D391 LStrClr}
  if gvar_02536930 = 'Familienblatt' then               {0053D3A2 LStrCmp}
    if CheckBox2.Checked and                           {0053D3BD je}
      (DataModule2.Table3Quelle.AsString <>            {0053D3D3}
        IntToStr(gvar_0061EFD4)) and                    {0053D3E8 LStrCmp}
      DataModule2.Table38.FindKey([                    {0053D41D je, High = 0}
        DataModule2.Table3Quelle.AsString]) then
      s := AIn + ' Qu.: ' +                            {0053D447 CatN5, überschreibt s}
        DataModule2.Table38Titel.AsString + '. ' + #13#10;
  if Form17.CheckBox14.Checked and                     {0053D451 [0061EFC8] statt Self}
    (Trim(DataModule2.Table3Namex.AsString) <> '') then {0053D47E Trim}
    s := s + AIn + ' Schreibweisen: ' +                {0053D4BA CatN5}
      Trim(DataModule2.Table3Namex.AsString) + #13#10; {0053D4AA Trim}
  if (gvar_02536930 = 'Familienblatt') and              {0053D4D0 LStrCmp}
    CheckBox15.Checked then                             {0053D4EB je}
  begin
    { Familienblatt: erst die Geburtszeile, dann die Taufzeile,
      jede Zeile mit eigenem Post. }
    if (DataModule2.Table3Gebjahr.AsString <> '') or    {0053D505 ja}
      (DataModule2.Table3Gebort.AsString <> '') then    {0053D51B jbe, roh}
    begin
      dat := DataModule2.Table3Gebtag.AsString + '.' +  {0053D572 CatN5}
        DataModule2.Table3Gebmonat.AsString + '.' +
        DataModule2.Table3Gebjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053D582}
      s := s + AIn + ' * ' + nn;                        {0053D58D CatN4}
      if Trim(DataModule2.Table3Gebort.AsString) <> '' then {0053D5AD Trim}
        s := s + ' ' + DataModule2.Table3Gebort.AsString;    {0053D5D6 CatN3, roh}
      if CheckBox2.Checked and                         {0053D5F0 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053D61B LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053D650 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053D675 CatN4}
      if s > AIn then                                   {0053D685 LStrCmp}
      begin
        DataModule2.Table14.Append;                     {0053D694}
        DataModule2.Table14Zeile.AsString := s;         {0053D6A6}
        DataModule2.Table14.Post;                       {0053D6B6}
      end;
    end;
    if (DataModule2.Table3Taufjahr.AsString <> '') or  {0053D6D0 ja}
      (DataModule2.Table3Taufort.AsString <> '') then   {0053D6E6 jbe, roh}
    begin
      dat := DataModule2.Table3Tauftag.AsString + '.' + {0053D740 CatN5}
        DataModule2.Table3Taufmonat.AsString + '.' +
        DataModule2.Table3Taufjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053D750}
      s := AIn + ' ~ ' + nn;                            {0053D75B CatN3, überschreibt s}
      if Trim(DataModule2.Table3Taufort.AsString) <> '' then {0053D784 Trim}
        s := s + ' ' + DataModule2.Table3Taufort.AsString;   {0053D7B6 CatN3, roh}
      if CheckBox2.Checked and                         {0053D7D0 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053D807 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053D842 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053D86D CatN4}
      if s > AIn then                                   {0053D87D LStrCmp}
      begin
        DataModule2.Table14.Append;                     {0053D890}
        DataModule2.Table14Zeile.AsString := s;         {0053D8A2}
        DataModule2.Table14.Post;                       {0053D8B2}
      end;
    end;                                                {0053D8B8 jmp 0053DCE4}
  end
  else
  begin
    { ohne Familienblatt: Geburts- und Taufzeile laufen nacheinander,
      jede Zeile überschreibt s neu. }
    if (DataModule2.Table3Gebjahr.AsString <> '') or    {0053D8D7 ja}
      (DataModule2.Table3Gebort.AsString <> '') then    {0053D8F3 jbe, roh}
    begin
      dat := DataModule2.Table3Gebtag.AsString + '.' +  {0053D95C CatN5}
        DataModule2.Table3Gebmonat.AsString + '.' +
        DataModule2.Table3Gebjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053D972}
      s := AIn + ' * ' + nn;                            {0053D980 CatN3, überschreibt s}
      if Trim(DataModule2.Table3Gebort.AsString) <> '' then {0053D9A9 Trim}
        s := s + ' ' + DataModule2.Table3Gebort.AsString;    {0053D9DB CatN3, roh}
      if CheckBox2.Checked and                         {0053D9F5 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053DA2C LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053DA67 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053DA92 CatN4}
      if s > AIn then                                   {0053DAA2 LStrCmp}
      begin
        DataModule2.Table14.Append;                     {0053DAB1}
        DataModule2.Table14Zeile.AsString := s;         {0053DAC3}
        DataModule2.Table14.Post;                       {0053DAD3}
      end;
    end;
    if (DataModule2.Table3Taufjahr.AsString <> '') or  {0053DAF3 ja}
      (DataModule2.Table3Taufort.AsString <> '') then   {0053DB0F jbe, roh}
    begin
      dat := DataModule2.Table3Tauftag.AsString + '.' + {0053DB78 CatN5}
        DataModule2.Table3Taufmonat.AsString + '.' +
        DataModule2.Table3Taufjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053DB8E}
      s := AIn + ' ~ ' + nn;                            {0053DB9C CatN3, überschreibt s}
      if DataModule2.Table3Taufort.AsString <> '' then {0053DBB9 jbe, roh - kein Trim}
        s := s + ' ' + DataModule2.Table3Taufort.AsString;   {0053DBE6 CatN3, roh}
      if CheckBox2.Checked and                         {0053DC00 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053DC37 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053DC72 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053DC9D CatN4}
      if s > AIn then                                   {0053DCAD LStrCmp}
      begin
        DataModule2.Table14.Append;                     {0053DCBC}
        DataModule2.Table14Zeile.AsString := s;         {0053DCCE}
        DataModule2.Table14.Post;                       {0053DCDE}
      end;
    end;
  end;
  if CheckBox4.Checked and                             {0053DCF4 je}
    (DataModule2.Table3Taufpat.AsString <> '') then     {0053DD14 jbe, roh}
  begin
    s := s + 'TP: ' + DataModule2.Table3Taufpat.AsString; {0053DD36 Cat3 - Quirk: s
      wird gleich danach gelöscht, die Zuweisung ist wirkungslos }
    DataModule2.Table14.Append;                         {0053DD48}
    DataModule2.Table14Zeile.AsString :=                {0053DD74 CatN3}
      AIn + 'TP: ' + DataModule2.Table3Taufpat.AsString;
    DataModule2.Table14.Post;                           {0053DD9E}
  end;
  s := '';                                              {0053DDA7 LStrClr}
  if (gvar_02536930 = 'Familienblatt') and              {0053DDB8 LStrCmp}
    CheckBox15.Checked then                             {0053DDD3 je}
  begin
    { Familienblatt: Sterbezeile mit eigenem Post, danach s leeren
      und die Beerdigungszeile bauen. }
    if (DataModule2.Table3Stjahr.AsString <> '') or    {0053DDF3 ja}
      (DataModule2.Table3Stort.AsString <> '') then    {0053DE0F jbe, roh}
    begin
      if Trim(s) = '' then                              {0053DE1E Trim}
        s := AIn;                                       {0053DE32 LStrLAsg}
      dat := DataModule2.Table3Sttag.AsString + '.' +  {0053DE9A CatN5}
        DataModule2.Table3Stmonat.AsString + '.' +
        DataModule2.Table3Stjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053DEB0}
      s := s + ' + ' + nn;                              {0053DEBE CatN3}
      if Trim(DataModule2.Table3Stort.AsString) <> '' then {0053DEE7 Trim}
        s := s + ' ' + DataModule2.Table3Stort.AsString;    {0053DF19 CatN3, roh}
      if CheckBox8.Checked and                         {0053DF33 je}
        (DataModule2.Table3Todesurs.AsString <> '') then {0053DF4F jbe, roh}
        s := s + ' (' + DataModule2.Table3Todesurs.AsString + ')'; {0053DF7A CatN4, roh}
      if CheckBox2.Checked and                         {0053DF94 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053DFCB LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053E006 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053E031 CatN4}
    end;
    if Trim(s) <> '' then                              {0053E044 Trim, jbe 0053E082}
    begin
      DataModule2.Table14.Append;                       {0053E05A}
      DataModule2.Table14Zeile.AsString := s;           {0053E06C}
      DataModule2.Table14.Post;                         {0053E07C}
    end;
    s := '';                                            {0053E085 LStrClr}
    if (DataModule2.Table3Begjahr.AsString <> '') or   {0053E0A4 ja}
      (Trim(DataModule2.Table3Begort.AsString) <> '') then {0053E0C5 Trim, jbe 0053E6F7}
    begin
      dat := DataModule2.Table3Begtag.AsString + '.' + {0053E13A CatN5}
        DataModule2.Table3Begmonat.AsString + '.' +
        DataModule2.Table3Begjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053E150}
      s := AIn + ' # ' + nn;                            {0053E15E CatN3, überschreibt s}
      if Trim(DataModule2.Table3Begort.AsString) <> '' then {0053E187 Trim}
        s := s + ' ' + DataModule2.Table3Begort.AsString;   {0053E1B9 CatN3, roh}
      if CheckBox2.Checked and                         {0053E1D3 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053E20A LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053E249 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053E278 CatN4}
    end;                                                {0053E282 jmp 0053E6F7}
  end
  else
  begin
    { ohne Familienblatt: Sterbe- ODER Beerdigungszeile (else-if). }
    if (DataModule2.Table3Stjahr.AsString <> '') or    {0053E2A1 ja}
      (Trim(DataModule2.Table3Stort.AsString) <> '') then {0053E2C2 Trim, jbe 0053E507}
    begin
      if Trim(s) = '' then                              {0053E2DD Trim}
        s := AIn;                                       {0053E2F1 LStrLAsg}
      dat := DataModule2.Table3Sttag.AsString + '.' +  {0053E359 CatN5}
        DataModule2.Table3Stmonat.AsString + '.' +
        DataModule2.Table3Stjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053E36F}
      s := s + ' + ' + nn;                              {0053E37D CatN3}
      if Trim(DataModule2.Table3Stort.AsString) <> '' then {0053E3A6 Trim}
        s := s + ' ' + DataModule2.Table3Stort.AsString;    {0053E3D8 CatN3, roh}
      if CheckBox8.Checked and                         {0053E3F2 je}
        (DataModule2.Table3Todesurs.AsString <> '') then {0053E40E jbe, roh}
        s := s + ' (' + DataModule2.Table3Todesurs.AsString + ')'; {0053E439 CatN4, roh}
      if CheckBox2.Checked and                         {0053E453 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053E48A LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053E4C9 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053E4F8 CatN4}
    end                                                 {0053E502 jmp 0053E6F7}
    else if (DataModule2.Table3Begjahr.AsString <> '') or {0053E521 ja}
      (Trim(DataModule2.Table3Begort.AsString) <> '') then {0053E542 Trim, jbe 0053E6F7}
    begin
      dat := DataModule2.Table3Begtag.AsString + '.' + {0053E5B7 CatN5}
        DataModule2.Table3Begmonat.AsString + '.' +
        DataModule2.Table3Begjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053E5CD}
      s := AIn + ' # ' + nn;                            {0053E5DB CatN3, überschreibt s}
      if Trim(DataModule2.Table3Begort.AsString) <> '' then {0053E604 Trim}
        s := s + ' ' + DataModule2.Table3Begort.AsString;   {0053E636 CatN3, roh}
      if CheckBox2.Checked and                         {0053E650 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053E687 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053E6C2 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053E6ED CatN4}
    end;
  end;
  if s > AIn then                                       {0053E6FD LStrCmp, jbe 0053E734}
  begin
    DataModule2.Table14.Append;                         {0053E70C}
    DataModule2.Table14Zeile.AsString := s;             {0053E71E}
    DataModule2.Table14.Post;                           {0053E72E}
  end;
end;

procedure TForm17.gebst(AIn: AnsiString);
var
  s, dat, nn: AnsiString;
begin
  { 0053E878: Zwilling von gebstvn, aber ohne den Taufpaten-Block und
    ohne die "Qu.: "-Zeile des zweiten Abschnitts - im Gegenteil: hier
    werden die Zeilen mit "s > AIn" und mit "Trim(s) <> ''" geprüft,
    die Ortsprüfungen aller vier Zeilen laufen über Trim (gebstvn prüft
    die Ortsfelder der Geburts-/Taufzeilen roh), und vor der Sterbezeile
    steht ein zweites "Alter"-Stück (0053F383), das es dort nicht gibt.
    Außerdem wird vor der Sterbezeile mit Length(s) = 0 geprüft,
    gebstvn dagegen mit Trim(s) = ''.
    AIn ([ebp-4]) ist der Namenspräfix des Aufrufers, s = [ebp-8];
    ESI = Self, EBX = DataModule2. }
  s := '';                                              {0053E8AD LStrClr}
  if gvar_02536930 = 'Familienblatt' then               {0053E8BE LStrCmp}
    if CheckBox2.Checked and                           {0053E8D9 je}
      (DataModule2.Table3Quelle.AsString <>            {0053E8EF}
        IntToStr(gvar_0061EFD4)) and                    {0053E904 LStrCmp}
      DataModule2.Table38.FindKey([                    {0053E939 je, High = 0}
        DataModule2.Table3Quelle.AsString]) then
      s := AIn + ' Qu.: ' +                            {0053E963 CatN5, überschreibt s}
        DataModule2.Table38Titel.AsString + '. ' + #13#10;
  if Form17.CheckBox14.Checked and                     {0053E96D [0061EFC8] statt Self}
    (Trim(DataModule2.Table3Namex.AsString) <> '') then {0053E99A Trim}
    s := s + AIn + ' Schreibweisen: ' +                {0053E9D6 CatN5}
      Trim(DataModule2.Table3Namex.AsString) + #13#10; {0053E9C6 Trim}
  if (gvar_02536930 = 'Familienblatt') and              {0053E9EC LStrCmp}
    CheckBox15.Checked then                             {0053EA07 je}
  begin
    { Familienblatt: Geburtszeile, Post, s leeren, Taufzeile. }
    if (DataModule2.Table3Gebjahr.AsString <> '') or    {0053EA21 ja}
      (Trim(DataModule2.Table3Gebort.AsString) <> '') then {0053EA39 Trim, jbe 0053EBA6}
    begin
      dat := DataModule2.Table3Gebtag.AsString + '.' +  {0053EA99 CatN5}
        DataModule2.Table3Gebmonat.AsString + '.' +
        DataModule2.Table3Gebjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053EAA9}
      s := s + AIn + ' * ' + nn;                        {0053EAB4 CatN4}
      if Trim(DataModule2.Table3Gebort.AsString) <> '' then {0053EAD4 Trim}
        s := s + ' ' + DataModule2.Table3Gebort.AsString;    {0053EAFD CatN3, roh}
      if CheckBox2.Checked and                         {0053EB17 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053EB42 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053EB77 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053EB9C CatN4}
    end;
    if Trim(s) <> '' then                              {0053EBAC Trim, jbe 0053EBE7}
    begin
      DataModule2.Table14.Append;                       {0053EBBF}
      DataModule2.Table14Zeile.AsString := s;           {0053EBD1}
      DataModule2.Table14.Post;                         {0053EBE1}
    end;
    s := '';                                            {0053EBEA LStrClr}
    if (DataModule2.Table3Taufjahr.AsString <> '') or  {0053EC03 ja}
      (Trim(DataModule2.Table3Taufort.AsString) <> '') then {0053EC1B Trim, jbe 0053F1C1}
    begin
      dat := DataModule2.Table3Tauftag.AsString + '.' + {0053EC8D CatN5}
        DataModule2.Table3Taufmonat.AsString + '.' +
        DataModule2.Table3Taufjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053ECA0}
      s := AIn + ' ~ ' + nn;                            {0053ECAB CatN3, überschreibt s}
      if Trim(DataModule2.Table3Taufort.AsString) <> '' then {0053ECD4 Trim}
        s := s + ' ' + DataModule2.Table3Taufort.AsString;   {0053ED06 CatN3, roh}
      if CheckBox2.Checked and                         {0053ED20 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053ED57 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053ED96 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053EDC5 CatN4}
    end;                                                {0053EDCF jmp 0053F1C1}
  end
  else
  begin
    { ohne Familienblatt: Geburt ODER Tauf (else-if). }
    if (DataModule2.Table3Gebjahr.AsString <> '') or    {0053EDEE ja}
      (Trim(DataModule2.Table3Gebort.AsString) <> '') then {0053EE0F Trim, jbe 0053EFD1}
    begin
      dat := DataModule2.Table3Gebtag.AsString + '.' +  {0053EE84 CatN5}
        DataModule2.Table3Gebmonat.AsString + '.' +
        DataModule2.Table3Gebjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053EE9A}
      s := AIn + ' * ' + nn;                            {0053EEA8 CatN3, überschreibt s}
      if Trim(DataModule2.Table3Gebort.AsString) <> '' then {0053EED1 Trim}
        s := s + ' ' + DataModule2.Table3Gebort.AsString;    {0053EF03 CatN3, roh}
      if CheckBox2.Checked and                         {0053EF1D je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053EF54 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053EF93 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053EFC2 CatN4}
    end                                                 {0053EFCC jmp 0053F1C1}
    else if (DataModule2.Table3Taufjahr.AsString <> '') or {0053EFEB ja}
      (Trim(DataModule2.Table3Taufort.AsString) <> '') then {0053F00C Trim, jbe 0053F1C1}
    begin
      dat := DataModule2.Table3Tauftag.AsString + '.' + {0053F081 CatN5}
        DataModule2.Table3Taufmonat.AsString + '.' +
        DataModule2.Table3Taufjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053F097}
      s := AIn + ' ~ ' + nn;                            {0053F0A5 CatN3, überschreibt s}
      if Trim(DataModule2.Table3Taufort.AsString) <> '' then {0053F0CE Trim}
        s := s + ' ' + DataModule2.Table3Taufort.AsString;   {0053F100 CatN3, roh}
      if CheckBox2.Checked and                         {0053F11A je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053F151 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053F18C je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053F1B7 CatN4}
    end;
  end;
  if s > AIn then                                       {0053F1C7 LStrCmp, jbe 0053F1FE}
  begin
    DataModule2.Table14.Append;                         {0053F1D6}
    DataModule2.Table14Zeile.AsString := s;             {0053F1E8}
    DataModule2.Table14.Post;                           {0053F1F8}
  end;
  s := '';                                              {0053F201 LStrClr}
  if (gvar_02536930 = 'Familienblatt') and              {0053F212 LStrCmp}
    CheckBox15.Checked then                             {0053F22D je}
  begin
    { Familienblatt: Sterbezeile mit eigenem Post, danach s leeren
      und die Beerdigungszeile bauen. }
    if (DataModule2.Table3Stjahr.AsString <> '') or    {0053F24D ja}
      (Trim(DataModule2.Table3Stort.AsString) <> '') then {0053F26E Trim, jbe 0053F4FC}
    begin
      if Length(s) = 0 then                             {0053F283 LStrLen}
        s := AIn;                                       {0053F292 LStrLAsg}
      dat := DataModule2.Table3Sttag.AsString + '.' +  {0053F2FA CatN5}
        DataModule2.Table3Stmonat.AsString + '.' +
        DataModule2.Table3Stjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053F310}
      s := s + ' + ' + nn;                              {0053F31E CatN3}
      if Trim(DataModule2.Table3Stort.AsString) <> '' then {0053F347 Trim}
        s := s + ' ' + DataModule2.Table3Stort.AsString;    {0053F379 CatN3, roh}
      if CheckBox15.Checked and                         {0053F393 je - Quirk: CB15 ist
        hier schon nachgewiesen, geprüft wird es noch einmal }
        (DataModule2.Table3Alter.AsString <> '') then    {0053F3AF jbe, roh}
        s := s + ' (' + DataModule2.Table3Alter.AsString + ')'; {0053F3DA CatN4, roh}
      if CheckBox8.Checked and                         {0053F3F4 je}
        (DataModule2.Table3Todesurs.AsString <> '') then {0053F410 jbe, roh}
        s := s + ' (' + DataModule2.Table3Todesurs.AsString + ')'; {0053F43B CatN4, roh}
      if CheckBox2.Checked and                         {0053F455 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053F48C LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053F4C7 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053F4F2 CatN4}
    end;
    if Trim(s) <> '' then                              {0053F505 Trim, jbe 0053F543}
    begin
      DataModule2.Table14.Append;                       {0053F51B}
      DataModule2.Table14Zeile.AsString := s;           {0053F52D}
      DataModule2.Table14.Post;                         {0053F53D}
    end;
    s := '';                                            {0053F546 LStrClr}
    if (DataModule2.Table3Begjahr.AsString <> '') or   {0053F565 ja}
      (Trim(DataModule2.Table3Begort.AsString) <> '') then {0053F586 Trim, jbe 0053FBA8}
    begin
      dat := DataModule2.Table3Begtag.AsString + '.' + {0053F5FB CatN5}
        DataModule2.Table3Begmonat.AsString + '.' +
        DataModule2.Table3Begjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053F611}
      s := AIn + ' # ' + nn;                            {0053F61F CatN3, überschreibt s}
      if Trim(DataModule2.Table3Begort.AsString) <> '' then {0053F648 Trim}
        s := s + ' ' + DataModule2.Table3Begort.AsString;   {0053F67A CatN3, roh}
      if CheckBox2.Checked and                         {0053F694 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053F6CB LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053F70A je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053F739 CatN4}
    end;                                                {0053F743 jmp 0053FBA8}
  end
  else
  begin
    { ohne Familienblatt: Sterbe- ODER Beerdigungszeile (else-if). }
    if (DataModule2.Table3Stjahr.AsString <> '') or    {0053F762 ja}
      (Trim(DataModule2.Table3Stort.AsString) <> '') then {0053F783 Trim, jbe 0053F9BD}
    begin
      if Length(s) = 0 then                             {0053F798 LStrLen}
        s := AIn;                                       {0053F7A7 LStrLAsg}
      dat := DataModule2.Table3Sttag.AsString + '.' +  {0053F80F CatN5}
        DataModule2.Table3Stmonat.AsString + '.' +
        DataModule2.Table3Stjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053F825}
      s := s + ' + ' + nn;                              {0053F833 CatN3}
      if Trim(DataModule2.Table3Stort.AsString) <> '' then {0053F85C Trim}
        s := s + ' ' + DataModule2.Table3Stort.AsString;    {0053F88E CatN3, roh}
      if CheckBox8.Checked and                         {0053F8A8 je}
        (DataModule2.Table3Todesurs.AsString <> '') then {0053F8C4 jbe, roh}
        s := s + ' (' + DataModule2.Table3Todesurs.AsString + ')'; {0053F8EF CatN4, roh}
      if CheckBox2.Checked and                         {0053F909 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053F940 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053F97F je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053F9AE CatN4}
    end                                                 {0053F9B8 jmp 0053FBA8}
    else if (DataModule2.Table3Begjahr.AsString <> '') or {0053F9D7 ja}
      (Trim(DataModule2.Table3Begort.AsString) <> '') then {0053F9F8 Trim, jbe 0053FBA8}
    begin
      dat := DataModule2.Table3Begtag.AsString +       {0053FA68 CatN4 - Quirk: der
        erste Punkt der Geburts-/Sterbedatumsbildung fehlt, nur zwischen
        Monat und Jahr steht ein Punkt }
        DataModule2.Table3Begmonat.AsString + '.' +
        DataModule2.Table3Begjahr.AsString;
      sub_0053D06C(dat, nn);                            {0053FA7E}
      s := AIn + ' # ' + nn;                            {0053FA8C CatN3, überschreibt s}
      if Trim(DataModule2.Table3Begort.AsString) <> '' then {0053FAB5 Trim}
        s := s + ' ' + DataModule2.Table3Begort.AsString;   {0053FAE7 CatN3, roh}
      if CheckBox2.Checked and                         {0053FB01 je}
        (DataModule2.Table3Quelle.AsString <>
          IntToStr(gvar_0061EFD4)) and                  {0053FB38 LStrCmp}
        DataModule2.Table38.FindKey([
          DataModule2.Table3Quelle.AsString]) then      {0053FB73 je}
        s := s + ' [' + DataModule2.Table38Titel.AsString + ']'; {0053FB9E CatN4}
    end;
  end;
  if s > AIn then                                       {0053FBAE LStrCmp, jbe 0053FBE5}
  begin
    DataModule2.Table14.Append;                         {0053FBBD}
    DataModule2.Table14Zeile.AsString := s;             {0053FBCF}
    DataModule2.Table14.Post;                           {0053FBDF}
  end;
end;


end.
