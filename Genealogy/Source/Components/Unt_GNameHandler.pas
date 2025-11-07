unit Unt_GNameHandler;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils;
  
{
  /////////////////////////////////////////////////////////////////////////////
  //  Unit: Unt_GNameHandler
  //  Zweck:
  //    Verwaltung und Heuristik für Vornamen/Geburtsnamen zur Geschlecht-\
  //    Erkennung (M/F) inkl. optionalem automatischen Lernen unbekannter Namen.
  //  Funktionen:
  //    * Laden / Speichern einer Namensliste (Name=Schlüssel, Value=Geschlechts-Code)
  //    * Erraten des Geschlechts anhand des ersten bekannten Namensbestandteils
  //    * Lernen einzelner Namensbestandteile (validiert und normalisiert eingeschränkt)
  //  Geschlechts-Codes:
  //    'M' = männlich, 'F' = weiblich, '_' = unbekannt (gelernt), 'U' = unbekannt (Rückgabe Guess)
  //  Hinweise:
  //    * Keine Thread-Sicherheit
  //    * Persistenz erfolgt über komplette Neuschreibung der Datei
  //    * Klein geschriebene Anfangsbuchstaben werden als Fehler gemeldet
  //    * Sehr kurze oder abgekürzte Namen / Marker werden ignoriert
  /////////////////////////////////////////////////////////////////////////////
}

type

{ TGNameHandler }
 /// <summary>
 ///   Callback-Typ für Meldungen (Fehler, Warnungen, Hinweise).
 /// </summary>
 /// <param name="Msg">Nachrichtentext.</param>
 /// <param name="aType">Typ/Kategorie (0 = Standard / Fehlerhinweis).</param>
 TSendMsg = Procedure(Msg:String;aType:integer) of object;

 /// <summary>
 ///   Record, der eine sortierte Liste von Vornamen mit Geschlechts-Code verwaltet
 ///   und Routinen zum Laden, Speichern, Lernen und Raten des Geschlechts bereitstellt.
 /// </summary>
 /// <remarks>
 ///   Nutzung:
 ///   <code>
 ///     var H: TGNameHandler;
 ///     H.Init;
 ///     try
 ///       H.LoadGNameList('names.sex');
 ///       writeln(H.GuessSexOfGivnName('Anna'));
 ///       H.LearnSexOfGivnName('Kilian','M');
 ///       H.SaveGNameList;
 ///     finally
 ///       H.Done;
 ///     end;
 ///   </code>
 /// </remarks>
 /// <threadsafety>Nicht thread-sicher.</threadsafety>
 TGNameHandler=record
     private
       /// <summary>
       ///   Steuert, ob unbekannte Namen beim Raten automatisch als '_' gelernt werden.
       /// </summary>
       FcfgLearnUnknown: boolean ;
       /// <summary>
       ///   Zuletzt verwendeter Dateiname für Persistenz der Liste.
       /// </summary>
       FGNameFile: string;
       /// <summary>
       ///   Dirty-Flag: True, wenn seit letztem Speichern Änderungen vorliegen.
       /// </summary>
       FGNameListChanged: boolean;
       /// <summary>
       ///   Sortierte Stringliste (Name als Key, Geschlecht als Value).
       /// </summary>
       FGNameList: TStringList;
       /// <summary>
       ///   Optionaler Meldungs-/Fehler-Callback.
       /// </summary>
       FonError: TSendMsg;
       /// <summary>
       ///   Setter für cfgLearnUnknown mit Guard.
       /// </summary>
       procedure SetcfgLearnUnknown(AValue: boolean);
       /// <summary>
       ///   Setter für Changed mit Guard.
       /// </summary>
       procedure SetChanged(const AValue: boolean);
       /// <summary>
       ///   Setter für onError Callback (verhindert unnötige Zuweisung bei Gleichheit).
       /// </summary>
       procedure SetonError(AValue: TSendMsg);

     public
        /// <summary>
        ///   Initialisiert interne Datenstrukturen (erzeugt TStringList, setzt Defaults).
        /// </summary>
        Procedure Init;
        /// <summary>
        ///   Gibt Ressourcen frei und speichert – falls geändert – die Namensliste.
        /// </summary>
        Procedure Done;
        /// <summary>
        ///   Lädt eine vorhandene Namensliste oder leert sie, falls Datei fehlt.
        /// </summary>
        /// <param name="aFilename">Zieldatei.</param>
        procedure LoadGNameList(aFilename: string);
        /// <summary>
        ///   Speichert die Namensliste in angegebene oder zuletzt gesetzte Datei.
        /// </summary>
        /// <param name="aFilename">Optionaler Dateiname (überschreibt vorhandenen).</param>
        procedure SaveGNameList(aFilename: string = '');
        /// <summary>
        ///   Setzt nur den Dateinamen ohne sofortiges Speichern.
        /// </summary>
        /// <param name="aFilename">Neuer Dateiname.</param>
        procedure SetGNLFilename(aFilename: string = '');
        /// <summary>
        ///   Lernt das Geschlecht für alle gültigen Teile eines Namenseingabe-Strings.
        /// </summary>
        /// <param name="aName">Kompletter Name (kann Leerzeichen enthalten).</param>
        /// <param name="aSex">Geschlechts-Code (z.B. 'M','F','_').</param>
        procedure LearnSexOfGivnName(aName: string; aSex: char);
        /// <summary>
        ///   Errät das Geschlecht; liefert erstes bekanntes (nicht '_'), sonst 'U'.
        ///   Optionales Lernen unbekannter Teile (cfgLearnUnknown & bLearn).
        /// </summary>
        /// <param name="aName">Name, der analysiert wird.</param>
        /// <param name="bLearn">Ob unbekannte Namen gelernt werden dürfen.</param>
        /// <returns>'M','F' oder 'U'.</returns>
        function GuessSexOfGivnName(aName: string; bLearn: boolean = True): char;

        /// <summary>
        ///   Meldungs-/Fehler-Callback.
        /// </summary>
        property onError:TSendMsg read FonError write SetonError;
        /// <summary>
        ///   Aktiviert automatisches Lernen unbekannter Namen (als '_').
        /// </summary>
        property cfgLearnUnknown:boolean read FcfgLearnUnknown write SetcfgLearnUnknown;
        /// <summary>
        ///   Kennzeichnet, ob Änderungen an der Namensliste erfolgt sind.
        /// </summary>
        Property Changed:boolean read FGNameListChanged write SetChanged;
 end;

