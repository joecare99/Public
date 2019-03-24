UNIT frm_XMLDoc2po;

{$mode objfpc}{$H+}

INTERFACE

USES
  Classes, SysUtils, DOM, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ActnList, IniFiles, fra_XMLFile, fra_PoFile;

TYPE
  TChapters = ARRAY[1..4] OF Integer;
  { TfrmXml2PoMain }

  TfrmXml2PoMain = CLASS(TForm)
    actXmlProcessX2Po: TAction;
    actXmlProcessPo2X: TAction;
    alsXmlProcess: TActionList;
    btnProcessXml2Po: TBitBtn;
    btnProcessPo2Pas: TSpeedButton;
    btnSelectDir: TSpeedButton;
    edtSourceDir: TLabeledEdit;
    fraPoFile1:  TfraPoFile;
    fraXmlFile1: TfraXmlFile;
    pnlLeft:     TPanel;
    pnlProcessing: TPanel;
    pnlTop:      TPanel;
    pnlTopRight: TPanel;
    dlgSelectDirectory: TSelectDirectoryDialog;
    PROCEDURE actXmlProcessPo2XExecute(Sender: TObject);
    PROCEDURE actXmlProcessX2PoExecute(Sender: TObject);
    PROCEDURE btnSelectDirClick(Sender: TObject);
    PROCEDURE edtSourceDirChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    PROCEDURE FormResize(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
  private
    FIniFile: TIniFile;
    FCfgBaseSection: String;
    // Part of the Engine
    PROCEDURE parsePhrase(Path, Phrase: String; Chapter: TChapters);
    FUNCTION SetNewPhrase(Path: String; Phrase: DOMString;
      Chapter: TChapters): DOMString;
    function StringSplit(const LSpanTrans, lSearch: DOMString; out
      lFirst: DOMString; var lRest: DOMString): Boolean;
    Procedure SaveConfigValues(Sender:TObject);
  public
    FUNCTION AnalyzePhrase(Phr: String; out Excepts: TStringArray): String;
    FUNCTION BuildPhrase(PhrStmp: String; CONST Excepts: TStringArray): String;
  END;

VAR
  frmXml2PoMain: TfrmXml2PoMain;

RESOURCESTRING
  rsExcPaceholder = '%%%d:s';
  rsBigPaceholder = '%%%d:g';

const
  cBaseSection='Config';

IMPLEMENTATION

{$R *.lfm}

{ TfrmXml2PoMain }

procedure TfrmXml2PoMain.edtSourceDirChange(Sender: TObject);
BEGIN
  fraPoFile1.BaseDir := edtSourceDir.Text;
END;

procedure TfrmXml2PoMain.FormCreate(Sender: TObject);
var
  lConfigFile , lProjName: String;
begin
  lConfigFile:=sysutils.GetAppConfigFile(false);
  if (ParamCount>=1) and (ParamStr(1)[1]='/') then
    begin
      FCfgBaseSection:=cBaseSection+'/'+copy(ParamStr(1),2,length(ParamStr(1))-1);
      lProjName :=copy(ParamStr(1),2,length(ParamStr(1))-1);
    end
  else
    begin
      FCfgBaseSection:=cBaseSection;
      lProjName:=fraPoFile1.edtProjectName.text;
    end;
  FIniFile := TInifile.Create(lConfigFile);
  edtSourceDir.Text:=FIniFile.ReadString(FCfgBaseSection,edtSourceDir.Name,edtSourceDir.Text);
  fraXmlFile1.edtXmlFilename.text:=FIniFile.ReadString(FCfgBaseSection,fraXmlFile1.edtXmlFilename.Name,fraXmlFile1.edtXmlFilename.Text);
  fraPoFile1.edtProjectName.text:=FIniFile.ReadString(FCfgBaseSection,fraPoFile1.edtProjectName.Name,lProjName);
end;

procedure TfrmXml2PoMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FIniFile);
end;


procedure TfrmXml2PoMain.parsePhrase(Path, Phrase: String; Chapter: TChapters);

VAR
  exc, lTrans:  TStringArray;
  lPhraseStumb: String;

