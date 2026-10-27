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
  Windows, SysUtils, StrUtils, Classes, StdCtrls, Buttons, DBTables, DBCommon, Dialogs, Forms, Controls, Grids, DB, AHNGlobals, Unit1, Unit2, Unit15, Unit16;

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
    procedure oabk(AIn: AnsiString; var AErgebnis: AnsiString); //00584EBC
    procedure illki; //00584350
    procedure Even(AIn: AnsiString); //0057B94C
    procedure zsa(ALine: AnsiString; var AErgebnis: AnsiString); //00577834
    procedure ansl(AIn: AnsiString; var AOut: AnsiString); //005832F8
    function Ziff(AIn: AnsiString): Integer; //0057D410
    procedure sour(AIn: AnsiString); //005BF434
    procedure gedein_5; //005BFB94
    procedure famn; //0057D560
    procedure Prop(AIn: AnsiString; var AErgebnis: AnsiString); //0057C8B8
    procedure Educ(AIn: AnsiString); //0057C3E0
    procedure Grad(AIn: AnsiString); //0057BEC0
    procedure Note(AIn: AnsiString; var AEs: AnsiString); //0057CF58
    procedure Chan(AIn: AnsiString; var AEs: AnsiString); //0057CC58
    procedure Resi(AIn: AnsiString; var AEs: AnsiString); //0057CA24
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
    procedure refelt(AName: AnsiString; var AResult: AnsiString); //00583930
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

procedure sub_005AFB14(AIn: AnsiString; var AResult: AnsiString);
begin
  { Converts the text from the OEM (DOS) character set to ANSI, only when
    nonempty. The conversion happens in place via OemToCharA. }
  AResult := '';
  if Trim(AIn) <> '' then
  begin
    if OemToCharA(PChar(AIn), PChar(AIn)) then
      AResult := AIn;
  end;
end;

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

procedure sub_005772E4(ALine: AnsiString); forward;

procedure sub_005BD73C(AIn: AnsiString);
var
  v, t: AnsiString;
begin
  { Appends the godfather entry (Taufpat) of an imported "BAPT" record.
    Only processed when the current import tag is "BAPT" }
  if gvar_02536858 = 'BAPT' then
  begin
    v := DataModule2.Table1Taufpat.AsString;
    if Trim(v) <> '' then
    begin
      t := Trim(Copy(AIn, 8, Length(Trim(AIn))));
      DataModule2.Table1Taufpat.AsString := Trim(v) + ', ' + t;
    end
    else
      DataModule2.Table1Taufpat.AsString := Trim(Copy(AIn, 8, Length(Trim(AIn))));
  end;
end;

procedure sub_005BD88C(AIn: AnsiString; APerson: Integer);
var
  n: Integer;
  s: AnsiString;
begin
  { Writes the father/mother reference (APerson) to the temporary "fsc"
    import table (gvar_02536860): existing record "fnr" -> update of the
    field "v" (m) resp. "m" (w), otherwise a new record. }
  n := StrToInt(Copy(AIn, 10, Length(Trim(AIn)) - 10));
  gvar_02536860.IndexName := 'fnr';
  if gvar_02536860.FindKey([n]) then
  begin
    gvar_02536860.Edit;
    s := UpperCase(DataModule2.Table1Geschlecht.AsString);
    if s = 'M' then
      gvar_02536860.FieldByName('v').AsInteger := APerson
    else
    begin
      s := UpperCase(DataModule2.Table1Geschlecht.AsString);
      if s = 'W' then
        gvar_02536860.FieldByName('m').AsInteger := APerson;
    end;
    gvar_02536860.Post;
  end
  else
  begin
    gvar_02536860.Append;
    gvar_02536860.FieldByName('fnr').AsInteger := n;
    s := UpperCase(DataModule2.Table1Geschlecht.AsString);
    if s = 'M' then
      gvar_02536860.FieldByName('v').AsInteger := APerson
    else
    begin
      s := UpperCase(DataModule2.Table1Geschlecht.AsString);
      if s = 'W' then
        gvar_02536860.FieldByName('m').AsInteger := APerson;
    end;
    gvar_02536860.Post;
  end;
end;

procedure sub_005BDAFC(AIn: AnsiString; APerson: Integer);
var
  n: Integer;
  s, u: AnsiString;
begin
  { Appends the number of the child (APerson) as a 6 digit string to the
    field "k" (children) of the temporary "fsc" import table. }
  n := StrToInt(Copy(AIn, 10, Length(Trim(AIn)) - 10));
  if gvar_02536860.FindKey([n]) then
  begin
    gvar_02536860.Edit;
    s := gvar_02536860.FieldByName('k').AsString;
    sub_00576EB0(APerson, u);
    gvar_02536860.FieldByName('k').AsString := s + u;
    gvar_02536860.Post;
  end
  else
  begin
    gvar_02536860.Append;
    gvar_02536860.FieldByName('fnr').AsInteger := n;
    s := gvar_02536860.FieldByName('k').AsString;
    sub_00576EB0(APerson, u);
    gvar_02536860.FieldByName('k').AsString := s + u;
    gvar_02536860.Post;
  end;
end;

procedure sub_005BDCA0(AIn: AnsiString);
var
  s, u, v: AnsiString;
begin
  { Distributes the person attributes of an imported record to the fields
    of table 1: "lebt: j", "Schrw.:", "Hnm.:", "1 NOTE @" and the rest
    into the comment field. }
  if Trim(AIn) = '' then
    exit;
  if Pos('lebt: j', AIn) > 0 then
    DataModule2.Table1Lebt.AsString := 'j'
  else
  if Pos('Schrw.:', AIn) > 0 then
    DataModule2.Table1Namex.AsString := Trim(Copy(AIn, 16, Length(AIn)))
  else
  if Pos('Hnm.:', AIn) > 0 then
    DataModule2.Table1Hausname.AsString := Trim(Copy(AIn, 14, Length(AIn)))
  else
  if Pos('1 NOTE @', AIn) > 0 then
  begin
    { The note is looked up in Repso2 with the key from the record and
      written from "NOTE" on into the comment field. }
    Form1.Repso2.IndexName := 'ih';
    u := Trim(Copy(AIn, 9, 20));
    Form1.Repso2.FindNearest([u]);
    s := Form1.Repso2inh.AsString;
    v := Trim(Copy(AIn, 9, 20));
    if Pos(v, s) > 0 then
    begin
      s := Copy(s, Pos('NOTE', s) + 5, Length(s));
      sub_005772E4(Trim(s));
    end;
  end
  else
  begin
    s := Trim(DataModule2.Table1Kommentar.AsString);
    if s = '' then
      DataModule2.Table1Kommentar.AsString := Trim(Copy(AIn, 8, Length(AIn)))
    else
      DataModule2.Table1Kommentar.AsString :=
        s + #13#10 + Trim(Copy(AIn, 8, Length(AIn)));
  end;
