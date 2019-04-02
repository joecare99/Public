unit cls_HejDataFilter;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, cls_HejData;


type
  TEnumHejConcType=
    ( hCcT_Or = 0,   // ) OR ( ...
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


implementation

uses variants,cls_HejIndData,cls_HejMarrData;

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

end.

