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
  Windows, SysUtils, StrUtils, Classes, Graphics, StdCtrls, Buttons, DBTables, DBCommon, 
Dialogs, Forms, Controls, Grids, DB, QuickRpt, QRCtrls, AHNGlobals, Unit1, Unit2, Unit15, Unit16, Unit14, Unit24, Unit28, Unit29, Unit36, 
Unit39, Unit26, Unit27;

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
var
  krg: Integer;                     {0058505B [ebp-4] aktuelle Personnr}
  namFilter, ortFilter, husFilter: AnsiString;  {005852CC [ebp-2C] / 0058533C [ebp-30] / 005853AC [ebp-34] Form24-Listen-Muster}
  gueltig: Boolean;                 {00585203 [ebp-4A]}
  agu: Boolean;                     {00585A1C [ebp-49]}
  i: Integer;                       {0058528C [ebp-50] ListBox-Durchlaufzähler}
  num: Integer;                     {00585642/00585B93 [ebp-0B0] FindKey-Schlüssel}
  leere: Boolean;                   {0058563C/00585B99 [ebp-0AC]}
  idx: Integer;                     {0058566B ebx - innerer Table18-Durchlauf}
  s, u: AnsiString;                 {diverse Zwischenwerte}
  bl: Boolean;                      {00585B50/bl-Register - Ort-Treffer-Kette W-Zweig}
  dup: Boolean;                     {recon Weiche Ehe-Duplikat 00585E05..C9}
  bmk: TBookmark;                   {00586742 [ebp-24] lfbh2-Lesezeichen}
  v: AnsiString;                    {00586831 [ebp-204] Pos-Nadel 6stellige Mutter-Nr}
  zzg: AnsiString;                   {00586E41 [ebp-38] aufzubauende Berichtzeile (C3)}
  unkMut: AnsiString;                {00586D6A [ebp-40] '*Nr*'-Kette Kinder ohne Mutter}
  unkVat: AnsiString;                {00586D72 [ebp-44] '*Nr*'-Kette Kinder ohne Vater}
  kcount: Integer;                   {00586DF5 [ebp-18] Kind-Zaehler}
  ehn: Integer;                      {00587D0C [ebp-14] Eh-Kettenlaufindex}
  patn: Integer;                     {00587DA3 [ebp-10] aktiver Ehepartner-Nr}
   erst: Integer;                    {0058958F [ebp-1C] erster Kinder-Treffer (Zähler)}
   kopf: Boolean;                     {00589C97 [ebp-20] ' ['-Marker gesetzt}
   RedVar24: AnsiString;             {00588A6C [ebp-4AC] 58C67C-Settings-Flag}
   perNr: Integer;                    {00586E53 esi := Table1Nummer (Kindersuchen v/ m)}
begin
  { 00585048: OFB-Report "Ortsfamilienbuch": Inhalt von Form24.ListBox3
    (Nachnamenmuster), ListBox4 (Ortsmuster) und ListBox6 (Hausnamenmuster)
    in '*'-abgegrenzte Filterstrings zusammenfassen, dann Table1
    personweise ablaufen (Geschlecht M / W), alle matchenden Treffer in
    Form1.lfbh2 (ClientDataSet: lfbh2Nr/lfbh2Nm/lfbh2Prob/lfbh2Eh/lfbh2Ix/
    lfbh2Nam/lfbh2Aus/lfbh2Hei) einsammeln und später vorbereiten.
    C1 = Prolog (UI, Cursor, StringListen, Tabellenöffnung) + M-Zweig.
    C2 = W-Zweig; C3 = Tabellen-Aufbereitung. }
  krg := DataModule2.Table1Nummer.AsInteger;                 {0058506C}
  gvar_02536664 := '';                                       {00585081}
  Form1.Label19.Caption := 'OFB erstellen';                   {0058508B [404]}
  Form1.Label19.Visible := True;                             {005850AF}
  Form1.Label19.Refresh;                                     {005850BF}
  Form1.Refresh;                                             {005850CB}
  Screen.Cursor := crHourGlass;                              {005850D4 0FFF5}
  gvar_02536440 := TStringList.Create;                       {005850E4}
  gvar_02536440.Sorted := True;                              {005850F5}
  PByte(Integer(gvar_02536440)+$1D)^ := 0;                   {00585101}
  gvar_02536444 := TStringList.Create;                       {0058510A}
  gvar_02536444.Sorted := True;                              {0058511D}
  PByte(Integer(gvar_02536444)+$1D)^ := 0;                   {00585127}
  Form1.lfbh2.Open;                                          {00585130 [8B8]}
  Form1.lfbh2.EmptyDataSet;                                  {00585142}
  Form1.lfbh2.Open;                                          {00585154}
  Form1.lfbh2.DisableControls;                               {00585166}
  DataModule2.Table1.Open;                                   {00585178}
  DataModule2.Table1.IndexName := '';                        {0058518D}
  DataModule2.Table1.First;                                  {0058519F}
  DataModule2.Table1.DisableControls;                        {005851B1}
  DataModule2.Table18.Open;                                  {005851BE [140]}
  DataModule2.Table18.IndexName := 'num';                    {005851D5}
  DataModule2.Table18.First;                                 {005851EC}
  DataModule2.Table18.DisableControls;                       {005851FE}
  gueltig := False;                                          {00585203}
  Form24.ListBox3.Count;                                     {00585207..1C totes Ergebnis (nur D2-Count-Sync)}
  Form24.ListBox4.Count;                                     {0058521E..33 totes Ergebnis (nur D2-Count-Sync)}
  if Form24.ListBox6.Count > 0 then                          {00585235..4C [368] +0C4 = Count, NICHT Visible}
  begin
    gueltig := True;                                         {0058524E}
    Form24.RadioButton2.Visible := True;                     {00585252 [38C] +0C8 SetVisible}
  end;
  namFilter := '';                                           {00585269}
  for i := 1 to Form24.ListBox3.Count do                     {00585289..CA vtbl+218 Items}
    namFilter := namFilter + '*' + Form24.ListBox3.Items[i-1];
  namFilter := namFilter + '*';                              {005852CC}
  ortFilter := '';                                           {005852D9}
  for i := 1 to Form24.ListBox4.Count do                     {005852F9..3A}
    ortFilter := ortFilter + '*' + Form24.ListBox4.Items[i-1];
  ortFilter := ortFilter + '*';                              {0058533C}
  husFilter := '';                                           {00585349}
  for i := 1 to Form24.ListBox6.Count do                     {00585369..AC}
    husFilter := husFilter + '*' + Form24.ListBox6.Items[i-1];
  husFilter := husFilter + '*';                              {005853AC}
  while not DataModule2.Table1.Eof do                        {0058590E..1F Hauptloop u. 005858FB..5 Kante}
  begin
    if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then  {005853BE..3E6 [548]}
    begin
      Form1.lfbh2.Append;                                    {005853F1..03 [8B8]}
      Form1.lfbh2Nam.AsString := DataModule2.Table1Name.AsString;  {00585403..28 [91C]/[540]}
      if gvar_025363E8 = 1 then                              {00585430}
        Form1.lfbh2Ix.AsString :=                            {00585439..85 [918] Vornamen+GebJahr+TaufJahr}
          DataModule2.Table1Vornamen.AsString +              {00585439 [544]}
          DataModule2.Table1Gebjahr.AsString +               {00585451 [55C]}
          DataModule2.Table1Taufjahr.AsString;               {00585469 [56C]}
      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, s);   {005854A6..C0 [534]+58}
      Form1.lfbh2Prob.AsString := s;                         {005854C2..D2 [910]}
      if gvar_025363E0 = 1 then                              {005854D8}
      begin
        if Trim(DataModule2.Table1Gebjahr.AsString) > '' then  {005854E5..515 [55C]+Trim}
          Form1.lfbh2Ix.AsString :=                          {0058551B..5A0}
            DataModule2.Table1Gebjahr.AsString +             {00585521}
            DataModule2.Table1Gebmonat.AsString +            {00585546 [558]}
            DataModule2.Table1Gebtag.AsString                {00585557 [554]}
        else
          Form1.lfbh2Ix.AsString :=                          {005855A5..624}
            DataModule2.Table1Taufjahr.AsString +            {005855B8 [56C]}
            DataModule2.Table1Taufmonat.AsString +           {005855CE [568]}
            DataModule2.Table1Tauftag.AsString;              {005855E7 [564]}
      end;
      num := DataModule2.Table1Nummer.AsInteger;             {0058562A..40 [ebp-0B0]}
      leere := False;                                        {00585642 [ebp-0AC]}
      if DataModule2.Table18.FindKey([num]) then             {00585649..63}
      begin
        idx := 1;                                            {0058566B ebx}
        repeat                                               {00585675..866}
          sub_00576EB0(DataModule2.Table18Epnum.AsInteger, u);  {0058569C..D3 [4CC]+58 + 00576EB0}
          Form1.lfbh2Eh.AsString := Form1.lfbh2Eh.AsString + u + '*';  {00585675..E2 GetText [914] + Nr + '*'}
          if (gvar_025363E4 = 1) and (idx = 1) then          {005856E2..F2}
          begin
            if Trim(DataModule2.Table18Sajahr.AsString) > '' then  {005856F8..728 [4EC]}
              Form1.lfbh2Ix.AsString :=                      {0058572E..7B3}
                DataModule2.Table18Sajahr.AsString +         {00585734}
                DataModule2.Table18Samonat.AsString +        {00585752 [4E8]}
                DataModule2.Table18Satag.AsString            {00585770 [4E4]}
            else
              Form1.lfbh2Ix.AsString :=                      {005857B8..83D}
                DataModule2.Table18Hjahr.AsString +          {005857BE [4D8]}
                DataModule2.Table18Hmonat.AsString +         {005857DC [4D4]}
                DataModule2.Table18Htag.AsString;            {005857FA [4D0]}
          end;
          DataModule2.Table18.Next;                          {0058583D..4C}
        until DataModule2.Table18.Eof or                     {00585854..5C +0A1}
          (DataModule2.Table18Nummer.AsInteger <>            {00585865..8E [4C8]/[534]}
           DataModule2.Table1Nummer.AsInteger);
      end;
      Form1.lfbh2Eh.AsString := Form1.lfbh2Eh.AsString + '000000*';  {00585894..B7 CatN '000000*'}
      Form1.lfbh2.Post;                                      {005858DE vtbl+248}
    end
    else if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then  {0058594A..983}
    begin
      { 00585989..9D4: toter Pos-Test auf '*' + Hausname + '*' in husFilter -
        das setg-Ergebnis wird bei 00585A1C ohne Verwendung ueberschrieben }
      agu := Pos('*' + DataModule2.Table1Name.AsString + '*', namFilter) > 0;  {005859D9..5A1C [ebp-49]}
      if (Pos('*' + DataModule2.Table1Gebort.AsString + '*', ortFilter) > 0) or   {00585A20..68}
         (Pos('*' + DataModule2.Table1Taufort.AsString + '*', ortFilter) > 0) or   {00585A6E..B6}
         (Pos('*' + DataModule2.Table1Stort.AsString + '*', ortFilter) > 0) or     {00585ABC..B04}
         (Pos('*' + DataModule2.Table1Begort.AsString + '*', ortFilter) > 0) then  {00585B06..4E}
        bl := True                                                  {00585B54}
      else
        bl := False;                                                {00585B50}
      if gueltig then                                               {00585B56..5A}
      begin
        agu := False;                                               {00585B5C [ebp-49]}
        bl := False;                                                {00585B60}
        Form24.RadioButton2.Visible := True;                        {00585B62..73 vtbl+0C8}
      end;
      if not bl then                                                {00585B79..7B}
      begin
        num := DataModule2.Table1Nummer.AsInteger;                  {00585B81..B4 [ebp-0B0]}
        leere := False;                                             {00585B99 [ebp-0AC]}
        if DataModule2.Table18.FindKey([num]) then                  {00585BA0..BBB}
        begin
          repeat                                                    {00585BC2 jmp 00585CD3 Kante}
            if (Pos('*' + DataModule2.Table18Saort.AsString + '*', ortFilter) > 0) or   {00585BC7..C0F}
               (Pos('*' + DataModule2.Table18Hort.AsString + '*', ortFilter) > 0) or     {00585C15..C5D}
               (Pos('*' + DataModule2.Table18Schort.AsString + '*', ortFilter) > 0) then {00585C5F..CA7}
              bl := True;                                           {00585CA9}
            DataModule2.Table18.Next;                               {00585CAB..B8}
          until DataModule2.Table18.Eof or                          {00585CBD..D1}
            (DataModule2.Table18Nummer.AsInteger <>                 {00585CD3..CFB Kante}
             DataModule2.Table1Nummer.AsInteger);
        end;
      end;
      if namFilter = '*' then                                       {00585D01..13}
        agu := True;
      if ortFilter = '*' then                                       {00585D14..23}
        bl := True;
      if (agu and bl) or ((husFilter = '*') and                     {00585D25..4E Sonderfall}
         (namFilter = '*') and (ortFilter = '*')) then              {00585D50..53 je 00586689}
      begin
        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u);        {00585D59..72 [ebp-48]}
        num := DataModule2.Table1Nummer.AsInteger;                  {00585D73..85 [ebp-0B0]}
        leere := False;                                             {00585D8B [ebp-0AC]}
        if DataModule2.Table18.FindKey([num]) then                  {00585D92..DAC}
        begin
          idx := 1;                                                 {00585DB4}
          repeat                                                    {00585DB9 jmp 00586374 Kante}
            Form1.lfbh2.IndexName := 'Pro';                         {00585DBE..D5}
            sub_00576EB0(DataModule2.Table18Epnum.AsInteger, u);    {00585DD5..EB [ebp-13C]}
            dup := True;                                            {00585ECF Append-Vorgabe}
            if Form1.lfbh2.FindKey([u]) then                        {00585E05..24 +2C4 VType 0B}
            begin
              sub_00576EB0(DataModule2.Table18Nummer.AsInteger, s); {00585E2A..42 [ebp-140]}
              if Form1.lfbh2.FindKey([s]) and                       {00585E47..79 +2C4 je 00586347}
                 (Pos(u, Form1.lfbh2Eh.AsString) > 0) then          {00585E7F..C8 jne 00586347}
                dup := False;
            end;                                                    {00585ECF: bei FindKey-Fehlschlag Append}
            if dup then
            begin
              Form1.lfbh2.Append;                                   {00585ECF..EDC}
              Form1.lfbh2Nam.AsString := DataModule2.Table1Name.AsString;  {00585EE1..B0 [91C]/[540]}
              if gvar_025363E8 = 1 then                              {00585F14..1B}
                Form1.lfbh2Ix.AsString :=                            {00585F21..A0}
                  DataModule2.Table1Vornamen.AsString +              {00585F21..57 [544]}
                  DataModule2.Table1Gebjahr.AsString +               {00585F3F..75 [55C]}
                  DataModule2.Table1Taufjahr.AsString;               {00585F5D..9E [56C]}
              sub_00576EB0(DataModule2.Table1Nummer.AsInteger, s);   {00585FA6..C0 [ebp-160]/[534]}
              Form1.lfbh2Prob.AsString := s;                         {00585FC3..E0 [910]}
              if gvar_025363E0 = 1 then                              {00585FDE..E5}
              begin
                if Trim(DataModule2.Table1Gebjahr.AsString) > '' then  {00585FEB..5A1B [55C]}
                  Form1.lfbh2Ix.AsString :=                        {00586021..A6}
                    DataModule2.Table1Gebjahr.AsString +           {00585FF8 [55C]}
                    DataModule2.Table1Gebmonat.AsString +          {00586054 [558]}
                    DataModule2.Table1Gebtag.AsString              {0058606D [554]}
                else
                  Form1.lfbh2Ix.AsString :=                        {005860AB..12A}
                    DataModule2.Table1Taufjahr.AsString +          {005860B8 [56C]}
                    DataModule2.Table1Taufmonat.AsString +         {005860DE [568]}
                    DataModule2.Table1Tauftag.AsString;            {00586104 [564]}
              end;
              sub_00576EB0(DataModule2.Table18Epnum.AsInteger, s);   {0058614E..66 [ebp-194]/[4CC]}
              Form1.lfbh2Eh.AsString := Form1.lfbh2Eh.AsString + s + '*';  {00586130..9B CatN}
              if (gvar_025363E4 = 1) and (idx = 1) then              {005861A1..B1}
              begin
                if Trim(DataModule2.Table18Sajahr.AsString) > '' then  {005861B7..E7 [4EC]}
                  Form1.lfbh2Ix.AsString :=                        {005861ED..77}
                    DataModule2.Table18Sajahr.AsString +           {00586205 [4EC]}
                    DataModule2.Table18Samonat.AsString +          {00586223 [4E8]}
                    DataModule2.Table18Satag.AsString              {00586241 [4E4]}
                else
                  Form1.lfbh2Ix.AsString :=                        {00586277..B7}
                    DataModule2.Table18Hjahr.AsString +            {005862BA [4D8]}
                    DataModule2.Table18Hmonat.AsString +           {005862E0 [4D4]}
                    DataModule2.Table18Htag.AsString;              {00586301 [4D0]}
              end;
              Form1.lfbh2.Post;                                     {00586332..41 +248}
            end;
            DataModule2.Table18.Next;                               {00586347..54}
          until DataModule2.Table18.Eof or                          {00586359..6D}
            (DataModule2.Table18Nummer.AsInteger <>                 {00586359..9C Kante}
             DataModule2.Table1Nummer.AsInteger);
        end
        else
        begin
          DataModule2.Table1.IndexName := 'mut';                    {005863A7..B6}
          num := StrToInt(u);                                        {005863BB..C3 [ebp-0B0]}
          leere := False;                                            {005863C9 [ebp-0AC]}
          if DataModule2.Table1.FindKey([num]) then                  {005863D0..E9 'mut'-Suche}
          begin
            DataModule2.Table1.IndexName := '';                      {005863EF..FB}
            num := StrToInt(u);                                       {00586400..08}
            leere := False;                                           {0058640E [ebp-0AC]}
            DataModule2.Table1.FindKey([num]);                        {00586415..27 Positionierung}
            Form1.lfbh2.Append;                                       {0058642C..39}
            Form1.lfbh2Nam.AsString := DataModule2.Table1Name.AsString;  {0058643E..6B [91C]/[540]}
            if gvar_025363E8 = 1 then                                 {00586471..78}
              Form1.lfbh2Ix.AsString := DataModule2.Table1Vornamen.AsString;  {0058647A..A7 [544]}
            sub_00576EB0(DataModule2.Table1Nummer.AsInteger, s);      {005864AD..C9 [ebp-1D0]/[534]}
            Form1.lfbh2Prob.AsString := s;                            {005864CA..E5 [910]}
            if gvar_025363E0 = 1 then                                 {005864E5..EC}
            begin
              if Trim(DataModule2.Table1Gebjahr.AsString) > '' then   {005864F2..5A22 [55C]}
                Form1.lfbh2Ix.AsString :=                             {00586528..AD}
                  DataModule2.Table1Gebjahr.AsString +                {00586540 [55C]}
                  DataModule2.Table1Gebmonat.AsString +               {0058655E [558]}
                  DataModule2.Table1Gebtag.AsString                   {0058657C [554]}
              else
                Form1.lfbh2Ix.AsString :=                             {005865B2..37}
                  DataModule2.Table1Taufjahr.AsString +               {005865CA [56C]}
                  DataModule2.Table1Taufmonat.AsString +              {005865EE [568]}
                  DataModule2.Table1Tauftag.AsString;                 {00586606 [564]}
            end;
            Form1.lfbh2.Post;                                         {00586637..46 +248}
          end;
          DataModule2.Table1.IndexName := '';                         {0058664C..58}
          num := StrToInt(u);                                          {0058665D..65}
          leere := False;                                              {0058666B [ebp-0AC]}
          DataModule2.Table1.FindKey([num]);                           {00586672..84}
        end;
      end;
    end;
    DataModule2.Table1.Next;                                 {005858EC..FB}
  end;
  DataModule2.Table1.IndexName := '';                        {00585925..31}
  DataModule2.Table1.First;                                  {00585940}
  { 005866AB..BC: Table1-Eof-Kante der Hauptloop - Rekursion in den Kopf 0058594A }
  DataModule2.Table1.IndexName := '';                        {005866CC..CE}
  DataModule2.Table18.IndexName := 'num';                    {005866DA..E5}
  Form1.lfbh2.IndexName := 'Pro';                            {005866F1..FC}
  Form1.lfbh2.First;                                         {0058670E}
  while not Form1.lfbh2.Eof do                               {00586B59..6D / 00586713 jmp Kante}
  begin
    u := Form1.lfbh2Prob.AsString;                            {00586718..2A [ebp-48] [910]+60}
    bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));              {0058673A..42 vtbl+150}
    num := StrToInt(u);                                        {00586745..4D [ebp-0B0]}
    leere := False;                                            {00586753 [ebp-0AC]}
    DataModule2.Table1.FindKey([num]);                         {0058675A..73 ohne Pruefung des Ergebnisses}
    if DataModule2.Table1Vater.AsInteger > 0 then              {00586771..85}
    begin
      sub_00576EB0(DataModule2.Table1Vater.AsInteger, s);      {0058678B..A3 [ebp-1FC]/[538]}
      if Form1.lfbh2.FindKey([s]) and                          {005867A8..D8 +2C4 VType 0B}
         (DataModule2.Table1Mutter.AsInteger > 0) then         {005867E0..F4 [53C]}
      begin
        sub_00576EB0(DataModule2.Table1Mutter.AsInteger, v);   {005867FA..831 [ebp-204]/[53C]}
        if Pos(v, Form1.lfbh2Eh.AsString) > 0 then             {00586836..44 jle 0058691E}
        begin
          DataModule2.Table1.IndexName := 'mut';               {0058684A..59}
          num := StrToInt(u);                                   {0058685E..66 [ebp-0B0]}
          leere := False;                                       {0058686C [ebp-0AC]}
          if not DataModule2.Table1.FindKey([num]) then         {00586873..A88C jne 0058691E}
            if not DataModule2.Table18.FindKey([num]) then      {00586892..BC3 [140] jne}
            begin
              Form1.lfbh2.GotoBookmark(bmk);                    {005868C5..DD vtbl+1A0}
              Form1.lfbh2.Edit;                                 {005868DD..F1}
              Form1.lfbh2Nm.AsInteger := 1;                      {005868EF..08 +0A8 edx=1}
              Form1.lfbh2.Post;                                 {00586909..18 +248}
            end;
        end;
      end;
    end;
    DataModule2.Table1.IndexName := '';                        {0058691E..2A}
    num := StrToInt(u);                                         {0058692F..37}
    leere := False;                                             {0058693D [ebp-0AC]}
    DataModule2.Table1.FindKey([num]);                          {0058694A..56}
    if DataModule2.Table1Mutter.AsInteger > 0 then              {0058695B..6F [53C]}
    begin
      sub_00576EB0(DataModule2.Table1Mutter.AsInteger, s);      {00586975..8D [ebp-208]}
      if Form1.lfbh2.FindKey([s]) and                          {00586998..C4 +2C4 0B}
         (DataModule2.Table1Vater.AsInteger > 0) and           {005869CA..DE [538]}
         (Pos(IntToStr(DataModule2.Table1Vater.AsInteger),      {005869E4..A2E IntToStr-Nadel}
              Form1.lfbh2Eh.AsString) > 0) then
      begin
        DataModule2.Table1.IndexName := 'vat';                 {00586A34..43}
        num := StrToInt(u);                                     {00586A48..50}
        leere := False;                                         {00586A56 [ebp-0AC]}
        if not DataModule2.Table1.FindKey([num]) then           {00586A5D..A76 jne 00586B08}
          if not DataModule2.Table18.FindKey([num]) then        {00586A7C..AAD [140] jne}
          begin
            Form1.lfbh2.GotoBookmark(bmk);                      {00586AAF..C7 vtbl+1A0}
            Form1.lfbh2.Edit;                                   {00586AC7..DB}
            Form1.lfbh2Nm.AsInteger := 1;                        {00586AD9..03 +0A8 edx=1}
            Form1.lfbh2.Post;                                   {00586AF3..B02 +248}
          end;
      end;
    end;
    DataModule2.Table1.IndexName := '';                        {00586B08..14}
    Form1.lfbh2.GotoBookmark(bmk);                             {00586B19..2B vtbl+1A0 [ebp-24]}
    Form1.lfbh2.Next;                                          {00586B31..3E}
  end;
  Form1.lfbh2.IndexName := 'na';                             {00586B73..85}
  Form1.lfbh2.First;                                         {00586B8A..97}
  idx := 0;                                                  {00586B9C}
  while not Form1.lfbh2.Eof do                               {00586C8B..9F / 00586C75..89 Kanten}
  begin
    if Form1.lfbh2Nm.AsInteger = 1 then                       {00586BA3..B6 [90C]+58}
      Form1.lfbh2.Delete                                      {00586BB8..CA / 00586BCA Kante}
    else
    begin
      inc(idx);                                                {00586BCF}
      Form1.lfbh2.Edit;                                        {00586BD0..DD}
      Form1.lfbh2Nm.AsInteger := idx;                           {00586BE2..F3 +0A8 edx=ebx}
      if not gueltig then                                      {00586BF9..FD jne 00586C4E}
      begin
        Form1.lfbh2Hei.AsString := Copy(Form1.lfbh2Ix.AsString, 1, 4);  {00586BFF..48 [924]/[918] LStrCopy}
      end;
      Form1.lfbh2.Post;                                        {00586C4E..5D +248}
      Form1.lfbh2.Next;                                        {00586C63..70}
    end;
  end;
  Form1.lfbh2.IndexName := 'na';                             {00586CA5..B7}
  if gueltig then                                             {00586CBC..D9}
  begin
    Form1.lfbh2.IndexName := 'heir';                          {00586CC2..D4}
  end;
  Form1.lfbh2.First;                                         {00586CD9..E6}
  DataModule2.Table1.IndexName := '';                        {00586CEB..F7}
  DataModule2.Table14.Open;                                   {00586CFC..D09 [0E0]}
  DataModule2.Table14.Close;                                  {00586D0E..1B}
  DataModule2.Table14.EmptyTable;                             {00586D20..2D}
  DataModule2.Table14.Open;                                   {00586D32..44}
  idx := 0;                                                  {00586D44}
  Form1.lfbh2.First;                                         {00586D46..53}
  s := ' ';                                                  {00586D58..D60 [ebp-3C]}
  { 00586D65: jmp 0058BFDD }
  { --- C3: Tabellen-Aufbereitung (00586D6A..0058C854) --- }
  while not Form1.lfbh2.Eof do                             {00586D6A Kopf / 0058BFDD..F1 Eof-Kante}
  begin
    unkMut := '';                                            {00586D6A..6D LStrClr}
    unkVat := '';                                            {00586D72..75 LStrClr}
    if Trim(Form1.lfbh2Prob.AsString) = '' then              {00586D7A..AA [910]+60 Trim}
      Break;                                                 {0058BFB3 Tabelle durchlaufen -> Epilog}
    if idx > 0 then                                          {00586DB0..B2 test ebx}
    begin
      DataModule2.Table14.Append;                            {00586DB4..C1 [0E0]}
      DataModule2.Table14Zeile.AsString := ' ';              {00586DC6..DA [1E8]+0B0}
      DataModule2.Table14.Post;                              {00586DE0..F2 +248}
    end;
    kcount := 0;                                             {00586DF5..FA [ebp-18]}
    num := StrToInt(Form1.lfbh2Prob.AsString);               {00586DFA..E18}
    leere := False;                                          {00586E23 [ebp-0AC]}
    DataModule2.Table1.FindKey([num]);                       {00586E2A..3C}
    perNr := DataModule2.Table1Nummer.AsInteger;             {00586E41..53 esi [534]+58}
    if DataModule2.Table1Name.AsString <> s then             {00586E55..7B [540]+60 LStrCmp je->F86}
    begin
      DataModule2.Table14.Append;                            {00586E81..8E [0E0]}
      DataModule2.Table14Zeile.AsString := ' ';              {00586E93..AA [1E8]+0B0}
      DataModule2.Table14.Post;                              {00586EAD..BC +248}
      DataModule2.Table14.Append;                            {00586EC2..F0}
      DataModule2.Table14Zeile.AsString :=                  {00586ED4..F15 ucase [540]+60}
        ucase(DataModule2.Table1Name.AsString);
      DataModule2.Table14.Post;                              {00586F1B..2A +248}
      DataModule2.Table14.Append;                            {00586F30..3D}
      DataModule2.Table14Zeile.AsString := ' ';              {00586F42..56 [1E8]+0B0}
      DataModule2.Table14.Post;                              {00586F5C..6B +248}
      s := DataModule2.Table1Name.AsString;                  {00586F71..83 [540]+60 -> ebp-3C}
    end;
    zzg := '';                                              {00586F86..89 LStrClr [ebp-38]}
    Inc(idx);                                               {00586F8E inc ebx}
    DataModule2.Table14.Append;                             {00586F8F..9C}
    DataModule2.Table14Nm.AsString := IntToStr(idx);        {00586FA1..C3 [1EC]+0B0}
    zzg := ucase(DataModule2.Table1Name.AsString) + ' ' +   {00586FC9..26 CatN ebp-38}
           DataModule2.Table1Vornamen.AsString;             {00586FE1 [238]+' '+[240]}
    if Trim(DataModule2.Table1Name.AsString) <> '' then     {0058702B..5B Trim jbe->7299}
    begin
      if gvar_02536414 = 1 then                             {00587061..68 jne->7299}
      begin
        if gvar_02536418 = 1 then                           {0058706E..75 jne->71C8}
        begin
          if DataModule2.Table1Gebjahr.AsString <> '' then  {0058707B..0A3 [55C] cmp 58C8F8 '' jbe->714A}
          begin
            sub_00576F54(idx, u);                           {00587112..1A}
            gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +     {005870A9..30 CatN ebp-250 edx=7}
              DataModule2.Table1Vornamen.AsString + ' * ' +
              DataModule2.Table1Gebjahr.AsString + '' + u); {58C904 58C910('') 58C910('') 58C910('')}
          end
          else
          begin
            sub_00576F54(idx, u);                           {00587196..98}
            gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +     {0058714A..AE CatN ebp-264 edx=5}
              DataModule2.Table1Vornamen.AsString + '' + u);
          end;                                              {00587145 jmp 00587299}
        end
        else
        begin
          sub_00576F54(idx, u);                             {00587214..16}
          gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +       {005871C8..2C CatN ebp-274 edx=5}
            DataModule2.Table1Vornamen.AsString + '' + u);
        end;                                                {00587241 jmp 00587299}
      end
      else
      begin
        sub_00576F54(idx, u);                               {00587266..6E}
        gvar_02536440.Add(DataModule2.Table1Name.AsString + '' + u);      {00587243..84 CatN ebp-284 edx=3}
      end;
    end;                                                    {0058702B..299 if-Ende jbe->7299}
      if not gueltig then                                         {00587299..9D cmp [ebp-4A]0 jne->72F2 = skip wenn gueltig (FIX: war 'if gueltig')}
        if Form1.lfbh2Aus.AsInteger > 0 then                {0058729F..B3 [920]+58 test jle->72F2}
          zzg := zzg + ' [aus ' + IntToStr(Form1.lfbh2Aus.AsInteger) + '] '; {005872B5..ED CatN ebp-38 edx=4}
      if gvar_02536404 = 1 then                             {005872F2..F9 jne->7360}
        if Trim(DataModule2.Table1Religion.AsString) <> '' then  {005872FB..2B [54C] Trim jbe->7360}
          zzg := zzg + ', ' + DataModule2.Table1Religion.AsString;       {0058732D..5B CatN edx=3}
      if gvar_025363F0 = 1 then                             {00587360..67 jne->7437}
        if Trim(DataModule2.Table1Beruf.AsString) <> '' then     {0058736D..9D [550] Trim jbe->73D2}
          zzg := zzg + ', ' + DataModule2.Table1Beruf.AsString;         {0058739F..CD CatN edx=3}
      { 005873D2 - naechster Anlauf (C3d: Hausname [5C8] + Geb-Block) }
      if Trim(DataModule2.Table1Hausname.AsString) <> '' then      {005873D2..02 [5C8] Trim jbe->7437}
        zzg := zzg + ' ' + DataModule2.Table1Hausname.AsString;    {00587404..32 CatN ebp-38 edx=3}
      if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or       {00587437..67 [55C] ja->749F}
         (Trim(DataModule2.Table1Gebort.AsString) <> '') then      {00587469..99 [560] jbe->7646}
      begin
        u := DataModule2.Table1Gebtag.AsString + '.' +             {0058749F..1B CatN ebp-2CC 58C904/944}
             DataModule2.Table1Gebmonat.AsString + '.' +
             DataModule2.Table1Gebjahr.AsString;
        sub_00576FF8(u, v);                                        {00587521..27 ebp-2C8}
        zzg := zzg + ' * ' + v;                                    {0058749F..3A CatN ebp-38 edx=3}
        if gvar_02536410 = 1 then                                  {0058753F..46 jne->75B8}
        begin
          if Trim(DataModule2.Table1Gebort.AsString) <> '' then    {00587548..78 [560] Trim jbe->75EB}
          begin
            oabk(DataModule2.Table1Gebort.AsString, u);            {0058757A..A1 eax=[ebp-4] ecx=[ebp-2E4]}
            gvar_02536664 := gvar_02536664 + u;                    {005875A6..B1 LStrCat}
          end;
        end
        else
          zzg := zzg + ' ' + DataModule2.Table1Gebort.AsString;    {005875B8..E6 CatN ebp-38 edx=3}
        sub_00576F54(idx, u);                                      {00587614..16}
        gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + u);  {005875EB..3E CatN ebp-2F0 edx=3; jmp 7850}
      end
      else
      begin
        if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or    {00587646..76 [56C] ja->76AE}
           (Trim(DataModule2.Table1Taufort.AsString) <> '') then   {00587678..A8 [570] jbe->7850}
        begin
          u := DataModule2.Table1Tauftag.AsString + '.' +          {005876AE..725 CatN ebp-310 58C950/944}
               DataModule2.Table1Taufmonat.AsString + '.' +
               DataModule2.Table1Taufjahr.AsString;
          sub_00576FF8(u, v);                                      {00587730..36 ebp-30C}
          zzg := zzg + ' ~ ' + v;                                  {005876AE..49 CatN ebp-38 edx=3}
          if gvar_02536410 = 1 then                                {0058774E..55 jne->77C7}
          begin
            if Trim(DataModule2.Table1Taufort.AsString) <> '' then {00587757..87 [570] Trim jbe->77FA}
            begin
              oabk(DataModule2.Table1Taufort.AsString, u);         {00587789..B0}
              gvar_02536664 := gvar_02536664 + u;                  {005877B5..C0 LStrCat}
            end;
          end
          else
            zzg := zzg + ' ' + DataModule2.Table1Taufort.AsString; {005877C7..F5 CatN ebp-38 edx=3}
          sub_00576F54(idx, u);                                    {0058781D..25}
          gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + u); {005877FA..4D CatN ebp-334 edx=3}
        end;
      end;
      { 00587850 - C3e: St-Datum und Verwandte }
      if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or        {00587850..80 [584] ja->78B8}
         (Trim(DataModule2.Table1Stort.AsString) <> '') then       {00587882..B2 [588] jbe->7B40}
      begin
        u := DataModule2.Table1Sttag.AsString + '.' +              {005878B8..2F CatN ebp-354 58C95C/944}
             DataModule2.Table1Stmonat.AsString + '.' +
             DataModule2.Table1Stjahr.AsString;
        sub_00576FF8(u, v);                                        {00587934..40 ebp-350}
        zzg := zzg + ' + ' + v;                                    {005878B8..53 CatN ebp-38 edx=3}
        if gvar_02536410 = 1 then                                  {00587958..5F jne->79D1}
        begin
          if Trim(DataModule2.Table1Stort.AsString) <> '' then     {00587961..91 [588] Trim jbe->7A04}
          begin
            oabk(DataModule2.Table1Stort.AsString, u);             {00587993..BA}
            gvar_02536664 := gvar_02536664 + u;                    {005879BF..CA LStrCat}
          end;
        end
        else
          zzg := zzg + ' ' + DataModule2.Table1Stort.AsString;     {005879D1..FF CatN ebp-38 edx=3}
        sub_00576F54(idx, u);                                      {00587A27..2F}
        gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + u); {00587A04..57 CatN ebp-378 edx=3}
      end;
      if gvar_025363F8 = 1 then                                    {00587A5A..61 jne->7ACD}
        if Trim(DataModule2.Table1Todesurs.AsString) <> '' then    {00587A63..93 [58C] Trim jbe->7ACD}
          zzg := zzg + ' (' + DataModule2.Table1Todesurs.AsString + ')';  {00587A95..C8 CatN ebp-38 edx=4}
      if gvar_025363EC = 1 then                                    {00587ACD..D4 jne->7B40}
        if Trim(DataModule2.Table1Alter.AsString) <> '' then       {00587AD6..06 [5EC] Trim jbe->7B40}
          zzg := zzg + ' (' + DataModule2.Table1Alter.AsString + ')';     {00587B08..3B CatN ebp-38 edx=4}
      if gvar_025363F4 = 1 then                                    {00587B40..47 jne->7C91}
        if Trim(DataModule2.Table1Kommentar.AsString) <> '' then   {00587B4D..7D [5B0] Trim jbe->7C91}
        begin
          Form1.Memo1.Width := Form1.DBMemo1.Width;                {00587B83..A0 DBMemo1+48 -> Memo1 SetWidth}
          Form1.Memo1.Font.Size := Form1.DBMemo1.Font.Size;        {00587BA5..C9 DBMemo1+68 -> Memo1 FontSize}
          Form1.Memo1.Clear;                                       {00587BD1..E0 vtbl+0DC}
          Form1.Memo1.Lines.Assign(DataModule2.Table1Kommentar);   {00587BE6..08 [220]+8 / [5B0]}
          if Form1.Memo1.Lines.Count > 0 then                      {00587C0B..26 [220]+14 dec/test jl->7C91}
          begin
            i := Form1.Memo1.Lines.Count;                          {00587C28..29 [ebp-50]}
            gvar_02536644 := 0;                                    {00587C2C Single-Zeilenindex}
            repeat                                                 {00587C36..C8F}
              zzg := zzg + #13#10 +                                {00587C36..84 CatN ebp-38 edx=3}
                Trim(Form1.Memo1.Lines[Round(gvar_02536644)]);     {00587C5F..6E vtbl+0C en Trim}
              gvar_02536644 := gvar_02536644 + 1;                  {00587C86 inc Single}
              Dec(i);                                              {00587C8C..8F dec [ebp-50] jne}
            until i = 0;
          end;
        end;
      if Trim(Form1.lfbh2Eh.AsString) <> '' then                   {00587C91..C1 [914] Trim jbe->8B920}
      begin
        i := Length(Form1.lfbh2Eh.AsString) div 7;                 {00587CC7..09 LStrLen fild/fdiv 7 ROUND}
        if i > 0 then                                              {00587D01..03 test/jle->8B920}
        begin
          ehn := 1;                                                {00587D0C [ebp-14]}
          repeat                                                   {00587D13 Ehen-Loop (B914: Dec(i) jne->7D13)}
            patn := 0;                                             {00587D15 [ebp-10]}
            erst := 0;                                             {00587D18..1A [ebp-1C]}
            num := DataModule2.Table1Nummer.AsInteger;             {00587D1D..2F [534]+58 -> ebp-0B0}
            leere := False;                                        {00587D35 [ebp-0AC]}
            DataModule2.Table18.FindKey([num]);                    {00587D3C..51 [140] -> 0058B8E6 Eof-Check}
            while not DataModule2.Table18.Eof do                   {00587D56 jmp 0058B8E6: Tail-Kante}
            begin
            u := Copy(Form1.lfbh2Eh.AsString, (ehn - 1) * 7 + 1, 6);      {00587D5B..91 LStrCopy [3C0]}
            if StrToInt(u) = DataModule2.Table18Epnum.AsInteger then      {00587D96..B7 [4CC]+58/edi jne->8A701}
            begin
              patn := DataModule2.Table18Epnum.AsInteger;            {00587DBD..CF [4CC]+58 [ebp-10]}
              if Pos('Ehes', DataModule2.Table18Verbind.AsString) > 0 then  {00587DD2..FC [4F8] LStrPos jle->8479}
              begin
                if Trim(DataModule2.Table18Sajahr.AsString) <> '' then      {00587E02..32 [4EC] Trim jbe->7E94}
                begin
                  Form1.lfbh2.Edit;                                  {00587E34..41 [8B8]}
                  if not gueltig then                                {00587E46..4A [ebp-4A] jne->7E7F}
                    Form1.lfbh2Hei.AsString :=                      {00587E4C..79 [924] lfbh2Hei <-- [4EC] Sajahr}
                      DataModule2.Table18Sajahr.AsString;
                  Form1.lfbh2.Post;                                  {00587E7F..8E +248}
                end;
                if (Trim(DataModule2.Table18Sajahr.AsString) <> '') or      {00587E94..C4 [4EC] ja->7EFC}
                   (Trim(DataModule2.Table18Saort.AsString) <> '') then     {00587EC6..F6 [4F0] jbe->8128}
                begin
                  u := DataModule2.Table18Satag.AsString + '.' +      {00587EFC..7D CatN ebp-3E8 edx=5 58C9A0}
                       DataModule2.Table18Samonat.AsString + '.' +
                       DataModule2.Table18Sajahr.AsString;
                  sub_00576FF8(u, v);                                 {00587F82..8E ebp-3E4}
                  zzg := zzg + #13#10 + #13#10 + '- oo ' + v;         {00587F93..FA1 CatN ebp-38 edx=5}
                  if gvar_02536410 = 1 then                           {00587FA6..AD jne->801F}
                  begin
                    if Trim(DataModule2.Table18Saort.AsString) <> '' then    {00587FAF..DF [4F0] Trim jbe->8052}
                    begin
                      oabk(DataModule2.Table18Saort.AsString, u);      {00587FE1..08 [ebp-4] both}
                      gvar_02536664 := gvar_02536664 + u;              {0058800D..18 LStrCat}
                    end;
                  end
                  else
                    zzg := zzg + ' ' + DataModule2.Table18Saort.AsString;     {0058801F..4D CatN edx=3}
                  sub_00576F54(idx, u);                               {0058807B..7D}
                  gvar_02536444.Add(DataModule2.Table18Saort.AsString + '' + u);  {00588052..A5 CatN ebp-40C edx=3}
                  if gvar_025363FC = 1 then                           {005880A8..AF jne->846A}
                    if Trim(DataModule2.Table18Satrauz.AsString) <> '' then  {005880B5..E5 [4F4] Trim jbe->846A}
                      zzg := zzg + ' (TZ: ' +                          {005880EB..1E CatN ebp-38 edx=4}
                        DataModule2.Table18Satrauz.AsString + ')';
                  { 00588123: jmp 0058846A - Ende 'Ehes' -> Rumpf-Ende }
                end
                else
                begin
                  if (Trim(DataModule2.Table18Hjahr.AsString) <> '') or       {00588128..58 [4D8] Trim ja->8190}
                     (Trim(DataModule2.Table18Hort.AsString) <> '') then      {0058815A..8A [4DC] Trim jbe->844B}
                  begin
                    u := DataModule2.Table18Htag.AsString + '.' +             {00588190..11 CatN ebp-438 edx=5 ' oo '}
                         DataModule2.Table18Hmonat.AsString + '.' +
                         DataModule2.Table18Hjahr.AsString;
                    sub_00576FF8(u, v);                                       {00588216..22 ebp-434}
                    zzg := zzg + #13#10 + #13#10 + '- oo ' + v;               {00588190..30 CatN ebp-38 edx=5}
                    if gvar_02536410 = 1 then                                 {0058823A..41 jne->8349}
                    begin
                      if Trim(DataModule2.Table18Hjahr.AsString) <> '' then   {00588247..77 [4D8] Trim jbe->82D9}
                      begin
                        Form1.lfbh2.Edit;                                     {00588279..86}
                        if not gueltig then                                   {0058828B..8F jne->82C4}
                          Form1.lfbh2Hei.AsString :=                         {00588291..BE [924] lfbh2Hei <-- [4D8] Hjahr}
                            DataModule2.Table18Hjahr.AsString;
                        Form1.lfbh2.Post;                                     {005882C4..D3 +248}
                      end;
                      if Trim(DataModule2.Table18Hort.AsString) <> '' then    {005882D9..09 [4DC] Trim jbe->837C}
                      begin
                        oabk(DataModule2.Table18Hort.AsString, u);            {0058830B..32}
                        gvar_02536664 := gvar_02536664 + u;                   {00588337..42 LStrCat}
                      end;
                    end
                    else
                      zzg := zzg + ' ' + DataModule2.Table18Hort.AsString;    {00588349..77 CatN ebp-38 edx=3}
                    sub_00576F54(idx, u);                                     {0058839F..A7}
                    gvar_02536444.Add(DataModule2.Table18Hort.AsString + '' + u);   {0058837C..CF CatN ebp-468 edx=3}
                    if gvar_025363FC = 1 then                                 {005883D2..D9 jne->846A}
                      if Trim(DataModule2.Table18Trauz.AsString) <> '' then   {005883DF..0F [4E0] Trim jbe->846A}
                        zzg := zzg + ' (TZ: ' +                               {00588411..44 CatN ebp-38 edx=4}
                          DataModule2.Table18Trauz.AsString + ')';
                  end
                  else
                    zzg := zzg + #13#10 + #13#10 + '- oo';                    {0058844B..65 CatN ebp-38 edx=4}
                  zzg := zzg + ': ';                                          {0058846A..72 LStrCat ':' nur 'Ehes'-Pfad}
                end; {temp-C3g}
              end
              else
              begin
                if Pos('Bezie', DataModule2.Table18Verbind.AsString) > 0 then {00588479..A3 [4F8] LStrPos jle->84C4}
                  zzg := zzg + #13#10 + #13#10 + '- o-o : ';                  {005884A5..BF CatN ebp-38 edx=4}
              end; {temp-C3h}
              num := DataModule2.Table18Epnum.AsInteger;             {005884C4..D6 [4CC]+58 -> ebp-0B0}
              leere := False;                                        {005884DC [ebp-0AC]}
              DataModule2.Table1.FindKey([num]);                     {005884E3..F5 [5C]}
              zzg := zzg + ucase(DataModule2.Table1Name.AsString) +  {005884FA..5A CatN ebp-38 edx=4}
                ' ' + DataModule2.Table1Vornamen.AsString;
              bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));         {0058855F..74 [8B8]+150}
              Form1.lfbh2.IndexName := 'Pro';                        {00588577..89 58C8B8}
                num := DataModule2.Table1Vater.AsInteger;                {0058858E..A2 [538]+58 test eax jle->8887D}
                if (num > 0) and (DataModule2.Table1Mutter.AsInteger > 0) then {005885A8..BC [53C] test eax jle->8887D}
              begin
                sub_00576EB0(num, u);                                  {005885C2..DA ebp-490 6-stellig}
                if Form1.lfbh2.FindKey([u]) then                       {005885F2..11 [8B8]+2C4 vtAnsiString test al je->8887D}
                begin
                  if gueltig then                                      {00588617..23 [ebp-4A] jne->88734}
                  begin
                    DataModule2.Table17.Open;                          {00588734..41 [13C]}
                    DataModule2.Table17.IndexName := '';               {00588746..55 edx=0}
                    num := DataModule2.Table1Vater.AsInteger;          {0058875A..69 [538]+58}
                    leere := False;                                    {00588772 [ebp-0AC]}
                    DataModule2.Table17.FindKey([num]);                {00588779..8E findkey}
                    zzg := zzg + ' <' + DataModule2.Table17Name.AsString + ' ' +   {00588793..E9 CatN ebp-38 edx=6}
                           DataModule2.Table17Vornamen.AsString + '/';
                    num := DataModule2.Table1Mutter.AsInteger;         {005887EE..FD [53C]+58}
                    leere := False;                                    {00588806 [ebp-0AC]}
                    DataModule2.Table17.FindKey([num]);                {0058880D..22}
                    zzg := zzg + DataModule2.Table17Name.AsString + ' ' +          {00588827..78 CatN ebp-38 edx=5}
                           DataModule2.Table17Vornamen.AsString + '>';
                  end
                  else
                  begin
                    while not Form1.lfbh2.Eof do                       {005886F0..E8 Loop-Top}
                    begin
                      if StrToInt(Form1.lfbh2Prob.AsString) =          {005886F0..0E [910] StrToInt edi}
                         DataModule2.Table1Vater.AsInteger then        {00588715..29 [538]+58 je->88626}
                      begin
                        sub_00576EB0(DataModule2.Table1Mutter.AsInteger, u); {00588645..6D [53C] -> ebp-498}
                        if Pos(u + '*', Form1.lfbh2Eh.AsString) > 0 then {00588662..80 LStrCat/LStrPos jle->86C4}
                        begin
                          zzg := zzg + ' [aus ' +                     {00588682..BA CatN ebp-38 edx=4}
                            IntToStr(Form1.lfbh2Nm.AsInteger) + ']';
                          Break;                                      {005886BF jmp 0058887D}
                        end;
                        Form1.lfbh2.Next;                             {005886C4..D1 TDataSet.Next}
                      end
                      else
                        Break;                                        {0058872F jmp 0058887D}
                      if Form1.lfbh2.Eof then                         {005886D3..E1 cmp [0A1] jne->8887D}
                        Break;
                    end;
                  end;
                end;
              end;
              Form1.lfbh2.IndexName := 'na';                          {0058887D..F 58C8DC}
              if gueltig then                                         {00588894..98 je->88B1}
                Form1.lfbh2.IndexName := 'heir';                      {0058889A..AC 58C8E8}
              Form1.lfbh2.GotoBookmark(bmk);                          {005888B1..C3 vtbl+1A0 bmk [ebp-28]}
              if Trim(DataModule2.Table1Name.AsString) <> '' then     {005888C9..F9 [540] Trim jbe->8B37}
              begin
                if gvar_02536414 = 1 then                             {005888FF..06 jne->8AE1?}
                  if gvar_02536418 = 1 then                           {0058890C..13 jne->8A66?}
                  begin
                    if DataModule2.Table1Gebjahr.AsString <> '' then  {00588919..41 [55C] LStrCmp jbe->89E8}
                    begin
                      sub_00576F54(idx, u);                           {005889B0..B8}
                      gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +     {00588947..CE CatN ebp-4C0 edx=7}
                        DataModule2.Table1Vornamen.AsString + ' * ' +
                        DataModule2.Table1Gebjahr.AsString + '' + u);
                    end
                    else
                    begin
                      sub_00576F54(idx, u);                           {00588A2E..34}
                      gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +     {005889E8..AE CatN ebp-4E4 edx=5}
                        DataModule2.Table1Vornamen.AsString + '' + u);
                    end;                                              {005889E3 jmp 00588B37}
                  end
                  else
                  begin
                    sub_00576F54(idx, u);                             {00588A8A..8E?}
                    gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' +       {00588A66..? CatN ebp-4EC edx=5}
                      DataModule2.Table1Vornamen.AsString + '' + u);
                  end
                else
                begin
                  sub_00576F54(idx, u);                               {00588AF5..FD?}
                  gvar_02536440.Add(DataModule2.Table1Name.AsString + '' + u);      {00588AE1..EC CatN ebp-4F4 edx=3}
                end;
              end;
              if gueltig then                                          {00588B37..3B jne->8A3C Hoch katam Konvergenz}
                zzg := zzg + ' Haus ' + DataModule2.Table1Namex.AsString;  {00588AB2..B6 CatN ebp-38 edx=3}
              RedVar24 := 'Haus';                                      {00588AC2..CA [ebp-4AC] vtAnsiString}
              if DataModule2.Table1Geschlecht.AsString = 'w' then      {00588AD2..DC jz->8AC8}
                RedVar24 := RedVar24 + 'in';                           {00588AC8..D2 LStrCat}
              if gvar_02536404 = 1 then                                {00588B37..3E jne->8BA5}
              begin
                if Trim(DataModule2.Table1Religion.AsString) <> '' then {00588B40..70 [54C] jbe->8BA5}
                  zzg := zzg + ', ' + DataModule2.Table1Religion.AsString; {00588B72..A0 CatN ebp-38 edx=3}
              end;
              if gvar_025363F0 = 1 then                                {00588BA5..AC jne->8C7C}
                zzg := zzg + RedVar24;
              if Trim(DataModule2.Table1Beruf.AsString) <> '' then     {00588BB2..F2 [550] jz->8C17}
                zzg := zzg + ', ' + DataModule2.Table1Beruf.AsString;  {00588BE4..8C12 CatN ebp-38 edx=3}
              if Trim(DataModule2.Table1Hausname.AsString) <> '' then  {00588C17..47 [5C8] jbe->8C7C}
                zzg := zzg + ' ' + DataModule2.Table1Hausname.AsString; {00588C49..77 CatN ebp-38 edx=3}
              { 00588C7C Geb-Block k2 }
              if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or
                 (Trim(DataModule2.Table1Gebort.AsString) <> '') then begin
                zzg := zzg + ' * ' + Trim(DataModule2.Table1Gebtag.AsString) + '.' + Trim(DataModule2.Table1Gebmonat.AsString) + '.' + Trim(DataModule2.Table1Gebjahr.AsString); {00588CE4..7F CatN ebp-38 edx=5 (5 pushes) 58C904 + 58C944 '.' + 58C944 '.' + 58C944}
                sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' + DataModule2.Table1Gebmonat.AsString + '.' + DataModule2.Table1Gebjahr.AsString, v); {00588D50..71 Call ebp-538/534}
                zzg := zzg + v;
                if gvar_02536410 = 1 then begin {00588D84..8B}
                  if Trim(DataModule2.Table1Gebort.AsString) <> '' then begin
                    oabk(DataModule2.Table1Gebort.AsString, v);       {00588DBF..F6 Call [ebp-4] self oabk}
                    gvar_02536664 := gvar_02536664 + v;               {00588DF6..FD LStrCat}
                  end;
                end else begin                                        {00588DFD..2B (3 pushes) 58C8F8}
                  zzg := zzg + ' ' + DataModule2.Table1Gebort.AsString;
                end;
                sub_00576F54(idx, v);                                  {00588E4E..71 Call ebx/ebp-560/564}
                gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + v); {00588E76..83 CatN ebp-55C edx=3}
              end else begin                                           {00588E8B..EB 570 Trim [Taufort] jbe->00589095}
                if (Trim(DataModule2.Table1Taufort.AsString) <> '') or
                   (Trim(DataModule2.Table1Taufjahr.AsString) <> '') then begin {00588EF3..B6 56C/570}
                  zzg := zzg + ' ~ ' + Trim(DataModule2.Table1Tauftag.AsString) + '.' + Trim(DataModule2.Table1Taufmonat.AsString) + '.' + Trim(DataModule2.Table1Taufjahr.AsString); {00588F19..71 CatN ebp-57C edx=5}
                  sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' + DataModule2.Table1Taufmonat.AsString + '.' + DataModule2.Table1Taufjahr.AsString, v); {00588F75..8E Call}
                  zzg := zzg + v;
                  if gvar_02536410 = 1 then begin {00588F93..A4}
                    if Trim(DataModule2.Table1Taufort.AsString) <> '' then begin
                      oabk(DataModule2.Table1Taufort.AsString, v);     {00588FF5..05}
                      gvar_02536664 := gvar_02536664 + v;             {00589000..0A}
                    end;
                  end else begin
                    zzg := zzg + ' ' + DataModule2.Table1Taufort.AsString;
                  end;
                  sub_00576F54(idx, v);
                  gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + v); {00589075..92}
                end;
              end;
              { 00589095 St-Block }
              if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or
                 (Trim(DataModule2.Table1Stort.AsString) <> '') then begin {00589095..F7 [584]/[588] ja->90FD nein->9385}
                zzg := zzg + ' + ' + Trim(DataModule2.Table1Sttag.AsString) + '.' + Trim(DataModule2.Table1Stmonat.AsString) + '.' + Trim(DataModule2.Table1Stjahr.AsString); {005890FD..98 CatN ebp-38 edx=5}
                sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' + DataModule2.Table1Stmonat.AsString + '.' + DataModule2.Table1Stjahr.AsString, v); {00589179..85}
                zzg := zzg + v;
                if gvar_02536410 = 1 then begin {0058919D..A4}
                  if Trim(DataModule2.Table1Stort.AsString) <> '' then begin
                    oabk(DataModule2.Table1Stort.AsString, v);        {005891FF..0F}
                    gvar_02536664 := gvar_02536664 + v;               {0058920A..14}
                  end;
                end else begin
                  zzg := zzg + ' ' + DataModule2.Table1Stort.AsString;
                end;
                sub_00576F54(idx, v);
                gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + v); {0058927F..9C}
              end;
              if gvar_025363F8 = 1 then begin {0058929F..A6}
                if Trim(DataModule2.Table1Todesurs.AsString) <> '' then
                  zzg := zzg + ' (' + DataModule2.Table1Todesurs.AsString + ')'; {005892DA..0D CatN ebp-38 edx=4}
              end;
              if gvar_025363EC = 1 then begin {00589312..19}
                if Trim(DataModule2.Table1Alter.AsString) <> '' then
                  zzg := zzg + ' (' + DataModule2.Table1Alter.AsString + ')'; {0058934D..80}
              end;
              { 00589385 Notiz-Block }
              if gvar_025363F4 = 1 then begin {00589385..8C}
                if Trim(DataModule2.Table1Kommentar.AsString) <> '' then begin
                  Form1.Memo1.Clear;                                    {005893C8..DD}
                  Form1.Memo1.Lines.Add(DataModule2.Table1Kommentar.AsString); {005893DD..FF}
                  if Form1.Memo1.Lines.Count > 0 then                   {0058941A..1D}
                    for i := Form1.Memo1.Lines.Count - 1 downto 0 do     {00589420 gvar_02536644:=0}
                      zzg := zzg + #13#10 + Trim(Form1.Memo1.Lines[i]); {0058942D..86 Loop}
                end;
              end;
              { 00589488 Table1.FindKey + Geschlecht-Weiche }
              DataModule2.Table1.IndexName := '';                     {00589488..99}
              DataModule2.Table1.First;                               {00589499..A3}
              perNr := DataModule2.Table1Nummer.AsInteger;             {005894A8 esi}
              leere := False;                                          {005894AE}
              DataModule2.Table1.FindKey([perNr]);                    {005894B5..C7}
              if UpperCase(DataModule2.Table1Geschlecht.AsString) <> 'M' then begin {005894CC..05 jne->0058A691 M-Exit; W-Zweig ab 0058A701}
                { nicht 'M': ueberspringt den M-Zweig, faellt zum M-Exit 0058A691 }
              end else begin
                unkMut := '';                                          {0058950B..13 LStrClr}
                DataModule2.Table1.IndexName := 'vat';                 {00589513..22}
                DataModule2.Table1.First;                              {00589527..31}
                if patn <= 0 then begin                                {00589536..3A jle->0058A691}
                  { patn<=0: faellt ebenso zum M-Exit 0058A691 }
                end else begin
                  DataModule2.Table1.FindKey([perNr]);                 {00589540..5F}
                  if DataModule2.Table1.Found then                     {00589564..66 je->0058A691}
                  while DataModule2.Table1Vater.AsInteger = perNr do begin {0058A603..17 [538] cmp esi; je->00589571 COND}
                    if DataModule2.Table1Mutter.AsInteger = patn then begin {00589571..86 [53C] jne->98BE}
                      Inc(kcount);                                     {0058958C}
                      Inc(erst);                                       {0058958F}
                      if erst = 1 then                                 {00589592..96 jne->95B7}
                        zzg := zzg + #13#10#13#10'Kind(er): ';         {00589598..B2 CatN ebp-38 edx=4}
                      if Form24.CheckBox14.Checked then                 {005895B7..CE je->00589B9B}
                      begin
                        zzg := zzg + #13#10' - ' + IntToStr(kcount) + '. ' +
                          DataModule2.Table1Name.AsString + ' ' +
                          DataModule2.Table1Vornamen.AsString;          {005895D4..43 CatN ebp-38 edx=8}
                        if Trim(DataModule2.Table1Name.AsString) <> '' then begin {00589648..78}
                          if gvar_02536414 = 1 then                     {0058967E..85 jne->00589B9B}
                            if gvar_02536418 = 1 then                   {0058968B..92 jne->97E5}
                            begin
                              if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then begin {00589698..C0}
                                sub_00576F54(idx, v);
                                gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + ' * ' + DataModule2.Table1Gebjahr.AsString + v); {005896C6..5F CatN ebp-638 edx=7}
                              end else begin
                                sub_00576F54(idx, v);
                                gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {00589767..D0 edx=5}
                              end;
                            end else begin
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {005897E5..4E edx=5}
                            end;
                        end else begin
                          sub_00576F54(idx, v);
                          gvar_02536440.Add(DataModule2.Table1Name.AsString + v); {00589863..B9 edx=3}
                        end;
                      end;
                      { jmp 00589B9B; }                                    {00589762..9B}
                    end else begin
                      zzg := zzg + ' - ' + IntToStr(kcount) + '. ' +    {005898BE..28 edx=7}
                        DataModule2.Table1Name.AsString + ' ' +
                        DataModule2.Table1Vornamen.AsString;
                      if Trim(DataModule2.Table1Name.AsString) <> '' then begin {0058992D..5D}
                        if gvar_02536414 = 1 then                       {00589963..6A jne->9B45}
                          if gvar_02536418 = 1 then                     {00589970..77 jne->9ACA}
                          begin
                            if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then begin {0058997D..A5}
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + ' * ' + DataModule2.Table1Gebjahr.AsString + v); {005899AB..32 edx=7}
                            end else begin
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {00589A4C..B0 edx=5}
                            end;
                          end else begin
                            sub_00576F54(idx, v);
                            gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {00589ACA..2E edx=5}
                          end;
                      end else begin
                        sub_00576F54(idx, v);
                        gvar_02536440.Add(DataModule2.Table1Name.AsString + v); {00589B45..8B edx=3}
                      end;
                      { jmp 00589B9B; }                                     {00589AC5..B9B}
                    end;
                  { 00589B9B [20]-Marker + lfbh2-Scan-Loop }
                  kopf := False;                                           {00589B9B..9D xor eax -> [ebp-20]}
                  gvar_02536454 := Form1.lfbh2.IndexName;                  {00589BA0..C3 GetIndexName -> LStrAsg}
                  bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));           {00589BC8..DD vtbl+150 -> [ebp-24]}
                  Form1.lfbh2.IndexName := 'Pro';                          {00589BE0..F2}
                  Form1.lfbh2.First;                                       {00589BF7..C04}
                  u := '';
                  sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u);     {00589C09..26 [534] vtbl+58}
                  if Form1.lfbh2.FindKey([u]) then                         {00589C2C..58 vtbl+2C4 je->9C9E}
                  begin
                    zzg := zzg + ' [' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {00589C5A..92 CatN ebp-38 edx=4}
                    kopf := True;                                          {00589C97 [ebp-20]:=1}
                  end;
                  Form1.lfbh2.First;                                       {00589C9E..AB}
                  if not gueltig then                                      {00589CB0..B4 jne->9DA1}
                  begin
                    while not Form1.lfbh2.Eof do begin                    {00589D87 test [8B8+0A1] je->9CBF}
                      u := '';
                      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {00589CBF..F6}
                      u := u + '*';
                      if Pos(u, Form1.lfbh2Eh.AsString) > 0 then           {00589D0B..19 LStrPos jle->9D5F}
                      begin
                        zzg := zzg + ' [oo ' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {00589D1B..53 edx=4}
                        kopf := True;                                      {00589D58}
                      end;
                      Form1.lfbh2.Next;                                    {00589D5F..6C}
                    end;
                  end;
                  Form1.lfbh2.IndexName := gvar_02536454;                  {00589DA1..B4}
                  Form1.lfbh2.GotoBookmark(bmk);                           {00589DB9..CB vtbl+1A0}
                  if kopf then                                             {00589DD1..D5 jne->0058A603}
                  begin
                    { 00589DD1..D5 jne->0058A603 (COND): im Recon laeuft es in den Kind-Loop-Tail }
                  end else
                  begin
                    { 00589DDB gespiegelter Hauptkörper (kein ' ['-Marker) }
                    if gvar_02536404 = 1 then                               {00589DDB..E2 jne->9E49}
                    begin
                      if Trim(DataModule2.Table1Religion.AsString) <> '' then
                        zzg := zzg + ', ' + DataModule2.Table1Religion.AsString; {00589E16..44 edx=3}
                    end;
                    if gvar_025363F0 = 1 then                               {00589E49..50 jne->9F20}
                    begin
                      if Trim(DataModule2.Table1Beruf.AsString) <> '' then
                        zzg := zzg + ', ' + DataModule2.Table1Beruf.AsString; {00589E88..B6 edx=3}
                    end;
                    if Trim(DataModule2.Table1Hausname.AsString) <> '' then {00589EBB..EB}
                      zzg := zzg + ' ' + DataModule2.Table1Hausname.AsString; {00589EED..1B}
                    if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or
                       (Trim(DataModule2.Table1Gebort.AsString) <> '') then begin {00589F20..82 ja->9F88 nein->A12F}
                      zzg := zzg + ' * ' + Trim(DataModule2.Table1Gebtag.AsString) + '.' + Trim(DataModule2.Table1Gebmonat.AsString) + '.' + Trim(DataModule2.Table1Gebjahr.AsString); {00589F88..FFF}
                      sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' + DataModule2.Table1Gebmonat.AsString + '.' + DataModule2.Table1Gebjahr.AsString, v); {0058A004..23}
                      zzg := zzg + v;
                      if gvar_02536410 = 1 then begin
                        if Trim(DataModule2.Table1Gebort.AsString) <> '' then begin
                          oabk(DataModule2.Table1Gebort.AsString, v);      {0058A087..9A}
                          gvar_02536664 := gvar_02536664 + v;
                        end;
                      end else
                        zzg := zzg + ' ' + DataModule2.Table1Gebort.AsString;
                      sub_00576F54(idx, v);
                      gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + v); {0058A10A..27}
                    end else begin
                      if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or
                         (Trim(DataModule2.Table1Taufort.AsString) <> '') then begin {0058A12F..91 ja->A197}
                        zzg := zzg + ' ~ ' + Trim(DataModule2.Table1Tauftag.AsString) + '.' + Trim(DataModule2.Table1Taufmonat.AsString) + '.' + Trim(DataModule2.Table1Taufjahr.AsString); {0058A197..20E}
                        sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' + DataModule2.Table1Taufmonat.AsString + '.' + DataModule2.Table1Taufjahr.AsString, v); {0058A213..32}
                        zzg := zzg + v;
                        if gvar_02536410 = 1 then begin
                          if Trim(DataModule2.Table1Taufort.AsString) <> '' then begin
                            oabk(DataModule2.Table1Taufort.AsString, v);    {0058A296..A9}
                            gvar_02536664 := gvar_02536664 + v;
                          end;
                        end else
                          zzg := zzg + ' ' + DataModule2.Table1Taufort.AsString;
                        sub_00576F54(idx, v);
                        gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + v); {0058A319..36}
                      end;
                    end;
                    if gvar_02536400 = 1 then begin                        {0058A339..40 jne->A3AC}
                      if Trim(DataModule2.Table1Taufpat.AsString) <> '' then {0058A342..72}
                        zzg := zzg + ' (TP: ' + DataModule2.Table1Taufpat.AsString + ')'; {0058A374..A7 edx=4}
                    end;
                    { 0058A3AC St-Block gespiegelt }
                    if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or
                       (Trim(DataModule2.Table1Stort.AsString) <> '') then begin {0058A3AC..0E ja->A414 nein->A5B6}
                      zzg := zzg + ' + ' + Trim(DataModule2.Table1Sttag.AsString) + '.' + Trim(DataModule2.Table1Stmonat.AsString) + '.' + Trim(DataModule2.Table1Stjahr.AsString); {0058A414..8B}
                      sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' + DataModule2.Table1Stmonat.AsString + '.' + DataModule2.Table1Stjahr.AsString, v); {0058A490..AF}
                      zzg := zzg + v;
                      if gvar_02536410 = 1 then begin
                        if Trim(DataModule2.Table1Stort.AsString) <> '' then begin
                          oabk(DataModule2.Table1Stort.AsString, v);       {0058A516..26}
                          gvar_02536664 := gvar_02536664 + v;
                        end;
                      end else
                        zzg := zzg + ' ' + DataModule2.Table1Stort.AsString;
                      sub_00576F54(idx, v);
                      gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + v); {0058A596..B3}
                    end;
                    if gvar_025363F4 = 1 then begin                        {0058A5B6..BD}
                      zzg := zzg + ' ' + Trim(DataModule2.Table1Kommentar.AsString); {0058A5BF..FE edx=3}
                    end;
                  end;
                  { 0058A61D Kind-Loop-Tail (T1-Paradox-Fix: 3 Kanten getauscht, s. Recon-Notizen) }
                  if DataModule2.Table1Mutter.AsInteger = 0 then         {0058A61D..31 [53C] jne->A66B}
                  begin
                    u := '';
                    sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058A633..4E}
                    unkMut := unkMut + u + '*';                           {0058A653..66 CatN ebp-40 edx=3}
                  end;
                  DataModule2.Table1.Next;                                {0058A66B..75}
                  if DataModule2.Table1.Eof then                          {0058A67A..8B jne->0058B914; Abw.: ofb2 00593079 -> M-Exit}
                    Break;
                  end;
                end;
              end;
              { 0058A691 Mutter-nicht-bekannt + W-Zweig }
              if Trim(unkMut) <> '' then                                {0058A691..A6}
              begin
                u := '';
                illki(unkMut, idx, u);                                  {0058A6C4 Call self}
                zzg := zzg + #13#10 + 'Mutter nicht bekannt: ' + u;     {0058A6A8..D7 CatN ebp-38 edx=4}
              end;
              DataModule2.Table1.IndexName := '';                       {0058A6DC..E8}
              DataModule2.Table1.First;                                 {0058A6ED..F7}
              { 0058A6FC jmp 0058B827: ueberspringt den W-Zweig (else-Block ab 0058A701) }
            end else begin
            { 0058A701 W-Zweig }
            if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then begin {0058A701..3A jne->0058B827}
              unkVat := '';                                            {0058A740..43 LStrClr ebp-44}
              DataModule2.Table1.IndexName := 'mut';                   {0058A748..57}
              DataModule2.Table1.First;                                {0058A75C..66}
              if patn > 0 then begin                                   {00589536->A76B analog: patn>0}
                DataModule2.Table1.FindKey([perNr]);                   {0058A76B..8A}
                if DataModule2.Table1.Found then                        {0058A78F..91 je->0058B827}
                while not DataModule2.Table1.Eof do begin              {0058B80D -> 0058A79C Loop}
                  if DataModule2.Table1Vater.AsInteger = patn then begin {0058A79C..B1 [538] jne->B79D}
                    Inc(kcount);                                       {0058A7B7}
                    Inc(erst);                                         {0058A7BA}
                    if erst = 1 then                                   {0058A7BD..C1}
                      zzg := zzg + #13#10#13#10'Kind(er): ';           {0058A7C3..DD}
                    if Form24.CheckBox14.Checked then                   {0058A7E2..F9 je->0058AAE9}
                    begin
                      zzg := zzg + #13#10' - ' + IntToStr(kcount) + '. ' + {0058A7FF..6E edx=8}
                        DataModule2.Table1Name.AsString + ' ' +
                        DataModule2.Table1Vornamen.AsString;
                      if Trim(DataModule2.Table1Name.AsString) <> '' then begin {0058A873..A3}
                        if gvar_02536414 = 1 then                       {0058A8A9..B0 jne->0058AA8E}
                          if gvar_02536418 = 1 then                     {0058A8B6..BD jne->AA10}
                          begin
                            if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then begin {0058A8C3..EB}
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + ' * ' + DataModule2.Table1Gebjahr.AsString + v); {0058A8F1..78 edx=7}
                            end else begin
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {0058A992..F6 edx=5}
                            end;
                          end else begin
                            sub_00576F54(idx, v);
                            gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {0058AA10..74 edx=5}
                          end;
                      end else begin
                        sub_00576F54(idx, v);
                        gvar_02536440.Add(DataModule2.Table1Name.AsString + v); {0058AA8E..E1 edx=3}
                      end;
                    end else begin
                      zzg := zzg + ' - ' + IntToStr(kcount) + '. ' +    {0058AAE9..53 edx=7}
                        DataModule2.Table1Name.AsString + ' ' +
                        DataModule2.Table1Vornamen.AsString;
                      if Trim(DataModule2.Table1Name.AsString) <> '' then begin {0058AB58..88}
                        if gvar_02536414 = 1 then                       {0058AB8E..95 jne->AD70}
                          if gvar_02536418 = 1 then                     {0058AB9B..A2 jne->ACF5}
                          begin
                            if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then begin {0058ABA8..D0}
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + ' * ' + DataModule2.Table1Gebjahr.AsString + v); {0058ABD6..5D edx=7}
                            end else begin
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {0058AC77..DB edx=5}
                            end;
                          end else begin
                            sub_00576F54(idx, v);
                            gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {0058ACF5..59 edx=5}
                          end;
                      end else begin
                        sub_00576F54(idx, v);
                        gvar_02536440.Add(DataModule2.Table1Name.AsString + v); {0058AD70..C3 edx=3}
                      end;
                    end;
                    { 0058ADC6 [20]-Marker W + lfbh2-Scan-Loop }
                    kopf := False;                                     {0058ADC6..C9 xor eax}
                    gvar_02536454 := Form1.lfbh2.IndexName;            {0058ADCC..E9}
                    bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));     {0058AEE0 vtbl+150}
                    Form1.lfbh2.IndexName := 'Pro';                    {0058AE13..18}
                    Form1.lfbh2.First;                                 {0058AE2A..2F}
                    u := '';
                    sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058AE3C..47 [534]}
                    if Form1.lfbh2.FindKey([u]) then                   {0058AE72..7E je->AEC4}
                    begin
                      zzg := zzg + ' [' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {0058AE80..B8}
                      kopf := True;                                    {0058AEBD}
                    end;
                    Form1.lfbh2.First;                                 {0058AEC4..D3}
                    if not gueltig then                                {0058AEDA jne->AFC7}
                    begin
                      while not Form1.lfbh2.Eof do begin              {0058AFC1 je->AEE5}
                        u := '';
                        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058AEE5..1C}
                        u := u + '*';
                        if Pos(u, Form1.lfbh2Eh.AsString) > 0 then     {0058AF38..3F jle->AF85}
                        begin
                          zzg := zzg + ' [oo ' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {0058AF41..79}
                          kopf := True;                                {0058AF7E}
                        end;
                        Form1.lfbh2.Next;                              {0058AF85..92}
                      end;
                    end;
                    Form1.lfbh2.IndexName := gvar_02536454;            {0058AFC7..D4}
                    Form1.lfbh2.GotoBookmark(bmk);                     {0058AFF1}
                    if kopf then                                       {0058AFFB jne->0058B7EB}
                    begin
                      { Table1.Next / W-Loop-Tail }
                    end else
                    begin
                      { 0058B001 gespiegelter Hauptkörper W }
                      if gvar_02536404 = 1 then                       {0058B001..08 jne->B06F}
                      begin
                        if Trim(DataModule2.Table1Religion.AsString) <> '' then
                          zzg := zzg + ', ' + DataModule2.Table1Religion.AsString; {0058B00A..6A edx=3}
                      end;
                      if gvar_025363F0 = 1 then                       {0058B06F..76 jne->B146}
                      begin
                        if Trim(DataModule2.Table1Beruf.AsString) <> '' then
                          zzg := zzg + ', ' + DataModule2.Table1Beruf.AsString; {0058B07C..D4 edx=3}
                      end;
                      if Trim(DataModule2.Table1Hausname.AsString) <> '' then {0058B0E1..11}
                        zzg := zzg + ' ' + DataModule2.Table1Hausname.AsString; {0058B113..41}
                      if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or
                         (Trim(DataModule2.Table1Gebort.AsString) <> '') then begin {0058B146..A8 ja->B1AE nein->B329}
                        zzg := zzg + ' * ' + Trim(DataModule2.Table1Gebtag.AsString) + '.' + Trim(DataModule2.Table1Gebmonat.AsString) + '.' + Trim(DataModule2.Table1Gebjahr.AsString); {0058B1AE..FF}
                        sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' + DataModule2.Table1Gebmonat.AsString + '.' + DataModule2.Table1Gebjahr.AsString, v); {0058B204..36}
                        zzg := zzg + v;
                        if gvar_02536410 = 1 then begin
                          if Trim(DataModule2.Table1Gebort.AsString) <> '' then begin
                            oabk(DataModule2.Table1Gebort.AsString, v); {0058B257..B4}
                            gvar_02536664 := gvar_02536664 + v;
                          end;
                        end else
                          zzg := zzg + ' ' + DataModule2.Table1Gebort.AsString;
                        sub_00576F54(idx, v);
                        gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + v); {0058B2CE..24}
                      end else begin
                        if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or
                           (Trim(DataModule2.Table1Taufort.AsString) <> '') then begin {0058B329..8B ja->B391 nein->B527}
                          zzg := zzg + ' ~ ' + Trim(DataModule2.Table1Tauftag.AsString) + '.' + Trim(DataModule2.Table1Taufmonat.AsString) + '.' + Trim(DataModule2.Table1Taufjahr.AsString); {0058B391..F7}
                          sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' + DataModule2.Table1Taufmonat.AsString + '.' + DataModule2.Table1Taufjahr.AsString, v); {0058B3FD..0D}
                          zzg := zzg + v;
                          if gvar_02536410 = 1 then begin
                            if Trim(DataModule2.Table1Taufort.AsString) <> '' then begin
                              oabk(DataModule2.Table1Taufort.AsString, v); {0058B45D..BA}
                              gvar_02536664 := gvar_02536664 + v;
                            end;
                          end else
                            zzg := zzg + ' ' + DataModule2.Table1Taufort.AsString;
                          sub_00576F54(idx, v);
                          gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + v); {0058B4D1..24}
                        end;
                      end;
                      if gvar_02536400 = 1 then begin                {0058B527..2E jne->B59A}
                        if Trim(DataModule2.Table1Taufpat.AsString) <> '' then {0058B530..60}
                          zzg := zzg + ' (TP: ' + DataModule2.Table1Taufpat.AsString + ')'; {0058B562..95 edx=4}
                      end;
                      { 0058B59A St-Block gespiegelt W }
                      if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or
                         (Trim(DataModule2.Table1Stort.AsString) <> '') then begin {0058B59A..FC ja->B602 nein->B7EB}
                        zzg := zzg + ' + ' + Trim(DataModule2.Table1Sttag.AsString) + '.' + Trim(DataModule2.Table1Stmonat.AsString) + '.' + Trim(DataModule2.Table1Stjahr.AsString); {0058B602..79}
                        sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' + DataModule2.Table1Stmonat.AsString + '.' + DataModule2.Table1Stjahr.AsString, v); {0058B67E..8A}
                        zzg := zzg + v;
                        if gvar_02536410 = 1 then begin
                          if Trim(DataModule2.Table1Stort.AsString) <> '' then begin
                            oabk(DataModule2.Table1Stort.AsString, v); {0058B6CE..2B}
                            gvar_02536664 := gvar_02536664 + v;
                          end;
                        end else
                          zzg := zzg + ' ' + DataModule2.Table1Stort.AsString;
                        sub_00576F54(idx, v);
                        gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + v); {0058B745..98}
                      end;
                    end;
                  end else begin
                    { 0058B79D Vater=0 -> unkVat }
                    if DataModule2.Table1Vater.AsInteger = 0 then      {0058B79D..B1 jne->B7EB}
                    begin
                      u := '';
                      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058B7B3..CE}
                      unkVat := unkVat + u + '*';                       {0058B7D3..E6}
                    end;
                  end;
                  { 0058B7EB W-Loop-Tail }
                  DataModule2.Table1.Next;                              {0058B7EB..F5}
                  if DataModule2.Table1.Eof then                        {0058B804..0B jne->0058B827}
                    Break;
                  if DataModule2.Table1Mutter.AsInteger = perNr then    {0058B80D..21 [53C] je->0058A79C}
                    Continue
                  else
                    Break;
                end;
              end;
            end;
            end;
            { 0058B827 Vater-nicht-bekannt (unkVat) + Reset + FindKey }
            if Trim(unkVat) <> '' then                                  {0058B827..3C}
            begin
              u := '';
              illki(unkVat, idx, u);                                    {0058B84B..5A}
              zzg := zzg + #13#10 + 'Vater nicht bekannt: ' + u;         {0058B83E..6D edx=4}
            end;
            unkVat := '';                                                {0058B872..75 LStrClr}
            DataModule2.Table1.IndexName := '';                          {0058B87A..86}
            DataModule2.Table1.First;                                    {0058B88B..95}
            DataModule2.Table1.FindKey([perNr]);                         {0058B89A..C9}
              { 0058B8E4 Table18-Loop-Tail }
              DataModule2.Table18.Next;                              {0058B8C5..D0 [140]}
              if DataModule2.Table18.Eof then                        {0058B8DD..E4 jne->0058B914}
                Break;
              if DataModule2.Table18Nummer.AsInteger =                {0058B8E6..0E [4C8]/[534] je->00587D5B}
                 DataModule2.Table1Nummer.AsInteger then
                Continue
              else
                Break;                                               {->0058B914}
            end;                                                     { Table18-Loop-Ende }
            Inc(ehn);                                                {0058B914 [ebp-14]}
            Dec(i);                                                  {0058B917..1A jne->00587D13}
          until i = 0;                                               { Ehen-Loop-Ende }
        end; { i > 0 - 0058B920 auch bei jle->8B920 erreichbar }
      end; { Eh-Check - 0058B920 auch bei jbe->8B920 erreichbar }
          { 0058B920 Table14-Write }
          DataModule2.Table14Zeile.AsString := zzg;                  {0058B920..32 [1E8]+0B0 edx=[ebp-38]}
          { 0058B938 2. Pass: Reset + Geschlecht -> IndexName }
          DataModule2.Table1.IndexName := '';                        {0058B938..44 [5C]}
          DataModule2.Table1.First;                                  {0058B949..53}
          DataModule2.Table1.FindKey([perNr]);                       {0058B958..77}
          if Trim(Form1.lfbh2Eh.AsString) = '000000*' then           {0058B97C..B5 jne->0058BF75}
          begin
            if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then begin {0058B9BB..F4}
              DataModule2.Table1.IndexName := 'vat';                 {0058B9F6..A05}
            end else
            if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then begin {0058BA0C..45}
              DataModule2.Table1.IndexName := 'mut';                 {0058BA47..56}
            end;
            if DataModule2.Table1.IndexName = 'vat' then             {0058BA5B..80 jne->0058BCE8}
            begin
              if DataModule2.Table1.FindKey([perNr]) then            {0058BA86..AC je->BCE8}
              begin
                while not DataModule2.Table1.Eof do begin            {0058BCCE je->BAB7}
                  if DataModule2.Table1Mutter.AsInteger = 0 then     {0058BAB7..CB jne->BCAC}
                  begin
                    kopf := False;                                   {0058BAD1..D3}
                    gvar_02536454 := Form1.lfbh2.IndexName;          {0058BAD6..F9}
                    bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));   {0058BAFE..BB0B vtbl+150}
                    Form1.lfbh2.IndexName := 'Pro';                  {0058BB16..28}
                    Form1.lfbh2.First;                               {0058BB2D..3A}
                    u := '';
                    sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058BB3F..57}
                    if Form1.lfbh2.FindKey([u]) then                 {0058BB6F..8E je->BB97}
                      kopf := True;                                  {0058BB90}
                    Form1.lfbh2.IndexName := gvar_02536454;          {0058BB97..BAA}
                    Form1.lfbh2.GotoBookmark(bmk);                   {0058BBC1}
                    if kopf then                                     {0058BBCB jne->BCAC}
                    begin
                      u := '';
                      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058BBFB..C13}
                      u := u + '*';
                      v := '';
                      illki(u, idx, v);                              {0058BC33 Call self edx=u ecx=ebx}
                      if Pos('Mutter nicht bekannt: ', zzg) = 0 then {0058BBD1..E0 jne->BC4D}
                        zzg := zzg + #13#10#13#10'Kind(er), Mutter nicht bekannt: - ' + v {0058BBE2..46 edx=5}
                      else
                        zzg := zzg + ' - ' + v;                      {0058BC4D..A7 edx=3}
                    end;
                  end;
                  DataModule2.Table1.Next;                           {0058BCAC..B6}
                  if DataModule2.Table1.Eof then                     {0058BCBB..CC jne->0058BCE8}
                    Break;
                  if DataModule2.Table1Vater.AsInteger = perNr then  {0058BCCE..E2 [538] je->0058BAB7}
                    Continue
                  else
                    Break;                                           {->0058BCE8}
                end;
              end;
            end;
            if DataModule2.Table1.IndexName = 'mut' then             {0058BCE8..0D jne->0058BF75}
            begin
              if DataModule2.Table1.FindKey([perNr]) then            {0058BD13..39 je->BF75}
              begin
                while not DataModule2.Table1.Eof do begin            {0058BF5B je->BD44}
                  if DataModule2.Table1Vater.AsInteger = 0 then      {0058BD44..58 jne->BF39}
                  begin
                    kopf := False;                                   {0058BD5E..60}
                    gvar_02536454 := Form1.lfbh2.IndexName;          {0058BD63..86}
                    bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));   {0058BD8B..BDA0}
                    Form1.lfbh2.IndexName := 'Pro';                  {0058BDA3..B5}
                    Form1.lfbh2.First;                               {0058BDBA..C7}
                    u := '';
                    sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058BDCC..DE}
                    if Form1.lfbh2.FindKey([u]) then                 {0058BDFC..1B je->BE24}
                      kopf := True;                                  {0058BE1D}
                    Form1.lfbh2.IndexName := gvar_02536454;          {0058BE24..37}
                    Form1.lfbh2.GotoBookmark(bmk);                   {0058BE4E}
                    if kopf then                                     {0058BE58 jne->BF39}
                    begin
                      u := '';
                      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0058BE88..A0}
                      u := u + '*';
                      v := '';
                      illki(u, idx, v);                              {0058BEC0 Call self}
                      if Pos('Vater nicht bekannt: ', zzg) = 0 then  {0058BE5E..6D jne->BEDA}
                        zzg := zzg + #13#10#13#10'Kind(er), Vater nicht bekannt: - ' + v {0058BE6F..D3 edx=5}
                      else
                        zzg := zzg + ' - ' + v;                      {0058BEDA..34 edx=3}
                    end;
                  end;
                  DataModule2.Table1.Next;                           {0058BF39..43}
                  if DataModule2.Table1.Eof then                     {0058BF48..59 jne->0058BF75}
                    Break;
                  if DataModule2.Table1Mutter.AsInteger = perNr then {0058BF5B..6F [53C] je->0058BD44}
                    Continue
                  else
                    Break;                                           {->0058BF75}
                end;
              end;
            end;
          end;
          { 0058BF75 Table14-Write + Post }
          DataModule2.Table14Zeile.AsString := zzg;                  {0058BF75..87 [1E8]+0B0 edx=[ebp-38]}
          DataModule2.Table14.Post;                                  {0058BF8D..A2 [0E0]+248}
          DataModule2.Table1.IndexName := '';                        {0058BFA2..AE [5C]}
          Form1.lfbh2.Next;                                          {0058BFB3..C5}
     end;
   { --- C3q: Epilog (0058BFF7..0058C6ED) --- }
   DataModule2.Table1.EnableControls;                        {0058BFF7..F1}
   DataModule2.Table18.EnableControls;                       {0058C006..13 [140]}
   Form1.lfbh2.EnableControls;                               {0058C018..25 [8B8]}
   DataModule2.Table1.IndexName := '';                       {0058C02A..36 [5C]}
   DataModule2.Table1.FindKey([krg]);                        {0058C03B..61 [ebp-8]=Personnr vom Prolog}
   Screen.Cursor := crDefault;                               {0058C062..6B}
   Form1.Label19.Visible := False;                           {0058C070..7F [404]}
   if Trim(gvar_02536664) <> '' then                         {0058C084..9B jbe->C315}
   begin
     DataModule2.Table13.Open;                               {0058C0A6..AE [0CC]}
     DataModule2.Table13.IndexName := 'ort_';                {0058C0B8..C5}
     DataModule2.Table14.Append;                             {0058C0D1..D7}
     DataModule2.Table14Zeile.AsString := ' ';               {0058C0E1..F0}
     DataModule2.Table14.Post;                               {0058C0FB..0B}
     DataModule2.Table14.Append;                             {0058C112..18}
     DataModule2.Table14Zeile.AsString := ' ';               {0058C124..31}
     DataModule2.Table14.Post;                               {0058C13E..46}
     DataModule2.Table14.Append;                             {0058C153..59}
     DataModule2.Table14Zeile.AsString := 'Orts-Abkürzungen: '; {0058C163..72}
     DataModule2.Table14.Post;                               {0058C17F..87}
     DataModule2.Table13.First;                              {0058C194..9A}
     while not DataModule2.Table13.Eof do                    {0058C1EE..2FB}
     begin
       sub_00576EB0(DataModule2.Table13.RecNo, u);           {0058C1F3..23 [0CC] vtbl+150}
       if Pos(u, gvar_02536664) > 0 then                     {0058C213..26 jle->C2BF}
       begin
         DataModule2.Table14.Append;                          {0058C233..39}
         DataModule2.Table14Zeile.AsString :=                 {0058C244..A4 CatN3}
           DataModule2.Table13Abk.AsString + ': ' +
           DataModule2.Table13Ort.AsString;
         DataModule2.Table14.Post;                            {0058C2B1..B9}
       end;
       DataModule2.Table13.Next;                              {0058C2C6..CC}
     end;
   end;
   Form1.lfbh2.EmptyDataSet;                                 {0058C31A..22 [8B8]}
   Form15.QRMemo1.Visible := False;                          {0058C32E..36 [310]}
   Form15.QRMemo1.Enabled := False;                          {0058C342..4C +64}
InputQuery('OFB', 'Überschrift : ', gvar_02536438);         {0058C34F..68 var-Result, Boolesch-Rückwert verworfen}
   Form15.QRLabel1.Caption := gvar_02536438;                 {0058C374..80 [2F8]}
   Form15.QuickRep1.Page.Columns := 1;                       {0058C38C..9D}
   Form15.QRLabel2.Visible := False;                         {0058C3A9..B1 [2FC]}
   Form15.QRLabel2.Enabled := False;                         {0058C3BD..C5 +64}
   Form15.QRShape3.Visible := False;                         {0058C3D1..D9 [304]}
   Form15.QRShape3.Enabled := False;                         {0058C3E5..EF +64}
   Form15.QRBand1.Height := 30;                              {0058C3F9..04 [2F4]}
   Form15.QRLabel3.Caption := 'OFB';                         {0058C410..1B [368]}
   Form15.QRDBText4.Visible := False;                        {0058C427..2F [31C]}
   Form15.QRDBText5.Visible := False;                        {0058C43B..43 [320]}
   Form15.QRDBText6.Visible := False;                        {0058C44F..57 [324]}
   Form15.QRDBText7.Visible := False;                        {0058C463..6B [328]}
   Form15.QRDBText8.Visible := False;                        {0058C47B..7F [32C]}
   Form15.QRDBText9.Visible := False;                        {0058C48B..93 [330]}
   Form15.QRDBText10.Visible := False;                       {0058C49F..A7 [334]}
   Form15.QRDBText11.Visible := False;                       {0058C4B3..BB [338]}
   Form15.QRDBText12.Visible := False;                       {0058C4C7..CF [33C]}
   DataModule2.Table14.Open;                                 {0058C4D4..E1}
   Form15.QuickRep1.DataSet := DataModule2.Table14;         {0058C4ED..03}
   Form15.QRDBText1.DataSet := DataModule2.Table14;         {0058C50A..1F}
   Form15.QRDBText1.DataField := 'zeile';                    {0058C52B..36}
   Form15.QRDBText2.DataSet := DataModule2.Table14;         {0058C542..55}
   Form15.QRDBText2.DataField := 'nm';                       {0058C55A..6C}
   Form15.QRDBText1.Visible := True;                         {0058C571..80}
   Form15.QRDBText2.Visible := True;                         {0058C585..94}
   Form15.QRDBText1.Enabled := True;                         {0058C599..AA +64}
   Form15.QRDBText2.Enabled := True;                         {0058C5AD..BE +64}
   Form15.QRDBText1.Left := 60;                              {0058C5C8..D3}
   Form15.QRDBText1.Width := 610;                            {0058C5DF..EA}
   Form15.QRDBText2.Left := 8;                               {0058C5F4..01}
   Form15.QRDBText2.Width := 40;                             {0058C60B..18}
   PByte(Integer(Form15.QRDBText1)+$242)^ := 0;              {0058C622..2A +242}
   PByte(Integer(Form15.QRDBText2)+$242)^ := 0;              {0058C636..3E +242}
   Form15.QRDBText2.AutoSize := False;                       {0058C64C..54}
   Form15.QRDBText1.Font.Size := 9;                          {0058C660..6E +68}
   Form15.QRDBText2.Font.Size := 9;                          {0058C67A..88 +68}
   PByte(Integer(Form15.QRDBText1)+$0E0)^ := 0;              {0058C694..9E +0E0}
   Form15.QRDBText2.Enabled := True;                         {0058C6AB..B5}
    { Form15.QuickRep1.OnPreview := showpreview }             {0058C6C2..CB +2AC/+2A8 [ebp-4]}
    { Form15.QuickRep1.Preview; - die Vorschau ist im
      Kompatibilitaetsschicht nicht implementiert. }          {0058C6E2..E8}
end;

procedure TForm3.ofb2;
var
  krg: Integer;                                 {0058CBBE [ebp-8] Table1.Nummer}
  namFilter, ortFilter, husFilter: AnsiString;  {0058CD54/58/5C [ebp-54/58/5C]}
  agu: Boolean;                                 {0058CD31 [ebp-5D]}
  bl: Boolean;                                  {0058CD35 [ebp-5E]}
  gueltig: Boolean;                             {0058CD39 [ebp-60]}
  noch: Boolean;                                {CFAF-Knoten-Control}
  husHit: Boolean;                              {0058D038 setg [ebp-5F]}
  ok: Boolean;                                  {0058D3D1 Gate al}
  idx: Integer;                                 {0058D79E esi Table18-Ehenzaehler}
  s, u, s1, u48: AnsiString;                    {00576EB0-Ergebnisse / [ebp-114] toter Copy / [ebp-48]}
  i: Integer;                                   {0058CD7D [ebp-64] Loop-Zaehler / 005904AF Ehen-Rest}
  dup: Boolean;                                 {0058E063/E0B8/E108 W-Dedup: True = Append}
  bmk: TBookmark;                               {0058EA2D vtbl+150 GetBookmark [ebp-34]}
  prevName: AnsiString;                         {0058F4CB [ebp-44] Namens-Vergleich}
  s4C: AnsiString;                              {0058F4DD [ebp-4C] Body-Temp}
  s50: AnsiString;                              {0058F4E5 [ebp-50] Body-Temp}
  eli: Integer;                                 {0059257D [ebp-38] Marker-Flag Kind (lfbh2/gesp. Haupt)}
  t1Num: Integer;                               {0058F5B4 [ebp-10] Table1-Nummer}
  n1C: Integer;                                 {0058F568 [ebp-1C] Zaehler}
  v: AnsiString;                                {0058FDB5 sub_00576FF8-Ergebnis}
  iEh: Integer;                                 {005904B2 [ebp-14] Ehen-Index}
  n20: Integer;                                 {005904B9 [ebp-20] Ehen-Reset-Zaehler}
  patn: Integer;                                {00590570 [ebp-30] Epnum-Kopie}
  pnum: Integer;                                {00590ED2 edi Partner-Nummer}
  k: Integer;                                   {00591C62 [ebp-18] Kommentar-Loop-Zaehler}
begin
  { 0058CB84: OFB-Report ofb2 - zweite Variante des Ortsfamilienbuch-Reports.
    Aehnlich ofb3, aber die Ehen laufen ueber Table15 [0E8] ('num'-Index)
    statt Table18; Setup sammelt Form24-Filterstrings und oeffnet
    Table1/Table18/Table15. Chunk 1 = Prolog (0058CB84..0058CEF8). }
  krg := DataModule2.Table1Nummer.AsInteger;                 {0058CBAC..BE [534]+58}
  gvar_02536664 := '';                                       {0058CBC1..C6 @LStrClr}
  Form1.Label19.Caption := 'OFB erstellen';                   {0058CBCB..DD [404] 595394}
  Form1.Label19.Visible := True;                             {0058CBE2..F1 SetVisible dl=1}
  Form1.Label19.Refresh;                                     {0058CBF6..CC03}
  Form1.Refresh;                                             {0058CC08..11}
  Screen.Cursor := crHourGlass;                              {0058CC14..1F 0FFF5}
  gvar_02536440 := TStringList.Create;                       {0058CC24..30}
  gvar_02536440.Sorted := True;                              {0058CC35..3C SetSorted dl=1}
  PByte(Integer(gvar_02536440)+$1D)^ := 0;                   {0058CC41..46}
  gvar_02536444 := TStringList.Create;                       {0058CC4A..56}
  gvar_02536444.Sorted := True;                              {0058CC5B..62}
  PByte(Integer(gvar_02536444)+$1D)^ := 0;                   {0058CC67..6C}
  Form1.lfbh2.Open;                                          {0058CC70..82 [8B8] — 1x Open, kein 2.}
  Form1.lfbh2.EmptyDataSet;                                  {0058CC89..94}
  Form1.lfbh2.DisableControls;                               {0058CC9B..A1}
  DataModule2.Table1.Open;                                   {0058CCAD..B5 [5C]}
  DataModule2.Table1.IndexName := '';                        {0058CCBC..C1 xor edx,edx = nil}
  DataModule2.Table1.First;                                  {0058CCD0..D5}
  DataModule2.Table1.DisableControls;                        {0058CCDC..E4}
  DataModule2.Table18.Open;                                  {0058CCED..F6 [140]}
  DataModule2.Table18.IndexName := 'num';                    {0058CCFD..58CD08 5953AC}
  DataModule2.Table18.First;                                 {0058CD14..1A}
  DataModule2.Table18.DisableControls;                       {0058CD24..2C}
  agu := False;                                              {0058CD31 [ebp-5D]}
  bl := False;                                               {0058CD35 [ebp-5E]}
  gueltig := False;                                          {0058CD39 [ebp-60]}
  if Form24.ListBox6.Count > 0 then                          {0058CD3D..54 [368] +0C4 = Count}
    gueltig := True;                                         {0058CD56}
  namFilter := '';                                           {0058CD5A..62}
  for i := 1 to Form24.ListBox3.Count do                     {0058CD69..CDB8 [300]}
    namFilter := namFilter + '*' + Form24.ListBox3.Items[i-1]; {0058CD82..B2 CatN edx=3 [ebp-6C]}
  namFilter := namFilter + '*';                              {0058CDC5 @LStrCat}
  ortFilter := '';                                           {0058CDCD..D2}
  for i := 1 to Form24.ListBox4.Count do                     {0058CDD9..58CE28 [304]}
    ortFilter := ortFilter + '*' + Form24.ListBox4.Items[i-1];
  ortFilter := ortFilter + '*';                              {0058CE35}
  husFilter := '';                                           {0058CE3D..42}
  for i := 1 to Form24.ListBox6.Count do                     {0058CE49..58CE98 [368]}
    husFilter := husFilter + '*' + Form24.ListBox6.Items[i-1];
  husFilter := husFilter + '*';                              {0058CEA5}
  if gueltig then                                            {0058CEAA..CF cmp [ebp-60],0 je->CECF}
  begin
    agu := False;                                            {0058CEB0}
    bl := False;                                             {0058CEB4}
    Form24.RadioButton2.Visible := True;                     {0058CEB8..CF [38C] +0C8 SetVisible}
  end;
  DataModule2.Table15.Open;                                  {0058CECF..E1 [0E8] TTable}
  DataModule2.Table15.IndexName := 'num';                    {0058CEE8..F3 5953AC}
  { 0058CEF8 jmp 0058DA45 - Schleifen-Condition }
  while not DataModule2.Table1.Eof do                              {0058DA45..56 [5C]+0A1 je->CEFD}
  begin
    if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then  {0058CEFD..2A [548] jne->DA23}
    begin
      if gvar_0253641C = 0 then                                     {0058CF30..3D jne->CFF0 / jmp->CFAF}
      begin
        { CFAF-Knoten (0058CFAF..FEA): FindKey der aktuellen Person auf
          Table15; bei Fail Table1 vorruecken, bis eine MmxX-Person
          (Pos(Geschlecht,'MmxX')<>0) erreicht ist; Pos-Weg und Eof-
          Ausgaenge laufen auf CFAF (FindKey-Wdh.) oder CFF0 (M-Filter-
          block) zusammen. }
        noch := True;                                               { CFAF-Loop-Control }
        while noch do
        begin
          noch := False;
          if DataModule2.Table15.FindKey([DataModule2.Table1Nummer.AsInteger]) then  {0058CFAF..FE8 [0E8] 'num'}
            Break;                                                  { found -> 0058CFF0 }
          DataModule2.Table1.Next;                                  {0058CF3F}
          if DataModule2.Table1.Eof then
            Break;                                                  {0058CF58 jne->CFF0}
          if Pos(DataModule2.Table1Geschlecht.AsString, 'MmxX') <> 0 then  {0058CF89..AD 5953D0}
            noch := True                                             { Pos<>0 -> CFAF }
          else
          begin
            repeat                                                  { CF67/CF89 }
              DataModule2.Table1.Next;                              {0058CF67}
              if DataModule2.Table1.Eof then
              begin
                noch := True;                                       { CF67-Eof -> CFAF (letzte Zeile) }
                Break;
              end;
            until Pos(DataModule2.Table1Geschlecht.AsString, 'MmxX') <> 0;  {0058CF89 = CF67-Condition}
            noch := True;                                           { Pos<>0 -> CFAF }
          end;
        end;
      end;
      { 0058CFF0: M-Filterblock }
      husHit := Pos('*' + DataModule2.Table1Hausname.AsString + '*',
                    husFilter) > 0;                                 {0058CFF0..D038 setg [ebp-5F]}
      if not gueltig then                                           {0058D03C..40 jne->D1CB}
      begin
        agu := Pos('*' + DataModule2.Table1Name.AsString + '*',
                   namFilter) > 0;                                  {0058D046..D08E setg [ebp-5D]}
        bl := (Pos('*' + DataModule2.Table1Gebort.AsString + '*',
                   ortFilter) > 0) or                               {0058D092..D0DA jg->D1C6}
              (Pos('*' + DataModule2.Table1Taufort.AsString + '*',
                   ortFilter) > 0) or                               {0058D0E0..D128}
              (Pos('*' + DataModule2.Table1Stort.AsString + '*',
                   ortFilter) > 0) or                               {0058D12E..D176}
              (Pos('*' + DataModule2.Table1Begort.AsString + '*',
                   ortFilter) > 0);                                 {0058D178..D1C8 [ebp-5E]}
        if not bl then                                              {0058D1D5..D9 jne->D361}
          if DataModule2.Table18.FindKey(                           {0058D1DF..D21A [140] 'num'}
             [DataModule2.Table1Nummer.AsInteger]) then
          begin
            while DataModule2.Table18Nummer.AsInteger =            {0058D333..5B je->D225}
                  DataModule2.Table1Nummer.AsInteger do
            begin
              bl := (Pos('*' + DataModule2.Table18Saort.AsString + '*',
                         ortFilter) > 0) or                         {0058D225..D307 setg [ebp-5E]}
                    (Pos('*' + DataModule2.Table18Hort.AsString + '*',
                         ortFilter) > 0) or                         {0058D273..D2BB}
                    (Pos('*' + DataModule2.Table18Schort.AsString + '*',
                         ortFilter) > 0);                           {0058D2BD..D305}
              DataModule2.Table18.Next;                             {0058D30B..D318}
              if DataModule2.Table18.Eof then                       {0058D331 jne->D361}
                Break;
            end;
          end;
      end;
      if namFilter = '*' then agu := True;                          {0058D361..D370}
      if ortFilter = '*' then bl := True;                           {0058D374..D383}
      if husFilter = '*' then husHit := True;                       {0058D387..D396 [ebp-5F]}
      if gueltig then                                               {0058D39A..D3D3}
        ok := husHit
      else if (namFilter = '*') and (ortFilter = '*') then          {0058D3A5..D3C1 je->D3CF}
        ok := True                                                  {0058D3CF}
      else
        ok := agu and bl;                                           {0058D3C3..D3CD}
      if ok then                                                    {0058D3D1 test je->DA23}
      begin
        Form1.lfbh2.Append;                                         {0058D3D9 [8B8] TDataSet}
        Form1.lfbh2Nam.AsString := DataModule2.Table1Name.AsString; {0058D3E0..D41E [91C]:=[540]}
        if gvar_025363E8 = 1 then                                   {0058D41E..D425 jne->D4B0}
          Form1.lfbh2Ix.AsString :=                                 {0058D42B..D4AF CatN3 [918]}
            DataModule2.Table1Vornamen.AsString +
            DataModule2.Table1Gebjahr.AsString +
            DataModule2.Table1Taufjahr.AsString;
        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, s);         {0058D4B0..D4C8 [534] 6-stellig}
        Form1.lfbh2Prob.AsString := s;                               {0058D4CD..D4E8 [910]}
        if gvar_025363E0 = 1 then                                   {0058D4E8..D4EF jne->D63A}
          if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then    {0058D4F5..D525 jbe->D5B5}
            Form1.lfbh2Ix.AsString :=                               {0058D52B..D5AA CatN3 Jahr+Mon+Tag}
              DataModule2.Table1Gebjahr.AsString +
              DataModule2.Table1Gebmonat.AsString +
              DataModule2.Table1Gebtag.AsString
          else
            Form1.lfbh2Ix.AsString :=                               {0058D5B5..D634 CatN3}
              DataModule2.Table1Taufjahr.AsString +
              DataModule2.Table1Taufmonat.AsString +
              DataModule2.Table1Tauftag.AsString;
        if gvar_025363E4 = 1 then                                   {0058D63A..D641 jne->D75D}
        begin
          Form1.lfbh2Hei.AsString := '';                            {0058D647..D658 [924] xor edx}
          { 0058D65E..D6B5: Copy in [ebp-114] — Original-Totalspeicher (s1 nie gelesen) }
          s1 := Copy(DataModule2.Table1Kommentar.AsString,
                     Pos(#$92 + 'N',
                     DataModule2.Table1Kommentar.AsString) + 3, 4);
          if Pos(#$92 + 'N',
                 DataModule2.Table1Kommentar.AsString) > 0 then     {0058D6BA..D6E4 jle->D75D}
            Form1.lfbh2Hei.AsString := Copy(                        {0058D6E6..D757}
              DataModule2.Table1Kommentar.AsString,
              Pos(#$92 + 'N',
                  DataModule2.Table1Kommentar.AsString) + 3, 4);
        end;
        if DataModule2.Table18.FindKey(                             {0058D75D..D798 je->D9CB}
           [DataModule2.Table1Nummer.AsInteger]) then
        begin
          idx := 1;                                                 {0058D79E esi:=1}
          while DataModule2.Table18Nummer.AsInteger =              {0058D99D..D9C5 je->D7A8}
                DataModule2.Table1Nummer.AsInteger do
          begin
            sub_00576EB0(DataModule2.Table18Epnum.AsInteger, u);    {0058D7A8..D7E3 [4CC]}
            Form1.lfbh2Eh.AsString :=                               {0058D7E9..D813 CatN3 [914]}
              Form1.lfbh2Eh.AsString + u + '*';
            if (gvar_025363E4 = 1) and (idx = 1) then               {0058D819..D829 jne->D974}
            begin
              if Trim(DataModule2.Table18Sajahr.AsString) <> '' then {0058D82F..D85F jbe->D8EF}
                Form1.lfbh2Ix.AsString :=                           {0058D865..D8E4 CatN3 Jahr+Mon+Tag}
                  DataModule2.Table18Sajahr.AsString +
                  DataModule2.Table18Samonat.AsString +
                  DataModule2.Table18Satag.AsString
              else
                Form1.lfbh2Ix.AsString :=                           {0058D8EF..D96E CatN3}
                  DataModule2.Table18Hjahr.AsString +
                  DataModule2.Table18Hmonat.AsString +
                  DataModule2.Table18Htag.AsString;
            end;
            DataModule2.Table18.Next;                               {0058D974..D981}
            if DataModule2.Table18.Eof then                         {0058D993 jne->D9CB}
              Break;
            Inc(idx);                                               {0058D99C}
          end;
        end;
        Form1.lfbh2Eh.AsString := Form1.lfbh2Eh.AsString + '000000*'; {0058D9CB..DA08 5953EC}
        Form1.lfbh2.Post;                                           {0058DA0E..DA1D vtbl+248}
      end;
    end;
    DataModule2.Table1.Next;                                        {0058DA23..32 Tail}
    if DataModule2.Table1.Eof then                                  {0058DA3C..43 jne->DA5C}
      Break;
  end;
  DataModule2.Table1.IndexName := '';                              {0058DA5C..68 xor edx,edx}
  DataModule2.Table1.First;                                        {0058DA6D..77}
  if gueltig then                                                  {0058DA7C..A5 je->E996}
  begin
    agu := False;                                                  {0058DA86}
    bl := False;                                                   {0058DA8A}
    Form24.RadioButton2.Visible := True;                           {0058DA8E..A5 [38C] +0C8 SetVisible}
  end;
  { 0058DAA5 jmp 0058E996 - Schleifen-Condition 2. Table1-Pass (W-Zweig) }
  while not DataModule2.Table1.Eof do                              {0058E996..A7 je->DAAA}
  begin
    if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then  {0058DAAA..E3 [548] jne->E974}
    begin
      if gvar_0253641C = 0 then                                     {0058DAE9..F0 jne->DBAF}
      begin
        { W-Knoten (DB6E..DB6C): FindKey Table15; bei Fail Next-Schleife
          mit Pos(Geschlecht,'WwxX') [595408] — Spiegel des M-Knotens;
          Eof-Ausgaenge: DAF8->DBAF (Filter), DB20->DB6E (FindKey). }
        noch := True;
        while noch do
        begin
          noch := False;
          if DataModule2.Table15.FindKey([DataModule2.Table1Nummer.AsInteger]) then  {0058DB6E..A9 [0E8] 'num'}
            Break;                                                  { -> DBAF }
          DataModule2.Table1.Next;                                  {0058DAF8}
          if DataModule2.Table1.Eof then
            Break;                                                  {0058DB18 jne->DBAF}
          if Pos(DataModule2.Table1Geschlecht.AsString, 'WwxX') <> 0 then  {0058DB42..6C}
            noch := True                                             { -> DB6E }
          else
          begin
            repeat                                                  { DB20/DB42 }
              DataModule2.Table1.Next;                              {0058DB20}
              if DataModule2.Table1.Eof then
              begin
                noch := True;                                       { DB20-Eof -> DB6E }
                Break;
              end;
            until Pos(DataModule2.Table1Geschlecht.AsString, 'WwxX') <> 0;  {0058DB42}
            noch := True;                                           { -> DB6E }
          end;
        end;
      end;
      { 0058DBAF: W-Filterblock (Spiegel CFF0) }
      husHit := Pos('*' + DataModule2.Table1Hausname.AsString + '*',
                    husFilter) > 0;                                 {0058DBAF..DBF7 setg [ebp-5F]}
      if not gueltig then                                           {0058DBFB..FF jne->DD8A}
      begin
        agu := Pos('*' + DataModule2.Table1Name.AsString + '*',
                   namFilter) > 0;                                  {0058DC05..DC4D setg [ebp-5D]}
        bl := (Pos('*' + DataModule2.Table1Gebort.AsString + '*',
                   ortFilter) > 0) or                               {0058DC51..DC99 jg->DD85}
              (Pos('*' + DataModule2.Table1Taufort.AsString + '*',
                   ortFilter) > 0) or                               {0058DC9F..DCE7}
              (Pos('*' + DataModule2.Table1Stort.AsString + '*',
                   ortFilter) > 0) or                               {0058DCED..DD35}
              (Pos('*' + DataModule2.Table1Begort.AsString + '*',
                   ortFilter) > 0);                                 {0058DD37..DD87 [ebp-5E]}
        if not bl then                                              {0058DD94..D98 jne->DF20}
          if DataModule2.Table18.FindKey(                           {0058DD9E..DDD9 [140] 'num'}
             [DataModule2.Table1Nummer.AsInteger]) then
          begin
            while DataModule2.Table18Nummer.AsInteger =            {0058DEF2..DF1A je->DDE4}
                  DataModule2.Table1Nummer.AsInteger do
            begin
              bl := (Pos('*' + DataModule2.Table18Saort.AsString + '*',
                         ortFilter) > 0) or                         {0058DDE4..DEC6 setg [ebp-5E]}
                    (Pos('*' + DataModule2.Table18Hort.AsString + '*',
                         ortFilter) > 0) or                         {0058DE32..DE7A}
                    (Pos('*' + DataModule2.Table18Schort.AsString + '*',
                         ortFilter) > 0);                           {0058DE7C..DEC4}
              DataModule2.Table18.Next;                             {0058DECA..DED7}
              if DataModule2.Table18.Eof then                       {0058DEF0 jne->DF20}
                Break;
            end;
          end;
      end;
      if namFilter = '*' then agu := True;                          {0058DF20..DF2F}
      if ortFilter = '*' then bl := True;                           {0058DF33..DF42}
      if husFilter = '*' then husHit := True;                       {0058DF46..DF55}
      if gueltig then                                               {0058DF59..DF92}
        ok := husHit
      else if (namFilter = '*') and (ortFilter = '*') then
        ok := True
      else
        ok := agu and bl;
      if ok then                                                    {0058DF90..DF92 je->E974}
      begin
        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u48);      {0058DF98..DFAA [534] -> [ebp-48]}
        if DataModule2.Table18.FindKey(                             {0058DFB2..DFED je->E689}
           [DataModule2.Table1Nummer.AsInteger]) then
        begin
          idx := 1;                                                 {0058DFF3 esi:=1}
          while DataModule2.Table18Nummer.AsInteger =              {0058E656..7E je->DFFD / jmp->E974}
                DataModule2.Table1Nummer.AsInteger do
          begin
            Form1.lfbh2.IndexName := 'Pro';                          {0058E00A..E00F [595418]}
            sub_00576EB0(DataModule2.Table18Epnum.AsInteger, u);     {0058E014..E02C [ebp-1BC]}
            if Form1.lfbh2.FindKey([u]) then                        {0058E031..E063 +2C4 je->E10E}
            begin
              dup := True; { 2. FindKey je->E629: skip }
              sub_00576EB0(DataModule2.Table18Nummer.AsInteger, s); {0058E069..E081 [ebp-1C0]}
              if Form1.lfbh2.FindKey([s]) then                      {0058E086..E0B8 je->E629}
                dup := Pos(u, Form1.lfbh2Eh.AsString) > 0;           {0058E0BE..E108 jne->E629}
            end
            else
              dup := False; { 1. FindKey-Fail -> E10E Append }
            if not dup then                                          {0058E10E..}
            begin
              Form1.lfbh2.Append;                                    {0058E10E..E11F TDataSet.Append}
              Form1.lfbh2Nam.AsString := DataModule2.Table1Name.AsString; {0058E120..E14D [91C]:=[540]}
              if gvar_025363E8 = 1 then                              {0058E153..E15A jne->E1E5}
                Form1.lfbh2Ix.AsString :=                            {0058E160..E1DF CatN3 [918]}
                  DataModule2.Table1Vornamen.AsString +
                  DataModule2.Table1Gebjahr.AsString +
                  DataModule2.Table1Taufjahr.AsString;
              sub_00576EB0(DataModule2.Table1Nummer.AsInteger, s);   {0058E1E5..E1FD [534] 6-stellig}
              Form1.lfbh2Prob.AsString := s;                         {0058E202..E217 [910]}
              if gvar_025363E0 = 1 then                              {0058E21D..E224 jne->E36F}
                if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then {0058E22A..E25A jbe->E2EA}
                  Form1.lfbh2Ix.AsString :=                          {0058E260..E2DF CatN3 Jahr+Mon+Tag}
                    DataModule2.Table1Gebjahr.AsString +
                    DataModule2.Table1Gebmonat.AsString +
                    DataModule2.Table1Gebtag.AsString
                else
                  Form1.lfbh2Ix.AsString :=                          {0058E2EA..E369 CatN3}
                    DataModule2.Table1Taufjahr.AsString +
                    DataModule2.Table1Taufmonat.AsString +
                    DataModule2.Table1Tauftag.AsString;
              Form1.lfbh2Eh.AsString :=                              {0058E36F..E3DA CatN3 [914]}
                Form1.lfbh2Eh.AsString + u + '*';
              if (gvar_025363E4 = 1) and (idx = 1) then              {0058E3E0..E3F0 jne->E614}
              begin
                if Trim(DataModule2.Table18Sajahr.AsString) <> '' then {0058E3F6..E426 jbe->E4B6}
                  Form1.lfbh2Ix.AsString :=                          {0058E42C..E4AB CatN3}
                    DataModule2.Table18Sajahr.AsString +
                    DataModule2.Table18Samonat.AsString +
                    DataModule2.Table18Satag.AsString
                else if Trim(DataModule2.Table18Hjahr.AsString) <> '' then {0058E4B6..E4E6 jbe->E571}
                  Form1.lfbh2Ix.AsString :=                          {0058E4EC..E56B CatN3 — anders M: Trim-guard}
                    DataModule2.Table18Hjahr.AsString +
                    DataModule2.Table18Hmonat.AsString +
                    DataModule2.Table18Htag.AsString;
              end;
              { W-Hei: EIN Pos-Check, kein '' vorab, kein 1. dead-Copy (vs. M) }
              if Pos(#$92 + 'N',                                    {0058E571..E59B jle->E614}
                     DataModule2.Table1Kommentar.AsString) > 0 then
                Form1.lfbh2Hei.AsString := Copy(                     {0058E59D..E60E LStrCopy}
                  DataModule2.Table1Kommentar.AsString,
                  Pos(#$92 + 'N',
                      DataModule2.Table1Kommentar.AsString) + 3, 4);
              Form1.lfbh2.Post;                                      {0058E614..E623 +248}
            end;
            DataModule2.Table18.Next;                               {0058E629..E636}
            if DataModule2.Table18.Eof then                         {0058E648..E64F jne->E974}
              Break;
            Inc(idx);                                               {0058E655}
          end;
        end
        else
        begin
          { 0058E689: kein Ehen-Fund (Table18-FindKey fehlgeschlagen) }
          if gvar_0253641C = 0 then                                 {0058E689..E690 jne->E6A6}
            DataModule2.Table1.IndexName := 'mut';                  {0058E692..E6A1 [595424]}
          if DataModule2.Table1.FindKey([StrToInt(u48)]) then       {0058E6A6..E6D4 je->E937}
          begin
            DataModule2.Table1.IndexName := '';                     {0058E6DA..E6E6 xor edx,edx}
            DataModule2.Table1.FindKey([StrToInt(u48)]);            {0058E6EB..E712 ohne Test}
            Form1.lfbh2.Append;                                     {0058E717..E724 TDataSet.Append}
            Form1.lfbh2Nam.AsString := DataModule2.Table1Name.AsString; {0058E729..E756 [91C]:=[540]}
            if gvar_025363E8 = 1 then                               {0058E75C..E763 jne->E798}
              Form1.lfbh2Ix.AsString :=                             {0058E765..E792 — nur Vornamen!}
                DataModule2.Table1Vornamen.AsString;                {vs. Cat3 im Haupt-Append}
            sub_00576EB0(DataModule2.Table1Nummer.AsInteger, s);    {0058E798..E7B0 [534] 6-stellig}
            Form1.lfbh2Prob.AsString := s;                          {0058E7B5..E7CA [910]}
            if gvar_025363E0 = 1 then                               {0058E7D0..E7D7 jne->E922}
              if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then {0058E7DD..E80D jbe->E89D}
                Form1.lfbh2Ix.AsString :=                           {0058E813..E892 CatN3 Jahr+Mon+Tag}
                  DataModule2.Table1Gebjahr.AsString +
                  DataModule2.Table1Gebmonat.AsString +
                  DataModule2.Table1Gebtag.AsString
              else
                Form1.lfbh2Ix.AsString :=                           {0058E89D..E91C CatN3}
                  DataModule2.Table1Taufjahr.AsString +
                  DataModule2.Table1Taufmonat.AsString +
                  DataModule2.Table1Tauftag.AsString;
            Form1.lfbh2.Post;                                       {0058E922..E931 +248}
          end;
          { 0058E937: zurueckpositionieren — nach Post ODER bei FindKey-Fail }
          DataModule2.Table1.IndexName := '';                       {0058E937..E943 xor edx,edx}
          DataModule2.Table1.FindKey([StrToInt(u48)]);              {0058E948..E96F}
        end;
      end;
    end;
    DataModule2.Table1.Next;                                       {0058E974..7E}
    if DataModule2.Table1.Eof then                                 {0058E98D..94 jne->E9AD}
      Break;
  end;
  { 0058E9AD: lfbh2-Nachlauf }
  DataModule2.Table1.IndexName := '';                              {0058E9AD..E9B9 xor edx,edx}
  DataModule2.Table18.IndexName := 'num';                          {0058E9BE..E9D0 [5953AC]}
  Form1.lfbh2.IndexName := 'Pro';                                  {0058E9D5..E9E7 [595418]}
  Form1.lfbh2.First;                                               {0058E9EC..E9F9}
  while not Form1.lfbh2.Eof do                                     {0058E9FE jmp->EEE0 / EEF4 je->EA03}
  begin
    u := Form1.lfbh2Prob.AsString;                                 {0058EA03..EA15 [910]+60 [ebp-48]}
    bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));                 {0058EA18..EA2D vtbl+150}
    DataModule2.Table1.FindKey([StrToInt(u)]);                     {0058EA30..EA57 ohne Test}
    if DataModule2.Table1Vater.AsInteger > 0 then                  {0058EA5C..EA70 jle->EC57 [538]}
    begin
      sub_00576EB0(DataModule2.Table1Vater.AsInteger, s);          {0058EA76..EA8E 6-stellig}
      if Form1.lfbh2.FindKey([s]) then                             {0058EA93..EAC5 je->EC57}
        if DataModule2.Table1Mutter.AsInteger > 0 then             {0058EACB..EADF jle->EC57 [53C]}
        begin
          sub_00576EB0(DataModule2.Table1Mutter.AsInteger, s);     {0058EAE5..EB1C [53C]}
          if Pos(s, Form1.lfbh2Eh.AsString) > 0 then               {0058EB21..EB2F jle->EC57}
          begin
            DataModule2.Table1.IndexName := 'mut';                 {0058EB35..EB44 [595424]}
            if not DataModule2.Table1.FindKey([StrToInt(u)]) then  {0058EB49..EB77 jne->EC57}
              if not DataModule2.Table18.FindKey([StrToInt(u)]) then {0058EB7D..EBAE jne->EC57}
              begin
                Form1.lfbh2.GotoBookmark(bmk);                     {0058EBB4..EBC6 vtbl+1A0}
                if gvar_0253641C = 0 then                          {0058EBCC..EBD3 jne->EC18}
                begin
                  Form1.lfbh2.Edit;                                {0058EBD5..EBE2}
                  Form1.lfbh2Nm.AsInteger := 1;                    {0058EBE7..EBFB +0A8 edx=1}
                  Form1.lfbh2.Post;                                {0058EC01..EC10}
                end
                else
                begin
                  Form1.lfbh2.Edit;                                {0058EC18..EC25}
                  Form1.lfbh2Nm.AsInteger := -1;                   {0058EC2A..EC3C or edx,-1}
                  Form1.lfbh2.Post;                                {0058EC42..EC51}
                end;
              end;
          end;
        end;
    end;
    DataModule2.Table1.IndexName := '';                            {0058EC57..EC63 xor edx,edx}
    DataModule2.Table1.FindKey([StrToInt(u)]);                     {0058EC68..EC8F ohne Test}
    if DataModule2.Table1Mutter.AsInteger > 0 then                 {0058EC94..ECA8 jle->EE8F [53C]}
    begin
      sub_00576EB0(DataModule2.Table1Mutter.AsInteger, s);         {0058ECAE..ECC6 6-stellig}
      if Form1.lfbh2.FindKey([s]) then                             {0058ECCB..ECFD je->EE8F}
        if DataModule2.Table1Vater.AsInteger > 0 then              {0058ED03..ED17 jle->EE8F [538]}
          if Pos(IntToStr(DataModule2.Table1Vater.AsInteger),      {0058ED1D..ED67 IntToStr-Nadel}
                 Form1.lfbh2Eh.AsString) > 0 then
          begin
            DataModule2.Table1.IndexName := 'vat';                 {0058ED6D..ED7C [595430]}
            if not DataModule2.Table1.FindKey([StrToInt(u)]) then  {0058ED81..EDAF jne->EE8F}
              if not DataModule2.Table18.FindKey([StrToInt(u)]) then {0058EDB5..EDE6 jne->EE8F}
              begin
                Form1.lfbh2.GotoBookmark(bmk);                     {0058EDEC..EDFE vtbl+1A0}
                if gvar_0253641C = 0 then                          {0058EE04..EE0B jne->EE50}
                begin
                  Form1.lfbh2.Edit;                                {0058EE0D..EE1A}
                  Form1.lfbh2Nm.AsInteger := 1;                    {0058EE1F..EE33 +0A8 edx=1}
                  Form1.lfbh2.Post;                                {0058EE39..EE48}
                end
                else
                begin
                  Form1.lfbh2.Edit;                                {0058EE50..EE5D}
                  Form1.lfbh2Nm.AsInteger := -1;                   {0058EE62..EE74 or edx,-1}
                  Form1.lfbh2.Post;                                {0058EE7A..EE89}
                end;
              end;
          end;
    end;
    DataModule2.Table1.IndexName := '';                            {0058EE8F..EE9B xor edx,edx}
    Form1.lfbh2.GotoBookmark(bmk);                                 {0058EEA0..EEB2 vtbl+1A0}
    Form1.lfbh2.Next;                                              {0058EEB8..EEC5}
  end; { 0058EEE0..EEF4: Eof-Kante }
  { 0058EEFA: Delete-Loop #1 — raeumt gvar!=0-Markierungen (Nm=-1) }
  Form1.lfbh2.First;                                               {0058EEFA..EF07}
  while not Form1.lfbh2.Eof do                                     {0058EF0C jmp->EF5F / EF73 je->EF0E}
  begin
    if Form1.lfbh2Nm.AsInteger = -1 then                           {0058EF1B..EF21 inc; jne->EF37}
      Form1.lfbh2.Delete                                           {0058EF23..EF30 jmp->EF5F, kein Next}
    else if Form1.lfbh2.Eof then                                   {0058EF37..EF3B jne->EF75}
      Break                                                        {0058EF75 = na-Loop}
    else
      Form1.lfbh2.Next;                                            {0058EF4D..EF5A}
  end;
  { 0058EF75: 'na'-Nummerierung }
  Form1.lfbh2.IndexName := 'na';                                   {0058EF75..EF87 [59543C]}
  Form1.lfbh2.First;                                               {0058EF8C..EF99}
  idx := 0;                                                        {0058EF9E xor esi,esi}
  while not Form1.lfbh2.Eof do                                     {0058EFA0 jmp->F0C4 / F0D8 je->EFA5}
  begin
    if Form1.lfbh2Nm.AsInteger = 1 then                            {0058EFB2..EFB8 dec; jne->F008}
    begin
      if not gueltig then                                          {0058EFBA..EFBE jne->F09C}
      begin
        Form1.lfbh2.Edit;                                          {0058EFC4..EFD1}
        Form1.lfbh2Nm.AsInteger := -1;                             {0058EFD6..EFE8 or edx,-1}
        Form1.lfbh2.Post;                                          {0058EFEE..EFFD}
      end;
    end
    else
    begin
      Inc(idx);                                                    {0058F008}
      Form1.lfbh2.Edit;                                            {0058F009..F016}
      Form1.lfbh2Nm.AsInteger := idx;                              {0058F01B..F02C edx=esi}
      if not gueltig then                                          {0058F032..F036 jne->F087}
        Form1.lfbh2Hei.AsString := Copy(                           {0058F038..F081 LStrCopy}
          Form1.lfbh2Ix.AsString, 1, 4);
      Form1.lfbh2.Post;                                            {0058F087..F096}
    end;
    Form1.lfbh2.Next;                                              {0058F09C..F0A9}
  end;
  { 0058F0DE: Delete-Loop #2 — raeumt na-Loop-Markierungen (Nm=-1) }
  Form1.lfbh2.First;                                               {0058F0DE..F0EB}
  while not Form1.lfbh2.Eof do                                     {0058F0F0 jmp->F143 / F157 je->F0F2}
  begin
    if Form1.lfbh2Nm.AsInteger = -1 then                           {0058F101..F105 inc; jne->F11B}
      Form1.lfbh2.Delete                                           {0058F107..F114 jmp->F143, kein Next}
    else if Form1.lfbh2.Eof then                                   {0058F11B..F11F jne->F159}
      Break                                                        {0058F159 = Aus-Loop}
    else
      Form1.lfbh2.Next;                                            {0058F131..F13E}
  end;
  { 0058F159: Aus-Copy-Loop — Eltern-Nm -> lfbh2Aus [920] }
  DataModule2.Table1.IndexName := '';                              {0058F159..F165}
  DataModule2.Table18.IndexName := 'num';                          {0058F16A..F17C [5953AC]}
  Form1.lfbh2.IndexName := 'Pro';                                  {0058F181..F193 [595418]}
  Form1.lfbh2.First;                                               {0058F198..F1A5}
  while not Form1.lfbh2.Eof do                                     {0058F1AA jmp->F3E7 / F3FB je->F1AF}
  begin
    u := Form1.lfbh2Prob.AsString;                                 {0058F1AF..F1C1 [910]+60 [ebp-48]}
    bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));                 {0058F1C4..F1D9 vtbl+150}
    DataModule2.Table1.FindKey([StrToInt(u)]);                     {0058F1DC..F203 ohne Test}
    if DataModule2.Table1Vater.AsInteger > 0 then                  {0058F208..F21C jle->F2E8 [538]}
    begin
      sub_00576EB0(DataModule2.Table1Vater.AsInteger, s);          {0058F222..F23A 6-stellig}
      if Form1.lfbh2.FindKey([s]) then                             {0058F23F..F271 je->F3BF = skip}
      begin
        idx := Form1.lfbh2Nm.AsInteger;                            {0058F277..F289 [90C]+58 -> [ebp-2C]}
        Form1.lfbh2.GotoBookmark(bmk);                             {0058F28C..F29E vtbl+1A0}
        Form1.lfbh2.Edit;                                          {0058F2A4..F2B1}
        Form1.lfbh2Aus.AsInteger := idx;                           {0058F2B6..F2C8 [920] := Eltern-Nm}
        Form1.lfbh2.Post;                                          {0058F2CE..F2DD}
      end;
    end
    else if DataModule2.Table1Mutter.AsInteger > 0 then            {0058F2E8..F2FC jle->F3BF [53C]}
    begin
      sub_00576EB0(DataModule2.Table1Mutter.AsInteger, s);         {0058F302..F31A 6-stellig}
      if Form1.lfbh2.FindKey([s]) then                             {0058F31F..F351 je->F3BF = skip}
      begin
        idx := Form1.lfbh2Nm.AsInteger;                            {0058F353..F365 [90C]+58 -> [ebp-2C]}
        Form1.lfbh2.GotoBookmark(bmk);                             {0058F368..F37A vtbl+1A0}
        Form1.lfbh2.Edit;                                          {0058F380..F38D}
        Form1.lfbh2Aus.AsInteger := idx;                           {0058F392..F3A4 [920] := Eltern-Nm}
        Form1.lfbh2.Post;                                          {0058F3AA..F3B9}
      end;
    end;
    Form1.lfbh2.Next;                                              {0058F3BF..F3CC}
  end;
  { 0058F401: Output-Setup }
  Form1.lfbh2.IndexDefs.Update;                                    {0058F401..F413 GetIndexDefs+Update}
  Form1.lfbh2.IndexName := 'na';                                   {0058F418..F42A [59543C]}
  if gueltig then                                                  {0058F42F..F433 je->F44C}
    Form1.lfbh2.IndexName := 'heir';                               {0058F435..F447 [595448]}
  DataModule2.Table1.IndexName := '';                              {0058F44C..F458 xor edx,edx}
  Form1.lfbh2.First;                                               {0058F45D..F46A}
  DataModule2.Table14.Open;                                        {0058F46F..F47C [0E0]}
  DataModule2.Table14.Close;                                       {0058F481..F48E}
  DataModule2.Table14.EmptyTable;                                  {0058F493..F4A0}
  DataModule2.Table14.Open;                                        {0058F4A5..F4B2}
  idx := 0;                                                        {0058F4B7 xor esi,esi}
  Form1.lfbh2.First;                                               {0058F4B9..F4C6}
  prevName := ' ';                                                 {0058F4CB..F4D3 [ebp-44] 595458}
  while not Form1.lfbh2.Eof do                                     {0058F4D8 jmp->00594B8B / 00594B9F je->F4DD}
  begin
    s4C := '';                                                     {0058F4DD..F4E4 LStrClr [ebp-4C]}
    s50 := '';                                                     {0058F4E5..F4EC LStrClr [ebp-50]}
    if Trim(Form1.lfbh2Prob.AsString) = '' then                    {0058F4ED..F51D [910]+60 Trim jbe->00594B63}
    begin
      Form1.lfbh2.Next;                                            {00594B63 = Loop-Bottom}
      Continue;
    end;
    if idx > 0 then                                                {0058F523 test esi,esi jle->F568}
    begin
      DataModule2.Table14.Append;                                  {0058F527..F536 [0E0]}
      DataModule2.Table14Zeile.AsString := ' ';                     {0058F539..F54D [1E8]+0B0 595458}
      DataModule2.Table14.Post;                                    {0058F553..F562 +248}
    end;
    n1C := 0;                                                      {0058F568..F56A [ebp-1C]}
    DataModule2.Table1.FindKey([StrToInt(Form1.lfbh2Prob.AsString)]); {0058F56D..F5AF [5C] ohne Test}
    t1Num := DataModule2.Table1Nummer.AsInteger;                   {0058F5B4..F5C3 [534]+58 -> [ebp-10]}
    if DataModule2.Table1Name.AsString <> prevName then            {0058F5C9..F5EF [540]+60 je->F6FA}
    begin
      DataModule2.Table14.Append;                                  {0058F5F5..F602}
      DataModule2.Table14Zeile.AsString := ' ';                     {0058F607..F61B}
      DataModule2.Table14.Post;                                    {0058F621..F630}
      DataModule2.Table14.Append;                                  {0058F636..F643}
      DataModule2.Table14Zeile.AsString :=                         {0058F648..F689 ucase [540]+60}
        ucase(DataModule2.Table1Name.AsString);
      DataModule2.Table14.Post;                                    {0058F68F..F69E}
      DataModule2.Table14.Append;                                  {0058F6A4..F6B1}
      DataModule2.Table14Zeile.AsString := ' ';                     {0058F6B6..F6CA}
      DataModule2.Table14.Post;                                    {0058F6D0..F6DF}
      prevName := DataModule2.Table1Name.AsString;                 {0058F6E5..F6F7 -> [ebp-44]}
    end;
    gvar_02536630 := '';                                           {0058F6FA..F6FC ebx=@gvar_02536630}
    Inc(idx);                                                      {0058F701}
    DataModule2.Table14.Append;                                    {0058F702..F70F}
    DataModule2.Table14Nm.AsString := IntToStr(idx);               {0058F714..F736 [1EC]+0B0}
    gvar_0253643C := ' ';                                          {0058F73C..F746 @LStrAsg 595458}
    if Trim(DataModule2.Table1Namex.AsString) <> '' then           {0058F74B..F77B [5BC] Trim jbe->F7C5}
      gvar_0253643C := gvar_0253643C + ' (' +                      {0058F77D..F7C0 CatN edx=3}
        Trim(DataModule2.Table1Namex.AsString) + ') ';
    gvar_02536630 := ucase(DataModule2.Table1Name.AsString) +      {0058F7C5..F822 CatN edx=3 -> ebx}
      gvar_0253643C + DataModule2.Table1Vornamen.AsString;
    if Trim(DataModule2.Table1Name.AsString) <> '' then            {0058F827..F857 Trim jbe->FAD9}
    begin
      if gvar_02536420 = 1 then                                    {0058F85D..F864 cmp1 jne->F8A1}
        gvar_02536630 := gvar_02536630 + ' [DS ' +                 {0058F866..F89C CatN edx=4 ebx}
          IntToStr(DataModule2.Table1Nummer.AsInteger) + ']';
      if gvar_02536414 = 1 then                                    {0058F8A1..F8A8 cmp1 jne->FA83}
      begin
        if gvar_02536418 = 1 then                                  {0058F8AE..F8B5 cmp1 jne->FA08}
        begin
          if DataModule2.Table1Gebjahr.AsString > ' ' then         {0058F8BB..F8E3 [55C] cmp' ' jbe->F98A}
          begin
            sub_00576F54(idx, u);                                  {0058F952..F95A eax=esi}
            gvar_02536440.Add(DataModule2.Table1Name.AsString +    {0058F8E9..F982 CatN ebp-2FC edx=7}
              ' ' + DataModule2.Table1Vornamen.AsString + ' * ' +
              DataModule2.Table1Gebjahr.AsString + '' + u);
          end
          else
          begin
            sub_00576F54(idx, u);                                  {0058F9D0..F9D8}
            gvar_02536440.Add(DataModule2.Table1Name.AsString +    {0058F98A..FA00 CatN ebp-310 edx=5}
              ' ' + DataModule2.Table1Vornamen.AsString + '' + u);
          end;
        end
        else
        begin
          sub_00576F54(idx, u);                                    {0058FA4E..FA56}
          gvar_02536440.Add(DataModule2.Table1Name.AsString +      {0058FA08..FA7E CatN ebp-320 edx=5}
            ' ' + DataModule2.Table1Vornamen.AsString + '' + u);
        end;
      end
      else
      begin
        sub_00576F54(idx, u);                                      {0058FAA6..FAAE}
        gvar_02536440.Add(DataModule2.Table1Name.AsString + '' + u); {0058FA83..FAD6 CatN ebp-330 edx=3}
      end;
    end; { 0058F827..FAD6 if Trim(Name) }
    if not gueltig then                                         {0058FAD9..FADF cmp [ebp-60]0 jne->FB30 = skip wenn gueltig}
      if Form1.lfbh2Aus.AsInteger > 0 then                      {0058FADF..FB0E [920]+58 test jle->FB30}
        gvar_02536630 := gvar_02536630 + ' [aus ' +             {0058FAF5..FB2B CatN edx=4 ebx}
          IntToStr(Form1.lfbh2Aus.AsInteger) + '] ';
    if gvar_02536404 = 1 then                                   {0058FB30..FB37 jne->FB9C}
      if Trim(DataModule2.Table1Religion.AsString) <> '' then   {0058FB39..FB69 [54C] Trim jbe->FB9C}
        gvar_02536630 := gvar_02536630 + ', ' +                 {0058FB6B..FB97 CatN edx=3 ebx}
          DataModule2.Table1Religion.AsString;
    if gvar_025363F0 = 1 then                                   {0058FB9C..FBA3 jne->FC6F}
    begin
      if Trim(DataModule2.Table1Beruf.AsString) <> '' then      {0058FBA9..FBD9 [550] Trim jbe->FC0C}
        gvar_02536630 := gvar_02536630 + ', ' +                 {0058FBDB..FC07 CatN edx=3 ebx}
          DataModule2.Table1Beruf.AsString;
      if Trim(DataModule2.Table1Hausname.AsString) <> '' then   {0058FC0C..FC3C [5C8] Trim jbe->FC6F}
        gvar_02536630 := gvar_02536630 + ', ' +                 {0058FC3E..FC6A CatN edx=3 ebx}
          DataModule2.Table1Hausname.AsString;
    end;
    if Trim(DataModule2.Table1Lebensort.AsString) <> '' then    {0058FC6F..FC9F [578] Trim jbe->FCD2}
      gvar_02536630 := gvar_02536630 + ' in ' +                 {0058FCA1..FCCD CatN edx=3 ebx}
        DataModule2.Table1Lebensort.AsString;
    if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or       {0058FCD2..FD02 [55C] ja->FD3A}
       (Trim(DataModule2.Table1Gebort.AsString) <> '') then      {0058FD04..FD34 [560] jbe->FEDD}
    begin
      sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' +     {0058FD3A..FDB0 inner CatN ebp-384 edx=5}
        DataModule2.Table1Gebmonat.AsString + '.' +              {0058FDB5..FDC1 -> [ebp-380]}
        DataModule2.Table1Gebjahr.AsString, v);
      gvar_02536630 := gvar_02536630 + ' * ' + v;                {0058FD3A..FDD3 CatN edx=3 ebx}
      if gvar_02536410 = 1 then                                  {0058FDD8..FDDF jne->FE51}
      begin
        if Trim(DataModule2.Table1Gebort.AsString) <> '' then    {0058FDE1..FE11 [560] Trim jbe->FE82}
        begin
          oabk(DataModule2.Table1Gebort.AsString, u);            {0058FE13..FE3A eax=[ebp-4]}
          gvar_02536664 := gvar_02536664 + u;                    {0058FE3F..FE4A LStrCat}
        end;
      end
      else
        gvar_02536630 := gvar_02536630 + ' ' +                   {0058FE51..FE7D CatN edx=3 ebx}
          DataModule2.Table1Gebort.AsString;
      sub_00576F54(idx, u);                                      {0058FEA5..FEAD eax=esi}
      gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + u); {0058FE82..FED5 CatN ebp-3A8 edx=3}
    end                                                          {0058FED8 jmp 005900E3 ueberspringt Tauf-Block}
    else
    begin
      if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or    {0058FEDD..FF0D [56C] ja->FF45}
         (Trim(DataModule2.Table1Taufort.AsString) <> '') then   {0058FF0F..FF3F [570] jbe->005900E3}
      begin
        sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' +  {0058FF45..FFBB inner ebp-3C8 edx=5}
          DataModule2.Table1Taufmonat.AsString + '.' +           {0058FFC0..FFCC -> [ebp-3C4]}
          DataModule2.Table1Taufjahr.AsString, v);
        gvar_02536630 := gvar_02536630 + ' ~ ' + v;              {0058FF45..FFDE CatN edx=3 ebx}
        if gvar_02536410 = 1 then                                {0058FFE3..FFEA jne->0059005C}
        begin
          if Trim(DataModule2.Table1Taufort.AsString) <> '' then {0058FFEC..001C [570] Trim jbe->0059008D}
          begin
            oabk(DataModule2.Table1Taufort.AsString, u);         {0059001E..0045}
            gvar_02536664 := gvar_02536664 + u;                  {0059004A..0055 LStrCat}
          end;
        end
        else
          gvar_02536630 := gvar_02536630 + ' ' +                 {0059005C..0088 CatN edx=3 ebx}
            DataModule2.Table1Taufort.AsString;
        sub_00576F54(idx, u);                                    {005900B0..00B8}
        gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + u); {0059008D..00E0 CatN ebp-3EC edx=3}
      end;
    end;
    if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or        {005900E3..0113 [584] ja->014B}
       (Trim(DataModule2.Table1Stort.AsString) <> '') then       {00590115..0145 [588] jbe->03CB}
    begin
      sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' +      {0059014B..01C1 inner ebp-40C edx=5}
        DataModule2.Table1Stmonat.AsString + '.' +               {005901C6..01D2 -> [ebp-408]}
        DataModule2.Table1Stjahr.AsString, v);
      gvar_02536630 := gvar_02536630 + ' + ' + v;                {0059014B..01E4 CatN edx=3 ebx}
      if gvar_02536410 = 1 then                                  {005901E9..01F0 jne->0262}
      begin
        if Trim(DataModule2.Table1Stort.AsString) <> '' then     {005901F2..0222 [588] Trim jbe->0293}
        begin
          oabk(DataModule2.Table1Stort.AsString, u);             {00590224..024B}
          gvar_02536664 := gvar_02536664 + u;                    {00590250..025B LStrCat}
        end;
      end
      else
        gvar_02536630 := gvar_02536630 + ' ' +                   {00590262..028E CatN edx=3 ebx}
          DataModule2.Table1Stort.AsString;
      sub_00576F54(idx, u);                                      {005902B6..02BE}
      gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + u); {00590293..02D4 CatN ebp-430 edx=3}
    end;
    if gvar_025363F8 = 1 then                                   {005902E9..02F0 jne->035A}
      if Trim(DataModule2.Table1Todesurs.AsString) <> '' then   {005902F2..0322 [58C] Trim jbe->035A}
        gvar_02536630 := gvar_02536630 + ' (' +                 {00590324..0355 CatN edx=4 ebx}
          DataModule2.Table1Todesurs.AsString + ')';
    if gvar_025363EC = 1 then                                   {0059035A..0361 jne->03CB}
      if Trim(DataModule2.Table1Alter.AsString) <> '' then      {00590363..0393 [5EC] Trim jbe->03CB}
        gvar_02536630 := gvar_02536630 + ' (' +                 {00590395..03C6 CatN edx=4 ebx}
          DataModule2.Table1Alter.AsString + ')';
    if gvar_025363F4 = 1 then                                   {005903CB..03D2 jne->0437}
      if Trim(DataModule2.Table1Kommentar.AsString) <> '' then  {005903D4..0404 [5B0] Trim jbe->0437}
        gvar_02536630 := gvar_02536630 + #13#10 +               {00590406..0432 CatN edx=3 ebx 595518}
          DataModule2.Table1Kommentar.AsString;
    if Trim(Form1.lfbh2Eh.AsString) <> '' then                  {00590437..0467 [914]+60 jbe->005944D1}
    begin
      i := Round(Length(Form1.lfbh2Eh.AsString) / 7);            {0059046D..04AF LStrLen fdiv 7 @ROUND [ebp-64]}
      if i > 0 then                                              {005904A7..04A9 test jle->005944D1}
      begin
        iEh := 1;                                                {005904B2 [ebp-14]}
        repeat                                                   {005904B9 = Loop-Head}
          n20 := 0;                                              {005904B9..04BB xor eax [ebp-20]}
          DataModule2.Table18.FindKey(                           {005904BE..04F2 [140] ohne Test}
            [DataModule2.Table1Nummer.AsInteger]);
          while DataModule2.Table18Nummer.AsInteger =           {00594497..44BF je->005904FC}
                DataModule2.Table1Nummer.AsInteger do
          begin
            if StrToInt(Copy(Form1.lfbh2Eh.AsString,             {005904FC..0558 LStrCopy+StrToInt vs [4CC]}
              (iEh - 1) * 7 + 1, 6)) =
              DataModule2.Table18Epnum.AsInteger then
            begin                                                {jne->005943D7 = Tail}
              patn := DataModule2.Table18Epnum.AsInteger;         {0059055E..0570 [4CC]+58 [ebp-30]}
              if Pos('Ehes', DataModule2.Table18Verbind.AsString) > 0 then {00590573..059D [4F8] jle->0C0B}
              begin
                if Trim(DataModule2.Table18Sajahr.AsString) <> '' then     {005905A3..05D3 [4EC] jbe->0635}
                begin
                  Form1.lfbh2.Edit;                                {005905D5..05E2 [8B8]}
                  if not gueltig then                              {005905E7..05EB [ebp-60] jne->0620}
                    Form1.lfbh2Hei.AsString :=                     {005905ED..061A [924] <- [4EC] Sajahr}
                      DataModule2.Table18Sajahr.AsString;
                  Form1.lfbh2.Post;                                {00590620..062F +248}
                end;
                if (Trim(DataModule2.Table18Sajahr.AsString) <> '') or   {00590635..0665 [4EC] ja->069D}
                   (Trim(DataModule2.Table18Saort.AsString) <> '') then  {00590667..0697 [4F0] jbe->08C3}
                begin
                  u := DataModule2.Table18Satag.AsString + '.' +    {0059069D..071D inner CatN ebp-49C edx=5}
                       DataModule2.Table18Samonat.AsString + '.' +
                       DataModule2.Table18Sajahr.AsString;
                  sub_00576FF8(u, v);                              {00590722..072E [ebp-498]}
                  gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + {0059069D..0740 CatN edx=5 ebx}
                    '- oo ' + v;                                   {00595538}
                  if gvar_02536410 = 1 then                        {00590745..074C jne->07BE}
                  begin
                    if Trim(DataModule2.Table18Saort.AsString) <> '' then {0059074E..077E [4F0] jbe->07EF}
                    begin
                      oabk(DataModule2.Table18Saort.AsString, u);  {00590780..07A7 eax=[ebp-4]}
                      gvar_02536664 := gvar_02536664 + u;          {005907AC..07B7 LStrCat}
                    end;
                  end
                  else
                    gvar_02536630 := gvar_02536630 + ' ' +         {005907BE..07EA CatN edx=3 ebx}
                      DataModule2.Table18Saort.AsString;
                  sub_00576F54(idx, u);                            {00590818..081A eax=esi}
                  gvar_02536444.Add(DataModule2.Table18Saort.AsString + '' + u); {005907EF..0842 CatN ebp-4C0 edx=3}
                  if gvar_025363FC = 1 then                        {00590845..084C jne->0BFD}
                    if Trim(DataModule2.Table18Satrauz.AsString) <> '' then {00590852..0882 [4F4] jbe->0BFD}
                      gvar_02536630 := gvar_02536630 + ' (TZ: ' + {00590888..08B9 CatN edx=4 ebx}
                        DataModule2.Table18Satrauz.AsString + ')';
                end
                else if (Trim(DataModule2.Table18Hjahr.AsString) <> '') or   {005908C3..08F3 [4D8] ja->092B}
                        (Trim(DataModule2.Table18Hort.AsString) <> '') then  {005908F5..0925 [4DC] jbe->0BE0}
                begin
                  u := DataModule2.Table18Htag.AsString + '.' +    {0059092B..09AB inner CatN ebp-4EC edx=5}
                       DataModule2.Table18Hmonat.AsString + '.' +
                       DataModule2.Table18Hjahr.AsString;
                  sub_00576FF8(u, v);                              {005909B0..09BC [ebp-4E8]}
                  gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + {0059092B..09CE CatN edx=5 ebx}
                    '- oo ' + v;
                  if gvar_02536410 = 1 then                        {005909D3..09DA jne->0AE2}
                  begin
                    if Trim(DataModule2.Table18Hjahr.AsString) <> '' then {005909E0..0A10 [4D8] jbe->0A72}
                    begin
                      Form1.lfbh2.Edit;                            {00590A12..0A1F [8B8]}
                      if not gueltig then                          {00590A24..0A28 [ebp-60] jne->0A5D}
                        Form1.lfbh2Hei.AsString :=                 {00590A2A..0A57 [924] <- [4D8] Hjahr}
                          DataModule2.Table18Hjahr.AsString;
                      Form1.lfbh2.Post;                            {00590A5D..0A6C +248}
                    end;
                    if Trim(DataModule2.Table18Hort.AsString) <> '' then {00590A72..0AA2 [4DC] jbe->0B13}
                    begin
                      oabk(DataModule2.Table18Hort.AsString, u);    {00590AA4..0ACB}
                      gvar_02536664 := gvar_02536664 + u;           {00590AD0..0ADB LStrCat}
                    end;
                  end
                  else
                    gvar_02536630 := gvar_02536630 + ' ' +          {00590AE2..0B0E CatN edx=3 ebx}
                      DataModule2.Table18Hort.AsString;
                  sub_00576F54(idx, u);                             {00590B3C..0B3E eax=esi}
                  gvar_02536444.Add(DataModule2.Table18Hort.AsString + '' + u); {00590B13..0B66 CatN ebp-51C edx=3}
                  if gvar_025363FC = 1 then                         {00590B69..0B70 jne->0BFD}
                    if Trim(DataModule2.Table18Trauz.AsString) <> '' then {00590B76..0BA6 [4E0] jbe->0BFD}
                      gvar_02536630 := gvar_02536630 + ' (TZ: ' +  {00590BA8..0BD9 CatN edx=4 ebx}
                        DataModule2.Table18Trauz.AsString + ')';
                end
                else
                  gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + '- oo'; {00590BE0..0BF8 CatN edx=4 ebx}
                gvar_02536630 := gvar_02536630 + ': ';              {00590BFD..0C04 LStrCat 595568}
              end                                                   {00590C09 jmp 00590C54}
              else
              begin
                if Pos('Bezie', DataModule2.Table18Verbind.AsString) > 0 then {00590C0B..0C35 [4F8] jle->0C54}
                  gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + {00590C37..0C4F CatN edx=4 ebx}
                    '- o-o : ';                                     {00595584}
              end;
              DataModule2.Table1.FindKey(                          {00590C54..0C85 [5C] ohne Test}
                [DataModule2.Table18Epnum.AsInteger]);
              gvar_02536630 := gvar_02536630 +                     {00590C8A..0CE8 CatN edx=4 ebx}
                ucase(DataModule2.Table1Name.AsString) + ' ' +      {00590CB0 ucase eax=[ebp-4]}
                DataModule2.Table1Vornamen.AsString;
              bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));        {00590CED..0D02 vtbl+150 [ebp-3C]}
              Form1.lfbh2.IndexName := 'Pro';                       {00590D05..0D17 [595418]}
              if (DataModule2.Table1Vater.AsInteger > 0) and        {00590D1C..0D30 [538] jle->108E}
                 (DataModule2.Table1Mutter.AsInteger > 0) then      {00590D36..0D4A [53C] jle->108E}
              begin
                if gueltig then                                     {00590D50..0D54 [ebp-60] jne->0EC0}
                begin
                  pnum := DataModule2.Table1Nummer.AsInteger;      {00590EC0..0ED2 [534]+58 -> edi}
                  DataModule2.Table17.Open;                        {00590ED4..0EE5 [13C]}
                  DataModule2.Table17.IndexName := '';             {00590EE6..0EF5 SetIndexName ''/0}
                  DataModule2.Table17.FindKey([pnum]);             {00590EFA..0F1C self}
                  DataModule2.Table17.FindKey(                    {00590F21..0F55 [948] Vater}
                    [DataModule2.Table17Vater.AsInteger]);
                  gvar_02536630 := gvar_02536630 + ' <' +          {00590F5A..0FAE CatN edx=6 ebx}
                    DataModule2.Table17Name.AsString + ' ' +       {00590F61..0F76 [950]}
                    DataModule2.Table17Vornamen.AsString + '/';    {00590F84..0F99 [954]}
                  DataModule2.Table17.FindKey([pnum]);             {00590FB3..0FD5 self}
                  DataModule2.Table17.FindKey(                    {00590FDA..100E [94C] Mutter}
                    [DataModule2.Table17Mutter.AsInteger]);
                  gvar_02536630 := gvar_02536630 +                 {00591013..1062 CatN edx=5 ebx}
                    DataModule2.Table17Name.AsString + ' ' +       {00591015..102A [950]}
                    DataModule2.Table17Vornamen.AsString + '>';    {00591038..104D [954]}
                  DataModule2.Table17.FindKey([pnum]);             {00591067..1089 self}
                end
                else
                begin
                  sub_00576EB0(DataModule2.Table1Vater.AsInteger, u); {00590D5A..0D77 [538] -> [ebp-544]}
                  if Form1.lfbh2.FindKey([u]) then                 {00590D7D..0DA7 [8B8] jne->0E7C else->108E}
                  begin
                    while StrToInt(Form1.lfbh2Prob.AsString) =     {00590E7C..0E9C [910] je->0DB4 else->108E}
                      DataModule2.Table1Vater.AsInteger do
                    begin
                      sub_00576EB0(DataModule2.Table1Mutter.AsInteger, u); {00590DB4..0DEB [53C] -> [ebp-54C]}
                      if Pos(u + '*', Form1.lfbh2Eh.AsString) > 0 then {00590DF0..0E0E [914] jle->0E50}
                      begin
                        gvar_02536630 := gvar_02536630 + ' [aus ' + {00590E10..0E46 CatN edx=4 ebx}
                          IntToStr(Form1.lfbh2Nm.AsInteger) + '] ';  {00590E29..0E3A [90C]}
                        Break;                                       {00590E4B jmp ->108E}
                      end;
                      Form1.lfbh2.Next;                              {00590E50..0E5D}
                      if Form1.lfbh2.Eof then Break;                 {00590E62..0E76 jne->108E}
                    end;
                  end;
                end;
              end;
              Form1.lfbh2.IndexName := 'na';                            {0059108E..10A0 [59543C]}
              if gueltig then                                           {005910A5..10A9 [ebp-60] je->10C2}
                Form1.lfbh2.IndexName := 'heir';                        {005910AB..10BD [595448]}
              Form1.lfbh2.GotoBookmark(bmk);                            {005910C2..10D4 vtbl+1A0}
              if Trim(DataModule2.Table1Name.AsString) <> '' then       {005910DA..110A Trim jbe->138C}
              begin
                if gvar_02536420 = 1 then                               {00591110..1117 jne->1154}
                  gvar_02536630 := gvar_02536630 + ' [DS ' +            {00591119..114F CatN edx=4 ebx}
                    IntToStr(DataModule2.Table1Nummer.AsInteger) + ']';
                if gvar_02536414 = 1 then                               {00591154..115B jne->1336}
                begin
                  if gvar_02536418 = 1 then                             {00591161..1168 jne->12BB}
                  begin
                    if DataModule2.Table1Gebjahr.AsString > ' ' then    {0059116E..1196 LStrCmp jbe->123D}
                    begin
                      sub_00576F54(idx, u);                             {00591205..1212 eax=esi}
                      gvar_02536440.Add(DataModule2.Table1Name.AsString + {0059119C..1235 CatN ebp-578 edx=7}
                        ' ' + DataModule2.Table1Vornamen.AsString + ' * ' +
                        DataModule2.Table1Gebjahr.AsString + '' + u);
                    end
                    else
                    begin
                      sub_00576F54(idx, u);                             {00591283..1290}
                      gvar_02536440.Add(DataModule2.Table1Name.AsString + {0059123D..12B3 CatN ebp-58C edx=5}
                        ' ' + DataModule2.Table1Vornamen.AsString + '' + u);
                    end;
                  end
                  else
                  begin
                    sub_00576F54(idx, u);                               {00591301..1309}
                    gvar_02536440.Add(DataModule2.Table1Name.AsString + {005912BB..1331 CatN ebp-59C edx=5}
                      ' ' + DataModule2.Table1Vornamen.AsString + '' + u);
                  end;
                end
                else
                begin
                  sub_00576F54(idx, u);                                 {00591359..1361}
                  gvar_02536440.Add(DataModule2.Table1Name.AsString + '' + u); {00591336..1389 CatN ebp-5AC edx=3}
                end;
              end; { 005910DA..138C if Trim(Name) }
              if gvar_02536404 = 1 then                                 {0059138C..1393 jne->13F8}
                if Trim(DataModule2.Table1Religion.AsString) <> '' then {00591395..13C5 [54C] jbe->13F8}
                  gvar_02536630 := gvar_02536630 + ', ' +               {005913C7..13F3 CatN edx=3 ebx}
                    DataModule2.Table1Religion.AsString;
              if gvar_025363F0 = 1 then                                 {005913F8..13FF jne->14CB}
              begin
                if Trim(DataModule2.Table1Beruf.AsString) <> '' then    {00591405..1435 [550] jbe->1468}
                  gvar_02536630 := gvar_02536630 + ', ' +               {00591437..1463 CatN edx=3 ebx}
                    DataModule2.Table1Beruf.AsString;
                if Trim(DataModule2.Table1Hausname.AsString) <> '' then {00591468..1498 [5C8] jbe->14CB}
                  gvar_02536630 := gvar_02536630 + ', ' +               {0059149A..14C6 CatN edx=3 ebx}
                    DataModule2.Table1Hausname.AsString;
              end;
              if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or    {005914CB..14FB [55C] ja->1533}
                 (Trim(DataModule2.Table1Gebort.AsString) <> '') then   {005914FD..152D [560] jbe->16D6}
              begin
                sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' +  {00591533..15AE inner CatN ebp-5F0 edx=5}
                  DataModule2.Table1Gebmonat.AsString + '.' +
                  DataModule2.Table1Gebjahr.AsString, v);
                gvar_02536630 := gvar_02536630 + ' * ' + v;            {005915BF..15CC CatN edx=3 ebx}
                if gvar_02536410 = 1 then                               {005915D1..15D8 jne->164A}
                begin
                  if Trim(DataModule2.Table1Gebort.AsString) <> '' then {005915DA..160A [560] jbe->167B}
                  begin
                    oabk(DataModule2.Table1Gebort.AsString, u);         {0059160C..1633 eax=[ebp-4]}
                    gvar_02536664 := gvar_02536664 + u;                 {00591638..1643 LStrCat}
                  end;
                end
                else
                  gvar_02536630 := gvar_02536630 + ' ' +                {0059164A..1676 CatN edx=3 ebx}
                    DataModule2.Table1Gebort.AsString;
                sub_00576F54(idx, u);                                   {0059169E..16AB eax=esi}
                gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + u); {0059167B..16CE CatN ebp-614 edx=3}
              end
              else if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or {005916D6..1706 [56C] ja->173E}
                      (Trim(DataModule2.Table1Taufort.AsString) <> '') then {00591708..1738 [570] jbe->18DC}
              begin
                sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' + {0059173E..17B4 inner CatN ebp-634 edx=5}
                  DataModule2.Table1Taufmonat.AsString + '.' +
                  DataModule2.Table1Taufjahr.AsString, v);
                gvar_02536630 := gvar_02536630 + ' ~ ' + v;             {005917CA..17D7 CatN edx=3 ebx}
                if gvar_02536410 = 1 then                                {005917DC..17E3 jne->1855}
                begin
                  if Trim(DataModule2.Table1Taufort.AsString) <> '' then  {005917E5..1815 [570] jbe->1886}
                  begin
                    oabk(DataModule2.Table1Taufort.AsString, u);          {00591817..183E}
                    gvar_02536664 := gvar_02536664 + u;
                  end;
                end
                else
                  gvar_02536630 := gvar_02536630 + ' ' +                  {00591855..1881 CatN edx=3 ebx}
                    DataModule2.Table1Taufort.AsString;
                sub_00576F54(idx, u);                                     {005918A9..18B1 eax=esi}
                gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + u); {00591886..18D9}
              end;
              if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or      {005918DC..190C [584] ja->1944}
                 (Trim(DataModule2.Table1Stort.AsString) <> '') then     {0059190E..193E [588] jbe->1BC4}
              begin
                sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' +    {00591944..19BA inner CatN ebp-678 edx=5}
                  DataModule2.Table1Stmonat.AsString + '.' +
                  DataModule2.Table1Stjahr.AsString, v);
                gvar_02536630 := gvar_02536630 + ' + ' + v;              {005919D0..19DD CatN edx=3 ebx}
                if gvar_02536410 = 1 then                                 {005919E2..19E9 jne->1A5B}
                begin
                  if Trim(DataModule2.Table1Stort.AsString) <> '' then    {005919EB..1A1B [588] jbe->1A8C}
                  begin
                    oabk(DataModule2.Table1Stort.AsString, u);            {00591A1D..1A44}
                    gvar_02536664 := gvar_02536664 + u;
                  end;
                end
                else
                  gvar_02536630 := gvar_02536630 + ' ' +                  {00591A5B..1A87 CatN edx=3 ebx}
                    DataModule2.Table1Stort.AsString;
                sub_00576F54(idx, u);                                      {00591AAF..1AB7 eax=esi}
                gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + u); {00591A8C..1ADF}
              end;
              if gvar_025363F8 = 1 then                                    {00591AE2..1AE9 jne->1B53}
                if Trim(DataModule2.Table1Todesurs.AsString) <> '' then    {00591AEB..1B1B [58C] jbe->1B53}
                  gvar_02536630 := gvar_02536630 + ' (' +                  {00591B1D..1B4E CatN edx=4 ebx}
                    DataModule2.Table1Todesurs.AsString + ')';
              if gvar_025363EC = 1 then                                    {00591B53..1B5A jne->1BC4}
                if Trim(DataModule2.Table1Alter.AsString) <> '' then      {00591B5C..1B8C [5EC] jbe->1BC4}
                  gvar_02536630 := gvar_02536630 + ' (' +                  {00591B8E..1BBF CatN edx=4 ebx}
                    DataModule2.Table1Alter.AsString + ')';
              if gvar_025363F4 = 1 then                                    {00591BC4..1BCB jne->1CBC}
                if Trim(DataModule2.Table1Kommentar.AsString) <> '' then   {00591BD1..1C01 [5B0] jbe->1CBC}
                begin
                  Form1.Memo1.Clear;                                       {00591C07..1C16 [40C] vtbl+0DC}
                  Form1.Memo1.Lines.Add(DataModule2.Table1Kommentar.AsString); {00591C1C..1C3E [40C]+220 vtbl+8}
                  if Form1.Memo1.Lines.Count > 0 then                      {00591C41..1C5C Count-1 jl->1CBC}
                    for k := 0 to Form1.Memo1.Lines.Count - 1 do           {00591C5E..1C62 [ebp-18]}
                      gvar_02536630 := gvar_02536630 + #13#10 +           {00591C69..1CB7 CatN edx=3 ebx}
                        Trim(Form1.Memo1.Lines[k]);
                end;
              DataModule2.Table1.IndexName := '';                          {00591CBC..1CC8 SetIndexName 0}
              DataModule2.Table1.First;                                    {00591CCD..1CD7}
              DataModule2.Table1.FindKey([t1Num]);                         {00591CDC..1CFE [ebp-10]}
              if UpperCase(DataModule2.Table1Geschlecht.AsString) <> 'M' then {00591D03..1D3C jne->310B}
              begin
                s50 := '';                                       {0059314A..4D LStrClr [ebp-50]}
                DataModule2.Table1.IndexName := 'mut';           {00593152..61 [595424]}
                DataModule2.Table1.First;                        {00593166..70}
                DataModule2.Table1.FindKey([t1Num]);             {00593175..97 [ebp-10]}
                if DataModule2.Table1.Found then                 {0059319C je->005943D7}
                begin
                  while DataModule2.Table1Mutter.AsInteger = t1Num do begin {005943BC..CE je->005931A9}
                    if DataModule2.Table1Vater.AsInteger = patn then begin    {005931A9..BE je->005931C4; jne->0059434C}
                    begin
                      Inc(n1C);                                   {005931C4 / C7}
                      Inc(n20);                                   {005931C7}
                      if n20 = 1 then                             {005931CA..CE jne->005931ED}
                        gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + 'Kind(er): '; {005931D0..E8 CatN ebx edx=4}
                      if Form24.CheckBox14.Checked then           {005931F6..FC je->005935C9}
                      begin
                        gvar_0253643C := ' ';                     {0059320A..14}
                        if gvar_02536424 = 1 then                {00593219..20 jne->0059329C}
                          if Trim(DataModule2.Table1Namex.AsString) <> '' then {00593222..4B jbe->0059329C}
                            gvar_0253643C := gvar_0253643C + ' (' + Trim(DataModule2.Table1Namex.AsString) + ') '; {00593254..97 CatN 253643C edx=3}
                        gvar_02536630 := gvar_02536630 + ' - ' + IntToStr(n1C) + '. ' + {0059329C..BF CatN ebx edx=7}
                          DataModule2.Table1Name.AsString + gvar_0253643C + DataModule2.Table1Vornamen.AsString;
                      end else
                      begin
                        gvar_0253643C := ' ';                     {005935C9..D3}
                        if gvar_02536424 = 1 then                {005935D8..DF jne->0059365B}
                          if Trim(DataModule2.Table1Namex.AsString) <> '' then {005935E1..F6 jbe->0059365B}
                            gvar_0253643C := gvar_0253643C + ' (' + Trim(DataModule2.Table1Namex.AsString) + ') '; {00593613..56 CatN 253643C edx=3}
                        gvar_02536630 := gvar_02536630 + ' - ' + IntToStr(n1C) + '. ' + {0059365B..C4 CatN ebx edx=7}
                          DataModule2.Table1Name.AsString + gvar_0253643C + DataModule2.Table1Vornamen.AsString;
                      end;                                        {005936F9 Trim-Test teilt beide Arms}
                      if Trim(DataModule2.Table1Name.AsString) <> '' then begin {0059333F jbe->0059397B}
                        if gvar_02536420 = 1 then                {005936F2..99 jne->00593743}
                          gvar_02536630 := gvar_02536630 + ' [DS ' + IntToStr(DataModule2.Table1Nummer.AsInteger) + ']'; {00593708..3E CatN ebx edx=4}
                        if gvar_02536414 = 1 then                {00593743..4A jne->005938AA}
                        begin
                          if gvar_02536418 = 1 then              {00593750..57 jne->005938A4}
                          begin
                            if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then begin {0059375D..81 jbe->0059382C}
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + ' * ' + DataModule2.Table1Gebjahr.AsString + v); {0059378B..27 CatN ebp-980 edx=7}
                            end else begin
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {00593842..A5 CatN edx=5}
                            end;
                          end else begin
                            sub_00576F54(idx, v);
                            gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {00593925..6B CatN edx=5}
                          end;
                        end else begin
                          sub_00576F54(idx, v);
                          gvar_02536440.Add(DataModule2.Table1Name.AsString + '' + v); {00593925..6B}
                        end;
                        {005938AA/25 Arms Ende - jmp 0059397B}
                      end;
                      {0059397B [38]=0 + lfbh2-Marker/Scan/Restore (W)}
                      eli := 0;                                    {0059397D [ebp-38]}
                      gvar_02536454 := Form1.lfbh2.IndexName;      {00593980..A3}
                      bmk := TBookmark(PChar(Form1.lfbh2.Bookmark)); {005939A8..BD vtbl+150}
                      Form1.lfbh2.IndexName := 'Pro';              {005939C0..D2}
                      Form1.lfbh2.First;                           {005939D7..E4}
                      if gueltig then begin                        {005939E9 je->skip}
                        u := '';
                        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {005939ED..F6}
                        if Form1.lfbh2.FindKey([u]) then begin    {00593A02 hopp else koerper}
                          gvar_02536630 := gvar_02536630 + ' [' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {00593A44..7A CatN edx=4}
                          eli := 1;                               {00593A7F}
                        end;
                        Form1.lfbh2.First;                         {00593A86..98}
                        while not Form1.lfbh2.Eof do begin         {00593AA0 je->tail}
                          u := '';
                          sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {00593ACB..D6}
                          u := u + '*';
                          if Pos(u, Form1.lfbh2Eh.AsString) > 0 then begin {00593AF0 je->...}
                            gvar_02536630 := gvar_02536630 + ' [oo ' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {00593B50..2F CatN edx=4}
                            eli := 1;                             {00593B34}
                          end;
                          Form1.lfbh2.Next;                         {00593B39..48}
                        end;
                      end;                                        {00593B63..77}
                      Form1.lfbh2.IndexName := gvar_02536454;      {00593B7D..90}
                      Form1.lfbh2.GotoBookmark(bmk);               {00593BA5..B7 vtbl+1A0}
                      if eli = 0 then begin                          {00593BB1..BE jne->0059439A}
                        if gvar_02536404 = 1 then                  {00593BC0..E2 jne->00593C23}
                        begin
                          if Trim(DataModule2.Table1Religion.AsString) <> '' then {00593BC5..F0 jbe->3C23}
                            gvar_02536630 := gvar_02536630 + ', ' + DataModule2.Table1Religion.AsString; {00593BF2..1E CatN ebx edx=3}
                        end;
                        if gvar_025363F0 = 1 then                  {00593C23..2A jne->00593CF6}
                        begin
                          if Trim(DataModule2.Table1Beruf.AsString) <> '' then {00593C30..60 jbe->3C93}
                            gvar_02536630 := gvar_02536630 + ', ' + DataModule2.Table1Beruf.AsString; {00593C62..8E CatN ebx edx=3}
                        end;
                        if Trim(DataModule2.Table1Hausname.AsString) <> '' then {00593C93..FBC jbe->3CF6}
                          gvar_02536630 := gvar_02536630 + ', ' + DataModule2.Table1Hausname.AsString; {00593CC5..F1 CatN ebx edx=3}
                        if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or
                           (Trim(DataModule2.Table1Gebort.AsString) <> '') then begin {00593CF6..D26 je->3D5E}
                          gvar_02536630 := gvar_02536630 + ' * ' + Trim(DataModule2.Table1Gebtag.AsString) + '.' + Trim(DataModule2.Table1Gebmonat.AsString) + '.' + Trim(DataModule2.Table1Gebjahr.AsString); {00593F41..1C CatN ebx edx=3}
                          sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' + DataModule2.Table1Gebmonat.AsString + '.' + DataModule2.Table1Gebjahr.AsString, v); {00593DF5..1A}
                          gvar_02536630 := gvar_02536630 + v;
                          if gvar_02536410 = 1 then begin          {00593DFC..03 jne->3E7C}
                            if Trim(DataModule2.Table1Gebort.AsString) <> '' then begin {00593E05..35 jbe->F3D3}
                              oabk(DataModule2.Table1Gebort.AsString, v); {00593E4B..62}
                              gvar_02536664 := gvar_02536664 + v;
                            end;
                          end
                        else
                          gvar_02536630 := gvar_02536630 + ' ' + DataModule2.Table1Gebort.AsString;
                        sub_00576F54(idx, v);                       {00593E9A..AA}
                        gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + v); {00593EAA..D2}
                        end else begin
                          if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or
                             (Trim(DataModule2.Table1Taufort.AsString) <> '') then begin {00593ED7..F7 jbe->F3D3}
                            gvar_02536630 := gvar_02536630 + ' ~ ' + Trim(DataModule2.Table1Tauftag.AsString) + '.' + Trim(DataModule2.Table1Taufmonat.AsString) + '.' + Trim(DataModule2.Table1Taufjahr.AsString); {00593F3F..E3 CatN ebx edx=5}
                            sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' + DataModule2.Table1Taufmonat.AsString + '.' + DataModule2.Table1Taufjahr.AsString, v); {00593FCA..03}
                            gvar_02536630 := gvar_02536630 + v + ' ' + DataModule2.Table1Taufort.AsString; {00593FFB..4B CatN ebx edx=5}
                            if gvar_02536410 = 1 then begin       {00594000..07 jne->3DB5}
                              if Trim(DataModule2.Table1Taufort.AsString) <> '' then begin {00594009..39 jbe->F3D3}
                                oabk(DataModule2.Table1Taufort.AsString, v); {0059403F..56}
                                gvar_02536664 := gvar_02536664 + v;
                              end;
                            end
                          else
                            gvar_02536630 := gvar_02536630 + ' ' + DataModule2.Table1Taufort.AsString;
                        end;
                        sub_00576F54(idx, v);                       {005940A0..B8}
                        gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + v); {005940B3..D1}
                      end;
                    if gvar_02536400 = 1 then                     {005940D3..DA jne->00594144}
                    begin
                      if Trim(DataModule2.Table1Taufpat.AsString) <> '' then {005940DC..0E0 jbe}
                        gvar_02536630 := gvar_02536630 + ' (TP: ' + DataModule2.Table1Taufpat.AsString + ')'; {0059410E..3F CatN ebx edx=4}
                    end;
                    if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or
                       (Trim(DataModule2.Table1Stort.AsString) <> '') then begin {00594144..D26 je->AC}
                      gvar_02536630 := gvar_02536630 + ' + ' + Trim(DataModule2.Table1Sttag.AsString) + '.' + Trim(DataModule2.Table1Stmonat.AsString) + '.' + Trim(DataModule2.Table1Stjahr.AsString); {005941AC..E3 CatN ebx edx=3}
                      sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' + DataModule2.Table1Stmonat.AsString + '.' + DataModule2.Table1Stjahr.AsString, v); {00594233..53}
                      gvar_02536630 := gvar_02536630 + v;
                      if gvar_02536410 = 1 then begin          {00594251..57 jne->3F9F}
                        if Trim(DataModule2.Table1Stort.AsString) <> '' then begin {00594253..83 jbe->F4}
                          oabk(DataModule2.Table1Stort.AsString, v); {00594285..AC}
                          gvar_02536664 := gvar_02536664 + v;
                        end;
                      end
                    else
                      gvar_02536630 := gvar_02536630 + ' ' + DataModule2.Table1Stort.AsString;
                    sub_00576F54(idx, v);                       {005942C3..DC}
                    gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + v); {005942F4..12}
                    end;                                        {0059434A jmp 0059439A}
                  end;
                    end;
                    end
                    else
                  if DataModule2.Table1Vater.AsInteger = 0 then begin   {0059434C..60 jne->0059439A}
                    u := '';
                    sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {00594362..7D}
                    s50 := s50 + u + '*';                           {00594382..95 CatN [ebp-50] edx=3}
                  end;
                  DataModule2.Table1.Next;                        {0059439A..A4}
                  if DataModule2.Table1.Eof then Break;           {005943B3..BA jne->005943D7}
                end;
              end
            end
            else
            begin
              s4C := '';                                       {00591D42..1D45 LStrClr [ebp-4C]}
              DataModule2.Table1.IndexName := 'vat';           {00591D4A..1D59}
              DataModule2.Table1.First;                        {00591D5E..1D68}
              if patn > 0 then                                 {00591D6D..1D71 jle->0059309D}
              begin
                DataModule2.Table1.FindKey([t1Num]);           {00591D77..1D99}
                if DataModule2.Table1.Found then               {00591D9E..1DA0 je->0059309D}
                begin
                  while DataModule2.Table1Vater.AsInteger = t1Num do begin {00593082..897 je->00591DAB; jne->0059309D}
                    if DataModule2.Table1Mutter.AsInteger = patn then begin {00591DB2..C0 je->Koerper; jne->00593012}
                    begin
                      Inc(n1C);                                 {00591DC6}
                      Inc(n20);                                 {00591DC9}
                      if n20 = 1 then                           {00591DCC..D0 jne->00591DEF}
                        gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + 'Kind(er): '; {00591DD2..EA CatN ebx edx=4}
                      if Form24.CheckBox14.Checked then       {00591DEF..E06 je->005921CB}
                      begin
                        gvar_0253643C := ' ';                   {00591E0C..16}
                        if gvar_02536424 = 1 then              {00591E1B..22 jne->00591E9E}
                          if Trim(DataModule2.Table1Namex.AsString) <> '' then {00591E24..4B jbe->00591E9E}
                            gvar_0253643C := gvar_0253643C + ' (' + Trim(DataModule2.Table1Namex.AsString) + ') '; {00591E56..99 CatN 253643C edx=3}
                        gvar_02536630 := gvar_02536630 + #13#10 + ' - ' + IntToStr(n1C) + '. ' + {00591E9E..F05 CatN ebx edx=8}
                          DataModule2.Table1Name.AsString + gvar_0253643C + DataModule2.Table1Vornamen.AsString;
                      end else
                      begin
                        gvar_0253643C := ' ';                   {005921CB..D5}
                        if gvar_02536424 = 1 then              {005921DA..E1 jne->0059225D}
                          if Trim(DataModule2.Table1Namex.AsString) <> '' then {005921E3..FB jbe->0059225D}
                            gvar_0253643C := gvar_0253643C + ' (' + Trim(DataModule2.Table1Namex.AsString) + ') '; {00592215..58 CatN 253643C edx=3}
                        gvar_02536630 := gvar_02536630 + ' - ' + IntToStr(n1C) + '. ' + {0059225D..BF CatN ebx edx=7}
                          DataModule2.Table1Name.AsString + gvar_0253643C + DataModule2.Table1Vornamen.AsString;
                      end;
                      if Trim(DataModule2.Table1Name.AsString) <> '' then begin {00591F41 jbe->0059257D}
                        if gvar_02536420 = 1 then              {00591F47..4E jne->00591F8B}
                          gvar_02536630 := gvar_02536630 + ' [DS ' + IntToStr(DataModule2.Table1Nummer.AsInteger) + ']'; {00591F50..86 CatN ebx edx=4}
                        if gvar_02536414 = 1 then              {00591F8B..92 jne->00592170}
                        begin
                          if gvar_02536418 = 1 then            {00591F98..9F jne->005920F2}
                          begin
                            if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then begin {00591FA5..CD jbe->00592074}
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + ' * ' + DataModule2.Table1Gebjahr.AsString + v); {00591FD3..6C CatN ebp-704 edx=7}
                            end else begin
                              sub_00576F54(idx, v);
                              gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {00592074..EB edx=5}
                            end;
                          end else begin
                            sub_00576F54(idx, v);
                            gvar_02536440.Add(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString + v); {005920F2..ED edx=5}
                          end;
                        end else begin
                          sub_00576F54(idx, v);
                          gvar_02536440.Add(DataModule2.Table1Name.AsString + '' + v); {00592170..C3 edx=3}
                        end;
                      end;                                      {005922C6 / 005920ED jmp -> 0059257D}
                      { 0059257Dff [38]=0 + lfbh2-Marker/Scan/Restore + gesp. Haupt (M) }
                      eli := 0;                                {0059257F [ebp-38]}
                      gvar_02536454 := Form1.lfbh2.IndexName;   {00592582..A3}
                      bmk := TBookmark(PChar(Form1.lfbh2.Bookmark)); {005925AA..BF vtbl+150}
                      Form1.lfbh2.IndexName := 'Pro';           {005925C2..D4}
                      Form1.lfbh2.First;                        {005925D9..E6}
                      if gueltig then begin                    {005925EB je->skip 0059268B}
                        u := '';
                        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {005925F8..10}
                        if Form1.lfbh2.FindKey([u]) then begin {00592607..43 je->skip}
                          gvar_02536630 := gvar_02536630 + ' [' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {00592649..7F CatN edx=4}
                          eli := 1;                           {00592684 [ebp-38]}
                        end;
                        Form1.lfbh2.First;                      {0059268B..98}
                        while not Form1.lfbh2.Eof do begin    {tail 005926A4 je->0059278F; jmp 00592775}
                          u := '';
                          sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {005926C7..F6}
                          u := u + '*';
                          if Pos(u, Form1.lfbh2Eh.AsString) > 0 then begin {00592702 jle->0059274D}
                            gvar_02536630 := gvar_02536630 + ' [oo ' + IntToStr(Form1.lfbh2Nm.AsInteger) + ']'; {0059270B..41 CatN edx=4}
                            eli := 1;                          {00592746}
                          end;
                          Form1.lfbh2.Next;                      {0059274D..5A}
                        end;
                      end;                                     {E-Bel 0059269D..AA}
                      Form1.lfbh2.IndexName := gvar_02536454;  {0059278F..A2}
                      Form1.lfbh2.GotoBookmark(bmk);           {005927A7..B9 vtbl+1A0}
                      if eli = 0 then begin                    {005927BF..C3 jne->00593012}
                        if gvar_02536404 = 1 then              {005927C9..D0 jne->00592835}
                        begin
                          if Trim(DataModule2.Table1Religion.AsString) <> '' then {005927D2..02 jbe->00592835}
                            gvar_02536630 := gvar_02536630 + ', ' + DataModule2.Table1Religion.AsString; {00592804..30CatN ebx edx=3}
                        end;
                        if gvar_025363F0 = 1 then              {00592835..3C jne->005928A5}
                        begin
                          if Trim(DataModule2.Table1Beruf.AsString) <> '' then {00592842..72 jbe->005928A5}
                            gvar_02536630 := gvar_02536630 + ', ' + DataModule2.Table1Beruf.AsString; {00592874..A0 CatN ebx edx=3}
                        end;
                        if Trim(DataModule2.Table1Hausname.AsString) <> '' then {005928A5..D5 jbe->00592908}
                          gvar_02536630 := gvar_02536630 + ', ' + DataModule2.Table1Hausname.AsString; {005928D7..03 CatN ebx edx=3}
                        if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or
                           (Trim(DataModule2.Table1Gebort.AsString) <> '') then begin {00592908..38 je->00592970}
                          gvar_02536630 := gvar_02536630 + ' * ' + Trim(DataModule2.Table1Gebtag.AsString) + '.' + Trim(DataModule2.Table1Gebmonat.AsString) + '.' + Trim(DataModule2.Table1Gebjahr.AsString); {00592970..C9 CatN ebp-800 edx=5}
                          sub_00576FF8(DataModule2.Table1Gebtag.AsString + '.' + DataModule2.Table1Gebmonat.AsString + '.' + DataModule2.Table1Gebjahr.AsString, v); {005929EB..23}
                          gvar_02536630 := gvar_02536630 + v;
                          if gvar_02536410 = 1 then begin     {00592A0E..15 jne->00592A87}
                            if Trim(DataModule2.Table1Gebort.AsString) <> '' then begin {00592A17..47 jbe->00592AB8}
                              oabk(DataModule2.Table1Gebort.AsString, v); {00592A49..62}
                              gvar_02536664 := gvar_02536664 + v;
                            end;
                          end
                        else
                          gvar_02536630 := gvar_02536630 + ' ' + DataModule2.Table1Gebort.AsString; {00592A87..AF CatN ebx edx=3}
                          sub_00576F54(idx, v);                 {00592ABD..CD}
                          gvar_02536444.Add(DataModule2.Table1Gebort.AsString + '' + v); {00592AD6..E0}
                        end else begin                          {St-Tag r 00592B13}
                          if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or
                             (Trim(DataModule2.Table1Taufort.AsString) <> '') then begin {00592B13..75 ja->00592B7B nein->00592D19}
                            gvar_02536630 := gvar_02536630 + ' ~ ' + Trim(DataModule2.Table1Tauftag.AsString) + '.' + Trim(DataModule2.Table1Taufmonat.AsString) + '.' + Trim(DataModule2.Table1Taufjahr.AsString); {00592B7B..C0 CatN ebp-800 edx=5}
                            sub_00576FF8(DataModule2.Table1Tauftag.AsString + '.' + DataModule2.Table1Taufmonat.AsString + '.' + DataModule2.Table1Taufjahr.AsString, v); {00592BF6..0D}
                            gvar_02536630 := gvar_02536630 + v;
                            if gvar_02536410 = 1 then begin   {00592C19..20 jne->00592C92}
                              if Trim(DataModule2.Table1Taufort.AsString) <> '' then begin {00592C22..52 jbe->00592CC3}
                                oabk(DataModule2.Table1Taufort.AsString, v); {00592C54..5D}
                                gvar_02536664 := gvar_02536664 + v;
                              end;
                            end
                          else
                            gvar_02536630 := gvar_02536630 + ' ' + DataModule2.Table1Taufort.AsString; {00592C92..BA}
                            sub_00576F54(idx, v);                 {00592CC3..D4}
                            gvar_02536444.Add(DataModule2.Table1Taufort.AsString + '' + v); {00592CD6..08}
                          end;
                        end;
                        if gvar_02536400 = 1 then                {00592D19..20 jne->00592D8A}
                        begin
                          if Trim(DataModule2.Table1Taufpat.AsString) <> '' then {00592D22..52 jbe->00592D8A}
                            gvar_02536630 := gvar_02536630 + ' (TP: ' + DataModule2.Table1Taufpat.AsString + ')'; {00592D54..05 CatN ebx edx=4}
                        end;
                        if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or
                           (Trim(DataModule2.Table1Stort.AsString) <> '') then begin {00592D8A..FB ja->00592DEA nein->00592F90}
                          gvar_02536630 := gvar_02536630 + ' + ' + Trim(DataModule2.Table1Sttag.AsString) + '.' + Trim(DataModule2.Table1Stmonat.AsString) + '.' + Trim(DataModule2.Table1Stjahr.AsString); {00592DEA..699 CatN ebp-894 edx=5}
                          sub_00576FF8(DataModule2.Table1Sttag.AsString + '.' + DataModule2.Table1Stmonat.AsString + '.' + DataModule2.Table1Stjahr.AsString, v); {00592E6E..93}
                          gvar_02536630 := gvar_02536630 + v;
                          if gvar_02536410 = 1 then begin     {00592E9E..05}
                            if Trim(DataModule2.Table1Stort.AsString) <> '' then begin {00592EAC..29 jbe->00592F3A}
                              oabk(DataModule2.Table1Stort.AsString, v); {00592ED1..EE}
                              gvar_02536664 := gvar_02536664 + v;
                            end;
                          end
                        else
                          gvar_02536630 := gvar_02536630 + ' ' + DataModule2.Table1Stort.AsString; {00592F83..A4}
                          sub_00576F54(idx, v);                 {00592FB1..CB}
                          gvar_02536444.Add(DataModule2.Table1Stort.AsString + '' + v); {00592FBE..34}
                        end;
                        if gvar_025363F4 = 1 then                {00592F98..A5 jne->00593012}
                        begin
                          if Trim(DataModule2.Table1Kommentar.AsString) <> '' then {00592FA5..C9 bJ->00593012}
                            gvar_02536630 := gvar_02536630 + ' (' + DataModule2.Table1Kommentar.AsString + ')'; {00592FDB..041 CatN ebx edx=4}
                        end;
                      end;                                     {end if eli=0 (M)}
                    end;                                         {end if Mutter=patn}
                    end;                                         {end if Mutter=patn inner}
                    if DataModule2.Table1Mutter.AsInteger = 0 then begin {00593024 eax=test jne->00593060}
                      u := '';
                      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {00593026..3D}
                      s4C := s4C + u + '*';                   {00593048..5M CatN [ebp-4C] edx=3}
                    end;
                    DataModule2.Table1.Next;                   {00593060..6F}
                    if DataModule2.Table1.Eof then Break;      {00593079 jne->0059309D}
                  end;
                end;
              end;
              if Trim(s4C) <> '' then                          {0059309D..B2 [ebp-8D8] Trim jbe->005930E6}
              begin
                illki(s4C, idx, s);                           {005930C7..CFA}
                gvar_02536630 := gvar_02536630 + #13#10 + 'Mutter nicht bekannt: ' + s; {005930D4..01 CatN ebx edx=4}
              end;
              DataModule2.Table1.IndexName := '';              {005930E6..F2}
              DataModule2.Table1.First;                        {005930F7..01}
            end;
            end; {schließt if Copy=Epnum @3624}
            if Trim(s50) <> '' then                             {005943D7..43EC [ebp-50] Trim jbe->4420}
            begin
              illki(s50, idx, s);                               {005943EE..4409 eax=Self edx=s50 ecx=esi=idx}
              gvar_02536630 := gvar_02536630 + #13#10 +        {005943EE..441B CatN edx=4 ebx}
                'Vater nicht bekannt: ' + s;                     {00595634}
            end;
            s50 := '';                                           {00594420..4426 LStrClr [ebp-50]}
            DataModule2.Table1.IndexName := '';                  {00594428..4434 [5C] xor edx}
            DataModule2.Table1.First;                            {00594439..4444}
            DataModule2.Table1.FindKey([t1Num]);                 {00594448..446A [ebp-88] [5C]}
            DataModule2.Table18.Next;                            {0059446F..447C [140]}
            if DataModule2.Table18.Eof then Break;               {00594481..4495 [eax+0A1] jne->44C5}
          end;
          Inc(iEh);                                              {005944C5 [ebp-14]}
          Dec(i);                                                {005944C8 [ebp-64]}
        until i = 0;                                             {005944CB jne->005904B9}
      end;
    end;
    { 005944D1: Table14-Zeilen-Schreibblock - Chunk 7e.
      Zeile mit dem bisherigen gvar_02536630 fuellen, je nach Geschlecht
      den 'vat'- bzw. 'mut'-Index waehlen, die Kind(er)-Ehen ohne Mutter
      bzw. Vater anhaengen, dann Post. Endet mit dem While-Bottom
      (lfbh2.Next -> 00594B75/4B8B -> 0058F4DD bzw. 00594BA5). }
    DataModule2.Table14Zeile.AsString := gvar_02536630;         {005944D1..44E2 [1E8]+0B0 edx=[ebx]}
    DataModule2.Table1.IndexName := '';                         {005944E8..44F4 [5C] xor edx}
    DataModule2.Table1.First;                                   {005944F9..4503}
    DataModule2.Table1.FindKey([t1Num]);                        {00594508..452A [ebp-10] ohne Test}
    if Trim(Form1.lfbh2Eh.AsString) = '000000*' then            {0059452F..568 [914]+60 jne->00594B26}
    begin
      if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then begin {0059456E..5BD [548]}
        DataModule2.Table1.IndexName := 'vat';                  {005945A9..5B8 [595430]}
      end else
      if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then begin {005945BF..609}
        DataModule2.Table1.IndexName := 'mut';                  {005945FA..609 [595424]}
      end;
      if DataModule2.Table1.IndexName = 'vat' then begin        {0059460E..633 jne->0059489A}
        if DataModule2.Table1.FindKey([t1Num]) then             {00594639..662 je->0059489A}
        begin
          while DataModule2.Table1Vater.AsInteger = t1Num do begin {0059487F je->0059466D}
            if DataModule2.Table1Mutter.AsInteger = 0 then begin    {0059466D..681 jne->0059485D}
              eli := 0;                                          {00594687..689 [ebp-38]}
              gvar_02536454 := Form1.lfbh2.IndexName;            {0059468C..6AF}
              bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));     {005946C1..C9 vtbl+150 -> [ebp-34]}
              Form1.lfbh2.IndexName := 'Pro';                    {005946D9..DE [595418]}
              Form1.lfbh2.First;                                 {005946E3..F0}
              sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {005946F5..70E [534]+58}
              if Form1.lfbh2.FindKey([u]) then                   {00594712..744 je->0059474D}
                eli := 1;                                        {00594746}
              Form1.lfbh2.IndexName := gvar_02536454;            {0059474D..760}
              Form1.lfbh2.GotoBookmark(bmk);                     {00594765..77D vtbl+1A0}
              if eli = 1 then                                    {0059477D..781 jne->0059485D}
              begin
                if Pos('Mutter nicht bekannt: ', gvar_02536630) = 0 then {00594787..795 jne->00594800}
                begin
                  sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {005947AF..7C7}
                  u := u + '*';                                  {005947CC..7D7 @LStrCat [5953B8]}
                  illki(u, idx, s);                              {005947DC..7E7 eax=[ebp-4] Self}
                  gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + {00594797..7F9 CatN ebx edx=5}
                    'Kind(er), Mutter nicht bekannt: - ' + s;    {005947A3 [595654]}
                end else
                begin
                  sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {0059480E..82B}
                  u := u + '*';                                  {0059482B..836}
                  illki(u, idx, s);                              {0059483B..846}
                  gvar_02536630 := gvar_02536630 + ' - ' + s;    {00594800..858 CatN ebx edx=3 [5955D0]}
                end;
              end;
            end;
            DataModule2.Table1.Next;                             {0059485D..867}
            if DataModule2.Table1.Eof then Break;                {0059486C..87D jne->0059489A}
          end;
        end;
      end;
      if DataModule2.Table1.IndexName = 'mut' then begin        {0059489A..8BF jne->00594B26}
        if DataModule2.Table1.FindKey([t1Num]) then             {005948C5..8EE je->00594B26}
        begin
          while DataModule2.Table1Mutter.AsInteger = t1Num do begin {00594B0B je->005948F9}
            if DataModule2.Table1Vater.AsInteger = 0 then begin    {005948F9..90D jne->00594AE9}
              eli := 0;                                          {00594913..915 [ebp-38]}
              gvar_02536454 := Form1.lfbh2.IndexName;            {00594918..93B}
              bmk := TBookmark(PChar(Form1.lfbh2.Bookmark));     {00594940..955 vtbl+150 -> [ebp-34]}
              Form1.lfbh2.IndexName := 'Pro';                    {00594958..96A}
              Form1.lfbh2.First;                                 {0059496F..97C}
              sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {00594981..99E}
              if Form1.lfbh2.FindKey([u]) then                   {0059499E..9D0 je->005949D9}
                eli := 1;                                        {005949D2}
              Form1.lfbh2.IndexName := gvar_02536454;            {005949D9..9EC}
              Form1.lfbh2.GotoBookmark(bmk);                     {005949F1..A03 vtbl+1A0}
              if eli = 1 then                                    {00594A09..A0D jne->00594AE9}
              begin
                if Pos('Vater nicht bekannt: ', gvar_02536630) = 0 then {00594A13..A21 jne->00594A8C}
                begin
                  sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {00594A23..A4A}
                  u := u + '*';                                  {00594A58..A63}
                  illki(u, idx, s);                              {00594A68..A73}
                  gvar_02536630 := gvar_02536630 + #13#10 + #13#10 + {00594A23..A85 CatN ebx edx=5}
                    'Kind(er), Vater nicht bekannt: - ' + s;    {00594A2F [595680]}
                end else
                begin
                  sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {00594A9A..AB2}
                  u := u + '*';                                  {00594AB7..AC2}
                  illki(u, idx, s);                              {00594AC7..AD2}
                  gvar_02536630 := gvar_02536630 + ' - ' + s;    {00594A8C..AE4 CatN ebx edx=3 [5955D0]}
                end;
              end;
            end;
            DataModule2.Table1.Next;                             {00594AE9..AF3}
            if DataModule2.Table1.Eof then Break;                {00594AF8..B09 jne->00594B26}
          end;
        end;
      end;
    end;
    DataModule2.Table14Zeile.AsString := gvar_02536630;         {00594B26..B37 [1E8]+0B0 edx=[ebx]}
    DataModule2.Table14.Post;                                    {00594B3D..B4C [0E0]+248}
    DataModule2.Table1.IndexName := '';                          {00594B52..B5E [5C] xor edx}
    Form1.lfbh2.Next;                                            {00594B63..B70} {00594B75/4B8B = while-Bottom}
  end;
  { --- Chunk 8: Epilog (00594BA5..00595388) ---
    EnableControls + krg-FindKey + Cursor/Label19 +
    gvar_02536664-'ort_'-Sortierung + Vorschau-Setup.
    Die SEH-Rahmen 00594D8E..4EBE (Table13-Schleife, Handler
    00594EB9 jmp @HandleAnyException + @DoneExcept) und der Prozedur-
    Epilog 005952BA..5388 (12x @LStrArrayClr + jmp @HandleFinally bei
    00595378) sind compilergeneriert und werden - wie beim ofb3-Zwilling
    (C3q, Zeile 2744ff) - nicht transkribiert. }
  DataModule2.Table1.EnableControls;                        {00594BA5..BAF [5C]}
  DataModule2.Table18.EnableControls;                       {00594BB4..BC1 [140]}
  Form1.lfbh2.EnableControls;                               {00594BC6..BD3 [8B8]}
  DataModule2.Table1.IndexName := '';                       {00594BD8..BE4 [5C] xor edx}
  DataModule2.Table1.FindKey([krg]);                        {00594BE9..C0B [ebp-8] ohne Result-Test}
  Screen.Cursor := crDefault;                               {00594C10..C19 TScreen xor edx}
  Form1.Label19.Visible := False;                           {00594C1E..C2D [404]}
  if Trim(gvar_02536664) <> '' then                         {00594C32..C49 Trim jbe->00594EC3}
  begin
    DataModule2.Table13.Open;                               {00594C4F..C5C [0CC]}
    DataModule2.Table13.IndexName := 'ort_';                {00594C61..C73 [5956AC]}
    DataModule2.Table14.Append;                             {00594C78..C85 [0E0]}
    DataModule2.Table14Zeile.AsString := ' ';               {00594C8A..C9E [1E8]+0B0 edx=595458}
    DataModule2.Table14.Post;                               {00594CA4..CB3 +248}
    DataModule2.Table14.Append;                             {00594CB9..CC6}
    DataModule2.Table14Zeile.AsString := ' ';               {00594CCB..CDF}
    DataModule2.Table14.Post;                               {00594CE5..CF4}
    DataModule2.Table14.Append;                             {00594CFA..D07}
    DataModule2.Table14Zeile.AsString := 'Orts-Abkürzungen: '; {00594D0C..D20 [5956BC]}
    DataModule2.Table14.Post;                               {00594D26..D35}
    DataModule2.Table14.Append;                             {00594D3B..D48}
    DataModule2.Table14Zeile.AsString := ' ';               {00594D4D..D61}
    DataModule2.Table14.Post;                               {00594D67..D76}
    DataModule2.Table13.First;                              {00594D7C..D89 [0CC]}
    while not DataModule2.Table13.Eof do                    {00594D9C jmp->4E95; cond 4E95..4EA9 je->4DA1}
    begin
      sub_00576EB0(DataModule2.Table13.RecNo, u);           {00594DA1..DBC vtbl+150 -> [ebp-0B30]}
      if Pos(u, gvar_02536664) > 0 then                     {00594DC1..DD4 @LStrPos jle->00594E6D}
      begin
        DataModule2.Table14.Append;                         {00594DDA..DE7}
        DataModule2.Table14Zeile.AsString :=                {00594DEC..E38 CatN edx=3}
          DataModule2.Table13Abk.AsString + ': ' +          {[0A68] vtbl+60 push 595568}
          DataModule2.Table13Ort.AsString;                  {[0A44] vtbl+60}
        DataModule2.Table14.Post;                           {00594E3D..E67}
      end;
      DataModule2.Table13.Next;                             {00594E6D..E7A}
    end;                            {00594E7F..E93 Bottom-Check faellt auf 4E95}
  end;                                {00594EB7 jmp->00594EC3}
  Form1.lfbh2.EmptyDataSet;                                 {00594EC3..ED0 [8B8]}
  Form15.QRMemo1.Visible := False;                          {00594ED5..EE4 [310]}
  Form15.QRMemo1.Enabled := False;                          {00594EE9..EFA +64}
  gvar_02536438 := '';                                      {00594EFD..F02 @LStrClr}
  if InputQuery('OFB', 'Überschrift : ', gvar_02536438) then {00594F07..F1D je->005952BA}
  begin
    Form15.QRLabel1.Caption := gvar_02536438;               {00594F23..F36 [2F8]}
    Form15.QuickRep1.Page.Columns := 1;                     {00594F3B..F53 [2F0]+2BC}
    Form15.QRLabel2.Visible := False;                       {00594F58..F67 [2FC]}
    Form15.QRLabel2.Enabled := False;                       {00594F6C..F7D +64}
    Form15.QRShape3.Visible := False;                       {00594F80..F8F [304]}
    Form15.QRShape3.Enabled := False;                       {00594F94..FA5 +64}
    Form15.QRBand1.Height := 30;                            {00594FA8..FBA [2F4] edx=1E}
    Form15.QRLabel3.Caption := '(OFB) ' + gvar_02536438;    {00594FBF..FE8 LStrCat3 [368] [5956FC]}
    Form15.QRDBText4.Visible := False;                      {00594FED..FFC [31C]}
    Form15.QRDBText5.Visible := False;                      {00595001..5010 [320]}
    Form15.QRDBText6.Visible := False;                      {00595015..5024 [324]}
    Form15.QRDBText7.Visible := False;                      {00595029..5038 [328]}
    Form15.QRDBText8.Visible := False;                      {0059503D..504C [32C]}
    Form15.QRDBText9.Visible := False;                      {00595051..5060 [330]}
    Form15.QRDBText10.Visible := False;                     {00595065..5074 [334]}
    Form15.QRDBText11.Visible := False;                     {00595079..5088 [338]}
    Form15.QRDBText12.Visible := False;                     {0059508D..509C [33C]}
    DataModule2.Table14.Open;                               {005950A1..50AE [0E0]}
    Form15.QuickRep1.DataSet := DataModule2.Table14;        {005950B3..50CD [2F0]}
    Form15.QRDBText1.DataSet := DataModule2.Table14;        {005950D2..50EC [350]}
    Form15.QRDBText1.DataField := 'zeile';                  {005950F1..5103 [59570C]}
    Form15.QRDBText2.DataSet := DataModule2.Table14;        {00595108..5122 [354]}
    Form15.QRDBText2.DataField := 'nm';                     {00595127..5139 [59571C]}
    Form15.QRDBText1.Visible := True;                       {0059513E..514D dl=1}
    Form15.QRDBText2.Visible := True;                       {00595152..5161 dl=1}
    Form15.QRDBText1.Enabled := True;                       {00595166..5177 +64}
    Form15.QRDBText2.Enabled := True;                       {0059517A..518B +64}
    Form15.QRDBText1.Left := 60;                            {0059518E..51A0 edx=3C}
    Form15.QRDBText1.Width := 610;                          {005951A5..51B7 edx=262}
    Form15.QRDBText2.Left := 8;                             {005951BC..51CE}
    Form15.QRDBText2.Width := 40;                           {005951D3..51E5 edx=28}
    PByte(Integer(Form15.QRDBText1)+$242)^ := 0;            {005951EA..51F7 +242}
    PByte(Integer(Form15.QRDBText2)+$242)^ := 0;            {005951FE..520B +242}
    Form15.QRDBText2.AutoStretch := False;                  {00595212..5221 TQRLabel.SetAutoStretch}
    Form15.QRDBText1.Font.Size := 9;                        {00595226..523B +68}
    Form15.QRDBText2.Font.Size := 9;                        {00595240..5255 +68}
    PByte(Integer(Form15.QRDBText1)+$0E0)^ := 0;            {0059525A..526B +0E0}
    Form15.QRDBText2.Enabled := True;                       {00595271..5282 +0E0 dl=1}
    { Form15.QuickRep1.OnPreview := showpreview }           {00595288..529E +2AC/+2A8 [ebp-4] 583D38}
    { Form15.QuickRep1.Preview; - die Vorschau ist im
      Kompatibilitaetsschicht nicht implementiert. }        {005952A8..52B5}
  end;
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
    bmk := Form1.lfbh2.RecNo; //005845E0 vtbl+150 = GetRecNo -> [ebp-18]
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
  gvar_02536860 := TTable.Create(Self);  {005BFC05: AOwner=Self in ecx=[ebp-4], dl=1}
  gvar_02536860.DatabaseName := ExtractFilePath(ParamStr(0));  {005BFBF2}
  gvar_02536860.TableType := ttParadox;  {dl=1 -> TTableType: 0=ttDefault, 1=ttParadox}
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
  childIdx: Integer;        {0057DB69 [ebp-18] FAMC-Kinder-Reihenfolge}
  childNr: Integer;         {0057DB75 [ebp-4] Kind-Personnr (via Table25N uebersetzt)}
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
  mIdx := 0;  {0057D594 [ebp-10]}
  childIdx := 0;  {0057D5B6..5BB [ebp-18]}
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
    if Pos('1 CHIL', s) > 0 then  {0057DB55..DB63}
    begin
      Inc(childIdx);                                     {0057DB69 [ebp-18] - Reihenfolge-Kennzahl der Kinder des FAM}
      childNr := Ziff(s);                                {0057DB6C..DB75 [ebp-4]}
      DataModule2.Table25.FindKey([childNr]);            {0057DB88..DBA2 [1DC] - ohne Result-Test}
      childNr := DataModule2.Table25N.AsInteger;         {0057DBA9..DBB4 [308]}
      DataModule2.Table1.FindKey([childNr]);             {0057DBC7..DBDD [5C] - ohne Result-Test}
      if gvar_02536840 = 1 then                          {0057DBDE..DBE5}
      begin
        if husn > 0 then                                 {0057DBEB..DBF1}
          DataModule2.Table1Kistat.AsString := 'V';      {0057DBF1..DC05 [5C4]}
        if wifn > 0 then                                 {0057DC0B..DC0F}
          DataModule2.Table1Kistat.AsString :=           {0057DC11..DC4A CatN2 - GetText + 'M'}
            DataModule2.Table1Kistat.AsString + 'M';
        DataModule2.Table1.Edit;                         {0057DC5A..DC5F - Original: Edit erst NACH den SetText-Aufrufen}
        DataModule2.Table31.Append;                      {0057DC66..DC71 [2A4] Kind-Eltern-Beziehung}
        DataModule2.Table31Nummer.AsInteger := childNr;  {0057DC78..DC83 [2AC]}
        DataModule2.Table31Av.AsInteger := husn;         {0057DC8E..DC9B [2B0] Vater}
        DataModule2.Table31Am.AsInteger := wifn;         {0057DCA6..DCB3 [2B4] Mutter}
        DataModule2.Table31.Post;                        {0057DCC0..DCC8 vtbl+248}
      end
      else
      begin
        DataModule2.Table1.Edit;                         {0057DCD3..DCDD}
        DataModule2.Table1Vater.AsInteger := husn;       {0057DCE7..DCF4 [538]}
        DataModule2.Table1Mutter.AsInteger := wifn;      {0057DCF9..DD0C [53C]}
        t := RightStr('00' + IntToStr(childIdx), 2);     {0057DD12..DD4C CatN3 '00' + RightStr edx=2}
        DataModule2.Table1Indm.AsString := t;            {0057DD52..DD66 [5E4]}
      end;
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
var
  f: TextFile;                {005B3B59 [ebp-1D8] Ausgabedatei (Text)}
  lfd: Integer;                {005B3C85 [esi] Datensatz-Zaehler ab 1}
  anz: Integer;                {005B3C8A [edi] geschriebene Adressen}
  s0C: AnsiString;             {005B3CAB [ebp-0C] Ort aus Table13, sonst ''}
  s4: AnsiString;              {005B3E0E [ebp-4] Adress-Anrede 'Herrn'/'Frau'}
  s8: AnsiString;              {005B3E16 [ebp-8] Brief-Anrede 'Herr'/'Frau'}
begin
  { 005B3A3C: adrschreib - schreibt die als lebend markierten Personen
    (Table17Lebt='j') als Tab-getrennte Textdatei mit 9 Spalten; der Ort
    wird ueber Table13 nachgeschlagen. Quelle: Table17, Index 'namgeb',
    optional gefiltert auf gebjahr/taufjahr <= gvar_02536BA0.
    SEH-Rahmen/Prolog-Teardown (@LStrArrayClr 13/5/4/3, @HandleFinally) -
    nicht transkribiert. }

  {005B3A3C..5B3A4E Prolog: ecx=4A, je Iteration 2x push 0 -> 0x250 Bytes
   Lokalspeicher (tiefster Platz [ebp-250]), ebx := Self}
  {005B3A50..5B3A5E SEH-Rahmen fs:[0] -> Handler 005B40D6}
  Form1.SaveDialog1.DefaultExt := 'txt';                            {005B3A5E..5B3A73 [3FC]+74}
  Form1.SaveDialog1.Filter := 'Text-Dateien (*.txt)|*.txt';         {005B3A78..5B3A8D [3FC]+60}
  if not Form1.SaveDialog1.Execute then                             {005B3A92..5B3AA6 vtbl+3C -> 5B408B}
    Exit;
  if Form1.SaveDialog1.FileName = '' then                           {005B3AAC..5B3ACB GetFileName -> 5B408B}
    Exit;
  if Pos('.txt', Form1.SaveDialog1.FileName) = 0 then               {005B3AD1..5B3AFB LStrPos}
    Form1.SaveDialog1.FileName :=                                  {005B3AFD..5B3B30 [3FC]+78 LStrCat3}
      Form1.SaveDialog1.FileName + '.txt';
  AssignFile(f, Form1.SaveDialog1.FileName);                        {005B3B35..5B3B59 @Assign}
  Rewrite(f);                                                       {005B3B5E..5B3B64 @RewritText}
  if IOResult <> 0 then                                             {005B3B69..5B3B70 -> 5B408B}
    Exit;

  if gvar_02536BA0 > 1 then                                         {005B3B76..5B3B7E jle -> 5B3C17}
  begin
    DataModule2.Table17.Filter := 'gebjahr<=' +                     {005B3B84..5B3BC9 CatN edx=4}
      IntToStr(gvar_02536BA0) +                                     {005B3B89..5B3B9B erster IntToStr}
      ' and taufjahr<=' + IntToStr(gvar_02536BA0);                  {005B3BA6..5B3BB8; 5B3BCE vtbl+198}
    DataModule2.Table17.Filtered := True;                           {005B3BE9..5B3BFA [13C] vtbl+190 dl=1}
    Form1.DBText1.Color := $FFFF;                                   {005B3C00..5B3C12 [7B4] SetColor 0FFFF}
  end;
  DataModule2.Table17.Open;                                         {005B3C17..5B3C24}
  DataModule2.Table17.IndexName := 'namgeb';                        {005B3C29..5B3C3B}
  Screen.Cursor := crHourGlass;                                     {005B3C40..5B3C4B 0FFF5 = -11}
  DataModule2.Table17.First;                                        {005B3C50..5B3C5D}
  Form1.Label19.Caption := 'Adressen schreiben';                    {005B3C62..5B3C74 [404] SetText}
  Form1.lab18ein;                                                   {005B3C79..5B3C80}
  lfd := 1;                                                         {005B3C85 mov esi,1}
  anz := 0;                                                         {005B3C8A xor edi,edi}
  WriteLn(f, 'Brf_Anr' + #9 + 'Adr_Anr' + #9 + 'Vorname' + #9 +     {005B3C8C..5B3CA1 WriteLn}
    'Nachname' + #9 + 'Anschrift1' + #9 + 'Anschrift2' + #9 +
    'PLZ' + #9 + 'Ort' + #9 + 'Adrzus');
    {005B4184: Die Konstante ist im IDR-Listing nach 'Anschrift2'
     abgeschnitten (...); die letzten 3 Spaltennamen sind aus den 9
     Ausgabespalten abgeleitet - Verifizierung erst mit Original-Binary.}
  while not DataModule2.Table17.Eof do                              {005B3CA6 jmp -> 5B3FF2;
    5B3FF2..4006 [13C]+0A1=0 -> 5B3CAB}
  begin
    s0C := '';                                                      {005B3CAB..5B3CAE @LStrClr}
    Form1.Label18.Caption := IntToStr(lfd);                         {005B3CB3..5B3CD3 [400]}
    Form1.Label18.Refresh;                                          {005B3CD8..5B3CE5}
    if DataModule2.Table17Lebt.AsString = 'j' then                  {005B3CEA..5B3D12 -> 5B3FDF}
    begin
      if DataModule2.Table13.FindKey([                             {005B3D18..5B3D5F [9E8] -> [CC]}
        DataModule2.Table17Ort.AsString]) then
        s0C := DataModule2.Table13Ort.AsString;                     {005B3D61..5B3D73 [0A44]}
      if DataModule2.Table17Adr1.AsString +                         {005B3D76..5B3DFC CatN edx=5}
        DataModule2.Table17Adr2.AsString +
        DataModule2.Table17PLZ.AsString + s0C +
        DataModule2.Table17Adrzus.AsString <> '' then               {005B3E01..5B3E08 -> 5B3FDF}
      begin
        s4 := '';                                                   {005B3E0E..5B3E11}
        s8 := '';                                                   {005B3E16..5B3E19}
        if ucase(DataModule2.Table17Geschlecht.AsString) = 'M' then {005B3E1E..5B3E59}
        begin
          s4 := 'Herrn';                                            {005B3E5B..5B3E63}
          s8 := 'Herr';                                             {005B3E68..5B3E70}
        end
        else if ucase(DataModule2.Table17Geschlecht.AsString) = 'W' then {005B3E77..5B3EB2}
        begin
          s4 := 'Frau';                                             {005B3EB4..5B3EBC}
          s8 := 'Frau';                                             {005B3EC1..5B3EC9}
        end;
        WriteLn(f, s8 + #9 + s4 + #9 +                              {005B3ECE..5B3FBE CatN edx=0x11=17}
          DataModule2.Table17Vornamen.AsString + #9 +
          DataModule2.Table17Name.AsString + #9 +
          DataModule2.Table17Adr1.AsString + #9 +
          DataModule2.Table17Adr2.AsString + #9 +
          DataModule2.Table17PLZ.AsString + #9 +
          s0C + #9 +
          DataModule2.Table17Adrzus.AsString);                      {005B3FC3..5B3FD9 Write+Ln+IOTest}
        Inc(anz);                                                   {005B3FDE inc edi}
      end;
    end;
    DataModule2.Table17.Next;                                       {005B3FDF..5B3FEC}
    Inc(lfd);                                                       {005B3FF1 inc esi}
  end;
  CloseFile(f);                                                     {005B400C..5B4017 @Close+IOTest}
  Form1.Label18.Hide;                                               {005B401C..5B4029 [400]}
  Form1.Label19.Hide;                                               {005B402E..5B403B [404]}
  Screen.Cursor := crDefault;                                       {005B4040..5B4049 xor edx,edx}
  ShowMessage(IntToStr(anz) + ' Adresse(n) geschrieben.' +          {005B404E..5B407B CatN edx=4}
    #13#10 + '(Nur lebende Personen !)');                            {005B4080..5B4086}
  {005B408B..5B40E3 Epilog: SEH-Unload + 4x @LStrArrayClr (13/5/4/3) +
   ret - nicht transkribiert}
end;

procedure TForm3.gedausxv;
var
  krg: Integer;               {005B42DB [ebp-10] Table1Nummer-Restaurierung}
  idx: Integer;               {005B42D9 [edi] Paar-Zaehler}
  lfd: Integer;               {[esi] Table24Lfdn-Zwischenspeicher fuer dsn-Lauf}
  s8: AnsiString;             {005B42D1 [ebp-8] Dedup-Nadel-Liste}
  s0C: AnsiString;            {005B4342 [ebp-0C] Paar-Eintrag (12 Zeichen)}
  s4: AnsiString;             {005B434A [ebp-4] Kinder-Teil ('*'+6stellig)}
  u, v: AnsiString;           {00576EB0-Zwischenwerte (6-stellige Nummern)}
begin
  { 005B4288: gedausxv - baut gvar_02536448 (Paar-Eintraege) und
    gvar_0253644C (Kinder-Eintraege) fuer den FAMS/FAMC-Export in gedausv.
    Laeufert ueber Table24 ('lfn'), je Paar-Eintrag:
      s0C(12) + s4(7*n Kinder) + idx(6)  =  18+7n Zeichen.
    SEH-Rahmen/Prolog-Teardown (@LStrArrayClr 2F/3) - nicht transkribiert. }

  gvar_02536448 := TStringList.Create;                            {005B42AF..42BB}
  gvar_0253644C := TStringList.Create;                            {005B42C0..42CC}
  s8 := '';                                                       {005B42D1..42D4 @LStrClr [ebp-8]}
  idx := 0;                                                       {005B42D9 xor edi,edi}
  krg := DataModule2.Table1Nummer.AsInteger;                      {005B42DB..42E8 [534]+58}
  { DataModule2.Table24.RecordCount - toter Aufruf, Ergebnis ungenutzt }
                                                                {005B42EB..42F5 vtbl+14C}
  DataModule2.Table24.IndexName := 'lfn';                         {005B42FB..4308}
  DataModule2.Table24.First;                                      {005B430D..4315}
  while not DataModule2.Table24.Eof do                            {005B513D..514C je->005B431F}
  begin
    DataModule2.Table1.FindKey([DataModule2.Table24Nummer.AsInteger]); {005B431F..433D [5C] FindKey}
    s0C := '';                                                    {005B4342..4345 @LStrClr [ebp-0C]}
    s4 := '';                                                     {005B434A..434D @LStrClr [ebp-4]}
    if DataModule2.Table5.RecordCount > 0 then                    {005B4352..4364 jle->005B4B84}
    begin
      DataModule2.Table5.First;                                   {005B436A..4372}
      while not DataModule2.Table5.Eof do                         {005B4B6F..4B7E je->005B437C}
      begin
        sub_00576EB0(DataModule2.Table5Epnum.AsInteger, u);       {005B437C..438C [414]+58}
        if Pos(u + '*', gvar_0253665C) > 0 then                   {005B4391..43AE jle->005B4B49}
        begin
          { Dedup-Nadel 1: '*'+Num2Str(Table1Nummer)+'*'+Num2Str(Table5Epnum) }
          sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u);    {005B43B4..43C9}
          sub_00576EB0(DataModule2.Table5Epnum.AsInteger, v);     {005B43D6..43E6}
          if Pos('*' + u + '*' + v, s8) = 0 then                  {005B43FB..4408 jne->005B4B49}
          begin
            { Dedup-Nadel 2 (umgekehrt) }
            if Pos('*' + v + '*' + u, s8) = 0 then                {005B440E..4462 jne->005B4B49}
            begin
              s8 := s8 + '*' + u + '*' + v;                       {005B4468..44AD CatN5}
              if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then {005B44B2..44DA jne->005B47FC}
              begin
                {--- 005B44E0 M-Zweig ---}
                lfd := DataModule2.Table24Lfdn.AsInteger;         {005B44E0..44ED [228]+58 -> esi}
                sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {005B44F1..44FF}
                if Pos(u + '*', gvar_0253665C) > 0 then           {005B4504..4521 jle->005B4570}
                begin
                  DataModule2.Table24.IndexName := 'dsn';         {005B4523..4530}
                  DataModule2.Table24.FindKey([DataModule2.Table1Nummer.AsInteger]); {005B4535..4556}
                  sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, s0C); {005B455B..456B s0C :=}
                end;
                sub_00576EB0(DataModule2.Table5Epnum.AsInteger, u); {005B4570..4580}
                if Pos(u + '*', gvar_0253665C) > 0 then           {005B4585..45A2 jle->005B45FC}
                begin
                  DataModule2.Table24.IndexName := 'dsn';         {005B45A4..45B1}
                  DataModule2.Table24.FindKey([DataModule2.Table5Epnum.AsInteger]); {005B45B6..45D7}
                  sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, v); {005B45DC..45EC}
                  s0C := s0C + v;                                 {005B45F1..45F7 @LStrCat}
                end;
                DataModule2.Table24.IndexName := 'lfn';           {005B45FC..4609}
                DataModule2.Table24.FindKey([lfd]);               {005B460E..4622}
                DataModule2.Table7.IndexFieldNames := 'Vater';    {005B4627..4634 SetIndexFieldNames}
                if DataModule2.Table7.FindKey([DataModule2.Table1Nummer.AsInteger]) then {005B4639..4661 je->005B47A9}
                  while DataModule2.Table7Vater.AsInteger = DataModule2.Table1Nummer.AsInteger do {005B4785..47A3 je->005B466C}
                  begin
                    sub_00576EB0(DataModule2.Table7Nummer.AsInteger, u); {005B466C..467C [0A78]+58}
                    if Pos(u + '*', gvar_0253665C) > 0 then       {005B4681..469E jle->005B4767}
                      if DataModule2.Table7Mutter.AsInteger = DataModule2.Table5Epnum.AsInteger then {005B46A4..46C2 jne->005B4767}
                      begin
                        lfd := DataModule2.Table24Lfdn.AsInteger; {005B46C8..46D5}
                        DataModule2.Table24.IndexName := 'dsn';   {005B46D7..46E4}
                        DataModule2.Table24.FindKey([DataModule2.Table7Nummer.AsInteger]); {005B46E9..470A}
                        sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, v); {005B470F..4727}
                        s4 := s4 + '*' + v;                       {005B472C..4737 CatN3}
                        DataModule2.Table24.IndexName := 'lfn';   {005B473C..4749}
                        DataModule2.Table24.FindKey([lfd]);       {005B474E..4762}
                      end;
                    DataModule2.Table7.Next;                      {005B4767..476F}
                    if DataModule2.Table7.Eof then Break;         {005B4774..4783 jne->005B47A9}
                  end;
                Inc(idx);                                         {005B47A9}
                sub_00576EB0(idx, u);                             {005B47AA..47B5}
                s0C := s0C + s4 + u;                              {005B47BA..47C5 CatN3}
                gvar_02536448.Add(s0C);                           {005B47CA..47D4 vtbl+38}
                gvar_0253644C.Add(s4 + u);                        {005B47D7..47F9 Cat3+Add}
              end;
              {--- 005B47FC W-Zweig (sequenziell, kein else) ---}
              if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then {005B47FC..4824 jne->005B4B49}
              begin
                lfd := DataModule2.Table24Lfdn.AsInteger;         {005B482A..4837}
                sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); {005B4839..4849}
                if Pos(u + '*', gvar_0253665C) > 0 then           {005B484E..486B jle->005B48BA}
                begin
                  DataModule2.Table24.IndexName := 'dsn';         {005B486D..487A}
                  DataModule2.Table24.FindKey([DataModule2.Table1Nummer.AsInteger]); {005B487F..48A0}
                  sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, s0C); {005B48A5..48B5 s0C :=}
                end;
                sub_00576EB0(DataModule2.Table5Epnum.AsInteger, u); {005B48BA..48CA}
                if Pos(u + '*', gvar_0253665C) > 0 then           {005B48CF..48EC jle->005B4937}
                begin
                  { Original setzt hier KEIN IndexName - Index bleibt von Vorblock ('dsn') }
                  DataModule2.Table24.FindKey([DataModule2.Table5Epnum.AsInteger]); {005B48EE..490F}
                  sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, v); {005B4914..4924}
                  s0C := v + s0C;                                 {005B4929..4932 Cat3 umgekehrt}
                end;
                DataModule2.Table24.IndexName := 'lfn';           {005B4937..4944}
                DataModule2.Table24.FindKey([lfd]);               {005B4949..495D}
                DataModule2.Table7.IndexFieldNames := 'Mutter';   {005B4962..496F}
                if DataModule2.Table7.FindKey([DataModule2.Table1Nummer.AsInteger]) then {005B4974..499C je->005B4AE4}
                  while DataModule2.Table7Mutter.AsInteger = DataModule2.Table1Nummer.AsInteger do {005B4AC0..4ADE je->005B49A7}
                  begin
                    sub_00576EB0(DataModule2.Table7Nummer.AsInteger, u); {005B49A7..49B7}
                    if Pos(u + '*', gvar_0253665C) > 0 then       {005B49BC..49D9 jle->005B4AA2}
                      if DataModule2.Table7Vater.AsInteger = DataModule2.Table5Epnum.AsInteger then {005B49DF..49FD jne->005B4AA2}
                      begin
                        lfd := DataModule2.Table24Lfdn.AsInteger; {005B4A03..4A10}
                        DataModule2.Table24.IndexName := 'dsn';   {005B4A12..4A1F}
                        DataModule2.Table24.FindKey([DataModule2.Table7Nummer.AsInteger]); {005B4A24..4A45}
                        sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, v); {005B4A4A..4A62}
                        s4 := s4 + '*' + v;                       {005B4A67..4A72 CatN3}
                        DataModule2.Table24.IndexName := 'lfn';   {005B4A77..4A84}
                        DataModule2.Table24.FindKey([lfd]);       {005B4A89..4A9D}
                      end;
                    DataModule2.Table7.Next;                      {005B4AA2..4AAA}
                    if DataModule2.Table7.Eof then Break;         {005B4AAF..4ABE jne->005B4AE4}
                  end;
                Inc(idx);                                         {005B4AE4}
                sub_00576EB0(idx, u);                             {005B4AE5..4AF3}
                s0C := s0C + s4 + u;                              {005B4AF8..4B06 CatN3}
                gvar_02536448.Add(s0C);                           {005B4B0B..4B15}
                gvar_0253644C.Add(s4 + u);                        {005B4B18..4B46 Cat3+Add}
              end;
            end;
          end;
        end;
        s4 := '';                                                 {005B4B49..4B4C @LStrClr [ebp-4]}
        DataModule2.Table5.Next;                                  {005B4B51..4B59}
      end;
    end;
    {--- 005B4B84 zweites Paar (ohne Table5-Partner) ---}
    s4 := '';                                                     {005B4B84..4B87}
    s0C := '';                                                    {005B4B8C..4B8F}
    if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then {005B4B94..4BC8 jne->005B4E5C}
    begin
      DataModule2.Table7.IndexFieldNames := 'Vater';              {005B4BCE..4BDB}
      if DataModule2.Table7.FindKey([DataModule2.Table1Nummer.AsInteger]) then {005B4BE0..4C08 je->005B4D50}
        while DataModule2.Table7Vater.AsInteger = DataModule2.Table1Nummer.AsInteger do {005B4D2C..4D4A je->005B4C13}
        begin
          if DataModule2.Table7Mutter.AsInteger = 0 then          {005B4C13..4C22 jne->005B4D0E}
          begin
            sub_00576EB0(DataModule2.Table7Nummer.AsInteger, u);  {005B4C28..4C3B}
            if Pos(u + '*', gvar_0253665C) > 0 then               {005B4C40..4C63 jle->005B4D0E}
            begin
              lfd := DataModule2.Table24Lfdn.AsInteger;           {005B4C69..4C76}
              DataModule2.Table24.IndexName := 'dsn';             {005B4C78..4C85}
              DataModule2.Table24.FindKey([DataModule2.Table7Nummer.AsInteger]); {005B4C8A..4CAB}
              sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, v); {005B4CB0..4CCB}
              s4 := s4 + '*' + v;                                 {005B4CD0..4CDE CatN3}
              DataModule2.Table24.IndexName := 'lfn';             {005B4CE3..4CF0}
              DataModule2.Table24.FindKey([lfd]);                 {005B4CF5..4D09}
            end;
          end;
          DataModule2.Table7.Next;                                {005B4D0E..4D16}
          if DataModule2.Table7.Eof then Break;                   {005B4D1B..4D2A jne->005B4D50}
        end;
      if s4 <> '' then                                            {005B4D50..4D54 jbe->005B511F}
      begin
        Inc(idx);                                                 {005B4D5A}
        lfd := DataModule2.Table24Lfdn.AsInteger;                 {005B4D5B..4D68}
        DataModule2.Table24.IndexName := 'dsn';                   {005B4D6A..4D77}
        DataModule2.Table24.FindKey([DataModule2.Table1Nummer.AsInteger]); {005B4D7C..4D9D}
        sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, u);       {005B4DA2..4DB5}
        sub_00576EB0(idx, v);                                     {005B4DCE..4DD0}
        gvar_02536448.Add(u + '000000' + s4 + v);                 {005B4DBA..4DF8 CatN4+Add}
        gvar_0253644C.Add(s4 + v);                                {005B4DFB..4E29 Cat3+Add}
        DataModule2.Table24.IndexName := 'lfn';                   {005B4E2C..4E39}
        DataModule2.Table24.FindKey([lfd]);                       {005B4E3E..4E52}
      end;
    end
    else if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then {005B4E5C..4E90 jne->005B511F}
    begin
      DataModule2.Table7.IndexFieldNames := 'Mutter';             {005B4E96..4EA3}
      if DataModule2.Table7.FindKey([DataModule2.Table1Nummer.AsInteger]) then {005B4EA8..4ED0 je->005B5018}
        while DataModule2.Table7Mutter.AsInteger = DataModule2.Table1Nummer.AsInteger do {005B4FF4..5012 je->005B4EDB}
        begin
          if DataModule2.Table7Vater.AsInteger = 0 then           {005B4EDB..4EEA jne->005B4FD6}
          begin
            sub_00576EB0(DataModule2.Table7Nummer.AsInteger, u);  {005B4EF0..4F03}
            if Pos(u + '*', gvar_0253665C) > 0 then               {005B4F08..4F2B jle->005B4FD6}
            begin
              lfd := DataModule2.Table24Lfdn.AsInteger;           {005B4F31..4F3E}
              DataModule2.Table24.IndexName := 'dsn';             {005B4F40..4F4D}
              DataModule2.Table24.FindKey([DataModule2.Table7Nummer.AsInteger]); {005B4F52..4F73}
              sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, v); {005B4F78..4F93}
              s4 := s4 + '*' + v;                                 {005B4F98..4FA6 CatN3}
              DataModule2.Table24.IndexName := 'lfn';             {005B4FAB..4FB8}
              DataModule2.Table24.FindKey([lfd]);                 {005B4FBD..4FD1}
            end;
          end;
          DataModule2.Table7.Next;                                {005B4FD6..4FDE}
          if DataModule2.Table7.Eof then Break;                   {005B4FE3..4FF2 jne->005B5018}
        end;
      if s4 <> '' then                                            {005B5018..501C jbe->005B511F}
      begin
        Inc(idx);                                                 {005B5022}
        lfd := DataModule2.Table24Lfdn.AsInteger;                 {005B5023..5030}
        DataModule2.Table24.IndexName := 'dsn';                   {005B5032..503F}
        DataModule2.Table24.FindKey([DataModule2.Table1Nummer.AsInteger]); {005B5044..5065}
        sub_00576EB0(DataModule2.Table24Lfdn.AsInteger, u);       {005B506F..5082}
        sub_00576EB0(idx, v);                                     {005B5090..5098}
        gvar_02536448.Add('000000' + u + s4 + v);                 {005B506A..50C0 CatN4+Add}
        gvar_0253644C.Add(s4 + v);                                {005B50C3..50F1 Cat3+Add}
        DataModule2.Table24.IndexName := 'lfn';                   {005B50F4..5101}
        DataModule2.Table24.FindKey([lfd]);                       {005B5106..511A}
      end;
    end;
    DataModule2.Table24.Next;                                     {005B511F..5127}
  end;
  {--- 005B5152 Epilog ---}
  DataModule2.Table24.IndexName := 'dsn';                         {005B5152..515F}
  DataModule2.Table1.FindKey([krg]);                              {005B5164..5178 [5C] FindKey}
  { SEH-Teardown + @LStrArrayClr [ebp-0D4],2F / [ebp-0C],3 - nicht transkribiert }
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
  bmk: Integer;             {vtbl+150 = GetRecNo; je Block Table13/Table38/lfbh2.RecNo}
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
  Form1.SaveDialog1.DefaultExt := 'ged';                       {005B534B..5350 +74 @LStrAsg}
  Form1.SaveDialog1.Filter := 'Gedcom-Dateien (*.ged)|*.ged';  {005B5365..536A +60 @LStrAsg}
  Form1.SaveDialog1.Options := [ofHideReadOnly];               {005B537C..5382 dword +5C := 2}
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
        bmk := DataModule2.Table38.RecNo;                       {005B674F vtbl+150 = GetRecNo [530]}
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
          bmk := DataModule2.Table13.RecNo;                     {005B6AB2 vtbl+150 = GetRecNo [0CC]}
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
        bmk := DataModule2.Table38.RecNo;                       {005B6BAD vtbl+150 = GetRecNo [530]}
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
          bmk := DataModule2.Table13.RecNo;                     {005B6F10 vtbl+150 = GetRecNo [0CC]}
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
        bmk := DataModule2.Table38.RecNo;                       {005B700B vtbl+150 = GetRecNo [530]}
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
          bmk := DataModule2.Table13.RecNo;                     {005B7441 vtbl+150 = GetRecNo [0CC]}
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
        bmk := DataModule2.Table38.RecNo;                       {005B753C vtbl+150 = GetRecNo [530]}
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
          bmk := DataModule2.Table13.RecNo;                     {005B7972 vtbl+150 = GetRecNo [0CC]}
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
        bmk := DataModule2.Table38.RecNo;                       {005B7A6D vtbl+150 = GetRecNo [530]}
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
    {---- CHIL - Kinder ab Position 13 ('*'-Separator), Ziffern ab 14, je 7 Zeichen}
    if Length(gvar_02536448[famI]) > 18 then                      {005B8DBE..8DDE LStrLen cmp 12 = 0x12=18 (Hex-Radix)}
    begin
      u := Copy(gvar_02536448[famI], 13, Length(gvar_02536448[famI]) - 18);  {005B8DE4..8E2A LStrCopy edx=0D=13, ecx=sub 12=0x12=18}
      childCount := Round(Length(u) / 7);                         {005B8E2F..8E51 fild/fdiv 7:Single/ROUND [ebp-34]}
      childIdx := 1;                                              {005B8E5C [ebp-0C] personNr-Slot wird recycelt}
      for childIdx := 1 to childCount do                          {005B8E63..8F3D incl. dec/jne}
        WriteLn(gvar_02536458, '1 CHIL @I' +                      {005B8E63..8EE8 CatN3}
          IntToStr(StrToInt(Copy(gvar_02536448[famI], 7 * (childIdx - 1) + 14, 6))) + '@');  {005B8E81..8E9D dec/shl3/sub/add 0C=12/add 2 -> 7*(n-1)+14}
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
            bmk := DataModule2.Table13.RecNo;                  {005B94D6 vtbl+150 = GetRecNo [0CC]}
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
            bmk := DataModule2.Table38.RecNo;                  {005B96A4 vtbl+150 = GetRecNo [530]}
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
            bmk := DataModule2.Table13.RecNo;                  {005B9A29 vtbl+150 = GetRecNo [0CC]}
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
            bmk := DataModule2.Table38.RecNo;                  {005B9BF7 vtbl+150 = GetRecNo [530]}
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
            bmk := DataModule2.Table13.RecNo;                  {005B9F63 vtbl+150 = GetRecNo [0CC]}
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
          bmk := DataModule2.Table38.RecNo;                    {005BA05E vtbl+150 = GetRecNo [530]}
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
var
  i, cnt, maxnum: Integer;
  s, sg: AnsiString;
begin
  { Imports the OSB file kibu.dbf (directory taken from OpenDialog1.FileName,
    file name is stripped by 8 characters) into Table1; up to 4 marriages go
    into Table5. New record numbers are offset by gvar_02536940 (the last
    existing Table1.Nummer), afterwards gvar_02536944 is refreshed.
    Label18 shows the progress in %, Label19 the text "OSB lesen". }
  DataModule2.Table29.Open;                                    //005B22BD
  DataModule2.Table29.IndexName := 'qu';                       //005B22CF
  DataModule2.Table29.First;                                   //005B22E6
  gvar_02536648 := 1;                                          //005B22F8
  if DataModule2.Table1.RecordCount > 0 then                   //005B2302..16
  begin
    DataModule2.Table1.IndexName := '';                        //005B2318
    DataModule2.Table1.Last;                                   //005B2329
    gvar_02536940 := DataModule2.Table1Nummer.AsInteger;       //005B2338..50
  end;
  Form1.Refresh;                                               //005B2352
  DataModule2.Table23.Close;                                   //005B235E
  DataModule2.Table23.DatabaseName :=                          //005B2370..C8
    Copy(Form1.OpenDialog1.FileName, 1, Length(Form1.OpenDialog1.FileName) - 8);
  DataModule2.Table23.TableName := 'kibu.dbf';                 //005B23CD
  DataModule2.Table23.Open;                                    //005B23E4
  DataModule2.Table23.Last;                                    //005B23F6
  maxnum := DataModule2.Table23.FieldByName('num').AsInteger;  //005B2408..24
  DataModule2.Table23.First;                                   //005B2427
  cnt := 0;                                                    //005B2439
  Form1.Label18.Visible := True;                               //005B243E
  Form1.Label18.Caption := '0 %';                              //005B2452
  Form1.Label18.Refresh;                                       //005B2469
  Form1.Label19.Visible := True;                               //005B247B
  Form1.Label19.Caption := 'OSB lesen          ';              //005B248F
  Form1.Label19.Refresh;                                       //005B24A6
  while not DataModule2.Table23.Eof do                         //005B3651 -> 005B24BD
  begin
    Form1.Label18.Caption := IntToStr(Round(cnt / maxnum * 100)) + ' %';
    Form1.Label18.Refresh;                                     //005B24BD..09
    DataModule2.Table1.Append;                                 //005B250E
    DataModule2.Table1Nummer.AsInteger :=
      DataModule2.Table23.FieldByName('num').AsInteger + gvar_02536940;
    if DataModule2.Table23.FieldByName('vater').AsString > '0' then //005B2557..83
      DataModule2.Table1Vater.AsInteger :=
        StrToInt(DataModule2.Table23.FieldByName('vater').AsString) + gvar_02536940;
    if DataModule2.Table23.FieldByName('mutter').AsString > '0' then //005B25CA..F6
      DataModule2.Table1Mutter.AsInteger :=
        StrToInt(DataModule2.Table23.FieldByName('mutter').AsString) + gvar_02536940;
    DataModule2.Table1Name.AsString :=
      DataModule2.Table23.FieldByName('name').AsString;        //005B263D..74
    DataModule2.Table1Vornamen.AsString :=
      DataModule2.Table23.FieldByName('vornamen').AsString;    //005B2674..AB
    DataModule2.Table1Beruf.AsString :=
      DataModule2.Table23.FieldByName('beruf').AsString;       //005B26AB..E2
    DataModule2.Table1Geschlecht.AsString :=
      LowerCase(DataModule2.Table23.FieldByName('geschlecht').AsString); //005B26E2..24
    Form1.ucase(DataModule2.Table1Geschlecht.AsString, sg);    //005B2724..46
    if sg = 'F' then                                           //005B274B..58
      DataModule2.Table1Geschlecht.AsString := 'w';            //005B275A..74
    DataModule2.Table1Religion.AsString :=
      DataModule2.Table23.FieldByName('religion').AsString;    //005B2774..AB
    DataModule2.Table1Lebensort.AsString :=
      DataModule2.Table23.FieldByName('herkunft').AsString;    //005B27AB..DC
    DataModule2.Table1Gebtag.AsString :=
      DataModule2.Table23.FieldByName('gebtag').AsString;      //005B27E2..19
    DataModule2.Table1Gebmonat.AsString :=
      DataModule2.Table23.FieldByName('gebmonat').AsString;    //005B2819..50
    DataModule2.Table1Gebjahr.AsString :=
      DataModule2.Table23.FieldByName('gebjahr').AsString;     //005B2850..87
    DataModule2.Table1Gebort.AsString :=
      DataModule2.Table23.FieldByName('gebort').AsString;      //005B2887..BE
    DataModule2.Table1Quelleg.AsString := '';                  //005B28BE..D5
    DataModule2.Table1Tauftag.AsString :=
      Copy(DataModule2.Table23.FieldByName('tauftag').AsString, 1, 2);  //005B28D5..1C
    DataModule2.Table1Taufmonat.AsString :=
      Copy(DataModule2.Table23.FieldByName('tauftag').AsString, 4, 2);  //005B2922..69
    DataModule2.Table1Taufjahr.AsString :=
      Copy(DataModule2.Table23.FieldByName('tauftag').AsString, 7, 4);  //005B296F..B6
    DataModule2.Table1Taufort.AsString :=
      DataModule2.Table23.FieldByName('taufort').AsString;     //005B29BC..ED
    DataModule2.Table1Taufpat.AsString :=
      DataModule2.Table23.FieldByName('taufpat').AsString;     //005B29F3..2A
    DataModule2.Table1Quellet.AsString := '';                  //005B2A30..47
    DataModule2.Table1Sttag.AsString :=
      DataModule2.Table23.FieldByName('sttag').AsString;       //005B2A47..7E
    DataModule2.Table1Stmonat.AsString :=
      DataModule2.Table23.FieldByName('stmonat').AsString;     //005B2A84..BB
    DataModule2.Table1Stjahr.AsString :=
      DataModule2.Table23.FieldByName('stjahr').AsString;      //005B2AC1..F8
    DataModule2.Table1Stort.AsString :=
      DataModule2.Table23.FieldByName('stort').AsString;       //005B2AFE..35
    DataModule2.Table1Quelles.AsString := '';                  //005B2B3B..52
    DataModule2.Table1Todesurs.AsString :=
      DataModule2.Table23.FieldByName('todesurs').AsString;    //005B2B52..89
    DataModule2.Table1Begtag.AsString :=
      Copy(DataModule2.Table23.FieldByName('begrtag').AsString, 1, 2);  //005B2B8F..E2
    DataModule2.Table1Begmonat.AsString :=
      Copy(DataModule2.Table23.FieldByName('begrtag').AsString, 4, 2);  //005B2BE8..3B
    DataModule2.Table1Begjahr.AsString :=
      Copy(DataModule2.Table23.FieldByName('begrtag').AsString, 7, 4);  //005B2C41..94
    DataModule2.Table1Begort.AsString :=
      DataModule2.Table23.FieldByName('begrort').AsString;     //005B2C9A..D1
    DataModule2.Table1Quelleb.AsString := '';                  //005B2CD7..E8
    Form1.Memo1.Clear;                                        //005B2CEE vtbl+0DC
    Form1.Memo1.Lines.Assign(                                 //005B2D03..34 vtbl+8
      DataModule2.Table23.FieldByName('kommentar'));
    { Strips a trailing #$EC (listing shows the raw byte 0xEC at 005B3944)
      from every comment line - a leftover of the OSB export format. }
    for i := 0 to Form1.Memo1.Lines.Count - 1 do             //005B2D34..51
      if Copy(Form1.Memo1.Lines[i], Length(Form1.Memo1.Lines[i]), 1) = #$EC then
        Form1.Memo1.Lines[i] :=                              //005B2DCE..56 vtbl+20
          Copy(Form1.Memo1.Lines[i], 1, Length(Form1.Memo1.Lines[i]) - 1);
    DataModule2.Table1Kommentar.Assign(Form1.Memo1.Lines);   //005B2E61..86 vtbl+8
    if Trim(DataModule2.Table1Kommentar.AsString) <> '' then //005B2E9E..B6
      DataModule2.Table1Kommentar.AsString :=                //005B2EB8..11 CatN edx=5
        DataModule2.Table1Kommentar.AsString + #13 + #10 + #13 + #10;
    s := '';                                                  //005B2F11..14
    if DataModule2.Table23.FieldByName('quelle').AsString <> '' then //005B2F19..42
      s := s + 'Qu.: ' +                                     //005B2F44..86 CatN edx=5
        DataModule2.Table23.FieldByName('quelle').AsString + #13 + #10;
    if DataModule2.Table23.FieldByName('sonstiges').AsString <> '' then //005B2F8B..B4
      s := s + 'Bemerk.: ' +                                 //005B2FB6..EE CatN edx=3
        DataModule2.Table23.FieldByName('sonstiges').AsString;
    DataModule2.Table1Kommentar.AsString :=                  //005B2FF3..2A
      DataModule2.Table1Kommentar.AsString + s;
    DataModule2.Table1Lebt.AsString := 'n';                  //005B3030..4A
    if DataModule2.Table1Gebjahr.AsString <> '' then         //005B304A..69
    begin
      DataModule2.Table1Indj.AsString := DataModule2.Table1Gebjahr.AsString;  //005B306F..9C
      DataModule2.Table1Indm.AsString := DataModule2.Table1Gebmonat.AsString; //005B30A2..CF
      DataModule2.Table1Indt.AsString := DataModule2.Table1Gebtag.AsString;   //005B30D5..102
    end
    else
    begin
      DataModule2.Table1Indj.AsString := DataModule2.Table1Taufjahr.AsString;  //005B310D..3A
      DataModule2.Table1Indm.AsString := DataModule2.Table1Taufmonat.AsString; //005B3140..6D
      DataModule2.Table1Indt.AsString := DataModule2.Table1Tauftag.AsString;   //005B3173..A0
    end;
    try                                                       //005B31A6 SEH-Rahmen
      DataModule2.Table1.Post;
    except                                                    //005B31D0 jmp @HandleAnyException
    end;                                                      //005B31D5 call @DoneExcept
    for i := 1 to 4 do                                       //005B31DA..3636 i=1..4
      if Copy(DataModule2.Table23.FieldByName('ehen').AsString,
              (i - 1) * 6 + 1, 5) > '00000' then             //005B31E1..238
      begin
        DataModule2.Table5.Append;                           //005B323E..4B
        DataModule2.Table5Nummer.AsInteger :=
          DataModule2.Table23.FieldByName('num').AsInteger + gvar_02536940;
        DataModule2.Table5Epnum.AsInteger :=                 //005B328A..2E8
          StrToInt(Copy(DataModule2.Table23.FieldByName('ehen').AsString,
                         (i - 1) * 6 + 1, 5)) + gvar_02536940;
        DataModule2.Table5Htag.AsString :=                   //005B32EE..34A Cat3 edx='htag'
          DataModule2.Table23.FieldByName('htag' + IntToStr(i)).AsString;
        DataModule2.Table5Hmonat.AsString :=                 //005B3350..3AC
          DataModule2.Table23.FieldByName('hmonat' + IntToStr(i)).AsString;
        DataModule2.Table5Hjahr.AsString :=                  //005B33B2..40E
          DataModule2.Table23.FieldByName('hjahr' + IntToStr(i)).AsString;
        DataModule2.Table5Hort.AsString :=                   //005B3414..470
          DataModule2.Table23.FieldByName('hort' + IntToStr(i)).AsString;
        DataModule2.Table5Hqu.AsString := '';                //005B3476..48D
        DataModule2.Table5Trauz.AsString :=                  //005B348D..4E9
          DataModule2.Table23.FieldByName('trauz' + IntToStr(i)).AsString;
        DataModule2.Table5Verbind.AsString := 'Eheschliessung'; //005B34EF..503
        if DataModule2.Table5Hjahr.AsString <> '' then       //005B3509..528
        begin
          DataModule2.Table5Indj.AsString := DataModule2.Table5Hjahr.AsString;  //005B352A..557
          DataModule2.Table5Indm.AsString := DataModule2.Table5Hmonat.AsString; //005B355D..58A
        end
        else
        begin
          DataModule2.Table5Indj.AsString := DataModule2.Table5Sajahr.AsString;  //005B3592..5BF
          DataModule2.Table5Indm.AsString := DataModule2.Table5Samonat.AsString; //005B35C5..5F2
        end;
        try                                                   //005B35F8 SEH-Rahmen
          DataModule2.Table5.Post;
        except                                                //005B3625 jmp @HandleAnyException
        end;                                                  //005B362A call @DoneExcept
      end;
    Inc(cnt);                                                 //005B363C
    DataModule2.Table23.Next;                                 //005B363F
  end;                                                        //005B3651 Eof -> 005B24BD
  DataModule2.Table23.Close;                                  //005B366B
  Form1.listen_akt;                                           //005B367D
  Form1.Label18.Hide;                                         //005B3689
  Form1.Label19.Hide;                                         //005B369B
  DataModule2.Table1.Last;                                    //005B36AD
  gvar_02536944 := DataModule2.Table1Nummer.AsInteger;        //005B36BC..6D4
  DataModule2.Table1.First;                                   //005B36D6
  { Epilogue: the outer SEH frame is unwound and the string temporaries are
    released - compiler generated, not transcribed:
      @LStrArrayClr 0x54 slots from [ebp-16C], 3 slots from [ebp-1C],
      @LStrClr [ebp-10] }                                     //005B36E5..3717
end;

procedure TForm3.ahndosein;
var
  i, cnt, maxnum: Integer;
  s, t: AnsiString;
  local: TTable;
begin
  { Imports the AHNEN-DOS export ahnen.dbf (directory taken from
    OpenDialog1.FileName, file name stripped by 9 characters). The records
    are first copied into a locally created Paradox table 'ahntab'
    (TableType ttParadox, 43 field defs, primary index on 'n', working
    index 'ein'), afterwards every record is transferred to Table1; up to
    3 marriages, read from positions 13/18/23 of the 'code' key, go into
    Table5 ('00000' = no marriage). 19 string copies run through
    sub_005AFB14, the record numbers are offset by gvar_02536940 (the last
    existing Table1.Nummer), afterwards gvar_02536944 is refreshed.
    Label18 shows the progress in %, Label19 the text "AHNEN DOS lesen".
    SEH-Rahmen/Prolog-Teardown (@LStrArrayClr 0x64/0x35/3, @LStrClr,
    @HandleFinally) - nicht transkribiert. }
  DataModule2.Table29.Open;                                    //005AFBCC
  DataModule2.Table29.IndexName := 'qu';                       //005AFBD1..E3
  DataModule2.Table29.First;                                   //005AFBE8..F5
  gvar_02536648 := 1;                                          //005AFBFA
  { 005AFC04..5AFF3B: Hilfstabelle 'ahntab' lokal anlegen - TTable.Create
    mit AOwner=Self (ecx=[ebp-4], dl=1), danach 43 FieldDefs. }
  local := TTable.Create(Self);                                //005AFC04..13
  local.TableType := ttParadox;                                //005AFC16..1B
  local.TableName := 'ahntab';                                 //005AFC20..28
  local.FieldDefs.Clear;                                       //005AFC2D..35
  local.FieldDefs.Add('n', ftAutoInc, 0, True);                //005AFC47
  local.FieldDefs.Add('num', ftInteger, 0, True);              //005AFC59
  local.FieldDefs.Add('name', ftString, 30, False);            //005AFC6B
  local.FieldDefs.Add('vornamen', ftString, 30, False);        //005AFC7D
  local.FieldDefs.Add('code', ftString, 30, False);            //005AFC8F
  local.FieldDefs.Add('geschlecht', ftString, 1, False);       //005AFCA1
  local.FieldDefs.Add('religion', ftString, 2, False);         //005AFCB3
  local.FieldDefs.Add('beruf', ftString, 30, False);           //005AFCC5
  local.FieldDefs.Add('Lebensorte', ftString, 80, False);      //005AFCD7
  local.FieldDefs.Add('gebtag', ftString, 2, False);           //005AFCE9
  local.FieldDefs.Add('gebmonat', ftString, 2, False);         //005AFCFB
  local.FieldDefs.Add('gebjahr', ftString, 4, False);          //005AFD0D
  local.FieldDefs.Add('gebort', ftString, 40, False);          //005AFD1F
  local.FieldDefs.Add('tauftag', ftString, 10, False);         //005AFD31
  local.FieldDefs.Add('taufort', ftString, 40, False);         //005AFD43
  local.FieldDefs.Add('taufpat', ftString, 55, False);         //005AFD55
  local.FieldDefs.Add('htag1', ftString, 2, False);            //005AFD67
  local.FieldDefs.Add('hmonat1', ftString, 2, False);          //005AFD79
  local.FieldDefs.Add('hjahr1', ftString, 4, False);           //005AFD8B
  local.FieldDefs.Add('hort1', ftString, 40, False);           //005AFD9D
  local.FieldDefs.Add('trauz1', ftString, 55, False);          //005AFDAF
  local.FieldDefs.Add('htag2', ftString, 2, False);            //005AFDC1
  local.FieldDefs.Add('hmonat2', ftString, 2, False);          //005AFDD3
  local.FieldDefs.Add('hjahr2', ftString, 4, False);           //005AFDE5
  local.FieldDefs.Add('hort2', ftString, 40, False);           //005AFDF7
  local.FieldDefs.Add('trauz2', ftString, 55, False);          //005AFE09
  local.FieldDefs.Add('htag3', ftString, 2, False);            //005AFE1B
  local.FieldDefs.Add('hmonat3', ftString, 2, False);          //005AFE2D
  local.FieldDefs.Add('hjahr3', ftString, 4, False);           //005AFE3F
  local.FieldDefs.Add('hort3', ftString, 40, False);           //005AFE51
  local.FieldDefs.Add('trauz3', ftString, 55, False);          //005AFE63
  local.FieldDefs.Add('sttag', ftString, 2, False);            //005AFE75
  local.FieldDefs.Add('stmonat', ftString, 2, False);          //005AFE87
  local.FieldDefs.Add('stjahr', ftString, 4, False);           //005AFE99
  local.FieldDefs.Add('stort', ftString, 40, False);           //005AFEAB
  local.FieldDefs.Add('stalter', ftString, 3, False);          //005AFEBD
  local.FieldDefs.Add('todesurs', ftString, 15, False);        //005AFECF
  local.FieldDefs.Add('begrtag', ftString, 10, False);         //005AFEE1
  local.FieldDefs.Add('begrort', ftString, 40, False);         //005AFEF3
  local.FieldDefs.Add('quelle', ftString, 60, False);          //005AFF05
  local.FieldDefs.Add('sonstiges', ftString, 60, False);       //005AFF17
  local.FieldDefs.Add('kommentar', ftMemo, 10, False);         //005AFF29
  local.FieldDefs.Add('tx', ftString, 1, False);               //005AFF3B
  { 005AFF40..5AFF76: IndexDefs - Primverzeichnis auf 'n', Arbeits-
    verzeichnis 'ein' auf name;gebjahr;gebmonat;gebtag. }
  local.IndexDefs.Clear;                                       //005AFF40..4B
  local.IndexDefs.Add('', 'n', [ixPrimary]);                   //005AFF50..5F
  local.IndexDefs.Add('ein', 'name;gebjahr;gebmonat;gebtag',
    [ixCaseInsensitive]);                                      //005AFF64..76
  local.CreateTable;                                           //005AFF7B..7E
  local.IndexName := 'ein';                                    //005AFF83..8B
  local.Open;                                                  //005AFF90..93
  DataModule2.Table23.Close;                                   //005AFF98..A5
  DataModule2.Table23.DatabaseName :=                          //005AFFAA..005B0002
    Copy(Form1.OpenDialog1.FileName, 1, Length(Form1.OpenDialog1.FileName) - 9);
  DataModule2.Table23.TableName := 'ahnen.dbf';                //005B0007..19
  DataModule2.Table23.Open;                                    //005B001E..2B
  DataModule2.Table23.First;                                   //005B0030..3D
  { 005B0047..5B0B6F: Schleife ueber ahnen.dbf - 42 Feldkopien von
    Table23 in die Hilfstabelle, 19 davon mit sub_005AFB14. }
  while not DataModule2.Table23.Eof do                         //005B0042..B6F
  begin
    local.Append;                                              //005B0047..4A
    local.FieldByName('num').AsInteger :=
      DataModule2.Table23.FieldByName('num').AsInteger;        //005B004F..7C
    local.FieldByName('code').AsString :=
      DataModule2.Table23.FieldByName('code').AsString;        //005B0082..B5
    sub_005AFB14(DataModule2.Table23.FieldByName('name').AsString, t); //005B00BB..E0
    local.FieldByName('name').AsString := t;                   //005B00E5..F9
    sub_005AFB14(DataModule2.Table23.FieldByName('vornamen').AsString, t); //005B00FF..124
    local.FieldByName('vornamen').AsString := t;               //005B0129..3D
    local.FieldByName('geschlecht').AsString :=
      DataModule2.Table23.FieldByName('geschlecht').AsString;  //005B0143..76
    local.FieldByName('religion').AsString :=
      DataModule2.Table23.FieldByName('religion').AsString;    //005B017C..AF
    sub_005AFB14(DataModule2.Table23.FieldByName('beruf').AsString, t); //005B01B5..DA
    local.FieldByName('beruf').AsString := t;                  //005B01DF..F3
    sub_005AFB14(DataModule2.Table23.FieldByName('lebensorte').AsString, t); //005B01F9..21E
    local.FieldByName('lebensorte').AsString := t;             //005B0223..37
    local.FieldByName('gebtag').AsString :=
      DataModule2.Table23.FieldByName('gebtag').AsString;      //005B023D..70
    local.FieldByName('gebmonat').AsString :=
      DataModule2.Table23.FieldByName('gebmonat').AsString;    //005B0276..A9
    local.FieldByName('gebjahr').AsString :=
      DataModule2.Table23.FieldByName('gebjahr').AsString;     //005B02AF..E2
    sub_005AFB14(DataModule2.Table23.FieldByName('gebort').AsString, t); //005B02E8..30D
    local.FieldByName('gebort').AsString := t;                 //005B0312..26
    local.FieldByName('tauftag').AsString :=
      DataModule2.Table23.FieldByName('tauftag').AsString;     //005B032C..5F
    sub_005AFB14(DataModule2.Table23.FieldByName('taufort').AsString, t); //005B0365..38A
    local.FieldByName('taufort').AsString := t;                //005B038F..A3
    sub_005AFB14(DataModule2.Table23.FieldByName('taufpat').AsString, t); //005B03A9..3CE
    local.FieldByName('taufpat').AsString := t;                //005B03D3..E7
    local.FieldByName('htag1').AsString :=
      DataModule2.Table23.FieldByName('htag1').AsString;       //005B03ED..420
    local.FieldByName('hmonat1').AsString :=
      DataModule2.Table23.FieldByName('hmonat1').AsString;     //005B0426..59
    local.FieldByName('hjahr1').AsString :=
      DataModule2.Table23.FieldByName('hjahr1').AsString;      //005B045F..98
    sub_005AFB14(DataModule2.Table23.FieldByName('hort1').AsString, t); //005B049E..4CC
    local.FieldByName('hort1').AsString := t;                  //005B04D1..E8
    sub_005AFB14(DataModule2.Table23.FieldByName('trauz1').AsString, t); //005B04EE..51C
    local.FieldByName('trauz1').AsString := t;                 //005B0521..38
    local.FieldByName('htag2').AsString :=
      DataModule2.Table23.FieldByName('htag2').AsString;       //005B053E..77
    local.FieldByName('hmonat2').AsString :=
      DataModule2.Table23.FieldByName('hmonat2').AsString;     //005B057D..B6
    local.FieldByName('hjahr2').AsString :=
      DataModule2.Table23.FieldByName('hjahr2').AsString;      //005B05BC..F5
    sub_005AFB14(DataModule2.Table23.FieldByName('hort2').AsString, t); //005B05FB..629
    local.FieldByName('hort2').AsString := t;                  //005B062E..45
    sub_005AFB14(DataModule2.Table23.FieldByName('trauz2').AsString, t); //005B064B..679
    local.FieldByName('trauz2').AsString := t;                 //005B067E..95
    local.FieldByName('htag3').AsString :=
      DataModule2.Table23.FieldByName('htag3').AsString;       //005B069B..D4
    local.FieldByName('hmonat3').AsString :=
      DataModule2.Table23.FieldByName('hmonat3').AsString;     //005B06DA..713
    local.FieldByName('hjahr3').AsString :=
      DataModule2.Table23.FieldByName('hjahr3').AsString;      //005B0719..52
    sub_005AFB14(DataModule2.Table23.FieldByName('hort3').AsString, t); //005B0758..786
    local.FieldByName('hort3').AsString := t;                  //005B078B..A2
    sub_005AFB14(DataModule2.Table23.FieldByName('trauz3').AsString, t); //005B07A8..7D6
    local.FieldByName('trauz3').AsString := t;                 //005B07DB..F2
    local.FieldByName('sttag').AsString :=
      DataModule2.Table23.FieldByName('sttag').AsString;       //005B07F8..831
    local.FieldByName('stmonat').AsString :=
      DataModule2.Table23.FieldByName('stmonat').AsString;     //005B0837..70
    local.FieldByName('stjahr').AsString :=
      DataModule2.Table23.FieldByName('stjahr').AsString;      //005B0876..AF
    sub_005AFB14(DataModule2.Table23.FieldByName('stort').AsString, t); //005B08B5..8E3
    local.FieldByName('stort').AsString := t;                  //005B08E8..FF
    local.FieldByName('stalter').AsString :=
      DataModule2.Table23.FieldByName('stalter').AsString;     //005B0905..3E
    sub_005AFB14(DataModule2.Table23.FieldByName('todesurs').AsString, t); //005B0944..972
    local.FieldByName('todesurs').AsString := t;               //005B0977..8E
    local.FieldByName('begrtag').AsString :=
      DataModule2.Table23.FieldByName('begrtag').AsString;     //005B0994..CD
    sub_005AFB14(DataModule2.Table23.FieldByName('begrort').AsString, t); //005B09D3..A01
    local.FieldByName('begrort').AsString := t;                //005B0A06..1D
    sub_005AFB14(DataModule2.Table23.FieldByName('quelle').AsString, t); //005B0A23..A51
    local.FieldByName('quelle').AsString := t;                 //005B0A56..6D
    sub_005AFB14(DataModule2.Table23.FieldByName('sonstiges').AsString, t); //005B0A73..AA1
    local.FieldByName('sonstiges').AsString := t;              //005B0AA6..BD
    sub_005AFB14(DataModule2.Table23.FieldByName('kommentar').AsString, t); //005B0AC3..AF1
    local.FieldByName('kommentar').AsString := t;              //005B0AF6..0B0D
    local.FieldByName('tx').AsString :=
      DataModule2.Table23.FieldByName('tx').AsString;          //005B0B13..4C
    local.Post;                                                //005B0B52..57
    DataModule2.Table23.Next;                                  //005B0B5D..6A
  end;
  if DataModule2.Table1.RecordCount > 0 then                   //005B0B89..9D
  begin
    DataModule2.Table1.IndexName := '';                        //005B0B9F..AB
    DataModule2.Table1.Last;                                   //005B0BB0..BA
    gvar_02536940 := DataModule2.Table1Nummer.AsInteger;       //005B0BBF..D7
  end;
  local.First;                                                 //005B0BD9..DC
  maxnum := local.RecordCount;                                 //005B0BE1..EC
  cnt := 0;                                                    //005B0BEF..F1
  Form1.Label18.Caption := '0 %';                              //005B0BF4..C06
  Form1.Label19.Refresh;                                       //005B0C0B..C18
  Form1.Label19.Caption := 'AHNEN DOS lesen         ';         //005B0C1D..C2F
  Form1.Label19.Refresh;                                       //005B0C34..C41
  Form1.lab18ein;                                              //005B0C46..4D
  { 005B0C57..5B1D70: Schleife ueber die Hilfstabelle - eine Person nach
    Table1, Indizes aus Geb- oder Taufdatum, Kommentar aus dem Memo-
    Feld und den Orten sonstiges/quelle, danach bis zu 3 Ehen nach
    Table5. }
  while not local.Eof do                                       //005B0C52..D66
  begin
    Form1.Label18.Caption := IntToStr(Round(cnt / maxnum * 100)) + ' %';
    Form1.Label18.Refresh;                                     //005B0C57..CAC
    DataModule2.Table1.Append;                                 //005B0CB1..BB
    DataModule2.Table1Nummer.AsInteger :=
      local.FieldByName('num').AsInteger + gvar_02536940;      //005B0CC0..CEA
    if (Copy(local.FieldByName('code').AsString, 5, 4) > '00000') and
       (Copy(local.FieldByName('code').AsString, 5, 4) <> '') then //005B0CF0..D75
      DataModule2.Table1Vater.AsInteger :=
        StrToInt(Trim(Copy(local.FieldByName('code').AsString, 5, 4))) +
        gvar_02536940;                                         //005B0D77..DDF
    if (Copy(local.FieldByName('code').AsString, 9, 4) > '00000') and
       (Copy(local.FieldByName('code').AsString, 9, 4) <> '') then //005B0DE5..E6A
      DataModule2.Table1Mutter.AsInteger :=
        StrToInt(Trim(Copy(local.FieldByName('code').AsString, 9, 4))) +
        gvar_02536940;                                         //005B0E6C..ED4
    DataModule2.Table1Name.AsString :=
      local.FieldByName('name').AsString;                      //005B0EDA..F07
    DataModule2.Table1Vornamen.AsString :=
      local.FieldByName('vornamen').AsString;                  //005B0F0D..F3A
    DataModule2.Table1Beruf.AsString :=
      local.FieldByName('beruf').AsString;                     //005B0F40..F6D
    DataModule2.Table1Geschlecht.AsString :=
      LowerCase(local.FieldByName('geschlecht').AsString);     //005B0F73..FB1
    if ucase(DataModule2.Table1Geschlecht.AsString) = 'F' then //005B0FB7..1009
      DataModule2.Table1Geschlecht.AsString := 'w';
    DataModule2.Table1Religion.AsString :=
      local.FieldByName('religion').AsString;                  //005B100F..103C
    DataModule2.Table1Gebtag.AsString :=
      local.FieldByName('gebtag').AsString;                    //005B1042..106F
    DataModule2.Table1Gebmonat.AsString :=
      local.FieldByName('gebmonat').AsString;                  //005B1075..10A2
    DataModule2.Table1Gebjahr.AsString :=
      local.FieldByName('gebjahr').AsString;                   //005B10A8..10D5
    DataModule2.Table1Gebort.AsString :=
      local.FieldByName('gebort').AsString;                    //005B10DB..1108
    DataModule2.Table1Quelleg.AsString := '';                  //005B110E..111F
    DataModule2.Table1Tauftag.AsString :=
      Copy(local.FieldByName('tauftag').AsString, 1, 2);       //005B1125..116E
    DataModule2.Table1Taufmonat.AsString :=
      Copy(local.FieldByName('tauftag').AsString, 4, 2);       //005B1174..11BD
    DataModule2.Table1Taufjahr.AsString :=
      Copy(local.FieldByName('tauftag').AsString, 7, 4);       //005B11C3..120C
    DataModule2.Table1Taufort.AsString :=
      local.FieldByName('taufort').AsString;                   //005B1212..123F
    DataModule2.Table1Taufpat.AsString :=
      local.FieldByName('taufpat').AsString;                   //005B1245..1272
    DataModule2.Table1Quellet.AsString := '';                  //005B1278..1289
    DataModule2.Table1Sttag.AsString :=
      local.FieldByName('sttag').AsString;                     //005B128F..12BC
    DataModule2.Table1Stmonat.AsString :=
      local.FieldByName('stmonat').AsString;                   //005B12C2..12EF
    DataModule2.Table1Stjahr.AsString :=
      local.FieldByName('stjahr').AsString;                    //005B12F5..1322
    DataModule2.Table1Stort.AsString :=
      local.FieldByName('stort').AsString;                     //005B1328..1355
    DataModule2.Table1Quelles.AsString := '';                  //005B135B..136C
    DataModule2.Table1Todesurs.AsString :=
      local.FieldByName('todesurs').AsString;                  //005B1372..139F
    DataModule2.Table1Begtag.AsString :=
      Copy(local.FieldByName('begrtag').AsString, 1, 2);       //005B13A5..13EE
    DataModule2.Table1Begmonat.AsString :=
      Copy(local.FieldByName('begrtag').AsString, 4, 2);       //005B13F4..143D
    DataModule2.Table1Begjahr.AsString :=
      Copy(local.FieldByName('begrtag').AsString, 7, 4);       //005B1443..148C
    DataModule2.Table1Begort.AsString :=
      local.FieldByName('begrort').AsString;                   //005B1492..14BF
    DataModule2.Table1Quelleb.AsString := '';                  //005B14C5..14D6
    Form1.Memo1.Clear;                                         //005B14DC..14EB
    Form1.Memo1.Lines.Assign(local.FieldByName('kommentar'));  //005B14F1..1515
    { 005B1518..5B163F: Abschneiden eines abschliessenden #$EC aus jeder
      Memo-Zeile (wahrscheinlich Rest des Zeilenumbruchs der DOS-Datei). }
    for i := 0 to Form1.Memo1.Lines.Count - 1 do
      if Copy(Form1.Memo1.Lines[i], Length(Form1.Memo1.Lines[i]), 1) = #$EC then
        Form1.Memo1.Lines[i] :=
          Copy(Form1.Memo1.Lines[i], 1, Length(Form1.Memo1.Lines[i]) - 1);
    DataModule2.Table1Kommentar.Assign(Form1.Memo1.Lines);     //005B1645..1667
    if Trim(DataModule2.Table1Kommentar.AsString) <> '' then   //005B166A..16EF
      DataModule2.Table1Kommentar.AsString :=
        DataModule2.Table1Kommentar.AsString + #13#10#13#10;
    { 005B16F5..5B1745: Debug-Rest des Originals - meldet einen gefuellten
      Kommentar per ShowMessage, bewusst uebernommen. }
    if Trim(DataModule2.Table1Kommentar.AsString) <> '' then
      ShowMessage(DataModule2.Table1Kommentar.AsString);
    s := '';                                                   //005B174A..74D
    if local.FieldByName('sonstiges').AsString <> '' then      //005B1752..17AB
      s := s + 'Bemerk.: ' + local.FieldByName('sonstiges').AsString + #13#10;
    if local.FieldByName('quelle').AsString <> '' then         //005B17B0..1809
      s := s + 'Qu.: ' + local.FieldByName('quelle').AsString + #13#10;
    DataModule2.Table1Kommentar.AsString :=
      DataModule2.Table1Kommentar.AsString + s;                //005B180E..1845
    DataModule2.Table1Lebensort.AsString :=
      local.FieldByName('lebensorte').AsString;                //005B184B..1878
    DataModule2.Table1Lebt.AsString := 'n';                    //005B187E..1892
    if DataModule2.Table1Gebjahr.AsString <> '' then           //005B1898..1956
    begin
      DataModule2.Table1Indj.AsString :=
        DataModule2.Table1Gebjahr.AsString;                    //005B18BD..18E8
      DataModule2.Table1Indm.AsString :=
        DataModule2.Table1Gebmonat.AsString;                   //005B18F0..191D
      DataModule2.Table1Indt.AsString :=
        DataModule2.Table1Gebtag.AsString;                     //005B1923..1950
    end
    else
    begin
      DataModule2.Table1Indj.AsString :=
        DataModule2.Table1Taufjahr.AsString;                   //005B195B..1988
      DataModule2.Table1Indm.AsString :=
        DataModule2.Table1Taufmonat.AsString;                  //005B198E..19BB
      DataModule2.Table1Indt.AsString :=
        DataModule2.Table1Tauftag.AsString;                    //005B19C1..19EE
    end;
    try
      DataModule2.Table1.Post;                                 //005B19F4..1A23
    except
    end;
    for i := 1 to 3 do                                         //005B1A28..1D55
      if Copy(local.FieldByName('code').AsString, (i - 1) * 5 + 13, 4) > '00000' then
      begin
        DataModule2.Table5.Append;                             //005B1A81..1A8E
        DataModule2.Table5Nummer.AsInteger :=
          local.FieldByName('num').AsInteger + gvar_02536940;  //005B1A93..ABD
        DataModule2.Table5Epnum.AsInteger :=
          StrToInt(Trim(Copy(local.FieldByName('code').AsString,
            (i - 1) * 5 + 13, 4))) + gvar_02536940;           //005B1AC3..B28
        DataModule2.Table5Htag.AsString :=
          local.FieldByName('htag' + IntToStr(i)).AsString;    //005B1B2E..B80
        DataModule2.Table5Hmonat.AsString :=
          local.FieldByName('hmonat' + IntToStr(i)).AsString;  //005B1B86..BD8
        DataModule2.Table5Hjahr.AsString :=
          local.FieldByName('hjahr' + IntToStr(i)).AsString;   //005B1BDE..C30
        DataModule2.Table5Hort.AsString :=
          local.FieldByName('hort' + IntToStr(i)).AsString;    //005B1C36..C88
        DataModule2.Table5Hqu.AsString := '';                  //005B1C8E..C9F
        DataModule2.Table5Trauz.AsString :=
          local.FieldByName('trauz' + IntToStr(i)).AsString;   //005B1CA5..CF7
        DataModule2.Table5Verbind.AsString := 'Eheschliessung'; //005B1CFD..D11
        try
          DataModule2.Table5.Post;                             //005B1D17..D49
        except
        end;
      end;
    Inc(cnt);                                                  //005B1D5B
    local.Next;                                                //005B1D5E..D61
  end;
  local.Close;                                                 //005B1D76..D79
  local.Free;                                                  //005B1D7E..D81
  Form1.listen_akt;                                            //005B1D86..D8D
  Form1.Label18.Hide;                                          //005B1D92..D9F
  Form1.Label19.Hide;                                          //005B1DA4..DB1
  DataModule2.Table1.Last;                                     //005B1DB6..DC0
  gvar_02536944 := DataModule2.Table1Nummer.AsInteger;         //005B1DC5..DDD
  DataModule2.Table1.First;                                    //005B1DDF..DE9
  { Epilogue: the outer SEH frame is unwound and the string temporaries are
    released - compiler generated, not transcribed:
      @LStrArrayClr 0x64 slots from [ebp-288], 0x35 slots from [ebp-0F8],
      3 slots from [ebp-24], @LStrClr [ebp-14] }               //005B1DEE..E30
end;

procedure TForm3.gedausx;
var
  cnt: Integer;                 {005A63C3 [ebp-10] Zaehler (Fn-Nummer)}
  anz: Integer;                 {005A63D5 [ebp-14] = Table1.RecordCount (Fortschritt)}
  upd: Integer;                 {005A75FB [ebp-18] 1 = Table31-Eintrag aktualisiert}
  vnr: Integer;                 {005A7615 [esi] Table31Av (Vater-Nummer)}
  mnr: Integer;                 {005A7624 [edi] Table31Am (Mutter-Nummer)}
  flag: Boolean;                {005A6529 [esi] Treffer-Flag des Table32-Scans}
  t: AnsiString;                {005A64A2 [ebp-8] toter Reset (einziges Vorkommen)}
  fk: AnsiString;               {005A64AA [ebp-4] Kinder-Liste im Table5-Lauf}
  uk: AnsiString;               {005A71AC [ebp-0C] Kinder-Liste im Post-Loop}
  n6, ep6, fn6: AnsiString;     {00576EB0-Temps: 6-stellige Nummer, Epnum, StrToInt(Fn)}
begin
  { 005A634C: gedausx - baut Table32 (Paar-Tabelle) auf:
    pro Person (Table1) und pro Ehe (Table5) wird - falls nicht schon ueber
    den Index v/m ein passender Eintrag existiert - ein Datensatz mit den
    Ehe-, Scheidungs- und Verbindungsdaten angehaengt (Dedup-Scan auf
    Table32, Kinder-Liste fk aus Table17 index vat/mut).
    Nach dem Table1-Lauf werden die Table31-Adressen eingepflegt
    (Edit mit Fk-Ergaenzung bzw. neuer Eintrag; gvar_02536660 sammelt
    'Nummer*Fn#' fuer den Folgelauf) und Eintraege ohne Partner
    (Table17 vat/mut ohne Gegennummer) nachgetragen.
    Die Hilfsaufrufe sub_00576EB0 stehen vor der jeweiligen Aussage -
    die Auswerte-Reihenfolge innerhalb der CatN-Ausdruecke weicht dadurch
    geringfuegig ab (siehe Recon-Notizen).
    SEH-Rahmen/Prolog-Teardown (@LStrArrayClr 64/F/2/3, @LStrClr) -
    nicht transkribiert. }

  DataModule2.Table31.Open;                                    //005A6373..637B
  DataModule2.Table31.IndexName := '';                         //005A6380..638A
  DataModule2.Table32.Open;                                    //005A638F..6397
  DataModule2.Table32.Close;                                   //005A639C..63A4
  DataModule2.Table32.EmptyTable;                              //005A63A9..63B1
  DataModule2.Table32.Open;                                    //005A63B6..63BE
  cnt := 0;                                                    //005A63C3 [ebp-10]
  { toter Zugriff auf Table1Nummer.AsInteger - Ergebnis ungenutzt } //005A63C8..63D2
  anz := DataModule2.Table1.RecordCount;                       //005A63D5..63E2 [ebp-14]
  DataModule2.Table1.IndexName := '';                          //005A63E5..63EC
  DataModule2.Table1.First;                                    //005A63F1..63F6
  DataModule2.Table17.Open;                                    //005A63FB..6403
  DataModule2.Table17.IndexName := '';                         //005A6408..6412
  DataModule2.Table17.First;                                   //005A6417..641F
  DataModule2.Table5.IndexName := 'num';                       //005A6424..6431

  while not DataModule2.Table1.Eof do                          //005A6436 jmp / cond 005A75C2..75CE
  begin
    Form1.Label18.Caption :=                                   //005A643B..648B [400]
      IntToStr(Round(DataModule2.Table1Nummer.AsInteger / anz * 100 / 2)) + ' %';
    Form1.Label18.Refresh;                                     //005A6490..649D
    t := '';                                                   //005A64A2..64A5 toter Reset
    fk := '';                                                  //005A64AA..64AD
    if DataModule2.Table5.RecordCount > 0 then                 //005A64B2..64C4 jle->005A71AC
    begin
      DataModule2.Table5.First;                                //005A64CA..64D2
      while not DataModule2.Table5.Eof do                      //005A64D7 jmp / cond 005A7197..71A6
      begin
        if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then //005A64DC..6504 jne->005A6AEB
        begin
          DataModule2.Table32.IndexName := 'v';                //005A650A..6517
          DataModule2.Table32.First;                           //005A651C..6524
          flag := False;                                       //005A6529 [esi]
          sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6); //005A652B..6546 [ebp-34]
          if DataModule2.Table32.FindKey([n6]) then            //005A654A..655E je->005A65F7
            while DataModule2.Table32Fv.AsString = n6 do       //005A6564 jmp / cond 005A65BF..65F1
            begin
              sub_00576EB0(DataModule2.Table5Epnum.AsInteger, ep6); //005A6566..658F [ebp-3C]
              if DataModule2.Table32Fm.AsString = ep6 then     //005A6593..6598 jne->005A65A1
              begin
                flag := True;                                  //005A659A [esi]
                Break;                                         //005A659F jmp->005A65F7
              end;
              DataModule2.Table32.Next;                        //005A65A1..65A9
              if DataModule2.Table32.Eof then Break;           //005A65AE..65BD jne->005A65F7
            end;
          DataModule2.Table32.First;                           //005A65F7..65FF
          sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6); //005A6604..6619 [ebp-48]
          if not (DataModule2.Table32.FindKey([n6]) and flag) then //005A6623..663B je->005A6641 / jne->005A7179
          begin
            Inc(cnt);                                          //005A6641
            DataModule2.Table32.Append;                        //005A6644..664C
            sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6); //005A6651..6666 [ebp-4C]
            DataModule2.Table32Fv.AsString := n6;              //005A6669..6673 [2C4]
            sub_00576EB0(DataModule2.Table5Epnum.AsInteger, ep6); //005A6679..668E [ebp-50]
            DataModule2.Table32Fm.AsString := ep6;             //005A6691..669B [2C8]
            DataModule2.Table32H.AsString :=                   //005A66A1..66F4 [2D4]
              sub_00582C24(DataModule2.Table5Htag.AsString,    {418 Tag}
                           DataModule2.Table5Hmonat.AsString,  {41C Monat}
                           DataModule2.Table5Hjahr.AsString);  {420 Jahr}
            DataModule2.Table32Ho.AsString :=
              DataModule2.Table5Hort.AsString;                 //005A66FA..6717 [2D8]
            DataModule2.Table32Htz.AsString :=
              DataModule2.Table5Trauz.AsString;                //005A671D..673A [310]
            DataModule2.Table32Hq.AsString :=
              DataModule2.Table5Hqu.AsString;                  //005A6740..675D [2F8]
            DataModule2.Table32S.AsString :=                   //005A6763..67B6 [2DC]
              sub_00582C24(DataModule2.Table5Satag.AsString,   {42C Tag}
                           DataModule2.Table5Samonat.AsString, {430 Monat}
                           DataModule2.Table5Sajahr.AsString); {434 Jahr}
            DataModule2.Table32So.AsString :=
              DataModule2.Table5Saort.AsString;                //005A67BC..67D9 [2E0]
            DataModule2.Table32Stz.AsString :=
              DataModule2.Table5Satrauz.AsString;              //005A67DF..6802 [314]
            DataModule2.Table32Sq.AsString :=
              DataModule2.Table5Saqu.AsString;                 //005A6808..682B [2FC]
            DataModule2.Table32Sch.AsString :=                 //005A6831..689C [2E4]
              sub_00582C24(DataModule2.Table5Schtag.AsString,  {444 Tag}
                           DataModule2.Table5Schmonat.AsString,{448 Monat}
                           DataModule2.Table5Schjahr.AsString);{44C Jahr}
            DataModule2.Table32Scho.AsString :=
              DataModule2.Table5Schort.AsString;               //005A68A2..68C5 [2E8]
            DataModule2.Table32Schq.AsString :=
              DataModule2.Table5Schqu.AsString;                //005A68CB..68EE [300]
            DataModule2.Table32Vb.AsString :=                  //005A68F4..6944 [2EC]
              UpperCase(Copy(DataModule2.Table5Verbind.AsString, 1, 1));
            DataModule2.Table32Fn.AsString := IntToStr(cnt);   //005A694A..6968 [2D0]
            DataModule2.Table32Indj.AsString :=
              DataModule2.Table5Indj.AsString;                 //005A696E..6991 [2F0]
            DataModule2.Table32Indm.AsString :=
              DataModule2.Table5Indm.AsString;                 //005A6997..69BA [2F4]
            fk := '';                                          //005A69C0..69C3
            DataModule2.Table17.IndexName := 'vat';            //005A69C8..69D5
            DataModule2.Table17.First;                         //005A69DA..69E2
            if DataModule2.Table17.FindKey([DataModule2.Table1Nummer.AsInteger]) then //005A69E7..6A0F je->005A6AAC
              while DataModule2.Table17Vater.AsInteger = DataModule2.Table1Nummer.AsInteger do //005A6A15 jmp / cond 005A6A88..6AA6
              begin
                if DataModule2.Table17Mutter.AsInteger = DataModule2.Table5Epnum.AsInteger then //005A6A17..6A35 jne->005A6A6A
                begin
                  sub_00576EB0(DataModule2.Table17Nummer.AsInteger, n6); //005A6A37..6A4D [ebp-0BC]
                  fk := fk + n6 + '*';                         //005A6A52..6A65 CatN3
                end;
                DataModule2.Table17.Next;                      //005A6A6A..6A72
                if DataModule2.Table17.Eof then Break;         //005A6A77..6A86 jne->005A6AAC
              end;
            if Trim(fk) <> '' then                             //005A6AAC..6AC1 jbe->005A6AD6
              DataModule2.Table32Fk.AsString := fk;            //005A6AC3..6AD0 (ungetrimmt)
            DataModule2.Table32.Post;                          //005A6AD6..6AE0 vtbl+248
          end;                                                 //005A6AE6 jmp->005A7179
        end
        else if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then //005A6AEB..6B1F jne->005A7179
        begin
          DataModule2.Table32.IndexName := 'm';                //005A6B25..6B32
          DataModule2.Table32.First;                           //005A6B37..6B3F
          flag := False;                                       //005A6B44 [esi]
          sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6); //005A6B46..6B67 [ebp-0CC]
          if DataModule2.Table32.FindKey([n6]) then            //005A6B6B..6B7F je->005A6C30
            while DataModule2.Table32Fm.AsString = n6 do       //005A6B85 jmp / cond 005A6BEC..6C2A
            begin
              sub_00576EB0(DataModule2.Table5Epnum.AsInteger, ep6); //005A6B87..6BB4 [ebp-0D4]
              if DataModule2.Table32Fv.AsString = ep6 then     //005A6BB9..6BC5 jne->005A6BCE
              begin
                flag := True;                                  //005A6BC7 [esi]
                Break;                                         //005A6BCC jmp->005A6C30
              end;
              DataModule2.Table32.Next;                        //005A6BCE..6BD6
              if DataModule2.Table32.Eof then Break;           //005A6BDB..6BEA jne->005A6C30
            end;
          DataModule2.Table32.First;                           //005A6C30..6C38
          sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6); //005A6C3D..6C55 [ebp-0E0]
          if not (DataModule2.Table32.FindKey([n6]) and flag) then //005A6C62..6C7A je->005A6C80 / jne->005A7179
          begin
            Inc(cnt);                                          //005A6C80
            DataModule2.Table32.Append;                        //005A6C83..6C8B
            sub_00576EB0(DataModule2.Table5Epnum.AsInteger, ep6); //005A6C90..6CA8 [ebp-0E4]
            DataModule2.Table32Fv.AsString := ep6;             //005A6CAE..6CB8 [2C4]
            sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6); //005A6CBE..6CD6 [ebp-0E8]
            DataModule2.Table32Fm.AsString := n6;              //005A6CDC..6CE6 [2C8]
            DataModule2.Table32H.AsString :=                   //005A6CEC..6D57 [2D4]
              sub_00582C24(DataModule2.Table5Htag.AsString,    {418 Tag}
                           DataModule2.Table5Hmonat.AsString,  {41C Monat}
                           DataModule2.Table5Hjahr.AsString);  {420 Jahr}
            DataModule2.Table32Ho.AsString :=
              DataModule2.Table5Hort.AsString;                 //005A6D5D..6D80 [2D8]
            DataModule2.Table32Htz.AsString :=
              DataModule2.Table5Trauz.AsString;                //005A6D86..6DA9 [310]
            DataModule2.Table32Hq.AsString :=
              DataModule2.Table5Hqu.AsString;                  //005A6DAF..6DD2 [2F8]
            DataModule2.Table32S.AsString :=                   //005A6DD8..6E43 [2DC]
              sub_00582C24(DataModule2.Table5Satag.AsString,   {42C Tag}
                           DataModule2.Table5Samonat.AsString, {430 Monat}
                           DataModule2.Table5Sajahr.AsString); {434 Jahr}
            DataModule2.Table32So.AsString :=
              DataModule2.Table5Saort.AsString;                //005A6E49..6E6C [2E0]
            DataModule2.Table32Stz.AsString :=
              DataModule2.Table5Satrauz.AsString;              //005A6E72..6E95 [314]
            DataModule2.Table32Sq.AsString :=
              DataModule2.Table5Saqu.AsString;                 //005A6E9B..6EBE [2FC]
            DataModule2.Table32Sch.AsString :=                 //005A6EC4..6F2F [2E4]
              sub_00582C24(DataModule2.Table5Schtag.AsString,  {444 Tag}
                           DataModule2.Table5Schmonat.AsString,{448 Monat}
                           DataModule2.Table5Schjahr.AsString);{44C Jahr}
            DataModule2.Table32Scho.AsString :=
              DataModule2.Table5Schort.AsString;               //005A6F35..6F58 [2E8]
            DataModule2.Table32Schq.AsString :=
              DataModule2.Table5Schqu.AsString;                //005A6F5E..6F81 [300]
            DataModule2.Table32Vb.AsString :=                  //005A6F87..6FD7 [2EC]
              UpperCase(Copy(DataModule2.Table5Verbind.AsString, 1, 1));
            DataModule2.Table32Fn.AsString := IntToStr(cnt);   //005A6FDD..6FFB [2D0]
            DataModule2.Table32Indj.AsString :=
              DataModule2.Table5Indj.AsString;                 //005A7001..7024 [2F0]
            DataModule2.Table32Indm.AsString :=
              DataModule2.Table5Indm.AsString;                 //005A702A..704D [2F4]
            fk := '';                                          //005A7053..7056
            DataModule2.Table17.IndexName := 'mut';            //005A705B..7068
            DataModule2.Table17.First;                         //005A706D..7075
            if DataModule2.Table17.FindKey([DataModule2.Table1Nummer.AsInteger]) then //005A707A..70A2 je->005A713F
              while DataModule2.Table17Mutter.AsInteger = DataModule2.Table1Nummer.AsInteger do //005A70A8 jmp / cond 005A711B..7139
              begin
                if DataModule2.Table17Vater.AsInteger = DataModule2.Table5Epnum.AsInteger then //005A70AA..70C8 jne->005A70FD
                begin
                  sub_00576EB0(DataModule2.Table17Nummer.AsInteger, n6); //005A70CA..70E0 [ebp-154]
                  fk := fk + n6 + '*';                         //005A70E5..70F8 CatN3
                end;
                DataModule2.Table17.Next;                      //005A70FD..7105
                if DataModule2.Table17.Eof then Break;         //005A710A..7119 jne->005A713F
              end;
            if Trim(fk) <> '' then                             //005A713F..7154 jbe->005A7169
              DataModule2.Table32Fk.AsString := fk;            //005A7156..7163 (ungetrimmt)
            DataModule2.Table32.Post;                          //005A7169..7173 vtbl+248
          end;
        end;
        DataModule2.Table5.Next;                               //005A7179..7181
        if DataModule2.Table5.Eof then Break;                  //005A7186..7195 jne->005A71AC
      end;
    end;
    uk := '';                                                  //005A71AC..71AF
    {--- 005A71B4 M-Post-Loop (sequenziell, kein else) ---}
    if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then //005A71B4..71E8 jne->005A73AF
    begin
      DataModule2.Table17.IndexName := 'vat';                  //005A71EE..71FB
      DataModule2.Table17.First;                               //005A7200..7208
      if DataModule2.Table17.FindKey([DataModule2.Table1Nummer.AsInteger]) then //005A720D..7235 je->005A72C3
        while DataModule2.Table17Vater.AsInteger = DataModule2.Table1Nummer.AsInteger do //005A723B jmp / cond 005A729F..72BD
        begin
          if DataModule2.Table17Mutter.AsInteger = 0 then      //005A723D..724C jne->005A7281
          begin
            sub_00576EB0(DataModule2.Table17Nummer.AsInteger, n6); //005A724E..7264 [ebp-164]
            uk := uk + n6 + '*';                               //005A7269..727C CatN3
          end;
          DataModule2.Table17.Next;                            //005A7281..7289
          if DataModule2.Table17.Eof then Break;               //005A728E..729D jne->005A72C3
        end;
      if Trim(uk) <> '' then                                   //005A72C3..72D8 jbe->005A73AF
      begin
        Inc(cnt);                                              //005A72DE
        DataModule2.Table32.Append;                            //005A72E1..72E9
        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6);  //005A72EE..7306 [ebp-16C]
        DataModule2.Table32Fv.AsString := n6;                  //005A730C..7316 [2C4]
        sub_00576EB0(0, n6);                                   //005A731C..7329 [ebp-170] xor eax,eax
        DataModule2.Table32Fm.AsString := n6;                  //005A732F..7339 [2C8]
        DataModule2.Table32Fk.AsString := uk;                  //005A733F..734C [2CC]
        DataModule2.Table32Fn.AsString := IntToStr(cnt);       //005A7352..7370 [2D0]
        DataModule2.Table32Indj.AsString :=
          DataModule2.Table5Indj.AsString;                     //005A7376..7399 [2F0]
        DataModule2.Table32.Post;                              //005A739F..73A9 vtbl+248
      end;
    end;
    {--- 005A73AF W-Post-Loop (sequenziell, kein else) ---}
    if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then //005A73AF..73E3 jne->005A75AA
    begin
      DataModule2.Table17.IndexName := 'mut';                  //005A73E9..73F6
      DataModule2.Table17.First;                               //005A73FB..7403
      if DataModule2.Table17.FindKey([DataModule2.Table1Nummer.AsInteger]) then //005A7408..7430 je->005A74BE
        while DataModule2.Table17Mutter.AsInteger = DataModule2.Table1Nummer.AsInteger do //005A7436 jmp / cond 005A749A..74B8
        begin
          if DataModule2.Table17Vater.AsInteger = 0 then       //005A7438..7447 jne->005A747C
          begin
            sub_00576EB0(DataModule2.Table17Nummer.AsInteger, n6); //005A7449..745F [ebp-184]
            uk := uk + n6 + '*';                               //005A7464..7477 CatN3
          end;
          DataModule2.Table17.Next;                            //005A747C..7484
          if DataModule2.Table17.Eof then Break;               //005A7489..7498 jne->005A74BE
        end;
      if Trim(uk) <> '' then                                   //005A74BE..74D3 jbe->005A75AA
      begin
        Inc(cnt);                                              //005A74D9
        DataModule2.Table32.Append;                            //005A74DC..74E4
        sub_00576EB0(0, n6);                                   //005A74E9..74F6 [ebp-18C]
        DataModule2.Table32Fv.AsString := n6;                  //005A74FC..7506 [2C4]
        sub_00576EB0(DataModule2.Table1Nummer.AsInteger, n6);  //005A750C..7524 [ebp-190]
        DataModule2.Table32Fm.AsString := n6;                  //005A752A..7534 [2C8]
        DataModule2.Table32Fk.AsString := uk;                  //005A753A..7547 [2CC]
        DataModule2.Table32Fn.AsString := IntToStr(cnt);       //005A754D..756B [2D0]
        DataModule2.Table32Indj.AsString :=
          DataModule2.Table5Indj.AsString;                     //005A7571..7594 [2F0]
        DataModule2.Table32.Post;                              //005A759A..75A4 vtbl+248
      end;
    end;
    DataModule2.Table1.Next;                                   //005A75AA..75AF
    if DataModule2.Table1.Eof then Break;                      //005A75B4..75C0 jne->005A75D4
  end;
  gvar_02536660 := '';                                         //005A75D4..75D9
  if DataModule2.Table31.RecordCount > 0 then                  //005A75DE..75F0 jle->005A7B58
  begin
    while not DataModule2.Table31.Eof do                       //005A75F6 jmp / cond 005A7B43..7B52
    begin
      upd := 0;                                                //005A75FB..75FD [ebp-18]
      if DataModule2.Table31Av.AsInteger > 0 then              //005A7600..760F jle->005A77E4
      begin
        vnr := DataModule2.Table31Av.AsInteger;                //005A7615..7622 [esi]
        mnr := DataModule2.Table31Am.AsInteger;                //005A7624..7631 [edi]
        DataModule2.Table32.IndexName := 'v';                  //005A7633..7640
        sub_00576EB0(vnr, n6);                                 //005A7645..765B [ebp-19C]
        if DataModule2.Table32.FindKey([n6]) then              //005A765F..7673 je->005A79BC
          while StrToInt(DataModule2.Table32Fv.AsString) = vnr do //005A7679 jmp / cond 005A77B9..77DF
          begin
            if StrToInt(DataModule2.Table32Fm.AsString) = mnr then //005A767E..769E jne->005A7797
            begin
              DataModule2.Table32.Edit;                        //005A76A4..76AC
              sub_00576EB0(DataModule2.Table31Nummer.AsInteger, n6); //005A76CC..76E4 [ebp-1AC]
              DataModule2.Table32Fk.AsString :=                //005A76B1..7709 CatN3
                DataModule2.Table32Fk.AsString + n6 + '*';
              DataModule2.Table32.Post;                        //005A770F..7719 vtbl+248
              sub_00576EB0(DataModule2.Table31Nummer.AsInteger, n6); //005A7725..773D [ebp-1B0]
              sub_00576EB0(StrToInt(DataModule2.Table32Fn.AsString), fn6); //005A7748..7771 [ebp-1B4]
              gvar_02536660 := gvar_02536660 + n6 + '*' + fn6 + '#'; //005A771F..7786 CatN5
              upd := 1;                                        //005A778B [ebp-18]
              Break;                                           //005A7792 jmp->005A79BC
            end;
            DataModule2.Table32.Next;                          //005A7797..779F
            if DataModule2.Table32.Eof then Break;             //005A77A4..77B3 jne->005A79BC
          end;
      end
      else if DataModule2.Table31Am.AsInteger > 0 then         //005A77E4..77F3 jle->005A79BC
      begin
        vnr := DataModule2.Table31Av.AsInteger;                //005A77F9..7806 [esi]
        mnr := DataModule2.Table31Am.AsInteger;                //005A7808..7815 [edi]
        DataModule2.Table32.IndexName := 'm';                  //005A7817..7824
        sub_00576EB0(mnr, n6);                                 //005A7829..783F [ebp-1C0]
        if DataModule2.Table32.FindKey([n6]) then              //005A7843..7857 je->005A79BC
          while StrToInt(DataModule2.Table32Fm.AsString) = mnr do //005A785D jmp / cond 005A7996..79B6
          begin
            if StrToInt(DataModule2.Table32Fv.AsString) = vnr then //005A7862..7882 jne->005A7978
            begin
              DataModule2.Table32.Edit;                        //005A7888..7890
              sub_00576EB0(DataModule2.Table31Nummer.AsInteger, n6); //005A78BD..78C8 [ebp-1D0]
              DataModule2.Table32Fk.AsString :=                //005A7895..78ED CatN3
                DataModule2.Table32Fk.AsString + n6 + '*';
              DataModule2.Table32.Post;                        //005A78F3..78FD vtbl+248
              sub_00576EB0(DataModule2.Table31Nummer.AsInteger, n6); //005A7909..7921 [ebp-1D4]
              sub_00576EB0(StrToInt(DataModule2.Table32Fn.AsString), fn6); //005A792C..7955 [ebp-1D8]
              gvar_02536660 := gvar_02536660 + n6 + '*' + fn6 + '#'; //005A7903..796A CatN5
              upd := 1;                                        //005A796F [ebp-18]
              Break;                                           //005A7976 jmp->005A79BC
            end;
            DataModule2.Table32.Next;                          //005A7978..7980
            if DataModule2.Table32.Eof then Break;             //005A7985..7994 jne->005A79BC
          end;
      end;
      if upd = 0 then                                          //005A79BC..79C0 jne->005A7B25
      begin
        Inc(cnt);                                              //005A79C6
        DataModule2.Table32.Append;                            //005A79C9..79D1
        sub_00576EB0(DataModule2.Table31Av.AsInteger, n6);     //005A79D6..79EE [ebp-1E4]
        DataModule2.Table32Fv.AsString := n6;                  //005A79F4..79FE [2C4]
        sub_00576EB0(DataModule2.Table31Am.AsInteger, n6);     //005A7A04..7A1C [ebp-1E8]
        DataModule2.Table32Fm.AsString := n6;                  //005A7A22..7A2C [2C8]
        sub_00576EB0(DataModule2.Table31Nummer.AsInteger, n6); //005A7A32..7A4A [ebp-1EC]
        DataModule2.Table32Fk.AsString := n6 + '*';            //005A7A4A..7A6A LStrCat+Set [2CC]
        DataModule2.Table32Fn.AsString := IntToStr(cnt);       //005A7A70..7A8E [2D0]
        DataModule2.Table32Vb.AsString := 'A';                 //005A7A94..7AA3 [2EC]
        DataModule2.Table32.Post;                              //005A7AA9..7AB3 vtbl+248
        sub_00576EB0(DataModule2.Table31Nummer.AsInteger, n6); //005A7ABF..7AD7 [ebp-1F4]
        sub_00576EB0(StrToInt(DataModule2.Table32Fn.AsString), fn6); //005A7AE2..7B0B [ebp-1F8]
        gvar_02536660 := gvar_02536660 + n6 + '*' + fn6 + '#'; //005A7AB9..7B20 CatN5
      end;
      DataModule2.Table31.Next;                                //005A7B25..7B2D
      if DataModule2.Table31.Eof then Break;                   //005A7B32..7B41 jne->005A7B58
    end;
  end;
  { Epilogue: SEH-Rahmen abbauen und String-Temps freigeben - compiler
    generated, nicht transkribiert:
      @LStrArrayClr 0x64 ab [ebp-1FC], 0xF ab [ebp-6C], 2 ab [ebp-28],
      @LStrClr [ebp-1C], 3 ab [ebp-0C], @HandleFinally }        //005A7B58..7BAA
end;

procedure TForm3.gedein;
var
  indnr: Integer;     {0059D342 [ebp-18] naechste INDI-Nummer (Start gvar_02536940)}
  indz: Integer;      {0059D347 [ebp-3C] INDI-Zaehler (Fortschritt, Auswertung 0059EE80)}
  famz: Integer;      {0059D583 [ebp-30] Zaehler der '0 @F'-Zeilen}
  nds: Integer;       {0059D244 [ebp-44] laufende Nr. der Table26-Zeile (REPO/NOTE/SOUR)}
  adrz: Integer;      {0059F089 [ebp-1C] ADR-Zaehler (ADR1..ADR5)}
  mansnr: Integer;    {005A41FC [ebp-20] HUSB-Nummer (Bogen2 Table5 Nummer; Table31 Av; huslist)}
  wifesnr: Integer;   {005A41F7 [ebp-24] WIFE-Nummer (Bogen2 Table5 Epnum; Table31 Am; wifelist)}
  kid: Integer;       {005A4229 [ebp-40] Kind-Zaehler (Start 14)}
  husbfound: Integer; {005A422E [ebp-38] 1 = HUSB in Kinderliste gefunden}
  utfflag: Integer;   {0059D371 [ebp-2C] '1 CHAR UTF' -> Zeilen werden Utf8ToAnsi}
  extloc: Integer;    {0059D35E [ebp-34] '3 _EXTENDED_LOCATIONS' gesetzt}
  rdflag: Integer;    {0059D503 [ebp-28] 1 nach jedem ReadLn, 0 vor dem naechsten Abschnitt}
  ctx: AnsiString;    {0059DDDF [ebp-0C0] aktueller Abschnitt ('sour','even','adr',...)}
  hdr: AnsiString;    {0059D8B3 [ebp-0B8] getrimmter Zeilenrest (Kopf-/ID-Daten)}
  fname: AnsiString;  {0059D379 [ebp-0B4] Dateiname aus OpenDialog1}
  klist: AnsiString;  {005A032D [ebp-0BC] '*'-getrennte Nummerenliste}
  huslist: AnsiString;{005A4581 [ebp-0C4] '*'-Liste der HUSB-Kindnummern}
  wifelist: AnsiString;{005A473A [ebp-0C8] '*'-Liste der WIFE-Kindnummern}
  anst: AnsiString;      { shared temp der ans()/Utf8ToAnsi-Ausgabe (z.B. F266/F374) }
  reliTag: AnsiString;    {005A09B6 [ebp-5C] FAM-RELI-Snapshot (gvar_02536624/628/62C)}
  reliMonat: AnsiString;  {005A09C4 [ebp-60] dto.}
  reliJahr: AnsiString;   {005A09D2 [ebp-64] dto.}
  civiTag: AnsiString;    {005A0A30 [ebp-9C] FAM-CIVI-Snapshot; '@CHR'-Block: 'Sdat.:'->1 Buchstabe}
  civiMonat: AnsiString;  {005A0A41 [ebp-0A0] 'Sdat.:'->2 Buchstaben}
  civiJahr: AnsiString;   {005A0A52 [ebp-0A4] 'Sdat.:'->3 Buchstaben}
  divTag: AnsiString;     {005A0AB3 [ebp-88] FAM-DIV-Snapshot}
  divMonat: AnsiString;   {005A0AC4 [ebp-8C] dto.}
  divJahr: AnsiString;    {005A0AD5 [ebp-90] dto.}
  refn: AnsiString;       {005A00A4 [ebp-420] REFN-Trim-Temp (Laenge-Test 0A)}
  husnrTxt: AnsiString;   {005A4428 [ebp-50] HUSB-Nummerntext ('0 @F'-Zeile)}
  wifnrTxt: AnsiString;   {005A45E1 [ebp-54] WIFE-Nummerntext}
  chnrTxt: AnsiString;    {005A47D8 [ebp-58] CHIL-Nummerntext}
  hort: AnsiString;       {005A10D6 [ebp-68] FAM-RELI-Ort (Table5 424)}
  hqu: AnsiString;        {005A1CF4 [ebp-6C] 'Hque.:'-Text (Table5 454)}
  trauzTxt: AnsiString;   {005A1C43 [ebp-70] 'Trauz'-Text (Table5 428)}
  famkom: AnsiString;     {005A42D5 [ebp-74] FAM-Kommentar (nur gelesen, Initial '')
    - Initialisierung im @FAM-Block; Wert nie beschrieben, bleibt immer leer }
  verbind: AnsiString;    {005A4231 [ebp-84] 'Verbindung' (Table5 440)}
  schort: AnsiString;     {005A1273 [ebp-94] FAM-DIV-Ort (Table5 450)}
  schqu: AnsiString;      {005A1F4A [ebp-98] 'Schq.:'-Text (Table5 45C)}
  saort: AnsiString;      {005A1E21 [ebp-0A8] 'Sort.:'-Text (Table5 438)}
  satrauz: AnsiString;    {005A1E84 [ebp-0AC] 'Strz.:'-Text (Table5 43C)}
  saqu: AnsiString;       {005A1EE7 [ebp-0B0] 'Saqu.:'-Text (Table5 458)}
  addrTst: AnsiString;    {005A32F8 [ebp-7C8] ADDR-String-Test (01 relativiert auf adrz)}
begin
  { 0059D218: gedein - GEDCOM-Import:
    liest die vom OpenDialog1 gewaehlte Datei zeilenweise ein und baut
    Table25 (INDI-Nummern), Table26 (REPO/NOTE/SOUR-Sammeltabelle),
    Table29 (SOUR-Quellen, Quelle-Feld 0x378) und Table1 (Personen) auf;
    die Kennungen '1 CHAR IBM/UTF/UNIC' bzw. '3 _EXTENDED_LOCATIONS'
    steuern Utf8ToAnsi bzw. die Extended-Location-Auswertung, der
    Abschnitts-Kontext ctx entscheidet, wohin eine '1 ...'-Zeile geschrieben
    wird. Danach folgt ein zweiter Lauf (Fortschritt Label18) und die
    FAM-Auswertung (HUSB/WIFE/CHIL, Ehetabellen-Append).
    Die Hilfsaufrufe sub_00576EB0 stehen vor der jeweiligen Aussage -
    die Auswerte-Reihenfolge innerhalb der CatN-Ausdruecke weicht dadurch
    geringfuegig ab (siehe Recon-Notizen).
    SEH-Rahmen/Prolog-Teardown (@LStrArrayClr/@LStrClr) - nicht transkribiert. }

  gvar_0253663C := 0;                                       //0059D23D
  nds := 0;                                                 //0059D244 [ebp-44]
  gvar_0253666C := 0;                                       //0059D249 Single
  gvar_02536668 := 0;                                       //0059D24E Single
  DataModule2.Table25.Open;                                 //0059D255 [1DC]
  DataModule2.Table25.Close;                                //0059D267
  DataModule2.Table25.EmptyTable;                           //0059D279
  DataModule2.Table25.Open;                                 //0059D28B
  DataModule2.Table25.IndexName := 'AA';                    //0059D29D
  DataModule2.Table26.Open;                                 //0059D2B4 [1E0]
  DataModule2.Table26.Close;                                //0059D2C6
  DataModule2.Table26.EmptyTable;                           //0059D2D8
  DataModule2.Table26.Open;                                 //0059D2EA
  DataModule2.Table26.IndexName := 'nro';                   //0059D2FC
  DataModule2.Table29.Open;                                 //0059D313 [248]
  DataModule2.Table1.Open;                                  //0059D325 [5C]
  //0059D334 [ebp-14] := 1 - toter Zaehler (einziges Vorkommen)
  indnr := gvar_02536940;                                   //0059D33B..D342 [ebp-18]
  indz := 0;                                                //0059D347 [ebp-3C]
  gvar_02536644 := 0;                                       //0059D34C Single
  gvar_0061F048 := 1;                                       //0059D351..D356
  extloc := 0;                                              //0059D35E [ebp-34]
  gvar_02536648 := 0;                                       //0059D363
  gvar_0253664C := 0;                                       //0059D36A
  utfflag := 0;                                             //0059D371 [ebp-2C]
  //0059D376 [ebp-10] := 0 - toter Zaehler (einziges Vorkommen)
  fname := Form1.OpenDialog1.FileName;                        //0059D379..D38C [ebp-0B4]
  System.Assign(gvar_02536458, fname);                         //0059D391..D39C @Assign
  Reset(gvar_02536458);                                     //0059D3A1..D3A6 @ResetText
  ReadLn(gvar_02536458, gvar_02536630);                     //0059D3AB..D3BF
  ReadLn(gvar_02536458, gvar_02536630);                     //0059D3C4..D3D8
  if IOResult <> 0 then                                     //0059D3DD..D3E4 je->0059D4C1
  begin
    ShowMessage('Fehler beim Einlesen.');                   //0059D3EA
    Exit;                                                   //0059D3F4 jmp->005A57D5 (Epilog)
  end;
  { Kopf-Abschnitt: Kennzeilen bis zur ersten '0'-Zeile auswerten }
  while Copy(gvar_02536630, 1, 1) <> '0' do                 //0059D4C1 / Ruecklauf 0059D3F9
  begin
    if Pos('1 CHAR ', gvar_02536630) > 0 then               //0059D3F9..D40B jle->0059D488
    begin
      if Pos('1 CHAR IBM', UpperCase(gvar_02536630)) > 0 then //0059D40D..D42F
        gvar_02536648 := 1;                                 //0059D431
      if Pos('1 CHAR UTF', UpperCase(gvar_02536630)) > 0 then //0059D43B..D45D
        utfflag := 1;                                       //0059D45F [ebp-2C]
      //0059D466..D486 Pos('1 CHAR UNIC', UpperCase(line)) - ohne Auswertung
    end;
    if Pos('3 _EXTENDED_LOCATIONS', gvar_02536630) > 0 then //0059D488..D49A
      extloc := 1;                                          //0059D49C [ebp-34]
    ReadLn(gvar_02536458, gvar_02536630);                   //0059D4A3
  end;
  Reset(gvar_02536458);                                     //0059D4F2 ResetText + @_IOTest (zurueck zum Anfang)
  rdflag := 0;                                              //0059D503 [ebp-28]
  ReadLn(gvar_02536458, gvar_02536630);                     //0059D506
  gvar_02536630 := Trim(gvar_02536630);                     //0059D524..D534 [ebp-0E0]
  Form1.Label19.Visible := True;                            //0059D544 [404]
  Form1.Label19.Caption := 'Gedcom prüfen ... ';            //0059D558..D565
  Form1.Label19.Refresh;                                    //0059D56F
  famz := 0;                                                //0059D583 [ebp-30]
  { Aelterer Haupt-Lauf: Zeilen bis '0 TRLR' auswerten }
  while Copy(ucase(Trim(gvar_02536630)), 1, 6) <> '0 TRLR' do   //0059EE26..EE7A jne->0059D58B
  begin
    if (Copy(gvar_02536630, 1, 1) = '0') and                     //0059D58B..D5B6 jne->0059D862
       (Pos('@ INDI', gvar_02536630) > 0) then                   //0059D5BC..D5CE jle->0059D862
    begin
      Inc(indnr);                                                //0059D5D4 [ebp-18]
      Inc(indz);                                                 //0059D5D7 [ebp-3C]
      if ucase(Copy(gvar_02536630, 4, 1)) = 'I' then            //0059D5DA..D61D jne->0059D665
        gvar_02536630 := Copy(gvar_02536630,                     //0059D61F..D663
          Pos('@', gvar_02536630) + 2,
          Length(gvar_02536630) - Pos('@', gvar_02536630))
      else
        gvar_02536630 := Copy(gvar_02536630,                     //0059D665..D6A7
          Pos('@', gvar_02536630) + 1,
          Length(gvar_02536630) - Pos('@', gvar_02536630));
      DataModule2.Table25.Append;                                //0059D6A7 [1DC]
      DataModule2.Table25A.AsInteger :=                          //0059D6B9..D6ED
        StrToInt(Copy(gvar_02536630, 1, Pos('@', gvar_02536630) - 1));
      DataModule2.Table25N.AsInteger := indnr;                   //0059D704 [308]
      DataModule2.Table25.Post;                                  //0059D71C
      DataModule2.Table1.Append;                                 //0059D731 [5C]
      DataModule2.Table1Nummer.AsInteger := indnr;               //0059D740 [534]
      DataModule2.Table1Vornamen.AsString := 'NN';               //0059D758 [544]
      DataModule2.Table1Quelle.AsString := '';                   //0059D772 [5FC]
      DataModule2.Table1Quelleg.AsString := '';                  //0059D789 [5A0]
      DataModule2.Table1Quellet.AsString := '';                  //0059D7A0 [5A4]
      DataModule2.Table1Quelles.AsString := '';                  //0059D7B7 [5A8]
      DataModule2.Table1Quelleb.AsString := '';                  //0059D7CE [5AC]
      DataModule2.Table1Lebt.AsString := 'n';                    //0059D7E5 [5B4]
      try
        DataModule2.Table1.Post;                                 //0059D80D (SEH-Rahmen 0059D829)
      except
        ShowMessage('Fehler: ' + IntToStr(indnr));               //0059D82E..D852
      end;                                                       //0059D827 jmp->0059D862 / @DoneExcept
    end;
    if Pos('0 @F', gvar_02536630) > 0 then                      //0059D862..D874 jle->0059D879
      Inc(famz);                                                 //0059D876 [ebp-30]
    if Pos('0 @REPO', gvar_02536630) > 0 then                   //0059D879..D88B jle->0059DAB5
    begin
      hdr := Trim(Copy(gvar_02536630, 9,                        //0059D891..D8B3 [ebp-0B8]
                       Length(gvar_02536630)));
      DataModule2.Table26.Append;                                //0059D8C4 [1E0]
      Inc(nds);                                                  //0059D8D6 [ebp-44]
      DataModule2.Table26Nr.AsInteger := nds;                    //0059D8D9 [32C]
      DataModule2.Table26Alt.AsString :=                         //0059D8F1..D91A [338]
        Copy(hdr, 1, Pos('@', hdr));
      ReadLn(gvar_02536458, gvar_02536630);                     //0059D935
      if utfflag = 1 then                                        //0059D953..D957 jne->0059D968
        gvar_02536630 := Utf8ToAnsi(gvar_02536630);              //0059D959
      rdflag := 1;                                               //0059D968 [ebp-28]
      gvar_02536630 := Trim(gvar_02536630);                      //0059D96F..D97F
      while Copy(gvar_02536630, 1, 1) <> '0' do                 //0059DA6F / Ruecklauf 0059D994
      begin
        DataModule2.Table26Inh.AsString :=                       //0059D994..DA00 CatN4
          DataModule2.Table26Inh.AsString + #13#10 +
          Trim(Copy(gvar_02536630, 8, 100));
        ReadLn(gvar_02536458, gvar_02536630);                   //0059DA15
        if utfflag = 1 then                                      //0059DA33..DA37 jne->0059DA48
          gvar_02536630 := Utf8ToAnsi(gvar_02536630);            //0059DA39
        rdflag := 1;                                             //0059DA48 [ebp-28]
        gvar_02536630 := Trim(gvar_02536630);                    //0059DA4F..DA5F
      end;
      DataModule2.Table26.Post;                                  //0059DAA0
    end;
    if Pos('@ NOTE', gvar_02536630) > 0 then                    //0059DAB5..DAC7 jle->0059DDAF
    begin
      hdr := Trim(Copy(gvar_02536630, 4,                        //0059DACD..DAEF [ebp-0B8]
                       Length(gvar_02536630)));
      DataModule2.Table26.Append;                                //0059DB00
      Inc(nds);                                                  //0059DB12 [ebp-44]
      DataModule2.Table26Nr.AsInteger := nds;                    //0059DB15 [32C]
      DataModule2.Table26Alt.AsString :=                         //0059DB2D..DB57 [338]
        Copy(hdr, 1, Pos('@', hdr) - 1);
      DataModule2.Table26Inh.AsString :=                         //0059DB72..DBB7 [330]
        Trim(Copy(hdr, Pos('@', hdr) + 6, Length(hdr)));
      DataModule2.Table26Inh2.AsString :=                        //0059DBD2..DC17 [334]
        Trim(Copy(hdr, Pos('@', hdr) + 6, Length(hdr)));
      ReadLn(gvar_02536458, gvar_02536630);                     //0059DC32
      if utfflag = 1 then                                        //0059DC50..DC54 jne->0059DC65
        gvar_02536630 := Utf8ToAnsi(gvar_02536630);              //0059DC56
      rdflag := 1;                                               //0059DC65 [ebp-28]
      while Copy(gvar_02536630, 1, 1) <> '0' do                 //0059DD0F / Ruecklauf 0059DC71
      begin
        DataModule2.Table26Inh2.AsString :=                      //0059DC71..DCC0 Cat
          DataModule2.Table26Inh2.AsString +
          Copy(gvar_02536630, 7, Length(gvar_02536630));
        ReadLn(gvar_02536458, gvar_02536630);                   //0059DCD5
        if utfflag = 1 then                                      //0059DCF3..DCF7 jne->0059DD08
          gvar_02536630 := Utf8ToAnsi(gvar_02536630);            //0059DCF9
        rdflag := 1;                                             //0059DD08 [ebp-28]
      end;
      DataModule2.Table26.Post;                                  //0059DD40
    end;
    if Copy(ucase(Trim(gvar_02536630)), 1, 6) = '0 TRLR' then    //0059DD55..DDA9 je->0059EE80
      Break;                                                     // (Verlassen des Laufs)
    { SOUR-Cluster: Quellen-Texte in Table29.Quelle anhaengen }
    if Pos('1 TEXT', gvar_02536630) > 0 then                    //0059DF1F..DF31 jle->0059E07C
      if ctx = 'sour' then                                       //0059DF37..DF47 jne->0059E07C
      begin
        DataModule2.Table29.Edit;                                //0059DF4D [248]
        if Trim(DataModule2.Table29Quelle.AsString) = '' then    //0059DF5F..DF8F
          DataModule2.Table29Quelle.AsString :=                  //0059DF91..DFC4 [378]
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)))
        else
          DataModule2.Table29Quelle.AsString :=                  //0059DFE4..E052 CatN3
            DataModule2.Table29Quelle.AsString + '; ' +
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)));
        DataModule2.Table29.Post;                                //0059E067
      end;
    if Pos('1 AUTH', gvar_02536630) > 0 then                    //0059E07C..E08E jle->0059E1D9
      if ctx = 'sour' then                                       //0059E094..E0A4 jne->0059E1D9
      begin
        DataModule2.Table29.Edit;                                //0059E0AA
        if Trim(DataModule2.Table29Quelle.AsString) = '' then    //0059E0BC..E0EC
          DataModule2.Table29Quelle.AsString :=                  //0059E0EE..E121
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)))
        else
          DataModule2.Table29Quelle.AsString :=                  //0059E141..E1AF CatN3
            DataModule2.Table29Quelle.AsString + ' ' +
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)));
        DataModule2.Table29.Post;                                //0059E1C4
      end;
    if Copy(Trim(ucase(gvar_02536630)), 1, 6) = '1 DATE' then   //0059E1D9..E22E jne->0059E379
      if ctx = 'sour' then                                       //0059E234..E244 jne->0059E379
      begin
        DataModule2.Table29.Edit;                                //0059E24A
        if Trim(DataModule2.Table29Quelle.AsString) = '' then    //0059E25C..E28C
          DataModule2.Table29Quelle.AsString :=                  //0059E28E..E2C1
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)))
        else
          DataModule2.Table29Quelle.AsString :=                  //0059E2E1..E34F CatN3
            DataModule2.Table29Quelle.AsString + ' ' +
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)));
        DataModule2.Table29.Post;                                //0059E364
      end;
    if Copy(Trim(ucase(gvar_02536630)), 1, 6) = '1 PLAC' then   //0059E379..E3CE jne->0059E519
      if ctx = 'sour' then                                       //0059E3D4..E3E4 jne->0059E519
      begin
        DataModule2.Table29.Edit;                                //0059E3EA
        if Trim(DataModule2.Table29Quelle.AsString) = '' then    //0059E3FC..E42C
          DataModule2.Table29Quelle.AsString :=                  //0059E42E..E461
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)))
        else
          DataModule2.Table29Quelle.AsString :=                  //0059E481..E4EF CatN3
            DataModule2.Table29Quelle.AsString + ' ' +
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)));
        DataModule2.Table29.Post;                                //0059E504
      end;
    if Pos('1 URL', gvar_02536630) > 0 then                     //0059E519..E52B jle->0059E67A
      if ctx = 'sour' then                                       //0059E531..E541 jne->0059E67A
      begin
        DataModule2.Table29.Edit;                                //0059E547
        if Trim(DataModule2.Table29Quelle.AsString) = '' then    //0059E559..E589
          DataModule2.Table29Quelle.AsString :=                  //0059E58B..E5BE
            Trim(Copy(gvar_02536630, 7, Length(gvar_02536630)))
        else
          DataModule2.Table29Quelle.AsString :=                  //0059E5DE..E64A CatN3
            DataModule2.Table29Quelle.AsString + ' ' +
            Trim(Copy(gvar_02536630, 7, Length(gvar_02536630)));
        DataModule2.Table29.Post;                                //0059E665
      end;
    if Copy(Trim(ucase(gvar_02536630)), 1, 6) = '1 TYPE' then   //0059E67A..E6CF jne->0059E770
      if ctx = 'sour' then                                       //0059E6D5..E6E5 jne->0059E770
      begin
        DataModule2.Table29.Edit;                                //0059E6EB
        DataModule2.Table29Quelle.AsString :=                    //0059E6FD..E75B Cat
          Trim(Copy(gvar_02536630, 8, Length(gvar_02536630))) + ' ';
        DataModule2.Table29.Post;                                //0059E75B
      end;
    if Pos('1 TITL', gvar_02536630) > 0 then                    //0059E770..E782 jle->0059E8D1
      if ctx = 'sour' then                                       //0059E788..E798 jne->0059E8D1
      begin
        DataModule2.Table29.Edit;                                //0059E79E
        if Trim(DataModule2.Table29Quelle.AsString) = '' then    //0059E7B0..E7E0
          DataModule2.Table29Quelle.AsString :=                  //0059E7E2..E815
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)))
        else
          DataModule2.Table29Quelle.AsString :=                  //0059E835..E8A1 CatN3
            DataModule2.Table29Quelle.AsString + ': ' +
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)));
        DataModule2.Table29.Post;                                //0059E8BC
      end;
    if Pos('1 PUBL', gvar_02536630) > 0 then                    //0059E8D1..E8E3 jle->0059EA32
      if ctx = 'sour' then                                       //0059E8E9..E8F9 jne->0059EA32
      begin
        DataModule2.Table29.Edit;                                //0059E8FF
        if Trim(DataModule2.Table29Quelle.AsString) = '' then    //0059E911..E941
          DataModule2.Table29Quelle.AsString :=                  //0059E943..E976
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)))
        else
          DataModule2.Table29Quelle.AsString :=                  //0059E996..EA02 CatN3
            DataModule2.Table29Quelle.AsString + ' ' +
            Trim(Copy(gvar_02536630, 8, Length(gvar_02536630)));
        DataModule2.Table29.Post;                                //0059EA1D
      end;
    { Extended Locations: Ort-Datensatz in Table13 }
    if (Pos('@ _LOC', gvar_02536630) > 0) and (extloc = 1) then //0059EA32..EA4E jle/jne->0059EDC2
    begin
      ctx := '_loc';                                             //0059EA54 [ebp-0C0]
      ReadLn(gvar_02536458, gvar_02536630);                     //0059EA64
      if utfflag = 1 then                                        //0059EA82..EA86 jne->0059EA97
        gvar_02536630 := Utf8ToAnsi(gvar_02536630);              //0059EA88
      rdflag := 1;                                               //0059EA97 [ebp-28]
      hdr := Trim(Copy(gvar_02536630, 8,                        //0059EA9E..EAC0 [ebp-0B8]
                       Length(gvar_02536630)));
      if DataModule2.Table13.FindKey([hdr]) then                 //0059EAE4 [0CC] je->0059EB16
        DataModule2.Table13.Edit                                 //0059EB02
      else
        DataModule2.Table13.Append;                              //0059EB16
      DataModule2.Table13Ort.AsString := hdr;                    //0059EB28 [0A44]
      while Copy(gvar_02536630, 1, 1) = '1' do                  //0059ED7C..EDA7 je->0059EB48
      begin
        if Pos('1 _FCNTY', gvar_02536630) > 0 then              //0059EB48..EB5A jle->0059EB99
          DataModule2.Table13Lkr.AsString :=                     //0059EB5C..EB7E [0A64]
            Copy(gvar_02536630, 10, Length(gvar_02536630));
        if Pos('1 _FCTRY', gvar_02536630) > 0 then              //0059EB99..EBAB jle->0059EBEA
          DataModule2.Table13Land.AsString :=                    //0059EBAD..EBCF [0A4C]
            Copy(gvar_02536630, 10, Length(gvar_02536630));
        if Pos('1 POST', gvar_02536630) > 0 then                //0059EBEA..EC10 jle->0059EC4F
          DataModule2.Table13PLZ.AsString :=                     //0059EC12..EC34 [0A48]
            Copy(gvar_02536630, 8, Length(gvar_02536630));
        if Pos('1 _ABBR', gvar_02536630) > 0 then               //0059EC4F..EC61 jle->0059ECA0
          DataModule2.Table13Abk.AsString :=                     //0059EC63..EC85 [0A68]
            Copy(gvar_02536630, 9, Length(gvar_02536630));
        if Pos('1 _FSTAE', gvar_02536630) > 0 then              //0059ECA0..ECB2 jle->0059ECF1
          DataModule2.Table13Bland.AsString :=                   //0059ECB4..ECD6 [0A58]
            Copy(gvar_02536630, 10, Length(gvar_02536630));
        if Pos('1 _GOV', gvar_02536630) > 0 then                //0059ECF1..ED03 jle->0059ED42
          DataModule2.Table13Maid.AsString :=                    //0059ED05..ED27 [0A74]
            Copy(gvar_02536630, 17, Length(gvar_02536630));
        ReadLn(gvar_02536458, gvar_02536630);                   //0059ED42
        if utfflag = 1 then                                      //0059ED60..ED64 jne->0059ED75
          gvar_02536630 := Utf8ToAnsi(gvar_02536630);            //0059ED66
        rdflag := 1;                                             //0059ED75 [ebp-28]
      end;
      DataModule2.Table13.Post;                                  //0059EDAD [0CC]
    end;
    if rdflag = 0 then                                           //0059EDC2..EDC6 jne->0059EE1B
    begin
      ReadLn(gvar_02536458, gvar_02536630);                     //0059EDC8
      gvar_02536630 := Trim(gvar_02536630);                      //0059EDE6..EDF6
      if utfflag = 1 then                                        //0059EE06..EE0A jne->0059EE1B
        gvar_02536630 := Utf8ToAnsi(gvar_02536630);              //0059EE0C
    end;
    rdflag := 0;                                                 //0059EE1B..EE1D [ebp-28]
    gvar_02536644 := gvar_02536644 + 1;                              //0059EE20 inc Single
  end;

  { **Zweiter Durchlauf ab dem ersten '0 @I'-Datensatz** (Reset) }
  gvar_0253666C := famz + indz;                                  //0059EE80..EE86 Single
  CloseFile(gvar_02536458);                                    //0059EE8B
  System.Assign(gvar_02536458, fname);                          //0059EE9A [ebp-0B4]
  Reset(gvar_02536458);                                          //0059EEAA
  ReadLn(gvar_02536458, gvar_02536630);                          //0059EEB9
  while (Copy(gvar_02536630, 1, 1) <> '0') and                  //0059EEF7..EF36
        (Pos('@ INDI', gvar_02536630) = 0) do                   //0059EF24..EF36
    ReadLn(gvar_02536458, gvar_02536630);
  Form1.Label18.Visible := True;                                 //0059EF38..EF47 [400]
  Form1.Label18.Caption := '0 %';                                //0059EF51..EF5E '0 %'
  Form1.Label18.Refresh;                                         //0059EF63..EF70
  Form1.Label19.Visible := True;                                 //0059EF75..EF84 [404]
  Form1.Label19.Caption := 'Gedcom einlesen  ';                  //0059EF89..EF9B (2 Leerzeilen)
  Form1.Label19.Refresh;                                         //0059EFA0..EFAD
  rdflag := 0;                                                   //0059EFB2..EFB4 [ebp-28]
  ctx := '';                                                     //0059EFB7..EFBD @LStrClr [ebp-0C0]

  while Copy(ucase(Trim(gvar_02536630)), 1, 6) <> '0 TRLR' do   //005A571D..5771 jne->0059EFC7
  begin
    if (Copy(gvar_02536630, 1, 1) = '0') and                    //0059EFC7..EF36 je->0059F090
       (Pos('@ INDI', gvar_02536630) > 0) then                  //0059EFF8..F00A
    begin                                                         //0059F00D..F01B
      indi;                                                       //0059F010 call [ebp-4]
      gvar_02536668 := gvar_02536668 + 1;                        //0059F018 inc Single
      Form1.Label18.Caption :=                                  //0059F01E..F054 F1[0x400]
        IntToStr(Round(gvar_02536668 / gvar_0253666C * 100)) + ' %';
      Form1.Label18.Refresh;                                     //0059F05A..F06C
      ctx := '';
      adrz := 1;
    end;                                                         //0059F069..F089
    if Pos('1 AFN', gvar_02536630) > 0 then                     //0059F090..F0A2 jle->0059F0F3
    begin                                                         //0059F0A4..F0B1
      DataModule2.Table1.Edit;                                    //0059F0A4 [0x5C]
      DataModule2.Table1IDNR.AsString :=                          //0059F0D8..F0E7 [5C0]
        Copy(gvar_02536630, 8, Length(gvar_02536630) - 7);
    end;
    if Copy(gvar_02536630, 1, 6) = '1 NAME' then                //0059F0F3..F11E jne->0059F408
    begin                                                         //0059F124..F143
      DataModule2.Table1.Edit;                                    //0059F124 [0x5C]
      if Pos('/', gvar_02536630) > 0 then                       //0059F133..F145 jle->0059F34F
      begin
        hdr := Trim(Copy(gvar_02536630, 8, Length(gvar_02536630))); //0059F14B..F17E [ebp-0B8]
        ans(Copy(hdr, 1, Pos('/', hdr) - 1), anst);           //0059F17E..F1B7 [2BC<-2C0]
        DataModule2.Table1Vornamen.AsString := Trim(anst);    //0059F1BC..F1E2 [2B8] ->0x544
        hdr := Trim(Copy(hdr, Pos('/', hdr) + 1, Length(hdr))); //0059F1E8..F237 [ebp-0B8]
        { neg. Laenge: Copy bis Stringende, Name := gesamt Rest }
        ans(Copy(hdr, 1, Pos('/', hdr) - 1), anst);           //0059F23C..F275 [2CC<-2D4]
        DataModule2.Table1Name.AsString := Trim(anst);        //0059F27A..F2A0 [2CC] ->0x540
        if not DataModule2.Table12.FindKey([DataModule2.Table1Name.AsString]) then //0059F2A6..F2ED jne->F3B4
        begin
          DataModule2.Table12.Append;                         //0059F2F3
          DataModule2.Table12Name.AsString := DataModule2.Table1Name.AsString; //0059F305..F31D [2DC] ->0x244
          DataModule2.Table12.Post;                           //0059F338..F347
        end;                                                  //0059F34D jmp->0059F3B4
      end
      else                                                    //0059F34F..F3AE jle-Fall
      begin
        ans(Copy(gvar_02536630, 8,                             //0059F34F..F383 [2E0<-2E8]
                 Length(gvar_02536630) - 7), anst);
        DataModule2.Table1Vornamen.AsString := Trim(anst);    //0059F388..F3AE [2E0] ->0x544
      end;
      { anschliessend: nachtraeglicher Wdh.-Split von hdr (mit neuem hdr) }
      hdr := Trim(Copy(hdr, Pos('/', hdr) + 1, Length(hdr))); //0059F3B4..F403 [ebp-0B8]
    end;
    if Pos('2 GIVN', gvar_02536630) > 0 then                 //0059F408..F41A jle->0059F48D
    begin                                                      //0059F41C
      DataModule2.Table1.Edit;                                 //0059F41C [0x5C]
      ans(Trim(Copy(gvar_02536630, 8,                         //0059F42B..F46D [2F4<-2FC]
               Length(gvar_02536630))), anst);
      DataModule2.Table1Vornamen.AsString := anst;            //0059F472..F487 ->0x544
    end;
    if Pos('2 SURN', gvar_02536630) > 0 then                 //0059F48D..F49F jle->0059F512
    begin                                                      //0059F4A1
      DataModule2.Table1.Edit;                                 //0059F4A1 [0x5C]
      ans(Trim(Copy(gvar_02536630, 8,                         //0059F4B0..F4F2 [300<-308]
               Length(gvar_02536630))), anst);
      DataModule2.Table1Name.AsString := anst;                //0059F4F7..F50C ->0x540
    end;
    if Pos('SEX', gvar_02536630) > 0 then                    //0059F512..F524 jle->0059F68E
    begin
      if Copy(gvar_02536630, 7, 1) = 'F' then                //0059F52A..F555 jne->0059F585
      begin
        DataModule2.Table1.Edit;                               //0059F557 [0x5C]
        DataModule2.Table1Geschlecht.AsString := 'w';         //0059F566 [548]
      end
      else if Copy(gvar_02536630, 7, 1) = 'M' then           //0059F585..F5B0 jne->0059F5E0
      begin
        DataModule2.Table1.Edit;                               //0059F5B2 [0x5C]
        DataModule2.Table1Geschlecht.AsString := 'm';         //0059F5C1 [548]
      end
      else if Copy(gvar_02536630, 7, 1) = 'U' then           //0059F5E0..F60B jne->0059F638
      begin
        DataModule2.Table1.Edit;                               //0059F60D [0x5C]
        DataModule2.Table1Geschlecht.AsString := 'x';         //0059F61C [548]
      end
      else                                                    //0059F638..F647
      begin
        DataModule2.Table1.Edit;                               //0059F638 [0x5C]
        DataModule2.Table1Geschlecht.AsString :=              //0059F647..F673 [318]
          LowerCase(Copy(gvar_02536630, 7, 1));
      end;
    end;                                                       //0059F680 jmp->0059F68E
    if Pos('NPFX', gvar_02536630) > 0 then                   //0059F68E..F6A0 jle->0059F705
    begin
      DataModule2.Table1.Edit;                                 //0059F6A2 [0x5C]
      ans(Copy(gvar_02536630, 8,                               //0059F6B1..F6EA [320<-324]
               Length(gvar_02536630) - 7), anst);
      DataModule2.Table1Beruf.AsString := anst;               //0059F6EA..[320] ->0x550
    end;
    if Pos('OCCU', gvar_02536630) = 3 then                   //0059F705..F718 cmp 3
    begin
      DataModule2.Table1.Edit;                                 //0059F71E [0x5C]
      { Beruf leer (T-Test F756 jbe->F7EE) oder nicht: beide Faelle
        enden mit derselben pipes-Anhaenge-Anweisung }
      ans(Copy(gvar_02536630, 8,                               //0059F763/F7EE..F813
               Length(gvar_02536630) - 7), anst);
      DataModule2.Table1Beruf.AsString := anst;               //0059F7D7/F827 ->0x550
    end;
    { **RELI / Religion + Kommentar-Anhaenge** (Konkatenation via @LStrCatN) }
    if Copy(gvar_02536630, 2, 5) = ' RELI' then              //0059F842..F86D jne->0059FBE9
    begin
      if Length(Trim(gvar_02536630)) = 6 then                //0059F873..F891 jne->F8A8
      begin
        gvar_02536630 := gvar_02536630;                      //0059F893..F89E toter Selbstzugriff
      end
      else                                                    //0059F8A8..F8D5 jg->F934
      begin
        DataModule2.Table1.Edit;                               //0059F8A8 [0x5C]
        if Length(Trim(gvar_02536630)) > 9 then               //0059F8B7..F8D5
        begin
          if Trim(LowerCase(Copy(gvar_02536630, 8, 2))) = 'ev' then    //0059F934..F981
            DataModule2.Table1Religion.AsString := Trim(LowerCase(Copy(gvar_02536630, 8, 2))) //0059F983..F9C0 ->0x54C
          else if Trim(LowerCase(Copy(gvar_02536630, 8, 4))) = 'kath' then  //0059F9E0..FA2D
            DataModule2.Table1Religion.AsString := 'rk'                   //0059FA2F
          else if Trim(LowerCase(Copy(gvar_02536630, 8, 4))) = 'konf' then //0059FA4E..FA9B
            DataModule2.Table1Religion.AsString := 'kl';                  //0059FA9D
        end
        else                                                   //0059F8D7..F914
          DataModule2.Table1Religion.AsString := Trim(LowerCase(Copy(gvar_02536630, 8, 2))); //->0x54C
      end;
      if Trim(DataModule2.Table1Kommentar.AsString) = '' then //0059FABC..FAE5 cmp 0 jne->FB5F
        DataModule2.Table1Kommentar.AsString :=               //0059FAEE..FB3F [398<-3A0]
          'Rel.: ' + Trim(Copy(gvar_02536630, 8, 100)) + #13#10
      else
        DataModule2.Table1Kommentar.AsString :=               //0059FB5F..FBCE [3A4<-3B0]
          DataModule2.Table1Kommentar.AsString + ' Rel.: ' +
          Trim(Copy(gvar_02536630, 8, 100)) + #13#10;
    end;
    if Pos('1 EVEN', gvar_02536630) > 0 then                 //0059FBE9..FBFB jle->FC0D
      ctx := 'even';                                           //0059FBFD [ebp-0C0]
    if (Pos('2 TYPE', gvar_02536630) > 0) and                //0059FC0D..FC35 jle->FD68
       (ctx = 'even') then                                    //0059FC25..FC35
    begin
      if Trim(DataModule2.Table1Kommentar.AsString) = '' then //0059FC3B..FC6B jne->FCDE
        DataModule2.Table1Kommentar.AsString :=               //0059FC6D..FCBE [3BC<-3C4]
          'Event Type: ' + Trim(Copy(gvar_02536630, 8, 100)) + #13#10
      else
        DataModule2.Table1Kommentar.AsString :=               //0059FCDE..FD4D [3C8<-3D4]
          DataModule2.Table1Kommentar.AsString + ' Event Type: ' +
          Trim(Copy(gvar_02536630, 8, 100)) + #13#10;
    end;
    if (Copy(ucase(Trim(gvar_02536630)), 1, 6) = '2 DATE') and //0059FD68..FDBD jne->FF06
       (ctx = 'even') then                                     //0059FDC3..FDD3
    begin
      if Trim(DataModule2.Table1Kommentar.AsString) = '' then //0059FDD9..FE09 jne->FE7C
        DataModule2.Table1Kommentar.AsString :=                //0059FE0B..FE5C [3EC<-3F4]
          'Event Date: ' + Trim(Copy(gvar_02536630, 8, 100)) + #13#10
      else
        DataModule2.Table1Kommentar.AsString :=                //0059FE7C..FEEB [3F8<-404]
          DataModule2.Table1Kommentar.AsString + 'Event Date: ' +
          Trim(Copy(gvar_02536630, 8, 100)) + #13#10;
    end;
    if Pos('EDUC', gvar_02536630) > 0 then                   //0059FF2A..FF3C jle->FF44
    begin
      DataModule2.Table1.Edit;                                 //0059FF42 [0x5C]
      ans(Copy(gvar_02536630, 8,                               //0059FF51..FF9B [410<-40C]
               Length(gvar_02536630) - 7), anst);
      DataModule2.Table1Kommentar.AsString :=                 //0059FFAF..FFCF [408]
        DataModule2.Table1Kommentar.AsString + 'Ausbildung: ' + anst + #13#10;
    end;
    if Pos('IDNO', gvar_02536630) > 0 then                   //0059FFE4..FFF6 jle->005A0058
    begin
      DataModule2.Table1.Edit;                                 //0059FFF8 [0x5C]
      DataModule2.Table1IDNR.AsString := Trim(Copy(gvar_02536630, 8,   //005A0007..A03D
        Length(gvar_02536630) - 7));
    end;
    if Pos('REFN', gvar_02536630) > 0 then                   //005A0058..A06A jle->A0288
    begin
      DataModule2.Table1.Edit;                                 //005A0070 [0x5C]
      refn := Trim(Copy(gvar_02536630, 8,                      //005A007F..A0B5
        Length(gvar_02536630) - 7));
      if Length(refn) > 10 then                                //005A00B5..A0C3 jg->A11B
      begin
        if Trim(DataModule2.Table1Kommentar.AsString) = '' then //005A011B..A14B jne->A1EA
          DataModule2.Table1Kommentar.AsString :=              //005A0151..A1CA
            'REFN: ' + refn + #13#10                            // CatN 'REFN: '|text|CRLF
        else
          DataModule2.Table1Kommentar.AsString :=              //005A01EA..A26D
            DataModule2.Table1Kommentar.AsString + #13#10 + 'REFN: ' + refn + #13#10;
          { leerer-Kommentar-Zweig: CatN zugaengt altes Kommentar mit (leer) }
      end
      else                                                    //005A00C5..A0FB
        DataModule2.Table1IDNR.AsString := refn;
    end;
    if Pos('1 ADOP', gvar_02536630) > 0 then                 //005A0288..A29A jle->A2AC
      ctx := 'adop';                                           //005A029C
    if (Pos('2 FAMC', gvar_02536630) > 0) and                //005A02AC..A2BE jle->A348
       (ctx = 'adop') then                                    //005A02C4..A2D4
      klist := klist +                                          //005A02D6..A0343 CatN [0BC]|458|'*'
        RightStr('000000' + Copy(gvar_02536630, 10,
                 Length(gvar_02536630) - 10), 6) + '*';
    if Pos('2 SOUR', gvar_02536630) > 0 then                 //005A0348..A35A jle->A449
    begin
      if Copy(gvar_02536630, 8, 1) = '@' then                //005A0360..A38B jne->A3EC
      begin
        DataModule2.Table1.Edit;                               //005A038D [0x5C]
        hdr := Trim(Copy(gvar_02536630, 9,                      //005A039C..A03CF [0B8<-468]
          Length(gvar_02536630)));
        DataModule2.Table1Quelle.AsString := hdr;              //005A03CF [0B8] ->0x5FC
      end
      else                                                    //005A03EC..A041D
      begin
        DataModule2.Table1.Edit;                               //005A03EC [0x5C]
        DataModule2.Table1Quelle.AsString := Trim(Copy(gvar_02536630, 8,   //005A03FB..A042E
          Length(gvar_02536630)));
      end;
    end;
    if Pos('BIRT', gvar_02536630) > 0 then                   //005A0449..A45B jle->A46D
      ctx := 'birt';                                           //005A045D
    if (Pos('BAPM', gvar_02536630) > 0) or                   //005A046D..A47F jg->A495
       (Pos('CHR', gvar_02536630) > 0) then                   //005A0481..A493 jle->A4A5
      ctx := 'chr';                                            //005A0495 (auch BAPM-Fall)
    if Pos('_GODP', gvar_02536630) > 0 then                  //005A04A5..A4B7 jle->A516
    begin
      DataModule2.Table1.Edit;                                 //005A04B9 [0x5C]
      DataModule2.Table1Taufpat.AsString := Trim(Copy(gvar_02536630, 9,   //005A04C8..A04FB
        Length(gvar_02536630)));                               //  [474] ->0x574
    end;
    if Pos('DEAT', gvar_02536630) > 0 then                   //005A0516..A528 jle->A53A
      ctx := 'deat';                                           //005A052A
    if Pos('CAUS', gvar_02536630) > 0 then                   //005A053A..A54C jle->A5AB
    begin
      DataModule2.Table1.Edit;                                 //005A054E [0x5C]
      DataModule2.Table1Todesurs.AsString := Trim(Copy(gvar_02536630, 8,  //005A055D..A0590
        Length(gvar_02536630)));                               //  [47C] ->0x58C
    end;
    if Pos('BURI', gvar_02536630) > 0 then                   //005A05AB..A5BD jle->A5CF
      ctx := 'buri';                                           //005A05BF
    if Pos('EMIG', gvar_02536630) > 0 then                   //005A05CF..A5E1 jle->A5F3
      ctx := 'emig';                                           //005A05E3
    if Pos('NATU', gvar_02536630) > 0 then                   //005A05F3..A605 jle->A617
      ctx := 'natu';                                           //005A0607
    if Pos('1 RESI', gvar_02536630) > 0 then                 //005A0617..A629 jle->A63B
      ctx := 'resi';                                           //005A062B
    { **Termin-Matrix je ctx ('2 DATE' ohne Edit->Familien-Snapshots)** }
    if Copy(ucase(Trim(gvar_02536630)), 1, 6) = '2 DATE' then //005A063B..A0690 jne->A0AE6
    begin
      if ctx = 'birt' then                                     //005A0696..A06A6 jne->A074A
      begin
        sub_00577934(TrimRight(Copy(gvar_02536630, 8,          //005A06AC..A06EA
          Length(gvar_02536630))));
        DataModule2.Table1.Edit;                               //005A06EA [0x5C]
        DataModule2.Table1Gebtag.AsString := gvar_02536624;   //005A06F9 [554]
        DataModule2.Table1Gebmonat.AsString := gvar_02536628; //005A0714 [558]
        DataModule2.Table1Gebjahr.AsString := gvar_0253662C;  //005A072F [55C]
      end
      else if ctx = 'chr' then                                 //005A074A..A075A jne->A07FE
      begin
        sub_00577934(TrimRight(Copy(gvar_02536630, 8,          //005A0760..A079E
          Length(gvar_02536630))));
        DataModule2.Table1.Edit;                               //005A079E [0x5C]
        DataModule2.Table1Tauftag.AsString := gvar_02536624;  //005A07AD [564]
        DataModule2.Table1Taufmonat.AsString := gvar_02536628; //005A07C8 [568]
        DataModule2.Table1Taufjahr.AsString := gvar_0253662C; //005A07E3 [56C]
      end
      else if ctx = 'deat' then                                //005A07FE..A080E jne->A08B2
      begin
        sub_00577934(TrimRight(Copy(gvar_02536630, 8,          //005A0814..A0852
          Length(gvar_02536630))));
        DataModule2.Table1.Edit;                               //005A0852 [0x5C]
        DataModule2.Table1Sttag.AsString := gvar_02536624;    //005A0861 [57C]
        DataModule2.Table1Stmonat.AsString := gvar_02536628;  //005A087C [580]
        DataModule2.Table1Stjahr.AsString := gvar_0253662C;   //005A0897 [584]
      end
      else if ctx = 'buri' then                                //005A08B2..A08C2 jne->A0966
      begin
        sub_00577934(TrimRight(Copy(gvar_02536630, 8,          //005A08C8..A0906
          Length(gvar_02536630))));
        DataModule2.Table1.Edit;                               //005A0906 [0x5C]
        DataModule2.Table1Begtag.AsString := gvar_02536624;   //005A0915 [590]
        DataModule2.Table1Begmonat.AsString := gvar_02536628; //005A0930 [594]
        DataModule2.Table1Begjahr.AsString := gvar_0253662C;  //005A094B [598]
      end
      else if ctx = 'fam_reli' then                            //005A0966..A0976 jne->A09E0
      begin
        sub_00577934(TrimRight(Copy(gvar_02536630, 8,          //005A0978..A09AB
          Length(gvar_02536630))));
        { KEIN Edit: Snapshot in lokale Triples }
        reliTag := gvar_02536624;                             //005A09B6 [ebp-5C]
        reliMonat := gvar_02536628;                           //005A09C4 [ebp-60]
        reliJahr := gvar_0253662C;                            //005A09D2 [ebp-64]
      end
      else if ctx = 'fam_civi' then                            //005A09E0..A09F0 jne->A0A63
      begin
        sub_00577934(TrimRight(Copy(gvar_02536630, 8,          //005A09F2..A0A25
          Length(gvar_02536630))));
        { KEIN Edit: Snapshot in lokale Triples (doppelt belegt mit
          '@CHR'-Block 'Sdat.:', sofern vorhanden) }
        civiTag := gvar_02536624;                             //005A0A30 [ebp-9C]
        civiMonat := gvar_02536628;                           //005A0A41 [ebp-0A0]
        civiJahr := gvar_0253662C;                            //005A0A52 [ebp-0A4]
      end
      else if ctx = 'fam_div' then                             //005A0A63..A0A73 jne->A0AE6
      begin
        sub_00577934(TrimRight(Copy(gvar_02536630, 8,          //005A0A75..A0AA8
          Length(gvar_02536630))));
        { KEIN Edit: Snapshot in lokale Triples }
        divTag := gvar_02536624;                              //005A0AB3 [ebp-88]
        divMonat := gvar_02536628;                            //005A0AC4 [ebp-8C]
        divJahr := gvar_0253662C;                             //005A0AD5 [ebp-90]
      end;
    end;                                                       //005A0AD6 jmp->005A0AE6
    { **'2 PLAC'-Matrix je ctx (Table13-Findex, ausserremainder Ort-Reihenfolge wie Raw)** }
    if Copy(ucase(Trim(gvar_02536630)), 1, 6) = '2 PLAC' then //005A0AE6..A0B3B jne->A12F7
    begin
      if ctx = 'resi' then                                     //005A0B41..A0B51 jne->A0BB8
      begin
        DataModule2.Table1.Edit;                               //005A0B53 [0x5C]
        DataModule2.Table1Lebensort.AsString := Trim(Copy(gvar_02536630, 8,  //005A0B62..A0B98 [4DC]
          Length(gvar_02536630) - 7));                         //  ->0x578
      end
      else if ctx = 'birt' then                                //005A0BB8..A0BC8 jne->A0CEE
      begin
        DataModule2.Table1.Edit;                               //005A0BCE [0x5C]
        ans(Copy(gvar_02536630, 8,                            //005A0BDD..A0C2A [4DC]
          Length(gvar_02536630) - 7), anst);
        DataModule2.Table1Gebort.AsString := Trim(anst);      //005A0C16..A0C27 [4DC] ->0x560
        if not DataModule2.Table13.FindKey([DataModule2.Table1Gebort.AsString]) then //A0C42..A0C89 jne->A1087
        begin
          DataModule2.Table13.Append;                         //005A0C8F
          DataModule2.Table13Ort.AsString := DataModule2.Table1Gebort.AsString; //A0CA1..A0CB9 [4EC] ->0xA44
          DataModule2.Table13.Post;                            //005A0CD4
        end;
      end
      else if ctx = 'chr' then                                 //005A0CEE..A0CFE jne->A0E24
      begin
        DataModule2.Table1.Edit;                               //005A0D04 [0x5C]
        ans(Copy(gvar_02536630, 8,                            //005A0D13..A0D69 [4F0]
          Length(gvar_02536630) - 7), anst);
        DataModule2.Table1Taufort.AsString := Trim(anst);     //A0D4C..A0D5D [4F0] ->0x570
        if not DataModule2.Table13.FindKey([DataModule2.Table1Taufort.AsString]) then //A0D78..A0DBF jne->A1087
        begin
          DataModule2.Table13.Append;                         //005A0DC5
          DataModule2.Table13Ort.AsString := DataModule2.Table1Taufort.AsString; //A0DD7..A0DEF [500] ->0xA44
          DataModule2.Table13.Post;                            //005A0E0A
        end;
      end
      else if ctx = 'deat' then                                //005A0E24..A0E34 jne->A0F5A
      begin
        DataModule2.Table1.Edit;                               //005A0E3A [0x5C]
        ans(Copy(gvar_02536630, 8,                            //005A0E49..A0E9F [504]
          Length(gvar_02536630) - 7), anst);
        DataModule2.Table1Stort.AsString := Trim(anst);       //A0E82..A0E93 [504] ->0x588
        if not DataModule2.Table13.FindKey([DataModule2.Table1Stort.AsString]) then //A0EAE..A0EF5 jne->A1087
        begin
          DataModule2.Table13.Append;                         //005A0EFB
          DataModule2.Table13Ort.AsString := DataModule2.Table1Stort.AsString; //A0F0D..A0F25 [514] ->0xA44
          DataModule2.Table13.Post;                            //005A0F40
        end;
      end
      else if ctx = 'buri' then                                //005A0F5A..A0F6A jne->A1087
      begin
        DataModule2.Table1.Edit;                               //005A0F70 [0x5C]
        ans(Copy(gvar_02536630, 8,                            //005A0F7F..A0FD5 [518]
          Length(gvar_02536630) - 7), anst);
        DataModule2.Table1Begort.AsString := Trim(anst);      //A0FB8..A0FC9 [518] ->0x59C
        if not DataModule2.Table13.FindKey([DataModule2.Table1Begort.AsString]) then //A0FE4..A102B jne->A1087
        begin
          DataModule2.Table13.Append;                         //005A102D
          DataModule2.Table13Ort.AsString := DataModule2.Table1Begort.AsString; //A103F..A1057 [528] ->0xA44
          DataModule2.Table13.Post;                            //005A1072
        end;
      end
      else if ctx = 'fam_reli' then                            //005A1087..A1097 jne->A1151
      begin
        ans(Copy(gvar_02536630, 8,                          //A109D..A10E7 [68<-52C]
          Length(gvar_02536630) - 7), anst);
        hort := Trim(anst);
        { KEIN Table13-Edit: FindKey direkt auf hort }
        if not DataModule2.Table13.FindKey([hort]) then        //A10E4..A1110 jne->A1151
        begin
          DataModule2.Table13.Append;                         //005A1112
          DataModule2.Table13Ort.AsString := hort;            //A1124 [68] ->0xA44
          DataModule2.Table13.Post;                            //005A113C
        end;
      end
      else if ctx = 'fam_civi' then                            //005A1151..A1161 jne->A1224
      begin
        ans(Copy(gvar_02536630, 8,                         //A1167..A11B7 [0A8]
          Length(gvar_02536630) - 7), anst);
        saort := Trim(anst);
        if not DataModule2.Table13.FindKey([saort]) then       //A11B1..A11E0 jne->A1224
        begin
          DataModule2.Table13.Append;                         //005A11E2
          DataModule2.Table13Ort.AsString := saort;           //A11F4 [0A8] ->0xA44
          DataModule2.Table13.Post;                            //005A120F
        end;
      end
      else if ctx = 'fam_div' then                             //005A1224..A1234 jne->A12F7
      begin
        ans(Copy(gvar_02536630, 8,                        //A123A..A128A [94<-53C]
          Length(gvar_02536630) - 7), anst);
        schort := Trim(anst);
        if not DataModule2.Table13.FindKey([schort]) then      //A1284..A12B3 jne->A12F7
        begin
          DataModule2.Table13.Append;                         //005A12B5
          DataModule2.Table13Ort.AsString := schort;          //A12C7 [94] ->0xA44
          DataModule2.Table13.Post;                            //005A12E2
        end;
      end;
    end;
    { **'0 @N'-Block: NOTEappen und Schluesselworte** }
    if Copy(gvar_02536630, 1, 4) = '0 @N' then                //005A12F7..A1322 jne->A1396
    begin
      ReadLn(gvar_02536458, gvar_02536630);                   //005A1324
      while Copy(gvar_02536630, 1, 1) <> '0' do               //005A1362..A138D
        ReadLn(gvar_02536458, gvar_02536630);
      rdflag := 1;                                             //005A138F [ebp-28]
    end;
    if Copy(gvar_02536630, 2, 6) = ' NOTE ' then               //005A1396..A13C1 jne->A22DE
    begin
      if Pos('@', gvar_02536630) = 8 then                     //005A13C7..A13DA (auf Pos=8)
      begin
        hdr := Trim(Copy(gvar_02536630, 9,                    //005A13E0..A1402 [0B8]
          Length(gvar_02536630)));
        DataModule2.Table26.IndexName := 'alt_';               //005A1413
        if DataModule2.Table26.FindKey([Copy(hdr, 1, Pos('@', hdr) - 1)]) then  //A142A..A1483 je->A22DE
        begin
          DataModule2.Table1.Edit;                             //A1489 [0x5C]
          if Trim(DataModule2.Table1Kommentar.AsString) = '' then //A1498..A14C8 jne->A1512
            DataModule2.Table1Kommentar.AsString :=            //A14CA..A14F2 [560] ->0x5B0
              DataModule2.Table26Inh2.AsString + #13#10
          else
            DataModule2.Table1Kommentar.AsString :=            //A1512..A1563 catN 'Inh2|CRLF' [564]
              DataModule2.Table1Kommentar.AsString + DataModule2.Table26Inh2.AsString + #13#10;
        end;
      end
      else if Pos('@', gvar_02536630) > 0 then               //005A1583..A1595 jne->A22DE
      begin
        { '@' an anderer Stairnposition - Block ueberspringen }
      end
      else if Trim(Copy(gvar_02536630, 8,                    //005A159B..A15D5 jbe->A22DE
            Length(gvar_02536630))) <> '' then
      begin
        if Pos('Schrw.:', gvar_02536630) > 0 then             //005A15DB..A15ED jle->A1642
          DataModule2.Table1Namex.AsString := Trim(Copy(gvar_02536630, 16,   //A15EF..A1622 [578] ->0x5BC
            Length(gvar_02536630)))
        else if Pos('Hnm.:', gvar_02536630) > 0 then         //005A1642..A1654 jle->A16A9
          DataModule2.Table1Hausname.AsString := Trim(Copy(gvar_02536630, 14, //A1656..A1689 [580] ->0x5C8
            Length(gvar_02536630)))
        else if Pos('lebt:', gvar_02536630) > 0 then         //005A16A9..A16BB jle->A1722
        begin
          if RightStr(gvar_02536630, 1) = 'j' then           //005A16BD..A16E2 jne->A1703
            DataModule2.Table1Lebt.AsString := 'j'           //A16E4 [5B4]
          else
            DataModule2.Table1Lebt.AsString := 'n';          //A1703
        end
        else if Pos('L.-Orte:', gvar_02536630) > 0 then      //005A1722..A1734 jle->A1789
          DataModule2.Table1Lebensort.AsString := Trim(Copy(gvar_02536630, 17, //A1736..A1769 [58C] ->0x578
            Length(gvar_02536630)))
        else if Pos('Gque', gvar_02536630) > 0 then          //005A1789..A179B jle->A1816
        begin
          DataModule2.Table1.Edit;                             //A179D [0x5C]
          ans(Copy(gvar_02536630, 15,                          //A17AC..A17F1 [594<-59C]
            Length(gvar_02536630) - 14), anst);
          DataModule2.Table1Quelleg.AsString := Trim(anst);   //A17E5..A17F6 [594] ->0x5A0
        end
        else if Pos('Tque', gvar_02536630) > 0 then          //005A1816..A1828 jle->A18A3
        begin
          DataModule2.Table1.Edit;                             //A182A [0x5C]
          ans(Copy(gvar_02536630, 15,                          //A1839..A187E [5A0]
            Length(gvar_02536630) - 14), anst);
          DataModule2.Table1Quellet.AsString := Trim(anst);   //A1872..A1883 [5A0] ->0x5A4
        end
        else if Pos('Sque', gvar_02536630) > 0 then          //005A18A3..A18B5 jle->A1930
        begin
          DataModule2.Table1.Edit;                             //A18B7 [0x5C]
          ans(Copy(gvar_02536630, 15,                          //A18C6..A193B [5AC]
            Length(gvar_02536630) - 14), anst);
          DataModule2.Table1Quelles.AsString := Trim(anst);   //A18FF..A1910 [5AC] ->0x5A8
        end
        else if Pos('Bque', gvar_02536630) > 0 then          //005A1930..A1942 jle->A19BD
        begin
          DataModule2.Table1.Edit;                             //A1944 [0x5C]
          ans(Copy(gvar_02536630, 15,                          //A1953..A1998 [5B8]
            Length(gvar_02536630) - 14), anst);
          DataModule2.Table1Quelleb.AsString := Trim(anst);   //A198C..A199D [5B8] ->0x5AC
        end
        else if Pos('Qu.G', gvar_02536630) > 0 then          //005A19BD..A19CF jle->A1A4A
        begin
          DataModule2.Table1.Edit;                             //A19D1 [0x5C]
          ans(Copy(gvar_02536630, 19,                          //A19E0..A1A24 [5C4<-5CC]
            Length(gvar_02536630) - 18), anst);
          DataModule2.Table1Quelleg.AsString := Trim(anst);   //A1A19..A1A2A [5C4] ->0x5A0
        end
        else if Pos('Qu.Ta', gvar_02536630) > 0 then         //005A1A4A..A1A5C jle->A1AD7
        begin
          DataModule2.Table1.Edit;                             //A1A5E [0x5C]
          ans(Copy(gvar_02536630, 18,                          //A1A6D..A1AA1 [5D0]
            Length(gvar_02536630) - 17), anst);
          DataModule2.Table1Quellet.AsString := Trim(anst);   //A1AA6..A1AB7 [5D0] ->0x5A4
        end
        else if Pos('Qu.To', gvar_02536630) > 0 then         //005A1AD7..A1AE9 jle->A1B64
        begin
          DataModule2.Table1.Edit;                             //A1AEB [0x5C]
          ans(Copy(gvar_02536630, 16,                          //A1AFA..A1B32 [5DC]
            Length(gvar_02536630) - 15), anst);
          DataModule2.Table1Quelles.AsString := Trim(anst);   //A1B33..A1B44 [5DC] ->0x5A8
        end
        else if Pos('Qu.Be', gvar_02536630) > 0 then         //005A1B64..A1B76 jle->A1BF1
        begin
          DataModule2.Table1.Edit;                             //A1B78 [0x5C]
          ans(Copy(gvar_02536630, 21,                          //A1B87..A1BBF [5E8]
            Length(gvar_02536630) - 20), anst);
          DataModule2.Table1Quelleb.AsString := Trim(anst);   //A1BC0..A1BD1 [5E8] ->0x5AC
        end
        else if (Pos('Trauz', gvar_02536630) = 8) then       //A1BF1..A1C04 (cmp 8, jne->A1CA7)
        begin
          { zweimalig identische Zuweisung: unbedingt (A1C0A..A1C4C) und
            bei utfflag=1 nochmals (A1C5B..A1C9D, jne->A22DE) - identischer Text }
          ans(Copy(gvar_02536630, 15,                        //A1C0A..A1C3E [5F4<-5F8]
            Length(gvar_02536630) - 14), anst);
          trauzTxt := Trim(anst);                            //A1C43..A1C4C [70]
          if utfflag = 1 then                                //A1C51..A1C55 jne->A22DE
          begin
            ans(Copy(gvar_02536630, 15,                      //A1C5B..A1C8F [5FC<-600]
              Length(gvar_02536630) - 14), anst);
            trauzTxt := Trim(anst);                          //A1C94..A1C9D [70]
          end;
        end
        else if Pos('Hque.:', gvar_02536630) > 0 then        //005A1CA7..A1CB9 jle->A1D07
        begin
          { A1CBB..A1D02: anst-Berechnung, Ziel [ebp-6C], wird im BIDOM-Stream
            nicht mehr gelesen (benachbarter 'Verb.'-Block liest eb-84) }
          ans(Copy(gvar_02536630, 15,                          //A1CBB..A1CF4 [6C<-604]
            Length(gvar_02536630) - 14), anst);
          hqu := Trim(anst);                                   //A1CF4 [6C]
        end
        else if Pos('Verb.:', gvar_02536630) > 0 then         //005A1D07..A1D19 jle->A1D6A
        begin
          ans(Copy(gvar_02536630, 15,                         //A1D1B..A1D4E [60C<-610]
            Length(gvar_02536630) - 14), anst);
          verbind := Trim(anst);                             //A1D54 [84] ->[ebp-84]
        end
        else if Pos('Sdat.:', gvar_02536630) > 0 then         //005A1D6A..A1D7C jle->A1DD4
        begin
          { Sdat.:  -> civiTriples (dual-use mit '@CHR'-Snapshot) }
          civiTag := Copy(gvar_02536630, 15, 2);              //005A1D7E
          civiMonat := Copy(gvar_02536630, 17, 2);            //005A1D99
          civiJahr := Copy(gvar_02536630, 19, 4);             //005A1DB4
        end
        else if Pos('Sort.:', gvar_02536630) > 0 then         //A1DD4..A1DE6 jle->A1E37
        begin
          ans(Copy(gvar_02536630, 15,                         //A1DE8..A1E1B [0A8<-614]
            Length(gvar_02536630) - 14), anst);
          saort := Trim(anst);                               //A1E21 [0A8]
        end
        else if Pos('Strz.:', gvar_02536630) > 0 then        //A1E37..A1E49 jle->A1E9A
        begin
          ans(Copy(gvar_02536630, 15,                         //A1E4B..A1E7E [0AC<-618]
            Length(gvar_02536630) - 14), anst);
          satrauz := Trim(anst);                             //A1E84 [0AC]
        end
        else if Pos('Saqu.:', gvar_02536630) > 0 then        //A1E9A..A1EAC jle->A1EFD
        begin
          ans(Copy(gvar_02536630, 15,                         //A1EAE..A1EE1 [0B0<-61C]
            Length(gvar_02536630) - 14), anst);
          saqu := Trim(anst);                                //A1EE7 [0B0]
        end
        else if Pos('Schq.:', gvar_02536630) > 0 then        //A1EFD..A1F0F jle->A1F60
        begin
          ans(Copy(gvar_02536630, 15,                         //A1F11..A1F44 [98<-620]
            Length(gvar_02536630) - 14), anst);
          schqu := Trim(anst);                               //A1F4A [98]
        end
        else if ctx = 'fam_reli' then                        //A1F60..A1F70 jne->A20A0
        begin
          if Pos('@', gvar_02536630) = 0 then                //A1F76..A1F88 jne->A22DE
          begin
            if Pos('not marr', gvar_02536630) > 0 then       //A1F8E..A1FA0 jle->A1FB7
              verbind := 'andere Beziehung'                  //A1FA2..A1FB2 jmp->A22DE
            else if Trim(Copy(gvar_02536630, 8,              //A1FB7..A1FF4 jbe->A22DE
                  Length(gvar_02536630) - 7)) <> '' then
            begin
              DataModule2.Table1.Edit;                       //A1FFA [0x5C]
              ans(Copy(gvar_02536630, 8,                     //A2015..A205B [648->644]
                Length(gvar_02536630) - 7), anst);
              DataModule2.Table1Kommentar.AsString :=        //A2060..A2095 catN 4 [63C]
                DataModule2.Table1Kommentar.AsString + anst + #13#10;
            end;
          end;
        end
        else if ctx = 'fam_civi' then                        //A20A0..A20B0 jne->A21B7
        begin
          if Pos('@', gvar_02536630) = 0 then                //A20B6..A20C8 jne->A22DE
          begin
            if Trim(Copy(gvar_02536630, 8,                   //A20CE..A210B jbe->A22DE
                  Length(gvar_02536630) - 7)) <> '' then
            begin
              DataModule2.Table1.Edit;                       //A2111 [0x5C]
              ans(Copy(gvar_02536630, 8,                     //A2138..A2172 [660->65C]
                Length(gvar_02536630) - 7), anst);
              DataModule2.Table1Kommentar.AsString :=        //A2177..A2197 catN 4 [654]
                DataModule2.Table1Kommentar.AsString + anst + #13#10;
            end;
          end;
        end
        else                                                  //A21B7: Catch-all
        begin
          DataModule2.Table1.Edit;                           //A21B7 [0x5C]
          if Trim(DataModule2.Table1Kommentar.AsString) = '' then //A21C6..A21F6 jne->A2251
          begin
            ans(Copy(gvar_02536630, 8,                       //A21F8..A222C [670->66C]
              Length(gvar_02536630) - 7), anst);
            DataModule2.Table1Kommentar.AsString := anst;    //A2231..A2246 [66C] ->0x5B0
          end
          else
          begin
            ans(Copy(gvar_02536630, 8,                       //A227A..A22A8 [680->67C]
              Length(gvar_02536630) - 7), anst);
            DataModule2.Table1Kommentar.AsString :=          //A2269..A22BE catN 3 [674]
              DataModule2.Table1Kommentar.AsString + #13#10 + anst;
          end;
        end;
      end;                                                    //005A22DE: Ende Note-Guard
    end;
    { **CONT/COMM-Block (zweites Hauptdispatch, Varianten ohne Fallbacks)** }
    if (Pos('CONT ', gvar_02536630) > 0) or                 //005A22DE..A22F0 jg->A230A / jle->COMM-Tst
       (Pos('COMM ', gvar_02536630) > 0) then               //005A22F2..A2304 jle->A300F
    begin
      DataModule2.Table1.Edit;                               //005A230A [0x5C]
      if Pos('Schrw.:', gvar_02536630) > 0 then             //A2319..A232B jle->A2380
        DataModule2.Table1Namex.AsString := Trim(Copy(gvar_02536630, 16,  //A232D..A2360 [684] ->5BC
          Length(gvar_02536630)))
      else if Pos('Hnm.:', gvar_02536630) > 0 then          //A2380..A2392 jle->A23E7
        DataModule2.Table1Hausname.AsString := Trim(Copy(gvar_02536630, 14, //A2394..A23C7 [68C] ->5C8
          Length(gvar_02536630)))
      else if Pos('lebt:', gvar_02536630) > 0 then          //A23E7..A23F9 jle->A241A
        DataModule2.Table1Lebt.AsString := 'j'              //A23FB [5B4] (direkt, kein j/n-Test!)
      else if Pos('L.-Orte:', gvar_02536630) > 0 then       //A241A..A242C jle->A2481
        DataModule2.Table1Lebensort.AsString := Trim(Copy(gvar_02536630, 17, //A242E..A2461 [694] ->578
          Length(gvar_02536630)))
      else if Pos('Gque', gvar_02536630) > 0 then           //A2481..A2493 jle->A250E
      begin
        DataModule2.Table1.Edit;                               //A2495 [0x5C]
        ans(Copy(gvar_02536630, 15,                            //A24A4..A24E2 [69C<-6A4]
          Length(gvar_02536630) - 14), anst);
        DataModule2.Table1Quelleg.AsString := Trim(anst);     //A24DD..A24EE [69C] ->5A0
      end
      else if Pos('Tque', gvar_02536630) > 0 then           //A250E..A2520 jle->A259B
      begin
        DataModule2.Table1.Edit;                               //A2522 [0x5C]
        ans(Copy(gvar_02536630, 15,                            //A2531..A256F [6A8]
          Length(gvar_02536630) - 14), anst);
        DataModule2.Table1Quellet.AsString := Trim(anst);     //A256A..A257B [6A8] ->5A4
      end
      else if Pos('Sque', gvar_02536630) > 0 then           //A259B..A25AD jle->A2628
      begin
        DataModule2.Table1.Edit;                               //A25AF [0x5C]
        ans(Copy(gvar_02536630, 15,                            //A25BE..A25FC [6B4]
          Length(gvar_02536630) - 14), anst);
        DataModule2.Table1Quelles.AsString := Trim(anst);     //A25F7..A2608 [6B4] ->5A8
      end
      else if Pos('Bque', gvar_02536630) > 0 then           //A2628..A263A jle->A26B5
      begin
        DataModule2.Table1.Edit;                               //A263C [0x5C]
        ans(Copy(gvar_02536630, 15,                            //A264B..A2689 [6C0]
          Length(gvar_02536630) - 14), anst);
        DataModule2.Table1Quelleb.AsString := Trim(anst);     //A2684..A2695 [6C0] ->5AC
      end
      else if Pos('Qu.G', gvar_02536630) > 0 then           //A26B5..A26C7 jle->A2742
      begin
        DataModule2.Table1.Edit;                               //A26C9 [0x5C]
        ans(Copy(gvar_02536630, 19,                            //A26D8..A2716 [6CC<-6D4]
          Length(gvar_02536630) - 18), anst);
        DataModule2.Table1Quelleg.AsString := Trim(anst);     //A2711..A2722 [6CC] ->5A0
      end
      else if Pos('Qu.Ta', gvar_02536630) > 0 then          //A2742..A2754 jle->A27CF
      begin
        DataModule2.Table1.Edit;                               //A2756 [0x5C]
        ans(Copy(gvar_02536630, 18,                            //A2765..A27A3 [6D8]
          Length(gvar_02536630) - 17), anst);
        DataModule2.Table1Quellet.AsString := Trim(anst);     //A279E..A27AF [6D8] ->5A4
      end
      else if Pos('Qu.To', gvar_02536630) > 0 then          //A27CF..A27E1 jle->A285C
      begin
        DataModule2.Table1.Edit;                               //A27E3 [0x5C]
        ans(Copy(gvar_02536630, 16,                            //A27F2..A282A [6E4]
          Length(gvar_02536630) - 15), anst);
        DataModule2.Table1Quelles.AsString := Trim(anst);     //A282B..A283C [6E4] ->5A8
      end
      else if Pos('Qu.Be', gvar_02536630) > 0 then          //A285C..A286E jle->A28E9
      begin
        DataModule2.Table1.Edit;                               //A2870 [0x5C]
        ans(Copy(gvar_02536630, 21,                            //A287F..A28BD [6F0]
          Length(gvar_02536630) - 20), anst);
        DataModule2.Table1Quelleb.AsString := Trim(anst);     //A28B8..A28C9 [6F0] ->5AC
      end
      else if (Pos('Trauz', gvar_02536630) = 8) then        //A28E9..A28FC (cmp 8, jne->A299F)
      begin
        { zweimalig identische Zuweisung: unbedingt (A2902..A2944) und
          bei utfflag=1 nochmals (A2953..A2995, jne->A300F) - identischer Text }
        ans(Copy(gvar_02536630, 15,                          //A2902..A2936 [6FC<-700]
          Length(gvar_02536630) - 14), anst);
        trauzTxt := Trim(anst);                              //A293B..A2944 [70]
        if utfflag = 1 then                                  //A2949..A294D jne->A300F
        begin
          ans(Copy(gvar_02536630, 15,                        //A2953..A2987 [704<-708]
            Length(gvar_02536630) - 14), anst);
          trauzTxt := Trim(anst);                            //A298C..A2995 [70]
        end;
      end
      else if Pos('Hque.:', gvar_02536630) > 0 then         //A299F..A29B1 jle->A29FF
      begin
        ans(Copy(gvar_02536630, 15,                            //A29B3..A29EC [6C<-70C]
          Length(gvar_02536630) - 14), anst);
        hqu := Trim(anst);                                     //A29EC [6C]
      end
      else if Pos('Verb.:', gvar_02536630) > 0 then          //A29FF..A2A11 jle->A2A62
      begin
        ans(Copy(gvar_02536630, 15,                          //A2A13..A2A46 [714<-718]
          Length(gvar_02536630) - 14), anst);
        verbind := Trim(anst);                               //A2A4C [84]
      end
      else if Pos('Sdat.:', gvar_02536630) > 0 then          //A2A62..A2A74 jle->A2ACC
      begin
        civiTag := Copy(gvar_02536630, 15, 2);                //A2A76 [9C]
        civiMonat := Copy(gvar_02536630, 17, 2);              //A2A91 [0A0]
        civiJahr := Copy(gvar_02536630, 19, 4);               //A2AAC [0A4]
      end
      else if Pos('Sort.:', gvar_02536630) > 0 then          //A2ACC..A2ADE jle->A2B2F
      begin
        ans(Copy(gvar_02536630, 15,                          //A2AE0..A2B13 [0A8<-71C]
          Length(gvar_02536630) - 14), anst);
        saort := Trim(anst);                                //A2B19 [0A8]
      end
      else if Pos('Strz.:', gvar_02536630) > 0 then          //A2B2F..A2B41 jle->A2B92
      begin
        ans(Copy(gvar_02536630, 15,                          //A2B43..A2B76 [0AC<-720]
          Length(gvar_02536630) - 14), anst);
        satrauz := Trim(anst);                              //A2B7C [0AC]
      end
      else if Pos('Saqu.:', gvar_02536630) > 0 then          //A2B92..A2BA4 jle->A2BF5
      begin
        ans(Copy(gvar_02536630, 15,                          //A2BA6..A2BD9 [0B0<-724]
          Length(gvar_02536630) - 14), anst);
        saqu := Trim(anst);                                 //A2BDF [0B0]
      end
      else if Pos('Schq.:', gvar_02536630) > 0 then          //A2BF5..A2C07 jle->A2C58
      begin
        ans(Copy(gvar_02536630, 15,                          //A2C09..A2C3C [98<-728]
          Length(gvar_02536630) - 14), anst);
        schqu := Trim(anst);                                //A2C42 [98]
      end
      else if ctx = 'adr' then                                //005A2C58..A2C68 jne->A2EE8
      begin
        if adrz = 1 then                                      //A2C6E..A2C72 jne->A2CEB
        begin
          DataModule2.Table1.Edit;                             //A2C74 [0x5C]
          ans(Copy(gvar_02536630, 8,                          //A2C83..A2CB5 [73C]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Adr1.AsString := Trim(anst);       //A2CBC..A2CCD ->5CC
          Inc(adrz);                                           //A2CE8 [ebp-1C]
        end
        else if adrz = 2 then                                 //A2CEB..A2CEF jne->A2D68
        begin
          DataModule2.Table1.Edit;                             //A2CF1 [0x5C]
          ans(Copy(gvar_02536630, 8,                          //A2D00..A2D32 [748]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Adr2.AsString := Trim(anst);       //A2D39..A2D4A ->5D0
          Inc(adrz);                                           //A2D65
        end
        else if adrz = 3 then                                 //A2D68..A2D6C jne->A2DE5
        begin
          DataModule2.Table1.Edit;                             //A2D6E [0x5C]
          ans(Copy(gvar_02536630, 8,                          //A2D7D..A2DA9 [754]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1PLZ.AsString := Trim(anst);        //A2DB6..A2DC7 ->5D4
          Inc(adrz);                                           //A2DE2
        end
        else if adrz = 4 then                                 //A2DE5..A2DE9 jne->A2E62
        begin
          DataModule2.Table1.Edit;                             //A2DEB [0x5C]
          ans(Copy(gvar_02536630, 8,                          //A2DFA..A2E26 [760]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Ort.AsString := Trim(anst);        //A2E33..A2E44 ->5D8
          Inc(adrz);                                           //A2E5F
        end
        else if adrz = 5 then                                 //A2E62..A2E66 jne->A300F
        begin
          DataModule2.Table1.Edit;                             //A2E6C [0x5C]
          ans(Copy(gvar_02536630, 8,                          //A2E7B..A2EA8 [76C]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Adrzus.AsString := Trim(anst);      //A2EB4..A2EC5 ->5DC
          Inc(adrz);                                           //A2EE0
        end;                                                   //A2EE3 jmp->A300F (kein ADR-Zweig)
      end
      else
      begin                                                   //A2EE8 (ctx<>'adr' + kein Keyword)
        DataModule2.Table1.Edit;                              //A2EE8 [0x5C]
        if Trim(DataModule2.Table1Kommentar.AsString) = '' then //A2EF7..A2F27 jne->A2F82
        begin
          ans(Copy(gvar_02536630, 8,                           //A2F29..A2F5D [784->780]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Kommentar.AsString := anst;        //A2F62..A2F77 [780] ->0x5B0
        end
        else
        begin
          ans(Copy(gvar_02536630, 8,                           //A2FA5..A2FD9 [794->790]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Kommentar.AsString :=              //A2F9A..A2FEF catN 3 [788]
            DataModule2.Table1Kommentar.AsString + #13#10 + anst;
        end;
      end;
    end;
    if Pos('CONC ', gvar_02536630) > 0 then                  //005A300F..A3021 jle->A3087
    begin
      DataModule2.Table1Kommentar.AsString :=                //A3023..A3072 [798]
        DataModule2.Table1Kommentar.AsString + Copy(gvar_02536630, 8,  //A303D
          Length(gvar_02536630));
    end;
    { **direkte ADR1..ADR5, ADDR-Kontext-Parser, NOTERest** }
    if Copy(gvar_02536630, 3, 4) = 'ADR1' then               //005A3087..A30B2 jne->A30F9
    begin
      DataModule2.Table1.Edit;                                 //A30B4 [0x5C]
      DataModule2.Table1Adr1.AsString := Copy(gvar_02536630, 8, 40);    //A30C3..A30DE [7A4] ->5CC
    end;
    if Copy(gvar_02536630, 3, 4) = 'ADR2' then               //005A30F9..A3124 jne->A316B
    begin
      DataModule2.Table1.Edit;                                 //A3126 [0x5C]
      DataModule2.Table1Adr2.AsString := Copy(gvar_02536630, 8, 40);    //A3135..A3150
    end;
    if Copy(gvar_02536630, 3, 4) = 'ADR3' then               //005A316B..A3196 jne->A31DD
    begin
      DataModule2.Table1.Edit;                                 //A3198 [0x5C]
      DataModule2.Table1PLZ.AsString := Copy(gvar_02536630, 8, 10);     //A31A7..A31C2
    end;
    if Copy(gvar_02536630, 3, 4) = 'ADR4' then               //005A31DD..A3208 jne->A324F
    begin
      DataModule2.Table1.Edit;                                 //A320A [0x5C]
      DataModule2.Table1Ort.AsString := Copy(gvar_02536630, 8, 40);     //A3219..A3234
    end;
    if Copy(gvar_02536630, 3, 4) = 'ADR5' then               //005A324F..A327A jne->A32C1
    begin
      DataModule2.Table1.Edit;                                 //A327C [0x5C]
      DataModule2.Table1Adrzus.AsString := Copy(gvar_02536630, 8, 40);  //A328B..A32A6
    end;
    if Pos('ADDR', gvar_02536630) > 0 then                   //005A32C1..A32D3 jle->A33B3
    begin
      ctx := 'adr';                                            //005A32D9
      DataModule2.Table1.Edit;                                 //A32E9 [0x5C]
      ans(Copy(gvar_02536630, 8,                              //A32F8..A332C [7D0->7CC]
        Length(gvar_02536630) - 7), anst);
      addrTst := Trim(anst);                                  //A3331..A333D [7C8]
      if addrTst <> '' then                                   //A3342..A3349 jbe->A33B3
      begin
        ans(Copy(gvar_02536630, 8,                            //A334B..A337F [7DC->7D8]
          Length(gvar_02536630) - 7), anst);
        DataModule2.Table1Adr1.AsString := Trim(anst);         //A3384..A33AA [7D4] ->5CC
        Inc(adrz);                                             //A33B0 [ebp-1C]
      end
      { leerer ADDR: adrz bleibt unveraendert }
    end;
    if Pos('PHON', gvar_02536630) > 0 then                   //005A33B3..A33C5 jle->A3424
    begin
      DataModule2.Table1.Edit;                                 //A33C7 [0x5C]
      DataModule2.Table1Tel.AsString := Trim(Copy(gvar_02536630, 8,      //A33D6..A3409 [7E0] ->5F0
        Length(gvar_02536630)));
    end;
    if Pos('EMA', gvar_02536630) > 0 then                    //005A3424..A3436 jle->A3495
    begin
      DataModule2.Table1.Edit;                                 //A3438 [0x5C]
      DataModule2.Table1Ema.AsString := Trim(Copy(gvar_02536630, 7,      //A3447..A347A [7E8] ->5F4
        Length(gvar_02536630)));
    end;
    if Pos('URL', gvar_02536630) > 0 then                    //005A3495..A34A7 jle->A3506
    begin
      DataModule2.Table1.Edit;                                 //A34A9 [0x5C]
      DataModule2.Table1Ur.AsString := Trim(Copy(gvar_02536630, 7,       //A34B8..A34EB [7F0] ->5F8
        Length(gvar_02536630)));
    end;
    if (Pos(' NOTE @', gvar_02536630) > 0) and               //005A3506..A3518 jle->A366D
       (Pos('@', gvar_02536630) = 8) then                    //A351E..A3531 jne->A366D
    begin
      DataModule2.Table1.Edit;                                 //A3537 [0x5C]
      hdr := Trim(Copy(gvar_02536630, 9,                       //A3546..A3568 [0B8<-7F8]
        Length(gvar_02536630)));
      DataModule2.Table26.IndexName := 'alt_';                 //A3579
      if DataModule2.Table26.FindKey([Copy(hdr, 1, Pos('@', hdr) - 1)]) then  //A3590..A35E9 je->A3649
      begin
        DataModule2.Table1Kommentar.AsString :=                //A360A..A362E catN [800|804]
          DataModule2.Table1Kommentar.AsString + DataModule2.Table26Inh.AsString;
      end;
    end;
    if Pos('not marr', gvar_02536630) > 0 then               //005A3649..A365B jle->A366D
      verbind := 'andere Beziehung';                           //A365D [ebp-84]
    if Pos(' NOTE @', gvar_02536630) > 0 then                 //005A366D..A367F jle->A3781
    begin
      if Pos('@', gvar_02536630) = 0 then                     //A3685..A3697 jne->A3781
      begin
        if Trim(Copy(gvar_02536630, 8,                          //A369D..A36DA jbe->A3781
              Length(gvar_02536630) - 7)) <> '' then
        begin
          DataModule2.Table1.Edit;                             //A36E0 [0x5C]
          ans(Copy(gvar_02536630, 8,                           //A370D..A3741 [81C->818]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Kommentar.AsString :=              //A3707..A3761 catN 4 [810]
            DataModule2.Table1Kommentar.AsString + anst + #13#10;
        end;
      end;
    end;
    if Pos(' TEXT', gvar_02536630) > 0 then                   //005A3781..A3793 jle->005A389D
    begin
      if Trim(Copy(gvar_02536630, 8,                          //A3799..A37D6 jbe->A389D
            Length(gvar_02536630) - 7)) <> '' then
      begin
        if ctx <> 'sour' then                                 //A37DC..A37EC je->A389D
        begin
          DataModule2.Table1.Edit;                            //A37FC [0x5C]
          ans(Copy(gvar_02536630, 8,                          //A3819..A3858 [834->830]
            Length(gvar_02536630) - 7), anst);
          DataModule2.Table1Kommentar.AsString :=             //A3819..A387D catN 6 [828]
            DataModule2.Table1Kommentar.AsString + ' [' + anst + ']' + #13#10;
        end;
      end;
    end;
    { **FAM-Block: Bogen-Abschluss auf Level-0 + '@ FAM'-Init (005A389D..A437A)** }
    if Copy(gvar_02536630, 1, 1) = '0' then                        //005A389D..A38C8 jne->A41FF
    begin
      if (mansnr > 0) and (wifesnr > 0) then                       //A38D2/A38DC jle->A3D6B (Ehepaar komplett?)
      begin
        { Bogen 1 (005A38E2..A3D66): Table5-Zeile Nummer=wifesnr/Epnum=mansnr }
        DataModule2.Table5.Append;                                 //005A38E2
        DataModule2.Table5Nummer.AsInteger := wifesnr;             //005A38F4 [410] <- [ebp-24]
        if mansnr > 0 then                                         //005A390C..A3910 jle->A392C
          DataModule2.Table5Epnum.AsInteger := mansnr              //005A3912 [414] <- [ebp-20]
        else
          DataModule2.Table5Epnum.AsInteger := 0;                  //005A392C
        if mansnr > 0 then                                         //005A3943..A3947 jle->A3D08
        begin
          DataModule2.Table5.Edit;                                 //005A394D [0x80]
          DataModule2.Table5Verbind.AsString := verbind;           //005A395F [440]
          DataModule2.Table5Htag.AsString := reliTag;              //005A397A [418]
          DataModule2.Table5Hmonat.AsString := reliMonat;          //005A3992 [41C]
          DataModule2.Table5Hjahr.AsString := reliJahr;            //005A39AA [420]
          DataModule2.Table5Hort.AsString := hort;                 //005A39C2 [424]
          DataModule2.Table5Hqu.AsString := hqu;                   //005A39DA [454]
          DataModule2.Table5Satag.AsString := civiTag;             //005A39F2 [42C]
          DataModule2.Table5Samonat.AsString := civiMonat;         //005A3A0D [430]
          DataModule2.Table5Sajahr.AsString := civiJahr;           //005A3A28 [434]
          DataModule2.Table5Saort.AsString := saort;               //005A3A43 [438]
          DataModule2.Table5Saqu.AsString := saqu;                 //005A3A5E [458]
          DataModule2.Table5Satrauz.AsString := satrauz;           //005A3A79 [43C]
          DataModule2.Table5Schtag.AsString := divTag;             //005A3A94 [444]
          DataModule2.Table5Schmonat.AsString := divMonat;         //005A3AAF [448]
          DataModule2.Table5Schjahr.AsString := divJahr;           //005A3ACA [44C]
          DataModule2.Table5Schort.AsString := schort;             //005A3AE5 [450]
          DataModule2.Table5Schqu.AsString := schqu;               //005A3B00 [45C]
          DataModule2.Table5Trauz.AsString := trauzTxt;            //005A3B1B [428]
          { Level-1-Bogen: Kommentar + Indizes an den WIFE-Personendatensatz }
          DataModule2.Table1.FindKey([wifesnr]);                   //005A3B33..A3B55 (Ergebnis wird nicht geprueft)
          DataModule2.Table1.Edit;                                 //005A3B5A [0x5C]
          if Trim(famkom) <> '' then                               //005A3B69..A3B7E jbe->A3BD6
            DataModule2.Table1Kommentar.AsString :=                //005A3B80..A3BBB catN 4
              DataModule2.Table1Kommentar.AsString + famkom + #13#10;
          try                                                      //005A3BD6 SEH-Rahmen
            DataModule2.Table1.Post;                               //005A3BE4
          except                                                   //005A3C00 jmp @HandleAnyException
          end;                                                     //005A3C05 call @DoneExcept
          DataModule2.Table1.Edit;                                 //005A3C0A
          if DataModule2.Table5Hjahr.AsString <> '' then           //005A3C19..A3C38 jbe->A3CA2
          begin
            DataModule2.Table5Indj.AsString :=                     //005A3C3A..A3C67 [460]
              DataModule2.Table5Hjahr.AsString;
            DataModule2.Table5Indm.AsString :=                     //005A3C6D..A3C9A [464]
              DataModule2.Table5Hmonat.AsString;
          end
          else
          begin
            DataModule2.Table5Indj.AsString :=                     //005A3CA2..A3CCF [460]
              DataModule2.Table5Sajahr.AsString;
            DataModule2.Table5Indm.AsString :=                     //005A3CD5..A3D02 [464]
              DataModule2.Table5Samonat.AsString;
          end;
        end;
        { 005A3D08..A3D66: Table5.Post nur bei Zustandsbyte [9D]=2/3, stiller SEH-Abfang }
        DataModule2.Table5.Post;                                   //005A3D42
        { Bogen 2 (005A3D7F..A41F0): gespiegelt - Nummer=mansnr/Epnum=wifesnr }
        DataModule2.Table5.Append;                                 //005A3D7F
        DataModule2.Table5Nummer.AsInteger := mansnr;              //005A3D91 [410] <- [ebp-20]
        if wifesnr > 0 then                                        //005A3DA9..A3DAD jle->A3DC9
          DataModule2.Table5Epnum.AsInteger := wifesnr             //005A3DAF [414] <- [ebp-24]
        else
          DataModule2.Table5Epnum.AsInteger := 0;                  //005A3DC9
        if wifesnr > 0 then                                        //005A3DE0..A3DE4 jle->A41A5
        begin
          DataModule2.Table5.Edit;                                 //005A3DEA [0x80]
          DataModule2.Table5Verbind.AsString := verbind;           //005A3DFC [440]
          DataModule2.Table5Htag.AsString := reliTag;              //005A3E17 [418]
          DataModule2.Table5Hmonat.AsString := reliMonat;          //005A3E2F [41C]
          DataModule2.Table5Hjahr.AsString := reliJahr;            //005A3E47 [420]
          DataModule2.Table5Hort.AsString := hort;                 //005A3E5F [424]
          DataModule2.Table5Hqu.AsString := hqu;                   //005A3E77 [454]
          DataModule2.Table5Satag.AsString := civiTag;             //005A3E8F [42C]
          DataModule2.Table5Samonat.AsString := civiMonat;         //005A3EAA [430]
          DataModule2.Table5Sajahr.AsString := civiJahr;           //005A3EC5 [434]
          DataModule2.Table5Saort.AsString := saort;               //005A3EE0 [438]
          DataModule2.Table5Satrauz.AsString := satrauz;           //005A3EFB [43C]
          DataModule2.Table5Saqu.AsString := saqu;                 //005A3F16 [458]
          DataModule2.Table5Schtag.AsString := divTag;             //005A3F31 [444]
          DataModule2.Table5Schmonat.AsString := divMonat;         //005A3F4C [448]
          DataModule2.Table5Schjahr.AsString := divJahr;           //005A3F67 [44C]
          DataModule2.Table5Schort.AsString := schort;             //005A3F82 [450]
          DataModule2.Table5Schqu.AsString := schqu;               //005A3F9D [45C]
          DataModule2.Table5Trauz.AsString := trauzTxt;            //005A3FB8 [428]
          { Level-1-Bogen: Kommentar + Indizes an den HUSB-Personendatensatz }
          DataModule2.Table1.FindKey([mansnr]);                    //005A3FD0..A3FE0 (Ergebnis wird nicht geprueft)
          DataModule2.Table1.Edit;                                 //005A3FF7 [0x5C]
          if Trim(famkom) <> '' then                               //005A4006..A401B jbe->A4073
            DataModule2.Table1Kommentar.AsString :=                //005A401D..A4058 catN 4
              DataModule2.Table1Kommentar.AsString + famkom + #13#10;
          try                                                      //005A4073 SEH-Rahmen
            DataModule2.Table1.Post;                               //005A4081
          except                                                   //005A409D jmp @HandleAnyException
          end;                                                     //005A40A2 call @DoneExcept
          DataModule2.Table1.Edit;                                 //005A40A7
          if DataModule2.Table5Hjahr.AsString <> '' then           //005A40B6..A40D5 jbe->A413F
          begin
            DataModule2.Table5Indj.AsString :=                     //005A40D7..A40EF [460]
              DataModule2.Table5Hjahr.AsString;
            DataModule2.Table5Indm.AsString :=                     //005A410A..A4122 [464]
              DataModule2.Table5Hmonat.AsString;
          end
          else
          begin
            DataModule2.Table5Indj.AsString :=                     //005A413F..A4157 [460]
              DataModule2.Table5Sajahr.AsString;
            DataModule2.Table5Indm.AsString :=                     //005A4172..A418A [464]
              DataModule2.Table5Samonat.AsString;
          end;
        end;
        { 005A41A5..A41F0: Table5.Post nur wenn [9D]-2 < 2 unsigned, d.h. [9D] in 2..3 }
        DataModule2.Table5.Post;                                   //005A41CC
      end;
      { Level-0 schliesst den FAM-Bogen ab: Nummern zuruecksetzen }
      mansnr := 0;                                                 //005A41F5..A41FC
      wifesnr := 0;
    end;
    { **'0 @ FAM ...': FAM-Beginn - Kontext + Snapshots zuruecksetzen (005A41FF..A4375)** }
    if Pos('@ FAM', gvar_02536630) > 0 then                       //005A41FF..A4211 jle->A437A
    begin
      ctx := 'fam';                                               //005A4217 [ebp-0C0]
      kid := 0;                                                   //005A4229 [ebp-40]
      husbfound := 0;                                             //005A422E [ebp-38]
      verbind := 'Eheschliessung';                                //005A4231 [ebp-84]
      husnrTxt := '';                                             //005A4241 [ebp-50]
      wifnrTxt := '';                                             //005A4249 [ebp-54]
      mansnr := 0;                                                //005A4251 [ebp-20]
      wifesnr := 0;                                               //005A4256 [ebp-24]
      chnrTxt := '';                                              //005A425B [ebp-58]
      reliTag := '';                                              //005A4263 [ebp-5C]
      reliMonat := '';                                            //005A426B [ebp-60]
      reliJahr := '';                                             //005A4273 [ebp-64]
      hort := '';                                                 //005A427B [ebp-68]
      hqu := '';                                                  //005A4283 [ebp-6C]
      trauzTxt := '';                                             //005A428B [ebp-70]
      civiTag := '';                                              //005A4293 [ebp-9C]
      civiMonat := '';                                            //005A429E [ebp-0A0]
      civiJahr := '';                                             //005A42A9 [ebp-0A4]
      saort := '';                                                //005A42B4 [ebp-0A8]
      satrauz := '';                                              //005A42BF [ebp-0AC]
      saqu := '';                                                 //005A42CA [ebp-0B0]
      famkom := '';                                               //005A42D5 [ebp-74]
      divTag := '';                                               //005A42DD [ebp-88]
      divMonat := '';                                             //005A42E8 [ebp-8C]
      divJahr := '';                                              //005A42F3 [ebp-90]
      schort := '';                                               //005A42FE [ebp-94]
      schqu := '';                                                //005A4309 [ebp-98]
      { Fortschritt: % des Dateizeigers }
      gvar_02536668 := gvar_02536668 + 1;                         //005A4314 inc dword / fild (Integer-inkrement)
      Form1.Label18.Caption :=                                    //005A431A..A4363 SetText [Form1+400]
        IntToStr(Round(gvar_02536668 / gvar_0253666C * 100)) + ' %';
      Form1.Label18.Refresh;                                      //005A4368..A4375
    end;
    { **klist-Scan: 6-stelliger Schluessel der Zeile in der ADOP/FAMC-Liste (005A437A..A43F0)** }
    anst := Copy(gvar_02536630, 5,                                //005A437A..A439A [ebp-888]
      Length(gvar_02536630) - 9);
    anst := '000000' + anst;                                      //005A439F..A43B0 Cat3 [ebp-884]
    anst := RightStr(anst, 6);                                    //005A43B5..A43C6 [ebp-880]
    anst := anst + '*';                                           //005A43CB..A43D6 Cat
    if Pos(anst, klist) > 0 then                                  //005A43DB..A43EE jle->A43F7
      husbfound := 1;                                             //005A43F0 [ebp-38]
    { **'1 HUSB'** }
    if Copy(gvar_02536630, 3, 4) = 'HUSB' then                    //005A43F7..A4422 jne->A45B0
    begin
      husnrTxt := Copy(gvar_02536630,                             //005A4428..A447A [ebp-50]
        Pos('@I', gvar_02536630) + 2,
        Length(Trim(gvar_02536630)) - Pos('@I', gvar_02536630) - 2);
      if Copy(gvar_02536630, 9, 1) <> 'I' then                    //005A447F..A44AA je->A44FF
        husnrTxt := Copy(gvar_02536630,                           //005A44AC..A44FA [ebp-50]
          Pos('@', gvar_02536630) + 1,
          Length(Trim(gvar_02536630)) - Pos('@', gvar_02536630) - 1);
      if DataModule2.Table25.FindKey([StrToInt(husnrTxt)]) then   //005A44FF..A4529 je->A4547
        mansnr := DataModule2.Table25N.AsInteger;                 //005A4532..A4544 [ebp-20] <- [308]
      sub_00576EB0(mansnr, anst);                                 //005A4547..A4550 [ebp-89C]
      anst := anst + '*';                                         //005A4555..A4560 Cat
      if Pos(anst, huslist) > 0 then                              //005A4565..A4578 jle->A4581
        kid := 20;                                                //005A457A [ebp-40]
      sub_00576EB0(mansnr, anst);                                 //005A4581..A4590 [ebp-8A0]
      huslist := huslist + anst + '*';                            //005A4595..A45AB CatN 3 [ebp-0C4]
    end;
    { **'1 WIFE'** }
    if Copy(gvar_02536630, 3, 4) = 'WIFE' then                    //005A45B0..A45DB jne->A4795
    begin
      wifnrTxt := Copy(gvar_02536630,                             //005A45E1..A4633 [ebp-54]
        Pos('@I', gvar_02536630) + 2,
        Length(Trim(gvar_02536630)) - Pos('@I', gvar_02536630) - 2);
      if Copy(gvar_02536630, 9, 1) <> 'I' then                    //005A4638..A4663 je->A46B8
        wifnrTxt := Copy(gvar_02536630,                           //005A4665..A46B3 [ebp-54]
          Pos('@', gvar_02536630) + 1,
          Length(Trim(gvar_02536630)) - Pos('@', gvar_02536630) - 1);
      if DataModule2.Table25.FindKey([StrToInt(wifnrTxt)]) then   //005A46B8..A46E9 je->A4700
        wifesnr := DataModule2.Table25N.AsInteger;                //005A46EB..A46FD [ebp-24] <- [308]
      sub_00576EB0(wifesnr, anst);                                //005A4700..A470E [ebp-8B4]
      anst := anst + '*';                                         //005A470E..A4719 Cat
      if Pos(anst, wifelist) > 0 then                             //005A471E..A4731 jle->A473A
        kid := 20;                                                //005A4733 [ebp-40]
      sub_00576EB0(wifesnr, anst);                                //005A473A..A4749 [ebp-8B8]
      wifelist := wifelist + anst + '*';                          //005A474E..A4764 CatN 3 [ebp-0C8]
      if (mansnr > 0) and (wifesnr > 0) then                      //005A4769..A4773 jle->A4795
      begin
        ctx := 'fam_reli';                                        //005A4775
        verbind := 'Eheschliessung';                              //005A4785
      end;
    end;
    { **A4795: Verwandtschaftstabelle je Zeile oeffnen + '1 CHIL'-Block** }
    DataModule2.Table31.Open;                                     //005A4795 [0x2A4]
    if Copy(gvar_02536630, 3, 4) = 'CHIL' then                    //005A47A7..A47D2 jne->A4B4E
    begin
      chnrTxt := Copy(gvar_02536630,                              //005A47D8..A482A [ebp-58]
        Pos('@I', gvar_02536630) + 2,
        Length(Trim(gvar_02536630)) - Pos('@I', gvar_02536630) - 2);
      if Copy(gvar_02536630, 9, 1) <> 'I' then                    //005A482F..A485A je->A48AF
        chnrTxt := Copy(gvar_02536630,                            //005A485C..A48AC [ebp-58]
          Pos('@', gvar_02536630) + 1,
          Length(Trim(gvar_02536630)) - Pos('@', gvar_02536630) - 1);
      if DataModule2.Table25.FindKey([StrToInt(chnrTxt)]) then    //005A48AF..A48C4 je->A4B4E
      begin
        if DataModule2.Table1.FindKey([                          //005A48E6..A4905 je->A4B4E
          DataModule2.Table25N.AsInteger]) then
        begin
          kid := kid + 1;                                         //005A4924 [ebp-40]
          DataModule2.Table1.Edit;                                //005A4927 [0x5C]
          anst := RightStr('0000' + IntToStr(kid), 4);            //005A4936..A496B [ebp-8D4/8D0/8CC]
          DataModule2.Table1Indj.AsString := anst;                //005A4970..A4985 [5E0]
          DataModule2.Table1Indm.AsString := '';                  //005A498B..A499C [5E4] (edx=0)
          DataModule2.Table1Indt.AsString := '';                  //005A49A2..A49B3 [5E8] (edx=0)
          if husbfound = 1 then                                   //005A49B9..A49BD jne->A4AB4
          begin
            { Kind ist zugleich HUSB: Kistat='V' + Table31-Zeile (Av/Am) }
            DataModule2.Table1.Edit;                              //005A49C3 [0x5C]
            DataModule2.Table1Kistat.AsString := 'V';             //005A49D2 [5C4]
            try                                                   //005A49EC SEH-Rahmen
              DataModule2.Table1.Post;                            //005A49FA
            except                                                //005A4A16 jmp @HandleAnyException
            end;                                                  //005A4A1B call @DoneExcept
            DataModule2.Table1.Edit;                              //005A4A20
            DataModule2.Table31.Append;                           //005A4A2F [0x2A4]
            DataModule2.Table31Nummer.AsInteger :=                //005A4A41..A4A64 [2AC] <- [308]
              DataModule2.Table25N.AsInteger;
            DataModule2.Table31Av.AsInteger := mansnr;            //005A4A6A [2B0] <- [ebp-20]
            DataModule2.Table31Am.AsInteger := wifesnr;           //005A4A82 [2B4] <- [ebp-24]
            DataModule2.Table31.Post;                             //005A4A9A
          end
          else
          begin
            DataModule2.Table1.Edit;                              //005A4AB4 [0x5C]
            if (husnrTxt <> '') or (wifnrTxt <> '') then          //005A4AC3..A4ACD jbe->A4B0B
            begin
              if mansnr > 0 then                                  //005A4ACF..A4AD3 jle->A4AED
                DataModule2.Table1Vater.AsInteger := mansnr;      //005A4AD5 [538]
              if wifesnr > 0 then                                 //005A4AED..A4AF1 jle->A4B0B
                DataModule2.Table1Mutter.AsInteger := wifesnr;    //005A4AF3 [53C]
            end;
            try                                                   //005A4B0B SEH-Rahmen
              DataModule2.Table1.Post;                            //005A4B19
            except                                                //005A4B35 jmp @HandleAnyException
            end;                                                  //005A4B3A call @DoneExcept
            DataModule2.Table1.Edit;                              //005A4B3F
          end;
        end;
      end;
    end;
    { **'1 MARR'/'2 TYPE RELI'/'2 TYPE CIVI'/'DIV' + _WITN-Snapshots (005A4B4E..A4CA1)** }
    if Pos('1 MARR', gvar_02536630) > 0 then                      //005A4B4E..A4B60 jle->A4B8B
    begin
      ctx := 'fam_reli';                                          //005A4B62..A4B6D
      if verbind = '' then                                        //005A4B72..A4B79 jne->A4B8B
        verbind := 'Eheschliessung';                              //005A4B7B..A4B86
    end;
    if Pos('2 TYPE RELI', gvar_02536630) > 0 then                 //005A4B8B..A4B9D jle->A4BAF
      ctx := 'fam_reli';                                          //005A4B9F..A4BAA
    if (ctx = 'fam_reli') and                                     //005A4BAF..A4BBF jne->A4C05
       (Pos('_WITN', gvar_02536630) > 0) then                     //005A4BC1..A4BD3 jle->A4C05
      trauzTxt := Trim(Copy(gvar_02536630, 9,                     //005A4BD5..A4C00 -> [ebp-70]
        Length(gvar_02536630)));
    if Pos('2 TYPE CIVI', gvar_02536630) > 0 then                 //005A4C05..A4C17 jle->A4C29
      ctx := 'fam_civi';                                          //005A4C19..A4C24
    if (ctx = 'fam_civi') and                                     //005A4C29..A4C39 jne->A4C82
       (Pos('_WITN', gvar_02536630) > 0) then                     //005A4C3B..A4C4D jle->A4C82
      satrauz := Trim(Copy(gvar_02536630, 9,                      //005A4C4F..A4C7D -> [ebp-0AC]
        Length(gvar_02536630)));
    if Pos('DIV', gvar_02536630) > 0 then                         //005A4C82..A4C94 jle->A4CA6
      ctx := 'fam_div';                                           //005A4C96..A4CA1
    { **'@ _LOC': Rest des Blocks einlesen bis keine '1 ...'-Zeile mehr (005A4CA6..A4D3E)** }
    if Pos('@ _LOC', gvar_02536630) > 0 then                      //005A4CA6..A4CB8 jle->A4D40
    begin
      ctx := '_loc';                                              //005A4CBE..A4CC9
      ReadLn(gvar_02536630);                                      //005A4CCE..A4CE7 @ReadLString+ReadLn+IOTest
      while Copy(gvar_02536630, 1, 1) = '1' do                    //005A4D13..A4D3E je->A4CEE
      begin
        ReadLn(gvar_02536630);                                    //005A4CEE..A4D07
        rdflag := 1;                                              //005A4D0C [ebp-28]
      end;
    end;
    { **Leseroutine der Schleife: naechste Zeile + UTF-8-Umsetzung (005A4D40..A4D7C)** }
    if rdflag = 0 then                                            //005A4D40..A4D44 jne->A4D64
      ReadLn(gvar_02536630);                                      //005A4D46..A4D5F
    rdflag := 0;                                                  //005A4D64 [ebp-28]
    if utfflag = 1 then                                           //005A4D69..A4D6D jne->A4D7E
      gvar_02536630 := Utf8ToAnsi(gvar_02536630);                 //005A4D6F..A4D79
    { **'0 TRLR': letzte Zeile - FAM-Bogen wird noch einmal aus Table5 geschrieben (005A4D7E..A4DEA)** }
    if Copy(ucase(Trim(gvar_02536630)), 1, 6) = '0 TRLR' then     //005A4D7E..A4DD2 jne->A571D
    begin
      if Pos('fam', ctx) > 0 then                                  //005A4DD8..A4DEA jle->A5777
      begin
        if (wifesnr > 0) and (mansnr > 0) then                     //005A4DF0/A4DFA jle->A528D
        begin
          { Bogen 1 (005A4E04..A5288): Table5-Zeile Nummer=wifesnr/Epnum=mansnr }
          DataModule2.Table5.Append;                               //005A4E04
          DataModule2.Table5Nummer.AsInteger := wifesnr;           //005A4E16 [410] <- [ebp-24]
          if mansnr > 0 then                                       //005A4E2E..A4E32 jle->A4E4E
            DataModule2.Table5Epnum.AsInteger := mansnr            //005A4E34 [414] <- [ebp-20]
          else
            DataModule2.Table5Epnum.AsInteger := 0;                //005A4E4E
          if mansnr > 0 then                                       //005A4E65..A4E69 jle->A522A
          begin
            DataModule2.Table5.Edit;                               //005A4E6F [0x80]
            DataModule2.Table5Verbind.AsString := verbind;         //005A4E81 [440]
            DataModule2.Table5Htag.AsString := reliTag;            //005A4E9C [418]
            DataModule2.Table5Hmonat.AsString := reliMonat;        //005A4EB4 [41C]
            DataModule2.Table5Hjahr.AsString := reliJahr;          //005A4ECC [420]
            DataModule2.Table5Hort.AsString := hort;               //005A4EE4 [424]
            DataModule2.Table5Hqu.AsString := hqu;                 //005A4EFC [454]
            DataModule2.Table5Satag.AsString := civiTag;           //005A4F14 [42C]
            DataModule2.Table5Samonat.AsString := civiMonat;       //005A4F2F [430]
            DataModule2.Table5Sajahr.AsString := civiJahr;         //005A4F4A [434]
            DataModule2.Table5Saort.AsString := saort;             //005A4F65 [438]
            DataModule2.Table5Saqu.AsString := saqu;               //005A4F80 [458]
            DataModule2.Table5Satrauz.AsString := satrauz;         //005A4F9B [43C]
            DataModule2.Table5Schtag.AsString := divTag;           //005A4FB6 [444]
            DataModule2.Table5Schmonat.AsString := divMonat;       //005A4FD1 [448]
            DataModule2.Table5Schjahr.AsString := divJahr;         //005A4FEC [44C]
            DataModule2.Table5Schort.AsString := schort;           //005A5007 [450]
            DataModule2.Table5Schqu.AsString := schqu;             //005A5022 [45C]
            DataModule2.Table5Trauz.AsString := trauzTxt;          //005A503D [428]
            DataModule2.Table1.FindKey([wifesnr]);                 //005A5055..A5065 (Ergebnis ungeprueft)
            DataModule2.Table1.Edit;                               //005A507C [0x5C]
            if Trim(famkom) <> '' then                             //005A508B..A50A0 jbe->A50F8
              DataModule2.Table1Kommentar.AsString :=              //005A50A2..A50DD catN 4
                DataModule2.Table1Kommentar.AsString + famkom + #13#10;
            try                                                    //005A50F8 SEH-Rahmen
              DataModule2.Table1.Post;                             //005A5106
            except                                                 //005A5122 jmp @HandleAnyException
            end;                                                   //005A5127 call @DoneExcept
            DataModule2.Table1.Edit;                               //005A512C
            if DataModule2.Table5Hjahr.AsString <> '' then         //005A513B..A515A jbe->A51C4
            begin
              DataModule2.Table5Indj.AsString :=                   //005A515C..A5174 [460]
                DataModule2.Table5Hjahr.AsString;
              DataModule2.Table5Indm.AsString :=                   //005A518F..A51A7 [464]
                DataModule2.Table5Hmonat.AsString;
            end
            else
            begin
              DataModule2.Table5Indj.AsString :=                   //005A51C4..A51DC [460]
                DataModule2.Table5Sajahr.AsString;
              DataModule2.Table5Indm.AsString :=                   //005A51F7..A520F [464]
                DataModule2.Table5Samonat.AsString;
            end;
          end;
          { 005A522A..A5288: Table5.Post nur bei Zustandsbyte [9D]=2/3 }
          DataModule2.Table5.Post;                                 //005A5264
        end;
        if (mansnr > 0) and (wifesnr > 0) then                     //005A528D..A529B jle->A5777
        begin
          { Bogen 2 (005A52A1..A571B): gespiegelt - Nummer=mansnr/Epnum=wifesnr }
          DataModule2.Table5.Append;                               //005A52A1
          DataModule2.Table5Nummer.AsInteger := mansnr;            //005A52B3 [410] <- [ebp-20]
          if wifesnr > 0 then                                      //005A52CB..A52CF jle->A52EB
            DataModule2.Table5Epnum.AsInteger := wifesnr           //005A52D1 [414] <- [ebp-24]
          else
            DataModule2.Table5Epnum.AsInteger := 0;                //005A52EB
          if wifesnr > 0 then                                      //005A5302..A5306 jle->A56C7
          begin
            DataModule2.Table5.Edit;                               //005A530C [0x80]
            DataModule2.Table5Verbind.AsString := verbind;         //005A531E [440]
            DataModule2.Table5Htag.AsString := reliTag;            //005A5339 [418]
            DataModule2.Table5Hmonat.AsString := reliMonat;        //005A5351 [41C]
            DataModule2.Table5Hjahr.AsString := reliJahr;          //005A5369 [420]
            DataModule2.Table5Hort.AsString := hort;               //005A5381 [424]
            DataModule2.Table5Hqu.AsString := hqu;                 //005A5399 [454]
            DataModule2.Table5Satag.AsString := civiTag;           //005A53B1 [42C]
            DataModule2.Table5Samonat.AsString := civiMonat;       //005A53CC [430]
            DataModule2.Table5Sajahr.AsString := civiJahr;         //005A53E7 [434]
            DataModule2.Table5Saort.AsString := saort;             //005A5402 [438]
            DataModule2.Table5Satrauz.AsString := satrauz;         //005A541D [43C]
            DataModule2.Table5Saqu.AsString := saqu;               //005A5438 [458]
            DataModule2.Table5Schtag.AsString := divTag;           //005A5453 [444]
            DataModule2.Table5Schmonat.AsString := divMonat;       //005A546E [448]
            DataModule2.Table5Schjahr.AsString := divJahr;         //005A5489 [44C]
            DataModule2.Table5Schort.AsString := schort;           //005A54A4 [450]
            DataModule2.Table5Schqu.AsString := schqu;             //005A54BF [45C]
            DataModule2.Table5Trauz.AsString := trauzTxt;          //005A54DA [428]
            DataModule2.Table1.FindKey([mansnr]);                  //005A54F2..A5502 (Ergebnis ungeprueft)
            DataModule2.Table1.Edit;                               //005A5519 [0x5C]
            if Trim(famkom) <> '' then                             //005A5528..A553D jbe->A5595
              DataModule2.Table1Kommentar.AsString :=              //005A553F..A557A catN 4
                DataModule2.Table1Kommentar.AsString + famkom + #13#10;
            try                                                    //005A5595 SEH-Rahmen
              DataModule2.Table1.Post;                             //005A55A3
            except                                                 //005A55BF jmp @HandleAnyException
            end;                                                   //005A55C4 call @DoneExcept
            DataModule2.Table1.Edit;                               //005A55C9
            if DataModule2.Table5Hjahr.AsString <> '' then         //005A55D8..A55F7 jbe->A5661
            begin
              DataModule2.Table5Indj.AsString :=                   //005A55F9..A5611 [460]
                DataModule2.Table5Hjahr.AsString;
              DataModule2.Table5Indm.AsString :=                   //005A562C..A5644 [464]
                DataModule2.Table5Hmonat.AsString;
            end
            else
            begin
              DataModule2.Table5Indj.AsString :=                   //005A5661..A5679 [460]
                DataModule2.Table5Sajahr.AsString;
              DataModule2.Table5Indm.AsString :=                   //005A5694..A56AC [464]
                DataModule2.Table5Samonat.AsString;
            end;
          end;
          { 005A56C7..A571B: Table5.Post nur wenn [9D] in 2..3 }
          DataModule2.Table5.Post;                                 //005A56F2
        end;
      end;
    end;
  end; // while-Schluss: Ruecksprung nach 0059EFC7 (Bedingung 005A571D..A5771)

  { **Abschluss (005A5777..A57D0): UI aus, Datei zu, Listen neu ** }
  Form1.Label18.Visible := False;                                 //005A5777..A5786 SetVisible(0)
  Form1.Label19.Visible := False;                                 //005A578B..A579A
  CloseFile(gvar_02536458);                                       //005A579F..A57A9 @Close+@_IOTest
  ChDir(gvar_02536B9C);                                           //005A57AE..A57B5
  Form1.listen_akt;                                               //005A57BA..A57C1
  DataModule2.Table1.First;                                       //005A57C6..A57D0
  { SEH-Rahmen/Prolog-Teardown (005A57D5..58A9: 12x @LStrArrayClr/@LStrClr ab
    [ebp-938], jmp @HandleFinally, Epilog pop edi/esi/ebx) - nicht transkribiert. }
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
var
  f: TextFile;                  {005A7C5B [ebp-20C] Export-Textdatei (lokal, nicht gvar_02536458)}
  fname: AnsiString;            {005A7D73 [ebp-210] SaveDialog1.FileName}
  tbl: TTable;                  {005A7CB0 [edi] Tabelle der Form26-Radiogruppe (uninitialisiert, wenn nur Radio2)}
  sektion: AnsiString;          {005A7CA1 [ebp-18] toter Merker 'nummer'/'nn' (4x geschrieben, nie gelesen)}
  dead1: AnsiString;            {005A7EF9 [ebp-2C] toter String (einziges Vorkommen := '')}
  dead2: AnsiString;            {005A8E0B [ebp-24] toter String (einziges Vorkommen := '')}
  dead3: AnsiString;            {005A8E4C [ebp-34] toter String (einziges Vorkommen := '')}
  st4, st5: AnsiString;         {005A7F51..FD7 DateToStr-Zwischenspeicher}
  stVon: AnsiString;            {005ADC86 [ebp-3C] '3 DATE '-Zeitraum FROM/TO (gedausv: stVon [ebp-24])}
  tag, monat, jahr: AnsiString; {005A7F68..FEC Copy-Ergebnisse (Tag/Monat/Jahr)}
  dat: AnsiString;              {005A7FF1 [ebp-218] sub_00582C24-Ergebnis}
  u: AnsiString;                {005A7FFE [ebp-214] '1 DATE '-Zeile}
  anz: Integer;                 {005A891C [ebp-10] Table1.RecordCount}
  krg: Integer;                 {005A892C [ebp-20] Start-Record (Table1Nummer)}
  kz: Integer;                  {005A8E04 [ebp-8] Person-Zaehler (Start 1)}
  gef: Integer;                 {005A8A26 [edi] 1 = Paar in Table10 gefunden}
  locList: AnsiString;          {005A8E44 [ebp-30] '*'-Liste der _LOC-Nummern}
  notiz: Integer;               {005A8EE0 [ebp-14] Merker pro Person (Start 0; gedausv haelt ihn in edi)}
  nm: AnsiString;               {005A8F45 [ebp-38] Vornamen getrimmt, '!' entfernt}
  plac: AnsiString;             {005A9887 [ebp-1C] '2 PLAC '-String (Ort,Lkr,Bland,Land)}
begin
  { 005A7C40: gedaus - GEDCOM-Export (5.5.1) in die ueber SaveDialog1
    gewaehlte Datei. Zuerst wertet die Form26-Radiogruppe die Sortierung aus
    (Table24/Index 'dsn', Table1 ohne Index), dann folgen der
    SaveDialog-Dialog-Setup (DefaultExt/Filter/Options) mit Rewrite(f), der
    HEAD-/CHAR-Block (Form27-Radios steuern gvar_02536654/6650), die
    Kopfzeilen SOUR/VERS/DEST/DATE/FILE/SUBM/GEDC/PLAC/LANG und der
    SUBM-Adressblock aus den Form27-Edits (UTF-8-Zweig via AnsiToUtf8).
    Danach UI-Status, Vorbereitung ("andere Beziehung"-Vorlauf ueber
    Table10, optionaler Jahresfilter) und der Personenschleifen-Lauf.
    SEH-Rahmen/Prolog-Teardown (@LStrArrayClr/@LStrClr ab 005AE7B3) - nicht
    transkribiert. }

  //005A7C6F..C79 DataModule2.Table1Nummer.AsInteger - Ergebnis ungenutzt
  Form1.Invalidate;                                  //005A7C7C..C85 TControl.Invalidate vtbl+7C
  if Form26.RadioButton1.Checked then                //005A7C88..C9F Checked vtbl+0C4
  begin
    sektion := 'nummer';                             //005A7CA1 [ebp-18]
    tbl := DataModule2.Table24;                      //005A7CAE..CB0 [1D0]
    tbl.IndexName := 'dsn';                          //005A7CB6..CBD
  end;
  if Form26.RadioButton2.Checked then                //005A7CC2..CD9
    sektion := 'nummer';                             //005A7CDB [ebp-18] tbl bleibt unveraendert
  if Form26.RadioButton3.Checked then                //005A7CE8..CFF
  begin
    sektion := 'nummer';                             //005A7D01 [ebp-18]
    tbl := DataModule2.Table1;                       //005A7D0E..D10 [5C]
    tbl.IndexName := '';                             //005A7D13..D17 xor edx = ''
  end;
  Form26.Hide;                                       //005A7D1C..D23 TCustomForm.Hide
  Form26.ModalResult := 2;                           //005A7D28..D2F [24C] FModalResult
  Form1.Refresh;                                     //005A7D39..D40 TControl.Refresh
  if gvar_0253692C = 'Over' then                     //005A7D45..D56
    sektion := 'nn';                                 //005A7D58 [ebp-18]
  if tbl = DataModule2.Table5 then                   //005A7D65..D6D je->005AE7B3
    Exit;                                            //   Epilog (Abbruch ohne Export)
  fname := Form1.SaveDialog1.FileName;               //005A7D73..D86 GetFileName +3FC
  System.Assign(f, fname);                           //005A7D8B..D93 @Assign auf [ebp-20C]
  Form1.SaveDialog1.DefaultExt := 'ged';             //005A7D98..DAD [74]
  Form1.SaveDialog1.Filter := 'Gedcom-Dateien (*.ged)|*.ged'; //005A7DB2..DC7 [60]
  Form1.SaveDialog1.Options := [ofHideReadOnly];     //005A7DCC..DDF [5C] := 2
  Rewrite(f);                                        //005A7DE2..DE9 @RewritText + @_IOTest
  if Form27.RadioButton2.Checked then                //005A7DEE..E05
    WriteLn(f, #$EF#$BB#$BF'0 HEAD')                 //005A7E07 BOM + '0 HEAD'
  else
    WriteLn(f, '0 HEAD');                            //005A7E1F
  gvar_02536654 := 0;                                //005A7E35..E37
  gvar_02536650 := 0;                                //005A7E3C..E3E
  gvar_02536658 := 0;                                //005A7E43..E45
  if Form27.RadioButton1.Checked then                //005A7E4A..E61
  begin
    gvar_02536654 := 1;                              //005A7E63
    WriteLn(f, '1 CHAR ANSI');                       //005A7E6D
  end
  else if Form27.RadioButton2.Checked then           //005A7E85..E9C
  begin
    gvar_02536650 := 1;                              //005A7E9E
    WriteLn(f, '1 CHAR UTF-8');                      //005A7EA8
  end
  else if Form27.RadioButton3.Checked then           //005A7EC0..ED7
  begin
    gvar_02536650 := 1;                              //005A7ED9
    WriteLn(f, '1 CHAR Unicode');                    //005A7EE3
  end;
  dead1 := '';                                       //005A7EF9 [ebp-2C] toter String
  WriteLn(f, '1 SOUR AHNENWIN');                     //005A7F01
  WriteLn(f, '2 VERS 5.1');                          //005A7F17
  WriteLn(f, '1 DEST OTHER');                        //005A7F2D
  st4 := DateToStr(Date);                            //005A7F43..F63
  jahr := Copy(st4, 7, 4);                           //005A7F68..F78 [ebp-21C]
  st5 := DateToStr(Date);                            //005A7F7D..F9D
  monat := Copy(st5, 4, 2);                          //005A7FA2..FB2 [ebp-224]
  st4 := DateToStr(Date);                            //005A7FB7..FD7
  tag := Copy(st4, 1, 2);                            //005A7FDC..FEC [ebp-22C]
  dat := sub_00582C24(tag, monat, jahr);             //005A7FF1..FF9 [ebp-218]
  u := '1 DATE ' + dat;                              //005A7FFE..800F Cat3 [ebp-214]
  WriteLn(f, u);                                     //005A8014..8026
  if gvar_02536650 = 1 then                                 //005A802B..8032 jne->809D
  begin
    u := '1 FILE ' + AnsiToUtf8(                           //005A8034..806E CatN3
      ExtractFileName(Form1.SaveDialog1.FileName));        //   [ebp-240/23C/238]
    WriteLn(f, u);                                         //005A8084
  end
  else
  begin
    u := '1 FILE ' + ExtractFileName(                      //005A809D..80C6 CatN3
      Form1.SaveDialog1.FileName);                         //   [ebp-24C/248]
    WriteLn(f, u);                                         //005A80DC
  end;
  WriteLn(f, '1 SUBM @S0@');                               //005A80F3
  WriteLn(f, '1 GEDC');                                    //005A8109
  WriteLn(f, '2 VERS 5.5.1');                              //005A811F
  WriteLn(f, '2 FORM LINEAGE-LINKED');                     //005A8135
  WriteLn(f, '1 PLAC');                                    //005A814B
  WriteLn(f, '2 FORM place, county, state, country');      //005A8161
  { SUBM-Block: Adressdaten aus den Form27-Edits, im UTF-8-Zweig konvertiert }
  if gvar_02536650 = 1 then                                 //005A8177..817E jne->8556
  begin
    WriteLn(f, '1 LANG German');                           //005A8184
    if Trim(Form27.Edit1.Text) <> '' then                  //005A819A..81CA jbe->8514
    begin
      WriteLn(f, AnsiToUtf8('0 @S0@ SUBM'));               //005A81D0..81E0
      WriteLn(f, '1 ADDR');                                //005A81F7
      u := '2 ADR1 ' + AnsiToUtf8(Form27.Edit1.Text);      //005A820D..8236 CatN3
      WriteLn(f, u);                                       //005A824C
      if Trim(Form27.Edit2.Text) <> '' then                //005A8263..8293 jbe->82EB
      begin
        u := '2 ADR2 ' + AnsiToUtf8(Form27.Edit2.Text);    //005A8295..82BE CatN3
        WriteLn(f, u);                                     //005A82D4
      end;
      if Trim(Form27.Edit3.Text) <> '' then                //005A82EB..831B jbe->8373
      begin
        u := '1 POST ' + AnsiToUtf8(Form27.Edit3.Text);    //005A831D..8346 CatN3
        WriteLn(f, u);                                     //005A835C
      end;
      if Trim(Form27.Edit5.Text) <> '' then                //005A8373..83A3 jbe->83FB
      begin
        u := '1 CITY ' + AnsiToUtf8(Form27.Edit5.Text);    //005A83A5..83CE CatN3
        WriteLn(f, u);                                     //005A83E4
      end;
      if Trim(Form27.Edit4.Text) <> '' then                //005A83FB..842B jbe->8483
      begin
        u := '1 PHON ' + AnsiToUtf8(Form27.Edit4.Text);    //005A842D..8456 CatN3
        WriteLn(f, u);                                     //005A846C
      end;
      if Trim(Form27.Edit6.Text) <> '' then                //005A8483..84B3 jbe->8894
      begin
        u := '1 EMAIL ' + AnsiToUtf8(Form27.Edit6.Text);   //005A84B9..84E2 CatN3
        WriteLn(f, u);                                     //005A84F8
      end;
    end
    else
    begin
      WriteLn(f, AnsiToUtf8('0 @S0@ SUBM'));               //005A8514..8524
      WriteLn(f, '1 NAME UNKNOWN');                        //005A853B
    end;
  end
  else
  begin
    WriteLn(f, '1 LANG German');                           //005A8556
    if Trim(Form27.Edit1.Text) <> '' then                  //005A856C..859C jbe->8868
    begin
      WriteLn(f, '0 @S0@ SUBM');                           //005A85A2
      WriteLn(f, '1 ADDR');                                //005A85B8
      u := '2 ADR1 ' + Form27.Edit1.Text;                  //005A85CE..85E6 CatN2
      WriteLn(f, u);                                       //005A85FC
      if Trim(Form27.Edit2.Text) <> '' then                //005A8613..8643 jbe->868A
      begin
        u := '2 ADR2 ' + Form27.Edit2.Text;                //005A8645..865D CatN2
        WriteLn(f, u);                                     //005A8673
      end;
      if Trim(Form27.Edit3.Text) <> '' then                //005A868A..86BA jbe->8701
      begin
        u := '1 POST ' + Form27.Edit3.Text;                //005A86BC..86D4 CatN2
        WriteLn(f, u);                                     //005A86EA
      end;
      if Trim(Form27.Edit5.Text) <> '' then                //005A8701..8731 jbe->8778
      begin
        u := '1 CITY ' + Form27.Edit5.Text;                //005A8733..874B CatN2
        WriteLn(f, u);                                     //005A8761
      end;
      if Trim(Form27.Edit4.Text) <> '' then                //005A8778..87A8 jbe->87EF
      begin
        u := '1 PHON ' + Form27.Edit4.Text;                //005A87AA..87C2 CatN2
        WriteLn(f, u);                                     //005A87D8
      end;
      if Trim(Form27.Edit6.Text) <> '' then                //005A87EF..881F jbe->8894
      begin
        u := '1 EMAIL ' + Form27.Edit6.Text;               //005A8821..8839 CatN2
        WriteLn(f, u);                                     //005A884F
      end;
    end
    else
    begin
      WriteLn(f, '0 @S0@ SUBM');                           //005A8868
      WriteLn(f, '1 NAME UNKNOWN');                        //005A887E
    end;
  end;
  Form27.Visible := False;                                 //005A8894..889D SetVisible(0)
  Form1.Label18.Visible := True;                        //005A88A2..88B1 SetVisible(1)
  Form1.Label18.Caption := ' ';                         //005A88B6..88C8 SetText
  Form1.Label18.Refresh;                                //005A88CD..88DA
  Form1.Label19.Visible := True;                        //005A88DF..88EE
  Form1.Label19.Caption := 'Gedcom schreiben';          //005A88F3..8905
  Form1.Label19.Refresh;                                //005A890A..8917
  anz := DataModule2.Table1.RecordCount;                //005A891C..8929 vtbl+14C [ebp-10]
  krg := DataModule2.Table1Nummer.AsInteger;            //005A892C..8939 vtbl+58 [ebp-20]
  DataModule2.Table1.IndexName := '';                   //005A893C..8943 xor edx
  DataModule2.Table1.First;                             //005A8948
  DataModule2.Table10.Open;                             //005A8952 [0A4]
  DataModule2.Table10.IndexName := 'num';               //005A895F..896C
  DataModule2.Table10.First;                            //005A8971
  { 005A897E..8C74: Vorlauf ueber alle Personen - fehlende "andere
    Beziehung"-Eintraege in Table10 nachtragen (beide Richtungen). }
  while not DataModule2.Table1.Eof do                   //005A897E jmp->8C74 (Entry); Exit-Test 005A8C66..C72 jne->8C86; Cond 005A8C74..C80 je->8983
  begin
    Form1.Label18.Caption :=                            //005A8983..8990 IntToStr [ebp-330]
      IntToStr(DataModule2.Table1Nummer.AsInteger);
    Form1.Label18.Refresh;                              //005A89B3..89C0
    if (DataModule2.Table1Vater.AsInteger > 0) and      //005A89C5..89D4 jle->8C5C
       (DataModule2.Table1Mutter.AsInteger > 0) then    //005A89DA..89E9 jle->8C5C
    begin
      if DataModule2.Table10.FindKey(                   //005A89EF..8A20 je->8B7C
           [DataModule2.Table1Vater.AsInteger]) then
      begin
        gef := 0;                                       //005A8A26 xor edi
        { 005A8A28..8A8D: innere Suche in Table10 (Index 'num') - bricht ab,
          sobald Nummer <> Vater ist (Ende der Treffergruppe). }
        while True do                                   //005A8A28 jmp->8A6F (Ruecklauf 8A8D)
        begin
          if DataModule2.Table10Nummer.AsInteger <>     //005A8A6F..8A8D je->8A2A
             DataModule2.Table1Vater.AsInteger then
            Break;                                      //   -> 005A8A8F
          if DataModule2.Table10Epnum.AsInteger =       //005A8A2A..8A48 jne->8A51
             DataModule2.Table1Mutter.AsInteger then
          begin
            gef := 1;                                   //005A8A4A
            Break;                                      //005A8A4F jmp->8A8F
          end;
          DataModule2.Table10.Next;                     //005A8A51
          if DataModule2.Table10.Eof then Break;        //005A8A5E..8A6D jne->8A8F
        end;
        if gef = 0 then                                 //005A8A8F..8A91 jne->8C5C
        begin
          { 005A8A97..8B77: Zahn 1 (Vater->Mutter) und Zahn 2 (Mutter->Vater) }
          DataModule2.Table10.Append;                   //005A8A97
          DataModule2.Table10Nummer.AsInteger :=        //005A8AA4..8AB1 [3B4]
            DataModule2.Table1Vater.AsInteger;          //   <- [538]
          DataModule2.Table10Epnum.AsInteger :=         //005A8AC3..8AD0 [3B8]
            DataModule2.Table1Mutter.AsInteger;         //   <- [53C]
          DataModule2.Table10Verbind.AsString :=        //005A8AE2 [3E4]
            'andere Beziehung';
          DataModule2.Table10.Post;                     //005A8AF7
          DataModule2.Table10.Append;                   //005A8B07
          DataModule2.Table10Nummer.AsInteger :=        //005A8B14..8B21
            DataModule2.Table1Mutter.AsInteger;
          DataModule2.Table10Epnum.AsInteger :=         //005A8B33..8B40
            DataModule2.Table1Vater.AsInteger;
          DataModule2.Table10Verbind.AsString :=        //005A8B52
            'andere Beziehung';
          DataModule2.Table10.Post;                     //005A8B67
        end;
      end
      else
      begin
        { 005A8B7C..8C4C: Paar nicht vorhanden - beide Zaehne anlegen }
        DataModule2.Table10.Append;                     //005A8B7C
        DataModule2.Table10Nummer.AsInteger :=          //005A8B89..8B96
          DataModule2.Table1Vater.AsInteger;
        DataModule2.Table10Epnum.AsInteger :=           //005A8BA8..8BB5
          DataModule2.Table1Mutter.AsInteger;
        DataModule2.Table10Verbind.AsString :=          //005A8BC7
          'andere Beziehung';
        DataModule2.Table10.Post;                       //005A8BDC
        DataModule2.Table10.Append;                     //005A8BEC
        DataModule2.Table10Nummer.AsInteger :=          //005A8BF9..8C06
          DataModule2.Table1Mutter.AsInteger;
        DataModule2.Table10Epnum.AsInteger :=           //005A8C18..8C25
          DataModule2.Table1Vater.AsInteger;
        DataModule2.Table10Verbind.AsString :=          //005A8C37
          'andere Beziehung';
        DataModule2.Table10.Post;                       //005A8C4C
      end;
    end;
    DataModule2.Table1.Next;                            //005A8C5C
  end;
  DataModule2.Table1.IndexName := '';                   //005A8C86..8C8D
  DataModule2.Table1.First;                             //005A8C92
  if gvar_02536BA0 > 1 then                             //005A8C9C..CA4 jle->8D9F
  begin
    { Jahresfilter: nur Personen bis zum eingestellten Jahr }
    DataModule2.Table1.Filter := 'gebjahr<=' +          //005A8CAA..8CF4 CatN4
      IntToStr(gvar_02536BA0) + ' and taufjahr<=' +
      IntToStr(gvar_02536BA0);
    DataModule2.Table1.Filtered := True;                //005A8D07..8D10 vtbl+190
    DataModule2.Table9.Filter := 'gebjahr<=' +          //005A8D16..8D5B CatN4
      IntToStr(gvar_02536BA0) + ' and taufjahr<=' +
      IntToStr(gvar_02536BA0);
    DataModule2.Table9.Filtered := True;                //005A8D76..8D82 vtbl+190
    Form1.DBText1.Color := clYellow;                    //005A8D88..8D9A $0000FFFF
  end;
  DataModule2.Table1.FindKey([krg]);                    //005A8D9F..8DBC [ebp-20]
  Form1.Label18.Caption := ' ';                         //005A8DC1..8DD3 SetText
  Form1.Label18.Update;                                 //005A8DD8..8DE7 vtbl+88
  Form1.Label18.Caption := '0 %';                       //005A8DED..8DFF
  kz := 1;                                              //005A8E04 [ebp-8]
  dead2 := '';                                          //005A8E0B [ebp-24] toter String
  gedausx;                                              //005A8E13..8E16 Self
  DataModule2.Table13.Open;                             //005A8E1B [0CC]
  DataModule2.Table13.IndexName := 'ort_';              //005A8E28
  DataModule2.Table1.First;                             //005A8E3A
  locList := '';                                        //005A8E44 [ebp-30]
  dead3 := '';                                          //005A8E4C [ebp-34] toter String
  DataModule2.Table38.Open;                             //005A8E54 [530]
  DataModule2.Table38.IndexName := 'tit';               //005A8E61
  { 005A8E73: Sprung zur Schleifenbedingung am Blockende (005ABEEC) -
    Personenschleife ueber Table1 (Kopf = Fortschrittsanzeige). }
  while not DataModule2.Table1.Eof do                   //005A8E73 jmp->ABEEC
  begin
    u := IntToStr(Round(kz / anz * 100 / 2) + 50) + ' %'; //005A8E78..8EA4 fild/fdiv/fmul100/fdiv2 ROUND +32(=50)
    Form1.Label18.Caption := u;                          //005A8EB4 [400] SetText
    Form1.Label18.Refresh;                               //005A8ECC
    notiz := 0;                                          //005A8EDE..8EE0 [ebp-14]
    WriteLn(f, '0 @I' + IntToStr(DataModule2.Table1Nummer.AsInteger) + //005A8EE3..8EFB CatN3
      '@ INDI');                                         //   push '0 @I', IntToStr, '@ INDI'
    nm := Trim(DataModule2.Table1Vornamen.AsString);     //005A8F32..8F45 +544
    if Pos('!', nm) > 0 then                             //005A8F53..8F62 jle->8F96
      { zweite Pos liest den Vornamen erneut (ungetrimmt) - Indizes koennen
        um fuehrende Leerzeichen abweichen, 1:1 aus dem Listing }
      Delete(nm, Pos('!', DataModule2.Table1Vornamen.AsString), 1); //005A8F64..8F91 LStrDelete
    if gvar_02536650 = 1 then                            //005A8F96..8F9D jne->902A
      WriteLn(f, '1 NAME ' + AnsiToUtf8(                 //005A8FA3..9011 CatN4
        nm + ' /' + Trim(DataModule2.Table1Name.AsString) + '/'))
    else                                                 //005A9028 jmp->908D / 902A
      WriteLn(f, '1 NAME ' + nm + ' /' +                 //005A902A..9076 CatN5
        Trim(DataModule2.Table1Name.AsString) + '/');
    if Trim(DataModule2.Table1Namex.AsString) <> '' then //005A908D..90B8 jbe->9184
    begin
      if gvar_02536650 = 1 then                          //005A90BE..90C5 jne->9124
        WriteLn(f, '1 NAME /' + AnsiToUtf8(              //005A90C7..910B CatN3
          DataModule2.Table1Namex.AsString) + '/')
      else                                               //005A9122 jmp->916E / 9124
        WriteLn(f, '1 NAME /' +                          //005A9124..9157 CatN3
          DataModule2.Table1Namex.AsString + '/');
      WriteLn(f, '2 TYPE variant');                      //005A916E
    end;
    if Trim(DataModule2.Table1Rufname.AsString) <> '' then //005A9184..91AF jbe->91F1
      WriteLn(f, '2 _RUFNAME ' +                         //005A91B1..91DA CatN3
        DataModule2.Table1Rufname.AsString);             {KEINE Utf8-Variante}
    if Trim(DataModule2.Table1Hausname.AsString) <> '' then //005A91F1..921C jbe->92E8
    begin
      if gvar_02536650 = 1 then                          //005A9222..9229 jne->9288
        WriteLn(f, '1 NAME /' + AnsiToUtf8(              //005A922B..926F CatN3
          DataModule2.Table1Hausname.AsString) + '/')
      else                                               //005A9286 jmp->92D2 / 9288
        WriteLn(f, '1 NAME /' +                          //005A9288..92BB CatN3
          DataModule2.Table1Hausname.AsString + '/');
      WriteLn(f, '2 TYPE estate');                       //005A92D2
    end;
    if ucase(DataModule2.Table1Geschlecht.AsString) = 'W' then //005A92E8..9323 jne->9340
      WriteLn(f, '1 SEX F')                              //005A9325
    else if ucase(DataModule2.Table1Geschlecht.AsString) = 'M' then //005A9340..937B jne->9398
      WriteLn(f, '1 SEX M')                              //005A937D
    else if (ucase(DataModule2.Table1Geschlecht.AsString) = 'X') or //005A9398..93D3 je->9402
       (Trim(DataModule2.Table1Geschlecht.AsString) = '') then //005A93D5..9400 jne->9418
      WriteLn(f, '1 SEX U');                             //005A9402
    if Trim(DataModule2.Table1Beruf.AsString) <> '' then //005A9418..9443 jbe->94E5
    begin
      if gvar_02536650 = 1 then                          //005A9449..9450 jne->94A5
        WriteLn(f, '1 OCCU ' + AnsiToUtf8(               //005A9452..948C CatN3
          DataModule2.Table1Beruf.AsString))
      else                                               //005A94A3 jmp->94E5 / 94A5
        WriteLn(f, '1 OCCU ' + DataModule2.Table1Beruf.AsString); //005A94A5..94CE
    end;
    if Trim(DataModule2.Table1Religion.AsString) <> '' then //005A94E5..9510 jbe->9552
      WriteLn(f, '1 RELI ' + DataModule2.Table1Religion.AsString); //005A9512..953B CatN3 {KEINE Utf8-Variante}
    if Trim(DataModule2.Table1IDNR.AsString) <> '' then  //005A9552..957D jbe->95BF
      WriteLn(f, '1 IDNO ' + DataModule2.Table1IDNR.AsString); //005A957F..95A8 CatN3 {KEINE Utf8-Variante}
    if Trim(DataModule2.Table1Quelle.AsString) <> '' then //005A95BF..95EA jbe->9681
      if DataModule2.Table38.FindKey(                    //005A95F0..962D je->9681
        [DataModule2.Table1Quelle.AsString]) then
        WriteLn(f, '1 SOUR @S' +
          IntToStr(DataModule2.Table38.RecNo) + '@');    //005A962F..966A CatN3 (v150 = GetRecNo)
    if (Trim(DataModule2.Table1Gebjahr.AsString) <> '') or //005A9681..96AC ja->96DF
       (Trim(DataModule2.Table1Gebort.AsString) <> '') then //005A96AE..96D9 jbe->9AD1
    begin
      WriteLn(f, '1 BIRT');                              //005A96DF
      if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then //005A96F5..9720 jbe->97AE
        WriteLn(f, '2 DATE ' + sub_00582C24(             //005A9726..9797 CatN3
          DataModule2.Table1Gebtag.AsString,              //   554 Tag
          DataModule2.Table1Gebmonat.AsString,            //   558 Monat
          DataModule2.Table1Gebjahr.AsString));           //   55C Jahr
      if Trim(DataModule2.Table1Gebort.AsString) <> '' then //005A97AE..97D9 jbe->9A02
      begin
        DataModule2.Table13.FindKey(                      //005A97DF..9805 ohne Result-Test
          [DataModule2.Table1Gebort.AsString]);
        plac := DataModule2.Table1Gebort.AsString + ',' + //005A981A..9887 CatN7 [ebp-1C]
          DataModule2.Table13Lkr.AsString + ',' +         //   0A64 Landkreis
          DataModule2.Table13Bland.AsString + ',' +       //   0A58 Bundesland
          DataModule2.Table13Land.AsString;               //   0A4C Land
        if gvar_02536650 = 1 then                         //005A989A..98A1 jne->98E0
          WriteLn(f, '2 PLAC ' + AnsiToUtf8(plac))        //005A98A3..98C7
        else                                              //005A98DE jmp->990A / 98E0
          WriteLn(f, '2 PLAC ' + plac);                   //005A98E0..98F3 Cat3
        if DataModule2.Table13.FindKey(                   //005A990A..9947 je->9A02
          [DataModule2.Table1Gebort.AsString]) then
        begin
          WriteLn(f, '3 _LOC @P' +
            IntToStr(DataModule2.Table13.RecNo) + '@');   //005A994D..9988 CatN3 (v150 = GetRecNo)
          sub_00576EB0(DataModule2.Table13.RecNo, u);     //005A999F..99B5 6-stellig
          if Pos(u, locList) = 0 then                     //005A99BA..99CA jne->9A02
          begin
            sub_00576EB0(DataModule2.Table13.RecNo, u);   //005A99CF..99E5 (erneut)
            locList := locList + u + '*';                 //005A99EA CatN3 [ebp-30]
          end;
        end;
      end;
      DataModule2.Table38.First;                          //005A9A02 innerhalb BIRT (Skip 96D9 -> 9AD1)
      if Trim(DataModule2.Table1Quelleg.AsString) <> '' then //005A9A0F..9A3A jbe->9AD1
        if DataModule2.Table38.FindKey(                    //005A9A40..9A7D je->9AD1
          [DataModule2.Table1Quelleg.AsString]) then
          WriteLn(f, '2 SOUR @S' +                         //005A9A7F..9ABA CatN3
            IntToStr(DataModule2.Table38.RecNo) + '@');    //   v150 = GetRecNo
    end;
    if (Trim(DataModule2.Table1Taufjahr.AsString) <> '') or //005A9AD1..9AFC ja->9B2F
       (Trim(DataModule2.Table1Taufort.AsString) <> '') then //005A9AFE..9B29 jbe->9F26
    begin
      WriteLn(f, '1 CHR');                                //005A9B2F
      if Trim(DataModule2.Table1Taufjahr.AsString) <> '' then //005A9B45..9B70 jbe->9BFE
        WriteLn(f, '2 DATE ' + sub_00582C24(               //005A9B76..9BE7 CatN3
          DataModule2.Table1Tauftag.AsString,              //   564 Tag
          DataModule2.Table1Taufmonat.AsString,            //   568 Monat
          DataModule2.Table1Taufjahr.AsString));           //   56C Jahr
      if Trim(DataModule2.Table1Taufort.AsString) <> '' then //005A9BFE..9C29 jbe->9E52
      begin
        DataModule2.Table13.FindKey(                       //005A9C2F..9C55 ohne Result-Test
          [DataModule2.Table1Taufort.AsString]);
        plac := DataModule2.Table1Taufort.AsString + ',' + //005A9C6A..9CD7 CatN7 [ebp-1C]
          DataModule2.Table13Lkr.AsString + ',' +
          DataModule2.Table13Bland.AsString + ',' +
          DataModule2.Table13Land.AsString;
        if gvar_02536650 = 1 then                          //005A9CEA..9CF1 jne->9D30
          WriteLn(f, '2 PLAC ' + AnsiToUtf8(plac))         //005A9CF3..9D17
        else                                               //005A9D2E jmp->9D5A / 9D30
          WriteLn(f, '2 PLAC ' + plac);                    //005A9D30..9D43 Cat3
        if DataModule2.Table13.FindKey(                    //005A9D5A..9D97 je->9E52
          [DataModule2.Table1Taufort.AsString]) then
        begin
          WriteLn(f, '3 _LOC @P' +
            IntToStr(DataModule2.Table13.RecNo) + '@');    //005A9D9D..9DD8 CatN3 (v150 = GetRecNo)
          sub_00576EB0(DataModule2.Table13.RecNo, u);      //005A9DEF..9E05 6-stellig
          if Pos(u, locList) = 0 then                      //005A9E0A..9E1A jne->9E52
          begin
            sub_00576EB0(DataModule2.Table13.RecNo, u);    //005A9E1F..9E35 (erneut)
            locList := locList + u + '*';                  //005A9E3A CatN3 [ebp-30]
          end;
        end;
      end;
      DataModule2.Table38.IndexName := 'tit';              //005A9E52 Reset im CHR-Block
      if Trim(DataModule2.Table1Quellet.AsString) <> '' then //005A9E64..9E8F jbe->9F26
        if DataModule2.Table38.FindKey(                    //005A9E95..9ED2 je->9F26
          [DataModule2.Table1Quellet.AsString]) then
          WriteLn(f, '2 SOUR @S' +                         //005A9ED4..9F0F CatN3
            IntToStr(DataModule2.Table38.RecNo) + '@');    //   v150 = GetRecNo
    end;
    if Trim(DataModule2.Table1Taufpat.AsString) <> '' then //005A9F26..9F51 jbe->9FF3
    begin
      if gvar_02536650 = 1 then                            //005A9F57..9F5E jne->9FB3
        WriteLn(f, '2 _GODP ' + AnsiToUtf8(                //005A9F60..9F9A CatN3
          DataModule2.Table1Taufpat.AsString))
      else                                                 //005A9FB1 jmp->9FF3 / 9FB3
        WriteLn(f, '2 _GODP ' +                            //005A9FB3..9FDC CatN3
          DataModule2.Table1Taufpat.AsString);
    end;
    if (Trim(DataModule2.Table1Stjahr.AsString) <> '') or  //005A9FF3..A01E ja->A051
       (Trim(DataModule2.Table1Stort.AsString) <> '') then //005AA020..A04B jbe->A510
    begin
      WriteLn(f, '1 DEAT');                                //005AA051
      if Trim(DataModule2.Table1Stjahr.AsString) <> '' then //005AA067..A092 jbe->A120
        WriteLn(f, '2 DATE ' + sub_00582C24(               //005AA098..A109 CatN3
          DataModule2.Table1Sttag.AsString,                //   57C Tag
          DataModule2.Table1Stmonat.AsString,              //   580 Monat
          DataModule2.Table1Stjahr.AsString));             //   584 Jahr
      if Trim(DataModule2.Table1Stort.AsString) <> '' then //005AA120..A14B jbe->A374
      begin
        DataModule2.Table13.FindKey(                       //005AA151..A177 ohne Result-Test
          [DataModule2.Table1Stort.AsString]);
        plac := DataModule2.Table1Stort.AsString + ',' +   //005AA18C..A1F9 CatN7 [ebp-1C]
          DataModule2.Table13Lkr.AsString + ',' +
          DataModule2.Table13Bland.AsString + ',' +
          DataModule2.Table13Land.AsString;
        if gvar_02536650 = 1 then                          //005AA20C..A213 jne->A252
          WriteLn(f, '2 PLAC ' + AnsiToUtf8(plac))         //005AA215..A239
        else                                               //005AA250 jmp->A27C / A252
          WriteLn(f, '2 PLAC ' + plac);                    //005AA252..A265 Cat3
        if DataModule2.Table13.FindKey(                    //005AA27C..A2B9 je->A374
          [DataModule2.Table1Stort.AsString]) then
        begin
          WriteLn(f, '3 _LOC @P' +
            IntToStr(DataModule2.Table13.RecNo) + '@');    //005AA2BF..A2FA CatN3 (v150 = GetRecNo)
          sub_00576EB0(DataModule2.Table13.RecNo, u);      //005AA311..A327 6-stellig
          if Pos(u, locList) = 0 then                      //005AA32C..A33C jne->A374
          begin
            sub_00576EB0(DataModule2.Table13.RecNo, u);    //005AA341..A357 (erneut)
            locList := locList + u + '*';                  //005AA35C CatN3 [ebp-30]
          end;
        end;
      end;
      DataModule2.Table38.First;                           //005AA374
      if Trim(DataModule2.Table1Quelles.AsString) <> '' then //005AA381..A3AC jbe->A443
        if DataModule2.Table38.FindKey(                     //005AA3B2..A3EF je->A443
          [DataModule2.Table1Quelles.AsString]) then
          WriteLn(f, '2 SOUR @S' +                          //005AA3F1..A443 CatN3
            IntToStr(DataModule2.Table38.RecNo) + '@');     //   v150 = GetRecNo
      if Trim(DataModule2.Table1Todesurs.AsString) <> '' then //005AA443..A46E jbe->A510
        if gvar_02536650 = 1 then                           //005AA474..A47B jne->A4D0
          WriteLn(f, '2 CAUS ' + AnsiToUtf8(                //005AA47D..A4C9 CatN3
            DataModule2.Table1Todesurs.AsString))
        else                                                //005AA4CE jmp->A510 / A4D0
          WriteLn(f, '2 CAUS ' +                            //005AA4D0..A50B Cat3
            DataModule2.Table1Todesurs.AsString);
    end;                                                    // DEAT-Ende vor A510
    if (Trim(DataModule2.Table1Begjahr.AsString) <> '') or  //005AA510..A53B ja->A56E
       (Trim(DataModule2.Table1Begort.AsString) <> '') then //005AA53D..A568 jbe->A891
    begin
      WriteLn(f, '1 BURI');                                 //005AA56E
      if Trim(DataModule2.Table1Begjahr.AsString) <> '' then //005AA584..A5AF jbe->A63D
        WriteLn(f, '2 DATE ' + sub_00582C24(                //005AA5B5..A638 CatN3
          DataModule2.Table1Begtag.AsString,                //   590 Tag
          DataModule2.Table1Begmonat.AsString,              //   594 Monat
          DataModule2.Table1Begjahr.AsString));             //   598 Jahr
      if Trim(DataModule2.Table1Begort.AsString) <> '' then //005AA63D..A668 jbe->A891
      begin
        DataModule2.Table13.FindKey(                        //005AA66E..A6A4 ohne Result-Test
          [DataModule2.Table1Begort.AsString]);
        plac := DataModule2.Table1Begort.AsString + ',' +   //005AA6A9..A724 CatN7 [ebp-1C]
          DataModule2.Table13Lkr.AsString + ',' +
          DataModule2.Table13Bland.AsString + ',' +
          DataModule2.Table13Land.AsString;
        if gvar_02536650 = 1 then                           //005AA729..A730 jne->A76F
          WriteLn(f, '2 PLAC ' + AnsiToUtf8(plac))          //005AA732..A768
        else                                                //005AA76D jmp->A799 / A76F
          WriteLn(f, '2 PLAC ' + plac);                     //005AA76F..A794 Cat3
        if DataModule2.Table13.FindKey(                     //005AA799..A7D6 je->A891
          [DataModule2.Table1Begort.AsString]) then
        begin
          WriteLn(f, '3 _LOC @P' +
            IntToStr(DataModule2.Table13.RecNo) + '@');     //005AA7DC..A829 CatN3 (v150 = GetRecNo)
          sub_00576EB0(DataModule2.Table13.RecNo, u);       //005AA82E..A844 6-stellig
          if Pos(u, locList) = 0 then                       //005AA849..A859 jne->A891
          begin
            sub_00576EB0(DataModule2.Table13.RecNo, u);     //005AA85B..A874 (erneut)
            locList := locList + u + '*';                   //005AA879..A88C CatN3 [ebp-30]
          end;
        end;
      end;
    end;                                                    // BURI-Ende vor A891
    DataModule2.Table38.First;                              //005AA891 ausserhalb BURI
    if Trim(DataModule2.Table1Quelleb.AsString) <> '' then //005AA89E..A8C9 jbe->A960
      if DataModule2.Table38.FindKey(                      //005AA8CF..A90C je->A960
        [DataModule2.Table1Quelleb.AsString]) then
        WriteLn(f, '2 SOUR @S' +                           //005AA90E..A960 CatN3
          IntToStr(DataModule2.Table38.RecNo) + '@');      //   v150 = GetRecNo
    {RESI-Block: Lebensort [578] / Adr1 [5CC] als Paartor (ja->A9BE / jbe->B11F)}
    if (Trim(DataModule2.Table1Lebensort.AsString) <> '') or //005AA960..A98B ja->A9BE
       (Trim(DataModule2.Table1Adr1.AsString) <> '') then     //005AA98D..A9B8 jbe->AB11F
    begin
      WriteLn(f, '1 RESI');                                  //005AA9BE..A9CF
      if Trim(DataModule2.Table1Lebensort.AsString) <> '' then //005AA9D4..A9FF jbe->AAAA1
        if gvar_02536650 = 1 then                              //005AAA05..0C jne->AAA61
          WriteLn(f, '2 PLAC ' + AnsiToUtf8(                 //005AAA0E..AA5A CatN3
            Trim(DataModule2.Table1Lebensort.AsString)))
        else                                                 //005AAA5F jmp->AAA1
          WriteLn(f, '2 PLAC ' +                             //005AAA61..AAA1
            Trim(DataModule2.Table1Lebensort.AsString));
      {ADDR-Zweig ueber Adr1 [5CC] (+ADR2 5D0, ADR3 5DC, POST 5D4,
        CITY 5D8, PHON 5F0, EMAIL 5F4, WWW 5F8)}
      if Trim(DataModule2.Table1Adr1.AsString) <> '' then     //005AAAA1..AACC jbe->AAB84
      begin
        WriteLn(f, '2 ADDR');                                //005AAAD2..AAE3
        if gvar_02536650 = 1 then                            //005AAAE8..AAEF jne->AAB44
          WriteLn(f, '3 ADR1 ' + AnsiToUtf8(                 //005AAAF1..AB3D CatN3
            Trim(DataModule2.Table1Adr1.AsString)))
        else                                                 //005AAB42 jmp->AAB84
          WriteLn(f, '3 ADR1 ' +                             //005AAB44..AB84
            Trim(DataModule2.Table1Adr1.AsString));
      end;
      if Trim(DataModule2.Table1Adr2.AsString) <> '' then    //005AAB84..BAF jbe->AAC51
      begin
        if gvar_02536650 = 1 then                            //005AABB5..ABBC jne->AAC11
          WriteLn(f, '3 ADR2 ' + AnsiToUtf8(                 //005AABBE..AAC0A CatN3
            Trim(DataModule2.Table1Adr2.AsString)))
        else                                                 //005AAC0F jmp->AC51
          WriteLn(f, '3 ADR2 ' +                             //005AAC11..AAC51
            Trim(DataModule2.Table1Adr2.AsString));
      end;
      if Trim(DataModule2.Table1Adrzus.AsString) <> '' then  //005AAC51..AC7C jbe->AAD1E
      begin
        if gvar_02536650 = 1 then                            //005AAC82..AC89 jne->AACDE
          WriteLn(f, '3 ADR3 ' + AnsiToUtf8(                 //005AAC8B..ACD7 CatN3
            Trim(DataModule2.Table1Adrzus.AsString)))
        else                                                 //005AACDC jmp->AD1E
          WriteLn(f, '3 ADR3 ' +                             //005AACDE..AD1E
            Trim(DataModule2.Table1Adrzus.AsString));
      end;
      if Trim(DataModule2.Table1PLZ.AsString) <> '' then     //005AAD1E..AD49 jbe->AADEB
      begin
        if gvar_02536650 = 1 then                            //005AAD4F..AD56 jne->AADAB
          WriteLn(f, '3 POST ' + AnsiToUtf8(                 //005AAD58..ADA4 CatN3
            Trim(DataModule2.Table1PLZ.AsString)))
        else                                                 //005AADA9 jmp->ADEB
          WriteLn(f, '3 POST ' +                             //005AADAB..AADEB
            Trim(DataModule2.Table1PLZ.AsString));
      end;
      if Trim(DataModule2.Table1Ort.AsString) <> '' then     //005AADEB..AE16 jbe->AAEB8
      begin
        if gvar_02536650 = 1 then                            //005AAE1C..AE23 jne->AAE78
          WriteLn(f, '3 CITY ' + AnsiToUtf8(                 //005AAE25..AE71 CatN3
            Trim(DataModule2.Table1Ort.AsString)))
        else                                                 //005AAE76 jmp->AEB8
          WriteLn(f, '3 CITY ' +                             //005AAE78..AEB8
            Trim(DataModule2.Table1Ort.AsString));
      end;
      if Trim(DataModule2.Table1Tel.AsString) <> '' then     //005AAEB8..AEE3 jbe->AAF85
      begin
        if gvar_02536650 = 1 then                            //005AAEE9..AEF0 jne->AAF45
          WriteLn(f, '2 PHON ' + AnsiToUtf8(                 //005AAEF2..AF3E CatN3
            Trim(DataModule2.Table1Tel.AsString)))
        else                                                 //005AAF43 jmp->AF85
          WriteLn(f, '2 PHON ' +                             //005AAF45..AF85
            Trim(DataModule2.Table1Tel.AsString));
      end;
      if Trim(DataModule2.Table1Ema.AsString) <> '' then     //005AAF85..AFB0 jbe->AB052
      begin
        if gvar_02536650 = 1 then                            //005AAFB6..AFBD jne->AB012
          WriteLn(f, '2 EMAIL ' + AnsiToUtf8(                //005AAFBF..B00B CatN3
            Trim(DataModule2.Table1Ema.AsString)))
        else                                                 //005AB010 jmp->B052
          WriteLn(f, '2 EMAIL ' +                            //005AB012..B052
            Trim(DataModule2.Table1Ema.AsString));
      end;
      if Trim(DataModule2.Table1Ur.AsString) <> '' then      //005AB052..B07D jbe->AB11F
      begin
        if gvar_02536650 = 1 then                            //005AB083..B08A jne->AB0DF
          WriteLn(f, '2 WWW ' + AnsiToUtf8(                  //005AB08C..B0D8 CatN3
            Trim(DataModule2.Table1Ur.AsString)))
        else                                                 //005AB0DD jmp->AB11F
          WriteLn(f, '2 WWW ' +                              //005AB0DF..B11F
            Trim(DataModule2.Table1Ur.AsString));
      end;
    end;
    {Ableger Namex [5BC] - Schreibung/Schriftlinie}
    if Trim(DataModule2.Table1Namex.AsString) <> '' then     //005AB11F..B14A jbe->AB2A8
    begin
      if notiz = 0 then                                      //005AB150..B154 jne->AB205
      begin
        notiz := 1;                                          //005AB15A
        if gvar_02536650 = 1 then                            //005AB161..B168 jne->AB1C0
          WriteLn(f, '1 NOTE Schrw.: ' + AnsiToUtf8(         //005AB16A..1BB CatN3
            DataModule2.Table1Namex.AsString))
        else                                                 //005AB1BB jmp->B2A8
          WriteLn(f, '1 NOTE Schrw.: ' +                     //005AB1C0..200
            DataModule2.Table1Namex.AsString);
      end
      else                                                   //005AB200 jmp->B2A8
      begin
        if gvar_02536650 = 1 then                            //005AB205..B20C jne->AB261
          WriteLn(f, '2 CONT Schrw.: ' + AnsiToUtf8(         //005AB20E..25F CatN3
            DataModule2.Table1Namex.AsString))
        else                                                 //005AB25F jmp->B2A1
          WriteLn(f, '2 CONT Schrw.: ' +                     //005AB261..29C
            DataModule2.Table1Namex.AsString);
        notiz := 1;                                          //005AB2A1
      end;
    end;
    {Lebt [5B4]: 1 NOTE/2 CONT 'lebt: '-Markierungen - im Original
      ANSPRUCHSLOS mit AnsiToUtf8 geschrieben (Abweichung zum
      gvar_02536650-Muster der Ueber-/Unterfelder, 1:1 uebernommen)}
    if Trim(DataModule2.Table1Lebt.AsString) <> '' then      //005AB2A8..B2DC jne->AB3EC
    begin
      if notiz = 0 then                                      //005AB2E2..B2E6 jne->AB36F
      begin
        notiz := 1;                                          //005AB2EC
        if DataModule2.Table1Lebt.AsString = 'j' then        //005AB2F3..B316 jne->B3EC (LStrCmp 'j')
          WriteLn(f, '1 NOTE lebt: ' + AnsiToUtf8(           //005AB31C..36D
            DataModule2.Table1Lebt.AsString));
      end
      else                                                   //005AB36D jmp->B3EC
      begin
        if DataModule2.Table1Lebt.AsString = 'j' then        //005AB36F..B392 jne->B3E5 (ohne Trim)
          WriteLn(f, '2 CONT lebt: ' + AnsiToUtf8(           //005AB394..3E0
            DataModule2.Table1Lebt.AsString));
        notiz := 1;                                          //005AB3E5
      end;
    end;
    {Anmerkung zum Kommentar (TMemoField [5B0]) - ueber Form27.CheckBox1
      abschaltbar (TOKBottomDlg1.GetChecked vtbl+0C4 per [318])}
    if Form27.CheckBox1.Checked then                        //005AB3EC..B403 jne->AB801
    begin
    end
    else if Trim(DataModule2.Table1Kommentar.AsString) <> '' then //005AB409..B434 jbe->AB801
    begin
      Form1.Memo1.Clear;                                    //005AB43A..449 vtbl+0DC
      anz := 1;                          { [ebp-0C] Memo1-Lines-Zaehler - Slot-Wiederverwendung;
                                              Fenster anz: 005A8929/005A8E7B, kein Ueberlapp mit 0C }
      Form1.Memo1.Lines.Assign(DataModule2.Table1Kommentar); //005AB456..494 [220]+8 Assign
      if Form1.Memo1.Lines.Count > 0 then                  //005AB47F..499 jle->AB801
      begin
        if notiz = 0 then                                  //005AB49F..B4A3 jne->AB56E
        begin
          notiz := 1;                                      //005AB4A9
          if gvar_02536650 = 1 then                        //005AB4B0..B4B7 jne->AB51C
            WriteLn(f, '1 NOTE ' + AnsiToUtf8(             //005AB4B9..512 CatN3
              Form1.Memo1.Lines[0]))
          else                                             //005AB517 jmp->B62B
            WriteLn(f, '1 NOTE ' +                         //005AB51C..517
              Form1.Memo1.Lines[0]);
        end
        else                                               //005AB569 jmp->B62B
        begin
          if gvar_02536650 = 1 then                        //005AB56E..B575 jne->AB5D7
            WriteLn(f, '2 CONT ' + AnsiToUtf8(             //005AB577..5D5 CatN3
              Form1.Memo1.Lines[0]))
          else                                             //005AB5D5 jmp->B624
            WriteLn(f, '2 CONT ' +                         //005AB5D7..624
              Form1.Memo1.Lines[0]);
          notiz := 1;                                      //005AB624
        end;
        while anz < Form1.Memo1.Lines.Count do             //005AB62B..B644 jle->B801 //005AB64A jmp->B7E0 //005AB64F..B7FB jg->B64F Zopf? Kante
        begin
          {Zweig notiz=0 im Loop nicht erreichbar (notiz seit Vorblock = 1),
            aus dem Listing 1:1 uebernommen}
          if notiz = 0 then                                //005AB64F..B653 jne->AB71E
          begin
            notiz := 1;                                    //005AB659
            if gvar_02536650 = 1 then                      //005AB660..B667 jne->AB6CC
              WriteLn(f, '1 NOTE ' + AnsiToUtf8(           //005AB669..6C2 CatN3
                Form1.Memo1.Lines[0]))
            else                                           //005AB6C7 jmp->B7E0
              WriteLn(f, '1 NOTE ' +                       //005AB6CC..718
                Form1.Memo1.Lines[0]);
          end
          else                                             //005AB719 jmp->B7E0
          begin
            notiz := 1;                                    //005AB71E
            if gvar_02536650 = 1 then                      //005AB725..B72C jne->AB78F
              WriteLn(f, '2 CONT ' + AnsiToUtf8(           //005AB72E..788 CatN3
                Form1.Memo1.Lines[anz]))
            else                                           //005AB78D jmp->B7DD
              WriteLn(f, '2 CONT ' +                       //005AB78F..7D3
                Form1.Memo1.Lines[anz]);
          end;
          anz := anz + 1;                                  //005AB7DD
        end;
      end;
    end;
    {FAMS/FAMC: Paar-Scan ueber Table32 [2B8] (Familienindex 'v'=[2C4]
      / 'm'=[2C8], Nummer-Feld Fn [2D0]); edi wird als reiner Scratch
      behandelt: Vatersnummer inline als Table1Vater [538] utteredert}
    DataModule2.Table5.First;                              //005AB801..80E TDataSet.First
    if ucase(DataModule2.Table1Geschlecht.AsString) = 'M' then //005AB815..B849 jne->B9A5 Upper [ebp-828]
      {AB83F cmp 'M'; AB844 LStrCmp; AB849 jne->B9A5 }
    begin
      DataModule2.Table32.IndexName := 'v';                //005AB86E..B87B 'v'=5AFA04
      DataModule2.Table32.First;                           //005AB880..888 TDataSet.First
      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); //005AB88D..8A5
      if DataModule2.Table32.FindKey([u]) then             //005AB8B8..8CF je->ABB29
      begin
        {Kette ueber Fv == eigene Nummer -> '1 FAMS @F' mit Fn}
        while DataModule2.Table32Fv.AsString = u do       //005AB8D5 jmp->B95C (Entry) //005AB95C..B99A je->B8DA //005AB9A0 jmp->BB29
        begin
          WriteLn(f, '1 FAMS @F' +                          //005AB8DA..935 CatN3
            IntToStr(StrToInt(DataModule2.Table32Fn.AsString)) + '@'); // AB8DF..90E
          DataModule2.Table32.Next;                        //005AB93A..942
          if DataModule2.Table32.Eof then Break;           //005AB947..956 jne->ABB29
        end;
      end;
    end
    else if ucase(DataModule2.Table1Geschlecht.AsString) = 'W' then //005AB9A5..B9D9 jne->BB29 Upper
      {AB9C9 cmp 'W'; AB9D4 LStrCmp; AB9D9 jne->BB29 }
    begin
      DataModule2.Table32.IndexName := 'm';                //005AB9FE..BA0B 'm'=5AF7C4
      DataModule2.Table32.First;                           //005ABA10..BA18
      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); //005ABA1D..ABA3B
      if DataModule2.Table32.FindKey([u]) then             //005ABA48..BA5F je->ABB29
      begin
        while DataModule2.Table32Fm.AsString = u do       //005ABA65 jmp->BAE5 (Entry) //005ABAE5..BB23 je->BA67
        begin
          WriteLn(f, '1 FAMS @F' +                          //005ABA67..AC2 CatN3
            IntToStr(StrToInt(DataModule2.Table32Fn.AsString)) + '@'); // ABA72..ABA9E
          DataModule2.Table32.Next;                        //005ABAC7..ACF
          if DataModule2.Table32.Eof then Break;           //005ABAD4..AE3 jne->ABB29
        end;
      end;
    end;
    {paarweise Achsen pruefen: Vaters-Kette (FAMC) wenn Table1Vater > 0}
    if DataModule2.Table1Vater.AsInteger > 0 then          //005ABB29..BB2B jle->BC77
    begin
      DataModule2.Table32.IndexName := 'v';                //005ABB31..BB3E
      DataModule2.Table32.First;                           //005ABB43..BB4B
      sub_00576EB0(DataModule2.Table1Vater.AsInteger, u); //005ABB50..ABB5D (edi = Cache Table1Vater)
      if DataModule2.Table32.FindKey([u]) then             //005ABB70..BB87 je->BDBC //005ABB8D jmp->BC39
      begin
        sub_00576EB0(DataModule2.Table1Mutter.AsInteger, st4); //005ABB92 Vorbereitung; [ebp-40] = Cache Table1Mutter (invariabel)
        while DataModule2.Table32Fv.AsString = u do        //005ABC39..BC6C je->BB92 //005ABC72 jmp->BDBC (Entry 005ABB8D jmp->BC39)
        begin
          if DataModule2.Table32Fm.AsString = st4 then     //005ABB92..BBC6 jne->BC17
          begin
            WriteLn(f, '1 FAMC @F' +                       //005ABBC8..BC12 CatN3
              IntToStr(StrToInt(DataModule2.Table32Fn.AsString)) + '@');
            Break;                                          //005ABC12 jmp->BDBC
          end;
          DataModule2.Table32.Next;                        //005ABC17..BC1F
          if DataModule2.Table32.Eof then Break;           //005ABC24..BC33 jne->BDBC
        end;
      end;
    end;
    if DataModule2.Table1Mutter.AsInteger > 0 then         //005ABC77..BC7B jle->ABDBC
    begin
      DataModule2.Table32.IndexName := 'm';                //005ABC81..BC8E
      DataModule2.Table32.First;                           //005ABC93..BC9B
      sub_00576EB0(DataModule2.Table1Mutter.AsInteger, u); //005ABCA0..BCAE (eax = [ebp-40] Cache Mutter)
      if DataModule2.Table32.FindKey([u]) then             //005ABCC1..BCD8 je->BDBC //005ABCDE jmp->BD82 (Entry)
      begin
        sub_00576EB0(DataModule2.Table1Vater.AsInteger, st4); //005ABCE3 Vorbereitung; edi = Cache Table1Vater (invariabel)
        while DataModule2.Table32Fm.AsString = u do        //005ABD82..BDB6 je->BCE3 / BDBC (Fallthrough)
        begin
          if DataModule2.Table32Fv.AsString = st4 then     //005ABCE3..BD16 jne->BD64
          begin
            WriteLn(f, '1 FAMC @F' +                       //005ABD18..BD62 CatN3
              IntToStr(StrToInt(DataModule2.Table32Fn.AsString)) + '@');
            Break;                                          //005ABD62 jmp->BDBC
          end;
          DataModule2.Table32.Next;                        //005ABD64..BD6C
          if DataModule2.Table32.Eof then Break;           //005ABD71..BD80 jne->BDBC
        end;
      end;
    end;
    kz := kz + 1;                               {005ABDBC inc [ebp-8]: kz-Slot-
                                                    Wiederverwendung als Schleifenzaehler}
    {ADOPT-Pruefung: gvar_02536660 (Asterisk-Liste der Adoptiv-Familien)}
    if Trim(gvar_02536660) <> '' then                       //005ABDBF..BDD6 jbe->ABED4
    begin
      sub_00576EB0(DataModule2.Table1Nummer.AsInteger, u); //005ABDDC..BDEF u = eigene 6er-Nr
      if Pos(u + '*', gvar_02536660) > 0 then             //005ABE04..BE17 jle->ABED4
      begin
        WriteLn(f, '1 ADOP');                             //005ABE1D..E2E
        WriteLn(f, '2 FAMC @F' +                            //005ABE33..ECF (Push Lit, CatN3)
          IntToStr(StrToInt(Copy(gvar_02536660,
            Pos(u + '*', gvar_02536660) + 7, 6))) + '@');
      end;
    end;
    {005ABED4: Tabellenende - Eof-Test der offenen Personenschleife;
      der je->8E78Zulauf zum while-Kopf (005A8E73) bleibt offen}
    DataModule2.Table1.Next;                              //005ABED4..BEEA jne->BEFE (Eof-Exit)
  end;                                                     // Schleifen-Ende: Kopf 005A8E73 jmp->BEEC; Weiter //005ABEEC..BEF8 je->8E78 (Body 005A8E78)
  DataModule2.Table32.IndexName := '';                     //005ABEFE..BF08 (Eof-Weg NACH der Schleife)
  DataModule2.Table32.First;                               //005ABF0D..BF1A jmp->D2C3 (Chunk8); Folgeblock 005ABF1F //005ABF8C je->BFEE
  while not DataModule2.Table32.Eof do                   //005AD2C3..D2D2 je->BF1F (Kopf-Test, First-Entry)
  begin
    WriteLn(f, '0 @F' + DataModule2.Table32Fn.AsString + '@ FAM'); //005ABF1F..BF64 CatN3
    if DataModule2.Table32Fv.AsString <> '000000' then    //005ABF69..BF8C je->BFEE
      WriteLn(f, '1 HUSB @I' +                            //005ABF8E..BFE9 CatN3
        IntToStr(StrToInt(DataModule2.Table32Fv.AsString)) + '@');
    if DataModule2.Table32Fm.AsString <> '000000' then    //005ABFEE..C011 je->C073
      WriteLn(f, '1 WIFE @I' +                            //005AC013..C06E CatN3
        IntToStr(StrToInt(DataModule2.Table32Fm.AsString)) + '@');
    if Length(DataModule2.Table32Fk.AsString) > 0 then     //005AC073..C093 jle->C16C
      for kz := 1 to                                      //005AC099..C0D2 jle->C16C
        Round(Length(DataModule2.Table32Fk.AsString) / 7) do
        WriteLn(f, '1 CHIL @I' +                          //005AC0DF..C166 jne->C0DF CatN3
          IntToStr(StrToInt(Copy(DataModule2.Table32Fk.AsString,
            7 * (kz - 1) + 1, 6))) + '@');
    if (Trim(DataModule2.Table32Vb.AsString) = 'E') or    //005AC16C..C1A0 je->C1DC
       (Trim(DataModule2.Table32Vb.AsString) = 'A') then  //005AC1A2..C1D6 jne->C7D2
    begin
      WriteLn(f, '1 MARR');                               //005AC1DC..C1ED
      if Trim(DataModule2.Table32Vb.AsString) = 'E' then  //005AC1F2..C226 jne->C2D2
        if ((Trim(DataModule2.Table32H.AsString) <> '') and //005AC22C..C257 jbe->C28F
            (Trim(DataModule2.Table32H.AsString) <> '.  .')) or //005AC259..C28D jne->C2BC
           (Trim(DataModule2.Table32Ho.AsString) <> '') then //005AC28F..C2BA jbe->C2D2
          WriteLn(f, '2 TYPE RELI');                      //005AC2BC..C2CD
      if Trim(DataModule2.Table32H.AsString) <> '' then   //005AC2D2..C2FD jbe->C33F
        WriteLn(f, '2 DATE ' + DataModule2.Table32H.AsString); //005AC2FF..C33A Cat3
      if Trim(DataModule2.Table32Ho.AsString) <> '' then  //005AC33F..C36A jbe->C758
      begin
        if DataModule2.Table13.FindKey(                   //005AC370..C3AD je->C5DA
          [DataModule2.Table32Ho.AsString]) then
        begin
          if gvar_02536650 = 1 then                       //005AC3B3..C3BA jne->C486
            WriteLn(f, '2 PLAC ' + AnsiToUtf8(            //005AC3C0..C47C CatN7
              DataModule2.Table32Ho.AsString + ',' +
              DataModule2.Table13Lkr.AsString + ',' +
              DataModule2.Table13Bland.AsString + ',' +
              DataModule2.Table13Land.AsString))
          else                                            //005AC481 jmp->C525
            WriteLn(f, '2 PLAC ' +                        //005AC486..C520 CatN8
              DataModule2.Table32Ho.AsString + ',' +
              DataModule2.Table13Lkr.AsString + ',' +
              DataModule2.Table13Bland.AsString + ',' +
              DataModule2.Table13Land.AsString);
          WriteLn(f, '3 _LOC @P' +                        //005AC525..C572 CatN3
            IntToStr(DataModule2.Table13.RecNo) + '@');    //   v150 = GetRecNo
          sub_00576EB0(DataModule2.Table13.RecNo, u);      //005AC577 6-stellig (Pos-Quelle)
          if Pos(u, locList) = 0 then                      //005AC5A2 jne->C5DA
          begin
            sub_00576EB0(DataModule2.Table13.RecNo, u);    //005AC5A4..C5BD (erneut)
            locList := locList + u + '*';                  //005AC5C2..C5D5 CatN3 [ebp-30]
          end;
        end;
        if Trim(DataModule2.Table32Htz.AsString) <> '' then //005AC5DA..C605 jbe->C6A7
        begin
          if gvar_02536650 = 1 then                       //005AC60B..C612 jne->C667
            WriteLn(f, '2 _WITN ' + AnsiToUtf8(           //005AC614..C660 CatN3
              DataModule2.Table32Htz.AsString))
          else                                            //005AC665 jmp->C6A7
            WriteLn(f, '2 _WITN ' +                       //005AC667..C6A2 Cat3
              DataModule2.Table32Htz.AsString);
        end;
        if DataModule2.Table32Hq.AsString <> '' then      //005AC6A7..C6C1 jbe->C758
          if DataModule2.Table38.FindKey(                 //005AC6C7..C704 je->C758
            [DataModule2.Table32Hq.AsString]) then
            WriteLn(f, '2 SOUR @S' +                      //005AC706..C753 CatN3
              IntToStr(DataModule2.Table38.RecNo) + '@');
      end;
      if Pos('E', DataModule2.Table32Vb.AsString) > 0 then //005AC758..C77D jle->C795
        WriteLn(f, '1 _STAT MARRIED');                    //005AC77F..C790
      if Pos('A', DataModule2.Table32Vb.AsString) > 0 then //005AC795..C7BA jle->C7D2
        WriteLn(f, '1 _STAT NOT MARRIED');                //005AC7BC..C7CD
    end;
    if ((Trim(DataModule2.Table32S.AsString) <> '') and   //005AC7D2..C7FD jbe->C835
        (Trim(DataModule2.Table32S.AsString) <> '.  .')) or //005AC7FF..C833 jne->C866
       (Trim(DataModule2.Table32So.AsString) <> '') then   //005AC835..C860 jbe->CD72
    begin
      WriteLn(f, '1 MARR');                               //005AC866..C877
      if (Trim(DataModule2.Table32S.AsString) <> '') or   //005AC87C..C8A7 ja->C8D6
         (Trim(DataModule2.Table32So.AsString) <> '') then //005AC8A9..C8D4 jbe->C8EC
        WriteLn(f, '2 TYPE CIVIL');                       //005AC8D6..C8E7
      if Trim(DataModule2.Table32S.AsString) <> '' then   //005AC8EC..C917 jbe->C959
        WriteLn(f, '2 DATE ' + DataModule2.Table32S.AsString); //005AC919..C954 Cat3
      if Trim(DataModule2.Table32So.AsString) <> '' then  //005AC959..C984 jbe->CD72
      begin
        if DataModule2.Table13.FindKey(                   //005AC98A..C9C7 je->CBF4
          [DataModule2.Table32So.AsString]) then
        begin
          if gvar_02536650 = 1 then                       //005AC9CD..C9D4 jne->CAA0
            WriteLn(f, '2 PLAC ' + AnsiToUtf8(            //005AC9DA..CA96 CatN7
              DataModule2.Table32So.AsString + ',' +
              DataModule2.Table13Lkr.AsString + ',' +
              DataModule2.Table13Bland.AsString + ',' +
              DataModule2.Table13Land.AsString))
          else                                            //005ACA9B jmp->CB3F
            WriteLn(f, '2 PLAC ' +                        //005ACAA0..CB3A CatN8
              DataModule2.Table32So.AsString + ',' +
              DataModule2.Table13Lkr.AsString + ',' +
              DataModule2.Table13Bland.AsString + ',' +
              DataModule2.Table13Land.AsString);
          WriteLn(f, '3 _LOC @P' +                        //005ACB3F..CB8C CatN3
            IntToStr(DataModule2.Table13.RecNo) + '@');    //   v150 = GetRecNo
          sub_00576EB0(DataModule2.Table13.RecNo, u);      //005ACB91 6-stellig (Pos-Quelle)
          if Pos(u, locList) = 0 then                      //005ACBBC jne->CBF4
          begin
            sub_00576EB0(DataModule2.Table13.RecNo, u);    //005ACBBE..CBD7 (erneut)
            locList := locList + u + '*';                  //005ACBDC..CBEF CatN3
          end;
        end;
        if Trim(DataModule2.Table32Stz.AsString) <> '' then //005ACBF4..CC1F jbe->CCC1
        begin
          if gvar_02536650 = 1 then                       //005ACC25..CC2C jne->CC81
            WriteLn(f, '2 _WITN ' + AnsiToUtf8(           //005ACC2E..CC7A CatN3
              DataModule2.Table32Stz.AsString))
          else                                            //005ACC7F jmp->CCC1
            WriteLn(f, '2 _WITN ' +                       //005ACC81..CCBC Cat3
              DataModule2.Table32Stz.AsString);
        end;
        if DataModule2.Table32Sq.AsString <> '' then      //005ACCC1..CCDB jbe->CD72
          if DataModule2.Table38.FindKey(                 //005ACCE1..CD1E je->CD72
            [DataModule2.Table32Sq.AsString]) then
            WriteLn(f, '2 SOUR @S' +                      //005ACD20..CD6D CatN3
              IntToStr(DataModule2.Table38.RecNo) + '@');
      end;
    end;
    if ((Trim(DataModule2.Table32Sch.AsString) <> '') and //005ACD72..CD9D jbe->CDD5
        (Trim(DataModule2.Table32Sch.AsString) <> '.  .')) or //005ACD9F..CDD3 jne->CE06
       (Trim(DataModule2.Table32Scho.AsString) <> '') then //005ACDD5..CE00 jbe->D210
    begin
      WriteLn(f, '1 DIV');                                //005ACE06..CE17
      if Trim(DataModule2.Table32Sch.AsString) <> '' then //005ACE1C..CE47 jbe->CE89
        WriteLn(f, '2 DATE ' + DataModule2.Table32Sch.AsString); //005ACE49..CE84 Cat3
      if Trim(DataModule2.Table32Scho.AsString) <> '' then //005ACE89..CEB4 jbe->D15F
      begin
        DataModule2.Table13.FindKey(                      //005ACEBA..CEF0 (al ungetestet)
          [DataModule2.Table32Scho.AsString]);
        if gvar_02536650 = 1 then                         //005ACEF5..CEFC jne->CFC8
          WriteLn(f, '2 PLAC ' + AnsiToUtf8(              //005ACF02..CFBE CatN7
            DataModule2.Table32Scho.AsString + ',' +
            DataModule2.Table13Lkr.AsString + ',' +
            DataModule2.Table13Bland.AsString + ',' +
            DataModule2.Table13Land.AsString))
        else                                              //005ACFC3 jmp->D067
          WriteLn(f, '2 PLAC ' +                          //005ACFC8..D062 CatN8
            DataModule2.Table32Scho.AsString + ',' +
            DataModule2.Table13Lkr.AsString + ',' +
            DataModule2.Table13Bland.AsString + ',' +
            DataModule2.Table13Land.AsString);
        if DataModule2.Table13.FindKey(                   //005AD067..D0A4 je->D15F
          [DataModule2.Table32Scho.AsString]) then
        begin
          WriteLn(f, '3 _LOC @P' +                        //005AD0AA..D0F7 CatN3
            IntToStr(DataModule2.Table13.RecNo) + '@');    //   v150 = GetRecNo
          sub_00576EB0(DataModule2.Table13.RecNo, u);      //005AD0FC 6-stellig (Pos-Quelle)
          if Pos(u, locList) = 0 then                      //005AD127 jne->D15F
          begin
            sub_00576EB0(DataModule2.Table13.RecNo, u);    //005AD129..D142 (erneut)
            locList := locList + u + '*';                  //005AD147..D15A CatN3
          end;
        end;
        if Trim(DataModule2.Table32Schq.AsString) <> '' then //005AD15F..D179 jbe->D210
          if DataModule2.Table38.FindKey(                 //005AD17F..D1BC je->D210
            [DataModule2.Table32Schq.AsString]) then
            WriteLn(f, '2 SOUR @S' +                      //005AD1BE..D20B CatN3
              IntToStr(DataModule2.Table38.RecNo) + '@');
      end;
    end;
    if DataModule2.Table32Vb.AsString = 'A' then          //005AD210..D233 jne->D2A5
      if (Trim(DataModule2.Table32Fv.AsString) <> '') and //005AD235..D260 jbe->D2A5
         (Trim(DataModule2.Table32Fm.AsString) <> '') then //005AD262..D28D jbe->D2A5
        WriteLn(f, '2 NOTE not marr');                    //005AD28F..D2A0
    DataModule2.Table32.Next;                             //005AD2A5..D2AD
    if DataModule2.Table32.Eof then Break;                //005AD2B2..D2C1 jne->D2D8
  end;                                                    // While-Ende: Kopf je->BF1F
  DataModule2.Table32.Close;                              //005AD2D8..D2E0
  if Trim(locList) <> '' then                             //005AD2E5..D2FA jbe->DC3D
    for kz := 1 to                                        //005AD300..D324 jle->DC3D
      Round(Length(locList) / 7) - 1 do
    begin
      WriteLn(f, '0 @P' +                                 //005AD331..D393 CatN3
        IntToStr(StrToInt(Copy(locList, 7 * (kz - 1) + 1, 6))) + '@ _LOC');
      //005AD398..D3AC v1A0 GotoBookmark Table13(StrToInt(Copy)) - Stub, Original positionierte auf den Bookmark
      if gvar_02536650 = 1 then                           //005AD3B2..D3B9 jne->D40E
        WriteLn(f, '1 NAME ' + AnsiToUtf8(                //005AD3BB..D407 CatN3
          DataModule2.Table13Ort.AsString))
      else                                                //005AD40C jmp->D44E
        WriteLn(f, '1 NAME ' +                            //005AD40E..D449 Cat3
          DataModule2.Table13Ort.AsString);
      if Trim(DataModule2.Table13Abk.AsString) <> '' then //005AD44E..D479 jbe->D51B
      begin
        if gvar_02536650 = 1 then                         //005AD47F..D486 jne->D4DB
          WriteLn(f, '1 _ABBR ' + AnsiToUtf8(             //005AD488..D4D4 CatN3
            DataModule2.Table13Abk.AsString))
        else                                              //005AD4D9 jmp->D51B
          WriteLn(f, '1 _ABBR ' +                         //005AD4DB..D516 Cat3
            DataModule2.Table13Abk.AsString);
      end;
      if Trim(DataModule2.Table13PLZ.AsString) <> '' then //005AD51B..D546 jbe->D588
        WriteLn(f, '1 _FPOST ' +                          //005AD548..D583 Cat3
          DataModule2.Table13PLZ.AsString);
      if Trim(DataModule2.Table13Lkr.AsString) <> '' then //005AD588..D5B3 jbe->D655
      begin
        if gvar_02536650 = 1 then                         //005AD5B9..D5C0 jne->D615
          WriteLn(f, '1 _FCNTY ' + AnsiToUtf8(            //005AD5C2..D60E CatN3
            DataModule2.Table13Lkr.AsString))
        else                                              //005AD613 jmp->D655
          WriteLn(f, '1 _FCNTY ' +                        //005AD615..D650 Cat3
            DataModule2.Table13Lkr.AsString);
      end;
      if Trim(DataModule2.Table13Bland.AsString) <> '' then //005AD655..D680 jbe->D722
      begin
        if gvar_02536650 = 1 then                         //005AD686..D68D jne->D6E2
          WriteLn(f, '1 _FSTAE ' + AnsiToUtf8(            //005AD68F..D6DB CatN3
            DataModule2.Table13Bland.AsString))
        else                                              //005AD6E0 jmp->D722
          WriteLn(f, '1 _FSTAE ' +                        //005AD6E2..D71D Cat3
            DataModule2.Table13Bland.AsString);
      end;
      if Trim(DataModule2.Table13Land.AsString) <> '' then //005AD722..D74D jbe->D7EF
      begin
        if gvar_02536650 = 1 then                         //005AD753..D75A jne->D7AF
          WriteLn(f, '1 _FCTRY ' + AnsiToUtf8(            //005AD75C..D7A8 CatN3
            DataModule2.Table13Land.AsString))
        else                                              //005AD7AD jmp->D7EF
          WriteLn(f, '1 _FCTRY ' +                        //005AD7AF..D7EA Cat3
            DataModule2.Table13Land.AsString);
      end;
      if (Trim(DataModule2.Table13Ort.AsString) <> '') and //005AD7EF..D81A jbe->D8ED
         (Trim(DataModule2.Table13Maid.AsString) <> '') then //005AD820..D84B jbe->D8ED
        if gvar_02536650 = 1 then                         //005AD851..D858 jne->D8AD
          WriteLn(f, '1 _GOV ' + AnsiToUtf8(              //005AD85A..D8A6 CatN3
            DataModule2.Table13Gov.AsString))
        else                                              //005AD8AB jmp->D8ED
          WriteLn(f, '1 _GOV ' +                          //005AD8AD..D8E8 Cat3
            DataModule2.Table13Gov.AsString);
      if (Trim(DataModule2.Table13Bg.AsString) <> '') or  //005AD8ED..D918 ja->D947
         (Trim(DataModule2.Table13Lg.AsString) <> '') then //005AD91A..D945 jbe->D95D
        WriteLn(f, '1 MAP');                              //005AD947..D958
      if (Trim(DataModule2.Table13Ort.AsString) <> '') and //005AD95D..D988 jbe->DA5B
         (Trim(DataModule2.Table13Lg.AsString) <> '') then //005AD98E..D9B9 jbe->DA5B
        if gvar_02536650 = 1 then                         //005AD9BF..D9C6 jne->DA1B
          WriteLn(f, '2 LONG ' + AnsiToUtf8(              //005AD9C8..DA14 CatN3
            DataModule2.Table13Lg.AsString))
        else                                              //005ADA19 jmp->DA5B
          WriteLn(f, '2 LONG ' +                          //005ADA1B..DA56 Cat3
            DataModule2.Table13Lg.AsString);
      if (Trim(DataModule2.Table13Ort.AsString) <> '') and //005ADA5B..DA86 jbe->DB59
         (Trim(DataModule2.Table13Bg.AsString) <> '') then //005ADA8C..DAB7 jbe->DB59
        if gvar_02536650 = 1 then                         //005ADABD..DAC4 jne->DB19
          WriteLn(f, '2 LATI ' + AnsiToUtf8(              //005ADAC6..DB12 CatN3
            DataModule2.Table13Bg.AsString))
        else                                              //005ADB17 jmp->DB59
          WriteLn(f, '2 LATI ' +                          //005ADB19..DB54 Cat3
            DataModule2.Table13Bg.AsString);
      if Trim(DataModule2.Table13Maid.AsString) <> '' then //005ADB59..DB84 jbe->DBC6
        WriteLn(f, '1 _MAIDENHEAD ' +                     //005ADB86..DBC1 Cat3
          DataModule2.Table13Maid.AsString);
      if Trim(DataModule2.Table13Gov.AsString) <> '' then //005ADBC6..DBF1 jbe->DC33
        WriteLn(f, '1 _GOV ' +                            //005ADBF3..DC2E Cat3
          DataModule2.Table13Gov.AsString);
    end;                                                  //005ADC33..DC37 jne->D331 (Danach 005ADC3D)
  DataModule2.Table38.Open;                                //005ADC3D..DC45 TDataSet.Open
  DataModule2.Table38.IndexName := 'tit';                  //005ADC4A..DC57 SetIndexName 'tit'
  DataModule2.Table38.First;                               //005ADC5C..DC64 TDataSet.First
  if DataModule2.Table38.RecordCount > 0 then              //005ADC69..DC7B jle->E727 v14C GetRecordCount
    while not DataModule2.Table38.Eof do                   //005ADC81 jmp->E712
    begin
      stVon := '';                                         //005ADC86..DC89 LStrClr [ebp-3C]
      WriteLn(f, '0 @S' +                                  //005ADC8E..DCD5 CatN3 (edx=3)
        IntToStr(DataModule2.Table38.RecNo) + '@ SOUR');    //   v150 GetRecNo
      if Trim(DataModule2.Table38Titel.AsString) <> '' then //005ADCDA..DD05 jbe->DDA7
        if gvar_02536650 = 1 then                          //005ADD0B..DD12 jne->DD67
          WriteLn(f, '1 TITL ' + AnsiToUtf8(               //005ADD14..DD60 CatN3
            DataModule2.Table38Titel.AsString))
        else                                               //005ADD65 jmp->DDA7
          WriteLn(f, '1 TITL ' +                           //005ADD67..DDA2 Cat3
            DataModule2.Table38Titel.AsString);
      if Trim(DataModule2.Table38Abk.AsString) <> '' then  //005ADDA7..DDD2 jbe->DE74
        if gvar_02536650 = 1 then                          //005ADDD8..DDDF jne->DE34
          WriteLn(f, '1 ABBR ' + AnsiToUtf8(               //005ADDE1..DE2D CatN3
            DataModule2.Table38Abk.AsString))
        else                                               //005ADE32 jmp->DE74
          WriteLn(f, '1 ABBR ' +                           //005ADE34..DE6F Cat3
            DataModule2.Table38Abk.AsString);
      if Trim(DataModule2.Table38Ereig.AsString) <> '' then //005ADE74..DE9F jbe->DF41
        if gvar_02536650 = 1 then                          //005ADEA5..DEAC jne->DF01
          WriteLn(f, '2 EVEN ' + AnsiToUtf8(               //005ADEAE..DEFA CatN3
            DataModule2.Table38Ereig.AsString))
        else                                               //005ADEFF jmp->DF41
          WriteLn(f, '2 EVEN ' +                           //005ADF01..DF3C Cat3
            DataModule2.Table38Ereig.AsString);
      if Trim(DataModule2.Table38Von.AsString) <> '' then  //005ADF41..DF6C jbe->DF94
        stVon := 'FROM ' + DataModule2.Table38Von.AsString; //005ADF6E..DF8F Cat3
      if Trim(DataModule2.Table38Bis.AsString) <> '' then  //005ADF94..DFBF jbe->DFEF
        stVon := stVon + ' TO ' +                          //005ADFC1..DFEA CatN3
          DataModule2.Table38Bis.AsString;
      if Trim(DataModule2.Table38Von.AsString +            //005ADFEF..E040 jbe->E0B2
        DataModule2.Table38Bis.AsString) <> '' then
        if gvar_02536650 = 1 then                          //005AE042..E049 jne->E088
          WriteLn(f, '3 DATE ' + AnsiToUtf8(stVon))        //005AE04B..E086 jmp->E0B2
        else                                               //005AE088..E0AD
          WriteLn(f, '3 DATE ' + stVon);
      if Trim(DataModule2.Table38Standort.AsString) <> '' then //005AE0B2..E0DD jbe->E17F
        if gvar_02536650 = 1 then                          //005AE0E3..E0EA jne->E13F
          WriteLn(f, '3 PLAC ' + AnsiToUtf8(               //005AE0EC..E138 CatN3
            DataModule2.Table38Standort.AsString))
        else                                               //005AE13D jmp->E17F
          WriteLn(f, '3 PLAC ' +                           //005AE13F..E17A Cat3
            DataModule2.Table38Standort.AsString);
      if Trim(DataModule2.Table38Publ.AsString) <> '' then //005AE17F..E1AA jbe->E24C
        if gvar_02536650 = 1 then                          //005AE1B0..E1B7 jne->E20C
          WriteLn(f, '1 PUBL ' + AnsiToUtf8(               //005AE1B9..E205 CatN3
            DataModule2.Table38Publ.AsString))
        else                                               //005AE20A jmp->E24C
          WriteLn(f, '1 PUBL ' +                           //005AE20C..E247 Cat3
            DataModule2.Table38Publ.AsString);
      if Trim(DataModule2.Table38Bestand.AsString) <> '' then //005AE24C..E277 jbe->E319
        if gvar_02536650 = 1 then                          //005AE27D..E284 jne->E2D9
          WriteLn(f, '2 CALN ' + AnsiToUtf8(               //005AE286..E2D2 CatN3
            DataModule2.Table38Bestand.AsString))
        else                                               //005AE2D7 jmp->E319
          WriteLn(f, '2 CALN ' +                           //005AE2D9..E314 Cat3
            DataModule2.Table38Bestand.AsString);
      if Length(DataModule2.Table38Bem.AsString) + 7 < 253 then //005AE319..E33F jge->E3E9
      begin
        if gvar_02536650 = 1 then                          //005AE345..E34C jne->E3A4
          WriteLn(f, '2 NOTE ' + AnsiToUtf8(               //005AE34E..E39F jmp->E627
            DataModule2.Table38Bem.AsString))
        else                                               //005AE3A4..E3E4 jmp->E627
          WriteLn(f, '2 NOTE ' +
            DataModule2.Table38Bem.AsString);
      end
      else if gvar_02536650 = 1 then                       //005AE3E9..E3F0 jne->E524
      begin
        WriteLn(f, '2 NOTE ' + AnsiToUtf8(Copy(            //005AE3F6..E45E CatN3
          DataModule2.Table38Bem.AsString, 1, 245)));
        for kz := 1 to                                    //005AE463..E49C jle->E627
          Round(Length(DataModule2.Table38Bem.AsString) / 245) do //   kz-Reuse [ebp-8]
          WriteLn(f, '3 CONC ' + AnsiToUtf8(Copy(         //005AE519..E51D jne->E4A9
            DataModule2.Table38Bem.AsString, 245 * kz + 1, 245)));
      end
      else                                                 //005AE51F jmp->E627
      begin
        WriteLn(f, '2 NOTE ' + Copy(                      //005AE524..E57B Cat3
          DataModule2.Table38Bem.AsString, 1, 245));
        for kz := 1 to                                    //005AE580..E5B9 jle->E627
          Round(Length(DataModule2.Table38Bem.AsString) / 245) do //   kz-Reuse [ebp-8]
          WriteLn(f, '3 CONC ' + Copy(                    //005AE621..E625 jne->E5C2
            DataModule2.Table38Bem.AsString, 245 * kz + 1, 245));
      end;
      if Trim(DataModule2.Table38Med.AsString) <> '' then //005AE627..E652 jbe->E6F4
        if gvar_02536650 = 1 then                          //005AE658..E65F jne->E6B4
          WriteLn(f, '3 MEDI ' + AnsiToUtf8(               //005AE661..E6B2 jmp->E6F4
            DataModule2.Table38Med.AsString))
        else                                               //005AE6B4..E6EF
          WriteLn(f, '3 MEDI ' +
            DataModule2.Table38Med.AsString);
      DataModule2.Table38.Next;                            //005AE6F4..E6FC TDataSet.Next
    end;                                                   //005AE701..E710 jne->E727 //005AE712..E721 je->DC86 (Kopf)
  Form1.Label18.Hide;                                     //005AE727..E734 [400] TControl.Hide
  Form1.Label19.Hide;                                     //005AE739..E746 [404] TControl.Hide
  WriteLn(f, '0 TRLR');                                   //005AE74B..E75C
  CloseFile(f);                                           //005AE761..E768 @Close + @_IOTest
  Form1.Refresh;                                          //005AE76D..E774 TControl.Refresh
  DataModule2.Table1.IndexName := '';                     //005AE779..E780 [5C] xor edx = ''
  DataModule2.Table1.FindKey([krg]);                      //005AE785..E7A2 [5C] offener Array-Index 0, Result ungenutzt
  Form1.anzeigen;                                         //005AE7A7..E7AE
end;

procedure TForm3.gedein_neu;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm3.gedein2;
var
  fname: AnsiString;    {005969D6 [ebp-0A0] OpenDialog1.FileName}
  f: TextFile;          {00596A04 [ebp-270] GEDCOM-Eingabedatei}
  zeile: AnsiString;    {00596A1F [ebp-34] aktuelle Eingabezeile}
  verarbz: Integer;     {00596A29 [ebp-30] verarbeitete Datensaetze INDI+FAM (Fortschritt)}
  datenz: Integer;      {00596A2E [ebp-2C] Anzahl INDI+FAM-Kopfzeilen aus Pre-Pass (Fortschritt-Nenner)}
  indnr: Integer;       {00596A31 [ebp-18] laufende INDI-Nummer (Start gvar_02536940)}
  idnr: Integer;        {00596D10 ebx orig. INDI-Nummer der Kopfzeile (Repso2alt)}
  ctx: AnsiString;      {00596CD7 [ebp-38] aktueller Abschnitt ('NI','adop','AD','Rel','chan','R','Ed','N','B','C','S','U','marr')}
  schl: AnsiString;     {00597535 [ebp-3C] Datensatz-Schluessel ('@N...','@S...','@P...') fuer Repso2.FindKey}
  zst: AnsiString;      {00597584 [ebp-318] Ergebnis-Temp von zsa (Original: je Aufruf eigener Speicher)}
  aktnr: Integer;       {00597CE7 [ebp-1C] Nummer des aktuellen INDI-Datensatzes (0 ausserhalb)}
  adrz: Word;           {00597C48 [ebp-12] Zaehler der '3 CONT'-Adresszeilen (je INDI neu 1)}
  anst: AnsiString;     {0059808E [ebp-3A8] Ausgabe-Temp von ans (Original: je Aufruf eigener Speicher)}
  famcs: AnsiString;    {005984C4 [ebp-0A4] ADOP-FAMC-Liste ('NNNNNN*'-Ketten, Start '')}
  ibmflag: Word;        {005969B8 [ebp-6] 1 = '1 CHAR IBM'}
  ansiflag: Word;       {005969C4 [ebp-0C] 1 = '1 CHAR ANSI'}
  utfflag: Word;        {005969CA [ebp-0E] 1 = '1 CHAR UTF' -> Utf8ToAnsi}
  unicflag: Word;       {005969D0 [ebp-10] 1 = '1 CHAR UNIC'}
begin
  { 00596994: gedein2 - GEDCOM-INDI-Import:
    liest die vom OpenDialog1 gewaehlte Datei zeilenweise ein; im Kopf-
    Abschnitt werden die Kennzeichen '1 CHAR IBM/ANSI/UTF/UNIC'
    ausgewertet (utfflag steuert spaeter Utf8ToAnsi), danach wird bis
    zur ersten Zeile mit '0 @' oder 'INDI' weitergelesen und anschli-
    iessend bis zum ersten '@ INDI'-Kopf uebersprungen. Die Pre-Pass-
    Schleife (ab 00596CBF) zaehlt alle INDI-/FAM-Kopfzeilen in datenz
    und fuegt die INDI-Nummern in das Client-Data-Set Form1.Repso2
    (Index 'ih') ein, der Haupt-Lauf (ab 00597C33) wertet die Daten-
    saetze aus und meldet verarbz/datenz als Fortschritt.
    SEH-Rahmen/Prolog-Teardown (@LStrArrayClr/@LStrClr ab 0059C909) -
    nicht transkribiert (wie gedaus/gedein). }

  ibmflag := 0;                                       //005969B8 [ebp-6]
  //005969BE [ebp-0A] := 0 - toter Zaehler (einziges Vorkommen)
  ansiflag := 0;                                      //005969C4 [ebp-0C]
  utfflag := 0;                                       //005969CA [ebp-0E]
  unicflag := 0;                                      //005969D0 [ebp-10]
  fname := Form1.OpenDialog1.FileName;                //005969D6..69E9 [ebp-0A0]
  Screen.Cursor := crHourGlass;                       //005969EE..69F9 0FFF5
  System.Assign(f, fname);                            //005969FE..6A0A @Assign
  Reset(f);                                           //00596A0F..6A1A @ResetText+@IOTest
  zeile := '';                                        //00596A1F..6A22 @LStrClr
  verarbz := 0;                                       //00596A29 [ebp-30]
  datenz := 0;                                        //00596A2E [ebp-2C]
  indnr := gvar_02536940;                             //00596A31..6A38 [ebp-18]
  if gvar_02536940 = 0 then                           //00596A3B..6A43 jne->6ABA
  begin
    DataModule2.Table1.Close;                         //00596A45..6A4F [5C]
    DataModule2.Table1.EmptyTable;                    //00596A54..6A5E
    DataModule2.Table1.Open;                          //00596A63..6A6D
    DataModule2.Table5.Open;                          //00596A72..6A7F [80]
    DataModule2.Table5.Close;                         //00596A84..6A91
    DataModule2.Table5.EmptyTable;                    //00596A96..6AA3
    DataModule2.Table5.Open;                          //00596AA8..6AB5
  end;
  DataModule2.Table1.Open;                            //00596ABA..6AC4 [5C]
  DataModule2.Table5.Open;                            //00596AC9..6AD6 [80]
  Form1.Repso2.Open;                                  //00596ADB..6AE8 [8C0]
  Form1.Repso2.EmptyDataSet;                          //00596AED..6AFA
  Form1.Refresh;                                      //00596AFF..6B06
  //00596B0B jmp->6C0E (Eintrittssprung zur Schleifenbedingung)
  while (Pos('0 @', zeile) = 0) and                   //00596C1D jne->6C34 (Exit)
        (Pos('INDI', zeile) = 0) do                   //00596C2E je->6B10 (Ruecklauf)
  begin
    if Pos('1 CHAR ', zeile) > 0 then                 //00596B10..6B1F jle->6BC5
    begin
      if Pos('1 CHAR IBM', UpperCase(zeile)) > 0 then //00596B25..6B45 jle->6B4D
        ibmflag := 1;                                 //00596B47 [ebp-6]
      if Pos('1 CHAR UTF', UpperCase(zeile)) > 0 then //00596B4D..6B6D jle->6B75
        utfflag := 1;                                 //00596B6F [ebp-0E]
      if Pos('1 CHAR ANSI', UpperCase(zeile)) > 0 then //00596B75..6B95 jle->6B9D
        ansiflag := 1;                                //00596B97 [ebp-0C]
      if Pos('1 CHAR UNIC', UpperCase(zeile)) > 0 then //00596B9D..6BBD jle->6BC5
        unicflag := 1;                                //00596BBF [ebp-10]
    end;
    //00596BC5..6BD2 Pos('3 _EXTENDED_LOCATIONS', zeile) - Ergebnis verworfen (toter Aufruf)
    ReadLn(f, zeile);                                 //00596BD4..6BED
    zeile := Trim(zeile);                             //00596BF2..6C09
  end;
  Form1.Label19.Visible := True;                      //00596C34..6C43 [404]
  Form1.Label19.Caption := 'Gedcom vorbereiten';      //00596C48..6C5A
  Form1.Label19.Refresh;                              //00596C5F..6C6C
  zeile := '';                                        //00596C71..6C74 @LStrClr
  Reset(f);                                           //00596C79..6C84 @ResetText+@IOTest
  //00596C89 jmp->6CA9 (Eintrittssprung zur Bedingung)
  while Pos('@ INDI', zeile) = 0 do                   //00596CA9..6CB8 je->6C8B
    ReadLn(f, zeile);                                 //00596C8B..6CA4
  //00596CBA jmp->7AFF - Eintritt in die Bedingung der Pre-Pass-Schleife
  while Pos('0 TRLR', zeile) = 0 do                   //00597AFF..7B0E je->6CBF
  begin
    if Pos('@ INDI', zeile) > 0 then                   //00596CBF..6CCE jle->6D7C
    begin
      inc(datenz);                                     //00596CD4 [ebp-2C]
      ctx := '';                                       //00596CD7..6CDA [ebp-38]
      idnr := StrToInt(Copy(zeile, 5, Pos('@ INDI', zeile) - 5)); //00596CDF..6D10 ebx
      inc(indnr);                                      //00596D12 [ebp-18]
      Form1.Repso2.Append;                             //00596D15..6D22 [8C0]
      Form1.Repso2nr.AsInteger := indnr;               //00596D27..6D39 [8C8]
      Form1.Repso2alt.AsString := IntToStr(idnr);      //00596D3F..6D61 [8D4]
      Form1.Repso2.Post;                               //00596D67..6D76
    end;
    if Pos('0 @F', zeile) > 0 then                     //00596D7C..6D8B jle->6D90
      inc(datenz);                                     //00596D8D [ebp-2C]
    if Pos('1 SOUR @S', zeile) > 0 then                //00596D90..6D9F jle->6ECA
    begin
      Form1.Repso2.IndexName := 'ih';                  //00596DA5..6DB7 [8C0]
      if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 14))]) then //00596DBC..6E18 jne->6ECA
      begin
        Form1.Repso2.Append;                           //00596E1E..6E2B
        Form1.Repso2nr.AsInteger := indnr;             //00596E30..6E42
        Form1.Repso2alt.AsString := IntToStr(idnr);    //00596E48..6E6A
        Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 14)); //00596E70..6EAF
        Form1.Repso2.Post;                             //00596EB5..6EC4
      end;
    end;
    if Pos('2 SOUR @S', zeile) > 0 then                //00596ECA..6ED9 jle->7004
    begin
      Form1.Repso2.IndexName := 'ih';                  //00596EDF..6EF1
      if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 14))]) then //00596EF6..6F52 jne->7004
      begin
        Form1.Repso2.Append;                           //00596F58..6F65
        Form1.Repso2nr.AsInteger := indnr;             //00596F6A..6F7C
        Form1.Repso2alt.AsString := IntToStr(idnr);    //00596F82..6FA4
        Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 14)); //00596FAA..6FE9
        Form1.Repso2.Post;                             //00596FEF..6FFE
      end;
    end;
    if Pos('1 REPO @R', zeile) > 0 then                //00597004..7013 jle->713E
    begin
      Form1.Repso2.IndexName := 'ih';                  //00597019..702B
      if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 14))]) then //00597030..708C jne->713E
      begin
        Form1.Repso2.Append;                           //00597092..709F
        Form1.Repso2nr.AsInteger := indnr;             //005970A4..70B6
        Form1.Repso2alt.AsString := IntToStr(idnr);    //005970BC..70DE
        Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 14)); //005970E4..7123
        Form1.Repso2.Post;                             //00597129..7138
      end;
    end;
    if Pos('3 _LOC @P', zeile) > 0 then                //0059713E..714D jle->7278
    begin
      Form1.Repso2.IndexName := 'ih';                  //00597153..7165
      if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 14))]) then //0059716A..71C6 jne->7278
      begin
        Form1.Repso2.Append;                           //005971CC..71D9
        Form1.Repso2nr.AsInteger := indnr;             //005971DE..71F0
        Form1.Repso2alt.AsString := IntToStr(idnr);    //005971F6..7218
        Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 14)); //0059721E..725D
        Form1.Repso2.Post;                             //00597263..7272
      end;
    end;
    if Pos('1 NOTE @N', zeile) > 0 then                //00597278..7287 jle->73B2
    begin
      Form1.Repso2.IndexName := 'ih';                  //0059728D..729F
      if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 14))]) then //005972A4..7300 jne->73B2
      begin
        Form1.Repso2.Append;                           //00597306..7313
        Form1.Repso2nr.AsInteger := indnr;             //00597318..732A
        Form1.Repso2alt.AsString := IntToStr(idnr);    //00597330..7352
        Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 14)); //00597358..7397
        Form1.Repso2.Post;                             //0059739D..73AC
      end;
    end;
    if Pos('2 NOTE @N', zeile) > 0 then                //005973B2..73C1 jle->74EC
    begin
      Form1.Repso2.IndexName := 'ih';                  //005973C7..73D9
      if not Form1.Repso2.FindKey([Trim(Copy(zeile, 8, 14))]) then //005973DE..743A jne->74EC
      begin
        Form1.Repso2.Append;                           //00597440..744D
        Form1.Repso2nr.AsInteger := indnr;             //00597452..7464
        Form1.Repso2alt.AsString := IntToStr(idnr);    //0059746A..748C
        Form1.Repso2inh.AsString := Trim(Copy(zeile, 8, 14)); //00597492..74D1
        Form1.Repso2.Post;                             //005974D7..74E6
      end;
    end;
    if (Pos('0 @N', zeile) > 0) and                  //005974EC..74FB jle->765C
       (Pos('0 @NI', zeile) = 0) then                //00597501..7510 jne->765C
    begin
      schl := Trim(Copy(zeile, 3, 14));              //00597516..7538
      schl := LeftStr(schl, Length(schl) - 5);       //0059753D..7561
      ReadLn(f, zeile);                              //00597566..757F
      zsa(zeile, zst);                               //00597584..7590
      zeile := zst;                                  //00597595..759E
      Form1.Repso2.IndexName := 'ih';                //005975A3..75B5
      if Form1.Repso2.FindKey([schl]) then           //005975BA..75E9 je->765C
      begin
        Form1.Repso2.Edit;                           //005975EB..75F8
        Form1.Repso2inh2.AsString := Trim(Copy(zeile, 8, Length(zeile))); //005975FD..7641 [8D0]
        Form1.Repso2.Post;                           //00597647..7656
      end;
    end;
    if Pos('0 @S', zeile) > 0 then                   //0059765C..766B jle->77C9
    begin
      schl := Trim(Copy(zeile, 3, 14));              //00597671..7693
      schl := LeftStr(schl, Length(schl) - 5);       //00597698..76BC
      ReadLn(f, zeile);                              //005976C1..76DA
      zsa(zeile, zst);                               //005976DF..76EB
      zeile := zst;                                  //005976F0..76F9
      if utfflag = 1 then                            //005976FE..7703 jne->7710
        zeile := Utf8ToAnsi(zeile);                  //00597705..770B
      Form1.Repso2.IndexName := 'ih';                //00597710..7722
      if Form1.Repso2.FindKey([schl]) then           //00597727..7756 je->77C9
      begin
        Form1.Repso2.Edit;                           //00597758..7765
        Form1.Repso2inh2.AsString := Trim(Copy(zeile, 8, Length(zeile))); //0059776A..77AE [8D0]
        Form1.Repso2.Post;                           //005977B4..77C3
      end;
    end;
    if Pos('0 @P', zeile) > 0 then                   //005977C9..77D8 jle->7936
    begin
      schl := Trim(Copy(zeile, 3, 14));              //005977DE..7800
      schl := LeftStr(schl, Length(schl) - 5);       //00597805..7829
      ReadLn(f, zeile);                              //0059782E..7847
      zsa(zeile, zst);                               //0059784C..7858
      zeile := zst;                                  //0059785D..7866
      if utfflag = 1 then                            //0059786B..7870 jne->787D
        zeile := Utf8ToAnsi(zeile);                  //00597872..7878
      Form1.Repso2.IndexName := 'ih';                //0059787D..788F
      if Form1.Repso2.FindKey([schl]) then           //00597894..78C3 je->7936
      begin
        Form1.Repso2.Edit;                           //005978C5..78D2
        Form1.Repso2inh2.AsString := Trim(Copy(zeile, 8, Length(zeile))); //005978D7..791B [8D0]
        Form1.Repso2.Post;                           //00597921..7930
      end;
    end;
    if Pos('0 @NI', zeile) > 0 then                   //00597936..7945 jle->79A4
    begin
      ctx := 'NI';                                    //00597947..794F [ebp-38]
      schl := Trim(Copy(zeile, 3, 14));               //00597954..7976
      schl := LeftStr(schl, Length(schl) - 5);        //0059797B..799F
    end;
    if (Pos('1 CON', zeile) > 0) and                  //005979A4..79B3 jle->7AC2
       (ctx = 'NI') then                              //005979B9..79C6 jne->7AC2
    begin
      Form1.Repso2.IndexName := 'ih';                 //005979CC..79DE
      if Form1.Repso2.FindKey([schl]) then            //005979E3..7A12 je->7AC2
      begin
        Form1.Repso2.Edit;                            //00597A18..7A25
        Form1.Repso2inh2.AsString := Form1.Repso2inh2.AsString +
          Trim(Copy(zeile, 8, Length(zeile))) + #13#10;   //00597A2A..7AA7 [8D0]
        Form1.Repso2.Post;                            //00597AAD..7ABC
      end;
    end;
    ReadLn(f, zeile);                                 //00597AC2..7ADB
    zsa(zeile, zst);                                  //00597AE0..7AEC
    zeile := zst;                                     //00597AF1..7AFA
  end;
  Reset(f);                                           //00597B14..7B1F @ResetText+@IOTest
  zeile := '';                                        //00597B24..7B27 @LStrClr
  DataModule2.Table1.DisableControls;                 //00597B2C..7B36 [5C]
  DataModule2.Table5.DisableControls;                 //00597B3B..7B48 [80]
  indnr := gvar_02536940;                             //00597B4D..7B54 [ebp-18]
  Form1.Label18.Visible := True;                      //00597B57..7B66 [400]
  Form1.Label18.Caption := '0 %';                     //00597B6B..7B7D
  Form1.Label18.Refresh;                              //00597B82..7B8F
  Form1.Label19.Visible := True;                      //00597B94..7BA3 [404]
  Form1.Label19.Caption := 'Gedcom einlesen  ';       //00597BA8..7BB5 (2 Leerzeichen)
  Form1.Label19.Refresh;                              //00597BBF..7BCC
  //00597BD1 jmp->7C22 (Eintrittssprung zur Schleifenbedingung)
  while Pos('@ INDI', zeile) = 0 do                   //00597C22..7C31 je->7BD3
  begin
    ReadLn(f, zeile);                                 //00597BD3..7BEC
    zsa(zeile, zst);                                  //00597BF1..7BFD
    zeile := zst;                                     //00597C02..7C0B
    if utfflag = 1 then                               //00597C10..7C15 jne->7C22
      zeile := Utf8ToAnsi(zeile);                     //00597C17..7C1D
  end;
  if Pos('@ INDI', zeile) > 0 then                   //00597C33..7C42 jle->7D40
  begin
    adrz := 1;                                       //00597C48 [ebp-12]
    inc(verarbz);                                    //00597C4E [ebp-30]
    ctx := '';                                       //00597C51..7C54 [ebp-38]
    //00597C59..7C85 StrToInt(Copy(zeile, 5, Pos('@ INDI', zeile) - 5)) - Ergebnis verworfen (toter Aufruf)
    inc(indnr);                                      //00597C8A [ebp-18]
    Form1.Label18.Caption :=                         //00597C8D..7CD0 [400]
      IntToStr(Round(verarbz / datenz * 100)) + ' %';
    Form1.Label18.Refresh;                           //00597CD5..7CE2 [400]
    aktnr := indnr;                                  //00597CE7..7CEA [ebp-1C]
    DataModule2.Table1.Append;                       //00597CED..7CF7 [5C]
    DataModule2.Table1Nummer.AsInteger := indnr;     //00597CFC..7D0E [534]
    DataModule2.Table1Lebt.AsString := 'n';          //00597D14..7D28 [5B4]
    DataModule2.Table1.Post;                         //00597D2E..7D3A [5C]
  end;
  if (Copy(zeile, 1, 1) = '0') and                  //00597D40..7D69 jne->7D81
     (Pos('0 @I', zeile) = 0) then                   //00597D6B..7D7A jne->7D81
    aktnr := 0;                                      //00597D7C..7D7E [ebp-1C]
  if (Pos('1 NAME', zeile) > 0) and                  //00597D81..7D90 jle->7FCE
     (aktnr = indnr) then                            //00597D96..7D9C jne->7FCE
  if Pos('VARIATION', zeile) = 0 then                //00597DA2..7DB1 jne->7EA0
  begin
    DataModule2.Table1.Edit;                         //00597DB7..7DC1
    DataModule2.Table1Vornamen.AsString :=           //00597DC6..7E01 [544]
      Copy(zeile, 8, Pos('/', zeile) - 8);
    zeile := Trim(Copy(zeile, Pos('/', zeile) + 1, 100)); //00597E07..7E45
    DataModule2.Table1Name.AsString :=               //00597E4A..7E83 [540]
      Copy(zeile, 1, Pos('/', zeile) - 1);
    DataModule2.Table1.Post;                         //00597E89..7E95 [5C]
    //00597E9B jmp->7FCE
  end
  else
  begin
    DataModule2.Table1.Edit;                         //00597EA0..7EAA
    DataModule2.Table1Namex.AsString :=              //00597EAF..7EEA [5BC]
      Copy(zeile, 12, Pos('/', zeile) - 12);
    zeile := Trim(Copy(zeile, Pos('/', zeile) + 1, 100)); //00597EF0..7F2E
    DataModule2.Table1Namex.AsString :=              //00597F33..7FB6 [5BC]
      Trim(DataModule2.Table1Namex.AsString + ' ' +
        Copy(zeile, 1, Pos('/', zeile) - 1));
    DataModule2.Table1.Post;                         //00597FBC..7FC8 [5C]
  end;
  if Pos('2 _RUFN', zeile) > 0 then                  //00597FCE..7FDD jle->8039
  begin
    DataModule2.Table1.Edit;                         //00597FDF..7FE9
    DataModule2.Table1Rufname.AsString :=            //00597FEE..8021 [600]
      Copy(zeile, 12, Length(zeile));
    DataModule2.Table1.Post;                         //00598027..8033 [5C]
  end;
  if Pos('2 GIVN', zeile) > 0 then                  //00598039..8048 jle->80C9
  begin
    DataModule2.Table1.Edit;                        //0059804A..8054
    ans(Trim(Copy(zeile, 8,                         //00598059..8097 [3A8<-3AC]
          Length(zeile))), anst);
    DataModule2.Table1Vornamen.AsString := anst;    //0059809C..80B1 [544]
    DataModule2.Table1.Post;                        //005980B7..80C3
  end;
  if Pos('2 SURN', zeile) > 0 then                  //005980C9..80D8 jle->8159
  begin
    DataModule2.Table1.Edit;                        //005980DA..80E4
    ans(Trim(Copy(zeile, 8,                         //005980E9..8127 [3B4<-3B8]
          Length(zeile))), anst);
    DataModule2.Table1Name.AsString := anst;        //0059812C..8141 [540]
    DataModule2.Table1.Post;                        //00598147..8153
  end;
  if Pos('1 SEX', zeile) > 0 then                   //00598159..8168 jle->82A7
  if Copy(zeile, 7, 1) = 'F' then                   //0059816E..8197 jne->81D9
  begin
    DataModule2.Table1.Edit;                        //00598199..81A3
    DataModule2.Table1Geschlecht.AsString := 'w';   //005981A8..81BC [548]
    DataModule2.Table1.Post;                        //005981C2..81CE
    //005981D4 jmp->82A7
  end
  else if Copy(zeile, 7, 1) = 'M' then              //005981D9..8202 jne->8241
  begin
    DataModule2.Table1.Edit;                        //00598204..820E
    DataModule2.Table1Geschlecht.AsString := 'm';   //00598213..8227 [548]
    DataModule2.Table1.Post;                        //0059822D..8239
    //0059823F jmp->82A7
  end
  else if Copy(zeile, 7, 1) = 'U' then              //00598241..826A jne->82A7
  begin
    DataModule2.Table1.Edit;                        //0059826C..8276
    DataModule2.Table1Geschlecht.AsString := 'x';   //0059827B..828F [548]
    DataModule2.Table1.Post;                        //00598295..82A1
  end;
  if (Pos('1 OCCU', zeile) > 0) and                 //005982A7..82B6 jle->832B
     (aktnr = indnr) then                           //005982B8..82BE jne->832B
  begin
    DataModule2.Table1.Edit;                        //005982C0..82CA
    DataModule2.Table1Beruf.AsString :=             //005982CF..8313 [550]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                        //00598319..8325
  end;
  if (Pos('1 NOTE Hnm.', zeile) > 0) and           //0059832B..833A jle->83AF
     (aktnr = indnr) then                          //0059833C..8342 jne->83AF
  begin
    DataModule2.Table1.Edit;                       //00598344..834E
    DataModule2.Table1Hausname.AsString :=         //00598353..8397 [5C8]
      Trim(Copy(zeile, 14, Length(zeile)));
    DataModule2.Table1.Post;                       //0059839D..83A9
  end;
  if Pos('1 NOTE lebt', zeile) > 0 then            //005983AF..83BE jle->840F
  begin
    DataModule2.Table1.Edit;                       //005983C0..83CA
    DataModule2.Table1Lebt.AsString :=             //005983CF..83F7 [5B4]
      RightStr(zeile, 1);
    DataModule2.Table1.Post;                       //005983FD..8409
  end;
  if Pos('1 IDNO', zeile) > 0 then                 //0059840F..841E jle->8486
  begin
    DataModule2.Table1.Edit;                       //00598420..842A
    DataModule2.Table1IDNR.AsString :=             //0059842F..846E [5C0]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //00598474..8480
  end;
  if Pos('1 ADOP', zeile) > 0 then                 //00598486..8495 jle->84A4
    ctx := 'adop';                                 //00598497..849F [ebp-38]
  if (Pos('2 FAMC', zeile) > 0) and                //005984A4..84B3 jle->8532
     (ctx = 'adop') then                           //005984B5..84C2 jne->8532
    famcs := famcs +                               //005984C4..852D [0A4]
      RightStr('000000' + Copy(zeile, 10, Length(zeile) - 10), 6) + '*';
  if (Pos('2 ADDR', zeile) > 0) or                 //00598532..8541 jg->8554
     (Pos('1 ADR1', zeile) > 0) then               //00598543..8552 jle->85C7
  begin
    ctx := 'AD';                                   //00598554..855C [ebp-38]
    DataModule2.Table1.Edit;                       //00598561..856B
    DataModule2.Table1Adr1.AsString :=             //00598570..85AF [5CC]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //005985B5..85C1
  end;
  if (Pos('3 CONT', zeile) > 0) and                //005985C7..85D6 jle->865C
     (adrz = 2) and                                //005985DC..85E1 jne->865C
     (ctx = 'AD') then                             //005985E3..85F0 jne->865C
  begin
    DataModule2.Table1.Edit;                       //005985F2..85FC
    DataModule2.Table1Ort.AsString :=              //00598601..863E [5D8]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //00598646..8652
    Inc(adrz);                                     //00598658 [ebp-12]
  end;
  if (Pos('3 CONT', zeile) > 0) and                //0059865C..866B jle->86F1
     (adrz = 1) and                                //00598671..8676 jne->86F1
     (ctx = 'AD') then                             //00598678..8685 jne->86F1
  begin
    DataModule2.Table1.Edit;                       //00598687..8691
    DataModule2.Table1PLZ.AsString :=              //00598696..86D3 [5D4]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //005986DB..86E7
    Inc(adrz);                                     //005986ED [ebp-12]
  end;
  if Pos('1 ADR3', zeile) > 0 then                 //005986F1..8700 jle->8768
  begin
    DataModule2.Table1.Edit;                       //00598702..870C
    DataModule2.Table1PLZ.AsString :=              //00598711..874E [5D4]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //00598756..8762
  end;
  if Pos('1 ADR4', zeile) > 0 then                 //00598768..8777 jle->87DF
  begin
    DataModule2.Table1.Edit;                       //00598779..8783
    DataModule2.Table1Ort.AsString :=              //00598788..87C5 [5D8]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //005987CD..87D9
  end;
  if Pos('1 ADR5', zeile) > 0 then                 //005987DF..87EE jle->8856
  begin
    DataModule2.Table1.Edit;                       //005987F0..87FA
    DataModule2.Table1Adrzus.AsString :=           //005987FF..883E [5DC]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //00598844..8850
  end;
  if Pos('2 EMAIL', zeile) > 0 then                //00598856..8865 jle->88CD
  begin
    DataModule2.Table1.Edit;                       //00598867..8871
    DataModule2.Table1Ema.AsString :=              //00598876..88B3 [5F4]
      Trim(Copy(zeile, 9, 20));
    DataModule2.Table1.Post;                       //005988BB..88C7
  end;
  if Pos('1 EMA', zeile) > 0 then                  //005988CD..88DC jle->8944
  begin
    DataModule2.Table1.Edit;                       //005988DE..88E8
    DataModule2.Table1Ema.AsString :=              //005988ED..892A [5F4]
      Trim(Copy(zeile, 7, 20));
    DataModule2.Table1.Post;                       //00598932..893E
  end;
  if (Pos('2 PHON', zeile) > 0) or                 //00598944..8953 jg->8966
     (Pos('1 PHON', zeile) > 0) then               //00598955..8964 jle->89CC
  begin
    DataModule2.Table1.Edit;                       //00598966..8970
    DataModule2.Table1Tel.AsString :=              //00598975..89B4 [5F0]
      Trim(Copy(zeile, 8, 20));
    DataModule2.Table1.Post;                       //005989BA..89C6
  end;
  if Pos('1 URL', zeile) > 0 then                  //005989CC..89DB jle->8A48
  begin
    DataModule2.Table1.Edit;                       //005989DD..89E7
    DataModule2.Table1Ur.AsString :=               //005989EC..8A30 [5F8]
      Trim(Copy(zeile, 7, Length(zeile)));
    DataModule2.Table1.Post;                       //00598A36..8A42
  end;
  if Pos('1 RELI', zeile) > 0 then                 //00598A48..8A57 jle->8A66
    ctx := 'Rel';                                  //00598A59..8A61 [ebp-38]
  if (Pos('1 RELI', zeile) > 0) and                //00598A66..8A75 jle->8B1F
     (ctx = 'Rel') and                             //00598A7B..8A88 jne->8B1F
     (Length(Trim(zeile)) > 6) and                 //00598A8E..8AAA jle->8B1F
     (aktnr = indnr) then                          //00598AAC..8AB2 jne->8B1F
  begin
    DataModule2.Table1.Edit;                       //00598AB4..8ABE
    DataModule2.Table1Religion.AsString :=         //00598AC3..8B07 [54C]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //00598B0D..8B19
  end;
  if (Pos('2 NOTE', zeile) > 0) and                //00598B1F..8B2E jle->8BD4
     (ctx = 'Rel') then                            //00598B34..8B41 jne->8BD4
  begin
    DataModule2.Table1.Edit;                       //00598B47..8B51
    if LowerCase(Trim(Copy(zeile, 8,               //00598B56..8BA6 jne->8BC2
         Length(zeile)))) = 'roman catholic' then
      DataModule2.Table1Religion.AsString := 'rk'; //00598BA8..8BBC [54C]
    DataModule2.Table1.Post;                       //00598BC2..8BCE
  end;
  if Pos('CHAN', zeile) > 0 then                   //00598BD4..8BE3 jle->8BF2
    ctx := 'chan';                                 //00598BE5..8BED [ebp-38]
  schl := '';                                      //00598BF2..8BF5 [ebp-3C]
  if Pos('1 SOUR @', zeile) > 0 then                //00598BFA..8C09 jle->8D9B
  begin
    Form1.Repso2.IndexName := 'ih';                 //00598C0F..8C21
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 8, Length(zeile)))]) then //00598C26..8C87 je->8C9E
      schl := Form1.Repso2inh2.AsString;            //00598C89..8C9B [8D0]
    if Pos(schl, DataModule2.Table1Quelle.AsString) = 0 then //00598C9E..8CC6 jne->8D9B
    begin
      DataModule2.Table1.Edit;                      //00598CCC..8CD6
      if Trim(DataModule2.Table1Quelle.AsString) <> '' then //00598CDB..8D0B jbe->8D71
        DataModule2.Table1Quelle.AsString :=        //00598D0D..8D69 [5FC]
          Trim(DataModule2.Table1Quelle.AsString + '; ' + schl)
        //00598D6F jmp->8D89
      else
        DataModule2.Table1Quelle.AsString := schl;  //00598D71..8D83 [5FC]
      DataModule2.Table1.Post;                      //00598D89..8D95
    end;
  end;
  if Pos('1 RESI', zeile) > 0 then                  //00598D9B..8DAA jle->8DB9
    ctx := 'R';                                     //00598DAC..8DB4 [ebp-38]
  if (Pos('2 PLAC', zeile) > 0) and                 //00598DB9..8DC8 jle->8E44
     (ctx = 'R') then                               //00598DCA..8DD7 jne->8E44
  begin
    DataModule2.Table1.Edit;                        //00598DD9..8DE3
    DataModule2.Table1Lebensort.AsString :=         //00598DE8..8E2C [578]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                        //00598E32..8E3E
  end;
  if Pos('1 EDUC', zeile) > 0 then                  //00598E44..8E53 jle->8E62
    ctx := 'Ed';                                    //00598E55..8E5D [ebp-38]
  if (Pos('2 NOTE', zeile) > 0) and                 //00598E62..8E71 jle->8F2F
     (ctx = 'Ed') then                              //00598E77..8E84 jne->8F2F
  begin
    DataModule2.Table1.Edit;                        //00598E8A..8E94
    DataModule2.Table1Kommentar.AsString :=         //00598E99..8F17 [5B0]
      DataModule2.Table1Kommentar.AsString + 'Ausbildung: ' +
      Trim(Copy(zeile, 8, Length(zeile))) + #13#10;
    DataModule2.Table1.Post;                        //00598F1D..8F29
  end;
  if (Pos('1 NOTE', zeile) > 0) and                 //00598F2F..8F3E jle->8F5E
     (Pos('@NI', zeile) = 0) then                   //00598F40..8F4F jne->8F5E
    ctx := 'N';                                     //00598F51..8F59 [ebp-38]
  if (Pos('1 NOTE', zeile) > 0) and                  //00598F5E..8F6D jle->9374
     (Pos('lebt', zeile) = 0) and                    //00598F73..8F82 jne->9374
     (ctx = 'N') then                                //00598F88..8F95 jne->9374
  if Pos('1 NOTE @N', zeile) > 0 then                //00598F9B..8FAA jle->92BB
  begin
    Form1.Repso2.IndexName := 'ih';                  //00598FB0..8FC2
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 8, Length(zeile)))]) then //00598FC7..9023 je->9374
    if Trim(Form1.Repso2inh2.AsString) <> '' then    //00599029..9059 jbe->9374
    if Pos('lebt: j', Form1.Repso2inh2.AsString) > 0 then //0059905F..9089 jle->90CB
    begin
      DataModule2.Table1.Edit;                       //0059908B..9095
      DataModule2.Table1Lebt.AsString := 'j';        //0059909A..90AE [5B4]
      DataModule2.Table1.Post;                       //005990B4..90C0
      //005990C6 jmp->9374
    end
    else if Pos('Hnm.:', Form1.Repso2inh2.AsString) > 0 then //005990CB..90F5 jle->9181
    begin
      DataModule2.Table1.Edit;                       //005990FB..9105
      DataModule2.Table1Hausname.AsString :=         //0059910A..9164 [5C8]
        Trim(Copy(Form1.Repso2inh2.AsString, 7, 40));
      DataModule2.Table1.Post;                       //0059916A..9176
      //0059917C jmp->9374
    end
    else if Pos('Schrw.:', Form1.Repso2inh2.AsString) > 0 then //00599181..91AB jle->9237
    begin
      DataModule2.Table1.Edit;                       //005991B1..91BB
      DataModule2.Table1Namex.AsString :=            //005991C0..921A [5BC]
        Trim(Copy(Form1.Repso2inh2.AsString, 9, 40));
      DataModule2.Table1.Post;                       //00599220..922C
      //00599232 jmp->9374
    end
    else
    begin
      DataModule2.Table1.Edit;                       //00599237..9241
      DataModule2.Table1Kommentar.AsString :=        //00599246..929E [5B0]
        DataModule2.Table1Kommentar.AsString +
        Form1.Repso2inh2.AsString;
      DataModule2.Table1.Post;                       //005992A4..92B0
      //005992B6 jmp->9374
    end
  end
  else if Pos('1 NOTE Hnm.', zeile) = 0 then         //005992BB..92CA jne->9374
  begin
    DataModule2.Table1.Edit;                         //005992D0..92DA
    DataModule2.Table1Kommentar.AsString :=          //005992DF..935C [5B0]
      DataModule2.Table1Kommentar.AsString +
      Trim(Copy(zeile, 8, Length(zeile))) + #13#10;
    DataModule2.Table1.Post;                         //00599362..936E
  end;
  if Pos('2 CON', zeile) > 0 then                  //00599374..9383 jle->94AD
  begin
    DataModule2.Table1.Edit;                       //00599389..9393
    if Pos('2 CONC', zeile) > 0 then               //00599398..93A7 jle->941C
      DataModule2.Table1Kommentar.AsString :=      //005993A9..9414 [5B0]
        DataModule2.Table1Kommentar.AsString + Trim(Copy(zeile, 8, Length(zeile)))
        //0059941A jmp->949B
    else
      DataModule2.Table1Kommentar.AsString :=      //0059941C..9495 [5B0]
        DataModule2.Table1Kommentar.AsString + #13#10 +
        Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //0059949B..94A7
  end;
  if Pos('0 @NI', zeile) > 0 then                  //005994AD..94BC jle->95F9
  begin
    Form1.Repso2.IndexName := 'ih';                //005994C2..94D4
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 3, Pos('O', zeile) - 5))]) then //005994D9..9542 je->95F9
    if Trim(Form1.Repso2inh2.AsString) <> '' then  //00599548..9578 jbe->95F9
    begin
      DataModule2.Table1.Edit;                     //0059957A..9584
      DataModule2.Table1Kommentar.AsString :=      //00599589..95E1 [5B0]
        DataModule2.Table1Kommentar.AsString +
        Form1.Repso2inh2.AsString;
      DataModule2.Table1.Post;                     //005995E7..95F3
    end;
  end;
  if (Pos('0 @N', zeile) > 0) and                  //005995F9..9608 jle->9755
     (Pos('0 @NI', zeile) = 0) then                //0059960E..961D jne->9755
  begin
    Form1.Repso2.IndexName := 'ih';                //00599623..9635
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 3, Length(zeile) - 7))]) then //0059963A..969E je->9755
    if Trim(Form1.Repso2inh2.AsString) <> '' then  //005996A4..96D4 jbe->9755
    begin
      DataModule2.Table1.Edit;                     //005996D6..96E0
      DataModule2.Table1Kommentar.AsString :=      //005996E5..973D [5B0]
        DataModule2.Table1Kommentar.AsString +
        Form1.Repso2inh2.AsString;
      DataModule2.Table1.Post;                     //00599743..974F
    end;
  end;
  if Pos('1 BIRT', zeile) > 0 then                 //00599755..9764 jle->9773
    ctx := 'B';                                    //00599766..976E [ebp-38]
  if (Pos('2 DATE', zeile) > 0) and                //00599773..9782 jle->9847
     (ctx = 'B') then                              //00599788..9795 jne->9847
  begin
    sub_00577934(TrimRight(Copy(zeile, 8,          //0059979B..97D0
      Length(zeile))));
    DataModule2.Table1.Edit;                       //005997D5..97DF
    DataModule2.Table1Gebtag.AsString := gvar_02536624;   //005997E4..97F9 [554]
    DataModule2.Table1Gebmonat.AsString := gvar_02536628; //005997FF..9814 [558]
    DataModule2.Table1Gebjahr.AsString := gvar_0253662C;  //0059981A..982F [55C]
    DataModule2.Table1.Post;                       //00599835..9841
  end;
  if (Pos('2 PLAC', zeile) > 0) and                //00599847..9856 jle->98D2
     (ctx = 'B') then                              //00599858..9865 jne->98D2
  begin
    DataModule2.Table1.Edit;                       //00599867..9871
    DataModule2.Table1Gebort.AsString :=           //00599876..98BA [560]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //005998C0..98CC
  end;
  schl := '';                                      //005998D2..98D5 [ebp-3C]
  if (Pos('2 SOUR @', zeile) > 0) and              //005998DA..98E9 jle->99D0
     (ctx = 'B') then                              //005998EF..98FC jne->99D0
  begin
    Form1.Repso2.IndexName := 'ih';                //00599902..9914
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 8, Length(zeile)))]) then //00599919..997A je->99D0
    begin
      DataModule2.Table1.Edit;                     //0059997C..9986
      DataModule2.Table1Quelleg.AsString :=        //0059998B..99B8 [5A0]
        Form1.Repso2inh2.AsString;
      DataModule2.Table1.Post;                     //005999BE..99CA
    end;
  end;
  if (Pos('2 SOUR', zeile) > 0) and                //005999D0..99DF jle->9A70
     (Pos('@', zeile) = 0) and                     //005999E5..99F4 jne->9A70
     (ctx = 'B') then                              //005999F6..9A03 jne->9A70
  begin
    DataModule2.Table1.Edit;                       //00599A05..9A0F
    DataModule2.Table1Quelleg.AsString :=          //00599A14..9A58 [5A0]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //00599A5E..9A6A
  end;
  if (Pos('2 COMM', zeile) > 0) and                //00599A70..9A7F jle->9B38
     (ctx = 'B') then                              //00599A85..9A92 jne->9B38
  begin
    DataModule2.Table1.Edit;                       //00599A98..9AA2
    DataModule2.Table1Kommentar.AsString :=        //00599AA7..9B20 [5B0]
      DataModule2.Table1Kommentar.AsString +
      Trim(Copy(zeile, 8, Length(zeile))) + #13#10;
    DataModule2.Table1.Post;                       //00599B26..9B32
  end;
  if (Pos('1 CHR', zeile) > 0) or                  //00599B38..9B47 jg->9B5A
     (Pos('1 BAPT', zeile) > 0) then               //00599B49..9B58 jle->9B67
    ctx := 'C';                                    //00599B5A..9B62 [ebp-38]
  if (Pos('2 DATE', zeile) > 0) and                //00599B67..9B76 jle->9C3B
     (ctx = 'C') then                              //00599B7C..9B89 jne->9C3B
  begin
    sub_00577934(TrimRight(Copy(zeile, 8,          //00599B8F..9BC4
      Length(zeile))));
    DataModule2.Table1.Edit;                       //00599BC9..9BD3
    DataModule2.Table1Tauftag.AsString := gvar_02536624;   //00599BD8..9BED [564]
    DataModule2.Table1Taufmonat.AsString := gvar_02536628; //00599BF3..9C08 [568]
    DataModule2.Table1Taufjahr.AsString := gvar_0253662C;  //00599C0E..9C23 [56C]
    DataModule2.Table1.Post;                       //00599C29..9C35
  end;
  if (Pos('2 PLAC', zeile) > 0) and                //00599C3B..9C4A jle->9CC6
     (ctx = 'C') then                              //00599C4C..9C59 jne->9CC6
  begin
    DataModule2.Table1.Edit;                       //00599C5B..9C65
    DataModule2.Table1Taufort.AsString :=          //00599C6A..9CAE [570]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //00599CB4..9CC0
  end;
  if Pos('2 _GODP ', zeile) > 0 then               //00599CC6..9CD5 jle->9DFD
  begin
    DataModule2.Table1.Edit;                       //00599CDB..9CE5
    if Trim(DataModule2.Table1Taufpat.AsString) <> '' then //00599CEA..9D1A jbe->9DA1
    begin
      DataModule2.Table1Taufpat.AsString :=        //00599D20..9D99 [574]
        DataModule2.Table1Taufpat.AsString + ', ' +
        Copy(zeile, 9, Length(Trim(zeile)));
      //00599D9F jmp->9DEB
    end
    else
    begin
      DataModule2.Table1Taufpat.AsString :=        //00599DA1..9DE5 [574]
        Trim(Copy(zeile, 9, Length(Trim(zeile))));
    end;
    DataModule2.Table1.Post;                       //00599DEB..9DF7
  end;
  if Pos('1 GODP ', zeile) > 0 then                //00599DFD..9E0C jle->9F34
  begin
    DataModule2.Table1.Edit;                       //00599E12..9E1C
    if Trim(DataModule2.Table1Taufpat.AsString) <> '' then //00599E21..9E51 jbe->9ED8
    begin
      DataModule2.Table1Taufpat.AsString :=        //00599E57..9ED0 [574]
        DataModule2.Table1Taufpat.AsString + ', ' +
        Copy(zeile, 8, Length(Trim(zeile)));
      //00599ED6 jmp->9F22
    end
    else
    begin
      DataModule2.Table1Taufpat.AsString :=        //00599ED8..9F1C [574]
        Trim(Copy(zeile, 8, Length(Trim(zeile))));
    end;
    DataModule2.Table1.Post;                       //00599F22..9F2E
  end;
  if Pos('2 GODP ', zeile) > 0 then                //00599F34..9F43 jle->A06B
  begin
    DataModule2.Table1.Edit;                       //00599F49..9F53
    if Trim(DataModule2.Table1Taufpat.AsString) <> '' then //00599F58..9F88 jbe->A00F
    begin
      DataModule2.Table1Taufpat.AsString :=        //00599F8E..A007 [574]
        DataModule2.Table1Taufpat.AsString + ', ' +
        Copy(zeile, 8, Length(Trim(zeile)));
      //0059A00D jmp->A059
    end
    else
    begin
      DataModule2.Table1Taufpat.AsString :=        //0059A00F..A053 [574]
        Trim(Copy(zeile, 8, Length(Trim(zeile))));
    end;
    DataModule2.Table1.Post;                       //0059A059..A065
  end;
  schl := '';                                      //0059A06B..A06E [ebp-3C]
  if (Pos('2 SOUR @', zeile) > 0) and              //0059A073..A082 jle->A169
     (ctx = 'C') then                              //0059A088..A095 jne->A169
  begin
    Form1.Repso2.IndexName := 'ih';                //0059A09B..A0AD
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 8, Length(zeile)))]) then //0059A0B2..A113 je->A169
    begin
      DataModule2.Table1.Edit;                     //0059A115..A11F
      DataModule2.Table1Quellet.AsString :=        //0059A124..A151 [5A4]
        Form1.Repso2inh2.AsString;
      DataModule2.Table1.Post;                     //0059A157..A163
    end;
  end;
  if (Pos('2 SOUR', zeile) > 0) and                //0059A169..A178 jle->A209
     (Pos('@', zeile) = 0) and                     //0059A17E..A18D jne->A209
     (ctx = 'C') then                              //0059A18F..A19C jne->A209
  begin
    DataModule2.Table1.Edit;                       //0059A19E..A1A8
    DataModule2.Table1Quellet.AsString :=          //0059A1AD..A1F1 [5A4]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //0059A1F7..A203
  end;
  if (Pos('2 COMM', zeile) > 0) and                //0059A209..A218 jle->A2D1
     (ctx = 'C') then                              //0059A21E..A22B jne->A2D1
  begin
    DataModule2.Table1.Edit;                       //0059A231..A23B
    DataModule2.Table1Kommentar.AsString :=        //0059A240..A2B9 [5B0]
      DataModule2.Table1Kommentar.AsString +
      Trim(Copy(zeile, 8, Length(zeile))) + #13#10;
    DataModule2.Table1.Post;                       //0059A2BF..A2CB
  end;
  if Pos('1 DEAT', zeile) > 0 then                 //0059A2D1..A2E0 jle->A2EF
    ctx := 'S';                                    //0059A2E2..A2EA [ebp-38]
  if (Pos('2 DATE', zeile) > 0) and                //0059A2EF..A2FE jle->A3C3
     (ctx = 'S') then                              //0059A304..A311 jne->A3C3
  begin
    sub_00577934(TrimRight(Copy(zeile, 8,          //0059A317..A34C
      Length(zeile))));
    DataModule2.Table1.Edit;                       //0059A351..A35B
    DataModule2.Table1Sttag.AsString := gvar_02536624;     //0059A360..A375 [57C]
    DataModule2.Table1Stmonat.AsString := gvar_02536628;   //0059A37B..A390 [580]
    DataModule2.Table1Stjahr.AsString := gvar_0253662C;    //0059A396..A3AB [584]
    DataModule2.Table1.Post;                       //0059A3B1..A3BD
  end;
  if (Pos('2 PLAC', zeile) > 0) and                //0059A3C3..A3D2 jle->A44E
     (ctx = 'S') then                              //0059A3D4..A3E1 jne->A44E
  begin
    DataModule2.Table1.Edit;                       //0059A3E3..A3ED
    DataModule2.Table1Stort.AsString :=            //0059A3F2..A436 [588]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //0059A43C..A448
  end;
  if (Pos('2 CAUS', zeile) > 0) and                //0059A44E..A45D jle->A4D9
     (ctx = 'S') then                              //0059A45F..A46C jne->A4D9
  begin
    DataModule2.Table1.Edit;                       //0059A46E..A478
    DataModule2.Table1Todesurs.AsString :=         //0059A47D..A4C1 [58C]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //0059A4C7..A4D3
  end;
  schl := '';                                      //0059A4D9..A4DC [ebp-3C]
  if (Pos('2 SOUR @', zeile) > 0) and              //0059A4E1..A4F0 jle->A5D7
     (ctx = 'S') then                              //0059A4F6..A503 jne->A5D7
  begin
    Form1.Repso2.IndexName := 'ih';                //0059A509..A51B
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 8, Length(zeile)))]) then //0059A520..A581 je->A5D7
    begin
      DataModule2.Table1.Edit;                     //0059A583..A58D
      DataModule2.Table1Quelles.AsString :=        //0059A592..A5BF [5A8]
        Form1.Repso2inh2.AsString;
      DataModule2.Table1.Post;                     //0059A5C5..A5D1
    end;
  end;
  if (Pos('2 SOUR', zeile) > 0) and                //0059A5D7..A5E6 jle->A677
     (Pos('@', zeile) = 0) and                     //0059A5EC..A5FB jne->A677
     (ctx = 'S') then                              //0059A5FD..A60A jne->A677
  begin
    DataModule2.Table1.Edit;                       //0059A60C..A616
    DataModule2.Table1Quelles.AsString :=          //0059A61B..A65F [5A8]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //0059A665..A671
  end;
  if (Pos('2 COMM', zeile) > 0) and                //0059A677..A686 jle->A73F
     (ctx = 'S') then                              //0059A68C..A699 jne->A73F
  begin
    DataModule2.Table1.Edit;                       //0059A69F..A6A9
    DataModule2.Table1Kommentar.AsString :=        //0059A6AE..A727 [5B0]
      DataModule2.Table1Kommentar.AsString +
      Trim(Copy(zeile, 8, Length(zeile))) + #13#10;
    DataModule2.Table1.Post;                       //0059A72D..A739
  end;
  if Pos('1 BURI', zeile) > 0 then                 //0059A73F..A74E jle->A75D
    ctx := 'U';                                    //0059A750..A758 [ebp-38]
  if (Pos('2 DATE', zeile) > 0) and                //0059A75D..A76C jle->A831
     (ctx = 'U') then                              //0059A772..A77F jne->A831
  begin
    sub_00577934(TrimRight(Copy(zeile, 8,          //0059A785..A7BA
      Length(zeile))));
    DataModule2.Table1.Edit;                       //0059A7BF..A7C9
    DataModule2.Table1Begtag.AsString := gvar_02536624;    //0059A7CE..A7E3 [590]
    DataModule2.Table1Begmonat.AsString := gvar_02536628;  //0059A7E9..A7FE [594]
    DataModule2.Table1Begjahr.AsString := gvar_0253662C;   //0059A804..A819 [598]
    DataModule2.Table1.Post;                       //0059A81F..A82B
  end;
  if (Pos('2 PLAC', zeile) > 0) and                //0059A831..A840 jle->A8BC
     (ctx = 'U') then                              //0059A842..A84F jne->A8BC
  begin
    DataModule2.Table1.Edit;                       //0059A851..A85B
    DataModule2.Table1Begort.AsString :=           //0059A860..A8A4 [59C]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //0059A8AA..A8B6
  end;
  schl := '';                                      //0059A8BC..A8BF [ebp-3C]
  if (Pos('2 SOUR @', zeile) > 0) and              //0059A8C4..A8D3 jle->A9BA
     (ctx = 'U') then                              //0059A8D9..A8E6 jne->A9BA
  begin
    Form1.Repso2.IndexName := 'ih';                //0059A8EC..A8FE
    if Form1.Repso2.FindKey([Trim(Copy(zeile, 8, Length(zeile)))]) then //0059A903..A964 je->A9BA
    begin
      DataModule2.Table1.Edit;                     //0059A966..A970
      DataModule2.Table1Quelleb.AsString :=        //0059A975..A9A2 [5AC]
        Form1.Repso2inh2.AsString;
      DataModule2.Table1.Post;                     //0059A9A8..A9B4
    end;
  end;
  if (Pos('2 SOUR', zeile) > 0) and                //0059A9BA..A9C9 jle->AA5A
     (Pos('@', zeile) = 0) and                     //0059A9CF..A9DE jne->AA5A
     (ctx = 'U') then                              //0059A9E0..A9ED jne->AA5A
  begin
    DataModule2.Table1.Edit;                       //0059A9EF..A9F9
    DataModule2.Table1Quelleb.AsString :=          //0059A9FE..AA42 [5AC]
      Trim(Copy(zeile, 8, Length(zeile)));
    DataModule2.Table1.Post;                       //0059AA48..AA54
  end;
  if (Pos('2 COMM', zeile) > 0) and                //0059AA5A..AA69 jle->AB22
     (ctx = 'U') then                              //0059AA6F..AA7C jne->AB22
  begin
    DataModule2.Table1.Edit;                       //0059AA82..AA8C
    DataModule2.Table1Kommentar.AsString :=        //0059AA91..AB0A [5B0]
      DataModule2.Table1Kommentar.AsString +
      Trim(Copy(zeile, 8, Length(zeile))) + #13#10;
    DataModule2.Table1.Post;                       //0059AB10..AB1C
  end;
  {G2C17}
end;


end.



