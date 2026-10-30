unit cls_HejHelper;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_HejData,cls_HejIndData,unt_IGenBase2, cls_HejMarrData, cls_GenHelperBase;

type

{ THejHelper }
 THejHelper = class;
 { TVirtFamily }

 TVirtFamily = Class(TObject,IGenFamily)
   private
     FHusband: integer;
     FMarriage: IGenEvent;
     FWife: integer;
      Owner:THejHelper;
   public
   Ref2,
   Ref:string;
   Husband,
   Spouse,
   Marr,
   Marr2:integer;
   Children:array of Integer;
   Kind:Integer;
   FName,
   Date,
   Place:String;
   Procedure AppendChild(aInd:integer);
   Procedure ReplaceInd(aInd,aind2:integer);
   constructor Create(aOwner:THejHelper);
   destructor Destroy; override;
 public
 //--- Interface IGenFamily
    function GetChildCount: integer;
        function GetChildren(Idx: Variant): IGenIndividual;
        function GetFamilyName: string;
        function GetFamilyRefID: string;
        function GetHusband: IGenIndividual;
        function GetMarriage: IGenEvent;
        function GetMarriageDate: string;
        function GetMarriagePlace: string;
        function GetWife: IGenIndividual;
        function EnumChildren:IGenIndEnumerator;
        procedure SetChildren(Idx: Variant; AValue: IGenIndividual);
        procedure SetFamilyName(AValue: string);
        procedure SetFamilyRefID(AValue: string);
        procedure SetHusband(AValue: IGenIndividual);
        procedure SetMarriage(AValue: IGenEvent);
        procedure SetMarriageDate(AValue: string);
        procedure SetMarriagePlace(AValue: string);
        procedure SetWife(AValue: IGenIndividual);
    public
 // --Interface IGenEntity
      function GetEventCount: integer;
      function GetEvents(Idx: Variant): IGenEvent;
      procedure SetEvents(Idx: variant; AValue: IGenEvent);
      property EventCount: integer read GetEventCount;
      property Events[Idx: variant]: IGenEvent read GetEvents write SetEvents;
   public
 // -- Interface IGenData
        function GetData: string;
        function GetFType: integer;
        function GetObject: TObject;
        procedure SetData(AValue: string);
        procedure SetFType(AValue: integer);

 end;

 THejHelper=Class(TGenHelperBase)
private
  FHejObj: TClsHejGenealogy;
  FIndIndex:TStrings;
  FFamily:Array of TVirtFamily;

  procedure AppendIndex(aRef: string; aIndID: integer);
  function GetFami(Idx: Variant): TVirtFamily;
  function GetFieldof(const SubType, knd: integer): TEnumHejIndDatafields;
  function GetIndi(Idx: Variant): THejIndData;
  function GetMarrFieldof(const SubType, knd: integer): TEnumHejMarrDatafields;
  function HejFamilyType(const SubType: integer): String;
  function RplHejDModiv(Date: String): String;

  function IsFamilyEvent(const SubType: integer): boolean;
  function IsMetaField(const SubType: TEnumHejIndDatafields): boolean;
  procedure SetHejObj(AValue: TClsHejGenealogy);
  Function FindInd(aRef:String;aCre:Boolean=false):integer;
  function FindFam(aRef: String; aCre: Boolean=False): TVirtFamily;

public
  procedure StartIndiv(Sender: TObject; aText, aRef: string;
    SubType: integer);override;
  procedure StartFamily(Sender: TObject; aText, {%H-}aRef: string;
  {%H-}SubType: integer);override;
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
  procedure SaveToFile(const Filename: string); override;

  function IndexOf(iInd:IGenIndividual):integer;
public
  Procedure Clear;override;

  Procedure MergePerson(lInd,lInd2:integer);
  Procedure MergeFamily(lInd,lInd2:TVirtFamily);

  property HejObj: TClsHejGenealogy read FHejObj write SetHejObj;
  property Indi[Idx:Variant]:THejIndData read GetIndi;
  property Fami[Idx:Variant]:TVirtFamily read GetFami;
public
    Constructor Create;
    destructor Destroy; override;
   end;

implementation

uses cls_HejPlaceData,strutils,variants;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

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

constructor TVirtFamily.Create(aOwner: THejHelper);
begin
  Owner := aOwner;
end;

destructor TVirtFamily.Destroy;
begin
  setlength(Children,0);
  inherited Destroy;
end;

function TVirtFamily.GetChildCount: integer;
begin
  result := length(Children);
end;

