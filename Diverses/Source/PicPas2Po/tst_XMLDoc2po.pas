UNIT tst_XMLDoc2po;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

INTERFACE

USES
  Classes, SysUtils,{$IFDEF FPC}  fpcunit, testutils, testregistry, {$ELSE}  Ttstsuite, {$ENDIF} frm_XMLDoc2po;

TYPE

  { TTestXMLDoc2Po }

  TTestXMLDoc2Po = CLASS(TTestCase)
  private
    FDataPath: String;
    PROCEDURE LoadTestData;
  protected
    PROCEDURE SetUp; override;
    PROCEDURE TearDown; override;
    PROCEDURE CheckDirectoryExists(DirToTest, Msg: String);
  public
  published
    PROCEDURE TestSetUp;
    PROCEDURE TestAnalyzePhrase;
    PROCEDURE TestBuildPhrase;
    PROCEDURE TestStringSplit;
    PROCEDURE TestStringSplit2;
    procedure TestStringSplit3;
    procedure TestStringSplit4;
  END;

IMPLEMENTATION

USES Forms;

CONST
  BaseDir = 'Data';

  Phrazes: ARRAY[0..6, 0..1] OF String =
    (('In diesem Spiel versuchen Sie, die durcheinander geworfenen Buchstaben wiede' +
    'r in alphabetische Reihenfolge zu bringen',
    'In diesem Spiel versuchen Sie, die durcheinander geworfenen Buchstaben wiede' +
    'r in alphabetische Reihenfolge zu bringen'),
    ('Der Computer mischt das Spielfeld mit ungefähr 150 mal durch.',
    'Der Computer mischt das Spielfeld mit ungefähr %0:s mal durch.'),
    ('Die Zeilen 2221 bis 2235 zeichnen die Buchstaben auf das Spielfeld.',
    'Die Zeilen %0:s bis %1:s zeichnen die Buchstaben auf das Spielfeld.'),
    ('Beim Umsetzen werden zuerst "%" und "/"-Zeichen ausgen. "/44" durch Platzha' +
    'lter ersetzt, so daß "%0:s" nicht erkannt wird.',
    'Beim Umsetzen werden zuerst "/%" und "//"-Zeichen ausgen. "//%0:s" durch Plat' +
    'zhalter ersetzt, so daß "/%0:s" nicht erkannt wird.'),
    ('D i e s e  Z e i l e  e n t h ä l t  g e s p e r r t e n  T e x t !',
    '%1:g Diese Zeile enthält gesperrten Text!%0:g'),
    ('Diese Zeile enthält ein  g e s p e r r t e s  Wort.',
    'Diese Zeile enthält ein %1:g gesperrtes %0:g Wort.'),
    ('1 -  manual mode', '%1:g%0:s- %0:g manual mode'));

  SentenceToSplit: ARRAY[0..3, 0..3] OF String =
    (('The quick brown fox jumps over the lazy dog.', 'brown fox', 'The quick ',
    ' jumps over the lazy dog.'),
    ('The quick brown fox jumps over the lazy dog.', 'quick fox', '',
    'The quick brown fox jumps over the lazy dog.'),
    ('The quick brown fox jumps over the lazy dog.', 'quick brown', 'The ',
    ' fox jumps over the lazy dog.'),
    (' fox jumps over the lazy dog.', 'lazy', ' fox jumps over the ',
    ' dog.'));


PROCEDURE TTestXMLDoc2Po.LoadTestData;
BEGIN
  CheckNotNull(frmXml2PoMain, 'Mainform is initialized');
  frmXml2PoMain.fraPoFile1.LoadPOFile(FDataPath + 'Navitrol.de.po');
END;

PROCEDURE TTestXMLDoc2Po.SetUp;
VAR
  i: Integer;
BEGIN
  IF FDataPath = '' THEN
  BEGIN
    FDataPath := BaseDir;
    FOR i := 0 TO 2 DO
      IF DirectoryExists(FDataPath) THEN
        break
      ELSE
        FDataPath := '..' + DirectorySeparator + FDataPath;
    // Plan B
    IF not DirectoryExists(FDataPath) THEN
      FDataPath := GetAppConfigDir(True);
  END;
  IF not assigned(frmXml2PoMain) THEN
    Application.CreateForm(TfrmXml2PoMain, frmXml2PoMain);

END;

PROCEDURE TTestXMLDoc2Po.TearDown;
BEGIN
  // Jet Empty
END;

PROCEDURE TTestXMLDoc2Po.CheckDirectoryExists(DirToTest, Msg: String);
BEGIN
  IF DirectoryExists(DirToTest) THEN
    Inc(AssertCount)
  ELSE
    Fail('Directory: "' + DirToTest + '" does not exist! ' + Msg);
END;

PROCEDURE TTestXMLDoc2Po.TestSetUp;
BEGIN
  CheckNotNull(frmXml2PoMain, 'Mainform is initialized');
  CheckDirectoryExists(FDataPath, 'DataPath must exist');
