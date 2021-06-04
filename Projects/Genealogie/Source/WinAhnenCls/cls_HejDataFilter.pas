unit cls_HejDataFilter;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, cls_HejData;


type
  TEnumHejConcType=
    ( hCcT_Nop = -1, // Ende
      hCcT_Or = 0,   // ) OR ( ...
      hCcT_Nor = 1,  // ) or not ( ...
      hCcT_xor = 2,  // ) xor ( ...
      hCcT_And = 3,  // and (..)
      hCcT_xor2 = 4); // xor (..)

  TEnumHejCompareType=
    ( hCmp_Nop = 0, // always false
      hCmp_Equal = 1,
      hCmp_UnEqual = 2,
      hCmp_Less = 3,
      hCmp_LessOEqual = 4,
      hCmp_GreaterOEqual = 5,
      hCmp_Greater = 6,
      hCmp_Startswith = 7,
      hCmp_Endswith = 8,
      hCmp_Contains = 9,
      hCmp_IsEmpty = 10,
      hCmp_IsNotEmpty =11);

  { TFilterRule }

  TFilterRule=record
    Function toString:String;
    Function toPasStruct:String;
    Procedure Init(aDataField:Integer;
    aIndRedir:TEnumHejIndRedir;
    aCompType:TEnumHejCompareType;
    aCompValue:variant);
    Procedure Clear;
    Function Equals(const aFilterRule:TFilterRule):boolean;
    Function Eval(Ind:integer;ActGen:TClsHejGenealogy):boolean;
  public
    // Datenfelder
    Concat:TEnumHejConcType;
    DataField:Integer; //
    IndRedir:TEnumHejIndRedir;
    CompType:TEnumHejCompareType;
    CompValue:variant;
  end;

  { TGenFilter }
  TArrayOfInteger = array of Integer;
  TGenFilter=Class
  private
    FRules:array of TFilterRule;
    FActRule: Integer;
    function GetConcat(Idx: integer): TEnumHejConcType;
    function GetRules(Idx: integer): TFilterRule;
    procedure SetConcat(Idx: integer; AValue: TEnumHejConcType);
    procedure SetRules(Idx: integer; AValue: TFilterRule);
  public
    Procedure Clear;
    Function Count:integer;
    Function ToString: string; override;
    Function ToPasStruct: String;
    Function SingleEval(Ind:integer;ActGen:TClsHejGenealogy):boolean;
    function Eval(ActGen: TClsHejGenealogy): TArrayOfInteger;
    Procedure AppendRule(aConcat:TEnumHejConcType;aFilterRule:TFilterRule);
    Procedure SetRule(aConcat:TEnumHejConcType;aFilterRule:TFilterRule);
    property Rules[Idx:integer]:TFilterRule read GetRules write SetRules;
    Property Concat[Idx:integer]:TEnumHejConcType read GetConcat write SetConcat;
  end;

const
   CConcat:array[TEnumHejConcType] of string=(
     'hCcT_Nop',
     'hCcT_Or',
     'hCcT_Nor',
     'hCcT_xor',
     'hCcT_And',
     'hCcT_xor2');


   CCompType:array[TEnumHejCompareType] of string=
   ( 'hCmp_Nop',
     'hCmp_Equal',
     'hCmp_UnEqual',
     'hCmp_Less',
     'hCmp_LessOEqual',
     'hCmp_GreaterOEqual',
     'hCmp_Greater',
     'hCmp_Startswith',
     'hCmp_Endswith',
     'hCmp_Contains',
     'hCmp_IsEmpty',
     'hCmp_IsNotEmpty');

    CCompTypeOp:array[TEnumHejCompareType] of string=
   ( '? %s',
     '= %s',
     '<> %s',
     '< %s',
     '<= %s',
     '>= %s',
     '> %s',
     ' like "%s*"',
     ' like "*%s"',
     ' like "*%s*"',
     ' IsEmpty',
     ' IsNotEmpty');

   CIndMetaData:Array[TenumIndMetaData] of string=
   ('ParentCount',
    'SpouseCount',
    'ChildCount',
    'SiblingCount',
    'SourceCount',
    'PlaceCount',
    'AdoptCount',
    'AnyPlace',
    'AnySource',
    'AnyData',
    'AgeOfBapt',
    'AgeOfNextSibl',
    'AgeOfConf',
    'AgeOfFMarriage',
    'AgeOfFirstChild',
    'AgeOfLMarriage',
    'AgeOfLChild',
    'AgeOfDeath',
    'AgeDiffToSpouse');

