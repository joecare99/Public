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
  Windows, SysUtils, StrUtils, Classes, StdCtrls, Buttons, DBTables, DBCommon, Dialogs, Forms, Controls, Grids, DB, AHNGlobals, Unit1, Unit2, Unit15, Unit16, Unit14, Unit28, Unit29, Unit36, Unit39, Unit26, Unit27;

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
    procedure illki(ALine: AnsiString; ANr: Integer; var AErgebnis: AnsiString); //00584350
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

function sub_00582C24(A, B, C: AnsiString): AnsiString;
  {00582C24 (ret 4, ruekwert via [ebp+8]) - Konvertiert ein deutsches
   Datum (A = Tag, B = Monatsnummer, C = Jahr) in das nvj-konforme
   Exportformat. Bei voller Monatsnummer (1..12) entsteht 'DD MON YYYY'
   (Format %2s/%4s), sonst das Punktformat 'DD.MM.YYYY'. Enthaelt der
   Teil A eines der Praefix-Kennzeichen um/UM/ca/CA/VO/vo/na/NA/ER/er,
   wird der Rueckwert erst nach der Praefix-Kette (ABT/BEF/AFT/CAL)
   gefuellt: 'ABT ' + Monatskuerzel + ' ' + Jahr ohne Tagesangabe.
   Leerer Tag: 'MON YYYY', leeres Jahr: 'YYYY'. }
var
  mon, s, up1, up2, up3, up4, up5: AnsiString;
begin
  mon := '';  {00582C6C}
  case StrToInt(B) of  {00582C82 jumptable 00582C97}
    1: mon := 'JAN';  {00582CCB 58319C}
    2: mon := 'FEB';  {00582CDD 5831A8}
    3: mon := 'MAR';  {00582CEF 5831B4}
    4: mon := 'APR';  {00582D01 5831C0}
    5: mon := 'MAY';  {00582D10 5831CC}
    6: mon := 'JUN';  {00582D1F 5831D8}
    7: mon := 'JUL';  {00582D2E 5831E4}
    8: mon := 'AUG';  {00582D3D 5831F0}
    9: mon := 'SEP';  {00582D4C 5831FC}
    10: mon := 'OCT';  {00582D5B 583208}
    11: mon := 'NOV';  {00582D6A 583214}
    12: mon := 'DEC';  {00582D79 583220}
  end;
  s := Format('%2s', [A]) + ' ' + mon + ' ' + Format('%4s', [C]);  {00582D99-582DDB}
  if mon = '' then  {00582DFF jne 00582E7C}
    s := Format('%2s', [A]) + '.' + Format('%2s', [B]) + '.' +  {00582E05-582E77}
      Format('%4s', [C]);
  Result := '';  {00582E7F}
  { Nur ohne Praefix-Kennzeichen wird der Standard-Rueckwert uebernommen; }
  if Pos('um*UM*ca*CA*VO*vo*na*NA*ER*er', A) = 0 then  {00582E93}
    Result := s;  {00582E7C/CatN5-Bereits}
  up1 := UpperCase(s);  {00582EA6}
  if Pos('UM', up1) > 0 then  {00582EB3}
  begin
    if StrToInt(B) > 0 then  {00582ED2}
      Result := 'ABT ' + mon + ' ' + C;  {00582ED6-582EEE CatN4}
  end
  else
  begin
    up2 := UpperCase(s);  {00582F25}
    if Pos('CA', up2) > 0 then  {00582F2D}
    begin
      if StrToInt(B) > 0 then  {00582F4C}
        Result := 'ABT ' + mon + ' ' + C;  {00582F55-582F6D}
    end
    else
    begin
      up3 := UpperCase(s);  {00582FA4}
      if Pos('VO', up3) > 0 then  {00582FB1}
      begin
        if StrToInt(B) > 0 then  {00582FCB}
          Result := 'BEF ' + mon + ' ' + C;  {00582FD4-582FEC}
      end
      else
      begin
        up4 := UpperCase(s);  {00583023}
        if Pos('NA', up4) > 0 then  {0058302B}
        begin
          if StrToInt(B) > 0 then  {0058304A}
            Result := 'AFT ' + mon + ' ' + C;  {00583053-58306B}
        end
        else
        begin
          up5 := UpperCase(s);  {005830A2}
          if Pos('ER', up5) > 0 then  {005830AA}
          begin
            if StrToInt(B) > 0 then  {005830C9}
              Result := 'CAL ' + mon + ' ' + C;  {005830D2-5830EA}
          end
          else
          begin
            if Length(Trim(A)) = 0 then  {00583115-583124}
            begin
              Result := mon + ' ' + C;  {00583126-583139 CatN3}
              if Length(Trim(B)) = 0 then  {0058313E}
                Result := C;  {0058314F [ebp+8]=C}
            end;
          end;
        end;
      end;
    end;
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

procedure TForm3.illki(ALine: AnsiString; ANr: Integer;
  var AErgebnis: AnsiString);
var
  i, num, k, lfbFlag, bmk: Integer;
  s, u: AnsiString;
begin
  { 00584350: Builds a "Lebenslinien"-like catalog entry for the person
    numbers packed 7 characters each into ALine. AErgebnis receives
    "Name Vorname" plus birth/baptism/death details of every person
    found; gvar_02536440 collects names, gvar_02536444 places,
    gvar_02536664 abbreviated places. ANr is the caller's own line
    number, used as the suffix produced by sub_00576F54. }
  AErgebnis := '';
  if Length(Trim(ALine)) = 0 then
    Exit;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.First;
  num := Round(Length(ALine) / 7);
  if num <= 0 then
    Exit;
  i := 1;
  while i <= num do
  begin
    k := StrToInt(Copy(ALine, (i - 1) * 7 + 1, 6));
    DataModule2.Table1.FindKey([k]);
    AErgebnis := AErgebnis + DataModule2.Table1Name.AsString + ' ' +
      DataModule2.Table1Vornamen.AsString;
    if Trim(DataModule2.Table1Name.AsString) <> '' then
    begin
      if gvar_02536414 = 1 then
      begin
        if gvar_02536418 = 1 then
        begin
          sub_00576F54(i, u);
          gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +
            DataModule2.Table1Vornamen.AsString + ' * ' +
            DataModule2.Table1Gebjahr.AsString + u);
        end
        else
        begin
          sub_00576F54(i, u);
          gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +
            DataModule2.Table1Vornamen.AsString + u);
        end;
      end
      else
      begin
        sub_00576F54(i, u);
        gvar_02536440.Add(DataModule2.Table1Name.AsString + u);
      end;
    end;
    lfbFlag := 0;
    gvar_02536454 := Form1.lfbh2.IndexName;
    bmk := -1; //v150 GetBookmark - Stub, Original war Client-Bookmarkhandle
    Form1.lfbh2.IndexName := 'Pro';
    Form1.lfbh2.First;
    sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u);
    k := StrToInt(u);                                        {0058462A}
    if Form1.lfbh2.FindKey([k]) then
    begin
      AErgebnis := AErgebnis + ' [' +
        IntToStr(Form1.lfbh2Nm.AsInteger) + ']';
      lfbFlag := 1;
    end;
    Form1.lfbh2.IndexName := gvar_02536454;
    //v1A0 GotoBookmark - Stub, Original restaurierte das Bookmarkhandle
    if lfbFlag <> 0 then
    begin
      Inc(i);
      Continue;                                              {00584DDA}
    end;
    if gvar_02536404 = 1 then
      if Trim(DataModule2.Table1Religion.AsString) <> '' then
        AErgebnis := AErgebnis + ', ' +
          DataModule2.Table1Religion.AsString;
    if gvar_025363F0 = 1 then
    begin
      if Trim(DataModule2.Table1Beruf.AsString) <> '' then
        AErgebnis := AErgebnis + ', ' +
          DataModule2.Table1Beruf.AsString;
      if Trim(DataModule2.Table1Hausname.AsString) <> '' then
        AErgebnis := AErgebnis + ' ' +
          DataModule2.Table1Hausname.AsString;
    end;
    if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or
      (Trim(DataModule2.Table1Gebort.AsString) <> '') then
    begin
      sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' +
        DataModule2.Table1Gebmonat.AsString + '.' +
        DataModule2.Table1Gebjahr.AsString, s);
      AErgebnis := AErgebnis + ' * ' + s;
      if gvar_02536410 = 1 then
      begin
        if Trim(DataModule2.Table1Gebort.AsString) <> '' then
        begin
          oabk(DataModule2.Table1Gebort.AsString, s);
          gvar_02536664 := gvar_02536664 + s;
        end
        else
          AErgebnis := AErgebnis + ' ' +
            DataModule2.Table1Gebort.AsString;
      end;
      sub_00576F54(ANr, u);
      gvar_02536444.Add(DataModule2.Table1Gebort.AsString + u);
    end
    else if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or
      (Trim(DataModule2.Table1Taufort.AsString) <> '') then
    begin
      sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' +
        DataModule2.Table1Taufmonat.AsString + '.' +
        DataModule2.Table1Taufjahr.AsString, s);
      AErgebnis := AErgebnis + ' ~ ' + s;
      if gvar_02536410 = 1 then
      begin
        if Trim(DataModule2.Table1Taufort.AsString) <> '' then
        begin
          oabk(DataModule2.Table1Taufort.AsString, s);
          gvar_02536664 := gvar_02536664 + s;
        end
        else
          AErgebnis := AErgebnis + ' ' +
            DataModule2.Table1Taufort.AsString;
      end;
      sub_00576F54(ANr, u);
      gvar_02536444.Add(DataModule2.Table1Taufort.AsString + u);
    end;
    if gvar_02536400 = 1 then
      if Trim(DataModule2.Table1Taufpat.AsString) <> '' then
        AErgebnis := AErgebnis + ' (TP: ' +
          DataModule2.Table1Taufpat.AsString + ')';
    if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or
      (Trim(DataModule2.Table1Stort.AsString) <> '') then
    begin
      sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' +
        DataModule2.Table1Stmonat.AsString + '.' +
        DataModule2.Table1Stjahr.AsString, s);
      AErgebnis := AErgebnis + ' + ' + s;
      if gvar_02536410 = 1 then
      begin
        if Trim(DataModule2.Table1Stort.AsString) <> '' then
        begin
          oabk(DataModule2.Table1Stort.AsString, s);
          gvar_02536664 := gvar_02536664 + s;
        end
        else
          AErgebnis := AErgebnis + ' ' +
            DataModule2.Table1Stort.AsString;
      end;
      sub_00576F54(ANr, u);
      gvar_02536444.Add(DataModule2.Table1Stort.AsString + u);
    end;
    Inc(i);
  end;
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

{005BC604 - Phase-III-Flush: schreibt die Daten der aktuellen Familie
  (Husband- und Wife-Nummer, RelN/Married-Flag, Geschieden-Datum/-Ort,
  Ehedaten/-orte/-zeugen und die Quellen) in die Datentabellen.}
procedure sub_005BC604(AHusn, AWifn, ARelN: Integer; AMarried: Integer;
  ADatD, AOrtD, ADat1, AOrt1, AWit1, ADat2, AOrt2, AWit2, AQm1, AQm2,
  AQd: AnsiString); register;
begin
  { 005BC604: Ehe-/Familie-Satz (Table5) zu AHusn/AWifn suchen bzw. ergänzen
    und die im GEDCOM-Import (gedein_5 Phase III) gesammelten Heirats-/
    2. Heirats-/Scheidungsdaten zuweisen. }
  if not DataModule2.Table5.FindKey([AHusn]) then  {005BC6A0}
  begin
    DataModule2.Table5.Append;  {005BC6B5 [80]}
    DataModule2.Table5Nummer.AsInteger := AHusn;  {005BC6C6 [410]}
    DataModule2.Table5Epnum.AsInteger := AWifn;  {005BC6D9 [414]}
  end;
  { TODO C2: 005BD081/005BC6E4 - Edit-Pfad (Verbind 440, Datum/Ort/Zeuge/Quelle-
    Feldgruppen 418-45C, '2 SOUR'-Kette), Post, Pass-2 (005BD096). }
  DataModule2.Table5.Edit;  {005BC702}
  if AMarried = 1 then  {005BC70B}
    DataModule2.Table5Verbind.AsString := 'Eheschliessung'  {005BC715 [440]}
  else if AMarried = 0 then  {005BC724}
    DataModule2.Table5Verbind.AsString := 'andere Beziehung';  {005BC737}
  if Length(Trim(ADat1)) > 0 then  {005BC74E}
  begin
    if Pos(',', ADat1) > 0 then  {005BC763}
      sub_00577934(Copy(ADat1, 8, Pos(',', ADat1) - 8))  {005BC78B}
    else
      sub_00577934(Copy(ADat1, 8, Length(TrimRight(ADat1))));  {005BC7BB}
    DataModule2.Table5Htag.AsString := gvar_02536624;  {005BC7D0 [418]}
    DataModule2.Table5Hmonat.AsString := gvar_02536628;  {005BC7DF [41C]}
    DataModule2.Table5Hjahr.AsString := gvar_0253662C;  {005BC7F1 [420]}
  end;
  if Length(Trim(ADat2)) > 0 then  {005BC811}
  begin
    if Pos(',', ADat2) > 0 then  {005BC826}
      sub_00577934(Copy(ADat2, 8, Pos(',', ADat2) - 8))  {005BC84E}
    else
      sub_00577934(Copy(ADat2, 8, Length(TrimRight(ADat2))));  {005BC87E}
    DataModule2.Table5Satag.AsString := gvar_02536624;  {005BC893 [42C]}
    DataModule2.Table5Samonat.AsString := gvar_02536628;  {005BC8A3 [430]}
    DataModule2.Table5Sajahr.AsString := gvar_0253662C;  {005BC8B5 [434]}
  end;
  if Length(Trim(ADatD)) > 0 then  {005BC8D4}
  begin
    if Pos(',', ADatD) > 0 then  {005BC8E9}
      sub_00577934(Copy(ADatD, 8, Pos(',', ADatD) - 8))  {005BC911}
    else
      sub_00577934(Copy(ADatD, 8, Length(TrimRight(ADatD))));  {005BC93E}
    DataModule2.Table5Schtag.AsString := gvar_02536624;  {005BC956 [444]}
    DataModule2.Table5Schmonat.AsString := gvar_02536628;  {005BC967 [448]}
    DataModule2.Table5Schjahr.AsString := gvar_0253662C;  {005BC979 [44C]}
  end;
  if Length(Trim(AOrt1)) > 0 then  {005BC997}
  begin
    if Pos(',', AOrt1) > 0 then  {005BC9A8}
      DataModule2.Table5Hort.AsString :=
        Copy(AOrt1, 8, Pos(',', AOrt1) - 8)  {005BC9D5 [424]}
    else
      DataModule2.Table5Hort.AsString :=
        Copy(AOrt1, 8, Length(AOrt1));  {005BCA05 [424]}
  end;
  if Length(Trim(AOrt2)) > 0 then  {005BCA1F}
  begin
    if Pos(',', AOrt2) > 0 then  {005BCA30}
      DataModule2.Table5Saort.AsString :=
        Copy(AOrt2, 8, Pos(',', AOrt2) - 8)  {005BCA5D [438]}
    else
      DataModule2.Table5Saort.AsString :=
        Copy(AOrt2, 8, Length(AOrt2));  {005BCA8D [438]}
  end;
  if Length(Trim(AOrtD)) > 0 then  {005BCAA7}
  begin
    if Pos(',', AOrtD) > 0 then  {005BCAB8}
      DataModule2.Table5Schort.AsString :=
        Copy(AOrtD, 8, Pos(',', AOrtD) - 8)  {005BCAE5 [450]}
    else
      DataModule2.Table5Schort.AsString :=
        Copy(AOrtD, 8, Length(AOrtD));  {005BCB15 [450]}
  end;
  if Length(Trim(AWit1)) > 0 then  {005BCB2F}
    DataModule2.Table5Trauz.AsString :=
      Copy(AWit1, 9, Length(AWit1));  {005BCB56 [428]}
  if Length(Trim(AWit2)) > 0 then  {005BCB6E}
    DataModule2.Table5Satrauz.AsString :=
      Copy(AWit2, 9, Length(AWit2));  {005BCB95 [43C]}
  if Pos('2 SOUR @', AQm1) > 0 then  {005BCBAB}
  begin
    gvar_02536850 := '';  {005BCBB4 LStrClr}
    Form1.Repso2.IndexName := 'ih';  {005BCBC7}
    if Form1.Repso2.FindKey([Trim(Copy(AQm1, 8, Length(AQm1)))]) then  {005BCC18}
      gvar_02536850 := Form1.Repso2inh2.AsString;  {005BCC3A [8D0]}
    if Pos(gvar_02536850, DataModule2.Table5Hqu.AsString) = 0 then  {005BCC57}
    begin
      DataModule2.Table5.Edit;  {005BCC9E}
      if Length(Trim(DataModule2.Table5Hqu.AsString)) > 0
        then  {005BCC94 jbe-CCFC}
      begin
        DataModule2.Table5Hqu.AsString :=
          Trim(DataModule2.Table5Hqu.AsString + '; ' +
            gvar_02536850);  {005BCCF1 CatN3 [454]}
      end
      else
      begin
        DataModule2.Table5Hqu.AsString :=
          gvar_02536850;  {005BCD16}
      end;
    end;
  end;
  if Pos('2 SOUR @', AQm2) > 0 then  {005BCD2E}
  begin
    gvar_02536850 := '';  {005BCD37}
    Form1.Repso2.IndexName := 'ih';  {005BCD4A}
    if Form1.Repso2.FindKey([Trim(Copy(AQm2, 8, Length(AQm2)))]) then  {005BCDA5}
      gvar_02536850 := Form1.Repso2inh2.AsString;  {005BCDCB [8D0]}
    if Pos(gvar_02536850, DataModule2.Table5Saqu.AsString) = 0 then  {005BCDE8}
    begin
      DataModule2.Table5.Edit;  {005BCE37}
      if Length(Trim(DataModule2.Table5Saqu.AsString)) > 0
        then  {005BCE2D jbe-CE95}
      begin
        DataModule2.Table5Saqu.AsString :=
          Trim(DataModule2.Table5Saqu.AsString + '; ' +
            gvar_02536850);  {005BCE8A CatN3 [458]}
      end
      else
      begin
        DataModule2.Table5Saqu.AsString :=
          gvar_02536850;  {005BCEAF}
      end;
    end;
  end;
  if Pos('2 SOUR @', AQd) > 0 then  {005BCEC7}
  begin
    gvar_02536850 := '';  {005BCED0}
    Form1.Repso2.IndexName := 'ih';  {005BCEE3}
    if Form1.Repso2.FindKey([Trim(Copy(AQd, 8, Length(AQd)))]) then  {005BCF3E}
      gvar_02536850 := Form1.Repso2inh2.AsString;  {005BCF64 [8D0]}
    if Pos(gvar_02536850, DataModule2.Table5Schqu.AsString) = 0 then  {005BCF81}
    begin
      DataModule2.Table5.Edit;  {005BCFCA}
      if Length(Trim(DataModule2.Table5Schqu.AsString)) > 0
        then  {005BCFC6 jbe-D02E}
      begin
        DataModule2.Table5Schqu.AsString :=
          Trim(DataModule2.Table5Schqu.AsString + '; ' +
            gvar_02536850);  {005BD024 CatN3 [45C]}
      end
      else
      begin
        DataModule2.Table5Schqu.AsString :=
          gvar_02536850;  {005BD049}
      end;
    end;
  end;
  DataModule2.Table5.Post;  {005BD054 vtbl+248}
  { Pass 2: gleiche Zuweisung auf den Partner-Satz (Nummer = AWifn) - Mirror
    005BD096: FindKey/Append, Edit im Partner-Satz folgt in C3. }
  if not DataModule2.Table5.FindKey([AWifn]) then  {005BD0AD}
  begin
    DataModule2.Table5.Append;  {005BD0C2 [80]}
    DataModule2.Table5Nummer.AsInteger := AWifn;  {005BD0D4 [410]}
    DataModule2.Table5Epnum.AsInteger := AHusn;  {005BD0E6 [414]}
  end;
  { TODO C3: 005BD0F1..005BD65C - Mirror-Edit-Pfad + Epilog. }
  DataModule2.Table5.Edit;  {005BD10E}
  if AMarried = 1 then  {005BD113}
    DataModule2.Table5Verbind.AsString := 'Eheschliessung'  {005BD119 [440]}
  else if AMarried = 0 then  {005BD130}
    DataModule2.Table5Verbind.AsString := 'andere Beziehung';  {005BD145}
  if Length(Trim(ADat1)) > 0 then  {005BD160}
  begin
    if Pos(',', ADat1) > 0 then  {005BD175}
      sub_00577934(Copy(ADat1, 8, Pos(',', ADat1) - 8))  {005BD1A0}
    else
      sub_00577934(Copy(ADat1, 8, Length(TrimRight(ADat1))));  {005BD1DC}
    DataModule2.Table5Htag.AsString := gvar_02536624;  {005BD1F1 [418]}
    DataModule2.Table5Hmonat.AsString := gvar_02536628;  {005BD201 [41C]}
    DataModule2.Table5Hjahr.AsString := gvar_0253662C;  {005BD213 [420]}
  end;
  if Length(Trim(ADat2)) > 0 then  {005BD23B}
  begin
    if Pos(',', ADat2) > 0 then  {005BD250}
      sub_00577934(Copy(ADat2, 8, Pos(',', ADat2) - 8))  {005BD27B}
    else
      sub_00577934(Copy(ADat2, 8, Length(TrimRight(ADat2))));  {005BD2B7}
    DataModule2.Table5Satag.AsString := gvar_02536624;  {005BD2CC [42C]}
    DataModule2.Table5Samonat.AsString := gvar_02536628;  {005BD2DC [430]}
    DataModule2.Table5Sajahr.AsString := gvar_0253662C;  {005BD2EE [434]}
  end;
  if Length(Trim(ADatD)) > 0 then  {005BD316}
  begin
    if Pos(',', ADatD) > 0 then  {005BD32B}
      sub_00577934(Copy(ADatD, 8, Pos(',', ADatD) - 8))  {005BD356}
    else
      sub_00577934(Copy(ADatD, 8, Length(TrimRight(ADatD))));  {005BD392}
    DataModule2.Table5Schtag.AsString := gvar_02536624;  {005BD3A7 [444]}
    DataModule2.Table5Schmonat.AsString := gvar_02536628;  {005BD3B7 [448]}
    DataModule2.Table5Schjahr.AsString := gvar_0253662C;  {005BD3C9 [44C]}
  end;
  if Length(Trim(AOrt1)) > 0 then  {005BD3F1}
  begin
    if Pos(',', AOrt1) > 0 then  {005BD406}
      DataModule2.Table5Hort.AsString :=
        Copy(AOrt1, 8, Pos(',', AOrt1) - 8)  {005BD430 [424]}
    else
      DataModule2.Table5Hort.AsString :=
        Copy(AOrt1, 8, Length(AOrt1));  {005BD461 [424]}
  end;
  if Length(Trim(AOrt2)) > 0 then  {005BD48F}
  begin
    if Pos(',', AOrt2) > 0 then  {005BD4A4}
      DataModule2.Table5Saort.AsString :=
        Copy(AOrt2, 8, Pos(',', AOrt2) - 8)  {005BD4D9 [438]}
    else
      DataModule2.Table5Saort.AsString :=
        Copy(AOrt2, 8, Length(AOrt2));  {005BD50A [438]}
  end;
  if Length(Trim(AOrtD)) > 0 then  {005BD52D}
  begin
    if Pos(',', AOrtD) > 0 then  {005BD542}
      DataModule2.Table5Schort.AsString :=
        Copy(AOrtD, 8, Pos(',', AOrtD) - 8)  {005BD577 [450]}
    else
      DataModule2.Table5Schort.AsString :=
        Copy(AOrtD, 8, Length(AOrtD));  {005BD5A8 [450]}
  end;
  if Length(Trim(AWit1)) > 0 then  {005BD5CB}
    DataModule2.Table5Trauz.AsString :=
      Copy(AWit1, 9, Length(AWit1));  {005BD5F5 [428]}
  if Length(Trim(AWit2)) > 0 then  {005BD616}
    DataModule2.Table5Satrauz.AsString :=
      Copy(AWit2, 9, Length(AWit2));  {005BD63E [43C]}
  DataModule2.Table5.Post;  {005BD656 vtbl+248}
  { Pass 2 schreibt die Quell-Felder 454/458/45C NICHT (nur Pass 1).
    005BD65E/005BD063: Next/Eof-Suchknoten aus der ASM-Kontrollstruktur -
    im Recon-Fluss (FindKey/Append positioniert bereits) nicht erreichbar. }