END;

PROCEDURE TTestXMLDoc2Po.TestAnalyzePhrase;

VAR
  Excepts: TStringArray;

BEGIN
  CheckEquals(Phrazes[0, 1], frmXml2PoMain.AnalyzePhrase(Phrazes[0, 0], Excepts),
    'First Phrase');
  CheckEquals(0, length(Excepts), 'First Phrase no excepts');
  CheckEquals(Phrazes[1, 1], frmXml2PoMain.AnalyzePhrase(Phrazes[1, 0], Excepts),
    'Second Phrase');
  CheckEquals(1, length(Excepts), 'Second Phrase 1 excepts');
  CheckEquals('150', Excepts[0], 'Second Phrase: excepts=150');
  CheckEquals(Phrazes[2, 1], frmXml2PoMain.AnalyzePhrase(Phrazes[2, 0], Excepts),
    'Third Phrase');
  CheckEquals(2, length(Excepts), 'Third Phrase 2 excepts');
  CheckEquals('2221', Excepts[0], 'Third Phrase: excepts[0]');
  CheckEquals('2235', Excepts[1], 'Third Phrase: excepts[1]');
  CheckEquals(Phrazes[3, 1], frmXml2PoMain.AnalyzePhrase(Phrazes[3, 0], Excepts),
    'Fourth Phrase');
  CheckEquals(1, length(Excepts), 'Fourth Phrase 1 excepts');
  CheckEquals('44', Excepts[0], 'Fourth Phrase: excepts[0]');
  CheckEquals(Phrazes[4, 1], frmXml2PoMain.AnalyzePhrase(Phrazes[4, 0], Excepts),
    'Fifth Phrase');
  CheckEquals(Phrazes[5, 1], frmXml2PoMain.AnalyzePhrase(Phrazes[5, 0], Excepts),
    'Sixth Phrase');
  CheckEquals(Phrazes[6, 1], frmXml2PoMain.AnalyzePhrase(Phrazes[6, 0], Excepts),
    'Seventh Phrase');
END;

PROCEDURE TTestXMLDoc2Po.TestBuildPhrase;

VAR
  Excepts: TStringArray;

BEGIN
  setlength(Excepts, 0);
  CheckEquals(Phrazes[0, 0], frmXml2PoMain.BuildPhrase(Phrazes[0, 1], Excepts),
    'First Phrase');
  CheckEquals(0, length(Excepts), 'First Phrase no excepts');
  setlength(Excepts, 1);
  Excepts[0] := '150';
  CheckEquals(Phrazes[1, 0], frmXml2PoMain.BuildPhrase(Phrazes[1, 1], Excepts),
    'Second Phrase');
  setlength(Excepts, 2);
  Excepts[0] := '2221';
  Excepts[1] := '2235';
  CheckEquals(Phrazes[2, 0], frmXml2PoMain.BuildPhrase(Phrazes[2, 1], Excepts),
    'Third Phrase');
  setlength(Excepts, 1);
  Excepts[0] := '44';
  CheckEquals(Phrazes[3, 0], frmXml2PoMain.BuildPhrase(Phrazes[3, 1], Excepts),
    'Fourth Phrase');
  CheckEquals(Phrazes[4, 0], frmXml2PoMain.BuildPhrase(Phrazes[4, 1], Excepts),
    'Fifth Phrase');
  CheckEquals(Phrazes[5, 0], frmXml2PoMain.BuildPhrase(Phrazes[5, 1], Excepts),
    'Sixth Phrase');
  setlength(Excepts, 1);
  Excepts[0] := '1';
  CheckEquals(Phrazes[6, 0], frmXml2PoMain.BuildPhrase(Phrazes[6, 1], Excepts),
    'Sixth Phrase');
END;

FUNCTION StringSplit(CONST Sentence, Search: String; out First:string;var Rest: String): Boolean;
VAR
  pp: Integer;
BEGIN
  pp     := pos(Search, Sentence);
  Result := pp <> 0;
  IF Result THEN
  BEGIN
    First := copy(Sentence, 1, pp - 1);
    Rest  := copy(Sentence, pp + length(Search), length(Sentence) -
      pp - length(Search) + 1);
  END
  ELSE
  BEGIN
    First := '';
    Rest  := Sentence;
  END;
END;

PROCEDURE TTestXMLDoc2Po.TestStringSplit;
VAR
  lFirst, lRest, lMiddle: String;
