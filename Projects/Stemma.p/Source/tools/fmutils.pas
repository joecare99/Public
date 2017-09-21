unit FMUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Grids, StrUtils;

procedure SaveFormPosition(Sender: TForm);
  deprecated {$ifndef NoFormat}'use dmGenData.WriteCfgFormPosition'{$endif};
procedure SaveGridPosition(Sender: TStringGrid; cols: integer);
  deprecated {$ifndef NoFormat}'use dmGenData.WriteCfgGridPosition'{$endif};
procedure GetGridPosition(Sender: TStringGrid; cols: integer);
  deprecated {$ifndef NoFormat}'use dmGenData.ReadCfgGridPosition'{$endif};
procedure GetFormPosition(Sender: TForm; a: integer; b: integer; c: integer; d: integer);
  deprecated {$ifndef NoFormat}'use dmGenData.ReadCfgFormPosition'{$endif};
procedure SaveModificationTime(no: integer); overload;
  deprecated {$ifndef NoFormat}'use dmGenData.SaveModificationTime'{$endif};
procedure SaveModificationTime(no: string); overload;
  deprecated {$ifndef NoFormat}'use dmGenData.SaveModificationTime'{$endif};
procedure PopulateCitations(Tableau: TStringGrid; Code: string; no: integer);
  overload; deprecated{$ifndef NoFormat}'use dmGenData.PopulateCitations'{$endif};
procedure PopulateCitations(Tableau: TStringGrid; Code: string; Nstr: string);
  overload; deprecated{$ifndef NoFormat}'use dmGenData.PopulateCitations'{$endif};
function DecodeName(Name: string; format: byte): string;
procedure DecodePlace(Place: string;
  out article, detail, sCity, region, Country, State: string);
function DecodeChanged(Place: string): string;
function ConvertDate(Date: string; format: byte): string;
function RemoveUTF8(Text: string): string;
function DecodePhrase(sIndividuum: string; role: string; phrase: string;
  TypeEvenement: string; evenement: string): string; overload; deprecated;
function DecodePhrase(idIndividuum: integer; role: string; phrase: string;
  TypeEvenement: string; evenement: integer): string; overload;
function DecodePhraseTMG(idSujet: integer; role: string; phrase: string;
  TypeEvenement: string; evenement: string): string;
function DecodePhraseStemma(idIndividual: integer; role: string; phrase: string;
  TypeEvenement: string; evenement, char: integer): string; overload;
function DecodePhraseStemma(sIndividual: string; role: string; phrase: string;
  TypeEvenement: string; evenement: string; char: integer): string; overload; deprecated;
function CalculateAge(Date1: string; Date2: string; format: byte): string;
function InterpreteDate(Date: string; format: byte): string;
function getI3(no: integer): string;
  overload; deprecated {$ifndef NoFormat}'use dmGenData.getI3'{$endif};
function getI4(no: integer): string; overload;
  deprecated {$ifndef NoFormat}'use dmGenData.getI4'{$endif};
function getName(no: integer): string; overload;
  deprecated {$ifndef NoFormat}'use dmGenData.GetIndividuumName'{$endif};
function getI3(nstr: string): string;
  overload; deprecated {$ifndef NoFormat}'use dmGenData.getI3'{$endif};
function getI4(nstr: string): string;
  overload; deprecated {$ifndef NoFormat}'use dmGenData.getI4'{$endif};
function getName(nstr: string): string;
  overload; deprecated {$ifndef NoFormat}'use dmGenData.GetIndividuumName'{$endif};
function AutoQuote(orgStr: string): string;
function GetTableColWidthSum(const lTable: TStringGrid;
  const lIgnCol: integer): integer;

implementation

uses
  cls_Translation, dm_GenData;

procedure SaveModificationTime(no: string);
var
  nn: integer;
begin
  if TryStrToInt(no, nn) then
    dmGenData.SaveModificationTime(nn);
end;

procedure PopulateCitations(Tableau: TStringGrid; Code: string; no: integer);

begin
  // Populate le tableau de citations
  dmGenData.PopulateCitations(Tableau, code, No);
end;

function InterpreteDate(Date: string; format: byte): string;
var
  annee1, mois1, jour1, annee2, mois2, jour2, style, Original, bc1, bc2, temp: string;
  i, len: integer;
  valid: boolean;
  tmpSep1, tmpSep2: integer;
  test: TDateTime;
begin
  // Doit accepter les années négatives
  Original := Date;
  // Doit accepter année, mois et jour '...'
  while AnsiPos('...', Date) > 0 do
    Date := Copy(Date, 1, AnsiPos('...', Date) - 1) + '00' + Copy(
      Date, AnsiPos('...', Date) + 3, length(Date));
  if length(Date) = 0 then
    if format = 1 then
      InterpreteDate := '100000000030000000000'
    else
      InterpreteDate := ''
  else
   begin
    style := '3';
    if (Copy(Date, 1, 3) = 'av.') then
     begin
      Date := Copy(Date, 4, length(Date));
      style := '0';
     end;
    if (Copy(Date, 1, 3) = 'ap.') then
     begin
      Date := Copy(Date, 4, length(Date));
      style := '4';
     end;
    if (Copy(Date, 1, 1) = '<') then
     begin
      Date := Copy(Date, 2, length(Date));
      style := '0';
     end;
    if (Copy(Date, 1, 1) = 'c') or (Copy(Date, 1, 1) = 'v') then
     begin
      Date := Copy(Date, 2, length(Date));
      style := '1';
     end;
    if (Copy(Date, 1, 1) = '>') then
     begin
      Date := Copy(Date, 2, length(Date));
      style := '4';
     end;
    while (Date[1] = '.') or (Date[1] = ' ') do
      Date := Copy(Date, 2, length(Date));
    // extract year, month, day
    bc1 := '';
    if (Date[1] = '-') then
     begin
      bc1 := '-';
      Date := Copy(Date, 2, length(Date));
     end;
    Annee1 := '0000';
    Mois1 := '00';
    Jour1 := '00';
    Valid := True;
    len := AnsiPos(' ou', Date) - 1;
    if len <= 0 then
      len := AnsiPos('ou', Date) - 1;
    if len <= 0 then
      len := AnsiPos(' -', Date) - 1;
    if len <= 0 then
      len := AnsiPos('-', Date) - 1;
    if len <= 0 then
      len := AnsiPos(' a', Date) - 1;
    if len <= 0 then
      len := AnsiPos(' à', Date) - 1;
    if len <= 0 then
      len := AnsiPos('a', Date) - 1;
    if len <= 0 then
      len := AnsiPos('à', Date) - 1;
    if len <= 0 then
      len := length(Date);
    tmpSep1 := 0;
    tmpSep2 := 0;
    //validate the position of the date separators, if any, and
    //make sure only date separators and numerics are entered ...
    if len > 10 then
      len := 10;
    for i := 1 to len do
      if (i <= len) and (not (Date[i] in ['0'..'9'])) then
       begin
        if i < 3 then
          valid := False
        else if tmpSep1 = 0 then
          tmpSep1 := i
        else if (i = tmpSep1 + 1) or (tmpSep2 > 0) then
          if (i = tmpSep2 + 1) then
            valid := False
          else
            len := i - 1
        else
          tmpSep2 := i;
       end;

    //check for other error conditions ...
    if ((tmpSep1 = 0) and not (len in [4, 6, 8])) or
      ((tmpSep1 > 0) and (tmpSep2 - tmpSep1 > 3)) or (tmpSep2 = len) then
      valid := False;

    if valid then
      if (tmpSep1 > 0) then
       begin
        if (tmpSep1 < 3) then
          valid := False; //must be yy, yyy or yyyy
        if valid then
         begin
          annee1 := Copy(Date, 1, tmpSep1 - 1);
          if tmpSep2 = 0 then
            mois1 := Copy(Date, tmpSep1 + 1, len - tmpSep1)
          else
           begin
            mois1 := Copy(Date, tmpSep1 + 1, tmpSep2 - tmpSep1 - 1);
            jour1 := Copy(Date, tmpSep2 + 1, len - tmpSep2);
           end;
         end;
       end
      else
       begin
        annee1 := Copy(Date, 1, 4);
        if len > 5 then
          mois1 := Copy(Date, 5, 2);
        if len > 7 then
          jour1 := Copy(Date, 7, 2);
       end;
    while length(annee1) < 4 do
      annee1 := '0' + annee1;
    while length(mois1) < 2 do
      mois1 := '0' + mois1;
    while length(jour1) < 2 do
      jour1 := '0' + jour1;
    if (bc1 = '-') then
     begin
      annee1 := IntToStr(StrToInt(annee1) * (-1));
      while length(annee1) < 4 do
        annee1 := Copy(annee1, 1, 1) + '0' + Copy(annee1, 2, length(annee1));
     end;
    Date := Copy(Date, len + 1, Length(Date));
    Annee2 := '0000';
    Mois2 := '00';
    Jour2 := '00';
    if length(Date) > 0 then
     begin
      while (Date[1] = ' ') do
        Date := Copy(Date, 2, length(Date));
      // Verify Style of 2nd date
      if (Date[1] = '-') then
       begin
        Date := Copy(Date, 2, length(Date));
        style := '5';
       end;
      temp := RemoveUTF8(Date);
      if (temp[1] = 'a') or (temp[1] = 'à') then
       begin
        Date := Copy(temp, 2, length(Date));
        style := '7';
       end;
      if (Copy(Date, 1, 2) = 'au') then
       begin
        Date := Copy(Date, 3, length(Date));
        style := '7';
       end;
      if (Copy(Date, 1, 2) = 'ou') then
       begin
        Date := Copy(Date, 3, length(Date));
        style := '6';
       end;
      while (Date[1] = ' ') do
        Date := Copy(Date, 2, length(Date));
      bc2 := '';
      if (Date[1] = '-') then
       begin
        bc2 := '-';
        Date := Copy(Date, 2, length(Date));
       end;
      if valid and (StrToInt(style) > 4) then
       begin
        // extract year, month, day
        len := Length(Date);
        tmpSep1 := 0;
        tmpSep2 := 0;
        //validate the position of the date separators, if any, and
        //make sure only date separators and numerics are entered ...
        if len > 10 then
          valid := False
        else
          for i := 1 to len do
            if not (Date[i] in ['0'..'9']) then
             begin
              if i < 3 then
                valid := False
              else if tmpSep1 = 0 then
                tmpSep1 := i
              else
                tmpSep2 := i;
             end;

        //check for other error conditions ...
        if ((tmpSep1 = 0) and not (len in [4, 6, 8])) or
          ((tmpSep1 > 0) and (tmpSep2 - tmpSep1 > 3)) or (tmpSep2 = len) then
          valid := False;

        if valid then
          if (tmpSep1 > 0) then
           begin
            if (tmpSep1 < 3) then
              valid := False; //must be yy, yyy or yyyy
            if valid then
             begin
              annee2 := Copy(Date, 1, tmpSep1 - 1);
              if tmpSep2 = 0 then
                mois2 := Copy(Date, tmpSep1 + 1, len - tmpSep1)
              else
               begin
                mois2 := Copy(Date, tmpSep1 + 1, tmpSep2 - tmpSep1 - 1);
                jour2 := Copy(Date, tmpSep2 + 1, len - tmpSep2);
               end;
             end;
           end
          else
           begin
            annee2 := Copy(Date, 1, 4);
            mois2 := Copy(Date, 5, 2);
            jour2 := Copy(Date, 7, 2);
           end;
        while length(annee2) < 4 do
          annee2 := '0' + annee2;
        while length(mois2) < 2 do
          mois2 := '0' + mois2;
        while length(jour2) < 2 do
          jour2 := '0' + jour2;
        if (bc2 = '-') then
         begin
          annee2 := IntToStr(StrToInt(annee2) * (-1));
          while length(annee2) < 4 do
            annee2 := Copy(annee2, 1, 1) + '0' + Copy(annee2, 2, length(annee2));
         end;
       end;
     end;
    { TODO 11 : Si <-999 l'annee a 5 chiffres, ce qui n'est pas pris en compte dans le format de date dans la base de données }
    if (length(annee1) > 4) then
      Valid := False;
    if (length(annee2) > 4) then
      Valid := False;
    if (StrToInt(mois1) > 12) or (StrToInt(mois2) > 12) or (StrToInt(jour1) > 31) or
      (StrToInt(jour2) > 31) then
      Valid := False;
    { TODO : Bug: n'accepte pas si l'annee, le mois ou le jour est 0... }
    // Valide que le date est valide
    if (StrToInt(mois1) > 0) and (StrToInt(jour1) > 0) and
      (not (Copy(annee1, 1, 1) = '-')) then
      if not (TryEncodeDate(StrToInt(annee1), StrToInt(mois1),
        StrToInt(jour1), test)) then
        valid := False;
    if (StrToInt(mois2) > 0) and (StrToInt(jour2) > 0) and
      (not (Copy(annee2, 1, 1) = '-')) then
      if not (TryEncodeDate(StrToInt(annee2), StrToInt(mois2),
        StrToInt(jour2), test)) then
        valid := False;
    if Valid then
      if format = 1 then
        InterpreteDate := '1' + Annee1 + Mois1 + Jour1 + '0' + style + Annee2 + Mois2 + Jour2 + '00'
      else
        InterpreteDate := Original
    else
    if format = 1 then
      InterpreteDate := '0' + Original
    else
      InterpreteDate := Original;
   end;