BEGIN
  lPhraseStumb := AnalyzePhrase(Phrase, exc);
  SetLength(lTrans, 4);
  lTrans[0] := lPhraseStumb;
  lTrans[1] := lPhraseStumb;
  fraPoFile1.AppendData(path, lTrans);
END;

function TfrmXml2PoMain.SetNewPhrase(Path: String; Phrase: DOMString;
  Chapter: TChapters): DOMString;

VAR
  exc: TStringArray;
  {%H-}lPhraseStumb, lTransStumb: String;
  lid: Integer;
BEGIN
  lPhraseStumb := AnalyzePhrase(Ansistring(Phrase), exc);
  lid := fraPoFile1.LookUpIdent(path);
  IF lid < 0 THEN
    lid := fraPoFile1.LookUpSource(lPhraseStumb);
  IF lid >= 0 THEN
    lTransStumb := fraPoFile1.GetTranslText(lid);
  IF lTransStumb <> '' THEN
    Result := DOMString(BuildPhrase(lTransStumb, exc))
  ELSE
    Result := Phrase;
END;

procedure TfrmXml2PoMain.actXmlProcessX2PoExecute(Sender: TObject);

VAR
  Chapter: TChapters;

  PROCEDURE ParseChilds(Parent: String; Flag1, Flag2: Boolean; XMLNodes: TDOMNodeList);

  VAR
    LNewNode, lStyle, LSpanText: String;
    i:     Integer;
    lBailout, lInterest1, lInterest2, lInterest3, lBailout2: Boolean;
    lOutlLev, j: Longint;
    lNode: TDOMNode;
  BEGIN
    LSpanText := '';
    IF assigned(XMLNodes) THEN
      FOR i := 0 TO XMLNodes.Count - 1 DO
        IF not XMLNodes[i].InheritsFrom(TDOMText) THEN
        BEGIN
          LNewNode   := Parent + '[' + IntToStr(i) + ']' + DirectorySeparator +
            Ansistring(XMLNodes[i].NodeName);
          lBailout   := Ansistring(XMLNodes[i].NodeName) = 'draw:image';
          lBailout2  := (Ansistring(XMLNodes[i].NodeName) = 'text:span');
          lInterest1 := Ansistring(XMLNodes[i].NodeName) = 'office:text';
          lInterest2 := Ansistring(XMLNodes[i].NodeName) = 'text:p';
          lInterest3 := Ansistring(XMLNodes[i].NodeName) = 'text:h';
          IF lInterest3 THEN
          BEGIN
            trystrtoint(
              XMLNodes[i].Attributes.GetNamedItem('text:outline-level').TextContent{%H-},
              lOutlLev);
            Inc(Chapter[lOutlLev]);
            FOR j := lOutlLev + 1 TO 4 DO
              Chapter[j] := 0;
          END;
          IF lBailout THEN
            Continue;
          IF lBailout2 THEN
          BEGIN
            lNode := XMLNodes[i].Attributes.GetNamedItem('text:style-name');
            IF assigned(lNode) THEN
              lStyle := Ansistring(lNode.TextContent);
            IF lStyle <> 'T1' THEN
              ParsePhrase(
                LNewNode, trim(Ansistring(XMLNodes[i].TextContent)), Chapter);
            LSpanText := LSpanText + Ansistring(XMLNodes[i].TextContent);
            Continue;
          END;
          IF assigned(XMLNodes[i].ChildNodes) and
            (XMLNodes[i].ChildNodes.Count > 0) THEN
            ParseChilds(LNewNode, Flag1 or lInterest1, Flag2 or
              lInterest2 or lInterest3, XMLNodes[i].ChildNodes);

        END
        ELSE
        IF Flag1 and Flag2 and (trim(XMLNodes[i].TextContent) <> '') THEN
        BEGIN
          IF not lInterest3 THEN
            Inc(Chapter[4]);
          ParsePhrase(
            parent, trim(Ansistring(TDOMText(XMLNodes[i]).Data)), Chapter);
        END;

    IF LSpanText <> '' THEN
      ParsePhrase(parent, trim(LSpanText), Chapter);
  END;

