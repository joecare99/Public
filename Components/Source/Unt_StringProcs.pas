Unit Unt_StringProcs;

{$i jedi.inc}

{*V 2.30.00}
{*H 2.29.00 Zerlegung von Charset in Upper- und LowerCharset }
{*H 2.28.00 Umwandlungsfunktion: AoS2TArrayOfString }
{*H 2.27.00 Anpassungen an FPC, teilw. Unterstützung für int64, StrReplace behandlung}
{*H 2.26.00 Anpassungen an D_XE (VER220) include von jedi.inc}
{*H 2.25.00 Anpassungen an D2k9 (VER200)}
{*H 2.24.00 ExtractTextBetween}
{*H 2.23.00 Left und Right funktionen erweitert: Negative Anzahlen bed. length(s)-count }
{*H 2.22.00 Vollstaendige deklaration der Proceduren und Funktionen in Impl.
            Together-Model-Unterstuetzung}
{*H 2.21 2 weitere Zeichen fuer AscII2ANSI }
{*H 2.20 Str2QHtml }
{*H 2.19 TryFunctionMatching & BuildStringByFunction mit # als Nummernkenner }
{*H 2.18 SatzZeichenErw & Sonstiges }
{*H 2.17 ParseStr mit TStrings & Classes ? ! }
{*H 2.16 ParseStrAsProfile DatAsAtr:=Datum ... }
{*H 2.15 BuildStringByFunction}
{*H 2.14 ascii2ansi u.u. in Char-Ausfuehrung }
{*H 2.13 PutStrasProfile Korrigiert }
{*H 2.12 GetLastSepBy Korrigiert }
{*H 2.11.1 VararraybyLineSep KeepQuote korrigiert mit inner FullQuote }
{*H 2.11 Rueckgabewerte in Funktionen mit RESULT - variable }
{*H 2.10 Pos ausgeblendet fuer Delphi 9 (VER170) }
{*H 2.09 Deci korrigiert (hinsl. negative Zahlen)}
{*H 2.08 TryWildcardMatching, TryFunctionMatching}
{*H 2.07 LowCase }
{*H 2.06 GetSoundex }
{*H 2.05 Cleanpath }
{*H 2.04 Vararraybylinesep KeepQuote}
{*H 2.03 Value}
{*H 2.02 Vararraybylinesep AusgabeKonsistenz}
{*H 2.01 StrReplace }

Interface

Uses classes;

resourcestring
   Umlauts = 'Umlaute';

Type
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Liste der Separatoren</info>
  TSeparators = (Sep_CR, Sep_LF, Sep_Tab, Sep_Space, Sep_Semikolon,
    Sep_Komma, Sep_Gedankenstrich, Sep_Und, Sep_KaufmUnd,
    Sep_Querstrich, Sep_Backslash,
    Sep_DoppelSpace, Sep_EkgKlammer, Sep_GeschKlammer,
    Sep_RndKlammer, Sep_SpzKlammer, Sep_Anfuehrungsz,
    {$ifndef fpc}Sep_Hochkomma1,{$endif}
    Sep_Hochkomma2,
    Sep_Hochkomma3);
  TSeparatSet = Set Of TSeparators;
  TSepArray = Array[TSeparators] Of integer;
  TarrayOfString = Array Of String;

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Moegliche Parse-modi fuer ParseStr (und ParseVar)</info>
  TParseModus = (psm_Full, psm_Start,psm_StartErw, psm_End, psm_EndErw, psm_Somewhere);

  {$ifdef DEFAULTS_WIDESTRING}
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Typdeklaration fuer Zeichensaetze</info>
  TCharset = Set Of AnsiChar;
  {$ELSE}
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Typdeklaration fuer Zeichensaetze</info>
  TCharset = Set Of Char;
  {$ENDIF}

Const
  vbCr = #13;
  vbLf = #10;
  vbTab = #9;
  UmlAEGr = #217;
  UmlOEGr = #218;
  UmlUEGr = #219;
  UmlAEkl = #220;
  UmlOEkl = #221;
  UmlSSkl = #222;
  UmlUEkl = #223;
  {$IFDEF FPC}
  vbNewLine = LineEnding;
  {$ELSE}
  vbNewLine = #13#10;
  LineEnding = vbNewLine;
  {$ENDIF}
  Ziffern = ['0'..'9'];
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>ZiffernErw enthaelt die Zeichen um auch Real-Zahlen zu schreiben</info>
  ZiffernErw = Ziffern + [',', 'e', '-'];
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Whitespaces sind Zeichen die man nicht sieht</info>
  Whitespace = [' ', #0, vbcr, vbLf, vbTab, #255];
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>gebraeuchliche Satzzeichen</info>
  SatzZeichen = [' ', ',', ';', '.', ':', '?', '!', vbtab];
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Alle Satzzeichen</info>
  SatzZeichenErw = SatzZeichen + ['/', '-', '(', ')', '"', '''', '^'];

  {$ifndef fpc}
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>05.09.2014</since>
  ///  <version>2.23.00</version>
  ///  <info>Alle sonstigen Zeichen</info>
  SonstigesErw   =  [char('²'), '³',char('€'),'°','§'];
  {$endif}
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Alle sonstigen Zeichen</info>
  Sonstiges  = [ '$', '%', '&', '#',  '@',  '{', '[', ']',
    '}', '*', '+', '~', '\', '<', '>', '|', '_']
   {$ifndef fpc}   + SonstigesErw {$endif};

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Deutsche Umlaute</info>
  umlaut  =[UmlAEGr,UmlOEGr,UmlUEGr,UmlAEkl,UmlOEkl,UmlUEkl,UmlSSkl];

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>15.10.2016</since>
  ///  <version>2.30.00</version>
  ///  <info>Alle kleinen Buchstaben </info>
  LowerCharset  = ['a'..'z'] ;

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>15.10.2016</since>
  ///  <version>2.30.00</version>
  ///  <info>Alle kleinen Buchstaben + kleine dt. Umlaute</info>
  LowerCharsetErw  = LowerCharset+[UmlAEkl,UmlOEkl,UmlUEkl,UmlSSkl] ;

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>15.10.2016</since>
  ///  <version>2.30.00</version>
  ///  <info>Alle großen Buchstaben </info>
  UpperCharset  = ['A'..'Z'] ;

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>15.10.2016</since>
  ///  <version>2.30.00</version>
  ///  <info>Alle großen Buchstaben + Große dt. Umlaute</info>
  UpperCharsetErw  = UpperCharset + [UmlAEGr,UmlOEGr,UmlUEGr] ;

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Alle Buchstaben </info>
  Charset  = ['a'..'z', 'A'..'Z'] + umlaut;

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Alle Ziffern und Zeichen</info>
  AlphaNum  = Ziffern + Charset;

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Alle Ziffern und Zeichen</info>
  AllVisible  = AlphaNum + SatzZeichenErw + Whitespace + Sonstiges ;

{$IFDEF SUPPORTS_INT64}
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Wandelt eine Zahl in Hex-String um</info>
Function hex(value: int64; size: integer = -1): String; deprecated
{$ifdef SUPPORTS_DEPRECATED_DETAILS}'Use InttoHex instead'{$endif};
{$ELSE}
  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Wandelt eine Zahl in Hex-String um</info>
Function hex(value: longint; size: integer = -1): String; deprecated
{$ifdef SUPPORTS_DEPRECATED_DETAILS}'Use InttoHex instead'{$endif};
{$ENDIF}
// Wandelt eine Zahl in Hex-String um
// Obsolete !! --> inttohex()

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>wandelt einen Hex-Code in eine Zahl (byte) um</info>
Function hex2(h: String; len: integer = -1): {$IFDEF SUPPORTS_INT64}int64{$ELSE} integer{$ENDIF}  ; overload;
// wandelt einen Hex-Code in eine Zahl (byte) um

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Wandelt eine Zahl in Decimal-String um (incl. fuehrende Nullen)</info>
Function deci(value: longint; size: integer = -1): String;overload;
// Wandelt eine Zahl in Decimal-String um

///<author>Rosewich</author>
///  <user>admin</user>
///  <since>16.04.2008</since>
///  <version>2.23.00</version>
///  <info>Wandelt eine Zahl in Decimal-String um (incl. fuehrende Nullen)</info>
Function deci(value: int64; size: integer = -1): String;overload;
// Wandelt eine Zahl in Decimal-String um

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Durchsucht den String nach 'Such' und ersetzt dies durch 'Ers'</info>
Function StrReplace(Const Ostr, such, ers: String): String; overload;
//Durchsucht den String nach 'Such' und ersetzt dies durch 'Ers'.

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Ersetzt Im String den Teil ab Stelle START durch 'Ers'.</info>
Function StrReplace(Const Ostr: String; Const start: integer; Const ers:
  String): String; overload;inline;
//Ersetzt Im String den Teil ab Stelle START durch 'Ers'.

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>16.04.2008</since>
  ///  <version>2.23.00</version>
  ///  <info>Durchsucht den String 'Line' nach 'Word' und zaehlt alle vorkommen.</info>
Function WordCount(Const Line: String; Word: String = ' '): integer;
//Durchsucht den String nach 'Line' und zaehlt alle vorkommen.

//Fehlerverzeihende String nach Wert(variant) wandlung
Function value(strng: String; noerr: boolean = true): variant; inline;

Function Ansi2ascii(Astr: String): String; overload;
//Checked
Function Ascii2ansi(Astr: String): String; overload;
//Checked

Function Ansi2ascii(Achr: char): char; overload; inline;
//Checked
Function Ascii2ansi(Achr: char): char; overload; inline;
//Checked

Function Text2Filename(text: String): String;
//Checked
Function Filename2Text(text: String): String;
//Checked

// Bereinigt einen Pfad von allen ../ - Verweisen
Function CleanPath(path: String): String;

// Behandelt einen String wie ein Profile
// Sinn: Zusaetzliche Informationen in einem 'Memo' Speichern
// Hole Daten
Function parseStrasProfile(Org, Titel, eintr: String): Variant;

// Schreibe Daten
Procedure putStrasProfile(Var Org: String; Const titel: String; Const eintr:
  String; Const Datum: Variant);

Function left(org: String; anz: integer): String;inline;
Function right(org: String; anz: integer): String;inline;

// Kopiert rest des Strings ab angegebener Stelle
Function Middle(org: String; spos: integer): String; overload; inline;

{$IFNDEF COMPILER15_up}
Function UpCase(ch: Char): Char; overload;
{$ENDIF}
Function UpCase(S: String): String; overload;
Function LowCase(s: String): String;

{$IFNDEF COMPILER9_up}
Function Pos(sub: String; s: String; offset: integer = 1): integer; overload;
{$ENDIF}

// Ermittelt die position von 'sub' in 'S' ab Offset
Function Pos(offset: integer; sub: String; s: String): integer; overload; inline;
{$IFNDEF DEFAULTS_WIDESTRING}
// prüft ob der Char in dem Charset enthalten ist
// ersetzt 'in'-Konstrukt
Function CharInSet(C:Char; Cset:TCharset) :boolean; inline;
{$DEFINE DECL_CHARINSET}
{$else}
{$ifdef fpc}
// prüft ob der Char in dem Charset enthalten ist
// ersetzt 'in'-Konstrukt
Function CharInSet(C:Char; Cset:TCharset) :boolean; inline;
{$DEFINE DECL_CHARINSET}
{$endif}
{$ENDIF}

Function Findall(sub: String; s: String): variant;
//Liefert ein Array mit allen Startpositionen zurueck

// Behandelt einen String wie ein Profile
// Sinn: Zusaetzliche Informationen in einem 'Memo' Speichern
Function ParseStr(Const Line: String; Const Args: TarrayOfString): integer;
overload;
Function ParseStr(Const Line: String; Const Args: TarrayOfString; Modus:
  TParseModus): integer; overload;
Function ParseStr(Const Line: String; Const Args: TStrings; Modus: TParseModus):
  integer; overload;
Function ParseVar(Const Line: String; Const Args: variant; Modus: TParseModus =
  psm_Full): integer; overload;

Function DateTime2DTStr(DT: TDateTime): String;
//

  ///<author>Rosewich</author>
  ///  <user>admin</user>
  ///  <since>25.09.2008</since>
  ///  <version>2.25.00</version>
  ///  <info>Extrahiert aus einem Text den Untertext Zwischen LStart und LEnd</info>
Function ExtractTextBetween(const Text,LStart,LEnd: string; offset: Integer=1): string;


Function testLinesep(Line: String; Sep: TSeparators): boolean; overload;
Function testLinesep(Line: String; Sep: TSeparators;{$ifdef SUPPORTS_OUTPARAMS}out separat :string;var rest: String{$else}
  var separat,rest: String{$endif}): boolean; overload;

Procedure TestForLineSep(Const Line: String; Const validSep: TSeparatSet;
   Ergeb: TSepArray);

Function CountSeparators(Line: String; Sep: TSeparators): integer; overload;
Function CountSeparators(Line: String; SepSet: TSeparatset): integer; overload;

// Teste, ob 'TestString' aus Zeichen von 'charset' besteht.
// referenz zu CharInSet
Function TestString(testStr: String; Charset: TCharset): boolean;

Function getLastSepBy(Orginal: String; sep: TSeparators): String;

// Erzeugt ein dynamisches Array
Function DynArrayByLinesep(Const Line: String; sep: TSeparators = sep_Komma;
  KeepQuote: boolean = false): TarrayOfString;overload;
// Erzeugt ein Dynamisches Array 2
Function DynArrayByLinesep(Const Line: String; seps: TSeparatSet ;TrimEmpty:boolean;
  KeepQuote: boolean = false): TarrayOfString;overload;


// Erzeugt ein Variantes Array
Function VarArrayByLinesep(Const Line: String; sep: TSeparators = sep_Komma;
  KeepQuote: boolean = false): variant;overload;
// Erzeugt ein Variantes Array 2
Function VarArrayByLinesep(Const Line: String; seps: TSeparatSet ;TrimEmpty:boolean;
  KeepQuote: boolean = false): variant;overload;

// sortiert die Worte in einem String;
Function strsort(Const orig: String; sep: TSeparators = sep_space; ValidChars:
  TCharset = alphanum): String;
// Check

// Ermittelt den Differenzwert zweier Strings (1.0 ~> gleich )
Function EvalCompareStr(Const str1, str2: String): real;
//

// Schneidet führende und folgende Leerzeichen ab (-> trim), und
// wandelt doppelte Leerzeichen in einfache um.
Function strTrimm(org: String): String;
//

// Ermittelt ob "Probe" durch "Mask" dargestellt werden kann.
Function TryFWildcardMatching(Probe, Mask: String): integer; overload;
// Ermittelt ob "Probe" durch "Mask" dargestellt werden kann.
//  Elemente werden in der Sektion [WildCardFill] erwartet
Function TryFWildcardMatching(Probe, Mask: String; Var Wildcardfill: String):
  integer; overload;
//

//  Versucht den String 'Probe' anhand von 'Mask' zu zerlegen, bzw. Funktionen zuzuordnen.
//  Funktionen werden mit $<Buchstabe> beschrieben.
//  ab V.2.20 werden Nummern werden mit #<Buchstabe> beschrieben.
Function TryFunctionMatching(Probe, Mask: String; Var Wildcardfill: String):
  integer;

//  Baut einen String anhand der Maske und den Uebergebenen Fuellelementen
//  Funktionen werden mit $<Buchstabe> beschrieben.
//  ab V.2.20 werden Nummern werden mit #<Buchstabe> beschrieben.
//  Elemente werden in der Sektion [WildCardFill] erwartet
Function BuildStringByFunction(Mask, Wildcardfill: String): String;inline;

//  Wandelt ein dynamisches Array of String in TArray of String um
function aos2TArrayOfString(aos:Array of String):TarrayOfString;

Const
//  Vordefinierte String-Separatoren
  LineSeparators: Array[TSeparators, 0..1] Of String =
  ((vbCr, ''),
    (vbLf, ''),
    (vbTab, ''),
    (' ', ''),
    (';', ''),
    (',', ''),
    (' - ', ''),
    (' und ', ''),
    (' & ', ''),
    (' / ', ''),
    (' \ ', ''),
    ('  ', ''),
    ('[', ']'),
    ('{', '}'),
    ('(', ')'),
    ('<', '>'),
    (' "', '"'),
    {$ifndef fpc}(' ´', '´'),{$endif}
    (' `', '`'),
    (' ''', ''''));

  // Set aus String-Separatoren
  SepFullSet: TSeparatSet = [Sep_CR, Sep_LF, Sep_Tab, Sep_Space, Sep_Semikolon,
  Sep_Komma, Sep_Gedankenstrich, Sep_Und, Sep_KaufmUnd, Sep_Querstrich,
    Sep_Backslash, Sep_DoppelSpace, Sep_EkgKlammer, Sep_GeschKlammer,
    Sep_RndKlammer, Sep_SpzKlammer, Sep_Anfuehrungsz,
    {$ifndef fpc}Sep_Hochkomma1,{$endif}
    Sep_Hochkomma2,
    Sep_Hochkomma3];

//Ermittelt aus einem String den dazugehoerigen Soundex
Function GetSoundex(org: String): String;
{*e Ermittelt aus einem String den dazugehoerigen Soundex }


Const
// Konstante für ASCII <-> ANSI umwandlung
  asciiansi: Array[0..1] Of String =
   {$ifndef fpc}
   ('ÖÄÜöä'+UmlUEkl+'ßéá´ñ°', // Do not translate
    '™Žš”„á‚ ï¤ø'); // Do not translate
// '™Žš”„á‚ ï¤ø'); // Do not translate ??
{$ELSE}
   (#$D6#$C4#$DC#$F6#$E4#$FC#$DF#$E9#$E1#$B4#$F1#$B0, // Do not translate
    #$99#$8E#$9A#$94#$84#$81#$E1#$82#$A0#$EF#$A4#$F8);
{$endif}

Function Str2QHtml(s: String): String;

Const
  hexcode: Array[0..15] Of char = '0123456789ABCDEF';
  CSWildCardFill = 'WildCardFill';

Implementation

{$UNDEF debug}
Uses variants,
  Sysutils,
  Unt_Allgfunklib
{$IFDEF debug}
  , Unt_debug
{$ENDIF ~debug};


Const
  t2fstrings: Array[0..13, 0..2] Of String =
  (('; ', '\', #1),
    (vbTab, '\', #0),
    (vbcr, '\', #0),
    (vblf, '\', #0),
    ('\\', '\', #0),
    ('"', '''''', #1),
    ('/', '_', #0),
    (':', ';', #1),
    ('|', '!', #1),
    (' ', '_', #1),
    ('.', '_', #0),
    ('*', '_', #0),
    ('?', '_', #0),
    ('__', '_', #0));

  str2htmldef: Array[0..10, 0..2] Of String =
  ((' ', '%20', '%spc;'),
    ('&', '%', #0),
    ('"', '[', #0),
    ('\', ']', #0),
    (UmlAEkl, 'ae', #0),
    (UmlOEkl, 'oe', #0),
    (UmlUEkl, 'ue', #1),
    (UmlAEGr, 'Ae', #0),
    (UmlOEGr, 'Oe', #1),
    (UmlUEGr, 'Ue', #1),
    (UmlSSkl, 'ss', #1));

Type
  ///<property>SoundEx Definitions-Record</property>
  {$ifNdef DEFAULTS_WIDESTRING}
  TSoundex = Record
    Sal: String[2];
    komb: String[4];
  End;
  {$ELSE}
  TSoundex = Record
    Sal: String;
    komb: String;
  End;
  {$ENDIF}

Const
  maxkomb = 61;
  Soundex: Array[1..maxkomb] Of TSoundex =
  ((Sal: 'a'; komb: 'ah'),
    (Sal: UmlUEkl; komb: 'ai'),
    (Sal: UmlUEkl+'k'; komb: 'alk'),
    (Sal: UmlUEkl; komb: 'ay'),
    (Sal: 'a'; komb: 'a'),
    (Sal: 'p'; komb: 'b'),
    (Sal: 'kr'; komb: 'chr'),
    (Sal: 'ks'; komb: 'chs'),
    (Sal: 'k'; komb: 'ch'),
    (Sal: 'k'; komb: 'ck'),
    (Sal: 'k'; komb: 'c'),
    (Sal: 'd'; komb: 'd'),
    (Sal: 'e'; komb: 'eh'),
    (Sal: UmlUEkl; komb: 'ei'),
    (Sal: 'o'; komb: 'eu'),
    (Sal: UmlUEkl; komb: 'ey'),
    (Sal: 'e'; komb: 'e'),
    (Sal: 'f'; komb: 'f'),
    (Sal: 'k'; komb: 'ge'),
    (Sal: 'k'; komb: 'g'),
    (Sal: ''; komb: 'h'),
    (Sal: 'i'; komb: 'ieh'),
    (Sal: 'i'; komb: 'ie'),
    (Sal: 'ik'; komb: 'ich'),
    (Sal: 'i'; komb: 'ih'),
    (Sal: 'i'; komb: 'i'),
    (Sal: 'i'; komb: 'j'),
    (Sal: 'k'; komb: 'k'),
    (Sal: 'r'; komb: 'l'),
    (Sal: 'm'; komb: 'm'),
    (Sal: 'm'; komb: 'ng'),
    (Sal: 'm'; komb: 'n'),
    (Sal: 'o'; komb: 'oh'),
    (Sal: 'o'; komb: 'oi'),
    (Sal: 'o'; komb: 'o'),
    (Sal: 'f'; komb: 'pf'),
    (Sal: 'f'; komb: 'ph'),
    (Sal: 'p'; komb: 'p'),
    (Sal: 'k'; komb: 'q'),
    (Sal: 'r'; komb: 'r'),
    (Sal: 's'; komb: 'sch'),
    (Sal: 'sd'; komb: 'st'),
    (Sal: 's'; komb: 'sz'),
    (Sal: 's'; komb: 's'),
    (Sal: 's'; komb: 'ts'),
    (Sal: 's'; komb: 'tz'),
    (Sal: 'd'; komb: 't'),
    (Sal: 'u'; komb: 'uh'),
    (Sal: 'u'; komb: 'u'),
    (Sal: 'f'; komb: 'v'),
    (Sal: 'f'; komb: 'w'),
    (Sal: 's'; komb: 'x'),
    (Sal: UmlUEkl; komb: 'y'),
    (Sal: 's'; komb: 'z'),
    (Sal: 'e'; komb: UmlAEGr),
    (Sal: 'o'; komb: UmlOEGr),
    (Sal: UmlUEkl; komb: UmlUEGr),
    (Sal: 's'; komb: UmlSSkl),
    (Sal: 'e'; komb: UmlAEkl),
    (Sal: 'o'; komb: UmlOEkl),
    (Sal: UmlUEkl; komb: UmlUEkl));


function hex(value: int64; size: integer): String;
// Wandelt eine Zahl in Hex-String um
// Obsolete !! --> inttohex()

Var
  i: integer;
  v: longint;
  h: String;

Begin
  i := 1;
  v := value;
  h := '';
  While (i <= size) Or (v <> 0) Do
    Begin
      h := hexcode[v And $F] + h;
      v := v Shr 4;
      inc(i);
    End;
  result := h
End;
//-------------------------------------------------------------

function deci(value: longint; size: integer): String;
// Wandelt eine Zahl in Decimal-String um
// fehler Bei negativen Zahlen.

Var
  i: integer;
  v: longint;
  h: String;
  neg: boolean;
Begin
  i := 1;
  v := value;
  neg := v < 0;
  v := abs(v);
  If neg And (size > -1) Then
    dec(size);
  h := '';
  While (i <= size) Or (v <> 0) Do
    Begin
      h := hexcode[v Mod 10] + h;
      v := v Div 10;
      inc(i);
    End;
  If neg Then
    h := '-' + h;
  result := h
End;
//-------------------------------------------------------------
function deci(value: int64; size: integer): String;
// Wandelt eine Zahl in Decimal-String um
// fehler Bei negativen Zahlen.

Var
  i: integer;
  v: int64;
  h: String;
  neg: boolean;
Begin
  i := 1;
  v := value;
  neg := v < 0;
  v := abs(v);
  If neg And (size > -1) Then
    dec(size);
  h := '';
  While (i <= size) Or (v <> 0) Do
    Begin
      h := hexcode[v Mod 10] + h;
      v := v Div 10;
      inc(i);
    End;
  If neg Then
    h := '-' + h;
  result := h
End;
//-------------------------------------------------------------

function value(strng: String; noerr: boolean): variant;
// bestimmt den Wert eines Strings

Var
  e: integer;
  v: extended;

Begin
  strng := strreplace(strng, ',', '.');
  val(strng, v, e);
  If noerr Or (e = 0) Then
    result := v
  Else
    result := 0
End;
//-------------------------------------------------------------

function StrReplace(const Ostr, such, ers: String): String;
// Obsolete, Use
Var
  hst: String;
  pp,dl: integer;
  once:boolean;

Begin
  hst := Ostr;
  once := (Pos(such,ers)>0);
  dl := length(ers)-length(such);
  pp := pos(such, hst);
  if (such<>ers) then
  While (pp > 0)  Do
    Begin
      hst := copy(hst, 1, pp - 1) + ers + copy(hst, pp + length(such),
        length(hst));
      if once then
        pp := pos(pp+dl+1,such, hst)
      else
        pp := pos(such, hst);
    End;
  result := hst;
End;
//-------------------------------------------------------------

function StrReplace(const Ostr: String; const start: integer; const ers: String
  ): String;

Begin
  Assert(start <= Length(Ostr));
  result := copy(Ostr, 1, Start - 1) + ers + copy(Ostr, Start + length(ers),
    length(Ostr));
End;
//-------------------------------------------------------------

function WordCount(const Line: String; Word: String): integer;
//Durchsucht den String nach 'Line' und zaehlt alle vorkommen.
// O(length(line))

Var
  pp, cnt: integer;

Begin
  cnt := 0;
  pp := pos(word, Line);
  While pp > 0 Do
    Begin
      inc(cnt);
      pp := pos(pp + 1, word, line)
    End;
  result := cnt;
End;
//-------------------------------------------------------------

function Ansi2ascii(Achr: char): char;

Var
  i: integer;

Begin
  i := pos(achr, asciiansi[0]);
  If I = 0 Then
    result := achr
  Else
    result := asciiansi[1][i];
End;
//-------------------------------------------------------------

function Ascii2ansi(Achr: char): char;

Var
  i: integer;

Begin
  i := pos(achr, asciiansi[1]);
  If I = 0 Then
    result := achr
  Else
    result := asciiansi[0][i];
End;
//-------------------------------------------------------------

function Ansi2ascii(Astr: String): String;

Var
  i: integer;
  hst: String;
Begin
  hst := astr;
  For i := 1 To length(asciiansi[0]) Do
    Begin
      hst := StrReplace(hst, asciiansi[0][i], asciiansi[1][i])
    End;
  result := hst
End;
//-------------------------------------------------------------

function Ascii2ansi(Astr: String): String;

Var
  i: integer;
  hst: String;
Begin
  hst := astr;
  For i := 1 To length(asciiansi[0]) Do
    Begin
      hst := StrReplace(hst, asciiansi[1][i], asciiansi[0][i])
    End;
  result := hst
End;
//-------------------------------------------------------------

{$IFNDEF COMPILER9_UP}
function Pos(sub: String; s: String; offset: integer): integer;

Var
  p: integer;
Begin
  p := system.pos(sub, copy(S, offset, length(s)));
  If p > 0 Then
    p := p + offset - 1;
  result := p;
End;
{$ENDIF}
//-------------------------------------------------------------

function Pos(offset: integer; sub: String; s: String): integer;

Var
  p: integer;
Begin
  p := system.pos(sub, copy(S, offset, length(s)));
  If p > 0 Then
    p := p + offset - 1;
  result := p;
End;
//-------------------------------------------------------------

function ExtractTextBetween(const Text, LStart, LEnd: string; offset: Integer
  ): string;
var
  LE: Integer;
  LP: Integer;
  LPP: Integer;
begin
  offset := max(offset,1);
  LP := pos(offset, LStart, Text);
  LE := pos(offset + LP, LEnd, Text);
  LPP := pos(offset + LP, LStart, Text);
  while (LE>0) and (LPP<LE) and (LPP>0) do
    begin
      LP := LPP;
      LPP := pos(offset + LP, LStart, Text);
    end;
  if LE = 0 then
    result := copy(Text, lp + length(LStart) + 1{$ifdef FPC},length(text){$ENDIF})
  else
    result := copy(Text, lp + length(LStart) , LE - LP - Length(LStart) );
end;
//-------------------------------------------------------------

function Findall(sub: String; s: String): variant;
//Liefert ein Array mit allen Startpositionen zurueck
Var
  avar: Array Of integer;
  i, imax: integer;

Begin
  result := null;
  imax := 0;
  i := 1;
  While i > 0 Do
    Begin
      i := pos(i + 1, sub, s);
      If i > 0 Then
        inc(imax);
    End;
  If imax > 0 Then
    Begin
      SetLength(avar, imax);
      i := 0;
      avar[i] := pos(sub, s);
      For i := 1 To imax - 1 Do
        avar[i] := pos(avar[i - 1] + 1, sub, s);
      result := avar;
    End;
End;
//-------------------------------------------------------------

function testLinesep(Line: String; Sep: TSeparators): boolean;
//liefert zurueck, ob der Separator 'sep' in 'Line' vorkommt und Liefert das Separat und den Rest
Var
  posa, pose: integer;
  lsa, lse: String;

Begin
  lsa := lineseparators[Sep, 0];
  lse := LineSeparators[Sep, 1];
  posa := pos(lsa, line);
  If posa <> 0 Then
    Begin
      If lse = '' Then
        Begin
          //      separat = Mid(Line, posa + Len(lsa))
          //      rest = Left(Line, posa - 1)
          result := True;
        End
      Else
        Begin
          pose := pos(posa + Length(lsa), lse, Line);
          If pose > 0 Then
            Begin
              //        separat = Mid(Line, posa + Len(lsa), pose - posa - Len(lsa))
              result := true;
              //        rest = Left(Line, posa - 1) + Mid(Line, pose + Len(lse))
            End
          Else
            Begin
              result := False;
              //        separat = ""
              //        rest = Line
            End
        End
    End
  Else
    Begin
      result := False
        //    separat = ""
  //    rest = Line
    End;
End;
//-------------------------------------------------------------

function testLinesep(Line: String; Sep: TSeparators; out separat: string;
  var rest: String): boolean;
//liefert zurueck, ob der Separator 'sep' in 'Line' vorkommt und Liefert das Separat und den Rest
Var
  posa, pose: integer;
  lsa, lse: String;

Begin
  lsa := LineSeparators[Sep, 0];
  lse := LineSeparators[Sep, 1];
  posa := pos(lsa, line);
  If posa > 0 Then
    Begin
      If lse = '' Then
        Begin
          rest  := middle(Line, posa + Length(lsa));
          separat := Left(Line, posa - 1);
          result := True;
        End
      Else
        Begin
          pose := pos(posa + Length(lsa), lse, Line);
          If pose > 0 Then
            Begin
              rest := copy(Line, posa + Length(lsa), pose - posa -
                Length(lsa));
              result := true;
              separat := Left(Line, posa - 1) + copy(Line, pose + Length(lse),
                length(line));
            End
          Else
            Begin
              result := False;
              rest := '';
              separat := Line;
            End
        End
    End
  Else
    Begin
      result := False;
      rest := '';
      separat := Line;
    End;
End;
//-------------------------------------------------------------

function CountSeparators(Line: String; Sep: TSeparators): integer;
Var
  cnt1, cnt2: integer;
Begin
  if (copy(Lineseparators[sep, 0],2,1) <> Lineseparators[sep, 1]) or (Lineseparators[sep, 1] = '') then
    begin
      cnt1 := wordcount(line, Lineseparators[sep, 0]);
      If Lineseparators[sep, 1] <> '' Then
        Begin
          cnt2 := wordcount(line, Lineseparators[sep, 1]);
          result := min(cnt1, cnt2);
        End
      Else
        result := cnt1;
    end
  else
    result := wordcount(line, Lineseparators[sep, 1]) div 2;
End;
//-------------------------------------------------------------

function CountSeparators(Line: String; SepSet: TSeparatset): integer;
Var
  cnt: integer;
  isep: TSeparators;
Begin
  cnt := 0;
  For isep := low(TSeparators) To high(TSeparators) Do
    If isep In SepSet Then
      cnt := cnt + countSeparators(line, isep);
  result := cnt;
End;
//-------------------------------------------------------------

procedure TestForLineSep(const Line: String; const validSep: TSeparatSet;
  ergeb: TSepArray);

Var
  iterat: TSeparators;

Begin
  For iterat := low(Tseparators) To high(Tseparators) Do
    If iterat In validSep Then
      If testLinesep(line, iterat) Then
        inc(ergeb[iterat]);
End;
//-------------------------------------------------------------

function parseStrasProfile(Org, Titel, eintr: String): Variant;
// Behandelt einen String wie ein Profile
// Sinn: Zusaetzliche Informationen in einem 'Memo' Speichern
Var
  tpos, ntpos, epos, lpos: integer;

Begin
  result := '';
  If titel = '' Then
    Begin
      tpos := 1;
      If (org = '') Or (org[1] = '[') Then
        exit
    End
  Else
    Begin
      tpos := pos('[' + Titel + ']', Org);
      If tpos = 0 Then
        Exit
    End;
  ntpos := pos(tpos + 2, vbNewLine + '[', Org);
  If ntpos = 0 Then
    ntpos := Length(Org) + 1;
  epos := pos(tpos + Length(Titel), vbNewLine + upcase(eintr) + '=',
    upcase(Org));
  If (epos = 0) Or (epos > ntpos) Then
    Exit
  Else
    Begin
      lpos := pos(epos + 2, vbNewLine, Org);
      If lpos = 0 Then
        lpos := ntpos;
      result := copy(Org, epos + 3 + Length(eintr), lpos - (epos + 3 +
        Length(eintr)))
    End

End;
//-------------------------------------------------------------

procedure putStrasProfile(var Org: String; const titel: String;
  const eintr: String; const Datum: Variant);
// Behandelt einen String wie ein Profile
// Sinn: Zusaetzliche Informationen in einem 'Memo' Speichern
Var
  tpos, // Position des Titels
  ntpos, // Ende-Position des Titels
  epos, // Einfuegeposition
  lpos: integer;
  DatAsStr: String;
Begin
  DatAsStr := Datum;
  If titel <> '' Then
    Begin
      tpos := pos(vbNewLine + '[' + titel + ']', vbNewLine + Org);
      If tpos = 0 Then
        Begin
          Org := Org + vbNewLine + '[' + titel + ']' + vbNewLine + eintr + '=' +
            DatAsStr;
          exit;
        End;
      tpos := tpos - length(vbnewline);
    End
  Else
    Begin
      tpos := 1;
    End;

  // Bestimme Ende-Position
  If (tpos = 1) And (titel = '') Then
    Begin
      ntpos := pos(vbNewLine + '[', vbNewLine + Org);
      If ntpos = 0 Then
        ntpos := length(Org) + 1
      Else
        ntpos := ntpos - 1
    End
  Else
    ntpos := pos(tpos + 2, vbNewLine + '[', Org);

  If ntpos = 0 Then
    ntpos := length(Org) + 1;

  // Bestimme Einfuegeposition
  epos := pos(tpos + length(titel), vbNewLine + eintr + '=', Org);
  If (epos = 0) Or (epos > ntpos) Then
    Begin
      // Neuer Eintrag
      epos := pos(tpos + 2, vbNewLine, Org);
      Org := Left(Org, epos - 1) + vbNewLine + eintr + '=' + (DatAsStr) +
        Middle(Org, epos);
      Exit
    End;
  lpos := pos(epos + 2, vbNewLine, Org);
  If lpos = 0 Then
    lpos := ntpos;
  Org := Left(Org, epos + 2 + length(eintr)) + (DatAsStr) + Middle(Org, lpos)
End;
//-------------------------------------------------------------

function getLastSepBy(Orginal: String; sep: TSeparators): String;
Var
  start, spos: integer;
  test: String;

Begin
  start := 1;
  spos := pos(start, LineSeparators[sep, 0], Orginal);
  result := Orginal;
  While spos > 0 Do
    Begin
      test := copy(Orginal, spos + 1, length(Orginal) - spos);
      If test <> '' Then
        result := test;
      //      start:=spos;
      spos := pos(spos + Length(LineSeparators[sep, 0]), LineSeparators[sep, 0],
        Orginal);
    End
End;
//-------------------------------------------------------------

function left(org: String; anz: integer): String;

Begin
  If anz >= 0 Then
    result := copy(org, 1, anz)
  Else
    result := copy(org, 1, length(org) + anz)
End;
//-------------------------------------------------------------

function right(org: String; anz: integer): String;

Begin
  If anz >= 0 Then
    result := copy(org, length(org) - anz + 1, anz)
  Else
    result := copy(org, -anz + 1, length(org) + anz);
End;
//-------------------------------------------------------------

function Middle(org: String; spos: integer): String;

Begin
  result := copy(org, spos, length(org));
End;
//-------------------------------------------------------------

function strTrimm(org: String): String;
//
Var
  Hst: String;
Begin
  hst := Trim(Org);
  result := strreplace(hst, '  ', ' ');
End;
//-------------------------------------------------------------

function UpCase(ch: Char): Char; overload;


Begin
  result := system.UpCase(ch);
End;
//-------------------------------------------------------------

function UpCase(S: String): String; overload;

Var
  i: integer;

Begin
  For i := 1 To length(s) Do
    s[i] := system.UpCase(s[i]);
  result := s;
End;
//-------------------------------------------------------------

function LowCase(s: String): String;

Begin
  result := LowerCase(s);
End;
//-------------------------------------------------------------

function ParseStr(const Line: String; const Args: TarrayOfString): integer;

Var
  i: Integer;

Begin
  For i := 0 To high(args) Do
    If UpCase(line) = Upcase(args[i]) Then
      Begin
        result := i;
        Exit
      End;
  result := -1;
End;
//-------------------------------------------------------------

function ParseStr(const Line: String; const Args: TarrayOfString;
  Modus: TParseModus): integer;

Var
  i: Integer;

Begin
  For i := low(args) To high(args) Do
    Case modus Of
      psm_Full:
        Begin
          If UpCase(line) = Upcase(args[i]) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_Start:
        Begin
          If UpCase(left(line, length(args[i]))) = Upcase(args[i]) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_StartErw:
        Begin
          If (UpCase(left(line, length(args[i]))) = Upcase(args[i])) and
            charinset(copy(line+' ', length(args[i])+1,1)[1],Whitespace) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_End:
        Begin
          If UpCase(right(line, length(args[i]))) = Upcase(args[i]) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_EndErw:
        Begin
          If (UpCase(right(line, length(args[i]))) = Upcase(args[i])) and
            charinset(copy(' '+line,Length(line)-length(args[i])+1,1)[1],Whitespace) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_Somewhere:
        Begin
          If pos(Upcase(args[i]), UpCase(line)) > 0 Then
            Begin
              result := i;
              Exit
            End;
        End;
    End;
  result := -1;
End;
//-------------------------------------------------------------

function ParseStr(const Line: String; const Args: TStrings; Modus: TParseModus
  ): integer;

Var
  i: Integer;

Begin
  For i := 0 To args.Count - 1 Do
    Case modus Of
      psm_Full:
        Begin
          If UpCase(line) = Upcase(args[i]) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_Start:
        Begin
          If UpCase(left(line, length(args[i]))) = Upcase(args[i]) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_End:
        Begin
          If UpCase(right(line, length(args[i]))) = Upcase(args[i]) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_Somewhere:
        Begin
          If pos(Upcase(args[i]), UpCase(line)) > 0 Then
            Begin
              result := i;
              Exit
            End;
        End;
    End;
  result := -1;
End;
//-------------------------------------------------------------

function ParseVar(const Line: String; const Args: variant; Modus: TParseModus
  ): integer;

Var
  i: Integer;

Begin
  // Test ob args auch ein Array ist. (Ab V.2.17)
  If Not VarIsArray(args) Then
    Begin
      result := -1;
      exit
    End;
  For i := VarArraylowBound(args, 1) To VarArrayHighBound(args, 1) Do
    Case modus Of
      psm_Full:
        Begin
          If UpCase(line) = Upcase(String(args[i])) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_Start:
        Begin
          If UpCase(left(line, length(args[i]))) = Upcase(String(args[i])) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_End:
        Begin
          If UpCase(right(line, length(args[i]))) = Upcase(String(args[i])) Then
            Begin
              result := i;
              Exit
            End;
        End;
      psm_Somewhere:
        Begin
          If pos(Upcase(String(args[i])), UpCase(line)) > 0 Then
            Begin
              result := i;
              Exit
            End;
        End;
    End;
  result := -1;
End;
//-------------------------------------------------------------

function DateTime2DTStr(DT: TDateTime): String;

Var
  Yr, mn, dy, ho, mi, sc, msc: word;
  hst: String;

Begin
  decodedate(dt, yr, mn, dy);
  decodeTime(dt, ho, mi, sc, msc);
  hst := deci(yr, 4);
  hst := hst + deci(mn, 2);
  hst := hst + deci(dy, 2) + ';';
  hst := hst + deci(ho, 2);
  hst := hst + deci(mi, 2);
  hst := hst + deci(sc, 2);
  result := hst;
End;
//-------------------------------------------------------------

function TestString(testStr: String; Charset: TCharset): boolean;

Var
  i: integer;

Begin
  result := false;
  For i := 1 To length(teststr) Do
    Begin
      If Not charinSet(teststr[i] , charset) Then
        exit
    End;
  result := true;
End;

//-------------------------------------------------------------
function VarArrayByLinesep(const Line: String; sep: TSeparators;
  KeepQuote: boolean): variant;
// Erzeugt ein Variantes Array

Var
  avar: Array Of variant;
  rest, sect: String;
  i, cnt: integer;

Begin
  cnt := CountSeparators(line, sep);
  If cnt > 0 Then
    Begin
      SetLength(avar, cnt + 1);
      rest := line;
      For i := 0 To cnt Do
        Begin
         {$ifndef SUPPORTS_OUTPARAMS} sect:=''; {$ENDIF}
          testLinesep(rest, sep, sect, rest);
          avar[i] := sect;
        End;
    End
  Else
    Begin
      SetLength(avar, 1);
      avar[0] := line;
    End;
  If KeepQuote And (cnt > 1) Then
    Begin
      rest := '';
      cnt := 0;
      For i := 0 To high(avar) Do
        If (rest = '') Then
          Begin
            inc(Cnt);
            // Quote Angefangen
            If pos(copy(avar[i], 1, 1), '"''') > 0 Then
              rest := copy(avar[i], 1, 1);
            // Quote Beendet (Ab V2.12)
            If (rest <> '') And (copy(avar[i], length(avar[i]), 1) =
              copy(avar[i], 1, 1)) Then
              rest := '';
            // Teil Speichern
            avar[cnt - 1] := avar[i];
          End
        Else
          Begin
            If (copy(avar[i], length(avar[i]), 1) <> rest) Or (length(avar[i]) =
              0) Then
            Else If length(avar[i]) <= 1 Then
              rest := ''
            Else If copy(avar[i], length(avar[i]) - 1, 1) <> rest Then
              rest := ''
            Else If length(avar[i]) <= 2 Then

            Else If copy(avar[i], length(avar[i]) - 2, 1) = rest Then
              rest := '';

            avar[cnt - 1] := avar[cnt - 1] + LineSeparators[sep, 0] + avar[i];
          End;
      SetLength(avar, cnt);
    End;
{$ifndef fpc} // ToDo -oJC : Better define see JEDI.INC
  result := avar;
{$else}
  result := vararrayof( avar);
{$endif}
End;
//-------------------------------------------------------------

function DynArrayByLinesep(const Line: String; sep: TSeparators;
  KeepQuote: boolean): TarrayOfString;
// Erzeugt ein Variantes Array

Var
  avar: TarrayOfString;
  rest, sect: String;
  i, cnt: integer;

Begin
  cnt := CountSeparators(line, sep);
  If cnt > 0 Then
    Begin
      SetLength(avar, cnt + 1);
      rest := line;
      For i := 0 To cnt Do
        Begin
         {$ifndef SUPPORTS_OUTPARAMS} sect:=''; {$ENDIF}
          testLinesep(rest, sep, sect, rest);
          avar[i] := sect;
        End;
    End
  Else
    Begin
      SetLength(avar, 1);
      avar[0] := line;
    End;
  If KeepQuote And (cnt > 1) Then
    Begin
      rest := '';
      cnt := 0;
      For i := 0 To high(avar) Do
        If (rest = '') Then
          Begin
            inc(Cnt);
            // Quote Angefangen
            If pos(copy(avar[i], 1, 1), '"''') > 0 Then
              rest := copy(avar[i], 1, 1);
            // Quote Beendet (Ab V2.12)
            If (rest <> '') And (copy(avar[i], length(avar[i]), 1) =
              copy(avar[i], 1, 1)) Then
              rest := '';
            // Teil Speichern
            avar[cnt - 1] := avar[i];
          End
        Else
          Begin
            If (copy(avar[i], length(avar[i]), 1) <> rest) Or (length(avar[i]) =
              0) Then
            Else If length(avar[i]) <= 1 Then
              rest := ''
            Else If copy(avar[i], length(avar[i]) - 1, 1) <> rest Then
              rest := ''
            Else If length(avar[i]) <= 2 Then

            Else If copy(avar[i], length(avar[i]) - 2, 1) = rest Then
              rest := '';

            avar[cnt - 1] := avar[cnt - 1] + LineSeparators[sep, 0] + avar[i];
          End;
      SetLength(avar, cnt);
    End;
  result := avar;
End;
//-------------------------------------------------------------

function VarArrayByLinesep(const Line: String; seps: TSeparatSet;
  TrimEmpty: boolean; KeepQuote: boolean): variant;
// Erzeugt ein Variantes Array

Var
  avar: Array Of variant;
  rest, sect: String;
  i, cnt: integer;
  rr: String;
  fl: Integer;
  sep: TSeparators;
  tSect,tRest: String;

Begin
  cnt :=0;
  for sep in seps do
    cnt := cnt+ CountSeparators(line, sep);
  If cnt > 0 Then
    Begin
      SetLength(avar, cnt + 1);
      rest := line;
      For i := 0 To cnt Do
        Begin
          fl:=-1;
          sect := '';
          for sep in seps do
            begin
              rr:='';//Workaround
              testLinesep(rest, sep, tSect, rr);
              if (fl =-1) or (length(tSect)<fl) then
                begin
                  sect := tSect;
                  tRest := rr;
                  fl := length(tSect);
                end;
            end;
          rest := trest;
          avar[i] := sect;
        End;
    End
  Else
    Begin
      SetLength(avar, 1);
      avar[0] := line;
    End;
  if TrimEmpty then
    begin
      rest := '';
      cnt := 0;
      i := 0;
      while i <= high(avar) Do
        begin
          if avar[i]<>'' then
            begin
              avar[cnt] := avar[i];
              inc(cnt)
            end;
          inc(i);
        end;
      setlength(avar,cnt);
    end;
  If KeepQuote And (cnt > 1) Then
    Begin
      rest := '';
      cnt := 0;
      For i := 0 To high(avar) Do
        If (rest = '') Then
          Begin
            inc(Cnt);
            // Quote Angefangen
            If pos(copy(avar[i], 1, 1), '"''') > 0 Then
              rest := copy(avar[i], 1, 1);
            // Quote Beendet (Ab V2.12)
            If (rest <> '') And (copy(avar[i], length(avar[i]), 1) =
              copy(avar[i], 1, 1)) Then
              rest := '';
            // Teil Speichern
            avar[cnt - 1] := avar[i];
          End
        Else
          Begin
            If (copy(avar[i], length(avar[i]), 1) <> rest) Or (length(avar[i]) =
              0) Then
            Else If length(avar[i]) <= 1 Then
              rest := ''
            Else If copy(avar[i], length(avar[i]) - 1, 1) <> rest Then
              rest := ''
            Else If length(avar[i]) <= 2 Then

            Else If copy(avar[i], length(avar[i]) - 2, 1) = rest Then
              rest := '';

            avar[cnt - 1] := avar[cnt - 1] + LineSeparators[sep, 0] + avar[i];
          End;
      SetLength(avar, cnt);
    End;
{$ifndef fpc} // ToDo -oJC : Better define see JEDI.INC
  result := avar;
{$else}
  result := vararrayof( avar);
{$endif}
End;
//-------------------------------------------------------------

function DynArrayByLinesep(const Line: String; seps: TSeparatSet;
  TrimEmpty: boolean; KeepQuote: boolean): TarrayOfString;
// Erzeugt ein Variantes Array

Var
  avar: TarrayOfString;
  rest, sect: String;
  i, cnt: integer;
  rr: String;
  fl: Integer;
  sep: TSeparators;
  tSect,tRest: String;

Begin
  cnt :=0;
  for sep in seps do
    cnt := cnt+ CountSeparators(line, sep);
  If cnt > 0 Then
    Begin
      SetLength(avar, cnt + 1);
      rest := line;
      For i := 0 To cnt Do
        Begin
          fl:=-1;
          sect := '';
          for sep in seps do
            begin
              rr:='';//Workaround
              testLinesep(rest, sep, tSect, rr);
              if (fl =-1) or (length(tSect)<fl) then
                begin
                  sect := tSect;
                  tRest := rr;
                  fl := length(tSect);
                end;
            end;
          rest := trest;
          avar[i] := sect;
        End;
    End
  Else
    Begin
      SetLength(avar, 1);
      avar[0] := line;
    End;
  if TrimEmpty then
    begin
      rest := '';
      cnt := 0;
      i := 0;
      while i <= high(avar) Do
        begin
          if avar[i]<>'' then
            begin
              avar[cnt] := avar[i];
              inc(cnt)
            end;
          inc(i);
        end;
      setlength(avar,cnt);
    end;
  If KeepQuote And (cnt > 1) Then
    Begin
      rest := '';
      cnt := 0;
      For i := 0 To high(avar) Do
        If (rest = '') Then
          Begin
            inc(Cnt);
            // Quote Angefangen
            If pos(copy(avar[i], 1, 1), '"''') > 0 Then
              rest := copy(avar[i], 1, 1);
            // Quote Beendet (Ab V2.12)
            If (rest <> '') And (copy(avar[i], length(avar[i]), 1) =
              copy(avar[i], 1, 1)) Then
              rest := '';
            // Teil Speichern
            avar[cnt - 1] := avar[i];
          End
        Else
          Begin
            If (copy(avar[i], length(avar[i]), 1) <> rest) Or (length(avar[i]) =
              0) Then
            Else If length(avar[i]) <= 1 Then
              rest := ''
            Else If copy(avar[i], length(avar[i]) - 1, 1) <> rest Then
              rest := ''
            Else If length(avar[i]) <= 2 Then

            Else If copy(avar[i], length(avar[i]) - 2, 1) = rest Then
              rest := '';

            avar[cnt - 1] := avar[cnt - 1] + LineSeparators[sep, 0] + avar[i];
          End;
      SetLength(avar, cnt);
    End;
  result := avar;
End;
//-------------------------------------------------------------

function strsort(const orig: String; sep: TSeparators; ValidChars: TCharset
  ): String;
// = " ",
// Sortiert einen String
Var
  avar: variant;
  hst: String;
  i: integer;
  // Fuelle daten in das Array

Begin
  If testLinesep(orig, sep) Then
    Begin
      //Bubble Sort
      avar := vararraybyLinesep(orig, sep);
      If (avar <> null) Then
        Begin
          Sort_Bubblesort(avar);
          //Fuelle Daten in String
          hst := avar[0];
          For i := VarArrayLowBound(avar, 1) To VarArrayHighBound(avar, 1) Do
            hst := hst + LineSeparators[sep, 0] + avar[i] + LineSeparators[sep,
              1];
        End
      Else
        hst := orig;
    End
  Else
    hst := orig;
  //Rueckgabe des String
  result := hst;
End;
//-------------------------------------------------------------

{
Function hex2(h:string): Byte;
// wandelt einen Hex-Code in eine Zahl (byte) um
Const HD = '0123456789ABCDEF';
var lsn,msn :integer;

begin
  lsn:= pos(h[1],h);
  if lsn > 0 Then dec(lsn);
  If Length(h) > 1 Then
    begin
      msn := pos(h[2],h);
      if msn > 0 then
        begin
          dec(msn);
          hex2:=lsn*16+msn;
        end
      else
        hex2:=lsn;
    end
  else
    hex2:=lsn;
End ;
}

{$IFDEF SUPPORTS_INT64}
function hex2(h: String; len: integer = -1): int64;
{$ELSE}
Function hex2(h: String; len: integer = -1): integer; overload;
{$ENDIF}
// wandelt einen Hex-Code in eine Zahl (byte) um

Const
  HD = '0123456789ABCDEF';
Var
  {$IFDEF SUPPORTS_INT64}
  h2b: int64;
  {$ELSE}
  h2b: integer;
  {$ENDIF}
  //    neg:boolean;

Begin
  h2b := 0;
  h := StrReplace(h, ' ', '');
  if len>=0 then
    h:= left(h,len);
  While (h <> '') Do
    Begin
      If Length(h) > 0 Then
        h2b := h2b shl 4 + pos(Left(h, 1), hd) - 1;
      h := Middle(h, 2)
    End;
  result := h2b;
End;
//-------------------------------------------------------------

function Text2Filename(text: String): String;
Var
  NewName: String;
  i: integer;

Begin
  NewName := text;
  For i := low(t2fstrings) To high(t2fstrings) Do
    NewName := StrReplace(NewName, t2fstrings[i, 0], t2fstrings[i, 1]);
  Result := NewName;
End;
//-------------------------------------------------------------

function Filename2Text(text: String): String;
Var
  NewName: String;
  i: integer;
Begin
  NewName := Text;
  For i := high(t2fstrings) Downto low(t2fstrings) Do
    If t2fstrings[i, 2] <> #0 Then
      NewName := StrReplace(NewName, t2fstrings[i, 1], t2fstrings[i, 0]);
  Result := NewName;
End;
//-------------------------------------------------------------



function TryFWildcardMatching(Probe, Mask: String): integer;

Var
  apos1: integer;

Begin
  result := 0;
  If mask <> '' Then
    If mask[1] = '*' Then
      Begin
        apos1 := pos(2, '*', mask);
        If apos1 <> 0 Then
          Begin // Match Middle
            result := pos(upcase(copy(Mask, 2, apos1 - 2)), upcase(probe));
            If (0 = TryFWildcardMatching(middle(probe, result), middle(mask, 2)))
              Then
              result := 0;
          End
        Else
          Begin // Match end
            result := length(probe) - length(mask) + 2;
            If UpCase(copy(mask, 2, length(mask) - 1)) <> upcase(copy(probe,
              result, length(mask) - 1)) Then
              result := 0;
          End
      End
    Else
      Begin
        apos1 := pos('*', mask);
        If apos1 <> 0 Then
          Begin // Match Start
            If UpCase(copy(mask, 1, apos1 - 1)) = upcase(copy(probe, 1, apos1 -
              1)) Then
              If (0 <> TryFWildcardMatching(middle(probe, apos1), middle(mask,
                apos1))) Then
                result := 1;
          End
        Else
          Begin // Match Whole
            If UpCase(mask) = upcase(probe) Then
              result := 1;
          End;
      End;
End;

function TryFWildcardMatching(Probe, Mask: String; var Wildcardfill: String
  ): integer;

Var
  apos1: integer;
  // hstr:string;

Begin
  result := 0;
  If mask <> '' Then
    If mask[1] = '*' Then
      Begin
        apos1 := pos(2, '*', mask);
        If apos1 <> 0 Then
          Begin // Match Middle
            result := pos(upcase(copy(Mask, 2, apos1 - 2)), upcase(probe));
            If (0 = TryFWildcardMatching(middle(probe, result), middle(mask, 2),
              wildcardfill)) Then
              result := 0
            Else
              Begin
                apos1 := value(parsestrasprofile(wildcardfill, CSWildCardFill,
                  'Count')) + 1;
                putstrasprofile(wildcardfill, CSWildCardFill, 'Count',
                  inttostr(apos1));
                putstrasprofile(wildcardfill, CSWildCardFill, inttostr(apos1),
                  left(probe, result - 1));
              End;
          End
        Else
          Begin // Match end
            result := length(probe) - length(mask) + 2;
            If UpCase(copy(mask, 2, length(mask) - 1)) <> upcase(copy(probe,
              result, length(mask) - 1)) Then
              result := 0
            Else
              Begin
                putstrasprofile(wildcardfill, CSWildCardFill, 'Count', '1');
                putstrasprofile(wildcardfill, CSWildCardFill, '1', left(probe,
                  result - 1));
              End
          End
      End // if mask[1]= '*' then
    Else
      Begin
        apos1 := pos('*', mask);
        If apos1 <> 0 Then
          Begin // Match Start
            If UpCase(copy(mask, 1, apos1 - 1)) = upcase(copy(probe, 1, apos1 -
              1)) Then
              If (0 <> TryFWildcardMatching(middle(probe, apos1), middle(mask,
                apos1), Wildcardfill)) Then
                result := 1;
          End
        Else
          Begin // Match Whole
            wildcardfill := '';
            If UpCase(mask) = upcase(probe) Then
              result := 1;
          End;
      End; //if mask[1]<> '*' then
End;

Const
  FKenner = '*$#?';

Function getnextwcfunc(start: integer; mask: String; FktKenner: String = FKenner):
  integer; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF ~SUPPORTS_INLINE}

Var
  apos1: integer;
  I: Integer;

Begin
  result := length(mask) + 1;
  For I := 1 To length(FktKenner) Do
    Begin
      apos1 := pos(start, FktKenner[i], mask);
      If apos1 > 0 Then
        result := min(result, apos1);
    End;
End;

function TryFunctionMatching(Probe, Mask: String; var Wildcardfill: String
  ): integer;

Var //apos2,
  apos1: integer;

  Procedure AddFoundFktn(Var wildcardfill: String; Fktnname, txt: String);inline;

  Var
    FktnDesc: String;

  Begin
    Try
      FktnDesc := parsestrasprofile(wildcardfill, 'FunctionChars', Fktnname);
      If FktnDesc = '' Then
        FktnDesc := Fktnname
    Except
      FktnDesc := Fktnname;
    End;
    putstrasprofile(wildcardfill, CSWildCardFill, FktnDesc, txt);
  End; // Sub Function AddFoundFktn

  Function IncGetProfileValue(Var wildcardfill: String; Fktnname: String; Incr:
    integer = 1): integer; inline;

  Begin
    Try
      result := value(parsestrasprofile(wildcardfill, CSWildCardFill, Fktnname))
        + Incr;
    Except
      result := 1;
    End;
    putstrasprofile(wildcardfill, CSWildCardFill, Fktnname, inttostr(result));
  End;

Var
  start: integer;

Begin
  result := 0;
  start := 2;
  If mask <> '' Then
    If mask[1] = '*' Then
      Begin
        If mask[2] = '*' Then
          start := 3;
        apos1 := getnextwcfunc(start, mask);
        If apos1 <= length(mask) Then
          Begin // Match Middle
            result := pos(upcase(copy(Mask, start, apos1 - start)),
              upcase(probe));
            If (mask[2] <> '*') Or (result = 0) Then
              Begin
                If (0 = TryFunctionMatching(middle(probe, result), middle(mask,
                  start), wildcardfill)) Then
                  Begin
                    result := 0
                  End
                Else
                  Begin
                    apos1 := IncGetProfileValue(wildcardfill, 'Count');
                    AddFoundFktn(wildcardfill, inttostr(apos1), left(probe,
                      result - 1));
                  End;
              End
            Else If (0 = TryFunctionMatching(middle(probe, result + 1), mask,
              wildcardfill)) Then
              Begin
                If (0 = TryFunctionMatching(middle(probe, result), middle(mask,
                  start), wildcardfill)) Then
                  Begin
                    result := 0
                  End
                Else
                  Begin
                    apos1 := IncGetProfileValue(wildcardfill, 'Count');
                    AddFoundFktn(wildcardfill, inttostr(apos1), left(probe,
                      result - 1));
                  End;
              End
            Else
              Begin
                apos1 := IncGetProfileValue(wildcardfill, 'Count');
                AddFoundFktn(wildcardfill, inttostr(apos1), left(probe, result -
                  1));
              End;
          End
        Else
          Begin // Match end
            result := length(probe) - length(mask) + 2;
            If UpCase(copy(mask, 2, length(mask) - 1)) <> upcase(copy(probe,
              result, length(mask) - 1)) Then
              result := 0
            Else
              Begin
                putstrasprofile(wildcardfill, CSWildCardFill, 'Count', '1');
                AddFoundFktn(wildcardfill, inttostr(1), left(probe, result -
                  1));
              End
          End
      End
    Else If (mask[1] = '$') And (length(mask) >= 2) Then
      Begin // if (mask[1]= '$') and (length(mask)>=2) then
        apos1 := getnextwcfunc(3, mask);
        If apos1 <= length(mask) Then
          Begin // if apos1 <= length(mask) then ... Match Middle
            result := pos(upcase(copy(Mask, 3, apos1 - 3)), upcase(probe));
            If (0 = TryFunctionMatching(middle(probe, result), middle(mask, 3),
              wildcardfill)) Then
              result := 0
            Else If charInSet(mask[2] , ['#', '$', '*', '?']) Then
              If left(probe, result - 1) <> mask[2] Then
                result := 0
              Else
            Else If mask[2] <> #0 Then
              AddFoundFktn(wildcardfill, mask[2], left(probe, result - 1));
          End // if apos1 <= length(mask) then ... Match Middle
        Else
          Begin //  if apos1 <= length(mask) else ... Match end
            result := length(probe) - length(mask) + 3;
            If UpCase(middle(mask, 3)) <> upcase(right(probe, length(mask) - 2))
              Then
              result := 0
            Else If CharinSet(mask[2] , ['#', '$', '*', '?']) Then
              If left(probe, result - 1) <> mask[2] Then
                result := 0
              Else
            Else If mask[2] <> #0 Then
              AddFoundFktn(wildcardfill, mask[2], left(probe, result - 1));
          End // if apos1 <= length(mask) else ... Match End
      End // if (mask[1]= '$') and (length(mask)>=2) then
    Else If (mask[1] = '#') And (length(mask) >= 2) Then
      Begin // if (mask[1]= '#') and (length(mask)>=2) then
        apos1 := getnextwcfunc(3, mask);
        If apos1 <= length(mask) Then
          Begin // if apos1 <= length(mask) then ... Match Middle
            result := pos(upcase(copy(Mask, 3, apos1 - 3)), upcase(probe));
            If (0 = TryFunctionMatching(middle(probe, result), middle(mask, 3),
              wildcardfill)) Then
              result := 0
            Else If Not teststring(left(probe, result - 1), Ziffern) Then
              result := 0
            Else
              AddFoundFktn(wildcardfill, mask[2], left(probe, result - 1));
          End // if apos1 <= length(mask) then ... Match Middle
        Else
          Begin // // if apos1 <= length(mask) else ... Match end
            result := length(probe) - length(mask) + 3;
            If UpCase(middle(mask, 3)) <> upcase(right(probe, length(mask) - 2))
              Then
              result := 0
            Else If Not teststring(left(probe, result - 1), Ziffern) Then
              result := 0
            Else
              AddFoundFktn(wildcardfill, mask[2], left(probe, result - 1));
          End // if apos1 <= length(mask) else ... Match End
      End // if (mask[1]= '#') and (length(mask)>=2) then
    Else
      Begin
        apos1 := getnextwcfunc(1, mask);
        If apos1 <= length(mask) Then
          Begin // Match Start
            If UpCase(left(mask, apos1 - 1)) = upcase(left(probe, apos1 - 1))
              Then
              If (0 <> TryFunctionMatching(middle(probe, apos1), middle(mask,
                apos1), Wildcardfill)) Then
                result := 1;
          End
        Else
          Begin // Match Whole
            wildcardfill := '';
            If UpCase(mask) = upcase(probe) Then
              result := 1;
          End;
      End;
End;
//-------------------------------------------------------------

function EvalCompareStr(const str1, str2: String): real;
// Bewertet zwei Strings zueinander;
Var
  i, j, MaxJ, MaxI, maxQ, minj, mind, diff: integer;
  bigs, small: String;

Begin
  // Suche noch nach geeigneter Methode;
  If length(str1) >= length(str2) Then
    Begin
      bigs := str1;
      small := str2;
    End
  Else
    Begin
      bigs := str2;
      small := str1;
    End;
  maxI := length(bigs);
  maxJ := Length(small);
  maxQ := (maxI + 1) * maxJ;
  diff := 0;
  If maxQ > 0 Then
    Begin
      For i := 1 To maxI Do
        Begin
          minj := 0;
          mind := MaxI + 1;
          For j := 1 To maxJ Do
            Begin
              If (uppercase(bigs[i]) = uppercase(small[j])) And (min(abs(i - j),
                abs((maxi + J) - (MaxJ + i))) < mind) Then
                Begin
                  mind := min(abs(i - j), abs((maxi + j) - (MaxJ + i)));
                  minj := j;
                End
            End;
          If minj <> 0 Then
            Begin
              diff := diff + mind;
              If bigs[i] <> small[minj] Then
                inc(diff, 1);
              bigs[i] := #0;
              small[minj] := #0;
            End
          Else
            diff := diff + length(bigs) + 1;

        End;
      result := (maxq - diff) / maxQ;
    End
  Else If maxI = MaxJ Then
    result := 1
  Else
    result := 0;
End;
//-------------------------------------------------------------

function CleanPath(path: String): String;

Var
  pppos: integer;

Begin
  pppos := pos(2,'..\', path);
  While pppos > 0 Do
    Begin
      path := ExtractFilePath(left(path, pppos - 2)) + middle(path, pppos + 3);
      pppos := pos(2,'..\', path);
    End;
  result := path;
End;
//-------------------------------------------------------------

function GetSoundex(org: String): String;

Var
  i, d: byte;
  neu: String;

Begin
  {*k 1 }
{$IFDEF debug}
  inc(Stacktiefe);
  DebugLine('Unt_StringProcs.GetSoundEx: Start', UC_StrTrimm, 2);
{$ENDIF}
  i := 1;
  neu := '';
  org := LowerCase(org);
  While i <= length(org) Do
    If CharInSet(org[i] , Charset) Then
      Begin
        d := ord(org[i]) Or 32;
        If d > 127 Then
          d := 41
        Else
          d := ((d - 96) * 39) Div 26;
        While (d < maxkomb) And
          (copy(org + '  ', i, length(Soundex[d].komb)) <> Soundex[d].komb)
          And (org[i] >= Soundex[d].komb[1]) Do
          inc(d);
        If copy(org + '  ', i, length(Soundex[d].komb)) <> Soundex[d].komb Then
          assert(false, org[i] + ' nicht gefunden ! ' + inttostr(ord(org[i])) +
            #10#13 + 'd ist ' + inttostr(d) + ' (' + Soundex[d].komb + ')')
        Else If Length(neu) = 0 Then
          neu := neu + Soundex[d].Sal
        Else If neu[Length(neu)] <> Soundex[d].Sal Then
          neu := neu + Soundex[d].Sal;
        i := i + length(Soundex[d].komb);
      End
    Else
      Begin
        Neu := neu + org[i];
        inc(i)
      End;
  Result := neu;
{$IFDEF debug}
  DebugLine('Unt_StringProcs.GetSoundEx: Ende', UC_StrTrimm, 2);
  dec(Stacktiefe);
{$ENDIF}
  {*k 1 }
End;
//-------------------------------------------------------------

function BuildStringByFunction(Mask, Wildcardfill: String): String;
// Not Testet Yet
Var
  i: Integer;
  HStr: String;

Begin
  result := mask;
  i := getnextwcfunc(1, Result, '$#');
  While (i > 0) And (i < length(result)) Do
    Begin
      If Charinset(result[i + 1] , ['$', '#']) Then
        Hstr := result[i + 1]
      Else
        HStr := parseStrasProfile(Wildcardfill, CSWildCardFill, result[i + 1]);
      result := copy(result, 1, i - 1) + Hstr + copy(result, i + 2,
        length(result) - i);
      i := getnextwcfunc(i + length(hstr), Result, '$#');
    End;
End;
//-------------------------------------------------------------

function Str2QHtml(s: String): String;
Var
  i: Integer;
Begin
  result := s;
  For i := 0 To High(str2htmldef) Do
    StringReplace(result, Str2Htmldef[i, 0], Str2Htmldef[i, 1], [rfReplaceAll])
End;

{$IFDEF DECL_CHARINSET}
function CharInSet(C: Char; Cset: TCharset): boolean;

begin
  result := c in cset;
end;
{$ENDIF}

function aos2TArrayOfString(aos: array of String): TarrayOfString;

var
  i: Integer;
begin
  setlength(result,succ(high(aos)));
  for i := 0 to high(aos) do
    result[i] := aos[i];
end;



End.