end;


function GetName(no: integer): string;

var
  UndecodedName: string;
begin
  UndecodedName := dmGenData.GetIndividuumName(no);
  Result := DecodeName(UndecodedName, 1);
end;

function getI3(nstr: string): string;
var
  no: longint;
begin
  if trystrtoint(Nstr, no) then
    Result := dmGenData.GetI3(no);
end;

function getI4(nstr: string): string;
var
  no: longint;
begin
  if trystrtoint(Nstr, no) then
    Result := dmGenData.GetI4(no);
end;

function getName(nstr: string): string;
var
  no: longint;
  UndecodedName: string;
begin
  if trystrtoint(Nstr, no) then
    UndecodedName := dmGenData.GetIndividuumName(no);
  Result := DecodeName(UndecodedName, 1);
end;

function AutoQuote(orgStr: string): string;
begin
  Result := AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(orgStr, '\', '\\'),
    '"', '\"'), '''', '\''');
end;

function GetI3(no: integer): string;
begin
  Result := dmGenData.GetI3(no);
end;

function GetI4(no: integer): string;
begin
  Result := dmGenData.GetI4(no);
end;

function DecodePhraseStemma(sIndividual: string; role: string;
  phrase: string; TypeEvenement: string; evenement: string; char: integer): string;
var
  lidInd, lidEvent: longint;
begin
  if TryStrToInt(sIndividual, lidInd) and TryStrToInt(evenement, lidEvent) then
    Result := DecodePhraseStemma(lidInd, role, phrase, TypeEvenement, lidEvent, char)
  else
    Result := '';
end;

function CalculateAge(Date1: string; Date2: string; format: byte): string;
var
  annee1, mois1, jour1: word;
  annee2, mois2, jour2: word;
  annee3, mois3, jour3: word;
  temps1, temps2: TDateTime;
begin
  if (Copy(Date1, 1, 1) = '1') and (Copy(Date2, 1, 1) = '1') then
   begin
    annee1 := StrToInt(Copy(Date1, 2, 4));
    mois1 := StrToInt(Copy(Date1, 6, 2));
    jour1 := StrToInt(Copy(Date1, 6, 2));
    annee2 := StrToInt(Copy(Date2, 2, 4));
    mois2 := StrToInt(Copy(Date2, 6, 2));
    jour2 := StrToInt(Copy(Date2, 6, 2));
    temps1 := EncodeDate(annee1, mois1, jour1);
    temps2 := EncodeDate(annee2, mois2, jour2);
    if temps1 > temps2 then
      DecodeDate(temps1 - temps2, annee3, mois3, jour3)
    else
      DecodeDate(temps2 - temps1, annee3, mois3, jour3);
    if format = 0 then
      CalculateAge := IntToStr(annee3);
   end
  else
    CalculateAge := '';
end;

function DecodePhrase(idIndividuum: integer; role: string; phrase: string;
  TypeEvenement: string; evenement: integer): string;
var
  i: integer;
begin
  if copy(phrase, 1, 4) = '!TMG' then
    Result := trim(DecodePhraseTMG(idIndividuum, role, copy(phrase, 5, length(phrase)),
      TypeEvenement, IntToStr(evenement)))
  else
   begin
    Result := trim(DecodePhraseStemma(idIndividuum, role, phrase,
      TypeEvenement, evenement, 1));
   end;
  // Remplace les "  " par " "
  for i := 1 to length(Result) - 1 do
    if Copy(Result, i, 2) = '  ' then
      Result := Copy(Result, 1, i) + Copy(Result, i + 2, length(Result));
  if not (Copy(Result, length(Result), 1) = '.') then
    Result := Result + '.';
  Result := UpperCase(Copy(Result, 1, 1)) + Copy(Result, 2, Length(Result));
end;

function DecodePhraseTMG(idSujet: integer; role: string; phrase: string;
  TypeEvenement: string; evenement: string): string;
var
  RoleRecherche, Remplace, Code, temp, Sexe, lsI3: string;
  i, PosStart1, PosStart2, PosEnd1, PosEnd2, PosSeparateur: integer;
  Continue: boolean;
begin
  if AnsiPos('[L=' + Translation.Items[320] + ']', uppercase(phrase)) > 0 then
   begin
    phrase := copy(phrase, AnsiPos('[L=' + Translation.Items[320] + ']', uppercase(phrase)) + 4 +
      length(Translation.Items[320]), length(phrase));
    if AnsiPos('[L=', uppercase(phrase)) > 0 then
      phrase := copy(phrase, 1, AnsiPos('[L=', uppercase(phrase)));
   end;
  RoleRecherche := '[R=' + role;
  if AnsiPos(RoleRecherche, uppercase(phrase)) > 0 then
   begin
    phrase := copy(phrase, AnsiPos(RoleRecherche, uppercase(phrase)) +
      length(RoleRecherche) + 1, length(phrase));
    if AnsiPos('[R=', uppercase(phrase)) > 0 then
      phrase := copy(phrase, 1, AnsiPos('[R=', uppercase(phrase)) - 1);
   end;
  if AnsiPos('$!&', uppercase(phrase)) > 0 then
   begin
    if dmGenData.GetSexOfInd(idSujet) = 'F' then
      phrase := copy(phrase, AnsiPos('$!&', phrase) + 3, length(phrase))
    else
      phrase := copy(phrase, 1, AnsiPos('$!&', phrase) - 1);
   end;
  PosStart1 := 0;
  PosStart2 := 0;
  PosEnd1 := 0;
  PosEnd2 := 0;
  PosSeparateur := 0;
  Continue := True;
  while ((PosEnd2 <= PosStart2) and Continue) do
   begin
    i := PosEnd2 + 1;
    while (i <= length(phrase)) do
     begin
      if Copy(phrase, i, 1) = '[' then
       begin
        PosStart2 := i;
        i := length(phrase);
       end;
      i := i + 1;
     end;
    Continue := (Copy(phrase, PosStart2, 1) = '[');
    if Continue then
     begin
      i := PosStart2 - 1;
      while i > 0 do
       begin
        if Copy(Phrase, i, 1) = '<' then
         begin
          PosStart1 := i;
          i := 0;
         end
        else
        if Copy(Phrase, i, 1) = '>' then
         begin
          PosStart1 := 0;
          i := 0;
         end;
        i := i - 1;
       end;
      i := PosStart2 + 1;
      while i <= length(phrase) do
       begin
        if Copy(Phrase, i, 1) = ']' then
         begin
          PosEnd2 := i;
          i := length(phrase);
         end;
        i := i + 1;
       end;
      i := PosEnd2 + 1;
      while i <= length(phrase) do
       begin
        if Copy(Phrase, i, 1) = '>' then
         begin
          PosEnd1 := i;
          i := length(phrase);
         end
        else
        if Copy(Phrase, i, 1) = '<' then
         begin
          PosEnd1 := 0;
          i := length(phrase);
         end;
        i := i + 1;
       end;
      if ((PosStart1 > 0) and (PosEnd1 > 0)) then
       begin
        i := PosStart1 + 1;
        while i <= (PosEnd1 - 1) do
         begin
          if Copy(Phrase, i, 1) = '|' then
           begin
            PosSeparateur := i;
            i := PosEnd1;
           end;
          i := i + 1;
         end;
       end;
     end;
   end;

  // Trouve ce qui doit être remplacé

  Remplace := '';
  if TypeEvenement = 'R' then
    with dmGenData.Query4 do
     begin
       begin
        if PosEnd2 > PosStart2 then
         begin
          Code := Copy(Phrase, PosStart2 + 1, PosEnd2 - PosStart2 - 1);
          if Code = 'A' then
           begin
            SQL.Text := 'SELECT SD FROM R WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := CalculateAge(dmGenData.GetI3(idSujet), Fields[0].AsString, 0);
            if Remplace = '0' then
              Remplace := '';
           end;
          if Code = 'A1' then
           begin
            SQL.Text := 'SELECT SD, A FROM R WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            lsI3 := dmGenData.GetI3(Fields[1].AsInteger);
            Remplace := CalculateAge(lsI3, Fields[0].AsString, 0);
            if Remplace = '0' then
              Remplace := '';
           end;
          if Code = 'A2' then
           begin
            SQL.Text := 'SELECT SD, B FROM R WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            lsI3 := dmGenData.GetI3(Fields[1].AsInteger);
            Remplace := CalculateAge(lsI3, Fields[0].AsString, 0);
            if Remplace = '0' then
              Remplace := '';
           end;
          if Code = 'AO' then
           begin
            SQL.Text := 'SELECT SD, B, A FROM R WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            if Fields[1].AsInteger = idSujet then
              lsi3 := dmGenData.geti3(Fields[1].AsInteger)
            else
              lsi3 := dmGenData.geti3(Fields[2].AsInteger);
            Remplace := CalculateAge(lsI3, Fields[0].AsString, 0);
            if Remplace = '0' then
              Remplace := '';
           end;
          if Code = 'D' then
           begin
            SQL.Text := 'SELECT SD FROM R WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := ConvertDate(Fields[0].AsString, 0);
           end;
          //         if Code='L' then remplace:='/LIEU/'; JAMAIS DANS type 'R'
          if Code = 'M' then
           begin
            SQL.Text := 'SELECT M FROM R WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := Fields[0].AsString;
            if AnsiPos('[L=' + Translation.Items[320] + ']', uppercase(Remplace)) > 0 then
             begin
              Remplace := copy(Remplace, AnsiPos(
                '[L=' + Translation.Items[320] + ']', uppercase(Remplace)) + 4 + length(
                Translation.Items[320]), length(Remplace));
              if AnsiPos('[L=', uppercase(Remplace)) > 0 then
                Remplace := copy(Remplace, 1, AnsiPos('[L=', uppercase(Remplace)));
             end;
           end;
          if (Code = 'W') or (Code = 'N') then
           begin
            if role = 'ENFANT' then
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent'
            else
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if Code = 'P' then
           begin
            if role = 'ENFANT' then
              SQL.Text := 'SELECT I.S FROM R JOIN I ON R.A=I.no WHERE R.no=:idEvent'
            else
              SQL.Text := 'SELECT I.S FROM R JOIN I ON R.B=I.no WHERE R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if Fields[0].AsString = 'F' then
              Remplace := Translation.Items[66]
            else
              Remplace := Translation.Items[67];
           end;
          if Code = 'PP' then
           begin
            if role = 'ENFANT' then
              SQL.Text := 'SELECT I.S FROM R JOIN I ON R.A=I.no WHERE R.no=:idEvent'
            else
              SQL.Text := 'SELECT I.S FROM R JOIN I ON R.B=I.no WHERE R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if Fields[0].AsString = 'F' then
              Remplace := Translation.Items[68]
            else
              Remplace := Translation.Items[69];
           end;
          if Code = 'PO' then
           begin
            if role = 'ENFANT' then
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent'
            else
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if Code = 'P1' then
           begin
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if Code = 'P2' then
           begin
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if Code = 'PAR' then
           begin
            Sexe := dmGenData.GetSexOfInd(idSujet);
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A=:idind ORDER BY R.SD';
            ParamByName('idInd').AsInteger := idSujet;
            if not EOF then
             begin
              if Sexe = 'F' then
                Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
              else
                Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
              Next;
              if not EOF then
                Remplace :=
                  Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
             end
            else
              Remplace := '';
           end;
          if Code = 'PARO' then
           begin
            SQL.Text := 'SELECT A,B FROM R WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if role = 'ENFANT' then
              Remplace := Fields[1].AsString
            else
              Remplace := Fields[0].AsString;
            SQL.Text := 'SELECT I.S FROM I WHERE I.no=:iiPara1';
            ParamByName('idPara1').AsString := Remplace;
            Open;
            Sexe := Fields[0].AsString;
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A=' +
              Remplace + ' ORDER BY R.SD';
            Open;
            if not EOF then
             begin
              if sexe = 'F' then
                Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
              else
                Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
              Next;
              if not EOF then
                Remplace :=
                  Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
             end
            else
              Remplace := '';
           end;
          if Code = 'PAR1' then
           begin
            SQL.Text := 'SELECT R.A, I.S FROM R JOIN I on R.A=I.no WHERE R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Remplace := Fields[0].AsString;
            Sexe := Fields[1].AsString;
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A=' +
              Remplace + ' ORDER BY R.SD';
            Open;
            if not EOF then
             begin
              if Sexe = 'F' then
                Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
              else
                Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
              Next;
              if not EOF then
                Remplace :=
                  Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
             end
            else
              Remplace := '';
           end;
          if Code = 'PAR2' then
           begin
            SQL.Text := 'SELECT R.B, I.S FROM R JOIN I on R.B=I.no WHERE R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Remplace := Fields[0].AsString;
            Sexe := Fields[1].AsString;
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A=' +
              Remplace + ' ORDER BY R.SD';
            Open;
            if not EOF then
             begin
              if sexe = 'F' then
                Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
              else
                Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
              Next;
              if not EOF then
                Remplace :=
                  Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
             end
            else
              Remplace := '';
           end;
          //         if Code='WO' then remplace:='/Noms de tous les témoins/'; JAMAIS DANS type 'R'
          if Copy(Code, 1, 2) = 'R:' then // soit ENFANT, soit PARENT
           begin
            if Copy(Code, 3, length(code)) = 'ENFANT' then
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent'
            else
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
           end;
         end;
       end;
     end;
  if TypeEvenement = 'E' then
    with dmGenData.Query4 do
     begin
       begin
        if PosEnd2 > PosStart2 then
         begin
          Code := Copy(Phrase, PosStart2 + 1, PosEnd2 - PosStart2 - 1);
          if Code = 'A' then
           begin
            SQL.Text := 'SELECT PD FROM E WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := CalculateAge(dmGenData.GetI3(idSujet), Fields[0].AsString, 0);
            if Remplace = '0' then
              Remplace := '';
           end;
          if Code = 'A1' then
           begin
            SQL.Text :=
              'SELECT E.PD, W.I FROM E JOIN W on E.no=W.E WHERE W.X=1 AND no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if not EOF then
             begin
              lsI3 := dmGenData.GetI3(Fields[1].AsInteger);
              Remplace := CalculateAge(lsI3, Fields[0].AsString, 0);
              if Remplace = '0' then
                Remplace := '';
             end;
           end;
          if Code = 'A2' then
           begin
            SQL.Text :=
              'SELECT E.PD, W.I FROM E JOIN W on E.no=W.E WHERE W.X=1 AND no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if not EOF then
             begin
              Next;
              if not EOF then
               begin
                lsI3 := dmGenData.GetI3(Fields[1].AsInteger);
                Remplace := CalculateAge(lsI3, Fields[0].AsString, 0);
                if Remplace = '0' then
                  Remplace := '';
               end;
             end;
           end;
          if Code = 'AO' then
           begin
            SQL.Text :=
              'SELECT E.PD, W.I FROM E JOIN W on E.no=W.E WHERE W.X=1 AND (NOT (W.I=:idInd)) AND no=:idEvent';
            ParamByName('idind').AsInteger := idSujet;
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if not EOF then
             begin
              lsI3 := dmGenData.GetI3(Fields[1].AsInteger);
              Remplace := CalculateAge(lsI3, Fields[0].AsString, 0);
              if Remplace = '0' then
                Remplace := '';
             end;
           end;
          if Code = 'D' then
           begin
            SQL.Text := 'SELECT PD FROM E WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := ConvertDate(Fields[0].AsString, 0);
           end;
          if Code = 'L' then
           begin
            SQL.Text := 'SELECT L.L FROM L JOIN E ON L.no=E.L WHERE E.no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := DecodeChanged(Fields[0].AsString);
           end;
          if Code = 'M' then
           begin
            SQL.Text := 'SELECT M FROM E WHERE no=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            Remplace := Fields[0].AsString;
            if AnsiPos('[L=' + Translation.Items[320] + ']', uppercase(Remplace)) > 0 then
             begin
              Remplace := copy(Remplace, AnsiPos(
                '[L=' + Translation.Items[320] + ']', uppercase(Remplace)) + 4 + length(
                Translation.Items[320]), length(Remplace));
              if AnsiPos('[L=', uppercase(Remplace)) > 0 then
                Remplace := copy(Remplace, 1, AnsiPos('[L=', uppercase(Remplace)) - 1);
             end;
           end;
          if (Code = 'N') then
           begin
            SQL.Text := 'SELECT N FROM N WHERE N.X=1 and N.I=:idInd';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if (Code = 'W') or (Code = 'P') then
           begin
            SQL.Text := 'SELECT I.S FROM I WHERE I.no=:idInd';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            if Fields[0].AsString = 'F' then
              Remplace := Translation.Items[66]
            else
              Remplace := Translation.Items[67];
           end;
          if Code = 'PP' then
           begin
            SQL.Text := 'SELECT I.S FROM I WHERE I.no=:idInd';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            if Fields[0].AsString = 'F' then
              Remplace := Translation.Items[68]
            else
              Remplace := Translation.Items[69];
           end;
          if Code = 'PO' then
           begin
            SQL.Text :=
              'SELECT N.N FROM N JOIN W on N.I=W.I WHERE W.X=1 AND N.X=1 AND W.E=' +
              Evenement + ' AND NOT W.I=:idInd';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            if not EOF then
              Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if Code = 'P1' then
           begin
            SQL.Text :=
              'SELECT N.N FROM N JOIN W on N.I=W.I WHERE W.X=1 AND N.X=1 AND W.E=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if not EOF then
              Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if Code = 'P2' then
           begin
            SQL.Text :=
              'SELECT N.N FROM N JOIN W on N.I=W.I WHERE W.X=1 AND N.X=1 AND W.E=:idEvent';
            ParamByName('idEvent').AsString := Evenement;
            Open;
            if not EOF then
             begin
              Next;
              if not EOF then
                Remplace := DecodeName(Fields[0].AsString, 1);
             end;
           end;
          if Code = 'PAR' then
           begin
            Sexe := dmGenData.GetSexOfInd(idSujet);
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A=:idInd ORDER BY R.SD';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            if not EOF then
             begin
              if sexe = 'F' then
                Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
              else
                Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
              Next;
              if not EOF then
                Remplace :=
                  Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
             end
            else
              Remplace := '';
           end;
          if Code = 'PARO' then
           begin
            SQL.Text := 'SELECT W.I, I.S FROM W JOIN I on W.I=I.no WHERE W.X=1 AND W.E=' +
              Evenement + ' AND NOT W.I=:idInd';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            if not EOF then
             begin
              Remplace := Fields[0].AsString;
              Sexe := Fields[1].AsString;
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A=' +
                Remplace + ' ORDER BY R.SD';
              Open;
              if not EOF then
               begin
                if sexe = 'F' then
                  Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
                else
                  Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
                Next;
                if not EOF then
                  Remplace :=
                    Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
               end
              else
                Remplace := '';
             end;
           end;
          if Code = 'PAR1' then
           begin
            SQL.Text := 'SELECT W.I, I.S FROM W JOIN I on W.I=I.no WHERE W.X=1 AND W.E=' +
              Evenement;
            Open;
            if not EOF then
             begin
              Sexe := Fields[1].AsString;
              Remplace := Fields[0].AsString;
              SQL.Text :=
                'SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A=' +
                Remplace + ' ORDER BY R.SD';
              Open;
              if not EOF then
               begin
                if sexe = 'F' then
                  Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
                else
                  Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
                Next;
                if not EOF then
                  Remplace :=
                    Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
               end
              else
                Remplace := '';
             end;
           end;
          if Code = 'PAR2' then
           begin
            SQL.Text := 'SELECT W.I, I.S FROM W JOIN I on W.I=I.no WHERE W.X=1 AND W.E=' +
              Evenement;
            Open;
            if not EOF then
             begin
              Next;
              if not EOF then
               begin
                Remplace := Fields[0].AsString;
                Sexe := Fields[1].AsString;
                SQL.Text :=
                  'SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A=' +
                  Remplace + ' ORDER BY R.SD';
                Open;
                if not EOF then
                 begin
                  if sexe = 'F' then
                    Remplace :=
                      Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
                  else
                    Remplace :=
                      Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
                  Next;
                  if not EOF then
                    Remplace :=
                      Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
                 end
                else
                  Remplace := '';
               end;
             end;
           end;
          if Code = 'WO' then
           begin
            SQL.Text :=
              'SELECT N.N FROM N JOIN W on N.I=W.I JOIN E on W.E=E.no WHERE N.X=1 AND W.X=0 AND E.no=' +
              Evenement;
            Open;
            while not EOF do
             begin
              temp := DecodeName(Fields[0].AsString, 1);
              Next;
              if length(remplace) = 0 then
                Remplace := temp
              else
              if EOF then
                Remplace := Remplace + Translation.Items[72] + temp
              else
                Remplace := Remplace + ', ' + temp;
             end;
           end;
          if Copy(Code, 1, 2) = 'R:' then
           begin
            RoleRecherche := Copy(Code, 3, length(Code));
            SQL.Text := 'SELECT N.N FROM N JOIN W on N.I=W.I WHERE N.X=1 AND W.E=' +
              Evenement + ' AND W.R=''' + RoleRecherche + '''';
            Open;
            while not EOF do
             begin
              temp := DecodeName(Fields[0].AsString, 1);
              Next;
              if length(remplace) = 0 then
                Remplace := temp
              else
              if EOF then
                Remplace := Remplace + Translation.Items[72] + temp
              else
                Remplace := Remplace + ', ' + temp;
             end;
           end;
         end;
       end;
     end;
  if TypeEvenement = 'N' then
    with dmGenData.Query4 do
     begin
       begin
        if PosEnd2 > PosStart2 then
         begin
          Code := Copy(Phrase, PosStart2 + 1, PosEnd2 - PosStart2 - 1);
          if (Code = 'A') or (Code = 'A1') then
           begin
            SQL.Text := 'SELECT PD FROM N WHERE no=' + Evenement;
            Open;
            Remplace := CalculateAge(dmGenData.GetI3(idSujet), Fields[0].AsString, 0);
            if Remplace = '0' then
              Remplace := '';
           end;
          //         if Code='A2' then JAMAIS DANS TYPE 'N'
          //         if Code='AO' then JAMAIS DANS TYPE 'N'
          if Code = 'D' then
           begin
            SQL.Text := 'SELECT PD FROM N WHERE no=' + Evenement;
            Open;
            Remplace := ConvertDate(Fields[0].AsString, 0);
           end;
          //         if Code='L' then remplace:='/LIEU/'; JAMAIS DANS type 'N'
          if Code = 'M' then
           begin
            SQL.Text := 'SELECT M FROM N WHERE no=' + Evenement;
            Open;
            Remplace := Fields[0].AsString;
            if AnsiPos('[L=' + Translation.Items[320] + ']', uppercase(Remplace)) > 0 then
             begin
              Remplace := copy(Remplace, AnsiPos(
                '[L=' + Translation.Items[320] + ']', uppercase(Remplace)) + 4 + length(
                Translation.Items[320]), length(Remplace));
              if AnsiPos('[L=', uppercase(Remplace)) > 0 then
                Remplace := copy(Remplace, 1, AnsiPos('[L=', uppercase(Remplace)));
             end;
           end;
          if (Code = 'W') or (Code = 'N') or (Code = 'P1') or (Copy(Code, 1, 2) = 'R:') then
           begin
            SQL.Text := 'SELECT N FROM N WHERE no=' + Evenement;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
           end;
          if Code = 'P' then
           begin
            SQL.Text := 'SELECT I.S FROM N JOIN I ON N.I=I.no WHERE N.no=' + Evenement;
            Open;
            if Fields[0].AsString = 'F' then
              Remplace := Translation.Items[66]
            else
              Remplace := Translation.Items[67];
           end;
          if Code = 'PP' then
           begin
            SQL.Text := 'SELECT I.S FROM N JOIN I ON N.I=I.no WHERE N.no=' + Evenement;
            Open;
            if Fields[0].AsString = 'F' then
              Remplace := Translation.Items[68]
            else
              Remplace := Translation.Items[69];
           end;
          //         if Code='PO' then JAMAIS DANS TYPE 'N'
          //         if Code='P2' then JAMAIS DANS TYPE 'N'
          if (Code = 'PAR') or (Code = 'PAR1') then
           begin
            SQL.Text := 'SELECT I.S FROM I WHERE I.no=:idIind';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            Sexe := Fields[0].AsString;
            SQL.Text :=
              'SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A=:idInd ORDER BY R.SD';
            ParamByName('idind').AsInteger := idSujet;
            Open;
            if not EOF then
             begin
              if sexe = 'F' then
                Remplace := Translation.Items[70] + DecodeName(Fields[0].AsString, 1)
              else
                Remplace := Translation.Items[71] + DecodeName(Fields[0].AsString, 1);
              Next;
              if not EOF then
                Remplace :=
                  Remplace + Translation.Items[72] + DecodeName(Fields[0].AsString, 1);
             end
            else
              Remplace := '';
           end;
          //         if Code='PARO' then JAMAIS DANS TYPE 'N'
          //         if Code='PAR2' then JAMAIS DANS TYPE 'N'
          //         if Code='WO' then remplace:='/Noms de tous les témoins/'; JAMAIS DANS type 'N'
         end;
       end;
     end;

  // Remplace

  if length(remplace) = 0 then
    if (PosStart1 > 0) and (PosEnd1 > 0) and (PosEnd1 > PosStart1) and
      (PosStart1 < PosStart2) and (PosEnd1 > PosEnd2) then
      if (PosSeparateur > 0) and (PosSeparateur < PosEnd2) then
        // on a "...<...|...[.]...>..."
        phrase := Copy(phrase, 1, PosStart1 - 1) + Copy(
          phrase, PosStart1 + 1, PosSeparateur - PosStart1 - 1) +
          Copy(phrase, PosEnd1 + 1, Length(phrase))
      else
      if (PosSeparateur > 0) and (PosSeparateur > PosEnd2) then
        // on a "...<...[.]...|...>..."
        phrase := Copy(phrase, 1, PosStart1 - 1) + Copy(
          phrase, PosSeparateur + 1, PosEnd1 - PosSeparateur - 1) +
          Copy(phrase, PosEnd1 + 1, Length(phrase))
      else // on a "...<...[...]...>...
        phrase := Copy(phrase, 1, PosStart1 - 1) + Copy(phrase, PosEnd1 + 1, Length(phrase))
    else // on a " ...[...]..."
      phrase := Copy(phrase, 1, PosStart2 - 1) + Copy(phrase, PosEnd2 + 1, Length(phrase))
  else
  if (PosStart1 > 0) and (PosEnd1 > 0) and (PosEnd1 > PosStart1) and
    (PosStart1 < PosStart2) and (PosEnd1 > PosEnd2) then
    if (PosSeparateur > 0) and (PosSeparateur < PosEnd2) then
      // on a "...<...|...[.]...>..."
      phrase := Copy(phrase, 1, PosStart1 - 1) + Copy(
        phrase, PosSeparateur + 1, PosStart2 - PosSeparateur - 1) +
        Remplace + Copy(phrase, PosEnd2 + 1, PosEnd1 - PosEnd2 - 1) +
        Copy(Phrase, PosEnd1 + 1, Length(Phrase))
    else
    if (PosSeparateur > 0) and (PosSeparateur > PosEnd2) then
      // on a "...<...[.]...|...>..."
      phrase := Copy(phrase, 1, PosStart1 - 1) + Copy(
        phrase, PosStart1 + 1, PosStart2 - PosStart1 - 1) +
        Remplace + Copy(phrase, PosEnd2 + 1, PosSeparateur - PosEnd2 - 1) +
        Copy(Phrase, PosEnd1 + 1, Length(Phrase))
    else // on a "...<...[...]...>...
      phrase := Copy(phrase, 1, PosStart1 - 1) + Copy(
        phrase, PosStart1 + 1, PosStart2 - PosStart1 - 1) +
        Remplace + Copy(phrase, PosEnd2 + 1, PosEnd1 - PosEnd2 - 1) +
        Copy(Phrase, PosEnd1 + 1, Length(Phrase))
  else // on a " ...[...]..."
    phrase := Copy(phrase, 1, PosStart2 - 1) + Remplace + Copy(
      phrase, PosEnd2 + 1, Length(phrase));

  if PosEnd2 > PosStart2 then
    phrase := DecodePhraseTMG(idSujet, role, phrase, TypeEvenement, evenement);

  DecodePhraseTMG := phrase;
end;

function GetRelationCountOfParents(lidInd:integer): integer;

begin
  with dmGenData.Query3 do begin
Close;
    SQL.Text :=
      'SELECT count(A) FROM R WHERE X=1 AND A=:idChild';
    ParamByName('idChild').AsInteger := lidInd;
    Open;
    Result :=  Fields[0].AsInteger;
    Close;
  end;
end;

function GetTypePossibRoles(var evenement: integer; var TypeEvenement: string
  ): string;

begin
  with dmGenData.Query4 do begin
  SQL.Text :=
                'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
                ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
                TypeEvenement + '.no=:idEvent';
              ParamByName('idEvent').AsInteger := Evenement;
              Open;
               Result:= Fields[0].AsString;
              close;
  end;
end;

function DecodePhraseStemma(idIndividual: integer; role: string; phrase: string;
  TypeEvenement: string; evenement, char: integer): string;
var
  RoleRecherche, Remplace, temp, Sexe, lSex, lRoles: string;
  PosEnd1, PosSep1, PosSep2, PosSep3, compte: integer;
  lidInd: LongInt;
begin
  if AnsiPos('<L=' + Translation.Items[319] + '>', uppercase(phrase)) > 0 then
   begin
    phrase := copy(phrase, AnsiPos('<L=' + Translation.Items[319] + '>', uppercase(phrase)) + 5,
      length(phrase));
    if AnsiPos('</L>', uppercase(phrase)) > 0 then
      phrase := copy(phrase, 1, AnsiPos('</L>', uppercase(phrase)));
   end;
  RoleRecherche := '<R=' + role;
  if AnsiPos(RoleRecherche, uppercase(phrase)) > 0 then
   begin
    phrase := copy(phrase, AnsiPos(RoleRecherche, uppercase(phrase)) +
      length(RoleRecherche) + 1, length(phrase));
    if AnsiPos('</R>', uppercase(phrase)) > 0 then
      phrase := copy(phrase, 1, AnsiPos('</R>', uppercase(phrase)) - 1);
   end;
  while (not ((copy(phrase, char, 1) = '$') or (copy(phrase, char, 1) = '<'))) and
    (char < length(phrase)) do
    char := char + 1;
  if idIndividual > 0 then
   begin
    if copy(phrase, char, 1) = '$' then
      with dmGenData.Query4 do
       begin
         begin
          // fr: Vérifie si c'est une variable, si oui remplace par sa valeur
          // en: Checks to see if it is a variable, if yes replaces by its value
          if copy(phrase, char + 1, 1) = 'L' then
           begin
            // fr: Remplace par le Lieu
            // en: Replaces the place
            SQL.Text := 'SELECT L.L FROM L JOIN E ON L.no=E.L WHERE E.no=:idEvent';
            ParamByName('idEvent').AsInteger := Evenement;
            Open;
            remplace := DecodeChanged(Fields[0].AsString);
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 2, length(phrase));
           end;
          if copy(phrase, char + 1, 1) = 'N' then
           begin
            // Remplace par le Nom
            SQL.Text := 'SELECT N FROM N WHERE no=:idName';
            ParamByName('idName').AsInteger := Evenement;
            Open;
            Remplace := DecodeName(Fields[0].AsString, 1);
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 2, length(phrase));
           end;
          if copy(phrase, char + 1, 1) = 'M' then
           begin
            // Remplace par le Mémo
            SQL.Text := 'SELECT M FROM ' + TypeEvenement + ' WHERE no=:idEvent';
            ParamByName('idEvent').AsInteger := Evenement;
            Open;
            Remplace := Fields[0].AsString;
            if AnsiPos('<L=' + Translation.Items[320] + ']', uppercase(Remplace)) > 0 then
             begin
              Remplace := copy(Remplace, AnsiPos(
                '<L=' + Translation.Items[320] + '>', uppercase(Remplace)) + 4 + length(
                Translation.Items[320]), length(Remplace));
              if AnsiPos('</L>', uppercase(Remplace)) > 0 then
                Remplace := copy(Remplace, 1, AnsiPos('</L>', uppercase(Remplace)));
             end;
            if AnsiPos('[L=' + Translation.Items[320] + ']', uppercase(Remplace)) > 0 then
             begin
              Remplace := copy(Remplace, AnsiPos(
                '[L=' + Translation.Items[320] + ']', uppercase(Remplace)) + 4 + length(
                Translation.Items[320]), length(Remplace));
              if AnsiPos('[L=', uppercase(Remplace)) > 0 then
                Remplace := copy(Remplace, 1, AnsiPos('[L=', uppercase(Remplace)));
             end;
            phrase := Copy(phrase, 1, char - 1) + Remplace +
              Copy(phrase, char + 2, length(phrase));
           end;
          if copy(phrase, char + 1, 1) = 'P' then
           begin
            // Remplace par le Pronom

            if dmGenData.GetSexOfInd(idIndividual) = 'F' then
              Remplace := Translation.Items[66] // Female pronoun
            else
              Remplace := Translation.Items[67]; // Male pronoun
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 2, length(phrase));
           end;
          if copy(phrase, char + 1, 1) = 'D' then
           begin
            // Remplace par la Date
            if TypeEvenement = 'R' then
              SQL.Text := 'SELECT SD FROM R WHERE no=:idEvent'
            else
              SQL.Text := 'SELECT PD FROM ' + TypeEvenement + ' WHERE no=:idEvent';
            ParamByName('idEvent').AsInteger := evenement;
            Open;
            Remplace := ConvertDate(Fields[0].AsString, 0);
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 2, length(phrase));
           end;
          if copy(phrase, char + 1, 2) = 'R_' then
           begin
            // Vérifie quel role, remplace par la liste des noms }
            temp := Copy(phrase, char + 3, length(phrase));
            posend1 := AnsiPos('_', temp);
            if posend1 > 0 then
             begin
              RoleRecherche := Copy(temp, 1, posend1 - 1);
              // Vérifie que le role est dans la liste des roles possible }
              SQL.Text := 'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
                ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
                TypeEvenement + '.no=:idEvent';

              ParamByName('idEvent').AsInteger := evenement;
              Open;
              if AnsiPos(RoleRecherche, Fields[0].AsString) > 0 then
               begin
                remplace := '';
                if TypeEvenement = 'N' then
                 begin
                  remplace := dmGenData.GetIndividuumName(idIndividual);
                 end;
                if TypeEvenement = 'R' then
                 begin
                  SQL.Text := 'SELECT R.A, R.B FROM R WHERE no=:idEvent';
                  ParamByName('idEvent').AsInteger := evenement;
                  Open;
                  if RoleRecherche = 'PARENT' then
                    remplace := dmGenData.GetIndividuumName(Fields[1].AsInteger)
                  else
                    remplace := dmGenData.GetIndividuumName(Fields[0].AsInteger);
                 end;
                if TypeEvenement = 'E' then
                 begin
                  SQL.Text :=
                    'SELECT W.I, N.N FROM W JOIN E ON E.no=W.E JOIN N ON N.I=W.I WHERE N.X=1 AND E.no=:idEvent'
                    + ' AND W.R=''' + RoleRecherche + '''';
                  ParamByName('idEvent').AsInteger := Evenement;
                  Open;
                  First;
                  compte := 0;
                  while not EOF do
                   begin
                    temp := DecodeName(Fields[1].AsString, 1);
                    if compte = 0 then
                      remplace := temp;
                    if compte = 1 then
                      remplace := temp + Translation.Items[72] + remplace;
                    if compte > 1 then
                      remplace := temp + ', ' + remplace;
                    Next;
                    compte := compte + 1;
                   end;
                 end;
               end;
             end;
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 3 + posend1, length(phrase));
           end;
          if copy(phrase, char + 1, 3) = 'RO_' then
           begin
            // Vérifie quel role, remplace par la liste des noms }
            temp := Copy(phrase, char + 4, length(phrase));
            posend1 := AnsiPos('_', temp);
            if posend1 > 0 then
             begin
              RoleRecherche := Copy(temp, 1, posend1 - 1);
              // Vérifie que le role est dans la liste des roles possible }
              SQL.Text := 'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
                ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
                TypeEvenement + '.no=:idEvent';
              ParamByName('idEvent').AsInteger := Evenement;
              Open;
              if AnsiPos(RoleRecherche, Fields[0].AsString) > 0 then
               begin
                remplace := '';
                if TypeEvenement = 'R' then
                 begin
                  SQL.Text := 'SELECT R.A, R.B FROM R WHERE no=:idEvent';
                  ParamByName('idEvent').AsInteger := Evenement;
                  Open;
                  if RoleRecherche = 'PARENT' then
                    remplace := dmGenData.GetIndividuumName(Fields[0].AsInteger)
                  else
                    remplace := dmGenData.GetIndividuumName(Fields[1].AsInteger);
                 end;
                if TypeEvenement = 'E' then
                 begin
                  SQL.Text :=
                    'SELECT W.I, N.N FROM W JOIN E ON E.no=W.E JOIN N ON N.I=W.I WHERE N.X=1 AND E.no=:idEvent'
                    + ' AND W.R=''' + RoleRecherche + '''';
                  ParamByName('idEvent').AsInteger := Evenement;
                  Open;
                  compte := 0;
                  while not EOF do
                   begin
                    if not (Fields[0].AsInteger = idIndividual) then
                     begin
                      temp := DecodeName(Fields[1].AsString, 1);
                      if compte = 0 then
                        remplace := temp;
                      if compte = 1 then
                        remplace := temp + Translation.Items[72] + remplace;
                      if compte > 1 then
                        remplace := temp + ', ' + remplace;
                      compte := compte + 1;
                     end;
                    Next;
                   end;
                 end;
               end;
             end;
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 4 + posend1, length(phrase));
           end;
          if copy(phrase, char + 1, 3) = 'RP_' then
           begin
            // Vérifie quel role, remplace par la liste des noms
            temp := Copy(phrase, char + 4, length(phrase));
            posend1 := AnsiPos('_', temp);
            if posend1 > 0 then
             begin
              RoleRecherche := Copy(temp, 1, posend1 - 1);
              // Vérifie que le role est dans la liste des roles possible }
              SQL.Text := 'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
                ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
                TypeEvenement + '.no=:idEvent';
              ParamByName('idEvent').AsInteger := Evenement;
              Open;
              if AnsiPos(RoleRecherche, Fields[0].AsString) > 0 then
               begin
                remplace := '';
                if TypeEvenement = 'R' then
                 begin
                  SQL.Text := 'SELECT R.A, R.B FROM R WHERE no=:idEvent';
                  ParamByName('idEvent').AsInteger := Evenement;
                  Open;
                  dmGenData.Query3.SQL.Clear;
                  dmGenData.Query3.SQL.text:='SELECT R.A, R.B FROM R WHERE X=1 AND R.A=:idParent';
                  if RoleRecherche = 'PARENT' then
                    dmGenData.Query3.ParamByName('idparent').AsInteger:=Fields[1].AsInteger
                  else
                    dmGenData.Query3.ParamByName('idparent').AsInteger:=Fields[0].AsInteger;
                  dmGenData.Query3.Open;
                  while not dmGenData.Query3.EOF do
                   begin
                    if length(remplace) = 0 then
                      remplace :=
                        dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger)
                    else
                      remplace :=
                        remplace + Translation.Items[72] + dmGenData.GetIndividuumName(
                        dmGenData.Query3.Fields[1].AsInteger);
                    dmGenData.Query3.Next;
                   end;
                 end;
                if TypeEvenement = 'E' then
                 begin
                  SQL.Text :=
                    'SELECT W.I FROM W JOIN E ON E.no=W.E WHERE E.no=:idEvent' +
                    ' AND W.R=''' + RoleRecherche + '''';
                  ParamByName('idEvent').AsInteger := Evenement;
                  Open;
                  compte := 0;
                  while not EOF do
                   begin
                    dmGenData.Query3.SQL.Text :=
                      'SELECT R.A, R.B FROM R WHERE X=1 AND R.A=' +
                      Fields[0].AsString;
                    dmGenData.Query3.Open;
                    while not dmGenData.Query3.EOF do
                     begin
                      temp :=
                        dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger);
                      if compte = 0 then
                        remplace := temp;
                      if compte = 1 then
                        remplace := temp + Translation.Items[72] + remplace;
                      if compte > 1 then
                        remplace := temp + ', ' + remplace;
                      compte := compte + 1;
                      dmGenData.Query3.Next;
                     end;
                    Next;
                   end;
                 end;
               end;
             end;
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 4 + posend1, length(phrase));
           end;
          if copy(phrase, char + 1, 4) = 'ROP_' then
           begin
            // Vérifie quel role, remplace par la liste des noms
            temp := Copy(phrase, char + 5, length(phrase));
            posend1 := AnsiPos('_', temp);
            if posend1 > 0 then
             begin
              RoleRecherche := Copy(temp, 1, posend1 - 1);
              // Vérifie que le role est dans la liste des roles possible }
              SQL.Text := 'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
                ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
                TypeEvenement + '.no=:idEvent';
              ParamByName('idEvent').AsInteger := Evenement;
              Open;
              if AnsiPos(RoleRecherche, Fields[0].AsString) > 0 then
               begin
                remplace := '';
                if TypeEvenement = 'R' then
                 begin
                  SQL.Text := 'SELECT R.A, R.B FROM R WHERE no=:idEvent';
                  ParamByName('idEvent').AsInteger := Evenement;
                  Open;
                  dmGenData.Query3.SQL.Clear;
                  dmGenData.Query3.SQL.text:='SELECT R.A, R.B FROM R WHERE X=1 AND R.A=:idParent';
                  if RoleRecherche = 'PARENT' then
                    dmGenData.Query3.ParamByName('idparent').AsInteger:=Fields[1].AsInteger
                  else
                    dmGenData.Query3.ParamByName('idparent').AsInteger:=Fields[0].AsInteger;
                  dmGenData.Query3.Open;
                  while not dmGenData.Query3.EOF do
                   begin
                    if length(remplace) = 0 then
                      remplace :=
                        dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger)
                    else
                      remplace :=
                        remplace + Translation.Items[72] + dmGenData.GetIndividuumName(
                        dmGenData.Query3.Fields[1].AsInteger);
                    dmGenData.Query3.Next;
                   end;
                 end;
                if TypeEvenement = 'E' then
                 begin
                  SQL.Text :=
                    'SELECT W.I FROM W JOIN E ON E.no=W.E WHERE E.no=:idEvent' +
                    ' AND W.R=''' + RoleRecherche + '''';
                  ParamByName('idEvent').AsInteger := Evenement;
                  Open;
                  while not EOF do
                   begin
                    compte := 0;
                    if not (Fields[0].AsInteger = idIndividual) then
                     begin
                      dmGenData.Query3.SQL.Text :=
                        'SELECT R.A, R.B FROM R WHERE X=1 AND R.A=' +
                        Fields[0].AsString;
                      dmGenData.Query3.Open;
                      while not dmGenData.Query3.EOF do
                       begin
                        temp :=
                          dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger);
                        if compte = 0 then
                          remplace := temp;
                        if compte = 1 then
                          remplace := temp + Translation.Items[72] + remplace;
                        if compte > 1 then
                          remplace := temp + ', ' + remplace;
                        compte := compte + 1;
                        dmGenData.Query3.Next;
                       end;
                     end;
                    Next;
                   end;
                 end;
               end;
             end;
            phrase := Copy(phrase, 1, char - 1) + remplace +
              Copy(phrase, char + 5 + posend1, length(phrase));
           end;
          if (char + 1) < length(phrase) then
            phrase := DecodePhraseStemma(idIndividual, role, phrase,
              TypeEvenement, evenement, char + 1);
         end;
       end;
    if copy(phrase, char, 4) = '<$S=' then
     begin
      // fr: Vérifie si c'est une fonction
      // en: Check if it is a function
      temp := Copy(phrase, char + 6, length(phrase));
      posend1 := AnsiPos('</S>', temp);
      temp := copy(phrase, char + 6, posend1 - 1);
      if ((copy(phrase, char + 4, 2) = 'M>') or (copy(phrase, char + 4, 2) = 'F>')) and
        (posend1 > 0) then
       begin
        // fr: Si c'est une fonction remplace par sa valeur
        // en: If it is a function replace it by its value
        Sexe := Copy(phrase, char + 4, 1);
        lSex := dmGenData.GetSexOfInd(idIndividual);
        if (sexe = lSex) or ((sexe = 'M') and (lSex = '?')) then
          remplace := temp
        else
          remplace := '';
        phrase := Copy(phrase, 1, char - 1) + remplace + Copy(
          phrase, char + 9 + posend1, length(phrase));
       end;
      phrase := DecodePhraseStemma(idIndividual, role, phrase, TypeEvenement,
        evenement, char);
     end;
    if copy(phrase, char, 2) = '<<' then
     begin
      temp := Copy(phrase, char + 3, length(phrase));
      possep1 := AnsiPos('|', temp);
      posend1 := AnsiPos('>>', temp);
      temp := Copy(temp, possep1 + 1, length(temp));
      possep2 := AnsiPos('|', temp) + possep1;
      temp := Copy(temp, possep2 - possep1 + 1, length(temp));
      if AnsiPos('|', temp) > 0 then
       begin
        possep3 := AnsiPos('|', temp) + possep2;
        if possep3 > posend1 then
          possep3 := posend1;
       end
      else
        possep3 := posend1;
      // Vérifie si c'est une fonction, si oui remplace par sa valeur
      if (possep1 > 0) and (posend1 > 0) and (possep2 > 0) then
       begin
        remplace := Copy(phrase, char + 3 + possep1, possep2 - possep1 - 1);
        temp := Copy(phrase, char + 2, possep1);
        if Copy(temp, 1, 2) = '$M' then
         begin
          dmGenData.Query4.SQL.Text :=
            'SELECT M FROM ' + TypeEvenement + ' WHERE no=:idEvent';
          dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
          dmGenData.Query4.Open;
          if length(dmGenData.Query4.Fields[0].AsString) > 0 then
            remplace := Copy(phrase, char + 3 + possep1 + possep2, posend1 - possep2 - 1);
         end;
        if Copy(temp, 1, 2) = '$L' then
         begin
           dmGenData.Query4.SQL.Text :=
            'SELECT L.L FROM L JOIN E ON L.no=E.L WHERE E.no=:idEvent';
          dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
          dmGenData.Query4.Open;
          if length(DecodeChanged(dmGenData.Query4.Fields[0].AsString)) > 0 then
            remplace := Copy(phrase, char + 3 + possep1 + possep2, posend1 - possep2 - 1);
         end;
        if Copy(temp, 1, 2) = '$D' then
         begin
          if TypeEvenement = 'E' then
            dmGenData.Query4.SQL.Text := 'SELECT PD FROM E WHERE E.no=:idEvent';
          if TypeEvenement = 'N' then
            dmGenData.Query4.SQL.Text := 'SELECT PD FROM N WHERE E.no=:idEvent';
          if TypeEvenement = 'R' then
            dmGenData.Query4.SQL.Text := 'SELECT SD FROM R WHERE E.no=:idEvent';
          dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
          dmGenData.Query4.Open;
          if Length(ConvertDate(dmGenData.Query4.Fields[0].AsString, 1)) > 0 then
            remplace := Copy(phrase, char + 3 + possep1 + possep2, posend1 - possep2 - 1);
         end;
        if Copy(temp, 1, 3) = '$R_' then
         begin
          RoleRecherche := Copy(phrase, char + 5, possep1 - 4);
          // Vérifie que le role est dans la liste des roles possible }
          dmGenData.Query4.SQL.Text :=
            'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
            ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
            TypeEvenement + '.no=:idEvent';
          dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
          dmGenData.Query4.Open;
          compte := 0;
          if AnsiPos(RoleRecherche, dmGenData.Query4.Fields[0].AsString) > 0 then
           begin
            if (TypeEvenement = 'N') or (TypeEvenement = 'R') then
              compte := 1;
            if (TypeEvenement = 'E') then
             begin
              dmGenData.Query4.SQL.Text :=
                'SELECT W.I FROM W JOIN E ON W.E=E.no WHERE ' +
                'W.R=''' + RoleRecherche + ''' AND E.no=:idEvent';
              dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
              dmGenData.Query4.Open;
              compte := dmGenData.Query4.RecordCount;
             end;
           end;
         end;
        if Copy(temp, 1, 4) = '$RO_' then
         begin
          RoleRecherche := Copy(phrase, char + 6, possep1 - 5);
          // Vérifie que le role est dans la liste des roles possible }
          dmGenData.Query4.SQL.Text :=
            'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
            ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
            TypeEvenement + '.no=:idEvent';
          dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
          dmGenData.Query4.Open;
          compte := 0;
          if AnsiPos(RoleRecherche, dmGenData.Query4.Fields[0].AsString) > 0 then
           begin
            if (TypeEvenement = 'N') or (TypeEvenement = 'R') then
              compte := 0;
            if (TypeEvenement = 'E') then
             begin
              dmGenData.Query4.SQL.Text :=
                'SELECT W.I FROM W JOIN E ON W.E=E.no WHERE ' +
                'W.R=''' + RoleRecherche + ''' AND E.no=:idEvent';
              dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
              dmGenData.Query4.Open;
              compte := dmGenData.Query4.RecordCount;
              while not dmGenData.Query4.EOF do
               begin
                if dmGenData.Query4.Fields[0].AsInteger = idIndividual then
                  compte := compte - 1;
                dmGenData.Query4.Next;
               end;
             end;
           end;
         end;
        if Copy(temp, 1, 4) = '$RP_' then
         begin
          RoleRecherche := Copy(phrase, char + 6, possep1 - 5);
          // Vérifie que le role est dans la liste des roles possible }
          dmGenData.Query4.SQL.Text :=
            'SELECT Y.R FROM Y JOIN ' + TypeEvenement +
            ' ON Y.no=' + TypeEvenement + '.Y WHERE ' +
            TypeEvenement + '.no=:idEvent';
          dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
          dmGenData.Query4.Open;
          compte := 0;
          if AnsiPos(RoleRecherche, dmGenData.Query4.Fields[0].AsString) > 0 then
           begin
            if (TypeEvenement = 'N') then
             begin
              // Décompte les parents du idIndividual
              dmGenData.Query4.SQL.Text :=
                'SELECT R.B FROM R WHERE X=1 AND R.A=:idInd';
              dmGenData.Query4.ParamByName('idInd').AsInteger := idIndividual;
              dmGenData.Query4.Open;
              compte := dmGenData.Query4.RecordCount;
             end;
            if (TypeEvenement = 'R') then
             begin
              // Décompte les parents du role
              if RoleRecherche = 'PARENT' then
                dmGenData.Query4.SQL.Text := 'SELECT B FROM R WHERE no=:idEvent'
              else
                dmGenData.Query4.SQL.Text := 'SELECT A FROM R WHERE no=:idEvent';
              dmGenData.Query4.ParamByName('idEvent').AsInteger := Evenement;
              dmGenData.Query4.Open;
              dmGenData.Query3.SQL.Text :=
                'SELECT B FROM R WHERE X=1 AND A=' + dmGenData.Query4.Fields[0].AsString;
              dmGenData.Query3.Open;
              compte := dmGenData.Query3.RecordCount;
             end;
            if (TypeEvenement = 'E') then
             begin
              // Decompte les parents des témoins
              dmGenData.Query4.SQL.Text :=
                'SELECT W.I FROM W JOIN E ON W.E=E.no WHERE ' +
                'W.R=' + RoleRecherche;
              dmGenData.Query4.Open;
              while not dmGenData.Query4.EOF do
               begin
                dmGenData.Query3.SQL.Text :=
                  'SELECT B FROM R WHERE X=1 AND A=' + dmGenData.Query4.Fields[0].AsString;
                dmGenData.Query3.Open;
                compte := compte + dmGenData.Query3.RecordCount;
                dmGenData.Query4.Next;
               end;
             end;
           end;
         end;
        if Copy(temp, 1, 5) = '$ROP_' then
         begin
          // Decompte les parents des autres témoins
          RoleRecherche := Copy(phrase, char + 7, possep1 - 6);
          // Vérifie que le role est dans la liste des roles possible
          lRoles:=GetTypePossibRoles(evenement, TypeEvenement);
          compte := 0;
          if AnsiPos(RoleRecherche, lRoles) > 0 then
           begin
            if (TypeEvenement = 'E') then
             begin
              // Decompte les parents des autres témoins
              with dmGenData.Query4 do begin
Close;
                SQL.Text :=
                  'SELECT W.I FROM W JOIN E ON W.E=E.no WHERE ' +
                  'W.R=:Role AND E.no=:idEvent';
                ParamByName('idEvent').AsInteger := Evenement;
                ParamByName('Role').AsString := RoleRecherche;
                Open;
                while not EOF do
                 begin
                  lidInd := Fields[0].AsInteger;
                  if lidInd <> idIndividual then
                   begin
                    compte:=compte+GetRelationCountOfParents(lidInd);
                   end;
                  Next;
                 end;
              end;
             end;
           end;
         end;
        if (compte = 1) or ((compte > 1) and (possep3 = posend1)) then
          remplace := Copy(phrase, char + 3 + possep2, possep3 - possep2 - 1)
        else
        if compte > 1 then
          remplace := Copy(phrase, char + 3 + possep3, posend1 - possep3 - 1);
        phrase := Copy(phrase, 1, char - 1) + remplace + Copy(
          phrase, char + 4 + posend1, length(phrase));
        phrase := DecodePhraseStemma(idIndividual, role, phrase,
          TypeEvenement, evenement, char);
       end
      else
       begin
        if (char + 1) < length(phrase) then
          phrase := DecodePhraseStemma(idIndividual, role, phrase,
            TypeEvenement, evenement, char + 1);
       end;
     end;
   end;
  DecodePhraseStemma := phrase;
end;


function DecodePhrase(sIndividuum: string; role: string; phrase: string;
  TypeEvenement: string; evenement: string): string;
var
  i: integer;
  idInd, idEvent: longint;
begin
  tryStrToInt(sIndividuum, idInd);
  tryStrToInt(evenement, idEvent);
  if copy(phrase, 1, 4) = '!TMG' then
    DecodePhrase := trim(DecodePhraseTMG(
      idInd, role, copy(phrase, 5, length(phrase)), TypeEvenement, evenement))
  else
   begin
    DecodePhrase := trim(DecodePhraseStemma(idInd, role, phrase, TypeEvenement, idEvent, 1));
   end;
  // Remplace les "  " par " "
  for i := 1 to length(DecodePhrase) - 1 do
    if Copy(DecodePhrase, i, 2) = '  ' then
      DecodePhrase := Copy(DecodePhrase, 1, i) + Copy(
        DecodePhrase, i + 2, length(DecodePhrase));
  if not (Copy(DecodePhrase, length(DecodePhrase), 1) = '.') then
    DecodePhrase := DecodePhrase + '.';
  DecodePhrase := UpperCase(Copy(DecodePhrase, 1, 1)) + Copy(
    DecodePhrase, 2, Length(DecodePhrase));
end;

procedure SaveFormPosition(Sender: TForm);
begin
  dmGenData.WriteCfgFormPosition(Sender);
end;

procedure SaveGridPosition(Sender: TStringGrid; cols: integer);
begin
  dmGenData.WriteCfgGridPosition(Sender, cols);
end;

procedure GetGridPosition(Sender: TStringGrid; cols: integer);
begin
  dmGenData.ReadCfgGridPosition(Sender, cols);
end;

procedure GetFormPosition(Sender: TForm; a: integer; b: integer;
  c: integer; d: integer);
begin
  dmGenData.ReadCfgFormPosition(Sender, a, b, c, d);
end;

procedure SaveModificationTime(no: integer);
begin
  dmGenData.SaveModificationTime(no);
end;

procedure DecodePlace(Place: string;
  out article, detail, sCity, region, Country, State: string);
var
  pos2: integer;
  pos1: integer;
begin
  if copy(Place, 1, 4) = '!TMG' then
   begin
    article := '';
    Place := copy(Place, 5, length(Place));
    detail := copy(Place, 1, AnsiPos('|', Place) - 1);
    Place := copy(Place, AnsiPos('|', Place) + 1, length(Place));
    detail := copy(Place, 1, AnsiPos('|', Place) - 1);
    Place := copy(Place, AnsiPos('|', Place) + 1, length(Place));
    sCity := copy(Place, 1, AnsiPos('|', Place) - 1);
    Place := copy(Place, AnsiPos('|', Place) + 1, length(Place));
    region := copy(Place, 1, AnsiPos('|', Place) - 1);
    Place := copy(Place, AnsiPos('|', Place) + 1, length(Place));
    Country := copy(Place, 1, AnsiPos('|', Place) - 1);
    Place := copy(Place, AnsiPos('|', Place) + 1, length(Place));
    State := copy(Place, 1, AnsiPos('|', Place) - 1);
   end
  else
   begin
    Pos1 := AnsiPos('<' + CTagNameArticle + '>', Place) + Length(CTagNameArticle) + 2;
    Pos2 := AnsiPos('</' + CTagNameArticle + '>', Place);
    if (Pos1 + Pos2) > 9 then
      Article := Copy(Place, Pos1, Pos2 - Pos1)
    else
      Article := '';
    Pos1 := AnsiPos('<' + CTagNameDetail + '>', Place) + (Length(CTagNameDetail) + 2);
    Pos2 := AnsiPos('</' + CTagNameDetail + '>', Place);
    if (Pos1 + Pos2) > 9 then
      Detail := Copy(Place, Pos1, Pos2 - Pos1)
    else
      Detail := '';
    Pos1 := AnsiPos('<' + CTagNamePlace + '>', Place) + 7;
    Pos2 := AnsiPos('</' + CTagNamePlace + '>', Place);
    if (Pos1 + Pos2) > 7 then
      sCity := Copy(Place, Pos1, Pos2 - Pos1)
    else
      sCity := '';
    Pos1 := AnsiPos('<' + CTagNameRegion + '>', Place) + 9;
    Pos2 := AnsiPos('</' + CTagNameRegion + '>', Place);
    if (Pos1 + Pos2) > 9 then
      Region := Copy(Place, Pos1, Pos2 - Pos1)
    else
      Region := '';
    Pos1 := AnsiPos('<' + CTagNameCountry + '>', Place) + 10;
    Pos2 := AnsiPos('</' + CTagNameCountry + '>', Place);
    if (Pos1 + Pos2) > 10 then
      Country := Copy(Place, Pos1, Pos2 - Pos1)
    else
      Country := '';
    Pos1 := AnsiPos('<' + CTagNameState + '>', Place) + 6;
    Pos2 := AnsiPos('</' + CTagNameState + '>', Place);
    if (Pos1 + Pos2) > 6 then
      State := Copy(Place, Pos1, Pos2 - Pos1)
    else
      State := '';
   end;
end;

function DecodeChanged(Place: string): string;
var
  lArticle, lDetails, lPlace, lRegion, lCountry, lState: string;
begin
  DecodePlace(Place, lArticle, lDetails, lPlace, lRegion, lCountry, lState);
  if length(lDetails) = 0 then
    Place := trim(lArticle + ' ' + lPlace + ', ' + lRegion + ', ' + lCountry + ', ' + lState)
  else
    Place := trim(lArticle + ' ' + lDetails + ', ' + lPlace + ', ' + lRegion + ', ' + lCountry + ', ' + lState);
  while (AnsiPos(', , ', Place) > 0) do
   begin
    Place := copy(Place, 1, AnsiPos(', , ', Place) - 1) + copy(
      Place, AnsiPos(', , ', Place) + 2, length(Place));
   end;
  if copy(Place, length(Place), 1) = ',' then
    Place := copy(Place, 1, length(Place) - 1);
  if copy(Place, 1, 2) = ', ' then
    Place := copy(Place, 3, length(Place));
  DecodeChanged := Place;
end;

function RemoveUTF8(Text: string): string;
begin
  Text := AnsiReplaceStr(Text, 'å', 'a');
  Text := AnsiReplaceStr(Text, 'á', 'a');
  Text := AnsiReplaceStr(Text, 'à', 'a');
  Text := AnsiReplaceStr(Text, 'â', 'a');
  Text := AnsiReplaceStr(Text, 'ä', 'a');
  Text := AnsiReplaceStr(Text, 'ç', 'c');
  Text := AnsiReplaceStr(Text, 'é', 'e');
  Text := AnsiReplaceStr(Text, 'è', 'e');
  Text := AnsiReplaceStr(Text, 'ê', 'e');
  Text := AnsiReplaceStr(Text, 'ë', 'e');
  Text := AnsiReplaceStr(Text, 'ì', 'i');
  Text := AnsiReplaceStr(Text, 'ï', 'i');
  Text := AnsiReplaceStr(Text, 'î', 'i');
  Text := AnsiReplaceStr(Text, 'ò', 'o');
  Text := AnsiReplaceStr(Text, 'ö', 'o');
  Text := AnsiReplaceStr(Text, 'ô', 'o');
  Text := AnsiReplaceStr(Text, 'ø', 'o');
  Text := AnsiReplaceStr(Text, 'ù', 'u');
  Text := AnsiReplaceStr(Text, 'û', 'u');
  Text := AnsiReplaceStr(Text, 'ü', 'u');
  Text := AnsiReplaceStr(Text, 'ÿ', 'y');
  Text := AnsiReplaceStr(Text, 'ý', 'y');
  Text := AnsiReplaceStr(Text, 'ž', 'z');
  Text := AnsiReplaceStr(Text, 'Å', 'A');
  Text := AnsiReplaceStr(Text, 'Á', 'A');
  Text := AnsiReplaceStr(Text, 'À', 'A');
  Text := AnsiReplaceStr(Text, 'Â', 'A');
  Text := AnsiReplaceStr(Text, 'Ä', 'A');
  Text := AnsiReplaceStr(Text, 'Æ', 'AE');
  Text := AnsiReplaceStr(Text, 'Ç', 'C');
  Text := AnsiReplaceStr(Text, 'É', 'E');
  Text := AnsiReplaceStr(Text, 'È', 'E');
  Text := AnsiReplaceStr(Text, 'Ê', 'E');
  Text := AnsiReplaceStr(Text, 'Ë', 'E');
  Text := AnsiReplaceStr(Text, 'Ì', 'I');
  Text := AnsiReplaceStr(Text, 'Ï', 'I');
  Text := AnsiReplaceStr(Text, 'Î', 'I');
  Text := AnsiReplaceStr(Text, 'Ò', 'O');
  Text := AnsiReplaceStr(Text, 'Ö', 'O');
  Text := AnsiReplaceStr(Text, 'Ô', 'O');
  Text := AnsiReplaceStr(Text, 'Ù', 'U');
  Text := AnsiReplaceStr(Text, 'Û', 'U');
  Text := AnsiReplaceStr(Text, 'Ü', 'U');
  Text := AnsiReplaceStr(Text, 'Š', 'S');
  Text := AnsiReplaceStr(Text, 'Ž', 'Z');
  RemoveUTF8 := Text;
end;

function ConvertDate(Date: string; format: byte): string;
var
  lsTemp1, lsTemp2, lYear1, lYear2, lMonth1, lMonth2, lDay1, lDay2: string;
  liType1, liType2, liStyle: integer;
begin
  if copy(Date, 1, 1) <> '1' then
    ConvertDate := Copy(Date, 2, length(Date))
  else
   begin
    lYear1 := copy(Date, 2, 4);
    lMonth1 := copy(Date, 6, 2);
    lDay1 := copy(Date, 8, 2);
    lYear2 := copy(Date, 12, 4);
    lMonth2 := copy(Date, 16, 2);
    lDay2 := copy(Date, 18, 2);
    tryStrToInt(copy(Date, 11, 1), liStyle);
    liType1 := 0;
    liType2 := 0;
    if ((lMonth1 = '00') and (lDay1 = '00')) then
      liType1 := 1
    else    // annee seulement
    if ((lYear1 = '0000') and (lDay1 = '00')) then
      liType1 := 2
    else // mois seulement
    if ((lMonth1 = '00') and (lYear1 = '0000')) then
      liType1 := 3
    else // jour seulement
    if (lDay1 = '00') then
      liType1 := 4
    else                       // manque jour seulement
    if (lMonth1 = '00') then
      liType1 := 5
    else                       // manque mois seulement
    if (lYear1 = '0000') then
      liType1 := 6;                        // manque annee seulement
    if ((lMonth2 = '00') and (lDay2 = '00')) then
      liType2 := 1
    else    // annee seulement
    if ((lYear2 = '0000') and (lDay2 = '00')) then
      liType2 := 2
    else // mois seulement
    if ((lMonth2 = '00') and (lYear2 = '0000')) then
      liType2 := 3
    else // jour seulement
    if (lDay2 = '00') then
      liType2 := 4
    else                       // manque jour seulement
    if (lMonth2 = '00') then
      liType2 := 5
    else                       // manque mois seulement
    if (lYear2 = '0000') then
      liType2 := 6;                        // manque annee seulement
    if Copy(Date, 1, 21) = '100000000030000000000' then
      ConvertDate := ''
    else
     begin
      if format = 0 then
       begin
        lDay1 := IntToStr(StrToInt(lDay1));
        lDay2 := IntToStr(StrToInt(lDay2));
        lYear1 := IntToStr(StrToInt(lYear1));
        lYear2 := IntToStr(StrToInt(lYear2));
        if StrToInt(lDay1) = 1 then
          lDay1 := Translation.Items[74];
        if StrToInt(lDay2) = 1 then
          lDay2 := Translation.Items[74];
        case StrToInt(lMonth1) of
          1: lMonth1 := Translation.Items[75];
          2: lMonth1 := Translation.Items[76];
          3: lMonth1 := Translation.Items[77];
          4: lMonth1 := Translation.Items[78];
          5: lMonth1 := Translation.Items[79];
          6: lMonth1 := Translation.Items[80];
          7: lMonth1 := Translation.Items[81];
          8: lMonth1 := Translation.Items[82];
          9: lMonth1 := Translation.Items[83];
          10: lMonth1 := Translation.Items[84];
          11: lMonth1 := Translation.Items[85];
          12: lMonth1 := Translation.Items[86];
         end;
        case StrToInt(lMonth2) of
          1: lMonth2 := Translation.Items[75];
          2: lMonth2 := Translation.Items[76];
          3: lMonth2 := Translation.Items[77];
          4: lMonth2 := Translation.Items[78];
          5: lMonth2 := Translation.Items[79];
          6: lMonth2 := Translation.Items[80];
          7: lMonth2 := Translation.Items[81];
          8: lMonth2 := Translation.Items[82];
          9: lMonth2 := Translation.Items[83];
          10: lMonth2 := Translation.Items[84];
          11: lMonth2 := Translation.Items[85];
          12: lMonth2 := Translation.Items[86];
         end;
        case liStyle of
          0: case liType1 of
              0: ConvertDate := rsDateBeforeThe + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: ConvertDate := Translation.Items[88] + lYear1;
              2: ConvertDate := Translation.Items[88] + lMonth1;
              3: ConvertDate := Translation.Items[89] + lDay1;
              4: ConvertDate := Translation.Items[88] + lMonth1 + ' ' + lYear1;
              5: ConvertDate := Translation.Items[89] + lDay1 +
                  Translation.Items[90] + lYear1;
              6: ConvertDate := Translation.Items[89] + lDay1 + ' ' + lMonth1;
             end;
          1: case liType1 of
              0: ConvertDate := Translation.Items[91] + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: ConvertDate := Translation.Items[92] + lYear1;
              2: ConvertDate := Translation.Items[92] + lMonth1;
              3: ConvertDate := Translation.Items[93] + lDay1;
              4: ConvertDate := Translation.Items[92] + lMonth1 + ' ' + lYear1;
              5: ConvertDate :=
                  Translation.Items[93] + lDay1 + Translation.Items[90] + lYear1;
              6: ConvertDate := Translation.Items[93] + lDay1 + ' ' + lMonth1;
             end;
          2: case liType1 of
              0: ConvertDate := Translation.Items[91] + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: ConvertDate := Translation.Items[92] + lYear1;
              2: ConvertDate := Translation.Items[92] + lMonth1;
              3: ConvertDate := Translation.Items[93] + lDay1;
              4: ConvertDate := Translation.Items[92] + lMonth1 + ' ' + lYear1;
              5: ConvertDate :=
                  Translation.Items[93] + lDay1 + Translation.Items[90] + lYear1;
              6: ConvertDate := Translation.Items[93] + lDay1 + ' ' + lMonth1;
             end;
          3: case liType1 of
              0: ConvertDate := Translation.Items[94] + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: ConvertDate := Translation.Items[95] + lYear1;
              2: ConvertDate := Translation.Items[95] + lMonth1;
              3: ConvertDate := Translation.Items[96] + lDay1;
              4: ConvertDate := Translation.Items[95] + lMonth1 + ' ' + lYear1;
              5: ConvertDate :=
                  Translation.Items[96] + lDay1 + Translation.Items[90] + lYear1;
              6: ConvertDate := Translation.Items[96] + lDay1 + ' ' + lMonth1;
             end;
          4: case liType1 of
              0: ConvertDate := Translation.Items[97] + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: ConvertDate := Translation.Items[98] + lYear1;
              2: ConvertDate := Translation.Items[98] + lMonth1;
              3: ConvertDate := Translation.Items[99] + lDay1;
              4: ConvertDate := Translation.Items[98] + lMonth1 + ' ' + lYear1;
              5: ConvertDate :=
                  Translation.Items[99] + lDay1 + Translation.Items[90] + lYear1;
              6: ConvertDate := Translation.Items[99] + lDay1 + ' ' + lMonth1;
             end;
          5:
           begin
            case liType1 of
              0: lsTemp1 := Translation.Items[100] + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: lsTemp1 := Translation.Items[101] + lYear1;
              2: lsTemp1 := Translation.Items[101] + lMonth1;
              3: lsTemp1 := Translation.Items[102] + lDay1;
              4: lsTemp1 := Translation.Items[101] + lMonth1 + ' ' + lYear1;
              5: lsTemp1 := Translation.Items[102] + lDay1 + Translation.Items[90] + lYear1;
              6: lsTemp1 := Translation.Items[102] + lDay1 + ' ' + lMonth1;
             end;
            case liType2 of
              0: ConvertDate :=
                  lsTemp1 + Translation.Items[103] + lDay2 + ' ' + lMonth2 + ' ' + lYear2;
              1: ConvertDate := lsTemp1 + Translation.Items[72] + lYear2;
              2: ConvertDate := lsTemp1 + Translation.Items[72] + lMonth2;
              3: ConvertDate := lsTemp1 + Translation.Items[104] + lDay2;
              4: ConvertDate := lsTemp1 + Translation.Items[72] + lMonth2 + ' ' + lYear2;
              5: ConvertDate :=
                  lsTemp1 + Translation.Items[104] + lDay2 + Translation.Items[90] + lYear2;
              6: ConvertDate := lsTemp1 + Translation.Items[104] + lDay2 + ' ' + lMonth2;
             end;
           end;
          6:
           begin
            case liType1 of
              0: lsTemp1 := Translation.Items[94] + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: lsTemp1 := Translation.Items[95] + lYear1;
              2: lsTemp1 := Translation.Items[95] + lMonth1;
              3: lsTemp1 := Translation.Items[96] + lDay1;
              4: lsTemp1 := Translation.Items[95] + lMonth1 + ' ' + lYear1;
              5: lsTemp1 := Translation.Items[96] + lDay1 + Translation.Items[90] + lYear1;
              6: lsTemp1 := Translation.Items[96] + lDay1 + ' ' + lMonth1;
             end;
            case liType2 of
              0: ConvertDate :=
                  lsTemp1 + Translation.Items[105] + lDay2 + ' ' + lMonth2 + ' ' + lYear2;
              1: ConvertDate := lsTemp1 + Translation.Items[106] + lYear2;
              2: ConvertDate := lsTemp1 + Translation.Items[106] + lMonth2;
              3: ConvertDate := lsTemp1 + Translation.Items[107] + lDay2;
              4: ConvertDate := lsTemp1 + Translation.Items[106] + lMonth2 + ' ' + lYear2;
              5: ConvertDate :=
                  lsTemp1 + Translation.Items[107] + lDay2 + Translation.Items[90] + lYear2;
              6: ConvertDate := lsTemp1 + Translation.Items[107] + lDay2 + ' ' + lMonth2;
             end;
           end;
          7:
           begin
            case liType1 of
              0: lsTemp1 := Translation.Items[108] + lDay1 + ' ' + lMonth1 + ' ' + lYear1;
              1: lsTemp1 := Translation.Items[109] + lYear1;
              2: lsTemp1 := Translation.Items[109] + lMonth1;
              3: lsTemp1 := Translation.Items[110] + lDay1;
              4: lsTemp1 := Translation.Items[109] + lMonth1 + ' ' + lYear1;
              5: lsTemp1 := Translation.Items[110] + lDay1 + Translation.Items[90] + lYear1;
              6: lsTemp1 := Translation.Items[110] + lDay1 + ' ' + lMonth1;
             end;
            case liType2 of
              0: ConvertDate :=
                  lsTemp1 + Translation.Items[111] + lDay2 + ' ' + lMonth2 + ' ' + lYear2;
              1: ConvertDate := lsTemp1 + Translation.Items[112] + lYear2;
              2: ConvertDate := lsTemp1 + Translation.Items[112] + lMonth2;
              3: ConvertDate := lsTemp1 + Translation.Items[113] + lDay2;
              4: ConvertDate := lsTemp1 + Translation.Items[112] + lMonth2 + ' ' + lYear2;
              5: ConvertDate :=
                  lsTemp1 + Translation.Items[113] + lDay2 + Translation.Items[90] + lYear2;
              6: ConvertDate := lsTemp1 + Translation.Items[113] + lDay2 + ' ' + lMonth2;
             end;
           end;
         end;
       end
      else
       begin
        case liType1 of
          0: lsTemp1 := lYear1 + '/' + lMonth1 + '/' + lDay1;
          1: lsTemp1 := lYear1;
          2: lsTemp1 := '.../' + lMonth1 + '/...';
          3: lsTemp1 := '.../.../' + lDay1;
          4: lsTemp1 := lYear1 + '/' + lMonth1 + '/...';
          5: lsTemp1 := lYear1 + '/.../' + lDay1;
          6: lsTemp1 := '.../' + lMonth1 + '/' + lDay1;
         end;
        case liType2 of
          0: lsTemp2 := lYear2 + '/' + lMonth2 + '/' + lDay2;
          1: lsTemp2 := lYear2;
          2: lsTemp2 := '.../' + lMonth2 + '/...';
          3: lsTemp2 := '.../.../' + lDay2;
          4: lsTemp2 := lYear2 + '/' + lMonth2 + '/...';
          5: lsTemp2 := lYear2 + '/.../' + lDay2;
          6: lsTemp2 := '.../' + lMonth2 + '/' + lDay2;
         end;
        case liStyle of
          0: ConvertDate := '<' + lsTemp1;
          1: ConvertDate := Translation.Items[114] + lsTemp1;
          2: ConvertDate := Translation.Items[114] + lsTemp1;
          3: ConvertDate := lsTemp1;
          4: ConvertDate := '>' + lsTemp1;
          5: ConvertDate := lsTemp1 + ' - ' + lsTemp2;
          6: ConvertDate := lsTemp1 + Translation.Items[115] + lsTemp2;
          7: ConvertDate := lsTemp1 + Translation.Items[112] + lsTemp2;
         end;
       end;
     end;
   end;
end;

procedure PopulateCitations(Tableau: TStringGrid; Code: string; Nstr: string);
var
  no: longint;
begin
  if trystrtoint(Nstr, no) then
    dmGenData.PopulateCitations(Tableau, code, no);
end;

function DecodeName(Name: string; format: byte): string;
var
  titre, prenom, nom, suffixe, temp, nomcomplet: string;
  Pos1, Pos2: integer;
begin
  nomcomplet := '';
  temp := Name;
  titre := '';
  prenom := '';
  nom := '';
  suffixe := '';
  if copy(Name, 1, 5) = '!TMG|' then
   begin
    temp := copy(temp, 6, length(temp));
    nom := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
    temp := copy(temp, AnsiPos('|', temp) + 1, length(temp));
    titre := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
    temp := copy(temp, AnsiPos('|', temp) + 1, length(temp));
    prenom := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
    temp := copy(temp, AnsiPos('|', temp) + 1, length(temp));
    suffixe := trim(copy(temp, 1, AnsiPos('|', temp) - 1));
   end
  else
   begin
    // Traiter les noms avec <N=TITRE></N>...
    Pos1 := AnsiPos('<' + CTagNameTitle + '>', temp) + length(CTagNameTitle) + 2;
    Pos2 := AnsiPos('</' + CTagNameTitle + '>', temp);
    if (Pos1 + Pos2) > length(CTagNameTitle) + 2 then
      titre := Copy(temp, Pos1, Pos2 - Pos1);
    Pos1 := AnsiPos('<' + CTagNameGivenName + '>', temp) + length(CTagNameGivenName) + 2;
    // 9 car le 'é' prends 2 position en ANSI
    Pos2 := AnsiPos('</' + CTagNameGivenName + '>', temp);
    if (Pos1 + Pos2) > length(CTagNameGivenName) + 2 then
      prenom := Copy(temp, Pos1, Pos2 - Pos1);
    Pos1 := AnsiPos('<' + CTagNameFamilyName + '>', temp) + length(CTagNameFamilyName) + 2;
    Pos2 := AnsiPos('</' + CTagNameFamilyName + '>', temp);
    if (Pos1 + Pos2) > length(CTagNameFamilyName) + 2 then
      nom := Copy(temp, Pos1, Pos2 - Pos1);
    Pos1 := AnsiPos('<' + CTagNameSuffix + '>', temp) + length(CTagNameSuffix) + 2;
    Pos2 := AnsiPos('</' + CTagNameSuffix + '>', temp);
    if (Pos1 + Pos2) > length(CTagNameSuffix) + 2 then
      Suffixe := Copy(temp, Pos1, Pos2 - Pos1);
   end;
  if format = 1 then
   begin
    if length(titre) > 0 then
      nomcomplet := titre;
    if length(prenom) > 0 then
      if length(nomcomplet) = 0 then
        nomcomplet := prenom
      else
        nomcomplet := nomcomplet + ' ' + prenom;
    if length(nom) > 0 then
      if length(nomcomplet) = 0 then
        nomcomplet := nom
      else
        nomcomplet := nomcomplet + ' ' + nom;
    if length(suffixe) > 0 then
      if length(nomcomplet) = 0 then
        nomcomplet := suffixe
      else
        nomcomplet := nomcomplet + ' ' + suffixe;
   end;
  if format = 2 then
   begin
    if length(nom) > 0 then
      nomcomplet := nom;
    if length(suffixe) > 0 then
      if length(nomcomplet) = 0 then
        nomcomplet := suffixe
      else
        nomcomplet := nomcomplet + ' ' + suffixe;
    if length(prenom) > 0 then
      if length(prenom) = 0 then
        nomcomplet := ', ' + prenom
      else
        nomcomplet := nomcomplet + ', ' + prenom;
    if length(titre) > 0 then
      if length(nomcomplet) = 0 then
        nomcomplet := '(' + titre + ')'
      else
        nomcomplet := nomcomplet + ' (' + titre + ')';
   end;
  if length(nomcomplet) = 0 then
    nomcomplet := '???';
  Result := nomcomplet;
end;

function GetTableColWidthSum(const lTable: TStringGrid;
  const lIgnCol: integer): integer;
var
  lMaxTblSize, i: integer;
begin
  lMaxTblSize := 0;
  for i := 0 to lTable.Columns.Count - 1 do
    if i <> lIgnCol then
      lMaxTblSize := lMaxTblSize + lTable.Columns[i].Width;
  Result := lMaxTblSize;
end;

end.
