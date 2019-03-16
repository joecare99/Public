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

  TGenFilter=Class
  private
    FActRule: Integer;
    function GetRules(Idx: integer): TFilterRule;
    procedure SetRules(Idx: integer; AValue: TFilterRule);
  private
    FRules:array of TFilterRule;
    Function SingleEval(Ind:integer;ActGen:TClsHejGenealogy):boolean;
    Procedure AppendRule(aConcat:TEnumHejConcType;aFilterRule:TFilterRule);
    Procedure SetRule(aConcat:TEnumHejConcType;aFilterRule:TFilterRule);
    property Rules[Idx:integer]:TFilterRule read GetRules write SetRules;
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
      if FRules[i].Concat in COrConc then
        begin
          case lLastComb of
            hCcT_Or: lOrComb:=lOrComb or lAndComb;
            hCcT_Nor: lOrComb:=lOrComb or not lAndComb;
            hCcT_xor: lOrComb:=lOrComb xor lAndComb;
            else;
          end;
          lAndComb:=true;
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
            hCcT_Or: lOrComb:=lOrComb or lAndComb;
            hCcT_Nor: lOrComb:=lOrComb or not lAndComb;
            hCcT_xor: lOrComb:=lOrComb xor lAndComb;
            else ;
          end;
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
   result := copy(CindRedir[IndRedir],5,10);
   if IndRedir= hIRd_Meta then
     result := '.'+CIndMetaData[TenumIndMetaData(DataField)]
   else
     if DataField < 199 then
       result := '.'+CHejIndDataDesc[TEnumHejIndDatafields(DataField-100)]
     else
         result := '.'+CHejMarrDataDesc[TEnumHejMarrDatafields(DataField-200)];
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
    hCmp_Contains: result := pos(lData ,CompValue)>0;
    hCmp_IsEmpty: result := lData = null;
    hCmp_IsNotEmpty: result := lData <> null;
  end;
end;

end.