Const
    /// <summary>
    ///   Unicode-Ellipse als Platzhalter / unbekannter Name.
    /// </summary>
    csUnknown = '…';
    /// <summary>
    ///   ASCII-Ellipse als alternativer Platzhalter / unbekannter Name.
    /// </summary>
    csUnknown2 = '...';

implementation

uses Unt_FileProcs;

(* Maybe put to unt_StringProcs *)
/// <summary>
///   Prüft, ob der Text ab Position pPos exakt aTest entspricht.
/// </summary>
function TestFor(const aText: string; pPos: int64;
  const aTest: string): boolean; overload;
begin
    Result := copy(aText, pPos, length(aTest)) = aTest;
end;

/// <summary>
///   Prüft nacheinander mehrere Kandidaten (aTest-Array) und liefert bei Treffer
///   True sowie den Index über Found.
/// </summary>
function TestFor(const aText: string; pPos: int64;
    const aTest: array of string; out Found: integer): boolean; overload;
var
    i: integer;
begin
    Found := -1;
    Result := False;
    for i := 0 to high(Atest) do
        if TestFor(aText, ppos, atest[i]) then
          begin
            Found := i;
            exit(True);
          end;
end;

/// <summary>
///   Wie die überladene Variante mit Found, verwirft jedoch den Index.
/// </summary>
function TestFor(const aText: string; pPos: int64;
    const aTest: array of string): boolean; overload;
var
    lFound: integer;
begin
    Result := TestFor(aText, ppos, atest, lFound);
end;

{ TGNameHandler }

/// <summary>
///   Setzt Callback für Fehler-/Hinweismeldungen (mit Guard gegen identische Zuweisung).
/// </summary>
procedure TGNameHandler.SetonError(AValue: TSendMsg);
begin
  if @FonError=@AValue then Exit;
  FonError:=AValue;
end;

/// <summary>
///   Initialisiert die interne Namensliste sowie Standard-Konfiguration.
/// </summary>
procedure TGNameHandler.Init;
begin
   FGNameList:=TStringList.Create;
   FGNameList.Sorted := True;
   FcfgLearnUnknown:=True;
   FGNameListChanged:=false;
end;

/// <summary>
///   Speichert (falls geändert) und gibt dann die Ressourcen frei.
/// </summary>
procedure TGNameHandler.Done;
begin
  if FGNameListChanged and (FGNameFile <> '') then
    begin
      if FileExists(FGNameFile) then
          DeleteFile(FGNameFile);
      FGNameList.SaveToFile(FGNameFile);
    end;
  freeandnil(FGNameList);
end;

/// <summary>
///   Konfiguriert automatisches Lernen unbekannter Namen.
/// </summary>
procedure TGNameHandler.SetcfgLearnUnknown(AValue: boolean);
begin
  if FcfgLearnUnknown=AValue then Exit;
  FcfgLearnUnknown:=AValue;
end;