end;

procedure sub_005BE054(AIn: AnsiString);
begin
  { Appends ALine to the comment field of table 1 }
  if Trim(AIn) = '' then
    exit;
  DataModule2.Table1Kommentar.AsString :=
    DataModule2.Table1Kommentar.AsString + Trim(Copy(AIn, 8, Length(AIn) - 7));
end;

procedure sub_005BE104(AIn: AnsiString);
var
  s: AnsiString;
begin
  { Same attribute distribution as sub_005BDCA0, but without the
    "1 NOTE @" evaluation. }
  if Trim(AIn) = '' then
    exit;
  if Pos('lebt: j', AIn) > 0 then
    DataModule2.Table1Lebt.AsString := 'j'
  else
  if Pos('Schrw.:', AIn) > 0 then
    DataModule2.Table1Namex.AsString := Trim(Copy(AIn, 16, Length(AIn)))
  else
  if Pos('Hnm.:', AIn) > 0 then
    DataModule2.Table1Hausname.AsString := Trim(Copy(AIn, 14, Length(AIn)))
  else
  begin
    s := Trim(DataModule2.Table1Kommentar.AsString);
    if s = '' then
      DataModule2.Table1Kommentar.AsString := Trim(Copy(AIn, 8, Length(AIn)))
    else
      DataModule2.Table1Kommentar.AsString :=
        s + #13#10 + Trim(Copy(AIn, 8, Length(AIn)));
  end;
end;

procedure sub_005BE340(AIn: AnsiString);
begin
  { Writes the age "DEAT" into the field "Alter", as long as the line
    neither contain a "m" nor a "d". }
  if gvar_02536858 = 'DEAT' then
    if (Pos('m', AIn) = 0) and (Pos('d', AIn) = 0) then
      DataModule2.Table1Alter.AsString := Copy(AIn, 7, Length(AIn));
end;

procedure sub_005BE418(AIn: AnsiString);
begin
  { Writes the cause of death "DEAT" into the field "Todesurs". }
  if gvar_02536858 = 'DEAT' then
    DataModule2.Table1Todesurs.AsString := Copy(AIn, 8, Length(AIn));
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

procedure sub_005BE4B8(AIn: AnsiString);
var
  s: AnsiString;