function TVirtFamily.GetChildren(Idx: Variant): IGenIndividual;
begin
  if VarIsNumeric(Idx) then
//    result := Owner.GetIndi( Children[Idx]);
  else
    result := nil;
end;

function TVirtFamily.GetFamilyName: string;
begin
  Result := FName;
end;

function TVirtFamily.GetFamilyRefID: string;
begin
  Result := Ref;
end;

function TVirtFamily.GetHusband: IGenIndividual;
begin
//  Result := Owner.GetIndi(FHusband) ;
end;

function TVirtFamily.GetMarriage: IGenEvent;
begin
  Result := FMarriage;
end;

function TVirtFamily.GetMarriageDate: string;
begin
  If assigned(FMarriage) then
    result := FMarriage.Date;
end;

function TVirtFamily.GetMarriagePlace: string;
begin
  If assigned(FMarriage) then
    result := FMarriage.Place;
end;

function TVirtFamily.GetWife: IGenIndividual;
begin
//  Result := Owner.GetIndi(FWife)
end;

function TVirtFamily.EnumChildren: IGenIndEnumerator;
begin
//  result :=
end;

procedure TVirtFamily.SetChildren(Idx: Variant; AValue: IGenIndividual);
begin

end;

procedure TVirtFamily.SetFamilyName(AValue: string);
begin

end;

procedure TVirtFamily.SetFamilyRefID(AValue: string);
begin
  Ref:=AValue;
end;

procedure TVirtFamily.SetHusband(AValue: IGenIndividual);
begin
  FHusband := Owner.IndexOf(AValue);
end;

procedure TVirtFamily.SetMarriage(AValue: IGenEvent);
begin
  FMarriage := Avalue;
end;

procedure TVirtFamily.SetMarriageDate(AValue: string);
begin

end;

procedure TVirtFamily.SetMarriagePlace(AValue: string);
begin

end;

procedure TVirtFamily.SetWife(AValue: IGenIndividual);
begin
  FWife := Owner.IndexOf(AValue);
end;

function TVirtFamily.GetEventCount: integer;
begin
  result := 0
end;

function TVirtFamily.GetEvents(Idx: Variant): IGenEvent;
begin

end;

procedure TVirtFamily.SetEvents(Idx: variant; AValue: IGenEvent);
begin

end;

function TVirtFamily.GetData: string;
begin

end;

function TVirtFamily.GetFType: integer;
begin
  result := Kind;
end;

function TVirtFamily.GetObject: TObject;
begin
  result := self
end;

procedure TVirtFamily.SetData(AValue: string);
begin

end;

procedure TVirtFamily.SetFType(AValue: integer);
begin
 Kind := AValue;
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

  function THejHelper.IsFamilyEvent(const SubType: integer): boolean;
  begin
     result := subtype in [0,3,17]
  end;

  function THejHelper.IsMetaField(const SubType: TEnumHejIndDatafields
    ): boolean;
  begin
    result := subtype in [hind_Occupation,hind_Residence,hind_FarmName];
  end;

{ THejHelper }

procedure THejHelper.SetHejObj(AValue: TClsHejGenealogy);
begin
  if FHejObj=AValue then Exit;
  FHejObj:=AValue;
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
    if (aFam.Ref = aref) or (aFam.Ref2 = aref) then
      begin
        result := aFam;
        break;
      end;
  if not assigned(result) and aCre then
    begin
      result := TVirtFamily.Create(self);
      result.Ref := aRef;
      result.Marr:=-1;
      Result.Marr2:=-1;
      setlength(FFamily,high(FFamily)+2);
      FFamily[high(FFamily)]:=result;
    end;
end;