BEGIN
  SaveConfigValues(sender);
  Chapter[1] := 0;
  ParseChilds('', False, False, fraXMLFile1.XmlDocument.ChildNodes);
END;

procedure TfrmXml2PoMain.btnSelectDirClick(Sender: TObject);
BEGIN
  dlgSelectDirectory.FileName := edtSourceDir.Text;
  IF dlgSelectDirectory.Execute THEN
    edtSourceDir.Text := dlgSelectDirectory.FileName;
END;

    function TfrmXml2PoMain.StringSplit(const LSpanTrans, lSearch: DOMString; out
    lFirst: DOMString; var lRest: DOMString): Boolean;
  VAR
    pp: SizeInt;
  BEGIN
    pp     := pos(lSearch, LSpanTrans);
    Result := pp <> 0;
    IF Result THEN
    BEGIN
      lFirst := copy(LSpanTrans, 1, pp - 1);
      lRest  := copy(LSpanTrans, pp + length(lSearch), length(LSpanTrans) - pp);
    END
    else
      //Todo: Ask the User
      ;
  END;

  procedure TfrmXml2PoMain.SaveConfigValues(Sender: TObject);
  begin
    FIniFile.WriteString(FCfgBaseSection,edtSourceDir.Name,edtSourceDir.Text);
    FIniFile.WriteString(FCfgBaseSection,fraXmlFile1.edtXmlFilename.Name,fraXmlFile1.edtXmlFilename.Text);
    FIniFile.WriteString(FCfgBaseSection,fraPoFile1.edtProjectName.Name,fraPoFile1.edtProjectName.text);
    FIniFile.UpdateFile;
  end;

procedure TfrmXml2PoMain.actXmlProcessPo2XExecute(Sender: TObject);

