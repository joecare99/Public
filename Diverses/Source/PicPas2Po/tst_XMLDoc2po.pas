unit tst_XMLDoc2po;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,{$IFDEF FPC}  fpcunit, testutils, testregistry, {$ELSE}  Ttstsuite, {$ENDIF} frm_XMLDoc2po;

type

  { TTestXMLDoc2Po }

  TTestXMLDoc2Po= class(TTestCase)
  private
    FDataPath:String;
    Procedure LoadTestData;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    Procedure CheckDirectoryExists(DirToTest,Msg:String);
  public
  published
    procedure TestSetUp;
    Procedure TestAnalyzePhrase;
    Procedure TestBuildPhrase;
  end;

implementation
uses Forms;

Const BaseDir='Data';

 Phrazes:array[0..6,0..1] of string=
 (('In diesem Spiel versuchen Sie, die durcheinander geworfenen Buchstaben wiede'+
   'r in alphabetische Reihenfolge zu bringen',
   'In diesem Spiel versuchen Sie, die durcheinander geworfenen Buchstaben wiede'+
   'r in alphabetische Reihenfolge zu bringen'),
  ('Der Computer mischt das Spielfeld mit ungefähr 150 mal durch.',
   'Der Computer mischt das Spielfeld mit ungefähr %0:s mal durch.'),
  ('Die Zeilen 2221 bis 2235 zeichnen die Buchstaben auf das Spielfeld.',
   'Die Zeilen %0:s bis %1:s zeichnen die Buchstaben auf das Spielfeld.'),
   ('Beim Umsetzen werden zuerst "%" und "/"-Zeichen ausgen. "/44" durch Platzha'+
    'lter ersetzt, so daß "%0:s" nicht erkannt wird.',
    'Beim Umsetzen werden zuerst "/%" und "//"-Zeichen ausgen. "//%0:s" durch Plat'+
    'zhalter ersetzt, so daß "/%0:s" nicht erkannt wird.'),
  ('D i e s e  Z e i l e  e n t h ä l t  g e s p e r r t e n  T e x t !',
   '%1:g Diese Zeile enthält gesperrten Text!%0:g'),
  ('Diese Zeile enthält ein  g e s p e r r t e s  Wort.',
   'Diese Zeile enthält ein %1:g gesperrtes %0:g Wort.'),
   ('1 -  manual mode','%1:g%0:s- %0:g manual mode'));

procedure TTestXMLDoc2Po.LoadTestData;
begin
  CheckNotNull(frmXml2PoMain,'Mainform is initialized');
  frmXml2PoMain.fraPoFile1.LoadPOFile(FDataPath+'Navitrol.de.po');
end;

procedure TTestXMLDoc2Po.SetUp;
var
  i: Integer;
begin
  if FDataPath='' then
    begin
      FDataPath:=BaseDir;
      for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
          break
        else
          FDataPath:='..'+DirectorySeparator+FDataPath;
      // Plan B
      if not DirectoryExists(FDataPath) then
        begin
          FDataPath:=GetAppConfigDir(true);

        end;
    end;
  if not assigned(frmXml2PoMain) then
    Application.CreateForm(TfrmXml2PoMain,frmXml2PoMain);

end;

procedure TTestXMLDoc2Po.TearDown;
begin
  // Jet Empty
end;

procedure TTestXMLDoc2Po.CheckDirectoryExists(DirToTest, Msg: String);
begin
  if DirectoryExists(DirToTest) then
    inc(AssertCount)
  else
    Fail('Directory: "'+DirToTest+'" does not exist! '+Msg);
end;

procedure TTestXMLDoc2Po.TestSetUp;
begin
  CheckNotNull(frmXml2PoMain,'Mainform is initialized');
  CheckDirectoryExists(FDataPath,'DataPath must exist');
end;

procedure TTestXMLDoc2Po.TestAnalyzePhrase;

var
  Excepts: TStringArray;

begin
  CheckEquals(Phrazes[0,1],frmXml2PoMain.AnalyzePhrase(Phrazes[0,0],Excepts),'First Phrase');
  CheckEquals(0,length(Excepts),'First Phrase no excepts');
  CheckEquals(Phrazes[1,1],frmXml2PoMain.AnalyzePhrase(Phrazes[1,0],Excepts),'Second Phrase');
  CheckEquals(1,length(Excepts),'Second Phrase 1 excepts');
  CheckEquals('150',Excepts[0],'Second Phrase: excepts=150');
  CheckEquals(Phrazes[2,1],frmXml2PoMain.AnalyzePhrase(Phrazes[2,0],Excepts),'Third Phrase');
  CheckEquals(2,length(Excepts),'Third Phrase 2 excepts');
  CheckEquals('2221',Excepts[0],'Third Phrase: excepts[0]');
  CheckEquals('2235',Excepts[1],'Third Phrase: excepts[1]');
  CheckEquals(Phrazes[3,1],frmXml2PoMain.AnalyzePhrase(Phrazes[3,0],Excepts),'Fourth Phrase');
  CheckEquals(1,length(Excepts),'Fourth Phrase 1 excepts');
  CheckEquals('44',Excepts[0],'Fourth Phrase: excepts[0]');
  CheckEquals(Phrazes[4,1],frmXml2PoMain.AnalyzePhrase(Phrazes[4,0],Excepts),'Fifth Phrase');
  CheckEquals(Phrazes[5,1],frmXml2PoMain.AnalyzePhrase(Phrazes[5,0],Excepts),'Sixth Phrase');
  CheckEquals(Phrazes[6,1],frmXml2PoMain.AnalyzePhrase(Phrazes[6,0],Excepts),'Seventh Phrase');
end;

procedure TTestXMLDoc2Po.TestBuildPhrase;

var
  Excepts: TStringArray;

begin
  setlength(Excepts,0);
  CheckEquals(Phrazes[0,0],frmXml2PoMain.BuildPhrase(Phrazes[0,1],Excepts),'First Phrase');
  CheckEquals(0,length(Excepts),'First Phrase no excepts');
  setlength(Excepts,1);
  Excepts[0]:= '150';
  CheckEquals(Phrazes[1,0],frmXml2PoMain.BuildPhrase(Phrazes[1,1],Excepts),'Second Phrase');
  setlength(Excepts,2);
  Excepts[0]:= '2221';
  Excepts[1]:= '2235';
  CheckEquals(Phrazes[2,0],frmXml2PoMain.BuildPhrase(Phrazes[2,1],Excepts),'Third Phrase');
  setlength(Excepts,1);
  Excepts[0]:= '44';
  CheckEquals(Phrazes[3,0],frmXml2PoMain.BuildPhrase(Phrazes[3,1],Excepts),'Fourth Phrase');
  CheckEquals(Phrazes[4,0],frmXml2PoMain.BuildPhrase(Phrazes[4,1],Excepts),'Fifth Phrase');
  CheckEquals(Phrazes[5,0],frmXml2PoMain.BuildPhrase(Phrazes[5,1],Excepts),'Sixth Phrase');
  setlength(Excepts,1);
  Excepts[0]:= '1';
  CheckEquals(Phrazes[6,0],frmXml2PoMain.BuildPhrase(Phrazes[6,1],Excepts),'Sixth Phrase');
end;

initialization

  RegisterTest(TTestXMLDoc2Po{$IFNDEF FPC}.Suite {$ENDIF});
end.

