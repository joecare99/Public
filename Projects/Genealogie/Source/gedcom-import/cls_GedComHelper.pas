unit cls_GedComHelper;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Cmp_GedComFile, unt_IGenBase2,cls_GenHelperBase;

type
    { TGedComHelper }

    TGedComHelper = class(TGenHelperBase)
        FGedComFile: TGedComFile;

    private
        FFact: TGedComObj;

        function GetGEDTag(const SubType: integer): string;

        function IsFamilyEvent(const SubType: integer): boolean;
        procedure SetCitTitle(AValue: string);
        procedure SetGedComFile(AValue: TGedComFile);
        procedure WriteGedSource(GedObj: TGedComObj; qTitle, lsLink: string;
          lFileEx: boolean; lStrl: TStrings);
        procedure WriteGedText(GedObj: TGedComObj; lStrl: TStrings;
            lTag: string = 'TEX' + 'T');
        Function GetFather(aInd:TGedComObj):TGedComObj;
        Function GetMother(aInd:TGedComObj):TGedComObj;
    public
        {$ifdef DEBUG}
        FDebugDate:TDateTime;
       {$ENDIF}
        procedure StartFamily(Sender: TObject; aText, {%H-}aRef: string;
        {%H-}SubType: integer);override;
        procedure StartIndiv(Sender: TObject; aText, aRef: string;
          SubType: integer); override;
        procedure FamilyIndiv(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure FamilyType(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure FamilyDate(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure FamilyData(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure FamilyPlace(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure IndiData(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure IndiDate(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure IndiName(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure IndiPlace(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure IndiRef(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure IndiOccu(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure IndiRel(Sender: TObject; aText, aRef: string; SubType: integer);override;
        procedure CreateNewHeader(Filename: string);override;
        procedure SaveToFile(const Filename: string);override;

        function RplGedTags(Date: String): String;

        property GedComFile: TGedComFile read FGedComFile write SetGedComFile;
    end;

implementation

uses Unt_StringProcs;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

const
   gtAKA = 'AKA';
   gtBAPM = 'BAPM';
   gtBIRT = 'BIRT';
   gtBURI = 'BURI';
   gtCHAR = 'CHAR';
   gtCHIL = 'CHIL';
   gtCONC = 'CONC';
   gtCONT = 'CONT';
   gtDATA = 'DATA';
   gtDATE = 'DATE';
   gtDEAT = 'DEAT';
   gtDEST = 'DEST';
   gtDIV = 'DIV';
   gtEMIG = 'EMIG';
   gtFAM = 'FAM';
   gtFAMC = 'FAMC';
   gtFAMS = 'FAMS';
   gtFILE = 'FILE';
   gtFORM = 'FORM';
   gtGEDC = 'GEDC';
   gtGIVN = 'GIVN';
   gtHEAD = 'HEAD';
   gtHUSB = 'HUSB';
   gtINDI = 'INDI';
   gtLANG = 'LANG';
   gtMARR = 'MARR';
   gtNAME = 'NAME';
   gtNOTE = 'NOTE';
   gtOBJE = 'OBJE';
   gtOCCU = 'OCCU';
   gtPAGE = 'PAGE';
   gtPLAC = 'PLAC';
   gtREFN = 'REFN';
   gtRELI = 'RELI';
   gtRESI = 'RESI';
   gtSEX = 'SEX';
   gtSOUR = 'SOUR';
   gtSUBM = 'SUBM';
   gtSURN = 'SURN';
   gtTEXT = 'TEXT';
   gtTITL = 'TITL';
   gtTRLR = 'TRLR';
   gtTYPE = 'TYPE';
   gtVERS = 'VERS';
   gtWIFE = 'WIFE';
   gt_LINK = '_LINK';

procedure TGedComHelper.CreateNewHeader(Filename: string);
var
    lGedObj0: TGedComObj;
begin
    FGedComFile.Clear;
    lGedObj0 := FGedComFile.CreateChild('', gtHEAD);
    lGedObj0[gtSOUR].Data := 'GEDTest';
    lGedObj0[gtSOUR][gtNAME].Data := 'Test GedCom V0.1';
    lGedObj0[gtSOUR][gtVERS].Data := 'V0.1';
    lGedObj0[gtDEST].Data := 'GEDTest';
    {$ifdef DEBUG}
    if FDebugDate>0.0 then
      lGedObj0[gtDATE].Data := DateToStr(FDebugDate)
    else
    {$ENDIF}
      lGedObj0[gtDATE].Data := DateToStr(Now());
    lGedObj0[gtSUBM].Data := '@SUBM@';
    lGedObj0[gtCHAR].Data := FGedComFile.Encoding;
    lGedObj0[gtLANG].Data := 'GERMAN';
    lGedObj0[gtFILE].Data := FileName;
    lGedObj0[gtGEDC][gtVERS].Data := '5.5.1';
    lGedObj0[gtGEDC][gtFORM].Data := 'LINEAGE-LINKED';
    lGedObj0 := FGedComFile.CreateChild('@SUBM@', gtSUBM);
    lGedObj0[gtNAME].Data := 'Joe Care';
end;

procedure TGedComHelper.SaveToFile(const Filename: string);
var
    lSt: TMemoryStream;
begin
    FGedComFile[gtHEAD][gtFILE].Data := ExtractFileName(FileName);
    fgedComFile.CreateChild('', gtTRLR);
    lSt := TMemoryStream.Create;
      try
        FGedComFile.WriteToStream(lst);
        lst.Seek(0, soFromBeginning);
        lst.SaveToFile(FileName);
      finally
        FreeAndNil(lSt);
      end;
end;

procedure TGedComHelper.StartFamily(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam: TGedComObj;
    lFamID: string;
begin
    if atext.endswith(' ') then
       begin
         lFamID :='';
         Error(atext.QuotedString('"')+'is Illigal Family-Ref',aref,SubType)
       end;
    // Todo: Build Family-Reference
    lFamID := '@F' + aText + '@';
    lfam := FGedComFile.Find(lFamID);
    if not assigned(lfam) then
        lFam := FGedComFile.CreateChild(lFamID, gtFAM);
    if assigned(lFam) then
        lFam[gtREFN].Data := FOsbHdr + NormalCitRef(aText);
    if fCitTitle <> '' then
      begin
        if (FCitRefn = '') then
            FCitRefn := NormalCitRef(aText) + ', ' + FCitTitle;
        WriteGedSource(lFam[gtREFN], FCitRefn,'', False, FCitation);
      end
    else
        FCitRefn := '';
end;

procedure TGedComHelper.StartIndiv(Sender: TObject; aText, aRef: string;
    SubType: integer);

var
  lInd: TGedComObj;
begin
    if aRef='' then aref := aText;
    lInd := FGedComFile.Find('@' + aRef + '@');
    if not assigned(lInd) then
        lInd := FGedComFile.CreateChild('@' + aRef + '@', gtINDI);
    if assigned(lInd) then
       lind[gtREFN].Data := FOsbHdr+NormalCitRef(aRef);

    if fCitTitle <> '' then
      begin
        FCitRefn := NormalCitRef(aRef) + ', ' + FCitTitle;
        WriteGedSource(lInd[gtREFN], FCitRefn,'', False, FCitation);
      end
    else
        FCitRefn := '';
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
            lFam[gtHUSB].Data := lind.NodeID;
            lInd.CreateChild('', gtFAMS, lfam.NodeID);
          end
        else
        if SubType = 2 then
          begin
            lFam[gtWIFE].Data := lind.NodeID;
            lInd.CreateChild('',gtFAMS, lfam.NodeID);
          end;
        if SubType > 2 then
          begin
            lFam.CreateChild('', gtCHIL, lind.NodeID);
            lInd[gtFAMC].Data := lfam.NodeID;
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
        lFam[gtMARR].Data := aText;
        if FCitRefn <> '' then
            WriteGedSource(lFam[gtMARR], FCitRefn,'', False, FCitation);
      end;
end;

procedure TGedComHelper.FamilyDate(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam: TGedComObj;
    lGedTag: String;

  procedure SetGedDate(lObj: TGedComObj);
  begin
    if assigned(lObj) then
        lObj[lGedTag][gtDATE].Data := RplGedTags(aText);
  end;

begin
    lFam := FGedComFile.Find('@F' + aRef + '@');
    lGedTag := GetGedTag(SubType);
  if IsFamilyEvent(SubType) then
     SetGedDate(lFam)
   else
        begin
          SetGedDate(FGedComFile.Find('@I' + aRef +'M'+ '@'));
          SetGedDate(FGedComFile.Find('@I' + aRef +'F'+ '@'));
        end;
end;

procedure TGedComHelper.FamilyData(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TGedComObj;
  lGedTag: String;

  procedure SetGedData(lObj: TGedComObj);
    var lFact:TGedComObj;
  begin
    if not assigned(lObj) then
       exit;
    lObj[lGedTag].Data := aText;
    lFact := lObj[lGedTag];
    if FCitRefn <> '' then
       WriteGedSource(lFact, FCitRefn,'', False, FCitation);
  end;

begin
  lFam := FGedComFile.Find('@F' + aRef + '@');
  lGedTag := GetGedTag(SubType);
  if IsFamilyEvent(SubType) then
     SetGedData(lFam)
   else
        begin
          SetGedData(FGedComFile.Find('@I' + aRef +'M'+ '@'));
          SetGedData(FGedComFile.Find('@I' + aRef +'F'+ '@'));
        end;
end;

procedure TGedComHelper.FamilyPlace(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lFam: TGedComObj;
    lGedTag: String;

  procedure SetGedPlace(lObj: TGedComObj);
  begin
    if assigned(lObj) then
        lObj[lGedTag][gtPLAC].Data := aText.Replace('/',', ');
  end;

begin
    lFam := FGedComFile.Find('@F' + aRef + '@');
    lGedTag := GetGedTag(SubType);
  if IsFamilyEvent(SubType) then
     SetGedPlace(lFam)
   else
        begin
          SetGedPlace(FGedComFile.Find('@I' + aRef +'M'+ '@'));
          SetGedPlace(FGedComFile.Find('@I' + aRef +'F'+ '@'));
        end;
end;

procedure TGedComHelper.IndiName(Sender: TObject; aText, aRef: string;
    SubType: integer);
var
    lInd: TGedComObj;
    lPos, lDiff: Integer;
    OrgName: String;

  function EscapeSurname(nText: string):string;

  begin  // Todo -oJC: Adelsnamen "von XXX"
    result := nText;
    if not result.Contains('/') then
      begin
        lPos := result.LastIndexOf(' ');
        if lpos>=0 then
          result := result.Insert(lpos+1,'/')+'/';
      end;
  end;

begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if not assigned(lInd) then
        begin
          lInd := FGedComFile.CreateChild('@' + aRef + '@', gtINDI);
          if assigned(lInd) then
              lind[gtREFN].Data := FOsbHdr+NormalCitRef(aRef);
          if FCitRefn <> '' then
            WriteGedSource(lInd[gtREFN], FCitRefn,'', False, FCitation);
        end
      else
        begin
          if SubType = 0 then
            begin
               aText:=EscapeSurname(aText);
               OrgName := lInd[gtNAME].Data;
               if GetSoundex(OrgName) <> GetSoundex(aText) then
                  begin
                     lDiff := EvalCompareStr2(GetSoundex(OrgName), GetSoundex(aText));
                     if ldiff>3 then
                 Warning('IndiName: '+OrgName+'<>'+aText+' ' +
                   inttostr(ldiff),aRef,SubType)
                     else if ldiff > 7 then
                       Error('IndiName: '+OrgName+'<>'+aText+' ' +
                         inttostr(ldiff),aRef,SubType);
                  end
              end;
        end;
    if SubType = 0 then
      begin
        aText:=EscapeSurname(aText);
        lInd[gtNAME].Data := aText;
        if FCitRefn <> '' then
            WriteGedSource(lInd[gtNAME], FCitRefn,'', False, FCitation);
      end
    else
    if SubType = 1 then
      begin
        lInd[gtNAME].Data := '/' + aText + '/';
        if FCitRefn <> '' then
            WriteGedSource(lInd[gtNAME], FCitRefn,'', False, FCitation);
        lInd[gtNAME][gtSURN].Data := aText;
      end
    else
    if SubType = 2 then
      begin
        lInd[gtNAME].Data := aText + ' ' + lInd[gtNAME].Data;
        lInd[gtNAME][gtGIVN].Data := aText;
      end
    else
    if SubType = 3 then
      begin
        lInd.CreateChild('', gtNAME, aText)[gtTYPE].Data := gtAKA;
      end
    else
    if SubType = 4 then
      begin
        lInd[gtTITL].Data := aText;
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
        if lGedtag = gtNOTE then
          begin
            FFact := lind[lGedTag];
            if FFact.Data = '' then
              FFact.Data := aText
            else
              FFact.CreateChild('', gtCONT, aText);;
          end
        else
        if subtype < 12 then
          begin
            lInd[lGedTag].Data :=  aText;
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
        if lGedTag <> gtNOTE then
          begin
            if lGedtag = gtNOTE then
              begin
                FFact := lind[lGedTag];
                if FFact.Data = '' then
                  FFact.Data := 'am '+aText
                else
                  FFact.CreateChild('', gtCONT,'am '+ aText);;
              end
            else
            if subtype < 12 then
              begin
                if lValidDate then
                  lInd[lGedTag][gtDATE].Data := lGedDt
                else
                  lInd[lGedTag].Data := lGedDt;
                lYear := 5*((lYear+2)div 5);

                if FCitRefn <> '' then
                    WriteGedSource(lInd[lGedTag], FCitRefn,'', False, FCitation);
                if lValidDate
                  and (lGedTag=gtBAPM)
                  and (lInd[gtBIRT][gtDATE].Data = '') then
                    if lgedDT[1] in ['0'..'9'] then
                       lInd[gtBIRT][gtDATE].Data :=CGedDateModif[13]+' '+lGedDt
                    else
                      lInd[gtBIRT][gtDATE].Data :=CGedDateModif[1]+' '+inttostr(lYear);
                if lValidDate
                  and ((lGedTag=gtBAPM) or (lGedTag=gtBIRT))
                  and assigned(GetFather(lind))
                  and (GetFather(lind)[gtBIRT][gtDATE].Data = '') then
                      GetFather(lind)[gtBIRT][gtDATE].Data :=CGedDateModif[1]+' '+inttostr(lYear-30);
                if lValidDate
                  and ((lGedTag=gtBAPM) or (lGedTag=gtBIRT))
                  and assigned(GetMother(lind))
                  and (GetMother(lind)[gtBIRT][gtDATE].Data = '') then
                      GetMother(lind)[gtBIRT][gtDATE].Data :=CGedDateModif[1]+' '+inttostr(lYear-25);
              end
            else
            if assigned(FFact) and (FFact.Parent = lind as IGedParent) and
                (FFact.NodeType = lGedTag) then
                fFact[gtDATE].Data := lGedDt;
          end
        else
            lind[gtDATE].Data := aText;
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
        if lGedTag <> gtNOTE then
          begin
            if lGedtag = gtNOTE then
              begin
                FFact := lind[lGedTag];
                if FFact.Data = '' then
                  FFact.Data := 'in '+aText
                else
                  FFact.CreateChild('', gtCONT, 'in '+aText);;
              end
            else
            if subtype < 12 then
              begin
                lInd[lGedTag][gtPLAC].Data := aText.Replace('/',', ');
                if FCitRefn <> '' then
                    WriteGedSource(lInd[lGedTag], FCitRefn,'', False, FCitation);
              end
            else
            if assigned(FFact) and (ffact.Parent = lind as IGedParent) and
                (FFact.NodeType = lGedTag) then
                fFact[gtPLAC].Data := aText.Replace('/',', ');
          end
        else
            lind[gtPLAC].Data := aText.Replace('/',', ');
      end;

end;

procedure TGedComHelper.IndiRef(Sender: TObject; aText, aRef: string; SubType: integer);
var
    lInd: TGedComObj;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    if assigned(lInd) then
      begin
        lind[gtREFN].Data :=FOsbHdr+ NormalCitRef(aText);
        if FCitRefn <> '' then
            WriteGedSource(lInd[gtREFN], FCitRefn,'', False, FCitation);
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
        lind[gtOCCU].Data := aText;
        if FCitRefn <> '' then
            WriteGedSource(lInd[gtOCCU], FCitRefn,'', False, FCitation);
      end;
end;

procedure TGedComHelper.IndiRel(Sender: TObject; aText, aRef: string; SubType: integer);
var
    lInd, lInd2, lFam, lInd3, lFam2: TGedComObj;
    lIndSex: String;
    lFound: Boolean;
    i: Integer;
begin
    lInd := FGedComFile.Find('@' + aRef + '@');
    // exit;
    if assigned(lInd) and (aText<>'') then
      begin
        if (subtype = 2) then
          begin
            lIndSex:=lind[gtSEX].Data;
            if (lIndSex <> 'M') and  (lIndSex <>'F') then
              lIndSex := 'U';
            aText:=trim(aText);
            lInd2 := FGedComFile.Find('@I' + atext + lIndSex + '@');
            if not assigned(lInd2) then
                FGedComFile.AppendIndex('@I' + atext + lIndSex + '@', lind)
            else
              begin
                // Prüfe Merge

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
            if assigned(lFam) and (lInd[gtFAMC].Data <> lFam.NodeID) then
              begin
                Error('IndRel: '+aRef+' not in '+aText,aRef,SubType);
                lFam.CreateChild('', gtCHIL, lind.NodeID);
                lind[gtFAMC].link := lFam;
              end
          end;
      end
    else
      if aText='' then
        Warning('Relation text empty',aRef,SubType);
end;

procedure TGedComHelper.WriteGedText(GedObj: TGedComObj; lStrl: TStrings;
    lTag: string);
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
            GedObj[lTag].CreateChild('', gtCONT, copy(s, 1, lpp));
        s := copy(s, lpp + 1, maxint);
        while s <> '' do
          begin
            lpp := s.IndexOf(' ', 55);
            if lpp = -1 then
                lpp := 90;
            GedObj[lTag].CreateChild('', gtCONC, copy(s, 1, lpp));
            s := copy(s, lpp + 1, maxint);
          end;
      end;
end;

function TGedComHelper.GetFather(aInd: TGedComObj): TGedComObj;
var
  lfam, lHusb: TGedComObj;
begin
  result := nil;
  lfam := aind.Find(gtFAMC);
  if assigned(lfam) then lfam:=lfam.Link;
  if assigned(lFam) then
    lHusb:= lFam.find(gtHUSB)
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
    lfam := aind.Find(gtFAMC);
    if assigned(lfam) then lfam:=lfam.Link;
    if assigned(lFam) then
      lWife:= lFam.find(gtWIFE)
    else
      lWife := nil;
    if assigned(lWife) then
      result:= lWife.link;
end;

function TGedComHelper.GetGEDTag(const SubType: integer): string;
begin
    case SubType of
        0: Result := gtREFN;  // Refence
        1: Result := gtBIRT;  // Geburts-Event
        2: Result := gtBAPM;  // Tauf-Event
        3: Result := gtMARR;  // Hochzeits-Event
        4: Result := gtDEAT;  // Gestorben-Event
        5: Result := gtBURI;  // Begraben-Event
        6: Result := gtSEX;   // Geschlechts-Fact
        7: Result := gtOCCU;  // Berufs-Fact
        8: Result := gtRELI;  // Religions-Fact
        9: Result := gtRESI;  // Wohnort-Fact
        10: Result := gtGIVN; // Vorname-Fact
        11: Result := gtAKA;  // Also-Known-As-Fact
        12: Result := gtOCCU;
        13: Result := gtRESI;
        14: Result := gtEMIG;  // Ausgewandert-Event
        17: result := gtDIV; // Scheidung
        ord(evt_Age):Result := gtDEAT;
        ord(evt_Partner): result := gtNOTE
        else
            Result := gtNOTE;  // Notitz
      end;
end;

function TGedComHelper.IsFamilyEvent(const SubType: integer): boolean;

begin
  result := subtype in [0,3,17]
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
    if GedObj[gtSOUR].Data <> '' then
        exit;
    GedObj[gtSOUR].Data := '@S1@';
    GedObj[gtSOUR][gtPAGE].Data := qTitle;
    if lFileEx then
        // 3: Titel: Stichwort, ersch. Datum, Auftrag
        GedObj[gtSOUR][gtOBJE].Data := '@M' + lsLink + '@';
    if lStrl.Text <> '' then
        WriteGedText(GedObj[gtSOUR][gtDATA], lstrl);
    //Todo: Link - Tag
    if lsLink<>'' then
        GedObj[gtSOUR][gt_LINK].Data := lsLink;
    if not assigned(FGedComFile['@S1@']) then
        FGedComFile.CreateChild('@S1@', gtSOUR)[gtTITL].Data := 'Quelle';
end;

end.