end;

procedure TForm3.gedein_5;
label
  LHeaderLoop, LPhase1, LPhase1Tail, LPhase2, LPhase2Start, LPhase2Tail,
  LPhase3, LPhase3Tail;
var
  zaeler, lastnr, nummer, personCount, famCount: Integer;
  startnr, maxnum: Integer;
  married, relN, husn, wifn, famIdx, childCount: Integer;
  chrKey, snr, iii, kIdx, divres: Integer;
  namIdx: Integer;
  tt: AnsiString;
  gvar_0253686C: Integer;
  skipHeder, srcmode: Integer;
  Dtag1, Dmonat1, Djahr1: AnsiString;
  srcKey, showtext, srcstr: AnsiString;
  srcRec: AnsiString;
  header, srcname, zeile, r, sn1, key, dstr, ptmp: AnsiString;
  alt84, alt88, temp0, temp1, sav1, sav2: AnsiString;
  m1dat, m1ort, m1wit, m2dat, m2ort, m2wit: AnsiString;
  m2hnd, m1hnd, m2wit2, m1ort2, m2hnd2: AnsiString;
  ddat, dort, qm1, qm2, qd: AnsiString;
  kv: array[0..1] of TVarRec;
begin
  { $005BFB94: kompletter Import einer GEDCOM-Datei. Legt zun?chst eine
    tempor?re Familiestabelle "fsc" (Nr/Fnr/V/M/K) im EXE-Verzeichnis an und
    ordnet danach die ersten GEDCOM-Zeilen den Kopfdaten zu (Header-Loop).
    Phase I z?hlt/registriert @INDI- und @F-Objekte und importiert die
    Stammerfassungs-Objekte (0 @S/0 @P/0 @N), Phase II schreibt die Personen,
    Phase III die Familien. }
  gvar_0253686C := 0;
  skipHeder := 0;
  startnr := DataModule2.Table1Nummer.AsInteger;  {//534 [edx+58]}
  DataModule2.Table1.Open;  {//[5C]}
  gvar_02536860 := TTable.Create(nil);  {005BFC05: Create mit ecx=[ebp-4], dl=1}
  gvar_02536860.DatabaseName := ExtractFilePath(ParamStr(0));  {005BFBF2}
  gvar_02536860.TableType := ttDefault;  {dl=1: ttDefault}
  gvar_02536860.TableName := 'fsc';  {005BFC4F}
  gvar_02536860.FieldDefs.Clear;  {005BFC54}
  gvar_02536860.FieldDefs.Add('Nr', ftAutoInc, 0, True);  {005BFC70}
  gvar_02536860.FieldDefs.Add('Fnr', ftInteger, 0, True);  {005BFC82}
  gvar_02536860.FieldDefs.Add('V', ftInteger, 0, False);  {005BFC94}
  gvar_02536860.FieldDefs.Add('M', ftInteger, 0, False);  {005BFCA6}
  gvar_02536860.FieldDefs.Add('K', ftString, 180, False);  {005BFCBB size 0xB4}
  gvar_02536860.IndexDefs.Clear;  {005BFCC5 +24C}
  gvar_02536860.IndexDefs.Add('Nr', 'Nr', [ixPrimary]);  {004A9778 opt 0x1}
  gvar_02536860.IndexDefs.Add('Fnr', 'Fnr', []);  {004A9778 opt 0x0}
  try
    gvar_02536860.CreateTable;  {005BFD13}
  except
    { 005BFD27: Exception abfangen, Meldung, Abbruch (kein Reraise). }
    ShowMessage('Fehler');
    Screen.Cursor := crDefault;
    exit;
  end;
  gvar_02536860.Open;  {005BFD45}
  gvar_02536860.IndexName := 'Fnr';  {005BFD54}
  OpenDialog1.Filter := 'Gedcom-Dateien (*.ged)|*.ged';  {005BFD6A}
  if not OpenDialog1.Execute then
  begin
    { 005C52E1: Abbruch-Epilog (Ohne Datenaustausch). }
    Form1.Label18.Visible := False;
    Form1.Label19.Visible := False;
    { 005C5302: Form1.Repso2.SetDataSource(DataModule2.DataSource1) - die
      DataSource-Eigenschaft ist in Delphi 9 schreibgesch??tzt, Recon ??ber
      die DataSet-Eigenschaft der Quelle. }
    DataModule2.DataSource1.DataSet := Form1.Repso2;
    DataModule2.Table1.EnableControls;
    Form1.Repso2.EnableControls;
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.First;
    if lastnr > 0 then
      DataModule2.Table1.FindKey([startnr]);
    Screen.Cursor := crDefault;
    gvar_02536860.Close;
    gvar_02536860.DeleteTable;
    exit;
  end;
  Screen.Cursor := crHourGlass;  {5C55: 0xFFF5 = -11}
  zaeler := 1;  {005BFD9C}
  if DataModule2.Table1.RecordCount > 1 then
  begin
    { 005BFDBE: Verzweigung vor dem Import. }
    gvar_0253686C := Application.MessageBox(
      'Bestehende Daten ?berschreiben ?', 'Gedcom-Datei einlesen', 3);
    if gvar_0253686C = ID_CANCEL then
    begin
      { 005BFE4E. }
      Screen.Cursor := crDefault;
      gvar_02536860.Close;
      gvar_02536860.DeleteTable;
      exit;
    end
    else if gvar_0253686C = IDYES then
    begin
      { 005BFE75: alle Tabellen leeren, auch die Formulareinstellungen. }
      Form14.ListBox1.Clear;  {Form14.ListBox1 //300}
      Form28.ListBox1.Clear;  {Form28.ListBox1 //300}
      Form29.ListBox1.Clear;  {Form29.ListBox1 //2F8}
      Form36.ListBox1.Clear;  {Form36.ListBox1 //300}
      Form39.ListBox1.Clear;  {Form39.ListBox1 //300}
      DataModule2.Table5.MasterSource := nil;
      DataModule2.Table5.Open;
      DataModule2.Table5.Close;
      DataModule2.Table5.EmptyTable;
      DataModule2.Table5.Open;
      DataModule2.Table1.Open;
      DataModule2.Table1.Close;
      DataModule2.Table1.EmptyTable;
      DataModule2.Table1.Open;
      DataModule2.Table13.Open;
      DataModule2.Table13.Close;
      DataModule2.Table13.EmptyTable;
      DataModule2.Table13.Open;
      DataModule2.Table38.Open;
      DataModule2.Table38.Close;
      DataModule2.Table38.EmptyTable;
      DataModule2.Table38.Open;
      Form1.anzeigen;  {005D42BC}
    end
    else if gvar_0253686C = IDNO then
    begin
      { 005BFDE7: Daten sollen erhalten bleiben - nur zuletzt bearbeiteten
        Datensatz wiederfinden. }
      DataModule2.Table1.IndexName := '';
      DataModule2.Table1.Last;
      lastnr := DataModule2.Table1Nummer.AsInteger;
      nummer := DataModule2.Table1Nummer.AsInteger;
      gvar_02536944 := nummer;
      DataModule2.Table1.FindKey([startnr]);
    end;
  end;
  { 005BFFCB: gemeinsame Vorbereitung. }
  DataModule2.Table5.MasterSource := nil;
  DataModule2.Table1.DisableControls;
  DataModule2.Table5.DisableControls;
  DataModule2.Table25.Open;  {005BFFF9}
  DataModule2.Table25.Close;
  DataModule2.Table25.EmptyTable;
  DataModule2.Table25.Open;
  DataModule2.Table25.IndexName := 'AA';  {0x5C54EC}
  Form1.Repso2.Open;
  Form1.Repso2.EmptyDataSet;  {005C0051}
  Form1.Refresh;
  DataModule2.Table4.Open;
  DataModule2.Table4.Close;
  DataModule2.Table4.EmptyTable;
  DataModule2.Table4.Open;
  Form1.Label19.Visible := True;
  Form1.Label19.Caption := 'Gedcom vorbereiten';
  Form1.Label19.Refresh;
  AssignFile(gvar_02536670, OpenDialog1.FileName);
  DataModule2.Table38.Open;
  DataModule2.Table13.Open;
  header := '';
  gvar_02536848 := '';
  gvar_0253685C := '';
  Reset(gvar_02536670);

  { Kopf-Header-Loop (005C011C..005C0D48): Verarbeitung der GEDCOM-Headereihe. }
  zeile := '';
  while True do
  begin
    if Pos('@ INDI', zeile) > 0 then
    begin
      { 005C0D48: Phase-I-Einstieg. }
      if gvar_02536848 = 'unic' then
        ShowMessage('Die Gedcom-Datei ist im Unicode-Zeichensatz codiert.' +
          #13#10 + 'Es kann (v.a.bei Umlauten) zu Lesefehlern kommen.');
      personCount := 0;  {005C0D65 [10]}
      famCount := 0;
      Form1.Label18.Visible := True;
      Form1.Label18.Caption := '0';
      Form1.Label18.Refresh;
      break;
    end;
    if Pos('0 HEAD', zeile) = 4 then
      gvar_02536848 := 'utf';  {005C017E - Original setzt hier 'utf' als Vorgabe}
    if UpperCase(Copy(zeile, 1, 6)) = '1 FILE' then
      header := header + #13#10 + 'Datei: ' +
      {005C0207: CatN5}
        Copy(zeile, 8, Length(zeile)) + #13#10;
    if Pos('DATE', ucase(zeile)) > 0 then
    begin
      {005C02A9: ucase(zeile); Pos('DATE', ...); 2 DATE}
      sub_00577934(Copy(zeile, 8, Length(zeile)));
      header := header + #13#10 + 'Datum: ' + gvar_02536624 + '.' +
        gvar_02536628 + '.' + gvar_0253662C;  {CatN8 005C028B}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '1 SOUR' then
    begin
      header := header + #13#10 + 'Quelle: ' +
      {005C02CB: CatN4 005C02DA}
        Copy(zeile, 8, Length(zeile));
      srcname := Trim(Copy(zeile, 8, Length(zeile)));  {005C0332}
      ReadLn(gvar_02536670, zeile);  {005C0338: inline ReadLn}
      zsa(zeile, r);
      zeile := r;
      if UpperCase(Copy(zeile, 1, 6)) = '2 VERS' then
      begin
        header := header + Copy(zeile, 8, Length(zeile)) + ' ';  {CatN3 005C03B2}
        srcname := srcname + ' ' + Trim(Copy(zeile, 8, Length(zeile)));  {CatN3 005C0441}
      end;
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '1 DEST' then
      header := header + #13#10 + 'Ziel: ' +
        Copy(zeile, 8, Length(zeile));  {CatN4 005C04BB}
    if UpperCase(Copy(zeile, 1, 6)) = '1 NAME' then
    begin
      if Trim(Copy(zeile, 8, Length(zeile))) <> '' then
        header := header + #13#10 + 'Einsender: ' + #13#10 +
          Copy(zeile, 8, Length(zeile));  {CatN5 005C0572}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '2 ADR1' then
    begin
      if Trim(Copy(zeile, 8, Length(zeile))) <> '' then
        header := header + #13#10 + Copy(zeile, 8, Length(zeile));  {CatN3 005C061F}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '2 ADR2' then
    begin
      if Trim(Copy(zeile, 8, Length(zeile))) <> '' then
        header := header + #13#10 + Copy(zeile, 8, Length(zeile));  {CatN3 005C06CC}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '1 POST' then
    begin
      if Trim(Copy(zeile, 8, Length(zeile))) <> '' then
        header := header + #13#10 + Copy(zeile, 8, Length(zeile));  {CatN3 005C0779}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '1 CITY' then
    begin
      if Trim(Copy(zeile, 8, Length(zeile))) <> '' then
        header := header + ' ' + Copy(zeile, 8, Length(zeile));  {CatN3 005C0826}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '1 PHON' then
    begin
      if Trim(Copy(zeile, 8, Length(zeile))) <> '' then
        header := header + #13#10 + Copy(zeile, 8, Length(zeile));  {CatN3 005C08D3}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '1 EMAIL' then
    begin
      if Trim(Copy(zeile, 9, Length(zeile))) <> '' then
        header := header + #13#10 + Copy(zeile, 9, Length(zeile));  {CatN3 005C0980}
    end;
    if UpperCase(Copy(zeile, 1, 6)) = '1 GEDC' then
    begin
      header := header + 'GEDCOM: ' + #13#10;  {CatN3 005C09DA}
      ReadLn(gvar_02536670, zeile);  {005C09E7: inline ReadLn}
      zsa(zeile, r);
      zeile := r;
      if UpperCase(Copy(zeile, 1, 6)) = '2 VERS' then
        header := header + Copy(zeile, 8, Length(zeile)) + ' ';  {CatN3 005C0A8A}
      ReadLn(gvar_02536670, zeile);  {005C0A97: zus??tzlich, nach VERS}
      zsa(zeile, r);
      zeile := r;
      if UpperCase(Copy(zeile, 1, 6)) = '2 FORM' then
        header := header + Copy(zeile, 8, Length(zeile));  {LStrCat 005C0B2D}
    end;
    if Pos('1 PLAC', zeile) > 0 then
    begin
      ReadLn(gvar_02536670, zeile);  {005C0B4B: inline ReadLn}
      zsa(zeile, r);
      zeile := r;
      if Pos('2 FORM', zeile) > 0 then
        gvar_0253685C := Trim(Copy(zeile, 8, Length(zeile)));  {005C0BAA}
    end;
    if Pos('_EXTENDED_LOCATIONS', zeile) > 0 then
      header := header + #13#10 + 'Erweiterung: EXTENDED_LOCATIONS';  {CatN3 005C0BD5}
    if Pos('1 CHAR ', ucase(zeile)) > 0 then
    begin
      header := header + #13#10 + 'Zeichensatz: ' +
        Copy(zeile, 8, Length(zeile));  {CatN4 005C0C39}
      if Pos('1 CHAR IBM', ucase(zeile)) > 0 then
        gvar_02536848 := 'ibm';  {005C0C6A}
      if Pos('1 CHAR UTF', ucase(zeile)) > 0 then
        gvar_02536848 := 'utf';  {005C0C9B}
      if Pos('1 CHAR ANSI', ucase(zeile)) > 0 then
        gvar_02536848 := 'ansi';  {005C0CCC}
      if Pos('1 CHAR ANSEL', ucase(zeile)) > 0 then
        gvar_02536848 := 'ansel';  {005C0CFD}
      if Pos('1 CHAR UNIC', ucase(zeile)) > 0 then
        gvar_02536848 := 'unic';  {005C0D2E}
    end;
    { 005C0D33: '@ INDI'-Exits von oben }
  end;

  begin
    { Phase I (005C0DA0..005C2698): Objekte zählen und
      Stammerfassungs-Objekte (@S/@P/@N) importieren. }
    repeat  {005C26A8: Body 005C0DA0..}
      if Pos('@ INDI', zeile) > 0 then
      begin
        { 005C0DA0: @INDI-Einstieg. }
        inc(personCount);
        Form1.Label18.Caption := IntToStr(personCount);
        Form1.Label18.Refresh;
        gvar_02536870 := Copy(zeile, Pos('@ INDI', zeile) - 4, 4);  {005C0E05}
        Form1.Repso2.Append;
        Form1.Repso2nr.AsInteger := gvar_02536944 + personCount;  {005C0E22 [+0A8]}
        Form1.Repso2alt.AsString := gvar_02536870;  {005C0E2A [+0B0]}
        Form1.Repso2.Post;  {005C0E40}
      end
      else if Pos('0 @F', zeile) > 0 then
      begin
        { 005C0E69: Familienindex erhöhen. }
        inc(famCount);
        Form1.Label18.Caption := IntToStr(personCount + famCount);
        Form1.Label18.Refresh;
      end
      else if Pos('0 @S', zeile) > 0 then
      begin
        { 005C0EA9: Stammdaten-Objekt (@S) einlesen. }
        gvar_02536858 := 'SOUR0';
        gvar_02536850 := Trim(Copy(zeile, 3, 20));   {005C0F17 Copy(3,20)}
        gvar_02536850 := LeftStr(gvar_02536850,
          Length(gvar_02536850) - 5);  {005C0F15}
        ReadLn(gvar_02536670, zeile);  {005C0F2D}
        zsa(zeile, r);
        zeile := r;
        if gvar_02536650 = 1 then  {005C0F65 Utf8ToAnsi}
          zeile := Utf8ToAnsi(zeile);
        Form1.Repso2.IndexName := 'ih';  {005C0F81}
        if Form1.Repso2.FindKey([gvar_02536850]) then
        begin
          Form1.Repso2.Edit;
          Form1.Repso2inh2.AsString := Trim(Copy(zeile, 8, Length(zeile)));  {005C1005 [+0B0] [8D0]}
          Form1.Repso2.Post;
          sn1 := Form1.Repso2inh2.AsString;  {005C1021 GetAsString [+60]}
        end;
      end;

      if gvar_02536858 = 'SOUR0' then
      begin
        { 005C102E: Datenobjekt-Kopierer (Table38/index tit). }
        zsa(zeile, r);
        zeile := r;
        DataModule2.Table38.IndexName := 'tit';  {005C106F}
        if not DataModule2.Table38.FindKey([sn1]) then
        begin
          DataModule2.Table38.Append;
          DataModule2.Table38Titel.AsString := sn1;  {005C10BD [+0B0] [A18]}
          DataModule2.Table38.Post;
        end;
        if DataModule2.Table38.FindKey([sn1]) then
        begin
          if Pos('1 ABBR', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Abk.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C113F [A1C]}
            DataModule2.Table38.Post;
          end
          else if Pos('2 EVEN', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Ereig.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C11A6 [A20]}
            DataModule2.Table38.Post;
          end
          else if Pos('3 DATE', zeile) > 0 then
          begin
            if Pos('FROM', zeile) > 0 then
            begin
              if Pos('TO', zeile) > 0 then
              begin
                DataModule2.Table38.Edit;
                DataModule2.Table38Von.AsString :=
                  Copy(zeile, 13, Pos('TO', zeile) - 13);  {005C1292 [A24]}
                DataModule2.Table38.Post;
              end
              else
              begin
                DataModule2.Table38.Edit;
                DataModule2.Table38Von.AsString :=
                  Copy(zeile, 13, Length(zeile));  {005C1237 [A24]}
                DataModule2.Table38.Post;
              end;
            end;
            if Pos('TO', zeile) > 0 then
            begin
              DataModule2.Table38.Edit;
              DataModule2.Table38Bis.AsString :=
                Copy(zeile, Pos('TO', zeile) + 3, Length(zeile));  {005C1305 [A28]}
              DataModule2.Table38.Post;
            end;
          end
          else if Pos('3 PLAC', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Standort.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C136C [A2C]}
            DataModule2.Table38.Post;
          end
          else if Pos('1 PUBL', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Publ.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C13D3 [A30]}
            DataModule2.Table38.Post;
          end
          else if Pos('2 CALN', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Bestand.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C143A [A3C]}
            DataModule2.Table38.Post;
          end
          else if Pos('2 NOTE', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Bem.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C14A1 [A38]}
            DataModule2.Table38.Post;
          end
          else if Pos('3 CONC', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Bem.AsString :=
              DataModule2.Table38Bem.AsString +
              Copy(zeile, 8, Length(zeile));  {005C1522 [A38]}
            DataModule2.Table38.Post;
          end
          else if Pos('3 CONT', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Bem.AsString :=
              DataModule2.Table38Bem.AsString + #13 + #10 +
              Copy(zeile, 8, Length(zeile));  {005C15BC CatN4 [A38]}
            DataModule2.Table38.Post;
          end
          else if Pos('3 MEDI', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;
            DataModule2.Table38Med.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C1639 [A40]}
            DataModule2.Table38.Post;
          end
          else if Pos('AUTH', zeile) > 0 then
          begin
            DataModule2.Table38.Edit;  {005C1681}
            if Trim(DataModule2.Table38Bem.AsString) = '' then
              DataModule2.Table38Bem.AsString :=
                Copy(zeile, 8, Length(zeile))  {005C16D1}
            else
              DataModule2.Table38Bem.AsString :=
                DataModule2.Table38Bem.AsString + #13#10 +
                Copy(zeile, 8, Length(zeile));  {005C172A CatN4}
            DataModule2.Table38.Post;
          end;
        end;
      end;

      if Pos('1 SOUR @S', zeile) > 0 then
      begin
        { 005C1775: Quellenreferenz registrieren (Repso2/index ih). }
        gvar_02536858 := 'SOUR1';  {005C1780}
        Form1.Repso2.IndexName := 'ih';  {005C1792}
        if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 20))]) then
        begin
          Form1.Repso2.Append;
          Form1.Repso2nr.AsInteger := gvar_02536944 + personCount;  {005C1801}
          Form1.Repso2alt.AsString := gvar_02536870;  {005C181B [8D4]}
          Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 20));  {005C1861 [8CC]}
          Form1.Repso2.Post;
        end;
      end;
      if Pos('2 SOUR @S', zeile) > 0 then
      begin
        { 005C1896. }
        gvar_02536858 := 'SOUR2';
        Form1.Repso2.IndexName := 'ih';
        if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 20))]) then
        begin
          Form1.Repso2.Append;
          Form1.Repso2nr.AsInteger := gvar_02536944 + personCount;
          Form1.Repso2alt.AsString := gvar_02536870;
          Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 20));
          Form1.Repso2.Post;
        end;
      end;

      if Pos('2 PLAC', zeile) > 0 then  {005C19A8}
      begin
        if Pos(',', zeile) > 0 then
          tt := Copy(zeile, 8, Pos(',', zeile) - 8)  {005C19CA}
        else
          tt := Copy(zeile, 8, Length(zeile));  {005C19F2}
      end;
      if Pos('3 _LOC @P', zeile) > 0 then  {005C1A10}
      begin
        Form1.Repso2.IndexName := 'ih';
        if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 20))]) then
        begin
          Form1.Repso2.Append;
          Form1.Repso2nr.AsInteger := gvar_02536944 + personCount;  {005C1A94}
          Form1.Repso2alt.AsString := gvar_02536870;
          Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 20));
          Form1.Repso2inh2.AsString := tt;  {005C1B12 [8D0]}
          Form1.Repso2.Post;
        end;
      end;
      if Pos('0 @P', zeile) > 0 then  {005C1B38}
      begin
        gvar_02536858 := 'PL';
        tt := '';  {005C1B5C}
        gvar_02536850 := Trim(Copy(zeile, 3, 20));  {005C1B67}
        gvar_02536850 := LeftStr(gvar_02536850,
          Length(gvar_02536850) - 5);  {005C1BA1}
        ReadLn(gvar_02536670, zeile);  {005C1BD0}
        zsa(zeile, r);
        zeile := r;
        Form1.Repso2.IndexName := 'ih';  {005C1C0B}
        if Form1.Repso2.FindKey([gvar_02536850]) then
        begin
          Form1.Repso2.Edit;
          if Pos(',', zeile) > 0 then  {005C1C69}
            Form1.Repso2inh2.AsString :=
              Trim(Copy(zeile, 8, Pos(',', zeile) - 8))
          else
            Form1.Repso2inh2.AsString :=
              Trim(Copy(zeile, 8, Length(zeile)));
          Form1.Repso2.Post;
          tt := Form1.Repso2inh2.AsString;  {005C1D11 GetAsString}
        end;
        DataModule2.Table13.IndexName := 'ort_';  {005C1D24}
        if not DataModule2.Table13.FindKey([tt]) then
        begin
          DataModule2.Table13.Append;
          DataModule2.Table13Ort.AsString := tt;  {005C1D6F [A44]}
          DataModule2.Table13.Post;
        end;
      end;

      if gvar_02536858 = 'PL' then  {005C1D95}
      begin
        zsa(zeile, r);  {005C1DAA}
        zeile := r;
        DataModule2.Table13.IndexName := 'ort_';  {005C1DC9}
        if DataModule2.Table13.FindKey([tt]) then
        begin
          if Pos('1 _ABBR', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Abk.AsString :=
              Copy(zeile, 9, Length(zeile));  {005C1E47 [A68]}
            DataModule2.Table13.Post;
          end
          else if Pos('2 LATI', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Bg.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C1EAE [A70]}
            DataModule2.Table13.Post;
          end
          else if Pos('2 LONG', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Lg.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C1F15 [A6C]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 _FSTAE', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Bland.AsString :=
              Copy(zeile, 10, Length(zeile));  {005C1F7C [A58]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 _FCTRY', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Land.AsString :=
              Copy(zeile, 10, Length(zeile));  {005C1FE3 [A4C]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 _FCNTY', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Lkr.AsString :=
              Copy(zeile, 10, Length(zeile));  {005C204A [A64]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 _POST', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13PLZ.AsString :=
              Copy(zeile, 9, Length(zeile));  {005C20B1 [A48]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 _FPOST', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13PLZ.AsString :=
              Copy(zeile, 10, Length(zeile));  {005C2118 [A48]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 POST', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13PLZ.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C217F [A48]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 _MAIDENHEAD', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Maid.AsString :=
              Copy(zeile, 15, Length(zeile));  {005C21E6 [A74]}
            DataModule2.Table13.Post;
          end
          else if Pos('1 _GOV', zeile) > 0 then
          begin
            DataModule2.Table13.Edit;
            DataModule2.Table13Gov.AsString :=
              Copy(zeile, 8, Length(zeile));  {005C224A [A54]}
            DataModule2.Table13.Post;
          end;
        end;
      end;

      if Pos('0 @N', zeile) > 0 then  {005C2270}
      begin
        gvar_02536858 := '0note';
        Form1.Repso2.IndexName := 'ih';  {005C2294}
        if not Form1.Repso2.FindKey([Trim(Copy(zeile, 4, Length(zeile)))]) then
        begin
          Form1.Repso2.Append;
          Form1.Repso2nr.AsInteger := gvar_02536944 + personCount;  {005C2308}
          Form1.Repso2alt.AsString := gvar_02536870;
          Form1.Repso2inh.AsString := Trim(Copy(zeile, 4, Length(zeile)));
          Form1.Repso2.Post;
        end;
      end;
      if (Pos('1 CONT ', zeile) > 0) and (gvar_02536858 = '0note') then  {005C239B}
      begin
        Form1.Repso2.Edit;
        Form1.Repso2inh.AsString :=
          Form1.Repso2inh.AsString + #13#10 +
          Copy(zeile, 8, Length(zeile));  {005C2410 CatN3 [8CC]}
        Form1.Repso2.Post;
      end;
      if Pos('1 NOTE @N', zeile) > 0 then  {005C2446}
      begin
        Form1.Repso2.IndexName := 'ih';
        if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 20))]) then
        begin
          Form1.Repso2.Append;
          Form1.Repso2nr.AsInteger := gvar_02536944 + personCount;  {005C24CA}
          Form1.Repso2alt.AsString := gvar_02536870;
          Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 20));
          Form1.Repso2.Post;
        end;
      end;
      if Pos('2 NOTE @N', zeile) > 0 then  {005C2558}
      begin
        Form1.Repso2.IndexName := 'ih';
        if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 20))]) then
        begin
          Form1.Repso2.Append;
          Form1.Repso2nr.AsInteger := gvar_02536944 + personCount;  {005C25DC}
          Form1.Repso2alt.AsString := gvar_02536870;
          Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 20));
          Form1.Repso2.Post;
        end;
      end;

      ReadLn(gvar_02536670, zeile);  {005C266A: Loop-Tail}
    until (Pos('0 TRLR', zeile) > 0) or Eof(gvar_02536670);  {005C2686/Form 2699}

    { 005C26AE: Phase-I-Abschluss. }
    Form1.Label18.Visible := False;  {005C26AE [400]}
    header := header + #13#10 + #13#10 +
      IntToStr(personCount) + ' Personen' + #13#10 +
      IntToStr(famCount) + ' Familien';  {005C26BD CatN5+CatN4}
    Form1.Label19.Caption := header;  {005C271E [404]}
    Form1.Label19.Refresh;
    ShowMessage(header);  {005C273A}
    header := '';  {005C2742}
    gvar_0253684C := '';
    gvar_02536854 := '';
    Reset(gvar_02536670);  {005C275E}
    repeat
      ReadLn(gvar_02536670, zeile);  {005C276F}
    until Pos('@ INDI', zeile) > 0;  {005C278B}
    Form1.Label18.Visible := True;  {005C279C}
    Form1.Label18.Caption := '0 %';  {005C27AB}
    Form1.Label18.Refresh;
    Form1.Label19.Visible := True;  {005C27CA}
    Form1.Label19.Caption := 'Gedcom einlesen  ';  {005C27D9}
    Form1.Label19.Refresh;
    goto LPhase2;  {005C27F8 -> 005C47E5 -> 005C27FD}
  end;

  { Phase II (005C27FD..): Personen aus @INDI lesen und in Table1 schreiben,
    inklusive Namens-Kontrolle (SURN/GIVN/TYPE) }
  LPhase2:
  if Pos('@ INDI', zeile) > 0 then
  begin
    { 005C2812: @INDI-Einstieg. }
    inc(nummer);  {[ebp-18]}
    namIdx := 0;  {005C2817 [38]}
    alt84 := '';
    alt88 := '';
    Form1.Label18.Caption :=
      IntToStr(Round(zaeler / (personCount + famCount) * 100)) + ' %';  {005C2830-286A}
    Form1.Label18.Refresh;
    inc(zaeler);  {005C288F [-3C]}
    if (DataModule2.Table1.RecordCount = 1) and (nummer = 1) then
      DataModule2.Table1.Edit  {005C28A8}
    else
      DataModule2.Table1.Append;  {005C28B4}
    DataModule2.Table1Nummer.AsInteger := nummer;  {005C28C6 [-18]}
    DataModule2.Table1Vater.AsInteger := 0;  {005C28DB}
    DataModule2.Table1Mutter.AsInteger := 0;  {005C28EF}
    DataModule2.Table1Lebt.AsString := 'n';  {005C28FD [5B4]}
  end;
  if Pos('1 NAME', zeile) > 0 then
  begin
    { 005C291B. }
    gvar_02536858 := 'NAME';
    if Copy(zeile, 8, 1) <> '/' then  {005C2953}
    begin
      srcstr := Trim(zeile);
      if Length(srcstr) > 7 then  {005C296E}
        Nam(zeile, ptmp);  {005C297C erfassende Name-Zerlegung}
    end;
    inc(namIdx);  {005C2981}
  end;
  if Pos('ALIA', zeile) = 3 then  {005C2984}
  begin
    if Pos('@', zeile) > 0 then  {005C29A2}
    begin
      Form1.Repso2.IndexName := 'alt_';  {005C29AF}
      if Form1.Repso2.FindKey(
        [Trim(Copy(zeile, 9, Length(Trim(zeile)) - 9))]) then  {005C29C1}
      begin
        lastnr := Form1.Repso2nr.AsInteger;  {005C2A33 [+58]}
        srcKey := 'Diese Person k?nnte identisch sein mit Nr. ' +
          IntToStr(lastnr);  {005C2A4B CatN3}
        sub_005772E4(srcKey);  {005C2A67}
      end;
    end
    else
      sub_005772E4('Alias-Name: ' + Copy(zeile, 8, Length(zeile)));  {005C2A8C}
  end;
  if Pos('2 SURN', zeile) > 0 then  {005C2ABC}
  begin
    if namIdx = 1 then
      DataModule2.Table1Name.AsString := Copy(zeile, 8, Length(zeile))  {005C2AEE}
    else
      sub_005772E4('zu Name ' + IntToStr(namIdx) + ': ' +
        Copy(zeile, 8, Length(zeile)));  {005C2B4B CatN4}
    if Trim(Copy(zeile, 8, Length(zeile))) <>
       Trim(DataModule2.Table1Name.AsString) then  {005C2B8A-2BC1}
      sub_005772E4('"SURN"-Name stimmt nicht mit Name *berein.');  {005C2BC3}
  end;
  if Pos('2 GIVN', zeile) > 0 then  {005C2BE2}
  begin
    if namIdx = 1 then
      DataModule2.Table1Vornamen.AsString :=
        Copy(zeile, 8, Length(zeile))  {005C2C0E [544]}
    else
      sub_005772E4('zu Name ' + IntToStr(namIdx) + ': ' +
        Copy(zeile, 8, Length(zeile)));
    if Trim(Copy(zeile, 8, Length(zeile))) <>
       Trim(DataModule2.Table1Vornamen.AsString) then  {005C2CA5-2CE1}
      sub_005772E4('"GIVN"-Name stimmt nicht mit Vornamen *berein.');  {005C2CE3}
  end;
  if Pos('2 FONE', zeile) > 0 then  {005C2CFC}
    sub_005772E4('zu Name ' + IntToStr(namIdx) + ': ' +
      Copy(zeile, 8, Length(zeile)));
  if Pos('2 NICK', zeile) > 0 then  {005C2D6C}
    sub_005772E4('Spitzname: ' + Copy(zeile, 8, Length(zeile)));
  if Pos('2 NPFX', zeile) > 0 then  {005C2DBC}
    sub_005772E4('zu Name ' + IntToStr(namIdx) + ': ' +
      Copy(zeile, 8, Length(zeile)));
  if Pos('2 NSFX', zeile) > 0 then  {005C2E2A}
    sub_005772E4('zu Name ' + IntToStr(namIdx) + ': ' +
      Copy(zeile, 8, Length(zeile)));
  if Pos('2 SPFX', zeile) > 0 then  {005C2E98}
    sub_005772E4('zu Name ' + IntToStr(namIdx) + ': ' +
      Copy(zeile, 8, Length(zeile)));
  if Pos('2 ROMN', zeile) > 0 then  {005C2F06}
    sub_005772E4('zu Name ' + IntToStr(namIdx) + ': ' +
      Copy(zeile, 8, Length(zeile)));
  if gvar_02536858 = 'NAME' then  {005C2F63-2F72 Guardian (jne 005C352D)}
  begin
    if Copy(zeile, 8, 1) = '/' then  {005C2F91 (NAME-Zerlegung der 2. Zeile)}
    begin
      alt84 := Trim(Copy(zeile, Pos('/', zeile) + 1, 40));  {005C2FAA-2FD3}
      alt84 := Copy(alt84, 1, Length(alt84) - 1);  {005C2FDF-2FF6 keine Nach-'/-Zeilen'}
    end;
    if Pos('2 TYPE', zeile) > 0 then  {005C2FFD}
    begin
      if Pos('/', zeile) > 0 then  {005C3021}
      begin
        alt84 := Trim(Copy(zeile, Pos('/', zeile) + 1, 40));  {005C3023-3053}
        alt84 := Copy(alt84, 1, Length(alt84) - 1);  {005C306E}
      end;
      if Copy(zeile, 8, 3) = 'aka' then  {005C3084}
        sub_005772E4('auch bekannt als: ' + alt88 + ' ' + alt84)  {005C30A8 CatN4}
      else if Copy(zeile, 8, 5) = 'birth' then
        sub_005772E4('Geburtsname: ' + alt84)  {005C3104 CatN3}
      else if Copy(zeile, 8, 9) = 'immigrant' then
        sub_005772E4('Name nach Einwanderung: ' + alt88 + ' ' + alt84)  {005C3150}
      else if Copy(zeile, 8, 6) = 'maiden' then
        sub_005772E4('Name vor erster Ehe: ' + alt84)  {005C31AC}
      else if Copy(zeile, 8, 7) = 'married' then
        sub_005772E4('Ehename: ' + alt84)  {005C31F8}
      else if Copy(zeile, 8, 8) = 'adoption' then
        sub_005772E4('Adoptivname: ' + alt84)  {005C3244}
      else if Copy(zeile, 8, 7) = 'divorce' then
        sub_005772E4('Name nach Scheidung: ' + alt84)  {005C3290}
      else if Copy(zeile, 8, 9) = 'pseudonym' then
        sub_005772E4('Künstlername: ' + alt88 + ' ' + alt84)  {005C32DC}
      else if Copy(zeile, 8, 9) = 'religious' then
        sub_005772E4('Ordensname: ' + alt88 + ' ' + alt84)  {005C3338}
      else if Copy(zeile, 8, 7) = 'unified' then
        sub_005772E4('Stammname: ' + alt84)  {005C3394}
      else if Copy(zeile, 8, 7) = 'variant' then  {005C33DE}
      begin
        if Trim(DataModule2.Table1Namex.AsString) = '' then  {005C340F [5BC]}
          DataModule2.Table1Namex.AsString := alt84
        else
          DataModule2.Table1Namex.AsString :=
            DataModule2.Table1Namex.AsString + '; ' + alt84;  {005C344F CatN3}
      end
      else if Copy(zeile, 8, 6) = 'estate' then  {005C3498}
      begin
        if Trim(DataModule2.Table1Hausname.AsString) = '' then  {005C34C9 [5C8]}
          DataModule2.Table1Hausname.AsString := alt84
        else
          DataModule2.Table1Hausname.AsString :=
            DataModule2.Table1Hausname.AsString + '; ' + alt84;  {005C350D CatN3}
      end;
    end;
  end;
  if (gvar_02536858 = 'NAME') and (Pos('2 NOTE', zeile) > 0) then  {005C352D}
    sub_005772E4('Bem. zu Name ' + IntToStr(namIdx) + ': ' +
      Copy(zeile, 8, Length(zeile)));  {005C354F CatN4}
  if (gvar_02536858 = 'NAME') and (Pos('2 SOUR', zeile) > 0) then  {005C35AC}
    sub_005772E4('Quelle zu Name ' + IntToStr(namIdx) + ': ' +
      Copy(zeile, 8, Length(zeile)));  {005C35CE CatN4}

  { TODO C6: 1 SEX-Rest am 005C3640 ff. - Listing-Extrakt L3553..4302 }
  if Pos('1 SEX', zeile) > 0 then  {005C3640}
  begin
    srcstr := Trim(Copy(zeile, 7, Length(zeile)));  {005C3656}
    if Pos('Mm', srcstr) > 0 then  {005C3675}
      DataModule2.Table1Geschlecht.AsString := 'm'  {005C368B [548]}
    else if Pos('FfWw', srcstr) > 0 then  {005C36D2}
      DataModule2.Table1Geschlecht.AsString := 'w'  {005C36E8}
    else if Pos('Xx', srcstr) > 0 then  {005C372F}
      DataModule2.Table1Geschlecht.AsString := 'x'  {005C3745}
    else if Pos('Uu', srcstr) > 0 then  {005C3789}
      DataModule2.Table1Geschlecht.AsString := 'x';  {005C379F [548]}
  end;
  if Pos('2 _RUFN', zeile) > 0 then  {005C37BB}
  begin
    DataModule2.Table1Rufname.AsString := Copy(zeile, 12, Length(zeile));  {005C37EF [600]}    if Pos(gvar_0253685C,
      Trim(DataModule2.Table1Vornamen.AsString)) = 0 then  {005C3845}
      sub_005772E4(
        'Hinweis: Rufname ist nicht in "Vornamen" enthalten.');  {005C384E}
  end;
  if Pos('1 OCCU', zeile) > 0 then  {005C3867}
    DataModule2.Table1Beruf.AsString :=
      Copy(zeile, 8, Length(zeile));  {005C3897 [550]}
  if Pos('1 RELI', zeile) > 0 then  {005C38AC}
  begin
    if (Pos('röm', zeile) > 0) and (Pos('kath', zeile) > 0) then  {005C38BF}
      DataModule2.Table1Religion.AsString := 'rk'  {005C38DF [54C]}
    else
      DataModule2.Table1Religion.AsString :=
        Copy(zeile, 8, Length(zeile));  {005C3915 [54C]}
  end;
  if Pos('1 IDNO', zeile) > 0 then  {005C392A}
    DataModule2.Table1IDNR.AsString :=
      Copy(zeile, 8, Length(zeile));  {005C395A [5C0]}
  if Pos('1 BIRT', zeile) > 0 then  {005C396F}
  begin
    gvar_02536858 := 'BIRT';  {005C397B}
    goto LPhase2Tail;  {005C3980}
  end;
  if Pos('1 CHR', zeile) > 0 then  {005C3994}
  begin
    gvar_02536858 := 'BAPT';
    goto LPhase2Tail;
  end;
  if Pos('1 BAP', zeile) > 0 then  {005C399E}
  begin
    gvar_02536858 := 'BAPT';  {005C39B1}
    goto LPhase2Tail;
  end;
  if Pos('1 DEAT', zeile) > 0 then  {005C39CA}
  begin
    gvar_02536858 := 'DEAT';  {005C39D6}
    goto LPhase2Tail;
  end;
  if Pos('1 BURI', zeile) > 0 then  {005C39EF}
  begin
    gvar_02536858 := 'BURI';  {005C39FB}
    goto LPhase2Tail;
  end;
  if Pos('1 RESI', zeile) > 0 then  {005C3A14}
  begin
    gvar_02536858 := 'RESI';  {005C3A20}
    goto LPhase2Tail;
  end;
  if Pos('1 CHAN', zeile) > 0 then  {005C3A39}
  begin
    gvar_02536858 := 'CHAN';  {005C3A45}
    goto LPhase2Tail;
  end;
  if Pos('1 EMIG', zeile) > 0 then  {005C3A5E}
  begin
    gvar_02536858 := 'EMIG';  {005C3A6A}
    if Trim(Copy(zeile, 8, Length(zeile))) <> '' then  {005C3A9E}
      sub_005772E4(Copy(zeile, 8, Length(zeile)));  {005C3ACF}
    goto LPhase2Tail;
  end;
  if Pos('1 FAMS', zeile) > 0 then  {005C3AE8}
  begin
    sub_005BD88C(zeile, DataModule2.Table1Nummer.AsInteger);  {005C3AFC}
    goto LPhase2Tail;
  end;
  if Pos('1 FAMC', zeile) > 0 then  {005C3B15}
  begin
    sub_005BDAFC(zeile, DataModule2.Table1Nummer.AsInteger);  {005C3B29}
    goto LPhase2Tail;
  end;
  if (Pos('2 DATE BET', zeile) > 0) or (Pos('2 DATE FROM', zeile) > 0) or
     (Pos('2 DATE TO', zeile) > 0) then  {005C3B42-3B64}
  begin
    ddat := '';  {005C3B6A [-7C]}
    if gvar_02536858 = 'BIRT' then  {005C3B77}
      ddat := 'Geburt: '
    else if gvar_02536858 = 'BAPT' then  {005C3B92}
      ddat := 'Taufe: '
    else if gvar_02536858 = 'DEAT' then  {005C3BB2}
      ddat := 'Tod: '
    else if gvar_02536858 = 'BURI' then  {005C3BD2}
      ddat := 'Bestatt.: ';
    if Pos('BET', zeile) > 0 then  {005C3BFF}
    begin
      sub_005772E4(ddat + ' zwischen ' +
        Copy(zeile, 11, Pos('AND', zeile) - 12) + ' und ' +
        Copy(zeile, Pos('AND', zeile) + 4, 20));  {005C3C7A CatN5}
      goto LPhase2Tail;
    end
    else if Pos('FROM', zeile) > 0 then  {005C3C99}
    begin
      if Pos('TO', zeile) > 0 then  {005C3CAE}
      begin
        sub_005772E4(ddat + 'von ' +
          Copy(zeile, 12, Pos('TO', zeile) - 13) + ' bis ' +
          Copy(zeile, Pos('TO', zeile) + 3, 20));  {005C3D29 CatN5}
        goto LPhase2Tail;
      end;
      sub_005772E4(ddat + 'ab ' + Copy(zeile, 12, 20));  {005C3D70 CatN3}
      goto LPhase2Tail;
    end;
    if Pos('TO', zeile) > 0 then  {005C3D8F}
    begin
      DataModule2.Table1Kommentar.AsString :=
        TrimRight(DataModule2.Table1Kommentar.AsString) + ptmp + ddat +
        'bis ' + Copy(zeile, 10, 20);  {005C3DF4 CatN5 [5B0]}
      goto LPhase2Tail;
    end;
  end;
  if Pos('2 DATE', zeile) > 0 then  {005C3E23}
  begin
    sub_005BE4B8(zeile);  {005C3E28}
    goto LPhase2Tail;
  end;
  if Pos('2 PLAC', zeile) > 0 then  {005C3E41}
  begin
    sub_005BEF5C(zeile);  {005C3E46}
    goto LPhase2Tail;
  end;
  if Pos('2 CAUS', zeile) > 0 then  {005C3E5F}
  begin
    sub_005BE418(zeile);  {005C3E64}
    goto LPhase2Tail;
  end;
  if (Pos('2 _GODP', zeile) > 0) or (Pos('2 GODP', zeile) > 0) then  {005C3E7D-3EAA}
  begin
    gvar_02536858 := 'BAPT';
    sub_005BD73C(zeile);  {005C3E91}
    goto LPhase2Tail;
  end;
  if Pos('3 AGE', zeile) > 0 then  {005C3ED7}
  begin
    sub_005BE340(zeile);  {005C3EDC}
    goto LPhase2Tail;
  end;
  if Pos('1 NOTE', zeile) > 0 then  {005C3EF5}
  begin
    sub_005BDCA0(zeile);  {005C3EFA}
    goto LPhase2Tail;
  end;
  if Pos('2 CONT', zeile) > 0 then  {005C3F13}
  begin
    sub_005BE104(zeile);  {005C3F18}
    goto LPhase2Tail;
  end;
  if Pos('CONC', zeile) > 0 then  {005C3F31}
  begin
    sub_005BE054(zeile);  {005C3F36}
    goto LPhase2Tail;
  end;
  if Pos('1 SOUR', zeile) > 0 then  {005C3F4F}
  begin
    if Pos('@', zeile) > 0 then  {005C3F64}
    begin
      DataModule2.Table1Quelle.AsString :=
        Trim(Copy(zeile, 8, Length(zeile)));  {005C3FA9 [5FC]}
      if not DataModule2.Table38.FindKey(
        [Trim(Copy(zeile, 8, Length(zeile)))]) then  {005C4001}
      begin
        DataModule2.Table38.Append;
        DataModule2.Table38Titel.AsString :=
          Trim(Copy(zeile, 8, Length(zeile)));  {005C405A [A18]}
        DataModule2.Table38.Post;
      end;
    end;
    goto LPhase2Tail;
  end;
  if Pos('2 EMAIL', zeile) > 0 then  {005C4084}
  begin
    DataModule2.Table1Ema.AsString :=
      Trim(Copy(zeile, 9, Length(zeile)));  {005C40C5 [5F4]}
    goto LPhase2Tail;
  end;
  if Pos('1 EMAIL', zeile) > 0 then  {005C40DF}
  begin
    DataModule2.Table1Ema.AsString :=
      Trim(Copy(zeile, 9, Length(zeile)));  {005C4120 [5F4]}
    goto LPhase2Tail;
  end;
  if Pos('1 EMA', zeile) > 0 then  {005C413A}
  begin
    DataModule2.Table1Ema.AsString :=
      Trim(Copy(zeile, 7, Length(zeile)));  {005C417B [5F4]}
    goto LPhase2Tail;
  end;
  if (Pos('2 PHON', zeile) > 0) or (Pos('1 PHON', zeile) > 0) then  {005C4195-41A6}
  begin
    DataModule2.Table1Tel.AsString :=
      Trim(Copy(zeile, 8, 20));  {005C41E2 [5F0]}
    goto LPhase2Tail;
  end;
  if Pos('1 URL', zeile) > 0 then  {005C41FC}
  begin
    DataModule2.Table1Ur.AsString :=
      Trim(Copy(zeile, 7, Length(zeile)));  {005C423D [5F8]}
    goto LPhase2Tail;
  end;
  if Pos('1 WWW', zeile) > 0 then  {005C4257}
  begin
    DataModule2.Table1Ur.AsString :=
      Trim(Copy(zeile, 7, Length(zeile)));  {005C4298 [5F8]}
    goto LPhase2Tail;
  end;
  if Pos('1 ADDR', zeile) > 0 then  {005C42B2}
  begin
    gvar_02536858 := 'ADDR';  {005C42BE}
    goto LPhase2Tail;
  end;
  if Pos('ADR1', zeile) > 0 then  {005C42D7}
  begin
    DataModule2.Table1Adr1.AsString :=
      Trim(Copy(zeile, 7, Length(zeile)));  {005C4318 [5CC]}
    goto LPhase2Tail;
  end;
  if Pos('ADR2', zeile) > 0 then  {005C4332}
  begin
    DataModule2.Table1Adr2.AsString :=
      Trim(Copy(zeile, 7, Length(zeile)));  {005C4373 [5D0]}
    goto LPhase2Tail;
  end;
  if Pos('ADR3', zeile) > 0 then  {005C438D}
  begin
    if Pos('AHNENWIN 4', ptmp) > 0 then  {005C43A5 [-0A0]}
    begin
      DataModule2.Table1PLZ.AsString :=
        Trim(Copy(zeile, 7, Length(zeile)));  {005C43E6 [5D4]}
    end
    else
    begin
      DataModule2.Table1Adrzus.AsString :=
        Trim(Copy(zeile, 7, Length(zeile)));  {005C4430 [5DC]}
    end;
    goto LPhase2Tail;
  end;
  if Pos('ADR4', zeile) > 0 then  {005C444A}
  begin
    if Pos('AHNENWIN 4', ptmp) > 0 then  {005C445E}
    begin
      DataModule2.Table1Ort.AsString :=
        Trim(Copy(zeile, 7, Length(zeile)));  {005C44A3 [5D8]}
    end;
    goto LPhase2Tail;
  end;
  if Pos('ADR5', zeile) > 0 then  {005C44BD}
  begin
    if Pos('AHNENWIN 4', ptmp) > 0 then  {005C44D1}
    begin
      DataModule2.Table1Ort.AsString :=
        Trim(Copy(zeile, 7, Length(zeile)));  {005C4516 [5DC]}
    end;
    goto LPhase2Tail;
  end;
  if Pos('CITY', zeile) > 0 then  {005C4530}
  begin
    DataModule2.Table1Ort.AsString :=
      Trim(Copy(zeile, 7, Length(zeile)));  {005C4571 [5D8]}
    goto LPhase2Tail;
  end;
  if Pos('POST', zeile) > 0 then  {005C458B}
  begin
    DataModule2.Table1PLZ.AsString :=
      Trim(Copy(zeile, 7, Length(zeile)));  {005C45CC [5D4]}
    goto LPhase2Tail;
  end;
  if Pos('1 SOUR @', zeile) > 0 then  {005C45E6}
  begin
    gvar_02536850 := '';  {005C45F0 LStrClr}
    Form1.Repso2.IndexName := 'ih';  {005C4603}
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 8, Length(zeile)))]) then  {005C465C}
      gvar_02536850 := Form1.Repso2inh2.AsString;  {005C4684 [8D0]}
    if Pos(gvar_02536850,
      DataModule2.Table1Quelle.AsString) = 0 then  {005C46A7}
    begin
      if Length(Trim(DataModule2.Table1Quelle.AsString)) > 0
        then  {005C46DF jbe-4748}
      begin
        DataModule2.Table1.Edit;  {005C46E6}
        DataModule2.Table1Quelle.AsString :=
          Trim(DataModule2.Table1Quelle.AsString + '; ' +
            gvar_02536850);  {005C4740 CatN3}
      end
      else
      begin
        DataModule2.Table1.Edit;  {005C474D}
        DataModule2.Table1Quelle.AsString :=
          gvar_02536850;  {005C4762}
      end;
    end;
    goto LPhase2Tail;
  end;
  if Pos('2 SOUR @', zeile) > 0 then  {005C4779}
  begin
    sour(zeile);  {005C4781}
    goto LPhase2Tail;
  end;

  LPhase2Tail:
  ReadLn(gvar_02536670, zeile);  {005C478E/005C4793}
  if Pos('0 @F', zeile) > 0 then  {005C47A2}
    goto LPhase3;  {005C47B1 -> 005C47FC}
  if Eof(gvar_02536670) then  {005C47B3}
    goto LPhase3;  {005C47C4 -> 005C47FC}
  zsa(zeile, ptmp);  {005C47D2}
  zeile := ptmp;  {005C47E0}
  if not Eof(gvar_02536670) then  {005C47EA}
    goto LPhase2;  {005C47F6 -> 005C27FD}

  LPhase3:
  { TODO C7: fsc-Auswertung 005C47FC..005C52D2 - Listing-Extrakt L4643..5444 }
  DataModule2.Table5.IndexName := 'fnr';  {005C4806}
  DataModule2.Table5.First;  {005C4810}
  DataModule2.Table5.Open;  {005C481D [80]}
  while not DataModule2.Table5.Eof do  {005C4949/4955 loop}
  begin
    if (DataModule2.Table5.FieldByName('v').AsInteger > 0) and
      (DataModule2.Table5.FieldByName('m').AsInteger > 0) then  {005C4836-4859}
    begin
      DataModule2.Table5.Append;  {005C4867}
      DataModule2.Table5Nummer.AsInteger :=
        DataModule2.Table5.FieldByName('v').AsInteger;  {005C488C [410]}
      DataModule2.Table5Epnum.AsInteger :=
        DataModule2.Table5.FieldByName('m').AsInteger;  {005C48B2 [414]}
      DataModule2.Table5.Post;  {005C48C2}
      DataModule2.Table5.Append;  {005C48D0}
      DataModule2.Table5Nummer.AsInteger :=
        DataModule2.Table5.FieldByName('m').AsInteger;  {005C48F5 [410]}
      DataModule2.Table5Epnum.AsInteger :=
        DataModule2.Table5.FieldByName('v').AsInteger;  {005C491B [414]}
      DataModule2.Table5.Post;  {005C492B}
    end;
    DataModule2.Table5.Next;  {005C4936}
  end;
  DataModule2.Table5.First;  {005C4960}
  while not DataModule2.Table5.Eof do  {005C4AF3/4AFF loop}
  begin
    if Length(Trim(DataModule2.Table5.FieldByName('k').AsString)) > 0 then  {005C499C}
    begin
      if Length(Trim(DataModule2.Table5.FieldByName('k').AsString)) div 6 > 0 then  {005C49D8-49F1}
      begin
        iii := Length(Trim(DataModule2.Table5.FieldByName('k').AsString)) div 6;  {005C49F7 [-0A8]}
        kIdx := 1;  {005C49FD [-1C]}
        repeat  {005C4A04 loop-head}
          DataModule2.Table1.FindKey([
            StrToInt(Copy(DataModule2.Table5.FieldByName('k').AsString,
              (kIdx - 1) * 6 + 1, 6))]);  {005C4A64}
          DataModule2.Table1.Edit;  {005C4A6E}
          DataModule2.Table1Vater.AsInteger :=
            DataModule2.Table5.FieldByName('v').AsInteger;  {005C4A93 [538]}
          DataModule2.Table1Mutter.AsInteger :=
            DataModule2.Table5.FieldByName('m').AsInteger;  {005C4AB9 [53C]}
          DataModule2.Table1.Post;  {005C4AC6}
          Inc(kIdx);  {005C4ACC}
          Dec(iii);  {005C4ACF}
        until iii = 0;
      end;
    end;
    DataModule2.Table5.Next;  {005C4AE0}
  end;
  DataModule2.Table5.MasterSource := nil;  {005C4B0F [80]}
  DataModule2.Table5.IndexName := 'num';  {005C4B21}
  famIdx := 0;  {005C4B28 [-34]}
  married := 1;  {005C4B2B [-30]}
  childCount := 0;  {005C4B34 [-20]}
  while not Eof(gvar_02536670) do  {005C52BB/52CC loop}
  begin
    if Pos('0 @F', zeile) > 0 then  {005C4B44}
    begin
      if (famIdx > 0) and (husn > 0) and (wifn > 0) then  {005C4B55-4B61}
        sub_005BC604(husn, wifn, relN, married, m2hnd, m1hnd, m1dat, m1ort,
          m2hnd2, m2dat, m2ort, m1ort2, m2wit, m2wit2, sav2);  {005C4B9C push-order 30,68,6C,...,78}
      Inc(famIdx);  {005C4BA1}
      gvar_02536858 := 'MARR';  {005C4BAE}
      husn := 0;  {005C4BB5 [-24]}
      wifn := 0;  {005C4BBA [-28]}
      relN := 1;  {005C4BBD [-2C]}
      m1dat := '';  {005C4BC7 [-50]}
      m2dat := '';  {005C4BCF [-5C]}
      m2hnd := '';  {005C4BD7 [-68]}
      m1ort := '';  {005C4BDF [-54]}
      m2ort := '';  {005C4BE7 [-60]}
      m1hnd := '';  {005C4BEF [-6C]}
      m2hnd2 := '';  {005C4BF7 [-58]}
      m1ort2 := '';  {005C4BFF [-64]}
      m2wit := '';  {005C4C07 [-70]}
      m2wit2 := '';  {005C4C0F [-74]}
      sav2 := '';  {005C4C17 [-78]}
      Form1.Label18.Caption :=
        IntToStr(Round((zaeler / (personCount + famCount)) * 100)) + ' %';  {005C4C3E}
      Form1.Label18.Refresh;  {005C4C76 [400]}
      Inc(zaeler);  {005C4C7B}
    end;
    if Pos('1 DIV', zeile) > 0 then  {005C4C8D}
      gvar_02536858 := 'DIV';  {005C4C99}
    if Pos('1 HUSB', zeile) > 0 then  {005C4CAD}
    begin
      husn := 0;  {005C4CB5 [-24]}
      Form1.Repso2.IndexName := 'alt_';  {005C4CF7}
      if Form1.Repso2.FindKey([
        Copy(zeile, 9, Length(Trim(zeile)) - 9)]) then  {005C4D21}
        husn := Form1.Repso2nr.AsInteger;  {005C4D3C}
    end;
    if Pos('1 WIFE', zeile) > 0 then  {005C4D53}
    begin
      if husn > 0 then  {005C4D5D}
      begin
        wifn := 0;  {005C4D65 [-28]}
        Form1.Repso2.IndexName := 'alt_';  {005C4DA7}
        if Form1.Repso2.FindKey([
          Copy(zeile, 9, Length(Trim(zeile)) - 9)]) then  {005C4DD1}
          wifn := Form1.Repso2nr.AsInteger;  {005C4DEC}
      end;
    end;
    if Pos('1 CHIL', zeile) > 0 then  {005C4E03}
    begin
      Inc(childCount);  {005C4E09 [-20]}
      Form1.Repso2.IndexName := 'alt_';  {005C4E19}
      if Form1.Repso2.FindKey([
        Copy(zeile, 9, Length(Trim(zeile)) - 9)]) then  {005C4E75}
      begin
        DataModule2.Table1.FindKey([Form1.Repso2nr.AsInteger]);  {005C4EAA}
        DataModule2.Table1.Edit;  {005C4EB4}
        if husn > 0 then  {005C4EBD}
          DataModule2.Table1Vater.AsInteger := husn;  {005C4ECC}
        if wifn > 0 then  {005C4ED6}
          DataModule2.Table1Mutter.AsInteger := wifn;  {005C4EE5}
        DataModule2.Table1Indj.AsString :=
          RightStr(IntToStr(childCount), 4);  {005C4F1D [5E0]}
        DataModule2.Table1.Post;  {005C4F2C}
      end;
    end;
    if Pos('2 TYPE RELI', zeile) > 0 then  {005C4F46}
      relN := 1;  {005C4F48 [-2C]}
    if Pos('2 TYPE CIVIL', zeile) > 0 then  {005C4F63}
      relN := 2;  {005C4F65}
    if Pos('2 DATE', zeile) > 0 then  {005C4F80}
    begin
      if gvar_02536858 = 'MARR' then  {005C4F91}
      begin
        if relN = 1 then  {005C4F97}
          m1dat := zeile  {005C4F9F [-50]}
        else if relN = 2 then  {005C4FAD}
          m2dat := zeile;  {005C4FB9 [-5C]}
      end
      else if gvar_02536858 = 'DIV' then  {005C4FD2}
        m2hnd := zeile;  {005C4FDE [-68]}
    end;
    if Pos('2 PLAC', zeile) > 0 then  {005C4FF7}
    begin
      if gvar_02536858 = 'MARR' then  {005C5008}
      begin
        if relN = 1 then  {005C500E}
          m1ort := zeile  {005C5016 [-54]}
        else if relN = 2 then  {005C5024}
          m2ort := zeile;  {005C5030 [-60]}
      end
      else if gvar_02536858 = 'DIV' then  {005C5049}
        m1hnd := zeile;  {005C5055 [-6C]}
    end;
    if Pos('2 _WITN', zeile) > 0 then  {005C506E}
    begin
      if relN = 1 then  {005C5078}
      begin
        if Length(Trim(m2hnd2)) > 0 then  {005C508F}
          m2hnd2 := zeile + ', ' + m2hnd2  {005C50A4 CatN3 [-58]}
        else
          m2hnd2 := zeile;  {005C50B4}
      end
      else if relN = 2 then  {005C50C2}
      begin
        if Length(Trim(m1ort2)) > 0 then  {005C50DD}
          m1ort2 := zeile + ', ' + m1ort2  {005C50ED CatN3 [-64]}
        else
          m1ort2 := zeile;  {005C5102}
      end;
    end;
    if Pos('2 SOUR', zeile) > 0 then  {005C511B}
    begin
      if gvar_02536858 = 'MARR' then  {005C512C}
      begin
        if relN = 1 then  {005C5132}
          m2wit := zeile  {005C513A [-70]}
        else if relN = 2 then  {005C5148}
          m2wit2 := zeile;  {005C5154 [-74]}
      end
      else if gvar_02536858 = 'DIV' then  {005C516D}
        sav2 := zeile;  {005C5179 [-78]}
    end;
    if Pos('1 MARRIED', zeile) > 0 then  {005C5192}
    begin
      if Pos('1 _STAT NOT MARRIED', zeile) > 0 then  {005C51A3}
        married := 0  {005C51A7 [-30]}
      else if Pos('1 _STAT MARRIED', zeile) > 0 then  {005C51BB}
        married := 1;  {005C51BD}
    end;
    if Pos('1 _STAT NOT MARRIED', zeile) > 0 then  {005C51D5}
      married := 0;  {005C51D9}
    if Pos('1 _STAT MARRIED', zeile) > 0 then  {005C51ED}
      married := 1;  {005C51EF}
    if Pos('2 NOTE not marr', zeile) > 0 then  {005C5207}
      married := 0;  {005C520B}
    ReadLn(gvar_02536670, zeile);  {005C5216/005C5220}
    zsa(zeile, ptmp);  {005C5236}
    zeile := ptmp;  {005C5244}
    if (Pos('0 @', zeile) > 0) and (Pos('@F', zeile) > 0) and  {005C5249/525A}
      (famIdx > 0) and (husn > 0) and (wifn > 0) then  {005C526B-527B}
      sub_005BC604(husn, wifn, relN, married, m2hnd, m1hnd, m1dat, m1ort,
        m2hnd2, m2dat, m2ort, m1ort2, m2wit, m2wit2, sav2);  {005C52B6}
  end;

  LPhase3Tail:
  CloseFile(gvar_02536670);  {005C52D7}
  Form1.Label18.Hide;  {005C52E9 [400]}
  Form1.Label19.Hide;  {005C52F6 [404]}
  DataModule2.Table5.MasterSource := nil;  {005C4B0F-recon-prec}
  DataModule2.Table1.EnableControls;  {005C5312 [5C]}
  DataModule2.Table5.EnableControls;  {005C531F [80]}
  DataModule2.Table1.IndexName := '';  {005C532B}
  DataModule2.Table1.First;  {005C5335}
  if startnr > 0 then  {005C533E [-0C]}
    DataModule2.Table1.FindKey([startnr]);  {005C535D}
  Screen.Cursor := crDefault;  {005C536B}
  DataModule2.Table5.Close;  {005C5375}
  DataModule2.Table5.DeleteTable;  {005C537F}
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
var
  krg: Integer;
  u, st1, st2, st3, st4, st5: AnsiString;
  uLoc: AnsiString;         {C6: [ebp-18] Copy-Slot st1 / [ebp-978] Table38N-Extrakt}
  stVon: AnsiString;        {C6: [ebp-24] FROM/TO-Zeitraum-String}
  jahr, monat, tag: AnsiString;
  personNr, proz: Integer;
  uNr: Integer;
  bmk: Integer;             {vtbl+150 GetBookmark - Recon-Stub -1}
  cmzCount: Integer;        {Form1.Memo1-Lines-Loop-Index (Original [esi])}
  edi: Integer;             {NOTES-Merker (erstr. '1 NOTE' / folg. '2 CONT')}
  famI: Integer;            {FAMS/FAM/FAMC-Loop-Index (Original [esi])}
  u6: AnsiString;           {00576EB0-Ergebnis 6-stellige Nummer, Vergleich}
  childCount: Integer;      {Anzahl Kinder im Paar-Eintrag [ebp-34]}
  childIdx: Integer;        {CHIL-Loop-Index, [ebp-0C] personNr-Slot-Reuse}
  komFeld: TField;          {FieldByName('kommentar') per recon}