const NoRule:TFilterRule=({%H-});

Function FilterRule(aDataField:Integer;
    aIndRedir:TEnumHejIndRedir;
    aCompType:TEnumHejCompareType;
    aCompValue:variant):TFilterRule;

resourcestring
      rshCcT_Nop = '';   // )
      rshCcT_Or = 'Oder';   // ) OR ( ...
      rshCcT_Nor = 'Oder nicht';  // ) or not ( ...
      rshCcT_xor = 'Entweder Oder';  // ) xor ( ...
      rshCcT_And = 'Und';  // and (..)
      rshCcT_xor2 = 'Entweder Oder 2'; // xor (..)

        rshCmp_Nop = '?'; // always false
        rshCmp_Equal = '=';
        rshCmp_UnEqual = '<>';
        rshCmp_Less = '<';
        rshCmp_LessOEqual = '<=';
        rshCmp_GreaterOEqual = '>=';
        rshCmp_Greater = '>';
        rshCmp_Startswith = 'wie $*';
        rshCmp_Endswith = 'wie *$';
        rshCmp_Contains = 'wie *$*';
        rshCmp_IsEmpty = '[ ]';
        rshCmp_IsNotEmpty ='![ ]';

        rshInMeD_ParentCount ='Anzahl Elternteile';
        rshInMeD_SpouseCount     ='Anzahl Ehepartner';
        rshInMeD_ChildCount      ='Anzahl Kinder';
        rshInMeD_SiblingCount    ='Anzahl Geschwister';
        rshInMeD_SourceCount     ='Anzahl Quellen';
        rshInMeD_PlaceCount      ='Anzahl Orte';
        rshInMeD_AdoptCount      ='Anzahl Adoptionen';
        rshInMeD_AnyPlace        ='ein Platz';
        rshInMeD_AnySource       ='eine Quelle';
        rshInMeD_AnyData         ='etwas';
        rshInMeD_AgeOfBapt       ='Alter bei Taufe';
        rshInMeD_AgeOfNextSibl   ='Alter bei n. Geschw.';
        rshInMeD_AgeOfConf       ='Alter bei Konfirmation';
        rshInMeD_AgeOfFMarriage  ='Alter bei e. Hochzeit';
        rshInMeD_AgeOfFirstChild ='Alter bei erstem Kind';
        rshInMeD_AgeOfLMarriage  ='Alter bei l. Hochzeit';
        rshInMeD_AgeOfLChild     ='Alter bei l. Kind';
        rshInMeD_AgeOfDeath      ='Alter bei Tod';
        rshInMeD_AgeDiffToSpouse ='Altersdiff. zu Partner';

var rshCcT: Array[TEnumHejConcType] of String;
    rshCmp: Array[TEnumHejCompareType] of String;
    rshMtD: Array[TenumIndMetaData] of string;

implementation

uses variants,cls_HejIndData,cls_HejMarrData;

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

const COrConc=[hCcT_Or,   // ) OR ( ...
      hCcT_Nor,  // ) or not ( ...
      hCcT_xor]; // ) xor ( ...

function FilterRule(aDataField: Integer; aIndRedir: TEnumHejIndRedir;
  aCompType: TEnumHejCompareType; aCompValue: variant): TFilterRule;
begin
  result.Init(aDataField,aIndRedir,aCompType,aCompValue);
end;

{ TGenFilter }

