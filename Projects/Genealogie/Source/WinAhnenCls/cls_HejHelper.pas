unit cls_HejHelper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_HejData,cls_HejIndData;

type

{ THejHelper }

 { TVirtFamily }

 TVirtFamily=Class
   Ref:string;
   Husband,
   Spouse,
   Marr,
   Marr2:integer;
   Children:array of Integer;
   Kind:Integer;
   Date,
   Place:String;
   Procedure AppendChild(aInd:integer);
   Procedure ReplaceInd(aInd,aind2:integer);
   destructor Destroy; override;
 end;

 THejHelper=Class
private
  FCitation: TStrings;
  FCitRefn,
  FCitTitle: string;
  FHejObj: TClsHejGenealogy;
  FIndIndex:TStrings;
  FFamily:Array of TVirtFamily;
  FOsbHdr: string;
  procedure AppendIndex(aRef: string; aIndID: integer);
  function GetFami(Idx: Variant): TVirtFamily;
  function GetFieldof(const SubType, knd: integer): TEnumHejIndDatafields;
  function GetIndi(Idx: Variant): THejIndData;
  function HejFamilyType(const SubType: integer): String;
  function RplHejDModiv(Date: String): String;
  procedure SetCitation(AValue: TStrings);
  procedure SetCitTitle(AValue: string);
  procedure SetHejObj(AValue: TClsHejGenealogy);
  procedure SetOsbHdr(AValue: string);
  Function FindInd(aRef:String;aCre:Boolean=false):integer;
  function FindFam(aRef: String; aCre: Boolean=False): TVirtFamily;
public
  procedure StartFamily(Sender: TObject; aText, {%H-}aRef: string;
  {%H-}SubType: integer);
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
  procedure SaveToFile(Filename: string);
public
  Procedure Clear;
  procedure FireEvent(Sender: TObject; aSTa: TStringArray);
  Procedure MergePerson(lInd,lInd2:integer);
  Procedure MergeFamily(lInd,lInd2:TVirtFamily);
  property HejObj: TClsHejGenealogy read FHejObj write SetHejObj;
  property Citation: TStrings read FCitation write SetCitation;
  property CitTitle: string read FCitTitle write SetCitTitle;
  property OsbHdr: string read FOsbHdr write SetOsbHdr;
  property Indi[Idx:Variant]:THejIndData read GetIndi;
  property Fami[Idx:Variant]:TVirtFamily read GetFami;
public
    Constructor Create;
    destructor Destroy; override;
   end;

implementation

uses cls_HejMarrData,cls_HejPlaceData,strutils,variants;

{ TVirtFamily }

procedure TVirtFamily.AppendChild(aInd: integer);
begin
  setlength(Children,high(Children)+2);
  Children[high(Children)]:=aInd;
end;

procedure TVirtFamily.ReplaceInd(aInd, aind2: integer);
var
  i: Integer;
begin
  if Husband = aInd then
    Husband:=aind2;
  if Spouse = aInd then
    Spouse:=aind2;
  for i := 0 to high(Children) do
    if Children[i] = aInd then
      Children[i]:=aind2;
end;

destructor TVirtFamily.Destroy;
begin
  setlength(Children,0);
  inherited Destroy;
end;


const CGedDateModif:array[0..15] of string=
     ('(s)','gs', // Geschätztes datum
      'um','um', // ungefähres Datum
      '(err)','er', // erreichnetes Datum
      'nach','na',  // Ereigniss hat (kurz) danach stattgefunden
      'seit','na',
      'frühestens','na',
      'vor','vo',  // Ereigniss hatt (kurz) davor stattgefunden
      'ca','um');

  function THejHelper.RplHejDModiv(Date:String):String;
    var
      i: Integer;
    begin
      for i := 0 to high(CGedDateModif) div 2 do
        if Date.StartsWith(CGedDateModif[i*2]) then
          exit( CGedDateModif[i*2+1]+date.Remove(0,length(CGedDateModif[i*2])));
      result := Date;
    end;

{ THejHelper }

procedure THejHelper.SetCitation(AValue: TStrings);
begin
  if FCitation=AValue then Exit;
  FCitation:=AValue;
end;

procedure THejHelper.SetCitTitle(AValue: string);
begin
  if FCitTitle=AValue then Exit;
  FCitTitle:=AValue;
end;

procedure THejHelper.SetHejObj(AValue: TClsHejGenealogy);
begin
  if FHejObj=AValue then Exit;
  FHejObj:=AValue;
end;

procedure THejHelper.SetOsbHdr(AValue: string);
begin
  if FOsbHdr=AValue then Exit;
  FOsbHdr:=AValue;
