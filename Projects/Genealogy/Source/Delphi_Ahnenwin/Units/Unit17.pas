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
    procedure gebstvn; //0053D358
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

procedure TForm17.gebstvn;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm17.gebst(AIn: AnsiString);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;


end.