function TGenFilter.GetRules(Idx: integer): TFilterRule;
begin
  // TEst Idx
  if idx=-1 then Idx := FActRule;
  if idx < 0 then exit(NoRule)
  else if idx > high(FRules) then exit(NoRule);
  result := FRules[Idx];
end;

function TGenFilter.GetConcat(Idx: integer): TEnumHejConcType;
begin
  // TEst Idx
  if idx=-1 then Idx := FActRule;
  if idx < 0 then exit(hCcT_Or)
  else if idx > high(FRules) then exit(hCcT_Or);
  result := FRules[Idx].Concat;
end;

procedure TGenFilter.SetConcat(Idx: integer; AValue: TEnumHejConcType);
begin
  // TEst Idx
  if idx=-1 then Idx := FActRule;
  if idx < 0 then exit
  else if idx = high(FRules)+1 then
    SetLength(FRules,high(FRules)+2)
  else if idx > high(FRules) then exit;
  // Keep Concat
  FRules[Idx].Concat := AValue;
end;

procedure TGenFilter.SetRules(Idx: integer; AValue: TFilterRule);
begin
  // TEst Idx
  if idx=-1 then Idx := FActRule;
  if idx < 0 then exit
  else if idx = high(FRules)+1 then
    SetLength(FRules,high(FRules)+2)
  else if idx > high(FRules) then exit;
  // Keep Concat
  AValue.Concat:= FRules[Idx].Concat;
  FRules[Idx] := AValue;
end;

procedure TGenFilter.Clear;
begin
  setlength(FRules,0);
end;

function TGenFilter.Count: integer;
begin
  result := length(FRules);
end;

function TGenFilter.ToString: string;
var
  i: Integer;
begin
  if (high(FRules)=0) then
    exit('()')
  else if FRules[0].Concat in [hCcT_Nor,hCcT_xor2] then
    result := 'not ('+FRules[0].toString else result := '('+FRules[0].toString;
  for i := 1 to high(FRules) do
    begin
    case FRules[i].Concat of
      hCcT_Or: result :=result+ ') or (' ;
      hCcT_Nor: result :=result+ ') or not (';
      hCcT_xor: result :=result+ ') xor (';
      hCcT_And: result :=result+ ' and ';
      hCcT_xor2: result :=result+ ' xor ';
    end;
      result := result+ FRules[i].toString;
    end;
  result := result+')';
end;

function TGenFilter.ToPasStruct: String;
var
  i: Integer;
begin
  result := '(';
  for i := 0 to high(FRules) do
    result := result +','+LineEnding+FRules[i].toPasStruct;
  Delete(Result,2,1+length(LineEnding));
  result :=Result + ')';

end;

function TGenFilter.SingleEval(Ind: integer; ActGen: TClsHejGenealogy): boolean;
var
  lOrComb, lAndComb, lEvalRule: Boolean;
  i: Integer;
  lLastComb: TEnumHejConcType;
begin
  lOrComb := false;
  lAndComb := true;
  lLastComb := hCcT_Or;
  for i := 0 to high(FRules) do
    begin
      lEvalRule := FRules[i].Eval(Ind,ActGen);
      if FRules[i].Concat in COrConc  then
        begin
          if (i>0) then
          case lLastComb of
            hCcT_Or: lOrComb:=lOrComb or lAndComb;
            hCcT_Nor: lOrComb:=lOrComb or not lAndComb;
            hCcT_xor: lOrComb:=lOrComb xor lAndComb;
            else;
          end;
          lAndComb:=lEvalRule;
          lLastComb:=FRules[i].Concat;
        end
      else
      case FRules[i].Concat of
        hCcT_And: lAndComb:=lAndComb and lEvalRule;
        hCcT_xor2: lAndComb:=lAndComb xor lEvalRule;
        else;
      end;
    end;
    case lLastComb of
            hCcT_Or: result:=lOrComb or lAndComb;
            hCcT_Nor: result:=lOrComb or not lAndComb;
            hCcT_xor: result:=lOrComb xor lAndComb;
            else result:=lOrComb;
          end;