end;

procedure THejHelper.AppendIndex(aRef:string;aIndID:integer);

begin
  FIndIndex.AddObject(aref,Tobject(ptrint(aIndID)));
end;

function THejHelper.GetFami(Idx: Variant): TVirtFamily;

begin
  result := nil;
  if VarIsNumeric(Idx) then
    begin
      if idx <= high(FFamily) then
        result := FFamily[Idx]
    end
  else
    begin
      Result := FindFam(Idx);
    end;
end;

function THejHelper.FindInd(aRef: String; aCre: Boolean): integer;
var
  lind: Integer;
begin
  lind:= FIndIndex.IndexOf(aref);
  if lind>=0 then
      result :=PtrInt(FIndIndex.Objects[lind])
  else
     if aCre then
        begin
          FHejObj.Append(self);
          result:=FHejObj.GetActID;
          AppendIndex(aRef,result);
        end
      else
        result := -1;
end;

function THejHelper.FindFam(aRef: String; aCre: Boolean): TVirtFamily;
var
  aFam: TVirtFamily;
begin
  result:=nil;
  for aFam in FFamily do
    if aFam.Ref = aref then
      begin
        result := aFam;
        break;
      end;
  if not assigned(result) and aCre then
    begin
      result := TVirtFamily.Create;
      result.Ref := aRef;
      result.Marr:=-1;
      Result.Marr2:=-1;
      setlength(FFamily,high(FFamily)+2);
      FFamily[high(FFamily)]:=result;

    end;
end;