BEGIN
  CheckEquals(True, StringSplit(SentenceToSplit[0, 0], SentenceToSplit[0, 1],
    lFirst, lRest),
    'First Split');
  CheckEquals(lFirst, SentenceToSplit[0, 2], 'First Split first');
  CheckEquals(lRest, SentenceToSplit[0, 3], 'First Split rest');
  // ------------------------
  CheckEquals(False, StringSplit(SentenceToSplit[1, 0], SentenceToSplit[1, 1],
    lFirst, lRest),
    'Second Split');
  CheckEquals(lFirst, SentenceToSplit[1, 2], 'Second Split first');
  CheckEquals(lRest, SentenceToSplit[1, 3], 'Second Split rest');
  // ------------------------
  CheckEquals(True, StringSplit(SentenceToSplit[2, 0], SentenceToSplit[2, 1],
    lFirst, lRest),
    'Third Split');
  CheckEquals(True, StringSplit(lRest, SentenceToSplit[3, 1], lMiddle, lRest),
    'Fourth Split');
  CheckEquals(lFirst, SentenceToSplit[2, 2], 'Third Split first');
  CheckEquals(lMiddle, SentenceToSplit[3, 2], 'Fourth Split first');
  CheckEquals(lRest, SentenceToSplit[3, 3], 'Fourth Split rest');
  // ------------------------

END;

PROCEDURE TTestXMLDoc2Po.TestStringSplit2;

CONST
  Sentence = 'The quick brown fox jumps over the lazy dog.';
  Split: ARRAY[0..2] OF String = ('quick', 'brown', 'lazy');

VAR
  i:     Integer;
  lResult: ARRAY OF String;
  lRest: String;
  lSuccess: Boolean;

BEGIN
  i := 1;
  setlength(lResult, i + 1);
  lSuccess := StringSplit(Sentence, split[0], lResult[0], lRest);
  WHILE lSuccess and (i < length(Split)) and (length(lrest) > 0) and
    StringSplit(lRest, split[i], lResult[i], lRest) DO
  BEGIN
    Inc(i);
    setlength(lResult, i + 1);
  END;
  lResult[i] := lRest;
  // Test Result
  lSuccess   :=
    (lResult[0] = 'The ') and (lResult[1] = ' ') and
    (lResult[2] = ' fox jumps over the ') and (lResult[3] = ' dog.');
  CheckTrue(lSuccess, 'Expected result');
END;

PROCEDURE TTestXMLDoc2Po.TestStringSplit3;
VAR
  lFirst, lRest, lMiddle: WideString;
BEGIN
  CheckEquals(True, frmXml2PoMain.StringSplit(widestring(SentenceToSplit[0, 0]),
    widestring(SentenceToSplit[0, 1]), lFirst, lRest),'First Split');
  CheckEquals(widestring( SentenceToSplit[0, 2]),lFirst, 'First Split first');
  CheckEquals(widestring(SentenceToSplit[0, 3]),lRest,  'First Split rest');
  // ------------------------
  CheckEquals(False, frmXml2PoMain.StringSplit(widestring(SentenceToSplit[1, 0]),
    widestring(SentenceToSplit[1, 1]),lFirst, lRest),
    'Second Split');
  CheckEquals(widestring(SentenceToSplit[1, 2]),lFirst, 'Second Split first');
  CheckEquals(widestring(SentenceToSplit[1, 3]),lRest, 'Second Split rest');
  // ------------------------
  CheckEquals(True, frmXml2PoMain.StringSplit(widestring(SentenceToSplit[2, 0]),
    widestring(SentenceToSplit[2, 1]),lFirst, lRest),
    'Third Split');
  CheckEquals(True, frmXml2PoMain.StringSplit(lRest,widestring( SentenceToSplit
    [3, 1]), lMiddle, lRest),'Fourth Split');
  CheckEquals( widestring(SentenceToSplit[2, 2]),lFirst, 'Third Split first');
  CheckEquals( widestring(SentenceToSplit[3, 2]),lMiddle, 'Fourth Split first');
  CheckEquals( widestring(SentenceToSplit[3, 3]), lRest, 'Fourth Split rest');
  // ------------------------

END;

PROCEDURE TTestXMLDoc2Po.TestStringSplit4;

CONST
  Sentence = 'The quick brown fox jumps over the lazy dog.';
  Split: ARRAY[0..2] OF wideString = ('quick', 'brown', 'lazy');

VAR
  i:     Integer;
  lResult: ARRAY OF wideString;
  lRest: WideString;
  lSuccess: Boolean;

BEGIN
  i := 1;
  setlength(lResult, i + 1);
  lSuccess := frmXml2PoMain.StringSplit(Sentence, split[0], lResult[0], lRest);
  WHILE lSuccess and (i < length(Split)) and (length(lrest) > 0) and
    frmXml2PoMain.StringSplit(lRest, split[i], lResult[i], lRest) DO
  BEGIN
    Inc(i);
    setlength(lResult, i + 1);
  END;
  lResult[i] := lRest;
  // Test Result
  lSuccess   :=
    (lResult[0] = 'The ') and (lResult[1] = ' ') and
    (lResult[2] = ' fox jumps over the ') and (lResult[3] = ' dog.');
  CheckTrue(lSuccess, 'Expected result');
END;


INITIALIZATION

  RegisterTest(TTestXMLDoc2Po{$IFNDEF FPC}.Suite{$ENDIF});
END.