/// <summary>
///   Setzt Dirty-Flag Changed (guarded).
/// </summary>
procedure TGNameHandler.SetChanged(const AValue: boolean);
begin
  if FGNameListChanged=AValue then Exit;
  FGNameListChanged:=AValue;
end;

/// <summary>
///   Lädt eine Namensliste aus Datei oder leert sie, wenn Datei fehlt.
/// </summary>
procedure TGNameHandler.LoadGNameList(aFilename: string);
begin
     if FileExists(aFilename) then
        FGNameList.LoadFromFile(aFilename)
    else
        FGNameList.Clear; // Todo: Load Defaults
    FGNameFile := aFilename;
    FGNameListChanged := False;
end;

/// <summary>
///   Speichert aktuelle Liste in angegebene oder bestehende Datei mittels Wrapper SaveFile.
/// </summary>
procedure TGNameHandler.SaveGNameList(aFilename: string);

begin
    if (aFilename = '') and (FGNameFile = '') then
        exit;
    if aFilename <> '' then
        FGNameFile := aFilename;
    SaveFile(FGNameList.SaveToFile,FGNameFile);
    FGNameListChanged := False;
end;

/// <summary>
///   Setzt nur Dateinamen für späteres Speichern (kein sofortiger Persistenzvorgang).
/// </summary>
procedure TGNameHandler.SetGNLFilename(aFilename: string);
begin
    if (aFilename = '') and (FGNameFile = '') then
        exit;
    if aFilename <> '' then
        FGNameFile := aFilename;
end;

/// <summary>
///   Lernt (validierte) Namensbestandteile mit angegebenem Geschlechts-Code.
///   Ignoriert Initialen, Platzhalter, zu kurze oder unzulässige Fragmente.
/// </summary>
procedure TGNameHandler.LearnSexOfGivnName(aName: string; aSex: char);
var
    lName: string;
begin
    {$if FPC_FULLVERSION = 30200 }
    {$Warning 'Split produces wrong results in 3.2.0' }
    {$ENDIF}
    for lName in aName.split([' ']) do
        if (length(lName) = 2) and lname.EndsWith('.') and (lName[1] in ['A'..'Z']) then
            Continue // Ignoriere abgekürzte Namen
        else
        if testfor(lName, 1, [csUnknown, csUnknown2]) then
            Continue // Ignoriere abgekürzte Namen
        else
        if ((length(lName) < 3) and (uppercase(lName) <> 'NN')) or
            lname.EndsWith('.') or lname.EndsWith('=') then
          begin
            if (lName <>'') and assigned(FonError) then
               FonError('"' + lName + '" is not a valid Name',0);
          end
        else
        if (length(lName) > 1) and (lName[1] in ['a'..'z']) then
          begin
            if (lName <>'') and assigned(FonError) then
              FonError('"' + lName + '" is not a valid Name (case)',0)
          end
        else
        if (lName <> '') and (copy(lName, 1, 1) <> '(') and
            (copy(lName, 1, 1) <> '"') and
            ((FGNameList.Values[lName] = '') or
            (FGNameList.Values[lName] = '_')) then
          begin
            FGNameList.Sorted := False;
            FGNameList.Values[lName] := aSex;
            FGNameList.Sorted := True;
            FGNameListChanged := True;
          end
        else
        if (copy(lName, 1, 1) <> '(') then
            break;
end;

/// <summary>
///   Errät Geschlecht aus Namensbestandteilen. Gibt bei erstem passenden Eintrag dessen
///   Code zurück; lernt optional unbekannte Bestandteile als '_'. Rückgabe 'U' wenn nichts
///   gefunden.
/// </summary>
function TGNameHandler.GuessSexOfGivnName(aName: string; bLearn: boolean): char;
var
    lName: string;
begin
    Result := 'U';
    {$if FPC_FULLVERSION = 30200 }
    {$Warning 'Split produces wrong results in 3.2.0' }
    {$ENDIF}
    for lName in aName.split([' ']) do
      begin
        if (length(lName) = 2) and lname.EndsWith('.') and (lName[1] in ['A'..'Z']) then
            Continue  // Ignoriere abgekürzte Namen
        else
        if ((length(lName) < 3) and (uppercase(lName) <> 'NN')) or
            lname.EndsWith('.') or lname.EndsWith('=') then
          begin
            if (lName <>'')
                and bLearn
                and assigned(FonError) then
               FonError('"' + lName + '" is not a valid Name',0);
          end
        else
        if (copy(lName, 1, 1) <> '(') and (copy(lName, 1, 1) <> '"') and
            (FGNameList.Values[lName] <> '') and
            (FGNameList.Values[lName] <> '_') then
            exit(FGNameList.Values[lName][1])
        else
        if FcfgLearnUnknown and bLearn then
            LearnSexOfGivnName(lName, '_');
      end;
end;

end.