procedure THejHelper.StartFamily(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFamID: String;
begin
  lFamID := 'F'+aText;
  FindFam(lFamID,true);
      if fCitTitle <> '' then
      begin
        if (FCitRefn = '') or not ((rightstr(atext, 1)[1] in ['F', 'M', 'U']) or
            (rightstr(atext, 2)[1] = 'C')or
            (rightstr(atext, 3)[1] = 'C')) then
            FCitRefn := RightStr('000' + atext, 4) + ', ' + FCitTitle;
      end
    else
        FCitRefn := '';
end;

procedure THejHelper.FamilyIndiv(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TVirtFamily;
  lInd, lCh: Integer;
begin
     lInd := FindInd( aText);
     lFam := Findfam('F' + aRef );
     if (lInd>=0) and assigned(lFam) then
       begin
         if SubType = 1 then
           begin
             lFam.Husband := lind;
             if FHejObj.iData[lInd,hind_Sex]='' then
               FHejObj.iData[lInd,hind_Sex]:='M';
             for lCh in lFam.Children do
               FHejObj.AppendLinkChild(lfam.Husband,lch );
             if lfam.Spouse >0 then
               begin
                 FHejObj.SetMarriage(lFam.Husband,lFam.Spouse);
                 lfam.Marr:=HejObj.ActualMarriage.ID;
                 FHejObj.Marriages.Data[lfam.Marr,hmar_Kind]:= HejFamilyType(lFam.Kind);
                 FHejObj.Marriages.Data[lfam.Marr,hmar_MarrChrchPlace]:= lFam.Place;
                 FHejObj.Marriages.Data[lfam.Marr,hmar_MarrChrchSource]:= FCitRefn;
                 FHejObj.Marriages.SetDateData(lfam.Marr,hmar_MarrChrchDay, lFam.Date);

                 FHejObj.SetMarriage(lFam.Spouse,lFam.Husband);
                 lfam.Marr2:=HejObj.ActualMarriage.ID;
                 FHejObj.Marriages.Data[lfam.Marr2,hmar_Kind]:= HejFamilyType(lFam.Kind);
                 FHejObj.Marriages.Data[lfam.Marr2,hmar_MarrChrchPlace]:= lFam.Place;
                 FHejObj.Marriages.Data[lfam.Marr2,hmar_MarrChrchSource]:= FCitRefn;
                 FHejObj.Marriages.SetDateData(lfam.Marr2,hmar_MarrChrchDay, lFam.Date);
               end;
           end
         else
         if SubType = 2 then
           begin
             lFam.Spouse := lind;
             for lCh in lFam.Children do
               FHejObj.AppendLinkChild(lfam.Spouse,lch );
             if lFam.Husband >0 then
               begin
                 FHejObj.SetMarriage(lFam.Husband,lFam.Spouse);
                 lfam.Marr:=HejObj.ActualMarriage.ID;
                 FHejObj.Marriages.Data[lfam.Marr,hmar_Kind]:= HejFamilyType(lFam.Kind);
                 FHejObj.Marriages.Data[lfam.Marr,hmar_MarrChrchPlace]:= lFam.Place;
                 FHejObj.Marriages.Data[lfam.Marr,hmar_MarrChrchSource]:= FCitRefn;
                 FHejObj.Marriages.SetDateData(lfam.Marr,hmar_MarrChrchDay, lFam.Date);

                 FHejObj.SetMarriage(lFam.Spouse,lFam.Husband);
                 lfam.Marr2:=HejObj.ActualMarriage.ID;
                 FHejObj.Marriages.Data[lfam.Marr2,hmar_Kind]:= HejFamilyType(lFam.Kind);
                 FHejObj.Marriages.Data[lfam.Marr2,hmar_MarrChrchPlace]:= lFam.Place;
                 FHejObj.Marriages.Data[lfam.Marr2,hmar_MarrChrchSource]:= FCitRefn;
                 FHejObj.Marriages.SetDateData(lfam.Marr2,hmar_MarrChrchDay, lFam.Date);
               end;
           end;
         if SubType > 2 then
           begin
             lFam.AppendChild(lInd);
             if lfam.Husband >0 then
             FHejObj.AppendLinkChild(lfam.Husband,lInd );
             if lfam.Spouse >0 then
             FHejObj.AppendLinkChild(lfam.Spouse,lInd );
           end;
       end;
end;

procedure THejHelper.FamilyType(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TVirtFamily;
  lmarr: THejMarrData;
  lHejBez: String;
begin
  lFam := Findfam('F' + aRef );
  lfam.Kind:=SubType;
  lHejBez:=HejFamilyType(SubType);
  if lfam.Marr>=0 then
    FHejObj.Marriages.Data[lfam.Marr,hmar_Kind]:=lHejBez;
  if lfam.Marr2>=0 then
    FHejObj.Marriages.Data[lfam.Marr2,hmar_Kind]:=lHejBez;
end;

procedure THejHelper.FamilyDate(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TVirtFamily;
begin
  lFam := Findfam('F' + aRef );
  lfam.Date:=RplHejDModiv( aText);
  if lfam.Marr>=0 then
    FHejObj.Marriages.SetDateData(lfam.Marr,hmar_MarrChrchDay,lfam.Date);
  if lfam.Marr2>=0 then
    FHejObj.Marriages.SetDateData(lfam.Marr2,hmar_MarrChrchDay,lfam.Date);
end;

procedure THejHelper.FamilyData(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TVirtFamily;
begin
  lFam := Findfam('F' + aRef );
  // Todo: Daten Eintragen
end;

procedure THejHelper.FamilyPlace(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TVirtFamily;
begin
  lFam := Findfam('F' + aRef );
  lfam.Place:=aText;
  if lfam.Marr>=0 then
    FHejObj.Marriages.Data[lfam.Marr,hmar_MarrChrchDay]:=aText;
  if lfam.Marr2>=0 then
    FHejObj.Marriages.Data[lfam.Marr2,hmar_MarrChrchDay]:=aText;
end;

procedure THejHelper.IndiName(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lpp, lInd: Integer;
begin
  lInd := FindInd( aRef ,True);
  if SubType = 0 then
    begin
      lpp:=aText.LastIndexOf(' ');
      if lpp>=0 then
      FHejObj.iData[lind,hind_FamilyName]:=copy(atext,lpp+2);
      FHejObj.iData[lind,hind_GivenName]:=LeftStr(atext,lpp);
      if FCitRefn <> '' then
          begin
            FHejObj.iData[lind,hind_NameSource]:= FCitRefn;
            FHejObj.iData[lind,hind_Text]:= FCitation.Text;
          end;
    end
  else
  if SubType = 1 then
    begin
      FHejObj.iData[lind,hind_FamilyName]:= aText;
      if FCitRefn <> '' then
        begin
          FHejObj.iData[lind,hind_NameSource]:= FCitRefn;
          FHejObj.iData[lind,hind_Text]:= FCitation.Text;
        end;
    end
  else
  if SubType = 2 then
    begin
      FHejObj.iData[lind,hind_GivenName]:= aText;
    end
  else
  if SubType = 3 then
    begin
      FHejObj.iData[lind,hind_AKA]:= aText;
    end
  else
  if SubType = 4 then
    begin
      FHejObj.iData[lind,hind_Text]:= FHejObj.iData[lind,hind_Text]+LineEnding+
        'Titel: '+aText;
    end;
end;

procedure THejHelper.IndiData(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lInd: Integer;
  lTag: TEnumHejIndDatafields;
  lHejDat: String;
begin
  lInd:= FindInd(aref);
  lTag:=GetFieldof(SubType,0);
  lHejDat:= atext;
  if (lTag=hind_Sex) and (aText='F') then
    lHejDat:='W';
  if lind>0 then
    begin
      if lTag<>hind_Text then
        FHejObj.iData[lind,lTag]:=lHejDat
      else
        FHejObj.iData[lind,lTag]:=FHejObj.iData[lind,lTag]+LineEnding+atext;
    end;
end;

procedure THejHelper.IndiDate(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lInd,lParent: Integer;
  lTag, lDSource: TEnumHejIndDatafields;
  lValidDate: Boolean;
  lYear: Longint;
  lHejDate: String;
begin
  lInd:= FindInd(aref);
  lTag:=GetFieldof(SubType,1);
  lHejDate := RplHejDModiv(atext);
    lValidDate := TryStrToInt(rightstr(lHejDate,4),lYear);
  if ltag in [hind_BurialDay,hind_DeathDay] then
    FHejObj.iData[lind,hind_Living]:='N';
  if ltag in [hind_BirthDay,hind_BaptDay] then
    if lValidDate and (lYear<1920) and (lYear>1000) then
      FHejObj.iData[lind,hind_Living]:='N';

  if lind>0 then
    begin
      if lValidDate and (lTag<>hind_Text) then
        begin
          lYear := 5*((lYear+2)div 5);
             FHejObj.SetDate(lind,lTag,lHejDate);
             lDSource := TClsHejIndividuals.GetSource(ltag);
      if (FCitRefn <> '') and (lTag<>hind_ID) then
          FHejObj.iData[lind,lDSource]:= FCitRefn;
        if  lHejDate[1] in ['0'..'9'] then
          begin
          // gibt es nur ein Taufdatum setze Geburt davor
            if (FHejObj.iData[lind,hind_BirthYear]='') and
               (lTag=hind_BaptDay) then
                 FHejObj.SetDate(lind,lTag,'vo '+lHejDate);
            lParent:=FHejObj.iData[lind,hind_idFather];
            if (lParent>0) and
               (FHejObj.iData[lParent,hind_BirthYear]='') and
                    (lTag in [hind_BaptDay,hind_BirthDay]) then
                      FHejObj.SetDate(lParent,hind_BirthDay,'um '+inttostr(lYear-30));
            lParent:=FHejObj.iData[lind,hind_idMother];
            if (lParent>0) and
               (FHejObj.iData[lParent,hind_BirthYear]='') and
                    (lTag in[hind_BaptDay,hind_BirthDay]) then
                      FHejObj.SetDate(lParent,hind_BirthDay,'um '+inttostr(lYear-25));
          end
        end
      else
        FHejObj.iData[lind,hind_Text]:=FHejObj.iData[lind,hind_Text]+LineEnding+atext;
    end;
end;

procedure THejHelper.IndiPlace(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lInd: Integer;
  lTag: TEnumHejIndDatafields;
begin
  lInd:= FindInd(aref);
  lTag:=GetFieldof(SubType,2);
  if lind>0 then
    begin
      if lTag<>hind_Text then
        FHejObj.iData[lind,lTag]:=atext
      else
        FHejObj.iData[lind,lTag]:=FHejObj.iData[lind,lTag]+LineEnding+atext;
    end;
end;

procedure THejHelper.IndiRef(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lInd: Integer;
begin
  lInd:= FindInd(aref);
  if lind>0 then
    FHejObj.iData[lind,hind_Index]:=atext
end;

procedure THejHelper.IndiOccu(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lInd: Integer;
  lTag: TEnumHejIndDatafields;
begin
  lInd:= FindInd(aref);
  lTag:=GetFieldof(SubType,0);
  if lind>0 then
    begin
      if lTag<>hind_Text then
        FHejObj.iData[lind,lTag]:=atext
      else
        FHejObj.iData[lind,lTag]:=FHejObj.iData[lind,lTag]+LineEnding+atext;
    end;
end;

procedure THejHelper.IndiRel(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
    lInd, lInd2, lInd3:integer;
    lFam, lFam2: TVirtFamily;
    lSex:Char;
begin
    lInd := FindInd(aRef);
    // exit;
    if lInd>=0 then
      begin
        if (subtype = 2) then
          begin
            lSex:=HejObj.iData[lind,hind_Sex];
            if lSex ='W' then lSex:='F';
            lInd2 := FindInd('I' + atext + lSex );
            if lInd2<=0 then
                AppendIndex('I' + atext + lSex, lind)
            else
              begin
            ;// Todo: Merge
                MergePerson(lind,lind2);
            // Merge Father
                lInd3:= FindInd(aRef +'M');
                lInd2:= FindInd('I' + atext + lSex + 'M');
                if (lind2>0) and (lInd3>0) then
                  MergePerson(lInd3,lInd2);
             // Merge Mother
                lInd3:= FindInd(aRef +'F');
                lInd2:= FindInd('I' + atext + lSex + 'F');
                if (lind2>0) and (lInd3>0) then
                  MergePerson(lInd3,lInd2);

                lFam := FindFam('F' + copy(aRef,2) );
                lFam2 := FindFam('F' + aText +lSex );
                if assigned(lFam) and assigned(lFam2) then
                  MergeFamily(lFam,lfam2)
              end
          end
        else
          begin
            lFam := FindFam('F' + aText );
            if assigned(lFam) then
              begin
                if lfam.Husband >0 then
                FHejObj.AppendLinkChild(lfam.Husband,lInd );
                if lfam.Spouse >0 then
                FHejObj.AppendLinkChild(lfam.Spouse,lInd );
              end;
          end;
      end;
end;

procedure THejHelper.CreateNewHeader(Filename: string);
begin
   //
end;

procedure THejHelper.SaveToFile(Filename: string);
var
    lSt: TMemoryStream;
begin
    lSt := TMemoryStream.Create;
      try
        FHejObj.WriteToStream(lst);
        lst.Seek(0, soFromBeginning);
        lst.SaveToFile(FileName);
      finally
        FreeAndNil(lSt);
      end;
end;

procedure THejHelper.Clear;
var
  i: Integer;
begin
  FHejObj.Clear;
  FIndIndex.Clear;
  for i := high(FFamily) downto 0 do
    freeandnil(FFamily[i]);
  setlength(FFamily,0);
end;

procedure THejHelper.FireEvent(Sender: TObject; aSTa: TStringArray);
var
  lInt: Longint;
begin
  if (length(aSTa) = 4) and trystrtoint(asta[3], lInt) then
      case aSTa[0] of
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
        end;
end;

procedure THejHelper.MergePerson(lInd, lInd2:integer);
var
  i: Integer;
begin
  if lind=lind2 then exit; // !!

  FHejObj.MergePerson(lind,lind2);
  for i := 0 to FIndIndex.Count-1 do
    if FIndIndex.Objects[i]=TObject(PtrInt(lind2)) then
      FIndIndex.Objects[i]:=TObject(PtrInt(lInd));
  for i := 0 to high(FFamily) do
    FFamily[i].ReplaceInd(lind2,lind);

end;

procedure THejHelper.MergeFamily(lInd, lInd2: TVirtFamily);
begin
  // ToDo:
end;

function THejHelper.GetFieldof(const SubType, knd: integer
  ): TEnumHejIndDatafields;
begin
    case SubType*3+Knd of
        0: Result := hind_Index;
        4: Result := hind_BirthDay;
        5: Result := hind_Birthplace;
        7: Result := hind_BaptDay;
        8: Result := hind_BaptPlace;
        12: Result := hind_DeathReason;
        13: Result := hind_DeathDay;
        14: Result := hind_DeathPlace;
        16: Result := hind_BurialDay;
        17: Result := hind_BurialPlace;
        18: Result := hind_Sex;
        21: Result := hind_Occupation;
        24: Result := hind_Religion;
        29: Result := hind_Residence;
        30: Result := hind_GivenName;
        33: Result := hind_AKA;
        else
            Result := hind_Text;
      end;
end;

function THejHelper.GetIndi(Idx: Variant): THejIndData;
var
  lIdx: Integer;
begin
  if VarIsNumeric(Idx) then
    result := FHejObj.PeekInd(Idx)
  else
    begin
      lIdx := FindInd(Idx);
      if lIdx>0 then
        result := FHejObj.PeekInd(lIdx)
    end;
end;

function THejHelper.HejFamilyType(const SubType: integer): String;
var
  lHejBez: String;
begin
  case Subtype of
     1: lHejBez := 'Eheschliessung';
     2: lHejBez := 'andere Beziehung';
  else
    lHejBez :='';
  end;
  Result:=lHejBez;
end;

constructor THejHelper.Create;
begin
  FIndIndex:= TStringlist.Create;
  TStringList(FIndIndex).Sorted:=true;
end;

destructor THejHelper.Destroy;
var
  i: Integer;
begin
  freeandnil(FIndIndex);
  for i := high(FFamily) downto 0 do
    freeandnil(FFamily[i]);
  setlength(FFamily,0);
  inherited Destroy;
end;

end.