VAR
  Chapter: TChapters;


  PROCEDURE ParseChilds(Parent: String; Flag1, Flag2: Boolean; XMLNodes: TDOMNodeList);

  VAR
    LNewNode, lStyle, LSpanText: String;
    lSpanArr: ARRAY OF TDOMNode;
    i:     Integer;
    lBailout, lInterest1, lInterest2, lInterest3, lBailout2, lBailout2b,
    lHandled: Boolean;
    lOutlLev, j: Longint;
    lNode: TDOMNode;
    LSpanTrans, lSearch, lMiddle, lLast, lFirst, lRest: DOMString;
    pp:    SizeInt;
  BEGIN
    LSpanText := '';
    setlength(LSpanArr, 0);
    lInterest3 := False;
    IF assigned(XMLNodes) THEN
      FOR i := 0 TO XMLNodes.Count - 1 DO
        IF not XMLNodes[i].InheritsFrom(TDOMText) THEN
        BEGIN
          LNewNode   := Parent + '[' + IntToStr(i) + ']' + DirectorySeparator +
            Ansistring(XMLNodes[i].NodeName);
          lBailout   := Ansistring(XMLNodes[i].NodeName) = 'draw:image';
          lBailout2  := Ansistring(XMLNodes[i].NodeName) = 'text:span';
          lBailout2b :=
            (i < XMLNodes.Count - 1) and (Ansistring(XMLNodes[i + 1].NodeName) =
            'text:span');
          lInterest1 := Ansistring(XMLNodes[i].NodeName) = 'office:text';
          lInterest2 := Ansistring(XMLNodes[i].NodeName) = 'text:p';
          lInterest3 := Ansistring(XMLNodes[i].NodeName) = 'text:h';
          IF lInterest3 THEN
          BEGIN
            trystrtoint(
              XMLNodes[i].Attributes.GetNamedItem('text:outline-level').TextContent,
              lOutlLev);
            Inc(Chapter[lOutlLev]);
            FOR j := lOutlLev + 1 TO 4 DO
              Chapter[j] := 0;
          END;
          IF lBailout2 THEN
          BEGIN
            lNode := XMLNodes[i].Attributes.GetNamedItem('text:style-name');
            IF assigned(lNode) THEN
              lStyle := Ansistring(lNode.TextContent);
            IF lStyle <> 'T1' THEN
              XMLNodes[i].TextContent :=
                SetNewPhrase(LNewNode, XMLNodes[i].TextContent, Chapter);
            LSpanText := LSpanText + Ansistring(XMLNodes[i].TextContent);
            setlength(lSpanArr, high(lSpanArr) + 2);
            lSpanArr[high(lSpanArr)] := XMLNodes[i];
            Continue;
          END
          ELSE IF lBailout or lBailout2b THEN
          ELSE
          IF assigned(XMLNodes[i].ChildNodes) and
            (XMLNodes[i].ChildNodes.Count > 0) THEN
            ParseChilds(LNewNode, Flag1 or lInterest1, Flag2 or
              lInterest2 or lInterest3, XMLNodes[i].ChildNodes);
        END
        ELSE IF (trim(TDOMText(XMLNodes[i]).Data) <> '') and
          (flag1 or Flag2) THEN
        BEGIN
          IF not lInterest3 THEN
            Inc(Chapter[4]);
          XMLNodes[i].TextContent :=
            SetNewPhrase(Parent, XMLNodes[i].TextContent, Chapter);
        END;
    IF LSpanText <> '' THEN
    BEGIN
      LSpanTrans := SetNewPhrase(Parent, LSpanText, Chapter);
      lHandled   := False;
      IF length(lSpanArr) = 1 THEN
      BEGIN
        lSpanArr[0].TextContent := LSpanTrans;
        lHandled := True;
      END
      ELSE IF length(lSpanArr) = 3 THEN
      BEGIN
        lNode := lSpanArr[1].Attributes.GetNamedItem('text:style-name');
        IF assigned(lNode) THEN
          lStyle := Ansistring(lNode.TextContent);
        IF lStyle <> 'T1' THEN
        BEGIN
          lSearch := lSpanArr[1].TextContent;
          IF StringSplit(LSpanTrans, lSearch, lFirst, lRest) THEN
          BEGIN
            lSpanArr[0].TextContent := lFirst;
            lSpanArr[2].TextContent := lRest;
            lHandled := True;
          END;
        END;
      END
      ELSE IF length(lSpanArr) = 5 THEN
      BEGIN
        lNode := lSpanArr[1].Attributes.GetNamedItem('text:style-name');
        IF assigned(lNode) THEN
          lStyle := Ansistring(lNode.TextContent);
        IF lStyle <> 'T1' THEN
        BEGIN
          lSearch := lSpanArr[1].TextContent;
          IF StringSplit(LSpanTrans, lSearch, lFirst, lRest) THEN
          BEGIN
            lSpanArr[0].TextContent := lFirst;
            IF StringSplit(lRest, lSpanArr[3].TextContent,
              lMiddle, lLast) THEN
            BEGIN
              lSpanArr[2].TextContent := lMiddle;
              lSpanArr[4].TextContent := lLast;
              lHandled := True;
            END;
          END;
        END;
      END;
      IF not lHandled THEN
      BEGIN
        // Notfall Text in 1. Spann eintragen, rest löschen.
        lSpanArr[0].TextContent := LSpanTrans;
        FOR i := 1 TO high(lSpanArr) DO
          lSpanArr[i].TextContent := '';
      END;

    END;
  END;

BEGIN
  SaveConfigValues(sender);
  Chapter[1] := 0;
  ParseChilds('', False, False, fraXMLFile1.XmlDocument.ChildNodes);
END;

procedure TfrmXml2PoMain.FormResize(Sender: TObject);
VAR
  lWidth: Integer;
BEGIN
  lWidth := (ClientWidth - 30) div 3;
  fraPoFile1.Width := lWidth;
  pnlleft.Width := lWidth * 2;
END;

procedure TfrmXml2PoMain.FormShow(Sender: TObject);
BEGIN
  edtSourceDirChange(Sender);
END;

function TfrmXml2PoMain.AnalyzePhrase(Phr: String; out Excepts: TStringArray
  ): String;
VAR
  copyMode: Boolean;
  i:    Integer;
  lBlankCount: Integer;
  lLastCh, lTestCh: Char;
  Phr2: String;
