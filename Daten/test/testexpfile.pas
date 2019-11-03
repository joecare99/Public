unit testExpFile;

{$IFDEF FPC}
  {$mode delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  {$IFDEF FPC}
  fpcunit, testregistry,
  {$ELSE}
  testframework,
  {$ENDIF}
  Cmp_SEWFile;

type

  { TTestCase1 }

  TTestCase1 = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  private
    FDataDir: string;
    FExpFile: TSEW_Exp_File;
    FKnownIdentifyer: TKnownIdentifyerList;
    procedure CheckEqualsTS(const Expected: string; const Actual: TStrings;
      const AMessage: string);
    function LoadfromFileToUTF8(Filename: STRING): string;

  published
    procedure TestDisplayname;
    procedure TestFileExtensions;
    procedure TestGetFileInfoStr;
    procedure TestGetFileOpenFilter;

    procedure TestParseCode1;
    procedure TestParseCode2;
    procedure TestParseCode2a;
    procedure TestParseCode2b;
    procedure TestParseCode3;

    procedure TestFormatCode1;
    procedure TestFormatCode2;
    procedure TestFormatCode3;
    procedure TestFormatCode3a;
    procedure TestFormatCode4;
    procedure TestFormatCode5;
    procedure TestFormatCode6;
    procedure TestFormatCode7;
    procedure TestFormatCode8;
    procedure TestFormatCode8a;
    procedure TestFormatCode9;
    procedure TestFormatCode9a;
    procedure TestFormatCode9b;
    procedure TestFormatCode10;
    procedure TestFormatCode10a;
    procedure TestFormatCode10b;
    procedure TestFormatCode11;
    procedure TestFormatCode12;
    procedure TestFormatCode13;
    procedure TestFormatCode14;

    procedure TestAutoFormatLine1;
    procedure TestAutoFormatLine2;
    procedure TestAutoFormatStringConst;
    procedure TestAutoformat1;
    procedure TestAutoformat2;

    procedure TestAutoformatFile1;
    procedure TestAutoformatFile2;
    procedure TestAutoformatFile3;
    procedure TestAutoformatFile4;
    procedure TestAutoformatFile5;
    procedure TestAutoformatFile6;
    procedure TestAutoformatFile7;
    procedure TestAutoformatFile8;
    procedure TestAutoformatFile9;
  end;

implementation

uses Unt_Stringprocs, LConvEncoding;

{$IFNDEF FPC}
const
  LineEnding = vbNewline;
  DirectorySeparator = '\';
{$ENDIF}

resourcestring
  DefDataDir = 'Data';
  ExpFile1 =
    '(* @NESTEDCOMMENTS := ''Yes'' *)' + LineEnding +
    '(* @PATH := ''\/SRL\/IEC_Interface'' *)' + LineEnding +
    '(* @OBJECTFLAGS := ''0, 8'' *)' + LineEnding + '(* @SYMFILEFLAGS := ''2048'' *)' +
    LineEnding + 'FUNCTION IEC_IO: BOOL' + LineEnding + 'VAR_INPUT  ' +
    LineEnding + 'END_VAR' + LineEnding + 'VAR' + LineEnding +
    'END_VAR   ' + LineEnding + 'VAR_IN_OUT' + LineEnding + LineEnding +
    'END_VAR' + LineEnding + LineEnding + '(* @END_DECLARATION := ''0'' *)' +
    LineEnding + ';' + LineEnding + 'END_FUNCTION';
  ExpectedFile1 = '[SEW-Exp-File]' + LineEnding + 'nestedcomments=Yes' +
    LineEnding + 'path=\SRL\IEC_Interface' + LineEnding + 'objectflags=0, 8' +
    LineEnding + 'symfileflags=2048' + LineEnding + 'type=Block' +
    LineEnding + 'name=IEC_IO' + LineEnding + LineEnding + '[WildCardFill]' +
    LineEnding + 'n=Yes' + LineEnding + 'p=\SRL\IEC_Interface' +
    LineEnding + 'o=0, 8' + LineEnding + 's=2048' + LineEnding +
    't=Block' + LineEnding + 'n=IEC_IO' + LineEnding;
  ExpectedFileFF1 =
    '(* @NESTEDCOMMENTS := ''Yes'' *)' + LineEnding +
    '(* @PATH := ''\/SRL\/IEC_Interface'' *)' + LineEnding +
    '(* @OBJECTFLAGS := ''0, 8'' *)' + LineEnding + '(* @SYMFILEFLAGS := ''2048'' *)' +
    LineEnding + 'FUNCTION IEC_IO: BOOL' + LineEnding +
    '(*---------------------------------------------------------------------*' +
    LineEnding + '*	Function: ' + LineEnding + '*	Author: J. Marx' +
    LineEnding + '*	Option: ' + LineEnding + '*	Date: ' + LineEnding +
    '*	Version: 1.0' + LineEnding +
    '*----------------------------------------------------------------------*' +
    LineEnding + '*	Info: ' + LineEnding +
    '*----------------------------------------------------------------------*' +
    LineEnding + 'Änderungen:' + LineEnding + LineEnding +
    '*----------------------------------------------------------------------*)' +
    LineEnding + 'VAR_INPUT' + LineEnding + 'END_VAR' + LineEnding +
    'VAR' + LineEnding + 'END_VAR' + LineEnding + 'VAR_IN_OUT' +
    LineEnding + LineEnding + 'END_VAR' + LineEnding + LineEnding +
    '(* @END_DECLARATION := ''0'' *)' + LineEnding + ';' + LineEnding +
    'END_FUNCTION' + LineEnding;
  ExpFile2 =
    '(* @NESTEDCOMMENTS := ''Yes'' *)' + LineEnding +
    '(* @GLOBAL_VARIABLE_LIST := ''Konfiguration'' *)' + LineEnding +
    '(* @PATH := ''\/Projekt\/Kundenspezifisch'' *)' + LineEnding +
    '(* @OBJECTFLAGS := ''0, 8'' *)' + LineEnding + '(* @SYMFILEFLAGS := ''2048'' *)' +
    LineEnding + 'VAR_GLOBAL CONSTANT' + LineEnding +
    '(*---------------------------------------------------------------------*' +
    LineEnding + '*	Function:' + LineEnding + '*	Author: J. Marx' +
    LineEnding + '*	Option:' + LineEnding + '*	Date:' + LineEnding +
    '*	Version: 1.0' + LineEnding +
    '*----------------------------------------------------------------------*' +
    LineEnding + '*	Info: ' + LineEnding +
    '*----------------------------------------------------------------------*' +
    LineEnding + 'Änderungen:' + LineEnding + LineEnding +
    '*----------------------------------------------------------------------*)' +
    LineEnding +
    '	PAT_AQuality                  :   ARRAY[   0 .. PAT_Last ]OF enumAuftragsQualitaet := AQ_SP, (* Stellplatz *)'
    + LineEnding + '	AQ_RP,                        (*  Ruestplatz *)' +
    LineEnding + '	AQ_MA,                        (*  Maschine *)' +
    LineEnding + '	AQ_MA,                        (*  EGS      *)' +
    LineEnding + '	AQ_WaMa,                      (*  Waschmaschine *)' +
    LineEnding + '	AQ_Last                       ;  ' + LineEnding +
    '	                             ' + LineEnding +
    '(* Kennung der Einzelnen Plätze ob und welcher Sonderplatz und Erlaubnis der einzelnen Paletten-Typen *)'
    + LineEnding +
    '	PlatzTypCfg                   :   ARRAY[   -1 .. PlT_Last ]OF udtPlatzConfig :=' +
    LineEnding + '(*						SP-Nummer						 		Univ.	H800, 	H1250, 	WK, 	Sonst *)' +
    LineEnding + '	(*None*)' + LineEnding + '	(' + LineEnding +
    '			SP_Nr        :=  SPN_None,' + LineEnding + '		AllowedPType := FALSE,' +
    LineEnding + '		FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE ),' + LineEnding + '(* Standard 0-9 *)' +
    LineEnding + '	(*Manipulator*)' + LineEnding + '	(' + LineEnding +
    '			SP_Nr :=  SPN_Manipulator,' + LineEnding + '		AllowedPType := FALSE,' +
    LineEnding + '		TRUE,' + LineEnding + '		TRUE,' + LineEnding +
    '		TRUE,' + LineEnding + '		TRUE,' + LineEnding + '		FALSE ), (*Rüstplatz1*)' +
    LineEnding + '	(	SP_Nr := SPN_Ruestplatz1,' + LineEnding +
    '		AllowedPType := FALSE,' + LineEnding + '		TRUE,' + LineEnding +
    '		TRUE,' + LineEnding + '		TRUE,' + LineEnding + '		TRUE,' +
    LineEnding + '		FALSE ), (*Rüstplatz1*)' + LineEnding +
    '	(	SP_Nr := SPN_Ruestplatz2,' + LineEnding + '		AllowedPType := FALSE,' +
    LineEnding + '		TRUE,' + LineEnding + '		TRUE,' + LineEnding +
    '		TRUE,' + LineEnding + '		TRUE,' + LineEnding + '		FALSE ), (*NBH1Wx*)' +
    LineEnding + '	(	SP_Nr := SPN_Maschine1,' + LineEnding +
    '		AllowedPType := FALSE,' + LineEnding + '		TRUE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE,' + LineEnding + '		FALSE,' +
    LineEnding + '		FALSE ), (*NBH1ApcMa*)' + LineEnding +
    '	(	SP_Nr := SPN_Maschine1,' + LineEnding + '		AllowedPType := FALSE,' +
    LineEnding + '		FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE ), (*NBH1DirBlMa*)' + LineEnding + '	(	SP_Nr := SPN_Maschine1,' +
    LineEnding + '		AllowedPType := FALSE,' + LineEnding + '		TRUE,' +
    LineEnding + '		FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE ), (*NBH2Wx*)' + LineEnding +
    '	(	SP_Nr := SPN_Maschine2,' + LineEnding + '		AllowedPType := FALSE,' +
    LineEnding + '		TRUE,' + LineEnding + '		FALSE,' + LineEnding +
    '		TRUE,' + LineEnding + '		FALSE,' + LineEnding + '		FALSE ), (*NBH2ApcMa*)' +
    LineEnding + '	(	SP_Nr := SPN_Maschine2,' + LineEnding +
    '		AllowedPType := FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE,' + LineEnding + '		FALSE,' +
    LineEnding + '		FALSE ), (*NBH2DirBlMa*)' + LineEnding +
    '	(	SP_Nr := SPN_Maschine2,' + LineEnding + '		AllowedPType := FALSE,' +
    LineEnding + '		TRUE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE ), (*StdStellplatz*)' + LineEnding + '	(	SP_Nr := SPN_None,' +
    LineEnding + '		AllowedPType := FALSE,' + LineEnding + '		TRUE,' +
    LineEnding + '		FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE ), (* Option: 10-19 *)' +
    LineEnding + '	(*                            Last*)' + LineEnding +
    '	(' + LineEnding + '			SP_Nr :=       SPN_None,' + LineEnding +
    '		AllowedPType := FALSE,' + LineEnding + '		FALSE,' + LineEnding +
    '		FALSE,' + LineEnding + '		FALSE,' + LineEnding + '		FALSE,' +
    LineEnding + '		FALSE );' + LineEnding + '	                             ' +
    LineEnding + 'END_VAR' + LineEnding + LineEnding +
    '(* @OBJECT_END := ''Konfiguration'' *)' + LineEnding +
    '(* @CONNECTIONS := Konfiguration' + LineEnding + 'FILENAME : ''''' +
    LineEnding + 'FILETIME : 0' + LineEnding + 'EXPORT : 0' +
    LineEnding + 'NUMOFCONNECTIONS : 0' + LineEnding + '*)' + LineEnding;
  ExpectedFile2 =
    '[SEW-Exp-File]' + LineEnding + 'nestedcomments=Yes' + LineEnding +
    'global_variable_list=Konfiguration' + LineEnding +
    'path=\Projekt\Kundenspezifisch' + LineEnding + 'objectflags=0, 8' +
    LineEnding + 'symfileflags=2048' + LineEnding + 'type=Ressource' +
    LineEnding + 'function=' + LineEnding + 'author=J. Marx' + LineEnding +
    'option=' + LineEnding + 'date=' + LineEnding + 'version=1.0' +
    LineEnding + 'info=' + LineEnding + 'changes=' + LineEnding +
    LineEnding + '[WildCardFill]' + LineEnding + 'n=Yes' + LineEnding +
    'g=Konfiguration' + LineEnding + 'p=\Projekt\Kundenspezifisch' +
    LineEnding + 'o=0, 8' + LineEnding + 's=2048' + LineEnding +
    't=Ressource' + LineEnding + 'f=' + LineEnding + 'a=J. Marx' +
    LineEnding + 'o=' + LineEnding + 'd=' + LineEnding + 'v=1.0' +
    LineEnding + 'i=' + LineEnding + 'c=' + LineEnding;
  ExpectedFileFF2 = '(* @NESTEDCOMMENTS := ''Yes'' *)' + LineEnding +
    '(* @GLOBAL_VARIABLE_LIST := ''Konfiguration'' *)' + LineEnding +
    '(* @PATH := ''\/Projekt\/Kundenspezifisch'' *)' + LineEnding +
    '(* @OBJECTFLAGS := ''0, 8'' *)' + LineEnding + '(* @SYMFILEFLAGS := ''2048'' *)' +
    LineEnding + 'VAR_GLOBAL CONSTANT' + LineEnding +
    '(*---------------------------------------------------------------------*' +
    LineEnding + '*	Function:' + LineEnding + '*	Author: C. Rosewich' +
    LineEnding + '*	Option:' + LineEnding + '*	Date:' + LineEnding +
    '*	Version: 1.1' + LineEnding +
    '*----------------------------------------------------------------------*' +
    LineEnding + '*	Info: ' + LineEnding +
    '*----------------------------------------------------------------------*' +
    LineEnding + 'Änderungen:' + LineEnding + LineEnding +
    '*----------------------------------------------------------------------*)' +
    LineEnding +
    '	PAT_AQuality :   ARRAY[   0 .. PAT_Last ]OF enumAuftragsQualitaet	:= AQ_SP,	(* Stellplatz *)'
    + LineEnding + '	AQ_RP,	(*       Ruestplatz *)' + LineEnding +
    '	AQ_MA,	(*       Maschine *)' + LineEnding + '	AQ_MA,	(*       EGS           *)' +
    LineEnding + '	AQ_WaMa,	(*     Waschmaschine *)' + LineEnding +
    '	AQ_Last;' + LineEnding + LineEnding +
    '(* Kennung der Einzelnen Plätze ob und welcher Sonderplatz und Erlaubnis der einzelnen Paletten-Typen *)'
    + LineEnding + '	PlatzTypCfg :   ARRAY[   -1 .. PlT_Last ]OF udtPlatzConfig	:=' +
    LineEnding + '(*						SP-Nummer						 		Univ.	H800, 	H1250, 	WK, 	Sonst *)' +
    LineEnding + '(*None*)' + LineEnding +
    '	(	SP_Nr	:=  SPN_None,	AllowedPType	:= FALSE,	FALSE,	FALSE,	FALSE,	FALSE ),' +
    LineEnding + '(* Standard 0-9 *)' + LineEnding + '(*Manipulator*)' +
    LineEnding +
    '	(	SP_Nr	:=  SPN_Manipulator,	AllowedPType	:= FALSE,	TRUE,	TRUE,	TRUE,	TRUE,	FALSE ),	(*Rüstplatz1*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Ruestplatz1,	AllowedPType	:= FALSE,	TRUE,	TRUE,	TRUE,	TRUE,	FALSE ),	(*Rüstplatz1*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Ruestplatz2,	AllowedPType	:= FALSE,	TRUE,	TRUE,	TRUE,	TRUE,	FALSE ),	(*NBH1Wx*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Maschine1,	AllowedPType	:= FALSE,	TRUE,	FALSE,	FALSE,	FALSE,	FALSE ),	(*NBH1ApcMa*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Maschine1,	AllowedPType	:= FALSE,	FALSE,	FALSE,	FALSE,	FALSE,	FALSE ),	(*NBH1DirBlMa*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Maschine1,	AllowedPType	:= FALSE,	TRUE,	FALSE,	FALSE,	FALSE,	FALSE ),	(*NBH2Wx*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Maschine2,	AllowedPType	:= FALSE,	TRUE,	FALSE,	TRUE,	FALSE,	FALSE ),	(*NBH2ApcMa*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Maschine2,	AllowedPType	:= FALSE,	FALSE,	FALSE,	FALSE,	FALSE,	FALSE ),	(*NBH2DirBlMa*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_Maschine2,	AllowedPType	:= FALSE,	TRUE,	FALSE,	FALSE,	FALSE,	FALSE ),	(*StdStellplatz*)'
    + LineEnding +
    '	(	SP_Nr	:=  SPN_None,	AllowedPType	:= FALSE,	TRUE,	FALSE,	FALSE,	FALSE,	FALSE ),	(* Option: 10-19 *)'
    + LineEnding + '(*                            Last*)' + LineEnding +
    '	(	SP_Nr	:=  SPN_None,	AllowedPType	:= FALSE,	FALSE,	FALSE,	FALSE,	FALSE,	FALSE );'
    +
    LineEnding + LineEnding + 'END_VAR' + LineEnding + LineEnding +
    '(* @OBJECT_END := ''Konfiguration'' *)' + LineEnding +
    '(* @CONNECTIONS := Konfiguration' + LineEnding + 'FILENAME : ''''' +
    LineEnding + 'FILETIME : 0' + LineEnding + 'EXPORT : 0' +
    LineEnding + 'NUMOFCONNECTIONS : 0' + LineEnding + '*)' + LineEnding;

Function TTestCase1.LoadfromFileToUTF8(Filename: STRING):string;
 var s,lFileEncoding:string;
     sf:TFileStream;
  BEGIN
    sf:=TFileStream.Create(Filename,fmOpenRead);
    try
      setlength(s,sf.Size);
      sf.ReadBuffer(s[1],sf.Size);
      lFileEncoding := GuessEncoding(s);
      result:=ConvertEncoding(s,lFileEncoding,EncodingUTF8);
    finally
      freeandnil(sf);
    end;
  END;

procedure TTestCase1.TestDisplayname;
begin
  CheckEquals('SEW-Export-Datei', Fexpfile.DisplayName, 'Displayname');
end;

procedure TTestCase1.TestFileExtensions;
begin
  CheckEquals(1, high(FExpFile.Extensions) + 1, 'Extensions-Anzahl');
  checkequals('.EXP', FExpFile.Extensions[0], 'Extension[0]');
end;

procedure TTestCase1.TestGetFileInfoStr;

var
  fn: string;
  ltf: Text;

begin
  fn := FDataDir + DirectorySeparator + 'File' + IntToStr(Random(10000)) + '.EXP';
  AssignFile(ltf, fn);
  Rewrite(ltf);
  try
    Write(ltf, ExpFile1);
    CloseFile(ltf);
    CheckEquals(ExpectedFile1, FExpFile.GetFileInfoStr(fn), 'FileInfo File1');
  finally
    DeleteFile(fn);
  end;
  fn := FDataDir + DirectorySeparator + 'File' + IntToStr(Random(10000)) + '.EXP';
  AssignFile(ltf, fn);
  Rewrite(ltf);
  try
    Write(ltf, ExpFile2);
    CloseFile(ltf);
    CheckEquals(ExpectedFile2, FExpFile.GetFileInfoStr(fn), 'FileInfo File2');
  finally
    DeleteFile(fn);
  end;
end;

procedure TTestCase1.TestParseCode1;
var
  lPsm: TParseMode;
  lIndent: integer;
  bb: boolean;
  lb: boolean;
begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  lb := False;
  CheckEquals('VAR ', ParseCode('VAR', bb, lb, lPsm), 'Var -> Var-Parsemode');
  CheckEquals(Ord(psm_VarStart), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
  CheckEquals('END_VAR ', ParseCode('END_VAR', bb, lb, lPsm), 'Var -> Var-Parsemode');
  CheckEquals(Ord(psm_var), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestParseCode2;
var
  lPsm: TParseMode;
  lIndent: integer;
  bb: boolean;
  lb: boolean;
begin
  lPsm := psm_var;
  lIndent := 1;
  Push(psm_Normal, 0);
  lb := False;
  CheckEquals('{bitaccess ', ParseCode('{bitaccess', bb, lb, lPsm), 'Var -> Bitaccess');
  CheckEquals(Ord(psm_Bitaccess), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
  CheckEquals('	"Ende"}', FormatCode('"Ende"}', lindent, lpsm), 'Bitaccess -> var');
  CheckEquals(Ord(psm_var), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');

end;

procedure TTestCase1.TestParseCode2a;
var
  lPsm: TParseMode;
  lIndent: integer;
  bb: boolean;
  lb: boolean;
begin
  lPsm := psm_var;
  lIndent := 1;
  Push(psm_Normal, 0);
  lb := False;
  CheckEquals('{bitaccess ', ParseCode('{bitaccess', bb, lb, lPsm), 'Var -> Bitaccess');
  CheckEquals(Ord(psm_Bitaccess), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
  CheckEquals('	"Ende(-Test"}', FormatCode('"Ende(-Test"}', lindent, lpsm),
    'Bitaccess -> var');
  CheckEquals(Ord(psm_var), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');

end;

procedure TTestCase1.TestParseCode2b;
begin
  FExpFile.Lines.Text :=
    'VAR {bitaccess test 1 "Ende(-Test"} {bitaccess test2 2 "Ende(-Test2"} END_VAR';
  FExpFile.AutoFormat;
  checkEquals('VAR' + LineEnding + '{bitaccess   test       1        "Ende(-Test"}' +
    LineEnding + '{bitaccess   test2      2        "Ende(-Test2"}' +
    LineEnding + 'END_VAR' + LineEnding, FExpFile.Lines.Text, 'TestParseCode2a');
end;

procedure TTestCase1.TestParseCode3;
var
  lPsm: TParseMode;
  lIndent: integer;
  bb: boolean;
  lb: boolean;
begin
  lPsm := psm_var;
  lIndent := 1;
  Push(psm_Normal, 0);
  lb := False;
  CheckEquals('t:STRING[5]:='';'';(*cc*) ', ParseCode(
    't:STRING[5]:='';'';(*cc*)', bb, lb, lPsm), 'var -String');
  CheckEquals(Ord(psm_var), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode1;
var
  lPsm: TParseMode;
  lIndent: integer;
begin

  lPsm := psm_Var;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals('	(	SP_Nr	:= SPN_None,	AllowedPType	:= FALSE,	FALSE,	FALSE,	FALSE,	FALSE ),',
    FormatCode('( SP_Nr:=SPN_None,AllowedPType:=FALSE,FALSE,FALSE,FALSE,FALSE),',
    lindent, lpsm), 'Format Code 1');
  CheckEquals(Ord(psm_Var), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode2;
var
  lPsm: TParseMode;
  lIndent: integer;
begin

  lPsm := psm_normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(
    '	TestProc(' + LineEnding + '		a	:= 15,' + LineEnding + '		b	:= 23 );',
    FormatCode('TestProc(a:=15,b:=23);', lindent, lpsm), 'Format Code 2 (Procedure)');
  CheckEquals(Ord(psm_normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode3;
var
  lPsm: TParseMode;
  lIndent: integer;
begin

  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(
    '	vv	:=' + LineEnding + '		fcTestFunc(' + LineEnding +
    '			par1	:= (	mode = mc_test ),' + LineEnding + '			par2	:= 23 );',
    FormatCode('vv:=fcTestFunc(par1:=(mode=mc_test),par2:=23);', lindent, lpsm),
    'Format Code 3 (Function)');
  CheckEquals(Ord(psm_normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode3a;
var
  lPsm: TParseMode;
  lIndent: integer;

const
  OCode1 = 'StoerMeld.E700504:= fcSETimer( Anforderung:=(Sicherheit.Sicherheit_Extern OR '
    + 'Eingaenge.iEndlTuerGeschlossen ) AND NOT Sicherheit.Hardware_Frg_IO_verl AND ' +
    'NOT Sicherheit.Not_Aus_NIO_verz AND NOT Sicherheit.Schutzbereich_NIO_verz, ' +
    'Zeitvorgabe:=2500, (* 2.5 s*)';
  OCode2 = 'Gruppe:=Gruppe, Zeitspeicher:= Tmr_e700504_Sicherheit_NIO );';
  FCode1 =
    '	StoerMeld.E700504	:=' + LineEnding + '		fcSETimer(' + LineEnding +
    '			Anforderung	:=' + LineEnding + '				(	Sicherheit.Sicherheit_Extern OR' +
    LineEnding + '					Eingaenge.iEndlTuerGeschlossen ) AND' + LineEnding +
    '				NOT Sicherheit.Hardware_Frg_IO_verl AND' + LineEnding +
    '				NOT Sicherheit.Not_Aus_NIO_verz AND' + LineEnding +
    '				NOT Sicherheit.Schutzbereich_NIO_verz,' + LineEnding +
    '			Zeitvorgabe	:= 2500, (* 2.5 s*)';
  FCode2 =
    '			Gruppe	:= Gruppe,' + LineEnding +
    '			Zeitspeicher	:= Tmr_e700504_Sicherheit_NIO );';

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(FCode1,
    FormatCode(OCode1, lindent, lpsm), 'Format Code 3a1 (Function)');
  CheckEquals(Ord(psm_ProcParam), Ord(lPsm), 'Parsmode');
  CheckEquals(3, lIndent, 'Indent');
  CheckEquals(FCode2,
    FormatCode(OCode2, lindent, lpsm), 'Format Code 3a2 (Function)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;


procedure TTestCase1.TestFormatCode4;
var
  lPsm: TParseMode;
  lIndent: integer;
begin

  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(
    '	vv	:=' + LineEnding + '	hh	:=' + LineEnding + '		TRUE;',
    FormatCode('vv:=hh:=TRUE;', lindent, lpsm), 'Format Code 4 (DoppelZuw.)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode5;
var
  lPsm: TParseMode;
  lIndent: integer;

const
  TestCode =
    'Anf_Plus_Fahren :=( ( Gruppe.BA_Hand AND OPZeile.TastePlus ) OR ' +
    '( Gruppe.BA_Automatik AND OPZeile.BefehlAutoPlus AND ' +
    'Gruppe.AutomatikGestartet ) ) AND ( NOT OPZeile.EndlagePlus OR ' +
    'Gruppe.BA_Hand_Ohne_Verr );';
  ExpCode =
    '	Anf_Plus_Fahren	:=' + LineEnding + '		(	(	Gruppe.BA_Hand AND' +
    LineEnding + '				OPZeile.TastePlus ) OR' + LineEnding +
    '			(	Gruppe.BA_Automatik AND' + LineEnding + '				OPZeile.BefehlAutoPlus AND' +
    LineEnding + '				Gruppe.AutomatikGestartet ) ) AND' + LineEnding +
    '		(	NOT OPZeile.EndlagePlus OR' + LineEnding + '			Gruppe.BA_Hand_Ohne_Verr );';

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(ExpCode, FormatCode(TestCode, lindent, lpsm), 'Format Code 5 (Logic)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode6;
var
  lPsm: TParseMode;
  lIndent: integer;

const
  TestCode =
    'StoerMeld.Err_KeineFreigabe := StoerMeld.Err_KeineFreigabe OR fcSETimer( ' +
    'Anforderung := StoerMeld.Mld_KeineFreigabePlus OR StoerMeld.Mld_KeineFreigabeMinus, '
    + 'Zeitvorgabe := 30000, Gruppe := Gruppe, Zeitspeicher := tmrSEKeineFreigabe );';
  ExpCode =
    '	StoerMeld.Err_KeineFreigabe	:= StoerMeld.Err_KeineFreigabe OR' +
    LineEnding + '		fcSETimer(' + LineEnding +
    '			Anforderung	:= StoerMeld.Mld_KeineFreigabePlus OR' + LineEnding +
    '				StoerMeld.Mld_KeineFreigabeMinus,' + LineEnding +
    '			Zeitvorgabe	:= 30000,' + LineEnding + '			Gruppe	:= Gruppe,' +
    LineEnding + '			Zeitspeicher	:= tmrSEKeineFreigabe );';

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(ExpCode, FormatCode(TestCode, lindent, lpsm),
    'Format Code 6 (Logic & Fn)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode7;
var
  lPsm: TParseMode;
  lIndent: integer;

const
  TestCode =
    'Restweg := AxisGroupKin.KinControl.INTERNAL.ConsistentInput.TargPos[ MX_AchsNr ] - '
    +
    'AxisGroupKin.KinControl.out.Data.Position[ MX_AchsNr ];';
  ExpCode =
    '	Restweg	:=' + LineEnding +
    '		AxisGroupKin.KinControl.INTERNAL.ConsistentInput.TargPos[ MX_AchsNr ] -' +
    LineEnding + '		AxisGroupKin.KinControl.out.Data.Position[ MX_AchsNr ];';

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(ExpCode, FormatCode(TestCode, lindent, lpsm),
    'Format Code 7 (Zuweisung2)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode8;
var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals('	a	:= -1;', FormatCode('A:=- 1;', lindent, lpsm, FKnownIdentifyer),
    'Format Code 8.1 (Zuweisung3a)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
  CheckEquals('	a	:= 5 - 1;', FormatCode('A:=5-1;', lindent, lpsm, FKnownIdentifyer),
    'Format Code 8.2 (Zuweisung3b)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode8a;
var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals('	a	:= a -' + LineEnding + '		(	1 * b );', FormatCode(
    'a:=a-(1*b);', lindent, lpsm), 'Format Code 8.1 (Zuweisung3a)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
  CheckEquals('	a	:=' + LineEnding + '		b -' + LineEnding + '		(	1 * c );',
    FormatCode('A:=B-(1*C);', lindent, lpsm, FKnownIdentifyer),
    'Format Code 8.2 (Zuweisung3b)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(1, lIndent, 'Indent');
end;

procedure TTestCase1.TestFormatCode9;
var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(
    #9'IF'#9'a OR' + LineEnding + #9#9'('#9'b AND' + lineending +
    #9#9#9'c ) THEN', FormatCode('IF A OR (B AND C)THEN', lindent,
    lpsm, FKnownIdentifyer),
    'Format Code 9.1 (Boolsche Verkn.)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(2, lIndent, 'Indent');
  lIndent := 1;

end;

procedure TTestCase1.TestFormatCode9a;
var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(#9'IF'#9'('#9'b ) OR' + LineEnding + #9#9'('#9'a AND' +
    lineending + #9#9#9'('#9'd OR' + lineending + #9#9#9#9'c ) ) THEN',
    FormatCode('IF(b)OR(a AND(d OR C))THEN', lindent, lpsm, FKnownIdentifyer),
    'Format Code 9.2 (Boolsche Verkn. 2)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), 'Parsmode');
  CheckEquals(2, lIndent, 'Indent');
  lIndent := 1;

end;

procedure TTestCase1.TestFormatCode9b;
var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(#9'IF'#9'('#9'a = b ) AND (* Test', FormatCode(
    'IF(A=B)AND(* Test', lindent, lpsm, FKnownIdentifyer),
    'Format Code 9.3 IF & Open Comment');
  CheckEquals(Ord(psm_normal), Ord(lPsm), 'Parsmode');
  CheckEquals(2, lIndent, 'Indent');
  lIndent := 1;

end;


procedure TTestCase1.TestFormatCode10;

const
  TestCode = 't:STRING[5]:='';'';(*cc*)';
  ExpCode = #9't : STRING[ 5 ]'#9':= '';'';(*cc*)';
  TestCname = 'Format Code 10';

var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Var;
  lIndent := 1;
  Push(psm_Var, 0);
  CheckEquals(ExpCode, FormatCode(TestCode, lindent, lpsm),  TestCname+ ' (String-dekl)');
  CheckEquals(Ord(psm_Var), Ord(lPsm), TestCname+ ' Parsmode');
  CheckEquals(1, lIndent, TestCname+ ' Indent');
  lIndent := 1;
end;

procedure TTestCase1.TestFormatCode10a;

const
  TestCode = 't:=''<[{r}]> '';';
  ExpCode = #9't'#9':= ''<[{r}]> '';';
  TestCname = 'Format Code 10b';

var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(format(ExpCode,[LineEnding]),
    FormatCode(TestCode, lindent, lpsm), TestCname + ' (Zuweisung)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), TestCname + ' Parsmode');
  CheckEquals(1, lIndent, TestCname + ' Indent');
end;

procedure TTestCase1.TestFormatCode10b;

const
  TestCode = 'strTelegramDescription0 : STRING(50) := ''<Cmd><Bew Va="0"><Kod Bof="0" Typ="Double8" /><Na>''; ';
  ExpCode = #9'strTelegramDescription0 : STRING('#9'50 )'#9':= ''<Cmd><Bew Va="0"><Kod Bof="0" Typ="Double8" /><Na>''; ';
  TestCname = 'Format Code 10b';

var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Var;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(format(ExpCode,[LineEnding]),
    FormatCode(TestCode, lindent, lpsm), TestCname + ' (Var Zuweisung)');
  CheckEquals(Ord(psm_Var), Ord(lPsm), TestCname + ' Parsmode');
  CheckEquals(1, lIndent, TestCname + ' Indent');
end;

procedure TTestCase1.TestFormatCode11;

const
  TestCode = 'a[0,1] := b; (* Test *);';
  ExpCode = #9'a[ 0, 1 ]'#9':=%s'#9#9'b; (* Test *);';
  TestCname = 'Format Code 11';

var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(format(ExpCode,[LineEnding]),
    FormatCode(TestCode, lindent, lpsm), TestCname + ' (Zuweisung Array)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), TestCname + ' Parsmode');
  CheckEquals(1, lIndent, TestCname + ' Indent');
end;

procedure TTestCase1.TestFormatCode12;

const
  TestCode = 'for i := a-1 to b-2 do';
  ExpCode = #9'for i'#9':=%0:s'#9#9#9'a - 1 to b - 2 do';
  TestCname = 'Format Code 12';

var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(format(ExpCode,[LineEnding]),
    FormatCode(TestCode, lindent, lpsm), TestCname + ' (Zuweisung Array)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), TestCname + ' Parsmode');
  CheckEquals(2, lIndent, TestCname + ' Indent');
end;

procedure TTestCase1.TestFormatCode13;

const
  TestCode = 'a:=X( 0, b );';
  ExpCode = #9'a'#9':=%0:s'#9#9'X('#9'0, b );';
  TestCname = 'Format Code 13';

var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(format(ExpCode,[LineEnding]),
    FormatCode(TestCode, lindent, lpsm), TestCname + ' (Zuweisung Function)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), TestCname + ' Parsmode');
  CheckEquals(1, lIndent, TestCname + ' Indent');
end;

procedure TTestCase1.TestFormatCode14;

const
  TestCode = 'a:=''Test '+Lineending+' Test'';';
  ExpCode = #9'a'#9':= ''Test %0:s Test'';';
  TestCname = 'Format Code 14';

var
  lPsm: TParseMode;
  lIndent: integer;

begin
  lPsm := psm_Normal;
  lIndent := 1;
  Push(psm_Normal, 0);
  CheckEquals(format(ExpCode,[LineEnding]),
    FormatCode(TestCode, lindent, lpsm), TestCname + ' (Zuweisung Function)');
  CheckEquals(Ord(psm_Normal), Ord(lPsm), TestCname + ' Parsmode');
  CheckEquals(1, lIndent, TestCname + ' Indent');
end;

procedure TTestCase1.TestAutoFormatLine1;

const
  TestCode = 'a := b; (* Test *);';
  ExpCode = 'a'#9':= b; (* Test *)%0:s;%0:s';
  TestCname = 'Auto Format Line 1';

begin
  FExpFile.Lines.Text := TestCode;
  FExpFile.AutoFormat;
  CheckEquals(Format(expcode,[LineEnding]), FExpFile.Lines.Text, TestCname+' (Double Semikolon)');
end;

procedure TTestCase1.TestAutoFormatLine2;

const
  TestCode = 'a := b(a1:=0,(* test *)b1:=2);';
  ExpCode = 'a'#9':=%0:s'#9'b(%0:s'#9#9'a1'#9':= 0, (* test *)%0:s'#9#9'b1'#9':= 2 );%0:s';
  TestCname = 'Auto Format Line 2';

begin
  FExpFile.Lines.Text := TestCode;
  FExpFile.AutoFormat;
  CheckEquals(format(expcode,[LineEnding]), FExpFile.Lines.Text, TestCname+' (Comment in parameters)');
end;

procedure TTestCase1.TestAutoFormatStringConst;

const
  TestCode = 'a:=''Update n:'+LineEnding+' for better performance '';'+'b := 2;';
  ExpCode = 'a'#9':= ''Update n:%0:s for better performance '';%0:sb'#9':= 2;%0:s';
  TestCname = 'Auto Format String Const';

begin
  FExpFile.Lines.Text := TestCode;
  FExpFile.AutoFormat;
  CheckEquals(format(expcode,[LineEnding]), FExpFile.Lines.Text, TestCname+' (Linbreak in StrConst)');
end;


procedure TTestCase1.CheckEqualsTS(const Expected: string; const Actual: TStrings;
  const AMessage: string);
var
  ExpectedSL: TStringList;
  I, Cnt: integer;
begin
  ExpectedSL := TStringList.Create;
  try
    ExpectedSL.Text := Expected;
    Cnt := ExpectedSL.Count;
    if Actual.Count < Cnt then
      Cnt := Actual.Count;
    for I := 0 to Cnt - 1 do
      CheckEquals(ExpectedSL[i], Actual[i], AMessage + ' Line:' + IntToStr(i));
    CheckEquals(ExpectedSL.Count, Actual.Count, AMessage + 'LineCount');
  finally
    ExpectedSL.Free;
  end;
end;


procedure TTestCase1.TestAutoformat1;
begin
  FExpFile.Lines.Text := ExpFile1;
  checkEquals('', FExpFile.Author, 'Author');
  checkEquals('0.0', FExpFile.Version, 'Version');
  checkEquals('\SRL\IEC_Interface', FExpFile.Path, 'Path');
  checkEquals('Block', FExpFile.BlockType, 'BlockType');
  FExpFile.Author := 'J. Marx';
  FExpFile.Version := '1.0';
  FExpFile.AutoFormat;
  checkEquals(ExpectedFileFF1, FExpFile.Lines.Text, 'Autoformat1');
end;

procedure TTestCase1.TestAutoformat2;
begin
  FExpFile.Lines.Text := ExpFile2;
  checkEquals('J. Marx', FExpFile.Author, 'Author');
  checkEquals('1.0', FExpFile.Version, 'Version');
  checkEquals('\Projekt\Kundenspezifisch', FExpFile.Path, 'Path');
  CheckEquals('Ressource', FExpFile.BlockType, 'BlockType');
  FExpFile.Author := 'C. Rosewich';
  FExpFile.Version := '1.1';
  FExpFile.AutoFormat;
//  FexpFile.Lines.Text := Utf8ToAnsi( FexpFile.Lines.Text); (*!*)
  checkEquals(ExpectedFileFF2, FExpFile.Lines.Text, 'Autoformat1');
end;

procedure TTestCase1.TestAutoformatFile1;
var
  FileName: string;
  ExpTS: TStringList;
begin
  FileName := 'FBACHSEMOVIAXIS.EXP';
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := Utf8ToAnsi( FexpFile.Lines.Text); (*!*)
  ExpTS := TStringList.Create;
  try
    expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, 'AutoFormatFile1');
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      ExpTS.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile2;
var
  FileName: string;
  ExpTS: TStringList;
begin
  FileName := 'FBAGGREGAT.EXP';
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := FexpFile.Lines.Text; (*!*)
  ExpTS := TStringList.Create;
  try
    expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, 'AutoFormatFile2');
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      ExpTS.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile3;
var
  FileName: string;
  ExpTS: TStringList;
begin
  FileName := 'FBRUESTPLATZ_HUBTUERE.EXP';
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := FexpFile.Lines.Text; (*!*)
  ExpTS := TStringList.Create;
  try
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt')) then
      expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, 'AutoFormatFile3');
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      ExpTS.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile4;
var
  FileName: string;
  ExpTS: TStringList;
begin
  FileName := 'FBWRITECSV.EXP';
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := FexpFile.Lines.Text; (*!*)
  ExpTS := TStringList.Create;
  try
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt')) then
      expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, 'AutoFormatFile4');
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      ExpTS.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile5;
var
  FileName: string;
  ExpTS: TStringList;
begin
  FileName := 'FCACHSESEW_UMR_3PDW.EXP';
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := FexpFile.Lines.Text; (*!*)
  ExpTS := TStringList.Create;
  try
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt')) then
      expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, 'AutoFormatFile5');
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      ExpTS.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile6;
var
  FileName: string;
  ExpTS: TStringList;
const
   testFileName = 'SRL_IS_CONTROLSTRUC.EXP';

begin
  FileName := testFileName;
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := FexpFile.Lines.Text; (*!*)
  ExpTS := TStringList.Create;
  try
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt')) then
      expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, TestName);
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      ExpTS.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile7;
var
  FileName: string;
  ExpTS: TStringList;

const
    testFileName = 'MC_KINSIMU3D_CONNECTAGK.EXP';

begin
  Filename:= testFileName;
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := FexpFile.Lines.Text; (*!*)
  ExpTS := TStringList.Create;
  try
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt')) then
      expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));

    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, TestName);
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      ExpTS.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile8;
var
  FileName: string;
  ExpTS: TStringList;

const
    testFileName = 'IMPORT_TECHMODULE_HANDLINGKINEMATICS_SBUSPLUS.EXP';

begin
  Filename:= testFileName;
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := Utf8ToAnsi( FexpFile.Lines.Text); (*!*)
//  FExpFile.Lines.StringsAdapter ;
  ExpTS := TStringList.Create;
  try
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt')) then
      expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, 'AutoFormatFile8');
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      expts.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;

procedure TTestCase1.TestAutoformatFile9;
var
  FileName: string;
  ExpTS: TStringList;

const
    testFileName = 'P00008.EXP';

begin
  Filename:= testFileName;
  FExpFile.LoadfromFile(FDataDir + DirectorySeparator + Filename);
  FExpFile.AutoFormat;
  FexpFile.Lines.Text := Utf8ToAnsi( FexpFile.Lines.Text); (*!*)
//  FExpFile.Lines.StringsAdapter ;
  ExpTS := TStringList.Create;
  try
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt')) then
      expTS.text := LoadfromFileToUTF8(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.txt'));
    FExpFile.SaveToFile(FDataDir + DirectorySeparator +
      ChangeFileExt(Filename, '_neu.EXP'));
    CheckEqualsTS(ExpTS.Text, FExpFile.Lines, 'AutoFormatFile9');
    if FileExists (FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info')) then
      expTS.LoadFromFile(FDataDir + DirectorySeparator + ChangeFileExt(Filename, '.info'))
    else
      expts.Clear;
    CheckEquals(ExpTS.Text, FExpFile.GetFileInfoStr(
      FDataDir + DirectorySeparator + Filename), 'FileInfo');
  finally
    FreeAndNil(ExpTS);
  end;
end;


procedure TTestCase1.TestGetFileOpenFilter;
begin
  checkEquals('SEW-Export-Datei (*.EXP)|*.EXP', FExpFile.FileOpenFilter, 'Autoformat1');
end;

procedure TTestCase1.SetUp;
var
  i: integer;
begin
  FExpFile := TSEW_Exp_File.Create;
  FDataDir := DefDataDir;
  for i := 0 to 2 do
    if not DirectoryExists(FDataDir) then
      FDataDir := '..' + DirectorySeparator + FDataDir
    else
      break;
  FDataDir := FDataDir + DirectorySeparator + 'SEWTest';
  setlength(FKnownIdentifyer, 5);
  FKnownIdentifyer[0].Name := 'TRUE';
  FKnownIdentifyer[1].Name := 'FALSE';
  FKnownIdentifyer[2].Name := 'a';
  FKnownIdentifyer[3].Name := 'b';
  FKnownIdentifyer[4].Name := 'c';
end;

procedure TTestCase1.TearDown;
begin
  setlength(FKnownIdentifyer, 0);
  FreeAndNil(FExpFile);
end;

initialization

  RegisterTest(TTestCase1
{$IFNDEF FPC}
    .suite
{$ENDIF}
    );
end.
