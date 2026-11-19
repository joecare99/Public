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
  SysUtils, Classes, Buttons, ExtCtrls, StdCtrls, Forms, Controls, Grids, DB, Unit2, AHNGlobals, Unit1, StrUtils;

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

procedure TForm17.BitBtn1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

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