BEGIN
  setlength(Excepts, 0);
  Result   := '';
  Phr      := StringReplace(Phr, '/', '//', [rfReplaceAll]);
  Phr      := StringReplace(Phr, '%', '/%', [rfReplaceAll]);
  // Look for "g e s p e r r t e n" Text
  copyMode := False;
  lLastCh  := ' ';
  Phr2     := '';
  FOR i := 1 TO length(Phr) DO
    IF not copyMode THEN
    BEGIN
      IF (lLastCh = ' ') and (copy(Phr, i, 1)[1] <> ' ') and
        (copy(Phr + ' ', i + 1, 1)[1] = ' ') and
        (((copy(Phr + '  ', i + 2, 1)[1] <> ' ') and
        (copy(Phr + '   ', i + 3, 1)[1] = ' ')) or
        ((copy(Phr + '  ', i + 2, 1)[1] = ' ') and
        (copy(Phr + '   ', i + 3, 1)[1] <> ' ') and
        (copy(Phr + '    ', i + 4, 1)[1] = ' '))) THEN
      BEGIN
        copyMode := True;
        Phr2     := Phr2 + Format(rsBigPaceholder, [Integer(copyMode)]);
        IF copy(Phr, i, 1)[1] in ['A'..'Z', 'a'..'z'] THEN
          Phr2 := Phr2 + ' ';
        Phr2   := Phr2 + copy(Phr, i, 1)[1];
      END
      ELSE IF (lLastCh <> ' ') or (copy(Phr, i, 1) <> ' ') THEN
        Phr2  := Phr2 + copy(Phr, i, 1);
      lLastCh := copy(Phr, i, 1)[1];
    END
    ELSE
    IF ((lLastCh = #195) and (Ord(copy(Phr, i, 1)[1]) > 128) and
      (copy(Phr, i, 1)[1] <> #195)) or (copy(Phr, i, 1)[1] = #195) THEN
    BEGIN
      //            lTestCh :=copy(Phr,i,1)[1];
      Phr2 := Phr2 + copy(Phr, i, 1);
      IF lLastCh <> #195 THEN
        lLastCh := copy(Phr, i, 1)[1];
    END
    ELSE
    IF (copy(Phr, i, 1)[1] <> ' ') and // akt. Zeichen ist kein Leerzeichen
      (copy(Phr + ' ', i + 1, 1)[1] <> ' ') THEN    // Nächstes Zeichen (wenn vorhanden)
    BEGIN
      copyMode := False;
      IF lLastCh in ['A'..'Z', 'a'..'z'] THEN
        Phr2 := Phr2 + ' ';
      Phr2   := Phr2 + Format(rsBigPaceholder, [Integer(copyMode)]);
      IF copy(Phr, i, 1)[1] in ['A'..'Z', 'a'..'z'] THEN
        Phr2 := Phr2 + ' ' + copy(Phr, i, 1)[1]
      ELSE
        Phr2 := Phr2 + copy(Phr, i, 1)[1];
      lLastCh := copy(Phr, i, 1)[1];
    END
    ELSE
    BEGIN
      IF (lLastCh = ' ') and ((copy(Phr, i, 1)[1] <> ' ') or
        ((copy(Phr, i, 1)[1] = ' ') and (copy(Phr2, length(phr2), 1) <> ' ')))
      THEN
        Phr2  := Phr2 + copy(Phr, i, 1);
      lLastCh := copy(Phr, i, 1)[1];
    END// Sonderprüfng: UTF8-Sonderzeichen
  ;
  IF copymode THEN
  BEGIN
    copyMode := False;
    IF lLastCh in ['A'..'Z', 'a'..'z'] THEN
      Phr2 := Phr2 + ' ';
    Phr    := Phr2 + Format(rsBigPaceholder, [Integer(copyMode)]);
  END
  ELSE
    Phr    := Phr2;
  // Ersetze Zahlen
  copyMode := True;
  FOR i := 1 TO length(Phr) DO
    IF copymode THEN
    BEGIN
      IF (lLastCh <> '%') and (charinset(copy(phr, i, 1)[1], ['0'..'9']) or
        ((copy(phr, i, 1) = '-') and (i < length(Phr)) and
        charinset(copy(phr, i + 1, 1)[i], ['0'..'9']))) THEN
      BEGIN
        CopyMode := False;
        setlength(Excepts, high(Excepts) + 2);
        Excepts[high(Excepts)] += copy(phr, i, 1);
        Result += format(rsExcPaceholder, [high(Excepts)]);
      END
      ELSE
        Result += copy(phr, i, 1);
      IF (lLastCh <> '%') or (not charinset(copy(phr, i, 1)[1], ['0'..'9'])) THEN
        lLastCh := copy(Phr, i, 1)[1];
    END
    ELSE
    IF charinset(copy(phr, i, 1)[1], ['.', '0'..'9']) or
      (charinset(copy(phr, i, 1)[1], [',', '-', '/', ':']) and
      (i < length(Phr)) and charinset(copy(phr, i + 1, 1)[1], ['/', '0'..'9'])) or
      ((copy(phr, i, 1)[1] = '%') and (i < length(Phr)) and not
      charinset(copy(phr, i + 1, 1)[1], ['0'..'9'])) THEN
      Excepts[high(Excepts)] += copy(phr, i, 1)
    ELSE
    BEGIN
      copymode := True;
      Result   += copy(phr, i, 1);
      lLastCh  := copy(Phr, i, 1)[1];
    END;
END;

function TfrmXml2PoMain.BuildPhrase(PhrStmp: String; const Excepts: TStringArray
  ): String;

VAR
  phr: String;
  i:   Integer;
  lps, lpe: SizeInt;
  lUTFMode: Boolean;
BEGIN
  phr := PhrStmp;
  Phr := StringReplace(Phr, '//', '// ', [rfReplaceAll]);
  Phr := StringReplace(Phr, '/%', '/% ', [rfReplaceAll]);
  FOR i := 0 TO high(Excepts) DO
    Phr := StringReplace(Phr, format(rsExcPaceholder, [i]), Excepts[i], [rfReplaceAll]);
  lps   := pos(format(rsBigPaceholder, [1]), phr);
  WHILE lps <> 0 DO
  BEGIN
    Delete(phr, lps, 4);
    IF copy(phr, lps, 1) = ' ' THEN
      Delete(phr, lps, 1);
    lpe := pos(format(rsBigPaceholder, [0]), copy(phr, lps, length(phr) - lps + 1));
    IF lpe <> 0 THEN
    BEGIN
      Delete(phr, lps + lpe - 1, 4);
      IF copy(phr, lps + lpe - 2, 1) = ' ' THEN
      BEGIN
        Delete(phr, lps + lpe - 2, 1);
        Dec(lpe);
      END;
      IF lps + lpe - 1 >= length(phr) THEN
        Dec(lpe);
      FOR i := lpe - 1 DOWNTO 1 DO
        IF (copy(phr, i + lps, 1)[1] <> ' ') or (i = lpe - 1) THEN
          insert(' ', phr, i + lps);
      IF lps > 1 THEN
        insert(' ', phr, lps);
      // UPF8-Sonderzeichen
      i := 0;
      lUTFMode := False;
      WHILE (i + lps < length(phr)) and (i < lpe * 2) DO
      BEGIN
        IF ((copy(phr, i + lps, 1)[1] = #195) or
          (lUTFMode and (Ord(copy(phr, i + lps + 2, 1)[1]) > 127) and
          (copy(phr, i + lps + 2, 1)[1] <> #195))) and
          (copy(phr, i + lps + 1, 1) = ' ') THEN
        BEGIN
          Delete(phr, i + lps + 1, 1);
          lUTFMode := True;
        END
        ELSE
          lUTFMode := False;
        Inc(i);
      END;
    END;
    lps := pos(format(rsBigPaceholder, [1]), Phr);
  END;
  Phr    := StringReplace(Phr, '/% ', '%', [rfReplaceAll]);
  Result := StringReplace(Phr, '// ', '/', [rfReplaceAll]);
END;

END.