end;

function TGenFilter.Eval(ActGen: TClsHejGenealogy): TArrayOfInteger;
var
  lIxCnt, i: Integer;
begin
  setlength(Result,ActGen.Count);
  lIxCnt:=0;
  for i:=1{!} to ActGen.Count do
      if SingleEval(i,ActGen) then
        begin
          result[lIxCnt] := i;
          inc(lIxCnt);
    end;
  setlength(Result,lIxCnt);
end;

procedure TGenFilter.AppendRule(aConcat: TEnumHejConcType;
  aFilterRule: TFilterRule);
begin
  setlength(FRules,high(FRules)+2);
  aFilterRule.Concat:=aConcat;
  FRules[high(FRules)]:=aFilterRule;
  FActRule:=high(FRules);
end;

procedure TGenFilter.SetRule(aConcat: TEnumHejConcType; aFilterRule: TFilterRule
  );
begin
  // Todo: ?? noch kein Plan
end;

{ TFilterRule }

function TFilterRule.toString: String;
begin
   result := copy(CindRedir[IndRedir],6,10);
   if IndRedir= hIRd_Meta then
     result :=result+ '.'+CIndMetaData[TenumIndMetaData(DataField)]
   else
     if DataField < 199 then
       result :=result+ '.'+CHejIndDataDesc[TEnumHejIndDatafields(DataField-100)]
     else
         result :=result+ '.'+CHejMarrDataDesc[TEnumHejMarrDatafields(DataField-200)];
  if VarIsNumeric(CompValue) then
  result := result + Format(CCompTypeOp[CompType],[FloatToStr(CompValue)])
  else if VarIsNull(CompValue) then
  result := result + Format(CCompTypeOp[CompType],['null'])
  else if VarIsStr(CompValue) then
  result := result + Format(CCompTypeOp[CompType],[QuotedStr(CompValue)]);
end;

function TFilterRule.toPasStruct: String;
begin
  result := '(';
  result := result+'Concat:'+CConcat[Concat];
  result := result+';DataField:'+inttostr(DataField);
  result := result+';IndRedir:'+CindRedir[IndRedir];
  result := result+';CompType:'+CCompType[CompType];
  if VarIsNumeric(CompValue) then
  result := result+';CompValue:'+floattostr(CompValue)+')'
  else if VarIsNull(CompValue) then
  result := result+';CompValue:null)'
  else if VarIsStr(CompValue) then
  result := result+';CompValue:'+QuotedStr(CompValue)+')';
end;

procedure TFilterRule.Init(aDataField: Integer; aIndRedir: TEnumHejIndRedir;
  aCompType: TEnumHejCompareType; aCompValue: variant);
begin
  DataField:=aDataField;
  IndRedir:=aIndRedir;
  CompType:=aCompType;
  CompValue:=aCompValue;
end;

procedure TFilterRule.Clear;
begin
  DataField:=0;
  IndRedir:=hIRd_Ind;
  CompType:=hCmp_Nop;
  CompValue:=null;
end;

function TFilterRule.Equals(const aFilterRule: TFilterRule): boolean;
begin
  result := (DataField=aFilterRule.DataField) and
         (IndRedir =aFilterRule.indRedir) and
  (CompType=aFilterRule.CompType) and
  (CompValue=aFilterRule.CompValue);
end;

function TFilterRule.Eval(Ind: integer; ActGen: TClsHejGenealogy): boolean;
var lData:variant;
begin
  if CompType <> hCmp_Nop then
  lData := ActGen.GetData(Ind,IndRedir,DataField)
  else
    lData := null;
  if (varisnull(lData) or varisnull(CompValue)) and
     not (CompType in [hCmp_Nop,hCmp_Equal,hCmp_UnEqual,
       hCmp_IsEmpty,hCmp_IsNotEmpty]) then exit(false);
  case CompType of
    hCmp_nop: result := false;
    hCmp_Equal: result := lData = CompValue;
    hCmp_UnEqual: result := lData <> CompValue;
    hCmp_Less: result := lData < CompValue;
    hCmp_LessOEqual: result := lData <= CompValue;
    hCmp_GreaterOEqual: result := lData >= CompValue;
    hCmp_Greater: result := lData > CompValue;
    hCmp_Startswith: result := copy(lData ,1,length(CompValue))= CompValue;
    hCmp_Endswith: result := RightStr(lData,length(CompValue))= CompValue;
    hCmp_Contains: result := pos(CompValue,lData)>0;
    hCmp_IsEmpty: result := lData = null;
    hCmp_IsNotEmpty: result := lData <> null;
  end;
