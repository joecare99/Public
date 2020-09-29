unit cls_GedComHelper;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Cmp_GedComFile;

type

    { TGedComHelper }

    TGedComHelper = class
        FGedComFile: TGedComFile;

    private
        FCitation: TStrings;
        FCitRefn: string;
        FCitTitle: string;
        FFact: TGedComObj;
        FOsbHdr: string;
        function GetGEDTag(const SubType: integer): string;
        procedure SetCitation(AValue: TStrings);
        procedure SetCitTitle(AValue: string);
        procedure SetGedComFile(AValue: TGedComFile);
        procedure SetOsbHdr(AValue: string);
        procedure WriteGedSource(GedObj: TGedComObj; qTitle, lsLink: string;
          lFileEx: boolean; lStrl: TStrings);
        procedure WriteGedText(GedObj: TGedComObj; lStrl: TStrings;
            lTag: string = 'TEX' + 'T');
        Function GetFather(aInd:TGedComObj):TGedComObj;
        Function GetMother(aInd:TGedComObj):TGedComObj;
    public
        procedure StartFamily(Sender: TObject; aText, {%H-}aRef: string;
        {%H-}SubType: integer);
        procedure StartIndiv(Sender: TObject; aText, aRef: string;
          SubType: integer);
        procedure FamilyIndiv(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure FamilyType(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure FamilyDate(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure FamilyData(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure FamilyPlace(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure IndiData(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure IndiDate(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure IndiName(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure IndiPlace(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure IndiRef(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure IndiOccu(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure IndiRel(Sender: TObject; aText, aRef: string; SubType: integer);
        procedure CreateNewHeader(Filename: string);
        procedure SaveToFile(const Filename: string);
        procedure FireEvent(Sender: TObject; aSTa: TStringArray);
        function RplGedTags(Date: String): String;
        function NormalCitRef(const aText: string): String;
        property GedComFile: TGedComFile read FGedComFile write SetGedComFile;
        property Citation: TStrings read FCitation write SetCitation;
        property CitTitle: string read FCitTitle write SetCitTitle;
        property OsbHdr: string read FOsbHdr write SetOsbHdr;
    end;

implementation

uses Unt_StringProcs;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

procedure TGedComHelper.CreateNewHeader(Filename: string);
var
    lGedObj0: TGedComObj;
begin
    FGedComFile.Clear;
    lGedObj0 := FGedComFile.CreateChild('', 'HEAD');
    lGedObj0['SOUR'].Data := 'GEDTest';
    lGedObj0['SOUR']['NAME'].Data := 'Test GedCom V0.1';
    lGedObj0['SOUR']['VERS'].Data := 'V0.1';
    lGedObj0['DEST'].Data := 'GEDTest';
    lGedObj0['DATE'].Data := DateToStr(Now());
    lGedObj0['SUBM'].Data := '@SUBM@';
    lGedObj0['CHAR'].Data := FGedComFile.Encoding;
    lGedObj0['LANG'].Data := 'GERMAN';
    lGedObj0['FILE'].Data := FileName;
    lGedObj0['GEDC']['VERS'].Data := '5.5.1';
    lGedObj0['GEDC']['FORM'].Data := 'LINEAGE-LINKED';
    lGedObj0 := FGedComFile.CreateChild('@SUBM@', 'SUBM');
    lGedObj0['NAME'].Data := 'Joe Care';
end;

procedure TGedComHelper.SaveToFile(const Filename: string);
var
    lSt: TMemoryStream;
begin
    FGedComFile['HEAD']['FILE'].Data := ExtractFileName(FileName);
    fgedComFile.CreateChild('', 'TRLR');
    lSt := TMemoryStream.Create;
      try
        FGedComFile.WriteToStream(lst);
        lst.Seek(0, soFromBeginning);
        lst.SaveToFile(FileName);
      finally
        FreeAndNil(lSt);
      end;
end;

procedure TGedComHelper.FireEvent(Sender: TObject; aSTa: TStringArray);
var
    lInt: longint;
begin
    if (length(aSTa) = 4) and trystrtoint(asta[3], lInt) then
        case aSTa[0] of
            'ParserStartIndiv': StartIndiv(Sender, aSTa[1], aSTa[2], lInt);
            'ParserStartFamily': StartFamily(Sender, aSTa[1], aSTa[2], lInt);
            'ParserFamilyType': FamilyType(Sender, aSTa[1], aSTa[2], lInt);
            'ParserFamilyDate': FamilyDate(Sender, aSTa[1], aSTa[2], lInt);
            'ParserFamilyData': FamilyData(Sender, aSTa[1], aSTa[2], lInt);
            'ParserFamilyIndiv': FamilyIndiv(Sender, aSTa[1], aSTa[2], lInt);
            'ParserFamilyPlace': FamilyPlace(Sender, aSTa[1], aSTa[2], lInt);
            'ParserIndiData': IndiData(Sender, aSTa[1], aSTa[2], lInt);
            'ParserIndiDate': IndiDate(Sender, aSTa[1], aSTa[2], lInt);
            'ParserIndiName': IndiName(Sender, aSTa[1], aSTa[2], lInt);
            'ParserIndiOccu': IndiOccu(Sender, aSTa[1], aSTa[2], lInt);
            'ParserIndiPlace': IndiPlace(Sender, aSTa[1], aSTa[2], lInt);
            'ParserIndiRef': IndiRef(Sender, aSTa[1], aSTa[2], lInt);
            'ParserIndiRel': IndiRel(Sender, aSTa[1], aSTa[2], lInt);
          else
          end;
end;

procedure TGedComHelper.StartFamily(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam: TGedComObj;
    lFamID: string;
begin
    if atext.endswith(' ') then
       lFamID :='';
    // Todo: Build Family-Reference
    lFamID := '@F' + aText + '@';
    lfam := FGedComFile.Find(lFamID);
    if not assigned(lfam) then
        lFam := FGedComFile.CreateChild(lFamID, 'FAM');
    if assigned(lFam) then
        lFam['REFN'].Data := FOsbHdr + NormalCitRef(aText);
    if fCitTitle <> '' then
      begin
        if (FCitRefn = '') then
            FCitRefn := NormalCitRef(aText) + ', ' + FCitTitle;
        WriteGedSource(lFam['REFN'], FCitRefn,'', False, FCitation);
      end
    else
        FCitRefn := '';
end;

procedure TGedComHelper.StartIndiv(Sender: TObject; aText, aRef: string;
    SubType: integer);

var
  lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if not assigned(lInd) then
        lInd := FGedComFile.CreateChild('@' + aRef + '@', 'INDI');
    if assigned(lInd) then
       lind['REFN'].Data := FOsbHdr+NormalCitRef(aRef);

    if fCitTitle <> '' then
      begin
        FCitRefn := NormalCitRef(aRef) + ', ' + FCitTitle;
        WriteGedSource(lInd['REFN'], FCitRefn,'', False, FCitation);
      end
    else
        FCitRefn := '';
end;

procedure TGedComHelper.SetOsbHdr(AValue: string);
begin
    if FOsbHdr = AValue then
        Exit;
    FOsbHdr := AValue;
end;

procedure TGedComHelper.FamilyIndiv(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam, lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aText + '@');
    lFam := FGedComFile.Find('@F' + aRef + '@');
    if assigned(lInd) and assigned(lFam) then
      begin
        if SubType = 1 then
          begin
            lFam['HUSB'].Data := lind.NodeID;
            lInd.CreateChild('','FAMS', lfam.NodeID);
          end
        else
        if SubType = 2 then
          begin
            lFam['WIFE'].Data := lind.NodeID;
            lInd.CreateChild('','FAMS', lfam.NodeID);
          end;
        if SubType > 2 then
          begin
            lFam.CreateChild('', 'CHIL', lind.NodeID);
            lInd['FAMC'].Data := lfam.NodeID;
          end;
      end;
end;

procedure TGedComHelper.FamilyType(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam: TGedComObj;
begin
    lFam := FGedComFile.Find('@F' + aRef + '@');
    if assigned(lFam) then
      begin
        lFam['MARR'].Data := aText;
        if FCitRefn <> '' then
            WriteGedSource(lFam['MARR'], FCitRefn,'', False, FCitation);
      end;
end;

procedure TGedComHelper.FamilyDate(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam: TGedComObj;
    lGedTag: String;
begin
    lFam := FGedComFile.Find('@F' + aRef + '@');
    lGedTag := GetGedTag(SubType);
    if assigned(lFam) then
        lFam[lGedTag]['DATE'].Data := aText;
end;

procedure TGedComHelper.FamilyData(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TGedComObj;
  lGedTag: String;
begin
  lFam := FGedComFile.Find('@F' + aRef + '@');
  lGedTag := GetGedTag(SubType);
  if assigned(lFam) then
      lFam[lGedTag].Data := RplGedTags(aText);
end;

procedure TGedComHelper.FamilyPlace(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam: TGedComObj;
begin
    lFam := FGedComFile.Find('@F' + aRef + '@');
    if assigned(lFam) then
        lFam['MARR']['PLAC'].Data := aText;
end;

procedure TGedComHelper.IndiName(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lInd: TGedComObj;
    lPos: Integer;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if not assigned(lInd) then
        begin
          lInd := FGedComFile.CreateChild('@' + aRef + '@', 'INDI');
          if assigned(lInd) then
              lind['REFN'].Data := FOsbHdr+NormalCitRef(aRef);
          if FCitRefn <> '' then
            WriteGedSource(lInd['REFN'], FCitRefn,'', False, FCitation);
        end;
    if SubType = 0 then
      begin
        if not aText.Contains('/') then
          begin
            lPos := atext.LastIndexOf(' ');
            if lpos>=0 then
              atext := atext.Insert(lpos+1,'/')+'/';
          end;
        lInd['NAME'].Data := aText;
        if FCitRefn <> '' then
            WriteGedSource(lInd['NAME'], FCitRefn,'', False, FCitation);
      end
    else
    if SubType = 1 then
      begin
        lInd['NAME'].Data := '/' + aText + '/';
        if FCitRefn <> '' then
            WriteGedSource(lInd['NAME'], FCitRefn,'', False, FCitation);
        lInd['NAME']['SURN'].Data := aText;
      end
    else
    if SubType = 2 then
      begin
        lInd['NAME'].Data := aText + ' ' + lInd['NAME'].Data;
        lInd['NAME']['GIVN'].Data := aText;
      end
    else
    if SubType = 3 then
      begin
        lInd.CreateChild('', 'NAME', aText)['TYPE'].Data := 'AKA';
      end
    else
    if SubType = 4 then
      begin
        lInd['TITL'].Data := aText;
      end;

end;

procedure TGedComHelper.IndiData(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lInd: TGedComObj;
    lGedTag: string;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    lGedTag := GetGedTag(SubType);
    if assigned(lInd) then
      begin
        if subtype < 12 then
          begin
            lInd[lGedTag].Data := aText;
            ffact := lInd[lGedTag];
          end
        else
            FFact := lind.CreateChild('', lGedTag, aText);
        if FCitRefn <> '' then
            WriteGedSource(FFact, FCitRefn,'', False, FCitation);
      end;
end;

const CGedDateModif:array[0..15] of string=
     ('(s)','EST', // Geschätztes datum
      'um','ABT', // ungefähres Datum
      '(err)','CAL', // erreichnetes Datum
      'nach','AFT',  // Ereigniss hat (kurz) danach stattgefunden
      'seit','AFT',
      'frühestens','AFT',
      'vor','BEF',  // Ereigniss hatt (kurz) davor stattgefunden
      'ca','ABT');

  function TGedComHelper.RplGedTags(Date:String):String;
    var
      i: Integer;
    begin
      for i := 0 to high(CGedDateModif) div 2 do
        if Date.StartsWith(CGedDateModif[i*2]) then
          exit( CGedDateModif[i*2+1]+date.Remove(0,length(CGedDateModif[i*2])));
      result := Date;
    end;

procedure TGedComHelper.IndiDate(Sender: TObject; aText, aRef: string;
    SubType: integer);


var
    lInd: TGedComObj;
    lGedTag, lGedDt: string;
    lYear: Longint;
    lValidDate:boolean;

begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    lGedTag := GetGEDTag(SubType);
    lGedDt :=RplGedTags(atext);
    lValidDate := TryStrToInt(rightstr(lGedDt,4),lYear);
    if assigned(lInd) then
      begin
        if lGedTag <> 'NOTE' then
          begin
            if subtype < 12 then
              begin
                if lValidDate then
                  lInd[lGedTag]['DATE'].Data := lGedDt
                else
                  lInd[lGedTag].Data := lGedDt;
                lYear := 5*((lYear+2)div 5);

                if FCitRefn <> '' then
                    WriteGedSource(lInd[lGedTag], FCitRefn,'', False, FCitation);
                if lValidDate
                  and (lGedTag='BAPM')
                  and (lInd['BIRT']['DATE'].Data = '') then
                    if lgedDT[1] in ['0'..'9'] then
                       lInd['BIRT']['DATE'].Data :='BEF '+lGedDt
                    else
                      lInd['BIRT']['DATE'].Data :='EST '+inttostr(lYear);
                if lValidDate
                  and ((lGedTag='BAPM') or (lGedTag='BIRT'))
                  and assigned(GetFather(lind))
                  and (GetFather(lind)['BIRT']['DATE'].Data = '') then
                      GetFather(lind)['BIRT']['DATE'].Data :='EST '+inttostr(lYear-30);
                if lValidDate
                  and ((lGedTag='BAPM') or (lGedTag='BIRT'))
                  and assigned(GetMother(lind))
                  and (GetMother(lind)['BIRT']['DATE'].Data = '') then
                      GetMother(lind)['BIRT']['DATE'].Data :='EST '+inttostr(lYear-25);
              end
            else
            if assigned(FFact) and (FFact.Parent = lind as IGedParent) and
                (FFact.NodeType = lGedTag) then
                fFact['DATE'].Data := lGedDt;
          end
        else
            lind['DATE'].Data := aText;
      end;
end;

procedure TGedComHelper.IndiPlace(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lInd: TGedComObj;
    lGedTag: string;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    lGedTag := GetGEDTag(SubType);
    if assigned(lInd) then
      begin
        if lGedTag <> 'NOTE' then
          begin
            if subtype < 12 then
              begin
                lInd[lGedTag]['PLAC'].Data := aText;
                if FCitRefn <> '' then
                    WriteGedSource(lInd[lGedTag], FCitRefn,'', False, FCitation);
              end
            else
            if assigned(FFact) and (ffact.Parent = lind as IGedParent) and
                (FFact.NodeType = lGedTag) then
                fFact['PLAC'].Data := aText;
          end
        else
            lind['PLAC'].Data := aText;
      end;

end;

procedure TGedComHelper.IndiRef(Sender: TObject; aText, aRef: string; SubType: integer);
var
    lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if assigned(lInd) then
      begin
        lind['REFN'].Data :=FOsbHdr+ NormalCitRef(aText);
        if FCitRefn <> '' then
            WriteGedSource(lInd['REFN'], FCitRefn,'', False, FCitation);
      end;
end;

procedure TGedComHelper.IndiOccu(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if assigned(lInd) then
      begin
        lind['OCCU'].Data := aText;
        if FCitRefn <> '' then
            WriteGedSource(lInd['OCCU'], FCitRefn,'', False, FCitation);
      end;
end;

procedure TGedComHelper.IndiRel(Sender: TObject; aText, aRef: string; SubType: integer);
var
    lInd, lInd2, lFam, lInd3, lFam2: TGedComObj;
    lIndSex: String;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    // exit;
    if assigned(lInd) then
      begin
        if (subtype = 2) then
          begin
            lIndSex:=lind['SEX'].Data;
            if (lIndSex <> 'M') and  (lIndSex <>'F') then
              lIndSex := 'U';
            aText:=trim(aText);
            lInd2 := FGedComFile.Find('@I' + atext + lIndSex + '@');
            if not assigned(lInd2) then
                FGedComFile.AppendIndex('@I' + atext + lIndSex + '@', lind)
            else
              begin

                FGedComFile.Merge(lind,lind2);
                // Merge Father
                lInd3 := FGedComFile.Find('@' + aRef + 'M@');
                lInd2 := FGedComFile.Find('@I' + atext + lIndSex + 'M@');
                  if  assigned(lInd3) and assigned(lInd2) then
                    FGedComFile.Merge(lind3,lind2);
                  // Merge Mother
                  lInd3 := FGedComFile.Find('@' + aRef + 'F@');
                  lInd2 := FGedComFile.Find('@I' + atext + lIndSex + 'F@');
                    if  assigned(lInd3) and assigned(lInd2) then
                      FGedComFile.Merge(lind3,lind2);

                 lFam := FGedComFile.Find('@F' + copy(aRef,2) + '@');
                 lFam2 := FGedComFile.Find('@F' + aText +lIndSex+ '@');
                 if  assigned(lFam) and assigned(lFam2) then
                   begin
                //      lfam2.clear;
                      FGedComFile.Merge(lFam,lfam2);
                   end;
              end;
          end
        else
          begin

            lFam := FGedComFile.Find('@F' + aText + '@');
            if assigned(lFam) and (lInd['FAMC'].Data <> lFam.NodeID) then
              begin

                lFam.CreateChild('', 'CHIL', lind.NodeID);
                lind['FAMC'].link := lFam;
              end;
          end;
      end;
end;

procedure TGedComHelper.WriteGedText(GedObj: TGedComObj; lStrl: TStrings;
    lTag: string = 'TEXT');
var
    i, lpp: integer;
    s: string;
begin
    for i := 0 to lstrl.Count - 1 do
      begin
        s := lstrl[i].replace(#10,' ').replace(#13,' ');
        lpp := s.IndexOf(' ', 55);

        if lpp = -1 then
            lpp := 90;
        if i = 0 then
            GedObj[lTag].Data := copy(s, 1, lpp)
        else
            GedObj[lTag].CreateChild('', 'CONT', copy(s, 1, lpp));
        s := copy(s, lpp + 1, maxint);
        while s <> '' do
          begin
            lpp := s.IndexOf(' ', 55);
            if lpp = -1 then
                lpp := 90;
            GedObj[lTag].CreateChild('', 'CONC', copy(s, 1, lpp));
            s := copy(s, lpp + 1, maxint);
          end;
      end;
end;

function TGedComHelper.GetFather(aInd: TGedComObj): TGedComObj;
var
  lfam, lHusb: TGedComObj;
begin
  result := nil;
  lfam := aind.Find('FAMC');
  if assigned(lfam) then lfam:=lfam.Link;
  if assigned(lFam) then
    lHusb:= lFam.find('HUSB')
  else
    lhusb := nil;
  if assigned(lHusb) then
    result:= lHusb.link;
end;

function TGedComHelper.GetMother(aInd: TGedComObj): TGedComObj;
var
  lfam, lWife: TGedComObj;
begin
  result := nil;
    lfam := aind.Find('FAMC');
    if assigned(lfam) then lfam:=lfam.Link;
    if assigned(lFam) then
      lWife:= lFam.find('WIFE')
    else
      lWife := nil;
    if assigned(lWife) then
      result:= lWife.link;
end;

function TGedComHelper.NormalCitRef(const aText: string): String;
var
  lText: String;
  lp1, i: Integer;
begin
  if aText.StartsWith('F') or aText.StartsWith('I') then
    lText := atext.Substring(1)
  else
    lText:=aText;

  // 1. Ziffernfolge wird
  lp1 :=lText.IndexOfAny('0123456789');
  if lp1 <0 then exit(lText);

  i := lp1 +1;
  while (i<length(lText)) and (lText.Chars[i] in Ziffern) do
    inc(i);
  result := lText.Insert(lp1,StringOfChar('0',4-(i-lp1)));
end;

procedure TGedComHelper.SetCitation(AValue: TStrings);
begin
    if @FCitation = @AValue then
        Exit;
    FCitation := AValue;
    FCitRefn:='';
end;

function TGedComHelper.GetGEDTag(const SubType: integer): string;
begin
    case SubType of
        0: Result := 'REFN';
        1: Result := 'BIRT';
        2: Result := 'BAPM';
        3: Result := 'MARR';
        4: Result := 'DEAT';
        5: Result := 'BURI';
        6: Result := 'SEX';
        7: Result := 'OCCU';
        8: Result := 'RELI';
        9: Result := 'RESI';
        10: Result := 'GIVN';
        11: Result := 'AKA';
        12: Result := 'OCCU';
        13: Result := 'RESI';
        14: Result := 'EMIG'
        else
            Result := 'NOTE';
      end;
end;

procedure TGedComHelper.SetCitTitle(AValue: string);
begin
    if FCitTitle = AValue then
        Exit;
    FCitTitle := AValue;
end;

procedure TGedComHelper.SetGedComFile(AValue: TGedComFile);
begin
    if @FGedComFile = @AValue then
        Exit;
    FGedComFile := AValue;
end;

procedure TGedComHelper.WriteGedSource(GedObj: TGedComObj; qTitle, lsLink: string;
    lFileEx: boolean; lStrl: TStrings);

begin
    if GedObj['SOUR'].Data <> '' then
        exit;
    GedObj['SOUR'].Data := '@S1@';
    GedObj['SOUR']['PAGE'].Data := qTitle;
    if lFileEx then
        // 3: Titel: Stichwort, ersch. Datum, Auftrag
        GedObj['SOUR']['OBJE'].Data := '@M' + lsLink + '@';
    if lStrl.Text <> '' then
        WriteGedText(GedObj['SOUR']['DATA'], lstrl);
    //Todo: Link - Tag
    if lsLink<>'' then
        GedObj['SOUR']['_LINK'].Data := lsLink;
    if not assigned(FGedComFile['@S1@']) then
        FGedComFile.CreateChild('@S1@', 'SOUR')['TITL'].Data := 'Quelle';
end;

end.
