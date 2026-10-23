unit Unit3;

{-------------------------------------------------------------------------------
  Unit3 - TForm3, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit3.pas and the original resource
  Source\Projects_AhnenWin\Form3.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  Windows, SysUtils, StrUtils, Classes, StdCtrls, Buttons, DBTables, DBCommon, Dialogs, Forms, Controls, Grids, DB, AHNGlobals, Unit1, Unit2;

type
  TForm3 = class(TForm)
  published
    Label1: TLabel; //2F0
    Label3: TLabel; //2F4
    Label2: TLabel; //2F8
    Edit1: TEdit; //2FC
    BitBtn2: TBitBtn; //300
    Edit2: TEdit; //304
    Button1: TButton; //308
    Query1: TQuery; //30C
    OpenDialog1: TOpenDialog; //310
    SaveDialog1: TSaveDialog; //314
    procedure Bapm(AIn: AnsiString; AFlag: Integer; var AEs: AnsiString); //005797B0
    procedure Birt(AIn: AnsiString; var AEs: AnsiString); //00578E28
    procedure Sex(AIn: AnsiString; var AEs: AnsiString); //00578C84
    procedure Occu(AIn: AnsiString; var AEs: AnsiString); //0057B5C8
    procedure Buri(AIn: AnsiString; var AEs: AnsiString); //0057AC40
    procedure Deat(AIn: AnsiString; var AEs: AnsiString); //0057A258
    procedure Nam(AIn: AnsiString; var AEs: AnsiString); //00578A48
    procedure ofb3; //00585048
    procedure ofb2; //0058CB84
    procedure indi; //005967C8
    procedure Ortdreh(AOrt: AnsiString; var AErgebnis: AnsiString); //0057893C
    procedure oabk; //00584EBC
    procedure illki; //00584350
    procedure Even(AIn: AnsiString); //0057B94C
    procedure zsa(ALine: AnsiString; var AErgebnis: AnsiString); //00577834
    procedure ansl(AIn: AnsiString; var AOut: AnsiString); //005832F8
    procedure sour; //005BF434
    procedure gedein_5; //005BFB94
    procedure famn; //0057D560
    procedure Prop; //0057C8B8
    procedure Educ(AIn: AnsiString); //0057C3E0
    procedure Grad(AIn: AnsiString); //0057BEC0
    procedure Note; //0057CF58
    procedure Chan; //0057CC58
    procedure Resi(AIn: AnsiString); //0057CA24
    procedure ans(AIn: AnsiString; var AOut: AnsiString); //005836E8
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //00584254
    procedure Edit2KeyPress(Sender: TObject; var Key: Char); //00584224
    procedure Edit1KeyPress(Sender: TObject; var Key: Char); //005841F4
    function ucase(const AAnsiString: AnsiString): AnsiString; //00583788
    procedure showpreview; //00583D38
    procedure FormCreate(Sender: TObject); //0058426C
    procedure Edit2Exit(Sender: TObject); //005841EC
    procedure BitBtn2Click(Sender: TObject); //00584080
    procedure FormActivate(Sender: TObject); //00584054
    procedure Button1Click(Sender: TObject); //00583D74
    procedure Edit1Exit(Sender: TObject); //005840EC
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //005840D0
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //005840B4
    procedure refelt; //00583930
    procedure adrschreib; //005B3A3C
    procedure gedausxv; //005B4288
    procedure gedausv; //005B5224
    procedure lieszeil; //005773C4
    procedure osbein; //005B229C
    procedure ahndosein; //005AFB9C
    procedure gedausx; //005A634C
    procedure gedein; //0059D218
    procedure OList; //00595FB4
    procedure NList; //00595720
    procedure gedaus; //005A7C40
    procedure gedein_neu; //0057EDEC
    procedure gedein2; //00596994
  end;

var
  Form3: TForm3;

implementation

{$R ..\Forms\Form3.DFM}

{ Local helpers of the original, unit level (not members of TForm3). }

procedure sub_00576EB0(AValue: Integer; var AResult: AnsiString);
var
  s: AnsiString;
begin
  { Formats the number to 6 digits, zero padded from the right. }
  s := '000000' + IntToStr(AValue);
  AResult := Copy(s, Length(s) - 5, 6);
end;

procedure sub_00576F54(AValue: Integer; var AResult: AnsiString);
var
  s: AnsiString;
begin
  { Formats the number to 6 characters, right aligned, space padded. }
  s := '      ' + IntToStr(AValue);
  AResult := Copy(s, Length(s) - 5, 6);
end;

procedure sub_00576FF8(ALine: AnsiString; var AErgebnis: AnsiString);
var
  i: Integer;
  s: AnsiString;
begin
  { Normalizes a date/comment entry: the prefixes ("..", "HK ", "vor...",
    "nach...") are evaluated, then leading dots and blanks are removed
    and the remaining dots are stripped. }
  AErgebnis := ALine;
  s := ALine;
  if Trim(s) = '..' then
  begin
    AErgebnis := '';
    exit;
  end;
  if Copy(s, 1, 2) = 'HK' then
  begin
    AErgebnis := 'HK ' + Copy(s, 4, 7);
    exit;
  end;
  if Pos('vo.r', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 1) + ' ' + RightStr(s, 4);
    exit;
  end;
  if Pos('na.ch', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 2) + ' ' + RightStr(s, 4);
    exit;
  end;
  if Trim(s) = '' then
    exit;
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
          break;
        end;
  end;
end;

procedure sub_005772E4(ALine: AnsiString);
var
  s, t: AnsiString;
begin
  { Appends ALine to the comment field (TMemoField) of table 1, with
    a line break as separator when the field is not empty. }
  if Trim(DataModule2.Table1Kommentar.AsString) <> '' then
    s := #13#10
  else
    s := '';
  t := TrimRight(DataModule2.Table1Kommentar.AsString) + s + ALine;
  DataModule2.Table1Kommentar.AsString := t;
end;

procedure sub_00577544(AMon: AnsiString; var ANr: AnsiString);
begin
  { Evaluates a 3-digit month name (JAN, MAI, OKT etc.) to a two-digit
    number. The month names are searched in the row of all German and
    English spellings. }
  case Pos(AMon, 'JANFEBMARM' + #228 + 'RAPRMAYMAIJUNJULAUGSEPOCTOKTNOVDECDEZ') of
    1:  ANr := '01';
    4:  ANr := '02';
    7:  ANr := '03';
    10: ANr := '03';
    13: ANr := '04';
    16: ANr := '05';
    19: ANr := '05';
    22: ANr := '06';
    25: ANr := '07';
    28: ANr := '08';
    31: ANr := '09';
    34: ANr := '10';
    37: ANr := '10';
    40: ANr := '11';
    43: ANr := '12';
    46: ANr := '12';
  else
    ANr := '';
  end;
end;

procedure sub_00577934(ADatum: AnsiString);
var
  s, kstr: AnsiString;
  ok: Integer;
  wY, wM, wD: Word;
begin
  { Evaluates a date (structured or as a free text entry) to the global
    date parts gvar_02536624 (day or keyword start), gvar_02536628
    (month or keyword ending) and gvar_0253662C (year). The entry can
    begin with the GEDCOM keywords BEF, AFT, ABT, CAL, EST or with the
    internal two-digit keywords CA, UM, VO, NA, ER, AB, CI. }
  if (Trim(ADatum) = '.  .') or (Trim(ADatum) = '..') or (Trim(ADatum) = '') then
  begin
    gvar_02536624 := '';
    gvar_02536628 := '';
    gvar_0253662C := '';
    exit;
  end;
  ok := 0;
  kstr := 'CA UM VO NA ER AB CI';
  gvar_02536624 := '';
  gvar_02536628 := '';
  gvar_0253662C := '';
  try
    DecodeDate(StrToDate(ADatum), wY, wM, wD);
    { The original stores wY in gvar_0253662C, wM in gvar_02536628 and
      wD in gvar_02536624 (without preceding zeros for the year, with
      preceding zeros for the month/day). }
    gvar_0253662C := IntToStr(wY);
    gvar_02536628 := RightStr('00' + Trim(IntToStr(wM)), 2);
    gvar_02536624 := RightStr('00' + Trim(IntToStr(wD)), 2);
    ok := 1;
  except
  end;
  if ok <> 0 then
    exit;
  s := ADatum;
  if UpperCase(Copy(s, 1, 3)) = 'BEF' then
  begin
    gvar_02536624 := 'vo';
    if Pos(Copy(s, 7, 1), '1234567890') > 0 then
      gvar_02536628 := 'r'
    else
      sub_00577544(UpperCase(Copy(s, 5, 3)), gvar_02536628);
    gvar_0253662C := RightStr(ADatum, 4);
    exit;
  end;
  if UpperCase(Copy(s, 1, 3)) = 'AFT' then
  begin
    gvar_02536624 := 'na';
    if Pos(Copy(s, 7, 1), '1234567890') > 0 then
      gvar_02536628 := 'ch'
    else
      sub_00577544(UpperCase(Copy(s, 5, 3)), gvar_02536628);
    gvar_0253662C := RightStr(ADatum, 4);
    exit;
  end;
  if UpperCase(Copy(s, 1, 3)) = 'ABT' then
  begin
    if Pos(Copy(s, 7, 1), '1234567890') > 0 then
      gvar_02536624 := 'um'
    else
    begin
      sub_00577544(UpperCase(Copy(s, 5, 3)), gvar_02536628);
      gvar_02536628 := gvar_02536628 + '.';
    end;
    gvar_0253662C := RightStr(ADatum, 4);
    exit;
  end;
  if (UpperCase(Copy(s, 1, 3)) = 'CAL') or (UpperCase(Copy(s, 1, 3)) = 'EST') then
  begin
    gvar_02536624 := 'er';
    if Pos(Copy(s, 7, 1), '1234567890') > 0 then
      gvar_02536628 := 'r'
    else
      sub_00577544(UpperCase(Copy(s, 5, 3)), gvar_02536628);
    gvar_0253662C := RightStr(ADatum, 4);
    exit;
  end;
  if (Length(s) = 6) and (Copy(s, 1, 2) = '..') then
  begin
    gvar_0253662C := Copy(s, 3, 4);
    exit;
  end;
  if (Length(s) = 8) and (Copy(s, 1, 1) = '.') and (Copy(s, 4, 1) = '.') then
  begin
    gvar_02536624 := ' ';
    gvar_02536628 := Copy(s, 2, 2);
    gvar_0253662C := Copy(s, 5, 4);
    exit;
  end;
  if (Length(s) = 10) and (Copy(s, 3, 1) = '.') and (Copy(s, 6, 1) = '.') then
  begin
    gvar_02536624 := Copy(s, 1, 2);
    gvar_02536628 := Copy(s, 4, 2);
    gvar_0253662C := Copy(s, 7, 4);
    exit;
  end;
  if Pos(UpperCase(Copy(Trim(s), 4, 3)), 'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC') > 0 then
  begin
    gvar_02536624 := RightStr('00' + Trim(Copy(s, 1, 2)), 2);
    if gvar_02536624 = '00' then
      gvar_02536624 := '';
    sub_00577544(UpperCase(Copy(Trim(s), 4, 3)), gvar_02536628);
    gvar_0253662C := Copy(s, 8, 4);
    exit;
  end;
  if (Length(s) = 7) and (Copy(s, 3, 1) = '.') then
  begin
    gvar_02536624 := '';
    gvar_02536628 := Copy(s, 1, 2);
    gvar_0253662C := Copy(s, 4, 4);
    exit;
  end;
  if (Length(s) = 11) and (Copy(s, 3, 2) = '  ') and (Copy(s, 7, 1) = ' ') then
  begin
    gvar_02536624 := Copy(s, 1, 2);
    gvar_02536628 := Copy(s, 5, 2);
    gvar_0253662C := Copy(s, 8, 4);
    exit;
  end;
  if Length(s) = 4 then
  begin
    for ok := 1 to 4 do
      if Pos(Copy(s, ok, 1), '0123456789') = 0 then
      begin
        gvar_0253662C := '';
        exit;
      end;
    gvar_0253662C := s;
    exit;
  end;
  if Pos(UpperCase(Copy(Trim(s), 1, 3)), 'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC') > 0 then
  begin
    gvar_02536624 := '';
    sub_00577544(UpperCase(Copy(Trim(s), 1, 3)), gvar_02536628);
    gvar_0253662C := Copy(Trim(ADatum), 5, 4);
    exit;
  end;
  if Pos(UpperCase(Copy(s, 1, 2)), kstr) > 0 then
  begin
    if Pos(UpperCase(Copy(s, 1, 2)), kstr) > 19 then
    begin
      gvar_0253662C := Copy(s, 4, Length(s) - 3);
      exit;
    end;
    case Pos(UpperCase(Copy(s, 1, 2)), kstr) of
      1:  begin gvar_02536624 := 'ca'; gvar_02536628 := '';   end;
      4:  begin gvar_02536624 := 'um'; gvar_02536628 := '';   end;
      7:  begin gvar_02536624 := 'vo'; gvar_02536628 := 'r '; end;
      10: begin gvar_02536624 := 'na'; gvar_02536628 := 'ch'; end;
      13: begin gvar_02536624 := 'er'; gvar_02536628 := 'r '; end;
      16: begin gvar_02536624 := 'ab'; gvar_02536628 := 't '; end;
      19: begin gvar_02536624 := 'ci'; gvar_02536628 := 'rc'; end;
    else
      gvar_0253662C := Copy(s, 4, Length(s) - 3);
    end;
    exit;
  end;
  { The last range: free text in the "day month year" format. }
  gvar_02536624 := Copy(s, 1, Pos(' ', s) - 1);
  if Length(Trim(gvar_02536624)) = 1 then
    gvar_02536624 := '0' + gvar_02536624;
  s := Copy(s, Pos(' ', s) + 1, Length(s) - Pos(' ', s));
  gvar_02536628 := Copy(s, 1, Pos(' ', s) - 1);
  if Pos(Trim(UpperCase(gvar_02536628)), 'JAN FEB MAR M' + #196 + 'R APR MAY MAI JUN JUL AUG SEP OCT OKT NOV DEC DEZ') > 0 then
    sub_00577544(UpperCase(gvar_02536628), gvar_02536628);
  if Length(Trim(gvar_02536628)) = 1 then
    gvar_02536628 := '0' + gvar_02536628;
  gvar_0253662C := Trim(Copy(s, Pos(' ', s) + 1, 10));
end;


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm3.Bapm(AIn: AnsiString; AFlag: Integer; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM section "1 BAPM" up to the next "1" line and writes
    the sub-lines Date/Place/Longitude/Latitude/_GODP/Note/Cont/Conc/
    Source/Comm to the person record (Taufe fields) and to the comment
    strings gvar_0253684C and gvar_02536430. The next "1" line is left
    in s for further disposal (return value via AEs). }
  gvar_02536430 := '';
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('DATE', s) > 0 then
    begin
      if Pos(',', s) > 0 then
      begin
        sub_00577934(Copy(s, 8, Pos(',', s) - 8));
        if Trim(gvar_0253684C) = '' then
          gvar_0253684C := 'Taufe: ' + Copy(s, Pos(',', s) + 1,
            Length(Trim(s)) - Pos(',', s))
        else
          gvar_0253684C := gvar_0253684C + #13#10 + 'Taufe: ' +
            Copy(s, Pos(',', s) + 1, Length(Trim(s)) - Pos(',', s));
      end
      else
        sub_00577934(Copy(TrimRight(s), 8, Length(TrimRight(s))));
      s := '~ ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
      DataModule2.Table1Tauftag.AsString := gvar_02536624;
      DataModule2.Table1Taufmonat.AsString := gvar_02536628;
      DataModule2.Table1Taufjahr.AsString := gvar_0253662C;
    end;
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(Trim(s), 8, Length(Trim(s))), s);
      DataModule2.Table1Taufort.AsString := s;
    end;
    if Pos('2 LONG', s) > 0 then
    begin
      { Adds a longitude entry to the place file (Table13), analogous to
        Birt. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Taufort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Taufort.AsString;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if Pos('2 LATI', s) > 0 then
    begin
      { Adds a latitude entry to the place file (Table13), analogous to
        Birt. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Taufort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Taufort.AsString;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if AFlag = 1 then
      if Pos('_GODP', s) > 0 then
      begin
        { Appends a godparent entry with ", " to Table1Taufpat, or sets
          it completely new. }
        if Trim(DataModule2.Table1Taufpat.AsString) <> '' then
          DataModule2.Table1Taufpat.AsString := DataModule2.Table1Taufpat.AsString +
            ', ' + Trim(Copy(s, 9, Length(Trim(s))))
        else
          DataModule2.Table1Taufpat.AsString := Trim(Copy(s, 9, Length(Trim(s))));
      end;
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Taufe: ' + Copy(Trim(s), 8, Length(Trim(s)))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Taufe: ' +
          Copy(Trim(s), 8, Length(Trim(s)));
    end;
    if Pos('CONT', s) > 0 then
      gvar_0253684C := gvar_0253684C + #13#10 + Copy(Trim(s), 8, Length(Trim(s)));
    if Pos('CONC', s) > 0 then
      gvar_0253684C := gvar_0253684C + ' ' + Copy(Trim(s), 8, Length(Trim(s)));
    gvar_02536850 := '';
    if Pos('2 SOUR @', s) > 0 then
    begin
      Form1.Repso2.IndexName := 'ih';
      if Form1.Repso2.FindKey([Trim(Copy(s, 8, Length(s)))]) then
        DataModule2.Table1Quellet.AsString := Form1.Repso2inh2.AsString;
    end;
    if (Pos('2 SOUR', s) > 0) and (Pos('@', s) = 0) then
      DataModule2.Table1Quellet.AsString := Trim(Copy(s, 8, Length(s)));
    if Pos('2 COMM', s) > 0 then
      gvar_02536430 := gvar_02536430 + #13#10 + Trim(Copy(s, 8, Length(s)));
    gvar_02536430 := gvar_02536430 + ' ' + s;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  AEs := gvar_02536430;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Birt(AIn: AnsiString; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM section "1 BIRT" up to the next "1" line and writes
    the sub-lines Date/Place/Longitude/Latitude/Note/Cont/Conc/Source/Comm
    to the person record (Table1) and the comment strings in
    gvar_0253684C and gvar_02536430. The next "1" line is left in s for
    further disposal (return value via AEs). }
  gvar_02536430 := '';
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('DATE', s) > 0 then
    begin
      if Pos(',', s) > 0 then
      begin
        sub_00577934(Copy(s, 8, Pos(',', s) - 8));
        if Trim(gvar_0253684C) = '' then
          gvar_0253684C := 'Geburt: ' + Copy(s, Pos(',', s) + 1,
            Length(Trim(s)) - Pos(',', s))
        else
          gvar_0253684C := gvar_0253684C + #13#10 + 'Geburt: ' +
            Copy(s, Pos(',', s) + 1, Length(Trim(s)) - Pos(',', s));
      end
      else
        sub_00577934(Copy(TrimRight(s), 8, Length(TrimRight(s))));
      s := '* ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
      DataModule2.Table1Gebtag.AsString := gvar_02536624;
      DataModule2.Table1Gebmonat.AsString := gvar_02536628;
      DataModule2.Table1Gebjahr.AsString := gvar_0253662C;
    end;
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(Trim(s), 8, Length(Trim(s))), s);
      DataModule2.Table1Gebort.AsString := s;
    end;
    if Pos('2 LONG', s) > 0 then
    begin
      { Adds a longitude entry to the place file (Table13): if the place
        exists, only the coordinate is updated, otherwise a new record is
        created. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Gebort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Gebort.AsString;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if Pos('2 LATI', s) > 0 then
    begin
      { Adds a latitude entry to the place file (Table13), analogous to
        2 LONG. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Gebort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Gebort.AsString;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Geburt: ' + Copy(Trim(s), 8, Length(Trim(s)))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Geburt: ' +
          Copy(Trim(s), 8, Length(Trim(s)));
    end;
    if Pos('CONT', s) > 0 then
      gvar_0253684C := gvar_0253684C + #13#10 + Copy(Trim(s), 8, Length(Trim(s)));
    if Pos('CONC', s) > 0 then
      gvar_0253684C := gvar_0253684C + ' ' + Copy(Trim(s), 8, Length(Trim(s)));
    gvar_02536850 := '';
    if Pos('2 SOUR @', s) > 0 then
    begin
      Form1.Repso2.IndexName := 'ih';
      if Form1.Repso2.FindKey([Trim(Copy(s, 8, Length(s)))]) then
        DataModule2.Table1Quelleg.AsString := Form1.Repso2inh2.AsString;
    end;
    if (Pos('2 SOUR', s) > 0) and (Pos('@', s) = 0) then
      DataModule2.Table1Quelleg.AsString := Trim(Copy(s, 8, Length(s)));
    if Pos('2 COMM', s) > 0 then
      gvar_02536430 := gvar_02536430 + #13#10 + Trim(Copy(s, 8, Length(s)));
    gvar_02536430 := gvar_02536430 + ' ' + s;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  AEs := gvar_02536430;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Sex(AIn: AnsiString; var AEs: AnsiString);
var
  s: AnsiString;
begin
  { Evaluates a GEDCOM line "1 SEX M/F/W/U": the sex is written as
    "m"/"w"/"x" to Table1Geschlecht. Unknown or not specified becomes
    "x". }
  s := Trim(Copy(AIn, 7, Length(AIn)));
  if UpperCase(s) = 'M' then
    AEs := 'm'
  else if (UpperCase(s) = 'F') or (UpperCase(s) = 'W') then
    AEs := 'w'
  else if UpperCase(s) = 'U' then
    AEs := 'x';
  if Trim(s) = '' then
    AEs := 'x';
  DataModule2.Table1Geschlecht.AsString := AEs;
end;

procedure TForm3.Occu(AIn: AnsiString; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM section "1 OCCU" up to the next "1" line and collects
    the sub-lines Date/Place/Note/Cont in the comment strings
    gvar_02536430 ("Beruf: " prefix in gvar_0253684C). The next "1" line is
    left in s for further disposal (return value via AEs). }
  gvar_02536430 := Trim(Copy(AIn, 8, Length(AIn)));
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('DATE', s) > 0 then
      gvar_02536430 := gvar_02536430 + ' ' + Copy(s, 8, Length(Trim(s)));
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(Trim(s), 8, Length(Trim(s))), s);
      gvar_02536430 := gvar_02536430 + ' ' + s;
    end;
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Beruf: ' + Copy(Trim(s), 8, Length(Trim(s)))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Beruf: ' +
          Copy(Trim(s), 8, Length(Trim(s)));
    end;
    if Pos('CONT', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + ' ' + Copy(s, 8, Length(s));
    end;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  AEs := gvar_02536430;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Buri(AIn: AnsiString; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM section "1 BURI" up to the next "1" line and writes
    the sub-lines Date/Place/Longitude/Latitude/Note/Cont/Conc/Source/
    Comm to the person record (Bestattung fields) and to the comment
    strings gvar_0253684C (label "Bestatt.: ") and gvar_02536430. The
    next "1" line is left in s for further disposal (return value via
    AEs). }
  gvar_02536430 := '';
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('DATE', s) > 0 then
    begin
      if Pos(',', s) > 0 then
      begin
        sub_00577934(Copy(s, 8, Pos(',', s) - 8));
        if Trim(gvar_0253684C) = '' then
          gvar_0253684C := 'Bestatt.: ' + Copy(s, Pos(',', s) + 1,
            Length(Trim(s)) - Pos(',', s))
        else
          gvar_0253684C := gvar_0253684C + #13#10 + 'Bestatt.: ' +
            Copy(s, Pos(',', s) + 1, Length(Trim(s)) - Pos(',', s));
      end
      else
        sub_00577934(Copy(TrimRight(s), 8, Length(TrimRight(s))));
      s := '# ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
      DataModule2.Table1Begtag.AsString := gvar_02536624;
      DataModule2.Table1Begmonat.AsString := gvar_02536628;
      DataModule2.Table1Begjahr.AsString := gvar_0253662C;
    end;
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(Trim(s), 8, Length(Trim(s))), s);
      DataModule2.Table1Begort.AsString := s;
    end;
    if Pos('2 LONG', s) > 0 then
    begin
      { Adds a longitude entry to the place file (Table13), analogous to
        Birt. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Begort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Begort.AsString;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if Pos('2 LATI', s) > 0 then
    begin
      { Adds a latitude entry to the place file (Table13), analogous to
        Birt. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Begort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Begort.AsString;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Bestatt.: ' + Copy(Trim(s), 8, Length(Trim(s)))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Bestatt.: ' +
          Copy(Trim(s), 8, Length(Trim(s)));
    end;
    if Pos('CONT', s) > 0 then
      gvar_0253684C := gvar_0253684C + #13#10 + Copy(Trim(s), 8, Length(Trim(s)));
    if Pos('CONC', s) > 0 then
      gvar_0253684C := gvar_0253684C + ' ' + Copy(Trim(s), 8, Length(Trim(s)));
    gvar_02536850 := '';
    if Pos('2 SOUR @', s) > 0 then
    begin
      Form1.Repso2.IndexName := 'ih';
      if Form1.Repso2.FindKey([Trim(Copy(s, 8, Length(s)))]) then
        DataModule2.Table1Quelleb.AsString := Form1.Repso2inh2.AsString;
    end;
    if (Pos('2 SOUR', s) > 0) and (Pos('@', s) = 0) then
      DataModule2.Table1Quelleb.AsString := Trim(Copy(s, 8, Length(s)));
    if Pos('2 COMM', s) > 0 then
      gvar_02536430 := gvar_02536430 + #13#10 + Trim(Copy(s, 8, Length(s)));
    gvar_02536430 := gvar_02536430 + ' ' + s;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  AEs := gvar_02536430;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Deat(AIn: AnsiString; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM section "1 DEAT" up to the next "1" line and writes
    the sub-lines Date/Place/Longitude/Latitude/Note/Cont/Conc/Source/
    Comm/Caus to the person record (Sterbe fields) and to the comment
    strings gvar_0253684C and gvar_02536430. The next "1" line is left
    in s for further disposal (return value via AEs). }
  gvar_02536430 := '';
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('DATE', s) > 0 then
    begin
      if Pos(',', s) > 0 then
      begin
        sub_00577934(Copy(s, 8, Pos(',', s) - 8));
        if Trim(gvar_0253684C) = '' then
          gvar_0253684C := 'Tod: ' + Copy(s, Pos(',', s) + 1,
            Length(Trim(s)) - Pos(',', s))
        else
          gvar_0253684C := gvar_0253684C + #13#10 + 'Tod: ' +
            Copy(s, Pos(',', s) + 1, Length(Trim(s)) - Pos(',', s));
      end
      else
        sub_00577934(Copy(TrimRight(s), 8, Length(TrimRight(s))));
      s := '+ ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
      DataModule2.Table1Sttag.AsString := gvar_02536624;
      DataModule2.Table1Stmonat.AsString := gvar_02536628;
      DataModule2.Table1Stjahr.AsString := gvar_0253662C;
    end;
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(Trim(s), 8, Length(Trim(s))), s);
      DataModule2.Table1Stort.AsString := s;
    end;
    if Pos('2 LONG', s) > 0 then
    begin
      { Adds a longitude entry to the place file (Table13), analogous to
        Birt. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Stort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Stort.AsString;
        DataModule2.Table13Lg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if Pos('2 LATI', s) > 0 then
    begin
      { Adds a latitude entry to the place file (Table13), analogous to
        Birt. }
      if DataModule2.Table13.FindKey([DataModule2.Table1Stort.AsString]) then
      begin
        DataModule2.Table13.Edit;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end
      else
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := DataModule2.Table1Stort.AsString;
        DataModule2.Table13Bg.AsString := Copy(Trim(s), 8, Length(s));
      end;
      DataModule2.Table13.Post;
    end;
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Tod: ' + Copy(Trim(s), 8, Length(Trim(s)))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Tod: ' +
          Copy(Trim(s), 8, Length(Trim(s)));
    end;
    if Pos('CONT', s) > 0 then
      gvar_0253684C := gvar_0253684C + #13#10 + Copy(Trim(s), 8, Length(Trim(s)));
    if Pos('CONC', s) > 0 then
      gvar_0253684C := gvar_0253684C + ' ' + Copy(Trim(s), 8, Length(Trim(s)));
    gvar_02536850 := '';
    if Pos('2 SOUR @', s) > 0 then
    begin
      Form1.Repso2.IndexName := 'ih';
      if Form1.Repso2.FindKey([Trim(Copy(s, 8, Length(s)))]) then
        DataModule2.Table1Quelles.AsString := Form1.Repso2inh2.AsString;
    end;
    if (Pos('2 SOUR', s) > 0) and (Pos('@', s) = 0) then
      DataModule2.Table1Quelles.AsString := Trim(Copy(s, 8, Length(s)));
    if Pos('2 COMM', s) > 0 then
      gvar_02536430 := gvar_02536430 + #13#10 + Trim(Copy(s, 8, Length(s)));
    if Pos('CAUS', s) > 0 then
      DataModule2.Table1Todesurs.AsString := Copy(Trim(s), 8, Length(Trim(s)));
    gvar_02536430 := gvar_02536430 + ' ' + s;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  AEs := gvar_02536430;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Nam(AIn: AnsiString; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Breaks down a GEDCOM name line "1 NAME Vorname /Zuname /Zusatz.": the
    given name is written to Table1Vornamen, the surname to Table1Name.
    A name suffix is appended to the comment field with the label
    "Namens-Zusatz:". AEs receives the name as "given name surname",
    the remainder after the second slash is stored in
    gvar_02536430. }
  if Pos('/', AIn) = 0 then
  begin
    AEs := AIn;
    gvar_02536430 := AIn;
    exit;
  end;
  s := Trim(Copy(AIn, 8, Length(AIn)));
  AEs := Copy(s, 1, Pos('/', s) - 1);
  DataModule2.Table1Vornamen.AsString := AEs;
  s := Trim(Copy(s, Pos('/', s) + 1, Length(s)));
  t := Copy(s, 1, Pos('/', s) - 1);
  DataModule2.Table1Name.AsString := t;
  AEs := AEs + ' ' + t;
  t := Trim(Copy(s, Pos('/', s) + 1, Length(s)));
  if t <> '' then
    sub_005772E4('Namens-Zusatz: ' + t);
  gvar_02536430 := s;
end;

procedure TForm3.ofb3;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.ofb2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.indi;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Ortdreh(AOrt: AnsiString; var AErgebnis: AnsiString);
var
  S, T: AnsiString;
begin
  { The place name is stored as "<number> <place name>", the number is
    moved to the end: "123 Ortsteil" -> "Ortsteil 123". Only applied
    when the first character is a digit. }
  AErgebnis := AOrt;
  if Pos(Copy(AOrt, 1, 1), '1234567890') > 0 then
  begin
    S := Copy(AOrt, Pos(' ', AOrt) + 1, Length(Trim(AOrt)));
    T := Copy(AOrt, 1, Pos(' ', AOrt) - 1);
    AErgebnis := S + ' ' + T;
  end;
end;

procedure TForm3.oabk;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.illki;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Even(AIn: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM section "1 EVEN" up to the next "1" line and builds
    a comment text in gvar_0253684C ("Ereig.: " header with the event
    name, then Date, Place "(Page)", Note/Cont/Conc on following lines).
    The next "1" line is left in s; gvar_02536430 receives it. }
  gvar_02536430 := '';
  gvar_0253684C := gvar_0253684C + #13#10 + 'Ereig.: ' +
    Copy(Trim(AIn), 8, Length(Trim(AIn)));
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('TYPE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Ereig.: ' + Copy(Trim(s), 8, Length(Trim(s)))
      else if Pos('Ereig', gvar_0253684C) = 0 then
        gvar_0253684C := gvar_0253684C + #13#10 + 'Ereig.: ' +
          Copy(Trim(s), 8, Length(Trim(s)))
      else
        gvar_0253684C := gvar_0253684C + ' ' + Copy(Trim(s), 8, Length(Trim(s)));
    end;
    if Pos('DATE', s) > 0 then
    begin
      sub_00577934(Copy(TrimRight(s), 8, Length(TrimRight(s))));
      gvar_0253684C := gvar_0253684C + ' ' + gvar_02536624 + '.' +
        gvar_02536628 + '.' + gvar_0253662C;
    end;
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(Trim(s), 8, Length(Trim(s))), s);
      gvar_0253684C := gvar_0253684C + ' ' + s;
    end;
    if Pos('PAGE', s) > 0 then
      gvar_0253684C := gvar_0253684C + ' (' +
        Copy(Trim(s), 8, Length(Trim(s))) + ')';
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
    if Pos('CONT', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
    if Pos('CONC', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + ' ' + Copy(s, 8, Length(s));
    end;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.zsa(ALine: AnsiString; var AErgebnis: AnsiString);
begin
  { Converts the line to the Windows character set, depending on the
    character set selected for the import/export (gvar_02536848):
    'utf' -> UTF-8 to ANSI, 'ibm'/'asci' -> OEM in place, 'ansel' ->
    ANSEL to Windows, otherwise unchanged. }
  if gvar_02536848 = 'utf' then
    AErgebnis := Utf8ToAnsi(ALine)
  else if (gvar_02536848 = 'ibm') or (gvar_02536848 = 'asci') then
  begin
    if ALine <> '' then
      OemToCharA(PAnsiChar(ALine), PAnsiChar(ALine));
  end
  else if gvar_02536848 = 'ansel' then
    ansl(ALine, AErgebnis)
  else
    AErgebnis := ALine;
end;

procedure TForm3.ansl(AIn: AnsiString; var AOut: AnsiString);
const
  { ANSEL to Windows-1252. The table has 94 entries for $A1..$FE,
    $00 means "no replacement". The original keeps the byte. }
  AnsTab: array[0..93] of Byte = (
    $00, $D8, $D0, $DE, $C6, $00, $00, $B7, $00, $AE,
    $B1, $00, $00, $00, $F8, $00, $FE, $E6, $00, $00,
    $A3, $F0, $A9, $BF, $A1, $DF, $00, $00, $00, $00,
    $00, $00, $00, $00, $A9, $00, $BF, $A1, $00, $00,
    $00, $00, $00, $00, $00, $00, $DF, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $60, $B4, $5E, $7E, $AF, $00,
    $00, $A8, $5E, $E5, $00, $00, $00, $22, $00, $B8,
    $00, $00, $00, $00, $00, $5F, $00, $00, $00, $00,
    $00, $00, $00, $B4);
var
  i, n, c, m, prev, u: Integer;
  s: AnsiString;
begin
  { Converts the ANSEL character set of the statement to the Windows
    character set. A preceding combining diaeresis ($E8, mapped to
    $A8) raises a, o, u and A, O, U to the German umlaut; the marker
    itself is not appended. }
  s := '';
  n := Length(AIn);
  if n > 0 then
  begin
    prev := 0;
    for i := 1 to n do
    begin
      c := Byte(AIn[i]);
      m := 0;
      if c > $A0 then
        if c - $A1 <= $5D then
          m := AnsTab[c - $A1];
      if (m <> $A8) and (prev <> $A8) then
      begin
        if m <> 0 then
          s := s + Chr(m)
        else
          s := s + Chr(c);
      end;
      if prev = $A8 then
      begin
        case c of
          $41: u := $C4;
          $4F: u := $D6;
          $55: u := $DC;
          $61: u := $E4;
          $6F: u := $F6;
          $75: u := $FC;
        else
          u := 0;
        end;
        if u > 0 then
          s := s + Chr(u);
      end;
      prev := m;
    end;
  end;
  AOut := s;
end;

procedure TForm3.ans(AIn: AnsiString; var AOut: AnsiString);
var
  s, t: AnsiString;
begin
  { Combined OEM/ANSEL conversion of the original: first the OEM
    conversion (in place), then the ANSEL conversion. }
  s := AIn;
  if gvar_02536648 <> 0 then
    if s <> '' then
      OemToCharA(PAnsiChar(s), PAnsiChar(s));
  if gvar_0253664C <> 0 then
  begin
    ansl(s, t);
    s := t;
  end;
  AOut := s;
end;

procedure TForm3.sour;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedein_5;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.famn;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Prop;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Educ(AIn: AnsiString);
var
  s: AnsiString;
begin
  { Reads a GEDCOM section "1 EDUC" (Schule) up to the next "1" line and
    builds a comment in gvar_0253684C ("Schule: " header with the event
    name, then the date, the place (as gvar_02536430) and the
    Note/Cont/Conc text). }
  gvar_0253684C := gvar_0253684C + #13#10 + 'Schule: ' +
    Copy(Trim(AIn), 8, Length(Trim(AIn)));
  ReadLn(gvar_02536670, s);
  zsa(s, s);
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('TYPE', s) > 0 then
    begin
      if Pos('Schule', gvar_0253684C) = 0 then
      begin
        if Trim(gvar_0253684C) = '' then
          gvar_0253684C := 'Schule: ' + Copy(Trim(s), 8, Length(Trim(s)))
        else
          gvar_0253684C := gvar_0253684C + #13#10 + 'Schule: ' +
            Copy(Trim(s), 8, Length(Trim(s)));
      end
      else
        gvar_0253684C := gvar_0253684C + ' ' + Copy(Trim(s), 8, Length(Trim(s)));
    end;
    if Pos('DATE', s) > 0 then
      gvar_0253684C := gvar_0253684C + ' ' +
        Copy(s, 8, Length(TrimRight(s)));
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(s, 8, Length(TrimRight(s))), gvar_02536430);
      gvar_0253684C := gvar_0253684C + ' ' + gvar_02536430;
    end;
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
    if Pos('CONT', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
    if Pos('CONC', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + ' ' + Copy(s, 8, Length(s));
    end;
    ReadLn(gvar_02536670, s);
    zsa(s, s);
  end;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Grad(AIn: AnsiString);
var
  s: AnsiString;
begin
  { Reads a GEDCOM section "1 GRAD" (Ausbildung) up to the next "1"
    line and builds a comment in gvar_0253684C ("Ausbild.: " header with
    the event name, then the date, the place (as gvar_02536430) and the
    Note/Cont/Conc text). }
  if Trim(gvar_0253684C) = '' then
    gvar_0253684C := 'Ausbild.: ' + Copy(Trim(AIn), 8, Length(Trim(AIn)))
  else
    gvar_0253684C := gvar_0253684C + #13#10 + 'Ausbild.: ' +
      Copy(Trim(AIn), 8, Length(Trim(AIn)));
  ReadLn(gvar_02536670, s);
  zsa(s, s);
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('TYPE', s) > 0 then
    begin
      if Pos('Ausbild', gvar_0253684C) = 0 then
      begin
        if Trim(gvar_0253684C) = '' then
          gvar_0253684C := 'Ausbild.: ' + Copy(Trim(s), 8, Length(Trim(s)))
        else
          gvar_0253684C := gvar_0253684C + #13#10 + 'Ausbild.: ' +
            Copy(Trim(s), 8, Length(Trim(s)));
      end
      else
        gvar_0253684C := gvar_0253684C + ' ' + Copy(s, 8, Length(Trim(s)));
    end;
    if Pos('DATE', s) > 0 then
      gvar_0253684C := gvar_0253684C + ' ' +
        Copy(s, 8, Length(TrimRight(s)));
    if Pos('PLAC', s) > 0 then
    begin
      Ortdreh(Copy(s, 8, Length(TrimRight(s))), gvar_02536430);
      gvar_0253684C := gvar_0253684C + ' ' + gvar_02536430;
    end;
    if Pos('NOTE', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
    if Pos('CONT', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
    if Pos('CONC', s) > 0 then
    begin
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + ' ' + Copy(s, 8, Length(s));
    end;
    ReadLn(gvar_02536670, s);
    zsa(s, s);
  end;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Note;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Chan;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Resi;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key =   $1B then
    Close;
end;

procedure TForm3.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(nil, True, True);
    Key := #0;
  end;
end;

procedure TForm3.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(nil, True, True);
    Key := #0;
  end;
end;

function TForm3.ucase(const AAnsiString: AnsiString): AnsiString;
var
  i: Integer;
  c: string;
begin
  { The text is written in capitals. The umlauts of the German alphabet
    are converted as well - UpperCase of Delphi 9 does not do that. Same
    transformation as TForm1.ucase, applied to a single value. }
  Result := '';
  if Length(AAnsiString) > 0 then
    for i := 1 to Length(AAnsiString) do
    begin
      c := Copy(AAnsiString, i, 1);
      if c = Chr(228) then
        Result := Result + Chr(196)
      else if c = Chr(246) then
        Result := Result + Chr(214)
      else if c = Chr(252) then
        Result := Result + Chr(220)
      else
        Result := Result + UpperCase(c);
    end;
end;

procedure TForm3.showpreview;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Edit2Exit(Sender: TObject);
begin
  Button1Click(Sender);
end;

procedure TForm3.BitBtn2Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Edit1Exit(Sender: TObject);
var
  n: Integer;
begin
  { A person number has been entered: register it, close this
    dialog and reposition the people table (Table9) on that number. }
  try
    n := StrToInt(Edit1.Text);
    if n > 0 then
    begin
      gvar_011AE2C4 := n;
      Close;
      DataModule2.Table9.FindKey([n]);
    end;
  except
  end;
end;

procedure TForm3.Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.refelt;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.adrschreib;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedausxv;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedausv;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.lieszeil;
var
  s: AnsiString;
begin
  { Reads in the next line of the GEDCOM file in gvar_02536630. The file
    end must have been reached ("0 TRLR") and object references (OBJE) are
    skipped. Otherwise the record counter gvar_0061F048 is advanced and
    the flag gvar_02536640 is set as "line read valid". }
  if Copy(ucase(Trim(gvar_02536630)), 1, 6) = '0 TRLR' then
  begin
    gvar_0253663C := 1;
    exit;
  end;
  ReadLn(gvar_02536458, s);
  gvar_02536630 := Trim(s);
  if Pos('OBJE', gvar_02536630) > 0 then
  begin
    ReadLn(gvar_02536458, s);
    gvar_02536630 := Trim(s);
  end;
  if Copy(ucase(Trim(gvar_02536630)), 1, 6) = '0 TRLR' then
    gvar_0253663C := 1
  else
  begin
    Inc(gvar_0061F048);
    gvar_02536640 := 1;
  end;
end;

procedure TForm3.osbein;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.ahndosein;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedausx;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedein;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.OList;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.NList;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedaus;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedein_neu;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedein2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;


end.