begin
  { 005B5224: GEDCOM-Export "v" (GEDCOM 5.5.1) - stellt alle Daten der
    geöffneten Datenbank als GED-Datei neu zusammen (Aufruf nach
    Reparatur/Export). Chunk C1: Quellenmonster-String
    gvar_0253665C ('qu'-Indexlauf über Table24), Export-Datei öffnen
    (SaveDialog1, Rewrite), 0 HEAD-Block inkl. BOM/CHAR-Variante
    (Form27 RadioButtons), SOUR/DEST/GEDC/PLAC-Kopfzeilen,
    '1 DATE '-Zeile über sub_00582C24 (Datum der Übersetzung),
    '1 FILE '-Zeile und die @S0@ SUBM-Blöcke mit dem Inhalt der
    Form27-Edits (im Unicode-Zweig via AnsiToUtf8). C2: INDIVIDUAL-Record-
    Kopf; C3: SEX/OCCU/RELI/IDNO/SOUR/BIRT/CHR/_GODP/DEAT/CAUS/BURI/RESI/
    NOTES; C4: FAMS/FAMC-Loops, 0 @F-Records, CHIL; C5: Paar-Positionierung,
    MARR/DIV/(CIVIL/RELI)/not-marr. C6: PLAC-Ref-Export (@P _LOC-Records aus
    st1), SOUR-Section (@S-Records aus st3 ueber Table38 'tit', Konkordat
    245er-Blaetterung der Bemerkung), 0 TRLR/Closing (Recon-Stub), Freel +
    UI-Reset und Neupositionierung auf den Start-Personendatensatz. }
  krg := DataModule2.Table1Nummer.AsInteger;                  {005B5274}
  Form26.Hide;                                               {005B5281}
  Form26.ModalResult := 2;                                   {005B528D}
  gvar_0253665C := '';                                       {005B5299}
  st1 := '';                                                   {005B5252..5265 LStrClr [ebp-14/-1C/-28]}
  st2 := '';
  st3 := '';
  DataModule2.Table29.IndexName := 'qu';                     {005B52AB}
  DataModule2.Table24.First;                                 {005B52B8}
  while not DataModule2.Table24.Eof do                       {005B5308 Rückkante}
  begin
    sub_00576EB0(DataModule2.Table24Nummer.AsInteger, u);    {005B52D1}
    gvar_0253665C := gvar_0253665C + u + '*';                {005B52BD CatN3}
    DataModule2.Table24.Next;                                {005B52F2}
  end;
  st4 := Form1.SaveDialog1.FileName;                         {005B5323 GetFileName +3FC}
  System.Assign(gvar_02536458, st4);                         {005B5336 Assign Dateivariable}
  Form1.SaveDialog1.Title := 'ged';                            {005B5350 vtbl+60}
  Form1.SaveDialog1.Filter := 'Gedcom-Dateien (*.ged)|*.ged';   {005B536A vtbl+74}
  Form1.SaveDialog1.FilterIndex := 2;                          {005B5382 dword +5C = 2}
  Rewrite(gvar_02536458);                                    {005B538A RewritText + IOTest}
  if Form27.RadioButton2.Checked then                        {005B53A3 UTF-8 -> BOM}
    WriteLn(gvar_02536458, #$EF#$BB#$BF'0 HEAD')             {005B53AD 5BBD30}
  else
    WriteLn(gvar_02536458, '0 HEAD');                        {005B53C8 5BBD44}
  gvar_02536654 := 0;                                        {005B53E1}
  gvar_02536650 := 0;                                        {005B53EA}
  gvar_02536658 := 0;                                        {005B53EF}
  if Form27.RadioButton1.Checked then                        {005B5403 ANSI}
  begin
    gvar_02536654 := 1;                                      {005B540F}
    WriteLn(gvar_02536458, '1 CHAR ANSI');                   {005B5419}
  end
  else if Form27.RadioButton2.Checked then                   {005B5441}
  begin
    gvar_02536650 := 1;                                      {005B544D}
    WriteLn(gvar_02536458, '1 CHAR UTF-8');                  {005B5457}
  end
  else if Form27.RadioButton3.Checked then                   {005B547F}
  begin
    gvar_02536650 := 1;                                      {005B548B}
    WriteLn(gvar_02536458, '1 CHAR Unicode');                {005B5495}
  end;
  WriteLn(gvar_02536458, '1 SOUR AHNENWIN');                 {005B54AE}
  WriteLn(gvar_02536458, '2 VERS 5.1');                      {005B54C7}
  WriteLn(gvar_02536458, '1 DEST OTHER');                    {005B54E0}
  st4 := DateToStr(Date);                                    {005B5501/ Jefferson}
  jahr := Copy(st4, 7, 4);                                     {005B5522}
  st5 := DateToStr(Date);                                    {005B552F}
  monat := Copy(st5, 4, 2);                                    {005B5550}
  st4 := DateToStr(Date);                                    {005B555D}
  tag := Copy(st4, 1, 2);                                      {005B557E}
  u := '1 DATE ' + sub_00582C24(tag, monat, jahr);           {005B5583/5590 CatN3}
  WriteLn(gvar_02536458, u);                                 {005B55A5}
  if gvar_02536650 = 1 then                                  {005B55BB}
    WriteLn(gvar_02536458, '1 FILE ' +                       {005B55F3 CatN3}
      AnsiToUtf8(ExtractFileName(Form1.SaveDialog1.FileName)))
  else
    WriteLn(gvar_02536458, '1 FILE ' +                       {005B563C CatN3}
      ExtractFileName(Form1.SaveDialog1.FileName));
  WriteLn(gvar_02536458, '1 SUBM @S0@');                     {005B5658}
  WriteLn(gvar_02536458, '1 GEDC');                          {005B5671}
  WriteLn(gvar_02536458, '2 VERS 5.5.1');                    {005B568A}
  WriteLn(gvar_02536458, '2 FORM LINEAGE-LINKED');           {005B56A3}
  WriteLn(gvar_02536458, '1 PLAC');                          {005B56BC}
  WriteLn(gvar_02536458, '2 FORM place, county, state, country'); {005B56D5}
  if gvar_02536650 = 1 then                                  {005B56EE}
  begin
    WriteLn(gvar_02536458, '1 LANG German');                 {005B56FB}
    if Trim(Form27.Edit1.Text) = '' then                     {005B5714..0734}
      { kein Adressblock, nur "0 @S0@ SUBM" + "1 NAME UNKNOWN" }
    begin
      WriteLn(gvar_02536458, AnsiToUtf8('0 @S0@ SUBM'));     {005B5A9A 5B5754}
      WriteLn(gvar_02536458, '1 NAME UNKNOWN');              {005B5AB3}
    end
    else
    begin
      WriteLn(gvar_02536458, AnsiToUtf8('0 @S0@ SUBM'));     {005B5744}
      WriteLn(gvar_02536458, '1 ADDR');                      {005B5768}
      WriteLn(gvar_02536458, '2 ADR1 ' +                     {005B57BB CatN3}
        AnsiToUtf8(Form27.Edit1.Text));
      if Trim(Form27.Edit2.Text) <> '' then                  {005B57E0..080A}
        WriteLn(gvar_02536458, '2 ADR2 ' +                   {005B5841 cat}
          AnsiToUtf8(Form27.Edit2.Text));
      if Trim(Form27.Edit3.Text) <> '' then                  {005B586B..895 vtbl+30C}
        WriteLn(gvar_02536458, '1 POST ' +                   {005B58CC cat}
          AnsiToUtf8(Form27.Edit3.Text));
      if Trim(Form27.Edit5.Text) <> '' then                  {005B58F6..920 vtbl+340 City}
        WriteLn(gvar_02536458, '1 CITY ' +                   {005B5957 cat}
          AnsiToUtf8(Form27.Edit5.Text));
      if Trim(Form27.Edit4.Text) <> '' then                  {005B5981..9AB vtbl+310 Phon}
        WriteLn(gvar_02536458, '1 PHON ' +                   {005B59E7 cat}
          AnsiToUtf8(Form27.Edit4.Text));
      if Trim(Form27.Edit6.Text) <> '' then                  {005B5A0C..A36 vtbl+348 Email}
        WriteLn(gvar_02536458, '1 EMAIL ' +                  {005B5A71 cat}
          AnsiToUtf8(Form27.Edit6.Text));
    end;
  end
  else
  begin
    WriteLn(gvar_02536458, '1 LANG German');                 {005B5AD1}
    if Trim(Form27.Edit1.Text) <> '' then                    {005B5AEA..B1A vtbl+304}
    begin
      WriteLn(gvar_02536458, '0 @S0@ SUBM');                 {005B5B20}
      WriteLn(gvar_02536458, '1 ADDR');                      {005B5B39}
      WriteLn(gvar_02536458, '2 ADR1 ' + Form27.Edit1.Text); {005B5B76 cat}
      if Trim(Form27.Edit2.Text) <> '' then                  {005B5BA0..5BCA}
        WriteLn(gvar_02536458, '2 ADR2 ' + Form27.Edit2.Text); {005B5BF0 cat}
      if Trim(Form27.Edit3.Text) <> '' then                  {005B5C2C..5C44}
        WriteLn(gvar_02536458, '1 POST ' + Form27.Edit3.Text); {005B5C6A cat}
      if Trim(Form27.Edit5.Text) <> '' then                  {005B5C8E..5CCE Edit5=340}
        WriteLn(gvar_02536458, '1 CITY ' + Form27.Edit5.Text); {005B5CE4 cat 1 CITY ' + Edit5 (005B5CCD GetText)}
      if Trim(Form27.Edit4.Text) <> '' then                  {005B5D08..5D38 Edit4=310}
        WriteLn(gvar_02536458, '1 PHON ' + Form27.Edit4.Text); {005B5D5E cat}
      if Trim(Form27.Edit6.Text) <> '' then                  {005B5D82..5DB2 Edit6=348, leer -> jmp 005B5E30}
        WriteLn(gvar_02536458, '1 EMAIL ' + Form27.Edit6.Text); {005B5DD8 cat, dann jmp 005B5E30}
    end
    else                                                     {005B5DFE}
    begin
      WriteLn(gvar_02536458, '0 @S0@ SUBM');                 {005B5DFE}
      WriteLn(gvar_02536458, '1 NAME UNKNOWN');              {005B5E17}
    end;
  end;
  Form27.Visible := False;                                   {005B5E39 TCustomForm.SetVisible(False)}
  Form1.Label18.Visible := True;                             {005B5E4D Form1+400}
  Form1.Label18.Caption := '0 %';                            {005B5E64 SetText}
  Form1.Label18.Refresh;                                     {005B5E76}
  Form1.Label19.Visible := True;                             {005B5E8A Form1+404}
  Form1.Label19.Caption := 'Gedcom schreiben';               {005B5E9C SetText}
  Form1.Label19.Refresh;                                     {005B5EB3}
  gvar_02536644 := DataModule2.Table24.RecordCount;          {005B5EC2 vtbl+14C}
  DataModule2.Table1.IndexName := '';                        {005B5ED4 +5C SetIndexName('')}
  DataModule2.Table24.IndexName := '';                       {005B5EE3 +1D0 SetIndexName('')}
  DataModule2.Table24.First;                                 {005B5EF0}
  DataModule2.Table29.Open;                                  {005B5EFD +248}
  DataModule2.Table29.IndexName := 'qu';                     {005B5F0F +248 'qu'}
  personNr := 1;                                             {005B5F14 [ebp-0C]}
  st2 := '';                                                 {005B5F1B [ebp-10]}
  gedausxv;                                                  {005B5F25}
  DataModule2.Table24.IndexName := '';                       {005B5F34}
  DataModule2.Table24.First;                                 {005B5F41; jmp in while-Bedingung 005B8B7D}
  while not DataModule2.Table24.Eof do                       {005B8B7D Bedingung}
  begin
    proz := Round(personNr / gvar_02536644 * 100);           {005B5F4B..5F5C fild/fdiv/fmul 100 + ROUND}
    Form1.Label18.Caption := IntToStr(proz) + ' %';          {005B5F63..5F91 ' %' + SetText}
    Form1.Label18.Refresh;                                   {005B5FA3}
    edi := 0;                                                  {005B5FA8 xor edi edi - NOTES-Merker}
    WriteLn(gvar_02536458, '0 @I' + IntToStr(personNr) +     {005B5FAA..5FD3 CatN3}
      '@ INDI');                                             {push '0 @I', IntToStr, '@ INDI'}
    uNr := DataModule2.Table24Nummer.AsInteger;              {005B5FF2..5FFF vtbl+22C +58 [ebp-168] Integer}
    DataModule2.Table1.FindKey([uNr]);                       {005B6019}
    st4 := Trim(DataModule2.Table1Vornamen.AsString);        {005B6024..603A +544}
    if Pos('!', st4) > 0 then                                {005B603F..604E}
      Delete(st4, Pos('!', st4), 1);                         {005B6078 LStrDelete 1 Zeichen an '!'-Pos}
    if gvar_02536650 = 1 then                                {005B6082}
      WriteLn(gvar_02536458, '1 NAME ' +                     {005B60F3 CatN4 -> AnsiToUtf8 -> CatN3}
        AnsiToUtf8(st4 + ' /' + Trim(DataModule2.Table1Name.AsString) + '/'))
    else                                                     {005B6119}
      WriteLn(gvar_02536458, '1 NAME ' + st4 + ' /' +        {005B6155 CatN5}
        Trim(DataModule2.Table1Name.AsString) + '/');        {push '1 NAME ', st4, ' /', Trim(Name), '/'}
    if Trim(DataModule2.Table1Namex.AsString) <> '' then     {005B617F..61AA +5BC}
    begin
      if gvar_02536650 = 1 then                              {005B61B0}
        WriteLn(gvar_02536458, '1 NAME /' +                  {005B61ED CatN3}
          AnsiToUtf8(DataModule2.Table1Namex.AsString) + '/')
      else                                                   {005B6219}
        WriteLn(gvar_02536458, '1 NAME /' +                  {005B6242 CatN3}
          DataModule2.Table1Namex.AsString + '/');
      WriteLn(gvar_02536458, '2 TYPE variant');              {005B6266}
    end;
    if Trim(DataModule2.Table1Rufname.AsString) <> '' then   {005B627F..62AA +600}
      WriteLn(gvar_02536458, '2 _RUFNAME ' +                 {005B62D0 CatN3}
        DataModule2.Table1Rufname.AsString);
    if Trim(DataModule2.Table1Hausname.AsString) <> '' then  {005B62EF..631A +5C8}
    begin
      if gvar_02536650 = 1 then                              {005B6320}
        WriteLn(gvar_02536458, '1 NAME /' +                  {005B635D CatN3}
          AnsiToUtf8(DataModule2.Table1Hausname.AsString) + '/')
      else                                                   {005B6389}
        WriteLn(gvar_02536458, '1 NAME /' +                  {005B63AC CatN3}
          DataModule2.Table1Hausname.AsString + '/');
      WriteLn(gvar_02536458, '2 TYPE estate');               {005B63D6}
    end;
    {--- C3 (005B63EF..005B8878): SEX / OCCU / RELI / IDNO / Quelleg-Ref /
      BIRT / CHR / _GODP / DEAT / CAUS / BURI / RESI / NOTES (Schrw., lebt,
      Memo-Kommentar) ---}
    st5 := Trim(DataModule2.Table1Geschlecht.AsString);        {005B63EA..640E +548}
    if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then
      WriteLn(gvar_02536458, '1 SEX F')                        {005B6425}
    else
    begin
      if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then
        WriteLn(gvar_02536458, '1 SEX M')                      {005B6479}
      else
      begin
        if (UpperCase(DataModule2.Table1Geschlecht.AsString) = 'X') or  {005B64BE..64C8}
           (st5 = '') then                                             {005B64CA..64F5}
          WriteLn(gvar_02536458, '1 SEX U');                            {005B64F7}
      end;
    end;
    if Trim(DataModule2.Table1Beruf.AsString) <> '' then        {005B6510..653B +550}
    begin
      if gvar_02536650 = 1 then                                 {005B6548}
        WriteLn(gvar_02536458, '1 OCCU ' +                      {005B654A..659E CatN3}
          AnsiToUtf8(DataModule2.Table1Beruf.AsString))
      else                                                      {005B65A0}
        WriteLn(gvar_02536458, '1 OCCU ' +                      {005B65BF CatN3}
          DataModule2.Table1Beruf.AsString);
    end;
    if Trim(DataModule2.Table1Religion.AsString) <> '' then     {005B65EB..660E +54C}
      WriteLn(gvar_02536458, '1 RELI ' +                        {005B662F CatN3}
        DataModule2.Table1Religion.AsString);                   {KEINE Utf8-Variante im Original}
    if Trim(DataModule2.Table1IDNR.AsString) <> '' then         {005B665B..667E +5C0}
      WriteLn(gvar_02536458, '1 IDNO ' +                        {005B669F CatN3}
        DataModule2.Table1IDNR.AsString);
    DataModule2.Table38.First;                                  {005B66C5 +530}
    if Trim(DataModule2.Table1Quelle.AsString) <> '' then       {005B66DE..66FB +5FC}
    begin
      u := DataModule2.Table1Quelle.AsString;                   {005B6707..671A}
      if DataModule2.Table38.FindKey([u]) then                  {005B6727..673E [ebp-168] VarType 0B}
      begin
        bmk := -1;                                              {005B674F [530] vtbl+150 GetBookmark - Recon-Stub}
        WriteLn(gvar_02536458, '1 SOUR @S' + IntToStr(bmk) + '@');  {005B6740..6790 CatN3}
      end;
      sub_00576EB0(bmk, u);                                     {005B67A2 vtbl+150 (erneut) + 00576EB0 6-stellig}
      st3 := st3 + u + '*';                                     {005B6795..67C6 CatN3 [ebp-28] SourRef-Accu}
    end;
    st5 := Trim(DataModule2.Table1Gebjahr.AsString);            {005B67D9..67F6 +55C}
    if (st5 <> '') or (Trim(DataModule2.Table1Gebort.AsString) <> '') then  {005B6817..6823 +560}
    begin
      WriteLn(gvar_02536458, '1 BIRT');                         {005B6829}
      if st5 <> '' then                                         {005B6861..686D}
        WriteLn(gvar_02536458, '2 DATE ' +                      {005B6873..68FF CatN3}
          sub_00582C24(DataModule2.Table1Gebtag.AsString,       {554 Tag}
                       DataModule2.Table1Gebmonat.AsString,     {558 Monat}
                       DataModule2.Table1Gebjahr.AsString));    {55C Jahr}
      if Trim(DataModule2.Table1Gebort.AsString) <> '' then     {005B6922..6929}
      begin
        u := DataModule2.Table1Gebort.AsString;                 {005B693F..694E}
        DataModule2.Table13.FindKey([u]);                       {005B6955..696A [0CC] - ohne Result-Test}
        st2 := DataModule2.Table1Gebort.AsString + ',' +        {005B6978..69E5 CatN7 [ebp-2C]}
               DataModule2.Table13Lkr.AsString + ',' +          {0A64}
               DataModule2.Table13Bland.AsString + ',' +        {0A58}
               DataModule2.Table13Land.AsString;                               {0A4C}
        if gvar_02536650 = 1 then                               {005B69EA}
          WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(st2))   {005B6A0D CatN3}
        else
          WriteLn(gvar_02536458, '2 PLAC ' + st2);              {005B6A3C CatN3}
        u := DataModule2.Table1Gebort.AsString;                 {005B6A70..6A73}
        if DataModule2.Table13.FindKey([u]) then                {005B6A96..6A9D}
        begin
          bmk := -1;                                            {005B6AB2 vtbl+150 - Recon-Stub}
          WriteLn(gvar_02536458, '3 _LOC @P' + IntToStr(bmk) + '@');  {005B6AA3..6AF3 CatN3}
          sub_00576EB0(bmk, u);                                 {005B6B02..6B14 [0CC] vtbl+150 + 6-stellig}
          if Pos(u, st1) = 0 then                               {005B6B1C..6B23 LStrPos - st1 [ebp-14] PLAC-Ref-Accu}
          begin
            sub_00576EB0(bmk, u);                               {005B6B32..6B3E vtbl+150 (erneut)}
            st1 := st1 + u + '*';                               {005B6B4E..6B56 CatN3}
          end;
        end;
      end;
      u := DataModule2.Table1Quelleg.AsString;                  {005B6B67..6B74 +5A0}
      if DataModule2.Table38.FindKey([u]) then                  {005B6B91..6B98}
      begin
        bmk := -1;                                              {005B6BAD vtbl+150 - Recon-Stub}
        WriteLn(gvar_02536458, '2 SOUR @S' + IntToStr(bmk) + '@');  {005B6B9E..6BEE CatN3}
        sub_00576EB0(bmk, u);                                   {005B6C00}
        st3 := st3 + u + '*';                                   {005B6BF3..6C24 CatN3}
      end;
    end;
    st5 := Trim(DataModule2.Table1Taufjahr.AsString);           {005B6C39..6C54 +56C}
    if (st5 <> '') or (Trim(DataModule2.Table1Taufort.AsString) <> '') then   {005B6C75..6C81 +570}
    begin
      WriteLn(gvar_02536458, '1 CHR');                          {005B6C87}
      if st5 <> '' then                                         {005B6CB9..6CCB}
        WriteLn(gvar_02536458, '2 DATE ' +                      {005B6CD1..6D5D CatN3}
          sub_00582C24(DataModule2.Table1Tauftag.AsString,      {564 Tag}
                       DataModule2.Table1Taufmonat.AsString,    {568 Monat}
                       DataModule2.Table1Taufjahr.AsString));   {56C Jahr}
      if Trim(DataModule2.Table1Taufort.AsString) <> '' then    {005B6D7B..6D87}
      begin
        u := DataModule2.Table1Taufort.AsString;
        DataModule2.Table13.FindKey([u]);                       {005B6DC3..6DDC}
        st2 := DataModule2.Table1Taufort.AsString + ',' +       {005B6DDC..6E3B CatN7}
               DataModule2.Table13Lkr.AsString + ',' +
               DataModule2.Table13Bland.AsString + ',' +
               DataModule2.Table13Land.AsString;
        if gvar_02536650 = 1 then
          WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(st2))   {005B6E6B}
        else
          WriteLn(gvar_02536458, '2 PLAC ' + st2);              {005B6E9A}
        u := DataModule2.Table1Taufort.AsString;
        if DataModule2.Table13.FindKey([u]) then                {005B6EF4..6EFB}
        begin
          bmk := -1;                                            {005B6F10 vtbl+150 - Recon-Stub}
          WriteLn(gvar_02536458, '3 _LOC @P' + IntToStr(bmk) + '@');  {005B6F01..6F51}
          sub_00576EB0(bmk, u);                                 {005B6F5E..6F6C}
          if Pos(u, st1) = 0 then                               {005B6F7A..6F81}
          begin
            sub_00576EB0(bmk, u);
            st1 := st1 + u + '*';
          end;
        end;
      end;
      u := DataModule2.Table1Quellet.AsString;                  {005B6FC1..6FD2 +5A4}
      if DataModule2.Table38.FindKey([u]) then                  {005B6FEF..6FF6}
      begin
        bmk := -1;                                              {005B700B vtbl+150 - Recon-Stub}
        WriteLn(gvar_02536458, '2 SOUR @S' + IntToStr(bmk) + '@');  {005B6FFC..704C}
        sub_00576EB0(bmk, u);                                   {005B705E..706A}
        st3 := st3 + u + '*';                                   {005B7051..7082 CatN3}
      end;
    end;
    if Trim(DataModule2.Table1Taufpat.AsString) <> '' then      {005B7097..70B2 +574}
    begin
      if gvar_02536650 = 1 then                                 {005B70BF}
        WriteLn(gvar_02536458, '2 _GODP ' + AnsiToUtf8(DataModule2.Table1Taufpat.AsString))  {005B70F6 CatN3}
      else
        WriteLn(gvar_02536458, '2 _GODP ' +                     {005B7136 CatN3}
          DataModule2.Table1Taufpat.AsString);
    end;
    st5 := Trim(DataModule2.Table1Stjahr.AsString);             {005B716A..7185 +584}
    if (st5 <> '') or (Trim(DataModule2.Table1Stort.AsString) <> '') then    {005B71A6..71B2 +588}
    begin
      WriteLn(gvar_02536458, '1 DEAT');                         {005B71B8}
      if st5 <> '' then                                         {005B71EA..71FC}
        WriteLn(gvar_02536458, '2 DATE ' +                      {005B7202..728D CatN3}
          sub_00582C24(DataModule2.Table1Sttag.AsString,        {57C Tag}
                       DataModule2.Table1Stmonat.AsString,      {580 Monat}
                       DataModule2.Table1Stjahr.AsString));     {584 Jahr}
      if Trim(DataModule2.Table1Stort.AsString) <> '' then      {005B72AC..72B8}
      begin
        u := DataModule2.Table1Stort.AsString;
        DataModule2.Table13.FindKey([u]);                       {005B72F4..72F9 - ohne Result-Test}
        st2 := DataModule2.Table1Stort.AsString + ',' +         {005B7309..736C CatN7}
               DataModule2.Table13Lkr.AsString + ',' +
               DataModule2.Table13Bland.AsString + ',' +
               DataModule2.Table13Land.AsString;
        if gvar_02536650 = 1 then
          WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(st2))   {005B739C}
        else
          WriteLn(gvar_02536458, '2 PLAC ' + st2);              {005B73CB}
        u := DataModule2.Table1Stort.AsString;
        if DataModule2.Table13.FindKey([u]) then                {005B7425..742C}
        begin
          bmk := -1;                                            {005B7441 vtbl+150 - Recon-Stub}
          WriteLn(gvar_02536458, '3 _LOC @P' + IntToStr(bmk) + '@');  {005B7432..7482}
          sub_00576EB0(bmk, u);                                 {005B7491..749D}
          if Pos(u, st1) = 0 then                               {005B74AB..74B2}
          begin
            sub_00576EB0(bmk, u);
            st1 := st1 + u + '*';
          end;
        end;
      end;
      u := DataModule2.Table1Quelles.AsString;                  {005B74F2..74FD +5A8}
      if DataModule2.Table38.FindKey([u]) then                  {005B7520..7527}
      begin
        bmk := -1;                                              {005B753C vtbl+150 - Recon-Stub}
        WriteLn(gvar_02536458, '2 SOUR @S' + IntToStr(bmk) + '@');  {005B752D..757D}
        sub_00576EB0(bmk, u);                                   {005B758F..759B}
        st3 := st3 + u + '*';                                   {005B7582..75B3 CatN3}
      end;
    end;
    if Trim(DataModule2.Table1Todesurs.AsString) <> '' then     {005B75C0..75E3 +58C}
    begin
      if gvar_02536650 = 1 then                                 {005B75F0}
        WriteLn(gvar_02536458, '2 CAUS ' + AnsiToUtf8(DataModule2.Table1Todesurs.AsString))  {005B7622 CatN3}
      else
        WriteLn(gvar_02536458, '2 CAUS ' +                      {005B7667 CatN3}
          DataModule2.Table1Todesurs.AsString);
    end;
    st5 := Trim(DataModule2.Table1Begjahr.AsString);            {005B7699..76B6 +598}
    if (st5 <> '') or (Trim(DataModule2.Table1Begort.AsString) <> '') then    {005B76D7..76E3 +59C}
    begin
      WriteLn(gvar_02536458, '1 BURI');                         {005B76E9}
      if st5 <> '' then                                         {005B771B..772D}
        WriteLn(gvar_02536458, '2 DATE ' +                      {005B7733..77BD CatN3}
          sub_00582C24(DataModule2.Table1Begtag.AsString,       {590 Tag}
                       DataModule2.Table1Begmonat.AsString,     {594 Monat}
                       DataModule2.Table1Begjahr.AsString));    {598 Jahr}
      if Trim(DataModule2.Table1Begort.AsString) <> '' then     {005B77DD..77E9}
      begin
        u := DataModule2.Table1Begort.AsString;
        DataModule2.Table13.FindKey([u]);                       {005B7825..782A - ohne Result-Test}
        st2 := DataModule2.Table1Begort.AsString + ',' +        {005B783A..7897 CatN7}
               DataModule2.Table13Lkr.AsString + ',' +
               DataModule2.Table13Bland.AsString + ',' +
               DataModule2.Table13Land.AsString;
        if gvar_02536650 = 1 then
          WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(st2))   {005B78CD}
        else
          WriteLn(gvar_02536458, '2 PLAC ' + st2);              {005B78FC}
        u := DataModule2.Table1Begort.AsString;
        if DataModule2.Table13.FindKey([u]) then                {005B7956..795D}
        begin
          bmk := -1;                                            {005B7972 vtbl+150 - Recon-Stub}
          WriteLn(gvar_02536458, '3 _LOC @P' + IntToStr(bmk) + '@');  {005B7963..79B3}
          sub_00576EB0(bmk, u);                                 {005B79C2..79CE}
          if Pos(u, st1) = 0 then                               {005B79DC..79E3}
          begin
            sub_00576EB0(bmk, u);
            st1 := st1 + u + '*';
          end;
        end;
      end;
      u := DataModule2.Table1Quelleb.AsString;                  {005B7A23..7A2E +5AC}
      if DataModule2.Table38.FindKey([u]) then                  {005B7A51..7A58}
      begin
        bmk := -1;                                              {005B7A6D vtbl+150 - Recon-Stub}
        WriteLn(gvar_02536458, '2 SOUR @S' + IntToStr(bmk) + '@');  {005B7A5E..7AAE}
        sub_00576EB0(bmk, u);                                   {005B7AC0..7ACC}
        st3 := st3 + u + '*';                                   {005B7AB3..7AE4 CatN3}
      end;
    end;
    st5 := Trim(DataModule2.Table1Lebensort.AsString);          {005B7AF9..7B14 +578}
    if (st5 <> '') or (Trim(DataModule2.Table1Adr1.AsString) <> '') then    {005B7B35..7B41 +5CC}
      WriteLn(gvar_02536458, '1 RESI');                         {005B7B47}
    if st5 <> '' then                                           {005B7B8B}
    begin
      if gvar_02536650 = 1 then                                 {005B7B98}
        WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(DataModule2.Table1Lebensort.AsString))  {005B7BCA CatN3}
      else
        WriteLn(gvar_02536458, '2 PLAC ' +                      {005B7C0F CatN3}
          DataModule2.Table1Lebensort.AsString);
    end;
    if Trim(DataModule2.Table1Adr1.AsString) <> '' then         {005B7C43..7C5E}
    begin
      WriteLn(gvar_02536458, '2 ADDR ');                        {005B7C64 - Kopfzeile ohne Inhalt}
      if gvar_02536650 = 1 then                                 {005B7C84}
        WriteLn(gvar_02536458, '3 ADR1 ' + AnsiToUtf8(DataModule2.Table1Adr1.AsString))  {005B7CB6 CatN3}
      else
        WriteLn(gvar_02536458, '3 ADR1 ' +                      {005B7CFB CatN3}
          DataModule2.Table1Adr1.AsString);
    end;
    if Trim(DataModule2.Table1Adr2.AsString) <> '' then         {005B7D2F..7D4A +5D0}
    begin
      if gvar_02536650 = 1 then                                 {005B7D57}
        WriteLn(gvar_02536458, '3 ADR2 ' + AnsiToUtf8(DataModule2.Table1Adr2.AsString))  {005B7D89 CatN3}
      else
        WriteLn(gvar_02536458, '3 ADR2 ' +                      {005B7DCE CatN3}
          DataModule2.Table1Adr2.AsString);
    end;
    if Trim(DataModule2.Table1Adrzus.AsString) <> '' then       {005B7E02..7E1D +5DC}
    begin
      if gvar_02536650 = 1 then                                 {005B7E2A}
        WriteLn(gvar_02536458, '3 ADR3 ' + AnsiToUtf8(DataModule2.Table1Adrzus.AsString))  {005B7E5C CatN3}
      else
        WriteLn(gvar_02536458, '3 ADR3 ' +                      {005B7EA1 CatN3}
          DataModule2.Table1Adrzus.AsString);
    end;
    if Trim(DataModule2.Table1PLZ.AsString) <> '' then          {005B7ED5..7EF0 +5D4}
    begin
      if gvar_02536650 = 1 then                                 {005B7EFD}
        WriteLn(gvar_02536458, '3 POST ' + AnsiToUtf8(DataModule2.Table1PLZ.AsString))  {005B7F2F CatN3}
      else
        WriteLn(gvar_02536458, '3 POST ' +                      {005B7F74 CatN3}
          DataModule2.Table1PLZ.AsString);
    end;
    if Trim(DataModule2.Table1Ort.AsString) <> '' then          {005B7FA8..7FC3 +5D8}
    begin
      if gvar_02536650 = 1 then                                 {005B7FD0}
        WriteLn(gvar_02536458, '3 CITY ' + AnsiToUtf8(DataModule2.Table1Ort.AsString))  {005B8002 CatN3}
      else
        WriteLn(gvar_02536458, '3 CITY ' +                      {005B8047 CatN3}
          DataModule2.Table1Ort.AsString);
    end;
    if Trim(DataModule2.Table1Tel.AsString) <> '' then          {005B807B..8096 +5F0}
    begin
      if gvar_02536650 = 1 then                                 {005B80A3}
        WriteLn(gvar_02536458, '2 PHON ' + AnsiToUtf8(DataModule2.Table1Tel.AsString))  {005B80D5 CatN3}
      else
        WriteLn(gvar_02536458, '2 PHON ' +                      {005B811A CatN3}
          DataModule2.Table1Tel.AsString);
    end;
    if Trim(DataModule2.Table1Ema.AsString) <> '' then          {005B814E..8169 +5F4}
    begin
      if gvar_02536650 = 1 then                                 {005B8176}
        WriteLn(gvar_02536458, '2 EMAIL ' + AnsiToUtf8(DataModule2.Table1Ema.AsString))  {005B81A8 CatN3}
      else
        WriteLn(gvar_02536458, '2 EMAIL ' +                     {005B81ED CatN3}
          DataModule2.Table1Ema.AsString);
    end;
    if Trim(DataModule2.Table1Ur.AsString) <> '' then           {005B821F..823C +5F8}
    begin
      if gvar_02536650 = 1 then                                 {005B8249}
        WriteLn(gvar_02536458, '2 WWW ' + AnsiToUtf8(DataModule2.Table1Ur.AsString))  {005B827B CatN3}
      else
        WriteLn(gvar_02536458, '2 WWW ' +                       {005B82C0 CatN3}
          DataModule2.Table1Ur.AsString);
    end;
    {Schwab-Notiz (Namex [5BC]); edi-Merker - erstes '1 NOTE', dann '2 CONT'}
    if Trim(DataModule2.Table1Namex.AsString) <> '' then        {005B82F4..830F}
    begin
      if edi = 0 then                                           {005B8317}
      begin
        edi := 1;                                               {005B831D}
        if gvar_02536650 = 1 then                               {005B8329}
          WriteLn(gvar_02536458, '1 NOTE Schrw.: ' +            {005B835B CatN3}
            AnsiToUtf8(DataModule2.Table1Namex.AsString))
        else
          WriteLn(gvar_02536458, '1 NOTE Schrw.: ' +            {005B83A3 CatN3}
            DataModule2.Table1Namex.AsString);
      end
      else
      begin
        if gvar_02536650 = 1 then                               {005B83D3}
          WriteLn(gvar_02536458, '2 CONT Schrw.: ' +            {005B8405 CatN3}
            AnsiToUtf8(DataModule2.Table1Namex.AsString))
        else
          WriteLn(gvar_02536458, '2 CONT Schrw.: ' +            {005B844A CatN3}
            DataModule2.Table1Namex.AsString);
        edi := 1;                                               {005B846E}
      end;
    end;
    {Lebt-Notiz [5B4]; nach 'Schrw.'-Ausgabe ist edi immer 1 -> immer '2 CONT'}
    if Trim(DataModule2.Table1Lebt.AsString) = 'j' then         {005B8483..84A7 LStrCmp /'j'/}
    begin
      if edi = 0 then                                           {005B84AF}
        WriteLn(gvar_02536458, '1 NOTE lebt: ' +                {005B84D0 CatN3}
          DataModule2.Table1Lebt.AsString)
      else
      begin
        WriteLn(gvar_02536458, '2 CONT lebt: ' +                {005B8515 CatN3}
          DataModule2.Table1Lebt.AsString);
      end;
      edi := 1;                                                 {005B8539 - in beiden Zweigen erreicht}
    end;
    {Notizen zum Kommentar (TMemoField [5B0]) - ueber Form27.CheckBox1 abschaltbar}
    if Form27.CheckBox1.Checked then                            {005B853E..8555 [318] vtbl+0C4 GetChecked}
    begin                                                       {005B8878 - Completion folgt in C4}
    end
    else if Trim(DataModule2.Table1Kommentar.AsString) <> '' then  {005B856B..8586 [5B0] TMemoField}
    begin
      Form1.Memo1.Clear;                                        {005B858C..85A1 [40C] Memo1 vtbl+0DC (als Clear gelesen)}
      komFeld := DataModule2.Table1.FieldByName('kommentar');              {005B85A6..85B5 [5C] FieldByName}
      Form1.Memo1.Lines.Assign(komFeld);                        {005B85BE..85CC [Memo1+220]=Lines, vtbl+8 - aus TMemoField, recon als Assign}
      if Form1.Memo1.Lines.Count > 0 then                       {005B85D6..85EF [Memo1+220] vtbl+14 GetCount; jle -> 005B8878}
      begin
        if edi = 0 then
        begin
          u := Form1.Memo1.Lines[0];                            {005B861D..8661 [220] vtbl+0C Get(0)}
          if gvar_02536650 = 1 then                             {005B85FE}
            WriteLn(gvar_02536458, '1 NOTE ' + AnsiToUtf8(u))   {005B863D CatN3}
          else
            WriteLn(gvar_02536458, '1 NOTE ' + u);              {005B8692 CatN3}
        end
        else
        begin
          u := Form1.Memo1.Lines[0];
          if gvar_02536650 = 1 then                             {005B86C2}
            WriteLn(gvar_02536458, '2 CONT ' + AnsiToUtf8(u))   {005B8701 CatN3}
          else
            WriteLn(gvar_02536458, '2 CONT ' + u);              {005B8753 CatN3}
        end;
        cmzCount := 1;                          {005B85A1 mov esi,1 - 2.Cont-Lines ab Zeile 2}
        while cmzCount < Form1.Memo1.Lines.Count do             {005B8777 vtbl+14 GetCount / 005B8870 cmp esi}
        begin
          u := Form1.Memo1.Lines[cmzCount];                     {005B87C1..87C4 [220] vtbl+0C Get(esi)}
          if gvar_02536650 = 1 then                             {005B87A2}
            WriteLn(gvar_02536458, '2 CONT ' + AnsiToUtf8(u))   {005B87E1 CatN3}
          else
            WriteLn(gvar_02536458, '2 CONT ' + u);              {005B8833 CatN3}
          cmzCount := cmzCount + 1;                             {005B8857 inc esi}
        end;
      end;
    end;
    {FAMS-Loop ueber gvar_02536448 (Paar-Eintraege, 12 Zeichen)}
    cmzCount := gvar_02536448.Count;                              {005B8878 [ebp-30]}
    for famI := 0 to cmzCount - 1 do                              {005B888B..8A40}
    begin
      u := Copy(gvar_02536448[famI], 1, 6);                       {005B88A0..88BF LStrCopy}
      sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, u6);        {005B88C6..88DE [228]+58 + 00576EB0}
      if u = u6 then                                              {005B88E5..88EA}
        WriteLn(gvar_02536458, '1 FAMS @F' +                      {005B88EC..8964 CatN3}
          IntToStr(StrToInt(RightStr(gvar_02536448[famI], 6))) + '@')
      else
      begin
        u := Copy(gvar_02536448[famI], 7, 6);                     {005B8976..8999}
        sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, u6);      {005B89A0..89AB [228]+58}
        if u = u6 then                                            {005B89BD..89C2}
          WriteLn(gvar_02536458, '1 FAMS @F' +                    {005B89C4..8A37 CatN3}
            IntToStr(StrToInt(RightStr(gvar_02536448[famI], 6))) + '@');
      end;
    end;
    {FAMC-Loop ueber gvar_0253644C (Kinder-Eintraege, '*'-markiert)}
    cmzCount := gvar_0253644C.Count;                              {005B8A46 [ebp-30]}
    for famI := 0 to cmzCount - 1 do                              {005B8A59..8B34}
    begin
      sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, u6);        {005B8A78..8A8B}
      if Pos('*' + u6, gvar_0253644C[famI]) > 0 then              {005B8A96..8AB4 LStrCat3() + LStrPos}
        WriteLn(gvar_02536458, '1 FAMC @F' +                      {005B8AB6..8B29 CatN3}
          IntToStr(StrToInt(RightStr(gvar_0253644C[famI], 6))) + '@');
    end;
    personNr := personNr + 1;                                     {005B8B3A inc [ebp-0C]}
    DataModule2.Table1.FindKey([krg]);                            {005B8B3D..8B5A [ebp-8]=krg als FindKey-Wert}
    DataModule2.Table24.Next;                                     {005B8B67}
  end;                                                            {while not Table24.Eof - Kopf 005B8B7D/8B8C}
  {Familien-Export: 'lfn'-Index, HUSB/WIFE/CHIL pro Paar-Eintrag}
  DataModule2.Table24.IndexName := 'lfn';                         {005B8B9F}
  DataModule2.Table24.First;                                      {005B8BAC}
  cmzCount := gvar_02536448.Count;                                {005B8BB1 [ebp-30]}
  for famI := 0 to cmzCount - 1 do                                {005B8BC4..005BA0DA}
  begin
    WriteLn(gvar_02536458, '0 @F' +                               {005B8BCA..8C3D CatN3}
      IntToStr(StrToInt(RightStr(gvar_02536448[famI], 6))) + '@ FAM');
    {---- HUSB ----}
    u := Copy(gvar_02536448[famI], 1, 6);                         {005B8C42..8C7B}
    if u <> '000000' then                                         {005B8C70..8C80}
      WriteLn(gvar_02536458, '1 HUSB @I' +                        {005B8C82..8CFB CatN3}
        IntToStr(StrToInt(Copy(gvar_02536448[famI], 1, 6))) + '@');
    {---- WIFE ----}
    u := Copy(gvar_02536448[famI], 7, 6);                         {005B8D00..8D39}
    if u <> '000000' then                                         {005B8D34..8D3E}
      WriteLn(gvar_02536458, '1 WIFE @I' +                        {005B8D40..8DB9 CatN3}
        IntToStr(StrToInt(Copy(gvar_02536448[famI], 7, 6))) + '@');
    {---- CHIL - Kinder ab Position 14, je 7 Zeichen + '*'-Separator}
    if Length(gvar_02536448[famI]) > 12 then                      {005B8DBE..8DDE LStrLen cmp 12}
    begin
      u := Copy(gvar_02536448[famI], 13, Length(gvar_02536448[famI]) - 12);  {005B8DE4..8E2A LStrCopy edx=0D}
      childCount := Round(Length(u) / 7);                         {005B8E2F..8E51 fild/fdiv 7:Single/ROUND [ebp-34]}
      childIdx := 1;                                              {005B8E5C [ebp-0C] personNr-Slot wird recycelt}
      for childIdx := 1 to childCount do                          {005B8E63..8F3D incl. dec/jne}
        WriteLn(gvar_02536458, '1 CHIL @I' +                      {005B8E63..8EE8 CatN3}
          IntToStr(StrToInt(Copy(gvar_02536448[famI], 13 + 7 * childIdx, 6))) + '@');
    end;
    {--- C5 (005B8EF9..005BA1B8): Paar-Positionierung, MARR-RELI, MARR-CIVIL, DIV, not-marr ---}
    u := Copy(gvar_02536448[famI], 1, 6);                     {005B8EF9..8F32}
    u := Copy(gvar_02536448[famI], 7, 6);                     {005B8F3D..8F76}
    if (u <> '000000') and (Copy(gvar_02536448[famI], 1, 6) <> '000000') then  {005B8F32..8F7B beide je-Endstuecke}
    begin
      uNr := StrToInt(Copy(gvar_02536448[famI], 1, 6));       {005B8FAF..8FBA}
      DataModule2.Table24.FindKey([uNr]);                     {005B8FBB..8FD7 [1D0]}
      uNr := DataModule2.Table24Nummer.AsInteger;             {005B8FDC..8FE9 [22C]+58}
      DataModule2.Table1.FindKey([uNr]);                      {005B8FEF..9003 [5C]}
      {Ehe-Suche: Table5 auf Paar-Nummer (005B9008..9129)}
      DataModule2.Table5.First;                               {005B9008..9010 [80]}
      cmzCount := DataModule2.Table5.RecordCount;             {005B901D vtbl+14C [ebp-30]}
      while cmzCount > 1 do                                   {005B9025 dec/jle -> 005B914D}
      begin
        if DataModule2.Table5Nummer.AsInteger = DataModule2.Table24Nummer.AsInteger then  {005B9129..9147 je 9031}
        begin
          uNr := StrToInt(Copy(gvar_02536448[famI], 7, 6));   {005B9031..9069}
          DataModule2.Table24.FindKey([uNr]);                 {005B9077..9087}
          if DataModule2.Table5Epnum.AsInteger = DataModule2.Table24Nummer.AsInteger then  {005B908C..90AA}
            break;                                            {gefunden -> 005B914D}
        end;
        uNr := StrToInt(Copy(gvar_02536448[famI], 1, 6));     {005B90B0..90DE}
        DataModule2.Table24.FindKey([uNr]);                   {005B90F6..9106}
        DataModule2.Table5.Next;                              {005B9113}
        if DataModule2.Table5.Eof then                        {005B9118..9127}
          break;                                              { -> 005B914D }
      end;
      {Verbind-Kennzeichnung (Table5Verbind [440])}
      if Pos('Ehes', DataModule2.Table5Verbind.AsString) > 0 then  {005B914D..9172 LStrPos 'Ehes'}
        WriteLn(gvar_02536458, '1 _STAT MARRIED');             {005B9174..9188}
      if Pos('and', DataModule2.Table5Verbind.AsString) > 0 then  {005B918D..91B2 LStrPos 'and'}
        WriteLn(gvar_02536458, '1 _STAT NOT MARRIED');         {005B91B4..91C8}
      {Trauung - Religioese (Trim(Hjahr) > '..' ODER Trim(Hort) <> '')}
      if (Trim(DataModule2.Table5Hjahr.AsString) > '..') or    {005B91CD..9201 LStrCmp '..' -> ja 005B9234}
         (Trim(DataModule2.Table5Hort.AsString) <> '') then    {005B9203..922E jbe -> 005B9720 = CIVIL-Check}
      begin
        WriteLn(gvar_02536458, '1 MARR');                      {005B9234..9248}
        WriteLn(gvar_02536458, '2 TYPE RELI');                 {005B924D..9261}
        if Trim(DataModule2.Table5Hjahr.AsString) <> '' then   {005B9266..9291}
          WriteLn(gvar_02536458, '2 DATE ' +                   {005B9297..931D CatN3}
            sub_00582C24(DataModule2.Table5Htag.AsString,      {418 Tag}
                         DataModule2.Table5Hmonat.AsString,    {41C Monat}
                         DataModule2.Table5Hjahr.AsString));   {420 Jahr}
        if Trim(DataModule2.Table5Hort.AsString) <> '' then    {005B9322..934D jbe -> 005B9720 (skip PLAC/LOC/WITN/SOUR)}
        begin
          u := DataModule2.Table5Hort.AsString;                {005B9353..9366}
          DataModule2.Table13.FindKey([u]);                    {005B9379..9389 [0CC] - ohne Result-Test}
          st2 := DataModule2.Table5Hort.AsString + ',' +       {005B939E..9409 CatN7 [ebp-2C]}
                 DataModule2.Table13Lkr.AsString + ',' +       {0A64}
                 DataModule2.Table13Bland.AsString + ',' +     {0A58}
                 DataModule2.Table13Land.AsString;             {0A4C}
          if gvar_02536650 = 1 then                            {005B940E}
            WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(st2))  {005B9417..9450}
          else
            WriteLn(gvar_02536458, '2 PLAC ' + st2);           {005B9457..947F}
          u := DataModule2.Table5Hort.AsString;                {005B9484..9494}
          if DataModule2.Table13.FindKey([u]) then             {005B949A..94BA}
          begin
            bmk := -1;                                         {005B94CA vtbl+150 - Recon-Stub}
            WriteLn(gvar_02536458, '3 _LOC @P' + IntToStr(bmk) + '@');  {005B94C7..9517 CatN3}
            sub_00576EB0(bmk, u);                              {005B951C..9532}
            if Pos(u, st1) = 0 then                            {005B9537..9547 LStrPos - st1 [ebp-14] PLAC-Ref-Accu}
            begin
              sub_00576EB0(bmk, u);                            {005B954C..9562}
              st1 := st1 + u + '*';                            {005B9567..9575 CatN3}
            end;
          end;
          if Trim(DataModule2.Table5Trauz.AsString) <> '' then {005B957F..95AA [428]}
          begin
            if gvar_02536650 = 1 then                          {005B95B0}
              WriteLn(gvar_02536458, '2 _WITN ' +              {005B95B9..9608}
                AnsiToUtf8(DataModule2.Table5Trauz.AsString))
            else
              WriteLn(gvar_02536458, '2 _WITN ' +              {005B960F..964D}
                DataModule2.Table5Trauz.AsString);
          end;
          u := DataModule2.Table5Hqu.AsString;                 {005B9652..9662 [454]}
          if DataModule2.Table38.FindKey([u]) then             {005B9678..968F [530]}
          begin
            bmk := -1;                                         {005B969F vtbl+150 - Recon-Stub}
            WriteLn(gvar_02536458, '2 SOUR @S' +               {005B9695..96E5 CatN3}
              IntToStr(bmk) + '@');
            sub_00576EB0(bmk, u);                              {005B96EA..9703}
            st3 := st3 + u + '*';                              {005B9708..9713 CatN3 [ebp-28] SourRef-Accu}
          end;
        end;
      end;                                                   {RELI-Block}
      {Trauung - Zivil (Trim(Sajahr)> '..' ODER Trim(Saort)<>'')}
      if (Trim(DataModule2.Table5Sajahr.AsString) > '..') or  {005B9720..9754}
         (Trim(DataModule2.Table5Saort.AsString) <> '') then  {005B9756..9781 jbe -> 005B9C73 (skip -> DIV)}
      begin
        WriteLn(gvar_02536458, '1 MARR');                      {005B9787..979B}
        WriteLn(gvar_02536458, '2 TYPE CIVIL');                {005B97A0..97B4}
        if Trim(DataModule2.Table5Sajahr.AsString) <> '' then  {005B97B9..97E4}
          WriteLn(gvar_02536458, '2 DATE ' +                   {005B97EA..9870 CatN3}
            sub_00582C24(DataModule2.Table5Satag.AsString,     {42C Tag}
                         DataModule2.Table5Samonat.AsString,   {430 Monat}
                         DataModule2.Table5Sajahr.AsString));  {434 Jahr}
        if Trim(DataModule2.Table5Saort.AsString) <> '' then   {005B9875..98A0 jbe -> 005B9C73}
        begin
          u := DataModule2.Table5Saort.AsString;               {005B98A6..98B6}
          DataModule2.Table13.FindKey([u]);                    {005B98CC..98DC [0CC] - ohne Test}
          st2 := DataModule2.Table5Saort.AsString + ',' +      {005B98F1..995C CatN7}
                 DataModule2.Table13Lkr.AsString + ',' +       {0A64}
                 DataModule2.Table13Bland.AsString + ',' +     {0A58}
                 DataModule2.Table13Land.AsString;             {0A4C}
          if gvar_02536650 = 1 then                            {005B9961}
            WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(st2))  {005B996A..99A3}
          else
            WriteLn(gvar_02536458, '2 PLAC ' + st2);           {005B99AA..99D2}
          u := DataModule2.Table5Saort.AsString;               {005B99D7..99E7}
          if DataModule2.Table13.FindKey([u]) then             {005B9A03..9A14}
          begin
            bmk := -1;                                         {005B9A28 vtbl+150 - Recon-Stub}
            WriteLn(gvar_02536458, '3 _LOC @P' + IntToStr(bmk) + '@');  {005B9A1A..9A6A}
            sub_00576EB0(bmk, u);                              {005B9A6F..9A85}
            if Pos(u, st1) = 0 then                            {005B9A8A..9A9A}
            begin
              sub_00576EB0(bmk, u);                            {005B9A9F..9AB5}
              st1 := st1 + u + '*';                            {005B9ABA..9ACD}
            end;
          end;
          if Trim(DataModule2.Table5Satrauz.AsString) <> '' then  {005B9AD2..9AFD [43C]}
          begin
            if gvar_02536650 = 1 then                          {005B9B03}
              WriteLn(gvar_02536458, '2 _WITN ' +              {005B9B0C..9B60}
                AnsiToUtf8(DataModule2.Table5Satrauz.AsString))
            else
              WriteLn(gvar_02536458, '2 _WITN ' +              {005B9B62..9BA0}
                DataModule2.Table5Satrauz.AsString);
          end;
          u := DataModule2.Table5Saqu.AsString;                {005B9BA5..9BB5 [458]}
          if DataModule2.Table38.FindKey([u]) then             {005B9BD1..9BE2}
          begin
            bmk := -1;                                         {005B9BF2 Recon-Stub}
            WriteLn(gvar_02536458, '2 SOUR @S' +               {005B9BE8..9C38 CatN3}
              IntToStr(bmk) + '@');
            sub_00576EB0(bmk, u);                              {005B9C3D..9C56}
            st3 := st3 + u + '*';                              {005B9C5B..9C6E}
          end;
        end;
      end;                                                   {CIVIL-Block}
      {Scheidung (Trim(Schjahr)> '..' ODER Trim(Schort)<>'')}
      if (Trim(DataModule2.Table5Schjahr.AsString) > '..') or
         (Trim(DataModule2.Table5Schort.AsString) <> '') then {005B9C73..9CD4 jbe -> 005BA0DA}
      begin
        WriteLn(gvar_02536458, '1 DIV');                       {005B9CDA..9CEE}
        if Trim(DataModule2.Table5Schjahr.AsString) <> '' then {005B9CF3..9D1E}
          WriteLn(gvar_02536458, '2 DATE ' +                   {005B9D24..9DAA CatN3}
            sub_00582C24(DataModule2.Table5Schtag.AsString,    {444 Tag}
                         DataModule2.Table5Schmonat.AsString,  {448 Monat}
                         DataModule2.Table5Schjahr.AsString)); {44C Jahr}
        if Trim(DataModule2.Table5Schort.AsString) <> '' then  {005B9DAF..9DDA jbe -> 005BA00C}
        begin
          u := DataModule2.Table5Schort.AsString;              {005B9DE0..9DF0}
          DataModule2.Table13.FindKey([u]);                    {005B9E0C..9E16 - ohne Test}
          st2 := DataModule2.Table5Schort.AsString + ',' +     {005B9E2B..9E96 CatN7}
                 DataModule2.Table13Lkr.AsString + ',' +
                 DataModule2.Table13Bland.AsString + ',' +
                 DataModule2.Table13Land.AsString;
          if gvar_02536650 = 1 then                            {005B9E9B}
            WriteLn(gvar_02536458, '2 PLAC ' + AnsiToUtf8(st2))  {005B9EA4..9EDD}
          else
            WriteLn(gvar_02536458, '2 PLAC ' + st2);           {005B9EE4..9F0C}
          u := DataModule2.Table5Schort.AsString;              {005B9F11..9F21}
          if DataModule2.Table13.FindKey([u]) then             {005B9F37..9F4C}
          begin
            bmk := -1;                                         {005B9F6A Recon-Stub}
            WriteLn(gvar_02536458, '3 _LOC @P' + IntToStr(bmk) + '@');  {005B9F54..9FA4}
            sub_00576EB0(bmk, u);                              {005B9FA9..9FBF}
            if Pos(u, st1) = 0 then                            {005B9FC4..9FD4}
            begin
              sub_00576EB0(bmk, u);                            {005B9FD6..9FEF}
              st1 := st1 + u + '*';                            {005B9FF4..A007}
            end;
          end;
        end;
        u := DataModule2.Table5Schqu.AsString;                 {005BA00C..BA01C [45C]}
        if DataModule2.Table38.FindKey([u]) then               {005BA032..BA042}
        begin
          bmk := -1;                                           {005BA054 Recon-Stub}
          WriteLn(gvar_02536458, '2 SOUR @S' + IntToStr(bmk) + '@');  {005BA04F..BA09F}
          sub_00576EB0(bmk, u);                                {005BA0A4..BA0BD}
          st3 := st3 + u + '*';                                {005BA0C2..BA0D5}
        end;
      end;
      {not-marr-Hinweis (005BA0DA..005BA1AE)}
      if Pos('and', DataModule2.Table5Verbind.AsString) > 0 then  {005BA0E0..BA0F8}
      begin
        u := Trim(Copy(gvar_02536448[famI], 1, 6));            {005BA105..8BA13F}
        if u <> '' then                                        {005BA144..8BA14B}
        begin
          u := Trim(Copy(gvar_02536448[famI], 7, 6));          {005BA14D..8BA18C}
          if u <> '' then                                      {005BA18C..BA193}
            WriteLn(gvar_02536458, '2 NOTE not marr');         {005BA195..BA1A9}
        end;
      end;
    end;                                                       {Pa-Eintrag - Ende (FAM-Loop-Body)}
    {--- C6 (005BA1B8..005BBCC5): PLAC-Ref-Export (@P... _LOC-Records aus
      st1), SOUR-Section (@S-Records aus st3 ueber Table38, Index 'tit'),
      0 TRLR, CloseFile, Freel der SListen und UI-Reset ---}
    {PLAC-Block: @P-Records ueber die st1-Sammel-StringList}
    if Trim(st1) <> '' then                                    {005BA1B8..BA1CD}
    begin
      cmzCount := Round(Length(st1) / 7);                      {005BA1D3..BA1F4 [ebp-30]}
      if cmzCount > 0 then                                     {005BA1F4 jle -> 005BA87F}
      begin
        childIdx := 1;                                         {005BA1FD [ebp-0C]}
        repeat                                                 {005BA204..BA879}
          uLoc := Copy(st1, childIdx * 7 - 6, 6);              {005BA208..BA21C LStrCopy}
          WriteLn(gvar_02536458, '0 @P' + IntToStr(StrToInt(uLoc)) + '@ _LOC');  {005BA221..BA269 CatN3}
          //v1A0 GotoBookmark Table13(StrToInt(uLoc)) - Stub, Original positionierte auf den Bookmark
          if gvar_02536650 = 1 then                            {005BA288..BA28F}
            WriteLn(gvar_02536458, '1 NAME ' +                 {005BA291..BA2E5 CatN3}
              AnsiToUtf8(DataModule2.Table13Ort.AsString))
          else
            WriteLn(gvar_02536458, '1 NAME ' +                 {005BA2E7..BA325 CatN3}
              DataModule2.Table13Ort.AsString);
          if Trim(DataModule2.Table13Abk.AsString) <> '' then  {005BA32A..BA355 jbe -> 005BA3FD}
          begin
            if gvar_02536650 = 1 then                          {005BA35B}
              WriteLn(gvar_02536458, '1 _ABBR ' +              {005BA37D..BA3B8 CatN3}
                AnsiToUtf8(DataModule2.Table13Abk.AsString))
            else
              WriteLn(gvar_02536458, '1 _ABBR ' +              {005BA3BA..BA3F8 CatN3}
                DataModule2.Table13Abk.AsString);
          end;
          if Trim(DataModule2.Table13PLZ.AsString) <> '' then  {005BA3FD..BA428 jbe -> 005BA46D}
            WriteLn(gvar_02536458, '1 _FPOST ' +             {005BA42A..BA468 CatN3 - KEINE Utf8-Variante im Original}
              DataModule2.Table13PLZ.AsString);
          if Trim(DataModule2.Table13Lkr.AsString) <> '' then  {005BA46D..BA498 jbe -> 005BA540}
          begin
            if gvar_02536650 = 1 then                          {005BA49E}
              WriteLn(gvar_02536458, '1 _FCNTY ' +             {005BA4C0..BA4FB CatN3}
                AnsiToUtf8(DataModule2.Table13Lkr.AsString))
            else
              WriteLn(gvar_02536458, '1 _FCNTY ' +             {005BA4FD..BA53B CatN3}
                DataModule2.Table13Lkr.AsString);
          end;
          if Trim(DataModule2.Table13Bland.AsString) <> '' then  {005BA540..BA56B jbe -> 005BA613}
          begin
            if gvar_02536650 = 1 then                          {005BA571}
              WriteLn(gvar_02536458, '1 _FSTAE ' +             {005BA593..BA5CE CatN3}
                AnsiToUtf8(DataModule2.Table13Bland.AsString))
            else
              WriteLn(gvar_02536458, '1 _FSTAE ' +             {005BA5D0..BA60E CatN3}
                DataModule2.Table13Bland.AsString);
          end;
          if Trim(DataModule2.Table13Land.AsString) <> '' then  {005BA613..BA63E jbe -> 005BA6E6}
          begin
            if gvar_02536650 = 1 then                          {005BA644}
              WriteLn(gvar_02536458, '1 _FCTRY ' +             {005BA666..BA6A1 CatN3}
                AnsiToUtf8(DataModule2.Table13Land.AsString))
            else
              WriteLn(gvar_02536458, '1 _FCTRY ' +             {005BA6A3..BA6E1 CatN3}
                DataModule2.Table13Land.AsString);
          end;
          if (Trim(DataModule2.Table13Ort.AsString) <> '') and  {005BA6E6..BA711 und BA717..BA742 je jbe -> 005BA7EA}
             (Trim(DataModule2.Table13Maid.AsString) <> '') then
          begin
            if gvar_02536650 = 1 then                          {005BA788}
              WriteLn(gvar_02536458, '1 _GOV ' +               {005BA775..BA7A5 CatN3}
                AnsiToUtf8(DataModule2.Table13Gov.AsString))
            else
              WriteLn(gvar_02536458, '1 _GOV ' +               {005BA7A7..BA7E5 CatN3}
                DataModule2.Table13Gov.AsString);
          end;
          if Trim(DataModule2.Table13Maid.AsString) <> '' then  {005BA7EA..BA815 jbe -> 005BA873}
          begin
            WriteLn(gvar_02536458, '1 MAP ' +                {005BA817..BA85A CatN3}
              DataModule2.Table13Maid.AsString);
            WriteLn(gvar_02536458, '2 TYPE MAIDENHEAD');     {005BA85A..BA86E}
          end;
          Inc(childIdx);                                     {005BA873 [ebp-0C]}
          Dec(cmzCount);                                     {005BA876 [ebp-30]}
        until cmzCount = 0;                                  {005BA879 jne -> 005BA204}
      end;
    end;
    {SOUR-Section (005BA87F..005BB3F5): Table38 (Index 'tit'), je Quelle ein
    0 @S-Record mit Titel/Abk/Ereignis/Zeitraum/Standort/Publ/Bestand/Bem/Med}
    DataModule2.Table38.Open;                                {005BA87F..BA88C}
    DataModule2.Table38.IndexName := 'tit';                  {005BA894..BA89E vtbl+360}
    DataModule2.Table38.First;                               {005BA89E..BA8AB}
    cmzCount := DataModule2.Table38.RecordCount;             {005BA8AB..BA8BD vtbl+14C [ebp-30]}
    while cmzCount > 0 do                                    {005BA8BD jle -> 005BB3F5}
    begin
      sub_00576EB0(DataModule2.Table38N.AsInteger, uLoc);    {005BA8C8..BA8DD vtbl+150 + 00576EB0}
      uLoc := uLoc + '*';                                    {005BA8DD..BA8E8 LStrCat [ebp-978]}
      if Pos(uLoc, st3) > 0 then                             {005BA8ED..BA8FD LStrPos - jle -> 005BB3C2 (Next)}
      begin
        WriteLn(gvar_02536458, '0 @S' +                      {005BA903..BA95B CatN3}
          IntToStr(DataModule2.Table38N.AsInteger) + '@ SOUR');
        u := DataModule2.Table38Titel.AsString;              {005BA960..BA97F [0A18]}
        if Trim(u) <> '' then                                {005BA97F..BA98B jbe -> 005BAA33}
        begin
          if gvar_02536650 = 1 then                          {005BA991}
            WriteLn(gvar_02536458, '1 TITL ' +               {005BA99A..BAA2E CatN3}
              AnsiToUtf8(DataModule2.Table38Titel.AsString))
          else
            WriteLn(gvar_02536458, '1 TITL ' +               {005BA99A..BAA2E CatN3}
              DataModule2.Table38Titel.AsString);
        end;
        u := DataModule2.Table38Abk.AsString;                {005BAA33..BAA5E [0A1C]}
        if Trim(u) <> '' then                                {005BAA52..BAA5E jbe -> 005BAB06}
        begin
          if gvar_02536650 = 1 then                          {005BAA64}
            WriteLn(gvar_02536458, '1 ABBR ' +               {005BAA6D..BAC1 CatN3}
              AnsiToUtf8(DataModule2.Table38Abk.AsString))
          else
            WriteLn(gvar_02536458, '1 ABBR ' +               {005BAA6D..BAC1 CatN3}
              DataModule2.Table38Abk.AsString);
        end;
        u := DataModule2.Table38Ereig.AsString;              {005BAB06..BAB31 [0A20]}
        if Trim(u) <> '' then                                {005BAB25..BAB31 jbe -> 005BABD9}
        begin
          if gvar_02536650 = 1 then                          {005BAB37}
            WriteLn(gvar_02536458, '2 EVEN ' +               {005BAB40..BABD9 CatN3}
              AnsiToUtf8(DataModule2.Table38Ereig.AsString))
          else
            WriteLn(gvar_02536458, '2 EVEN ' +               {005BAB40..BABD9 CatN3}
              DataModule2.Table38Ereig.AsString);
        end;
        {Zeitraum-String 'FROM ... TO ...' (005BABD9..005BAD50), [ebp-24]}
        stVon := '';                                         {005BA90B LStrClr [ebp-24]}
        u := DataModule2.Table38Von.AsString;                {005BABE1..BABEC [0A24]}
        if Trim(u) <> '' then                                {005BABF8..BAC04 jbe -> 005BAC2C}
          stVon := stVon + 'FROM ' +                         {005BAC06..BAC22 CatN3}
            DataModule2.Table38Von.AsString;
        u := DataModule2.Table38Bis.AsString;                {005BAC2C..BAC3A [0A28]}
        if Trim(u) <> '' then                                {005BAC4B..BAC57 jbe -> 005BAC87}
        begin
          stVon := Trim(stVon) + '';                         {005BAC59..BAC87 LStrCat ' TO ' + Bis}
          stVon := stVon + ' TO ' +
            DataModule2.Table38Bis.AsString;
        end;
        stVon := stVon;                                      {005BAC87..BACC0 Concat (Von + Bis)}
        if Trim(stVon) <> '' then                            {005BACC6..BACD1 jbe -> 005BAD50}
        begin
          if gvar_02536650 = 1 then                          {005BACD8}
            WriteLn(gvar_02536458, '3 DATE ' +               {005BACE3..BAD4B CatN3}
              AnsiToUtf8(stVon))
          else
            WriteLn(gvar_02536458, '3 DATE ' + stVon);       {005BAD23..BAD4B CatN3}
        end;
        u := DataModule2.Table38Standort.AsString;           {005BAD50..BAD63 [0A2C]}
        if Trim(u) <> '' then                                {005BAD6F..BAD7B jbe -> 005BAE23}
        begin
          if gvar_02536650 = 1 then                          {005BAD81}
            WriteLn(gvar_02536458, '3 PLAC ' +               {005BAD8A..BADD9 CatN3}
              AnsiToUtf8(DataModule2.Table38Standort.AsString))
          else
            WriteLn(gvar_02536458, '3 PLAC ' +               {005BAD8A..BADD9 CatN3}
              DataModule2.Table38Standort.AsString);
        end;
        u := DataModule2.Table38Publ.AsString;               {005BAE23..BAE33 [0A30]}
        if Trim(u) <> '' then                                {005BAE3C..BAE4E jbe -> 005BAEF6}
        begin
          if gvar_02536650 = 1 then                          {005BAE54}
            WriteLn(gvar_02536458, '1 PUBL ' +               {005BAE5D..BAEB3 CatN3}
              AnsiToUtf8(DataModule2.Table38Publ.AsString))
          else
            WriteLn(gvar_02536458, '1 PUBL ' +               {005BAE5D..BAEB3 CatN3}
              DataModule2.Table38Publ.AsString);
        end;
        u := DataModule2.Table38Bestand.AsString;            {005BAEF6..BAF06 [0A3C]}
        if Trim(u) <> '' then                                {005BAF15..BAF21 jbe -> 005BAFC9}
        begin
          if gvar_02536650 = 1 then                          {005BAF27}
            WriteLn(gvar_02536458, '2 CALN ' +               {005BAF30..BAFC9 CatN3}
              AnsiToUtf8(DataModule2.Table38Bestand.AsString))
          else
            WriteLn(gvar_02536458, '2 CALN ' +               {005BAF30..BAFC9 CatN3}
              DataModule2.Table38Bestand.AsString);
        end;
        {Bemerkung [0A38]: Laenge+7 >= 253 -> Konkordat 245er-Blaetterung (005BAFC9..BB2EF)}
        u := DataModule2.Table38Bem.AsString;                {005BAFC9..BAFD9}
        if Length(u) + 7 >= 253 then                         {005BAFE2..BAFEF jge -> 005BB09F}
        begin
          {Mehrzeilige Bemerkung (005BB09F..BB2EF)}
          if gvar_02536650 = 1 then                          {005BB09F..BB1DE}
          begin
            WriteLn(gvar_02536458, '2 NOTE ' +               {005BB0AC..BB11D CatN3}
              AnsiToUtf8(Copy(DataModule2.Table38Bem.AsString, 1, 245)));
            cmzCount := Round(Length(u) / 245);              {005BB126..BB153 [ebp-30]}
            if cmzCount > 0 then                             {005BB153 jle -> 005BB2EF}
            begin
              childIdx := 1;                                 {005BB15C [ebp-0C]}
              repeat                                         {005BB163..BB1DC}
                WriteLn(gvar_02536458, '3 CONC ' +           {005BB163..BB1D1 CatN3}
                  AnsiToUtf8(Copy(DataModule2.Table38Bem.AsString, childIdx * 245 + 1, 245)));
                Inc(childIdx);                               {005BB1D6 [ebp-0C]}
                Dec(cmzCount);                               {005BB1D9 [ebp-30]}
              until cmzCount = 0;                            {005BB1DC jne -> 005BB163}
            end;
          end
          else
          begin
            WriteLn(gvar_02536458, '2 NOTE ' +               {005BB1E3..BB23D CatN3}
              Copy(DataModule2.Table38Bem.AsString, 1, 245));
            cmzCount := Round(Length(u) / 245);              {005BB25B..BB27B [ebp-30]}
            if cmzCount > 0 then                             {005BB279 jle -> 005BB2EF}
            begin
              childIdx := 1;                                 {005BB27E [ebp-0C]}
              repeat                                         {005BB285..BB2ED}
                WriteLn(gvar_02536458, '3 CONC ' +           {005BB285..BB2E2 CatN3}
                  Copy(DataModule2.Table38Bem.AsString, childIdx * 245 + 1, 245));
                Inc(childIdx);                               {005BB2E7 [ebp-0C]}
                Dec(cmzCount);                               {005BB2EA [ebp-30]}
              until cmzCount = 0;                            {005BB2ED jne -> 005BB285}
            end;
          end;
        end
        else
        begin
          {Einzeilige Bemerkung (005BAFF5..BB09A)}
          if gvar_02536650 = 1 then                          {005BAFF5..BB052}
            WriteLn(gvar_02536458, '2 NOTE ' +               {005BAFFE..BB052 CatN3}
              AnsiToUtf8(DataModule2.Table38Bem.AsString))
          else
            WriteLn(gvar_02536458, '2 NOTE ' +               {005BB057..BB09A CatN3}
              DataModule2.Table38Bem.AsString);
        end;
        u := DataModule2.Table38Med.AsString;                {005BB2EF..BB302 [0A40]}
        if Trim(u) <> '' then                                {005BB313..BB31A jbe -> 005BB3C2}
        begin
          if gvar_02536650 = 1 then                          {005BB320}
            WriteLn(gvar_02536458, '3 MEDI ' +               {005BB329..BB3C2 CatN3}
              AnsiToUtf8(DataModule2.Table38Med.AsString))
          else
            WriteLn(gvar_02536458, '3 MEDI ' +               {005BB329..BB3C2 CatN3}
              DataModule2.Table38Med.AsString);
        end;
      end;
      DataModule2.Table38.Next;                              {005BB3CA}
      if DataModule2.Table38.Eof then                        {005BB3D7..BB3F5}
        break;                                               {005BB3DE jne -> 005BB3F5 - Eof-Rechtsende}
    end;
    {Abschluss (005BB3F5..005BB4A3): UI-Reset, 0 TRLR, CloseFile, Freel, anzeigen}
    st3 := '';                                               {005BB3F5..BB3FD LStrClr [ebp-28]}
    Form1.Label18.Hide;                                      {005BB402..BB40A Form1+400}
    Form1.Label19.Hide;                                      {005BB416..BB41C Form1+404}
    WriteLn(gvar_02536458, '0 TRLR');                        {005BB421..BB43A}
    CloseFile(gvar_02536458);                                {005BB43A..BB444}
    gvar_02536448.Free;                                      {005BB444..BB44E}
    gvar_0253644C.Free;                                      {005BB44E..BB458}
    Form1.Refresh;                                           {005BB45D..BB464}
    DataModule2.Table1.IndexName := '';                      {005BB469..BB475 [5C]}
    u := IntToStr(krg);                                      {005BB475..BB492 [ebp-168] VarType 0B}
    DataModule2.Table1.FindKey([krg]);                       {005BB485..BB497 [5C]}
    Form1.anzeigen;                                          {005BB49E TForm1.anzeigen}
  end;
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