begin
  { Evaluates a "2 DATE" line of the current event (gvar_02536858:
    BIRT/BAPT/DEAT/BURI/EMIG). The part before the comma is parsed by
    sub_00577934, the result is stored to the matching date triplet
    *tag/*monat/*jahr of table 1 (with "* " prefix in all fields) and
    the part behind the comma is appended to the comment string
    gvar_0253684C (prefix "Geburt: ", "Taufe: ", "Tod: ",
    "Bestatt.: " or "Auswanderung am "). Lines without a comma only
    parse the first part; lines of other events only parse the date. }
  if gvar_02536858 = 'BIRT' then
  begin
    if Pos(',', AIn) > 0 then
    begin
      sub_00577934(Copy(AIn, 8, Pos(',', AIn) - 8));
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Geburt: ' + Copy(AIn, Pos(',', AIn) + 1,
          Length(Trim(AIn)) - Pos(',', AIn))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Geburt: ' +
          Copy(AIn, Pos(',', AIn) + 1, Length(Trim(AIn)) - Pos(',', AIn));
    end
    else
      sub_00577934(Copy(TrimRight(AIn), 8, Length(TrimRight(AIn))));
    s := '* ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
    DataModule2.Table1Gebtag.AsString := gvar_02536624;
    DataModule2.Table1Gebmonat.AsString := gvar_02536628;
    DataModule2.Table1Gebjahr.AsString := gvar_0253662C;
  end
  else if gvar_02536858 = 'BAPT' then
  begin
    if Pos(',', AIn) > 0 then
    begin
      sub_00577934(Copy(AIn, 8, Pos(',', AIn) - 8));
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Taufe: ' + Copy(AIn, Pos(',', AIn) + 1,
          Length(Trim(AIn)) - Pos(',', AIn))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Taufe: ' +
          Copy(AIn, Pos(',', AIn) + 1, Length(Trim(AIn)) - Pos(',', AIn));
    end
    else
      sub_00577934(Copy(TrimRight(AIn), 8, Length(TrimRight(AIn))));
    s := '* ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
    DataModule2.Table1Tauftag.AsString := gvar_02536624;
    DataModule2.Table1Taufmonat.AsString := gvar_02536628;
    DataModule2.Table1Taufjahr.AsString := gvar_0253662C;
  end
  else if gvar_02536858 = 'DEAT' then
  begin
    if Pos(',', AIn) > 0 then
    begin
      sub_00577934(Copy(AIn, 8, Pos(',', AIn) - 8));
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Tod: ' + Copy(AIn, Pos(',', AIn) + 1,
          Length(Trim(AIn)) - Pos(',', AIn))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Tod: ' +
          Copy(AIn, Pos(',', AIn) + 1, Length(Trim(AIn)) - Pos(',', AIn));
    end
    else
      sub_00577934(Copy(TrimRight(AIn), 8, Length(TrimRight(AIn))));
    s := '* ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
    DataModule2.Table1Sttag.AsString := gvar_02536624;
    DataModule2.Table1Stmonat.AsString := gvar_02536628;
    DataModule2.Table1Stjahr.AsString := gvar_0253662C;
  end
  else if gvar_02536858 = 'BURI' then
  begin
    if Pos(',', AIn) > 0 then
    begin
      sub_00577934(Copy(AIn, 8, Pos(',', AIn) - 8));
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Bestatt.: ' + Copy(AIn, Pos(',', AIn) + 1,
          Length(Trim(AIn)) - Pos(',', AIn))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Bestatt.: ' +
          Copy(AIn, Pos(',', AIn) + 1, Length(Trim(AIn)) - Pos(',', AIn));
    end
    else
      sub_00577934(Copy(TrimRight(AIn), 8, Length(TrimRight(AIn))));
    s := '* ' + gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
    DataModule2.Table1Begtag.AsString := gvar_02536624;
    DataModule2.Table1Begmonat.AsString := gvar_02536628;
    DataModule2.Table1Begjahr.AsString := gvar_0253662C;
  end
  else if gvar_02536858 = 'EMIG' then
  begin
    if Pos(',', AIn) > 0 then
    begin
      sub_00577934(Copy(AIn, 8, Pos(',', AIn) - 8));
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'Auswanderung am ' + Copy(AIn, Pos(',', AIn) + 1,
          Length(Trim(AIn)) - Pos(',', AIn))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + 'Auswanderung am ' +
          Copy(AIn, Pos(',', AIn) + 1, Length(Trim(AIn)) - Pos(',', AIn));
    end
    else
    begin
      sub_00577934(Copy(TrimRight(AIn), 8, Length(TrimRight(AIn))));
      s := 'Auswanderung am ' + gvar_02536624 + '.' + gvar_02536628 +
        '.' + gvar_0253662C;
      sub_005772E4(s);
    end;
  end
  else
    sub_00577934(Copy(TrimRight(AIn), 8, Length(TrimRight(AIn))));
end;

procedure sub_005BEF5C(AIn: AnsiString);
var
  ort, s, e1, e2, e3: AnsiString;
begin
  { Evaluates a "2 PLAC" line of the current event (gvar_02536858):
    BIRT/BAPT/DEAT/BURI/RESI/EMIG. The line content behind column 8 is
    mirrored (Ortdreh) and stored to the matching place field of table
    1. Since the local gvar_0253685C is empty and the line contains a
    comma, the mirror is split up to three commas: the parts are
    written as new Lkr./Bland/Land entry of the place file (Table13),
    the key being the mirrored place itself. For EMIG a comment line
    "Auswanderung nach <ort>" is appended instead. }
  if gvar_02536858 <> 'RESI' then
  begin
    ort := Copy(AIn, 8, Length(Trim(AIn)));
    Form3.Ortdreh(ort, ort);
  end
  else
    ort := '';
  e1 := '';
  e2 := '';
  e3 := '';
  if (Trim(gvar_0253685C) > '') or (Pos(',', ort) > 0) then
    if gvar_02536858 = 'RESI' then
      e1 := ''
    else
    begin
      e1 := Copy(ort, 1, Pos(',', ort) - 1);
      ort := Copy(ort, Pos(',', ort) + 1, Length(ort));
      e2 := Copy(ort, 1, Pos(',', ort) - 1);
      ort := Copy(ort, Pos(',', ort) + 1, Length(ort));
      e3 := ort;
    end;
  if Trim(ort) <> '' then
  begin
    if DataModule2.Table13.FindKey([ort]) then
    begin
      DataModule2.Table13.Edit;
      DataModule2.Table13Lkr.AsString := e1;
      DataModule2.Table13Bland.AsString := e2;
      DataModule2.Table13Land.AsString := e3;
      DataModule2.Table13.Post;
    end
    else
    begin
      DataModule2.Table13.Append;
      DataModule2.Table13Ort.AsString := ort;
      DataModule2.Table13Lkr.AsString := e1;
      DataModule2.Table13Bland.AsString := e2;
      DataModule2.Table13Land.AsString := e3;
      DataModule2.Table13.Post;
    end;
  end;
  if gvar_02536858 = 'BIRT' then
    DataModule2.Table1Gebort.AsString := ort
  else if gvar_02536858 = 'BAPT' then
    DataModule2.Table1Taufort.AsString := ort
  else if gvar_02536858 = 'DEAT' then
    DataModule2.Table1Stort.AsString := ort
  else if gvar_02536858 = 'BURI' then
    DataModule2.Table1Begort.AsString := ort
  else if gvar_02536858 = 'RESI' then
    DataModule2.Table1Lebensort.AsString := Copy(AIn, 8, Length(AIn))
  else if gvar_02536858 = 'EMIG' then
  begin
    s := 'Auswanderung nach ' + ort;
    sub_005772E4(s);
  end;
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
var
  s, h: AnsiString;
  num: Integer;
begin
  { Handles the GEDCOM line "0 @Innn@ ..." of an individual record: shows
    the number in Form1.Label79 and positions Table1 on the person. }
  s := gvar_02536630;
  if ucase(Copy(s, 1, 4)) = 'I' then
    h := Copy(s, Pos('@', s) + 2, Length(s) - Pos('@', s))
  else
    h := Copy(s, Pos('@', s) + 1, Length(s) - Pos('@', s));
  num := StrToInt(Copy(s, 1, Pos('@', s) - 1));
  DataModule2.Table25.FindKey([num]);
  Form1.Label79.Caption := Copy(s, 1, Pos('@', s) - 1);
  Form1.Label79.Refresh;
  num := DataModule2.Table25N.AsInteger;
  DataModule2.Table1.FindKey([num]);
  DataModule2.Table1.Edit;
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

procedure TForm3.oabk(AIn: AnsiString; var AErgebnis: AnsiString);
var
  s, u: AnsiString;
begin
  { Looks up the abbreviation of a place in Table13 (index "ort_") and
    appends it (or the place itself when no abbreviation exists) together
    with the record number, to gvar_02536630. }
  AErgebnis := '';
  if Trim(AIn) = '' then
    Exit;
  DataModule2.Table13.IndexName := 'ort_';
  if DataModule2.Table13.FindKey([AIn]) then
  begin
    if Trim(DataModule2.Table13Abk.AsString) = '' then
      gvar_02536630 := gvar_02536630 + ' ' + AIn
    else
    begin
      gvar_02536630 := gvar_02536630 + ' ' +
        Trim(DataModule2.Table13Abk.AsString);
      sub_00576EB0(DataModule2.Table13.RecNo, u);
      AErgebnis := u + '*';
    end;
  end;
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

procedure TForm3.sour(AIn: AnsiString);
begin
  { Resolves a "2 SOUR @..." reference of the current event (gvar_02536858:
    BIRT/BAPT/DEAT/BURI) to the source text (Repso2) and appends it to the
    matching person source field. The field already contains the reference
    is left unchanged; otherwise the text is added with "; " (or set new). }
  if gvar_02536858 = 'BIRT' then
  begin
    if Pos('2 SOUR @', AIn) = 0 then
      exit;
    gvar_02536850 := '';
    Form1.Repso2.IndexName := 'ih';
    if Form1.Repso2.FindKey([Trim(Copy(AIn, 8, Length(AIn)))]) then
      gvar_02536850 := Form1.Repso2inh2.AsString;
    if Pos(gvar_02536850, DataModule2.Table1Quelleg.AsString) <> 0 then
      exit;
    DataModule2.Table1.Edit;
    if Trim(DataModule2.Table1Quelleg.AsString) = '' then
      DataModule2.Table1Quelleg.AsString := gvar_02536850
    else
      DataModule2.Table1Quelleg.AsString := Trim(
        DataModule2.Table1Quelleg.AsString + '; ' + gvar_02536850);
  end
  else if gvar_02536858 = 'BAPT' then
  begin
    if Pos('2 SOUR @', AIn) = 0 then
      exit;
    gvar_02536850 := '';
    Form1.Repso2.IndexName := 'ih';
    if Form1.Repso2.FindKey([Trim(Copy(AIn, 8, Length(AIn)))]) then
      gvar_02536850 := Form1.Repso2inh2.AsString;
    if Pos(gvar_02536850, DataModule2.Table1Quellet.AsString) <> 0 then
      exit;
    DataModule2.Table1.Edit;
    if Trim(DataModule2.Table1Quellet.AsString) = '' then
      DataModule2.Table1Quellet.AsString := gvar_02536850
    else
      DataModule2.Table1Quellet.AsString := Trim(
        DataModule2.Table1Quellet.AsString + '; ' + gvar_02536850);
  end
  else if gvar_02536858 = 'DEAT' then
  begin
    if Pos('2 SOUR @', AIn) = 0 then
      exit;
    gvar_02536850 := '';
    Form1.Repso2.IndexName := 'ih';
    if Form1.Repso2.FindKey([Trim(Copy(AIn, 8, Length(AIn)))]) then
      gvar_02536850 := Form1.Repso2inh2.AsString;
    if Pos(gvar_02536850, DataModule2.Table1Quelles.AsString) <> 0 then
      exit;
    DataModule2.Table1.Edit;
    if Trim(DataModule2.Table1Quelles.AsString) = '' then
      DataModule2.Table1Quelles.AsString := gvar_02536850
    else
      DataModule2.Table1Quelles.AsString := Trim(
        DataModule2.Table1Quelles.AsString + '; ' + gvar_02536850);
  end
  else if gvar_02536858 = 'BURI' then
  begin
    if Pos('2 SOUR @', AIn) = 0 then
      exit;
    gvar_02536850 := '';
    Form1.Repso2.IndexName := 'ih';
    if Form1.Repso2.FindKey([Trim(Copy(AIn, 8, Length(AIn)))]) then
      gvar_02536850 := Form1.Repso2inh2.AsString;
    if Pos(gvar_02536850, DataModule2.Table1Quelleb.AsString) <> 0 then
      exit;
    DataModule2.Table1.Edit;
    if Trim(DataModule2.Table1Quelleb.AsString) = '' then
      DataModule2.Table1Quelleb.AsString := gvar_02536850
    else
      DataModule2.Table1Quelleb.AsString := Trim(
        DataModule2.Table1Quelleb.AsString + '; ' + gvar_02536850);
  end;
end;

procedure TForm3.gedein_5;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

function TForm3.Ziff(AIn: AnsiString): Integer;
begin
  { Extracts the numeric part of a GEDCOM id ("@I123"/"0 @F45"): the last
    (numeric) token after the last whitespace. }
  Result := StrToIntDef(RightStr(Trim(Copy(AIn, 10, Length(AIn))), -1), 0);
end;

procedure TForm3.famn;
var
  husn, wifn: Integer;
  mIdx, rel: Integer;
  Dtag1, Dmonat1, Djahr1, Dort1, Dwit: AnsiString;
  Dtag2, Dmonat2, Djahr2, Dort2, Dwit2: AnsiString;
  Dtag3, Dmonat3, Djahr3, Dort3: AnsiString;
  Hqu, Squ, Cqu: AnsiString;
  s, t: AnsiString;
begin
  { Reads a GEDCOM family record ("0 @F...") and its sub-lines, resolves the
    husband/wife person numbers, collects the marriage details (date, place,
    witness, source) and finally creates the two Table5 (marriage) records,
    once with the husband in Nummer and once with the wife. }
  husn := 0;
  wifn := 0;
  mIdx := 0;
  rel := 1;
  Hqu := '';
  Squ := '';
  Cqu := '';
  ReadLn(gvar_02536670, s);
  IOResult;
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '0' do
  begin
    if Pos('1 HUSB', s) > 0 then
    begin
      husn := Ziff(s);
      if DataModule2.Table25.FindKey([husn]) then
        husn := DataModule2.Table25N.AsInteger;
    end;
    if Pos('1 WIFE', s) > 0 then
    begin
      wifn := Ziff(s);
      if DataModule2.Table25.FindKey([wifn]) then
        wifn := DataModule2.Table25N.AsInteger;
    end;
    if Pos('1 CHIL', s) > 0 then
    begin
      { TODO: kind-parent linkage (Table15/Table31), Listingteil
        0057DB67..0057DD66 - Originaladresse siehe Deklaration. }
    end;
    if (Pos('1 MARR', ucase(s)) > 0) or (Pos('1 _VWMARR', ucase(s)) > 0) then
    begin
      rel := 0;
      ReadLn(gvar_02536670, s);
      IOResult;
      zsa(s, t);
      s := t;
      while Copy(s, 1, 1) > '1' do
      begin
        if Pos('DATE', s) > 0 then
        begin
          sub_00577934(Trim(Copy(TrimRight(s), 8, Length(TrimRight(s)))));
          case mIdx of
            0: begin Dtag1 := gvar_02536624; Dmonat1 := gvar_02536628; Djahr1 := gvar_0253662C; end;
            1: begin Dtag2 := gvar_02536624; Dmonat2 := gvar_02536628; Djahr2 := gvar_0253662C; end;
          else  begin Dtag3 := gvar_02536624; Dmonat3 := gvar_02536628; Djahr3 := gvar_0253662C; end;
          end;
        end;
        if Pos('PLAC', s) > 0 then
          case mIdx of
            0: Ortdreh(Trim(Copy(TrimRight(s), 8, Length(TrimRight(s)))), Dort1);
            1: Ortdreh(Trim(Copy(TrimRight(s), 8, Length(TrimRight(s)))), Dort2);
          else  Ortdreh(Trim(Copy(TrimRight(s), 8, Length(TrimRight(s)))), Dort3);
          end;
        if Pos('2 LONG', s) > 0 then
        begin
          if Trim(Dort1) <> '' then
          begin
            if DataModule2.Table13.FindKey([Dort1]) then
            begin
              DataModule2.Table13.Edit;
              DataModule2.Table13Lg.AsString := Copy(s, 8, Length(s));
            end
            else
            begin
              DataModule2.Table13.Append;
              DataModule2.Table13Ort.AsString := Dort1;
              DataModule2.Table13Lg.AsString := Copy(s, 8, Length(s));
            end;
            DataModule2.Table13.Post;
          end;
        end;
        if Pos('2 LATI', s) > 0 then
        begin
          if Trim(Dort1) <> '' then
          begin
            if DataModule2.Table13.FindKey([Dort1]) then
            begin
              DataModule2.Table13.Edit;
              DataModule2.Table13Bg.AsString := Copy(s, 8, Length(s));
            end
            else
            begin
              DataModule2.Table13.Append;
              DataModule2.Table13Ort.AsString := Dort1;
              DataModule2.Table13Bg.AsString := Copy(s, 8, Length(s));
            end;
            DataModule2.Table13.Post;
          end;
        end;
        if Pos('SOUR', s) > 0 then
        begin
          Form1.Repso2.IndexName := 'ih';
          if Form1.Repso2.FindKey([Trim(Copy(s, 8, Length(s)))]) then
          begin
            if mIdx = 0 then
              Hqu := Form1.Repso2inh2.AsString
            else if mIdx = 1 then
              Squ := Form1.Repso2inh2.AsString;
          end;
        end;
        if Pos('TYPE', s) > 0 then
        begin
          if Pos('RELI', s) > 0 then
            mIdx := 0
          else if Pos('CIVIL', s) > 0 then
            mIdx := 1;
        end;
        if Pos('_WITN', s) > 0 then
        begin
          if mIdx = 0 then
            Dwit := Copy(s, 9, Length(s))
          else if mIdx = 1 then
            Dwit2 := Copy(s, 9, Length(s));
        end;
        if Pos('STAT', ucase(s)) > 0 then
          rel := 0;
        if Pos('NOTE', ucase(s)) > 0 then
          rel := 1;
        ReadLn(gvar_02536670, s);
        IOResult;
        zsa(s, t);
        s := t;
      end;
    end;
    if (husn > 0) and (wifn > 0) then
    begin
      { husband as Nummer, wife as Epnum }
      DataModule2.Table5.Append;
      DataModule2.Table5Nummer.AsInteger := husn;
      DataModule2.Table5Epnum.AsInteger := wifn;
      if rel = 0 then
        DataModule2.Table5Verbind.AsString := 'Eheschliessung'
      else
        DataModule2.Table5Verbind.AsString := 'andere Beziehung';
      DataModule2.Table5Htag.AsString := Dtag1;
      DataModule2.Table5Hmonat.AsString := Dmonat1;
      DataModule2.Table5Hjahr.AsString := Djahr1;
      DataModule2.Table5Hort.AsString := Dort1;
      DataModule2.Table5Trauz.AsString := Dwit;
      DataModule2.Table5Hqu.AsString := Hqu;
      DataModule2.Table5Satag.AsString := Dtag2;
      DataModule2.Table5Samonat.AsString := Dmonat2;
      DataModule2.Table5Sajahr.AsString := Djahr2;
      DataModule2.Table5Saort.AsString := Dort2;
      DataModule2.Table5Satrauz.AsString := Dwit2;
      DataModule2.Table5Saqu.AsString := Squ;
      DataModule2.Table5Schtag.AsString := Dtag3;
      DataModule2.Table5Schmonat.AsString := Dmonat3;
      DataModule2.Table5Schjahr.AsString := Djahr3;
      DataModule2.Table5Schort.AsString := Dort3;
      DataModule2.Table5Schqu.AsString := Cqu;
      DataModule2.Table5.Post;

      { wife as Nummer, husband as Epnum }
      DataModule2.Table5.Append;
      DataModule2.Table5Nummer.AsInteger := wifn;
      DataModule2.Table5Epnum.AsInteger := husn;
      if rel = 0 then
        DataModule2.Table5Verbind.AsString := 'Eheschliessung'
      else
        DataModule2.Table5Verbind.AsString := 'andere Beziehung';
      DataModule2.Table5Htag.AsString := Dtag1;
      DataModule2.Table5Hmonat.AsString := Dmonat1;
      DataModule2.Table5Hjahr.AsString := Djahr1;
      DataModule2.Table5Hort.AsString := Dort1;
      DataModule2.Table5Trauz.AsString := Dwit;
      DataModule2.Table5Hqu.AsString := Hqu;
      DataModule2.Table5Satag.AsString := Dtag2;
      DataModule2.Table5Samonat.AsString := Dmonat2;
      DataModule2.Table5Sajahr.AsString := Djahr2;
      DataModule2.Table5Saort.AsString := Dort2;
      DataModule2.Table5Satrauz.AsString := Dwit2;
      DataModule2.Table5Saqu.AsString := Squ;
      DataModule2.Table5Schtag.AsString := Dtag3;
      DataModule2.Table5Schmonat.AsString := Dmonat3;
      DataModule2.Table5Schjahr.AsString := Djahr3;
      DataModule2.Table5Schort.AsString := Dort3;
      DataModule2.Table5Schqu.AsString := Cqu;
      DataModule2.Table5.Post;
    end;
    gvar_02536844 := $2A01;
    ReadLn(gvar_02536670, gvar_02536630);
    IOResult;
    zsa(gvar_02536630, gvar_02536630);
    s := gvar_02536630;
  end;
end;

procedure TForm3.Prop(AIn: AnsiString; var AErgebnis: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM "1 PROP" block (list of properties). The name of the
    property is taken from the header line, the following lines (which do
    NOT start with a "1") are appended, separated by blanks. The result is
    returned in AErgebnis. }
  gvar_02536430 := Trim(Copy(AIn, 8, Length(AIn)));
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    gvar_02536430 := gvar_02536430 + ' ' + s;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  AErgebnis := gvar_02536430;
  gvar_02536430 := s;
  gvar_02536844 := $2A01;
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

procedure TForm3.Note(AIn: AnsiString; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM "2 NOTE" block (and following CONT/CONC lines) up to the
    next numbered line. The name buffer gvar_02536430 is accumulated from
    the lines; the comment buffer gvar_0253684C collects Note text. A name
    containing "lebt:" marks Table1Lebt as 'j'; "Hnm.:" stores the house
    name in Table1Hausname. AEs receives the built name; the last line
    remains as in gvar_02536430. }
  gvar_02536430 := Trim(Copy(AIn, 8, Length(AIn)));
  if Pos('lebt:', gvar_02536430) > 0 then
    DataModule2.Table1Lebt.AsString := 'j'
  else if Pos('Hnm.:', gvar_02536430) > 0 then
    DataModule2.Table1Hausname.AsString := Copy(AIn, 14, Length(Trim(AIn)))
  else if Trim(gvar_0253684C) = '' then
    gvar_0253684C := Copy(AIn, 8, Length(AIn))
  else
    gvar_0253684C := gvar_0253684C + #13#10 + gvar_02536430;

  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  gvar_02536430 := Trim(Copy(s, 8, Length(s)));
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('CONT', s) > 0 then
    begin
      if Pos('lebt:', gvar_02536430) > 0 then
        DataModule2.Table1Lebt.AsString := 'j'
      else if Pos('Hnm.:', gvar_02536430) > 0 then
        DataModule2.Table1Hausname.AsString := Copy(s, 14, Length(Trim(s)))
      else if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
    if Pos('CONC', s) > 0 then
    begin
      if Pos('lebt:', gvar_02536430) > 0 then
        DataModule2.Table1Lebt.AsString := 'j'
      else if Pos('Hnm.:', gvar_02536430) > 0 then
        DataModule2.Table1Hausname.AsString := Copy(s, 12, Length(Trim(s)))
      else if Trim(gvar_0253684C) = '' then
        gvar_0253684C := Copy(s, 8, Length(s))
      else
        gvar_0253684C := gvar_0253684C + #13#10 + Copy(s, 8, Length(s));
    end;
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

procedure TForm3.Chan(AIn: AnsiString; var AEs: AnsiString);
var
  s, c1: AnsiString;
begin
  { Reads a GEDCOM section "1 CHAN" (change record) up to the next "1"
    line; the DATE part is appended to gvar_02536430 and then added to
    gvar_0253684C labeled "DS ge'#196'nd.: ". A TIME part is appended in
    the same way. The next "1" line remains as in gvar_02536430. }
  gvar_02536430 := '';
  ReadLn(gvar_02536670, s);
  zsa(s, s);
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('DATE', s) > 0 then
    begin
      sub_00577934(Trim(Copy(s, 8, Length(s))));
      c1 := gvar_02536624 + '.' + gvar_02536628 + '.' + gvar_0253662C;
      gvar_02536430 := c1;
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := 'DS ge' + #196 + 'nd.: ' + c1
      else if Pos('DS ge' + #196 + 'nd.', gvar_0253684C) = 0 then
        gvar_0253684C := gvar_0253684C + #13#10 + 'DS ge' + #196 + 'nd.: ' + c1
      else
        gvar_0253684C := gvar_0253684C + ' ' + c1;
    end;
    if Pos('TIME', s) > 0 then
    begin
      c1 := Trim(TrimRight(s));
      if Trim(gvar_0253684C) = '' then
        gvar_0253684C := c1
      else if Pos('DS ge' + #196 + 'nd.', gvar_0253684C) = 0 then
        gvar_0253684C := gvar_0253684C + #13#10 + 'DS ge' + #196 + 'nd.: ' + c1
      else
        gvar_0253684C := gvar_0253684C + ' ' + c1;
    end;
    ReadLn(gvar_02536670, s);
    zsa(s, s);
  end;
  AEs := gvar_02536430;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
end;

procedure TForm3.Resi(AIn: AnsiString; var AEs: AnsiString);
var
  s, t: AnsiString;
begin
  { Reads a GEDCOM section "1 RESI" up to the next "1" line and collects
    the PLAC sub-lines (via Ortdreh, separated by blanks) as the residence
    in gvar_02536430. AEs receives the collected text and is written to
    Table1Lebensort; the next "1" line remains as in gvar_02536430. }
  gvar_02536430 := Trim(Copy(AIn, 8, Length(AIn)));
  ReadLn(gvar_02536670, s);
  zsa(s, t);
  s := t;
  while Copy(s, 1, 1) > '1' do
  begin
    if Pos('PLAC', s) > 0 then
    begin
      if Trim(gvar_02536430) = '' then
        Ortdreh(Trim(Copy(s, 8, Length(s))), gvar_02536430)
      else
      begin
        Ortdreh(Trim(Copy(s, 8, Length(s))), t);
        gvar_02536430 := gvar_02536430 + ' ' + t;
      end;
    end;
    ReadLn(gvar_02536670, s);
    zsa(s, t);
    s := t;
  end;
  AEs := gvar_02536430;
  DataModule2.Table1Lebensort.AsString := AEs;
  gvar_02536430 := s;
  { The original sets the low word of gvar_02536844 to $2A01; the
    reconstruction writes the complete value. Deviation with no
    visible effect. }
  gvar_02536844 := $2A01;
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
var
  i: Integer;
begin
  { Preview hook of the reports: hands the page to the Form16 preview and
    shows the Form16. Called by the QuickReport OnPageAvailable of the
    reports. }
  i := gvar_0061F0B8;
  Form16.QRPreview1PageAvailable(Form16.QRPreview1, i);
  Form16.QRPreview1.Update;
  Form16.Show;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  { Scales the form to the screen size (up to 800x600 or 400x300
    depending on the available resolution). }
  Scaled := True;
  if Screen.Height > 300 then
  begin
    Height := Height * Screen.Height div 300;
    Width := Width * Screen.Height div 300;
    Position := poScreenCenter;
  end;
  if Screen.Height < 300 then
  begin
    Height := Height * Screen.Height div 300;
    Width := Width * Screen.Height div 300;
    Position := poScreenCenter;
  end;
end;

procedure TForm3.Edit2Exit(Sender: TObject);
begin
  Button1Click(Sender);
end;

procedure TForm3.BitBtn2Click(Sender: TObject);
begin
  { The "Abbrechen" button: in the "Verwandte suchen" mode the original
    leaves the dialog result unchanged, otherwise it sets the cancel
    result. }
  if gvar_0253692C <> 'Verw' then
    ModalResult := mrCancel;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';
  ActiveControl := Edit1;
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  s, t: AnsiString;
  n: Integer;
begin
  { "OK": if a number was entered the person is searched in Table9
    (index ''), otherwise the GEDCOM name fields are combined lower-case
    and the closest match is searched in the index "geba". The form is
    closed in any case. }
  try
    n := StrToInt(Edit1.Text);
    if n > 0 then
    begin
      DataModule2.Table9.IndexName := '';
      DataModule2.Table9.FindKey([n]);
    end;
  except
    if Trim(Edit1.Text) <> '' then
    begin
      s := LowerCase(Copy(Edit1.Text, 2, 30));
      s := ucase(Copy(Edit1.Text, 1, 1)) + s;
      t := LowerCase(Copy(Edit2.Text, 2, 30));
      t := ucase(Copy(Edit2.Text, 1, 1)) + t;
      DataModule2.Table9.IndexName := 'geba';
      DataModule2.Table9.FindNearest([s, t]);
    end;
  end;
  Close;
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
      DataModule2.Table9.IndexName := '';
      DataModule2.Table9.FindKey([StrToInt(Edit1.Text)]);
    end;
  except
  end;
end;

procedure TForm3.Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = $1B then
    ModalResult := mrCancel;
end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = $1B then
    ModalResult := mrCancel;
end;

procedure TForm3.refelt(AName: AnsiString; var AResult: AnsiString);
var
  s, t, u: AnsiString;
begin
  { Builds the text of related people: the person itself from the search
    (Table9) and, if available, the parents. Result format 'n> text <'. }
  s := '';
  DataModule2.Table9.FindKey([AName]);
  if DataModule2.Table9Vater.AsInteger > 0 then
  begin
    DataModule2.Table9.FindKey([DataModule2.Table9Vater.AsInteger]);
    s := ucase(DataModule2.Table9Name.AsString) + ' ' +
      DataModule2.Table9Vornamen.AsString;
    sub_00576F54(gvar_025363DC, u);
    t := DataModule2.Table9Name.AsString + ' ' +
      DataModule2.Table9Vornamen.AsString + #1 + u;
    gvar_02536440.Add(t);
    if Trim(DataModule2.Table9Beruf.AsString) <> '' then
      s := s + ', ' + DataModule2.Table9Beruf.AsString;
    if Trim(DataModule2.Table9Hausname.AsString) <> '' then
      s := s + ', ' + DataModule2.Table9Hausname.AsString;
  end;
  if DataModule2.Table9Mutter.AsInteger > 0 then
  begin
    DataModule2.Table9.FindKey([DataModule2.Table9Mutter.AsInteger]);
    s := s + ' und ' + ucase(DataModule2.Table9Name.AsString) + ' ' +
      DataModule2.Table9Vornamen.AsString;
    sub_00576F54(gvar_025363DC, u);
    t := DataModule2.Table9Name.AsString + ' ' +
      DataModule2.Table9Vornamen.AsString + #1 + u;
    gvar_02536440.Add(t);
    if Trim(DataModule2.Table9Beruf.AsString) <> '' then
      s := s + ', ' + DataModule2.Table9Beruf.AsString;
    if Trim(DataModule2.Table9Hausname.AsString) <> '' then
      s := s + ', ' + DataModule2.Table9Hausname.AsString;
  end;
  if Trim(s) <> '' then
    AResult := AResult + '> ' + s + ' <';
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

procedure TForm3.NList;
var
  s, alt: AnsiString;
  i, n: Integer;
begin
  { Builds the print report "Namens-Register" (Form15): the surname list in
    gvar_02536440 (entries "surname<sep>forenames", separated by the
    character #1) is condensed into Table22 (No = surname, Zus = the list
    of forenames, combined with ", " when the surname is the same) and
    printed in two columns. }
  Screen.Cursor := crHourGlass;
  if gvar_0253692C = 'Vorf' then
    gvar_02536438 := 'Vorfahren von';
  if gvar_0253692C = 'Nach' then
    gvar_02536438 := 'Nachfahren von';
  Form15.QRLabel1.Caption := 'Namens-Register zu: ' + gvar_02536438;
  DataModule2.Table22.Open;
  DataModule2.Table22.Close;
  DataModule2.Table22.EmptyTable;
  DataModule2.Table22.Open;
  DataModule2.Table22.IndexName := 'namort';
  alt := '';
  DataModule2.Table22.Append;
  n := gvar_02536440.Count - 1;
  if n >= 0 then
    for i := 0 to n do
    begin
      s := gvar_02536440[i];
      if (Trim(Copy(s, 1, Pos(#1, s) - 1)) <> '') and
         (Copy(s, 1, Pos(#1, s) - 1) <> 'NN') then
      begin
        if Copy(s, 1, Pos(#1, s) - 1) = alt then
          DataModule2.Table22Zus.AsString := DataModule2.Table22Zus.AsString +
            ', ' + Trim(Copy(s, Pos(#1, s) + 1, Length(s)))
        else
        begin
          if Trim(Copy(s, Pos(#1, s) + 1, Length(s))) <> '' then
          begin
            DataModule2.Table22.Post;
            DataModule2.Table22.Append;
            DataModule2.Table22No.AsString := Copy(s, 1, Pos(#1, s) - 1);
            DataModule2.Table22Zus.AsString :=
              Trim(Copy(s, Pos(#1, s) + 1, Length(s)));
          end;
          alt := Copy(s, 1, Pos(#1, s) - 1);
        end;
      end;
    end;
  DataModule2.Table22.Post;
  DataModule2.Table22.First;
  s := DataModule2.Table22No.AsString;
  if Trim(s) = '' then
    DataModule2.Table22.Delete;
  gvar_02536440.Free;
  Form15.QuickRep1.DataSet := DataModule2.Table22;
  Form15.QRDBText1.DataSet := DataModule2.Table22;
  Form15.QRDBText2.DataSet := DataModule2.Table22;
  Form15.QRDBText1.DataField := 'zus';
  Form15.QRDBText2.DataField := 'no';
  DataModule2.Table22.Open;
  Form15.QRBand1.Height := 37;
  Form15.QRBand3.Height := 14;
  Form15.QRBand4.Height := 18;
  Form15.QRShape1.Visible := True;
  Form15.QRShape3.Visible := True;
  Form15.QRLabel2.Visible := True;
  Form15.QRLabel3.Caption := 'Namens-Register';
  if Pos('fahren von', gvar_02536438) = 0 then
  begin
    Form15.QRLabel2.Visible := False;
    Form15.QRShape3.Visible := False;
    Form15.QRBand1.Height := 30;
  end;
  Form15.QRDBText1.Font.Size := 9;
  Form15.QRDBText2.Font.Size := 9;
  Form15.QRDBText1.AutoStretch := False;
  Form15.QRDBText2.AutoStretch := False;
  Form15.QRDBText2.AutoStretch := True;
  Form15.QRDBText1.Visible := True;
  Form15.QRDBText1.Left := 235;
  Form15.QRDBText1.Width := 46;
  Form15.QRDBText2.Visible := True;
  Form15.QRDBText2.Left := 1;
  Form15.QRDBText2.Width := 230;
  Form16.Label5.Visible := True;
  Form16.Button9.Visible := True;
  Form16.SpeedButton3.Visible := True;
  Form16.SpeedButton6.Visible := False;
  Form15.QuickRep1.Page.Columns := 2;
  Screen.Cursor := crDefault;
  { The original wires its preview hook (offsets 2A8/2AC of QuickRep1) and
    calls TCustomQuickRep.Preview. The reconstruction uses the standard
    preview. }
  { Form15.QuickRep1.Preview; - die Vorschau ist im Kompatibilitaetsschicht nicht implementiert. }
end;

procedure TForm3.OList;
var
  s, alt: AnsiString;
  i, n: Integer;
begin
  { Builds the print report "Orts-Register" (Form15): identical layout to
    NList, but the place list in gvar_02536444 (entries
    " Place<sep>additions") is condensed into Table22 and printed with
    2 columns. //00595FB4 }
  Screen.Cursor := crHourGlass;
  if gvar_0253692C = 'Vorf' then
    gvar_02536438 := 'Vorfahren von';
  if gvar_0253692C = 'Nach' then
    gvar_02536438 := 'Nachfahren von';
  Form15.QRLabel1.Caption := 'Orts-Register zu: ' + gvar_02536438;
  DataModule2.Table22.Open;
  DataModule2.Table22.Close;
  DataModule2.Table22.EmptyTable;
  DataModule2.Table22.Open;
  DataModule2.Table22.IndexName := 'namort';
  alt := '';
  DataModule2.Table22.Append;
  n := gvar_02536444.Count - 1;
  if n >= 0 then
    for i := 0 to n do
    begin
      s := gvar_02536444[i];
      if Trim(Copy(s, 1, Pos(#1, s) - 1)) <> '' then
      begin
        if Copy(s, 1, Pos(#1, s) - 1) = alt then
          DataModule2.Table22Zus.AsString := DataModule2.Table22Zus.AsString +
            ', ' + Trim(Copy(s, Pos(#1, s) + 1, Length(s)))
        else
        begin
          DataModule2.Table22.Post;
          DataModule2.Table22.Append;
          DataModule2.Table22No.AsString := Copy(s, 1, Pos(#1, s) - 1);
          DataModule2.Table22Zus.AsString :=
            Trim(Copy(s, Pos(#1, s) + 1, Length(s)));
          alt := Copy(s, 1, Pos(#1, s) - 1);
        end;
      end;
    end;
  DataModule2.Table22.Post;
  DataModule2.Table22.First;
  s := DataModule2.Table22No.AsString;
  if Trim(s) = '' then
    DataModule2.Table22.Delete;
  gvar_02536444.Free;
  Form15.QuickRep1.DataSet := DataModule2.Table22;
  Form15.QRDBText1.DataSet := DataModule2.Table22;
  Form15.QRDBText2.DataSet := DataModule2.Table22;
  Form15.QRDBText1.DataField := 'zus';
  Form15.QRDBText2.DataField := 'no';
  DataModule2.Table22.Open;
  Form15.QRBand1.Height := 37;
  Form15.QRBand3.Height := 14;
  Form15.QRBand4.Height := 18;
  Form15.QRShape1.Visible := True;
  Form15.QRShape3.Visible := True;
  Form15.QRLabel2.Visible := True;
  Form15.QRLabel3.Caption := 'Orts-Register';
  if Pos('fahren von', gvar_02536438) = 0 then
  begin
    Form15.QRLabel2.Visible := False;
    Form15.QRShape3.Visible := False;
    Form15.QRBand1.Height := 30;
  end;
  Form15.QRDBText1.Font.Size := 9;
  Form15.QRDBText2.Font.Size := 9;
  Form15.QRDBText1.AutoStretch := False;
  Form15.QRDBText2.AutoStretch := False;
  Form15.QRDBText2.AutoStretch := True;
  Form15.QRDBText1.Visible := True;
  Form15.QRDBText1.Left := 155;
  Form15.QRDBText1.Width := 150;
  Form15.QRDBText2.Visible := True;
  Form15.QRDBText2.Left := 1;
  Form15.QRDBText2.Width := 150;
  Form16.Label5.Visible := True;
  Form16.Button9.Visible := True;
  Form16.SpeedButton3.Visible := True;
  Form16.SpeedButton6.Visible := False;
  Form15.QuickRep1.Page.Columns := 2;
  Screen.Cursor := crDefault;
  { Form15.QuickRep1.Preview; - die Vorschau ist im Kompatibilitaetsschicht nicht implementiert. }
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