end;

initialization
    rshCcT[hCcT_Or] := rshCcT_Or ;
    rshCcT[hCcT_Nor] := rshCcT_Nor ;
    rshCcT[hCcT_xor] := rshCcT_xor;
    rshCcT[hCcT_and] := rshCcT_And ;
    rshCcT[hCcT_xor2] := rshCcT_xor2;

    rshCmp[hCmp_Nop          ] := rshCmp_Nop ;
    rshCmp[hCmp_Equal        ] := rshCmp_Equal ;
    rshCmp[hCmp_UnEqual      ] := rshCmp_UnEqual ;
    rshCmp[hCmp_Less         ] := rshCmp_Less ;
    rshCmp[hCmp_LessOEqual   ] := rshCmp_LessOEqual;
    rshCmp[hCmp_GreaterOEqual] := rshCmp_GreaterOEqual;
    rshCmp[hCmp_Greater      ] := rshCmp_Greater ;
    rshCmp[hCmp_Startswith   ] := rshCmp_Startswith;
    rshCmp[hCmp_Endswith     ] := rshCmp_Endswith;
    rshCmp[hCmp_Contains     ] := rshCmp_Contains;
    rshCmp[hCmp_IsEmpty      ] := rshCmp_IsEmpty;
    rshCmp[hCmp_IsNotEmpty   ] := rshCmp_IsNotEmpty;

    rshMtD[hInMeD_ParentCount    ] := rshInMeD_ParentCount    ;
    rshMtD[hInMeD_SpouseCount    ] := rshInMeD_SpouseCount    ;
    rshMtD[hInMeD_ChildCount     ] := rshInMeD_ChildCount     ;
    rshMtD[hInMeD_SiblingCount   ] := rshInMeD_SiblingCount   ;
    rshMtD[hInMeD_SourceCount    ] := rshInMeD_SourceCount    ;
    rshMtD[hInMeD_PlaceCount     ] := rshInMeD_PlaceCount     ;
    rshMtD[hInMeD_AdoptCount     ] := rshInMeD_AdoptCount     ;
    rshMtD[hInMeD_AnyPlace       ] := rshInMeD_AnyPlace       ;
    rshMtD[hInMeD_AnySource      ] := rshInMeD_AnySource      ;
    rshMtD[hInMeD_AnyData        ] := rshInMeD_AnyData        ;
    rshMtD[hInMeD_AgeOfBapt      ] := rshInMeD_AgeOfBapt      ;
    rshMtD[hInMeD_AgeOfNextSibl  ] := rshInMeD_AgeOfNextSibl  ;
    rshMtD[hInMeD_AgeOfConf      ] := rshInMeD_AgeOfConf      ;
    rshMtD[hInMeD_AgeOfFMarriage ] := rshInMeD_AgeOfFMarriage ;
    rshMtD[hInMeD_AgeOfFirstChild] := rshInMeD_AgeOfFirstChild;
    rshMtD[hInMeD_AgeOfLMarriage ] := rshInMeD_AgeOfLMarriage ;
    rshMtD[hInMeD_AgeOfLChild    ] := rshInMeD_AgeOfLChild    ;
    rshMtD[hInMeD_AgeOfDeath     ] := rshInMeD_AgeOfDeath     ;
    rshMtD[hInMeD_AgeDiffToSpouse] := rshInMeD_AgeDiffToSpouse;

end.