procedure THejHelper.StartIndiv(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lInd: Integer;
begin
  if aRef='' then aref := aText;
  lInd := FindInd(aRef,true);
  FHejObj.iData[lInd,hind_Index]:= FOsbHdr+NormalCitRef(aRef);
  if fCitTitle <> '' then
        FCitRefn := NormalCitRef(aRef) + ', ' + FCitTitle
    else
        FCitRefn := '';

end;

procedure THejHelper.StartFamily(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFamID: String;
  lFam : TVirtFamily;
begin
  if atext.endswith(' ') then
     begin
       lFamID :='';
       Error(atext.QuotedString('"')+'is Illigal Family-Ref',aref,SubType);
     end;
  lFamID := 'F'+aText;
  lFam := FindFam(lFamID,true);
  lFam.Ref2:= FOsbHdr + NormalCitRef(aText);
  if fCitTitle <> '' then
      begin
        if (FCitRefn = '') then
          FCitRefn := NormalCitRef(aText) + ', ' + FCitTitle;
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
  lMarFld: TEnumHejMarrDatafields;
  lIndField: TEnumHejIndDatafields;
begin
  lFam := Findfam('F' + aRef );
  lfam.Date:=RplHejDModiv( aText);
  if IsFamilyEvent(SubType) then
     begin
       lMarFld := GetMarrFieldof(SubType,1);
  if (lfam.Marr>=0) and (lMarFld<>hmar_ID)  then
    FHejObj.Marriages.SetDateData(lfam.Marr,lMarFld,lfam.Date);
  if (lfam.Marr2>=0) and (lMarFld<>hmar_ID) then
    FHejObj.Marriages.SetDateData(lfam.Marr2,lMarFld,lfam.Date);
     end
     else
      begin
        lIndField:= GetFieldof(SubType,2);
        if (lfam.Husband <> 0) and IsMetaField(lIndField) then
          FHejObj.iMetaData[-1,lfam.Husband,lIndField,1] := lfam.Date
        else if (lfam.Husband <> 0) and (lIndField<>hind_Text) then
          FHejObj.SetDate(lfam.Husband,lIndField,lfam.Date)
        else if (lfam.Husband <> 0) then
          FHejObj.iData[lfam.Husband,lIndField] := FHejObj.iData[lfam.Husband,lIndField]+
            LineEnding + {GetTextHdr(Subtype) +} 'am ' + aText;
        if (lfam.Spouse <> 0) and IsMetaField(lIndField) then
          FHejObj.iMetaData[-1,lfam.Husband,lIndField,1] := lfam.Date
        else if (lfam.Spouse <> 0) and (lIndField<>hind_Text) then
          FHejObj.SetDate(lfam.Spouse,lIndField,lfam.Date)
        else if (lfam.Spouse <> 0) then
          FHejObj.iData[lfam.Spouse,lIndField] := FHejObj.iData[lfam.Spouse,lIndField]+
            LineEnding + {GetTextHdr(Subtype) +}'am ' + aText;
      end;

end;

procedure THejHelper.FamilyData(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TVirtFamily;
  lMarFld: TEnumHejMarrDatafields;
  lIndField: TEnumHejIndDatafields;
begin
  lFam := Findfam('F' + aRef );
  // Todo: Daten Eintragen
   if assigned(lFam) and IsFamilyEvent(SubType) then
      begin
         lMarFld := GetMarrFieldof(SubType,0);
        if (lfam.Marr>=0) and (lMarFld<>hmar_ID)  then
          FHejObj.Marriages.SetData(lfam.Marr,lMarFld,aText);
        if (lfam.Marr2>=0) and (lMarFld<>hmar_ID) then
          FHejObj.Marriages.SetData(lfam.Marr2,lMarFld,aText);
      end
   else
      begin
        lIndField:= GetFieldof(SubType,0);
        if (lfam.Husband <> 0) and IsMetaField(lIndField) then
          FHejObj.iMetaData[-1,lfam.Husband,lIndField,0] := aText
        else if (lfam.Husband <> 0) and (lIndField<>hind_Text) then
          FHejObj.iData[lfam.Husband,lIndField] := aText
        else if (lfam.Husband <> 0) then
          FHejObj.iData[lfam.Husband,lIndField] := FHejObj.iData[lfam.Husband,lIndField]+
            LineEnding {+ GetTextHdr(Subtype)} + aText;
        if (lfam.Spouse <> 0) and IsMetaField(lIndField) then
          FHejObj.iMetaData[-1,lfam.Spouse,lIndField,0] := aText
        else if (lfam.Spouse <> 0) and (lIndField<>hind_Text) then
          FHejObj.iData[lfam.Spouse,lIndField] := aText
        else if (lfam.Spouse <> 0) then
          FHejObj.iData[lfam.Spouse,lIndField] := FHejObj.iData[lfam.Spouse,lIndField]+
            LineEnding {+ GetTextHdr(Subtype)} + aText;
      end;
end;

procedure THejHelper.FamilyPlace(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lFam: TVirtFamily;
  lMarFld: TEnumHejMarrDatafields;
  lIndField: TEnumHejIndDatafields;
begin
  lFam := Findfam('F' + aRef );
  if not assigned(lFam) then
    exit;
  lfam.Place:=aText;
  if isFamilyEvent(Subtype) then
    begin
      lMarFld := GetMarrFieldof(SubType,2);
      if (lfam.Marr>=0) and (lMarFld<>hmar_ID)  then
    FHejObj.Marriages.Data[lfam.Marr,lMarFld]:=aText;
      if (lfam.Marr2>=0) and (lMarFld<>hmar_ID) then
    FHejObj.Marriages.Data[lfam.Marr2,lMarFld]:=aText;
    end
  else
     begin
       lIndField:= GetFieldof(SubType,1);
       if (lfam.Husband <> 0) and IsMetaField(lIndField) then
          FHejObj.iMetaData[-1,lfam.Husband,lIndField,2] := aText
        else if (lfam.Husband <> 0) and (lIndField<>hind_Text) then
         FHejObj.iData[lfam.Husband,lIndField] := aText
       else if (lfam.Husband <> 0) then
         FHejObj.iData[lfam.Husband,lIndField] := FHejObj.iData[lfam.Husband,lIndField]+
           LineEnding {+ GetTextHdr(Subtype)} + aText;
       if (lfam.Spouse <> 0) and IsMetaField(lIndField) then
          FHejObj.iMetaData[-1,lfam.Spouse,lIndField,2] := aText
        else if (lfam.Spouse <> 0) and (lIndField<>hind_Text) then
         FHejObj.iData[lfam.Spouse,lIndField] := aText
       else if (lfam.Spouse <> 0) then
         FHejObj.iData[lfam.Spouse,lIndField] := FHejObj.iData[lfam.Spouse,lIndField]+
           LineEnding {+ GetTextHdr(Subtype)} + aText;
     end;
end;

procedure THejHelper.IndiName(Sender: TObject; aText, aRef: string;
  SubType: integer);
var
  lpp, lInd: Integer;
begin
  lInd := FindInd( aRef ,True);
  if SubType = 0 then  // Fullname
    begin
        // Todo -oJC: Adelsnamen "von XXX"
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
  if SubType = 1 then  // FamilyName
    begin
      FHejObj.iData[lind,hind_FamilyName]:= aText;
      if FCitRefn <> '' then
        begin
          FHejObj.iData[lind,hind_NameSource]:= FCitRefn;
          FHejObj.iData[lind,hind_Text]:= FCitation.Text;
        end;
    end
  else
  if SubType = 2 then  // GivenName
    begin
      FHejObj.iData[lind,hind_GivenName]:= aText;
    end
  else
  if SubType = 3 then  // AKA
    begin
      FHejObj.iData[lind,hind_AKA]:= aText;
    end
  else
  if SubType = 4 then  // Title
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
      if IsMetaField(ltag) then
        FHejObj.iMetaData[-1,lind,lTag,0]:=atext
      else if lTag<>hind_Text then
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
      if lValidDate and IsMetaField(ltag) then
         FHejObj.iMetaData[-1,lind,lTag,1]:=lHejDate
      else  if lValidDate and (lTag<>hind_Text) then
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
      if IsMetaField(ltag) then
        FHejObj.iMetaData[-1,lind,lTag,2]:=atext
      else if lTag<>hind_Text then
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
      if IsMetaField(ltag) then
        FHejObj.iMetaData[-1,lind,lTag,0]:=atext
      else if lTag<>hind_Text then
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

procedure THejHelper.SaveToFile(const Filename: string);
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

function THejHelper.IndexOf(iInd: IGenIndividual): integer;
begin
  //if iInd is TClsIIndivid then
  //   result:= (iInd as TClsHejIndividuals).
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
        22: Result := hind_Occupation;
        23: Result := hind_Occupation;
        24: Result := hind_Religion;
        27: Result := hind_Residence;
        28: Result := hind_Residence;
        29: Result := hind_Residence;
        30: Result := hind_GivenName;
        ord(evt_AKA)*3: Result := hind_AKA;
        ord(evt_AddResidence)*3: Result := hind_Residence;
        ord(evt_AddResidence)*3+1: Result := hind_Residence;
        ord(evt_AddResidence)*3+2: Result := hind_Residence;
        ord(evt_Age)*3:Result := hind_Age;
        else
            Result := hind_Text;
      end;
end;

function THejHelper.GetMarrFieldof(const SubType, knd: integer
  ): TEnumHejMarrDatafields;
begin
    case SubType*3+Knd of
        ord(evt_Marriage)*3+1: Result := hmar_MarrChrchDay;
        ord(evt_Marriage)*3+2: Result := hmar_MarrChrchPlace;
        ord(evt_Divorce)*3+1: Result := hmar_DivorceDay;
        ord(evt_Divorce)*3+2: Result := hmar_DivorcePlace;
        else
            Result := TEnumHejMarrDatafields(-1);
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

