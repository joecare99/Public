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
    Function Eval(Ind:integer;ActGen:TClsHejGenealogy):boolean;
  public
    // Datenfelder
    Concat:TEnumHejConcType;
    DataField:Integer; //
    IndRedir:TEnumHejIndRedir;
    CompType:TEnumHejCompareType;
    CompValue:variant;
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
     'like "%s*"',
     'like "*%s"',
     'like "*%s*"',
     'IsEmpty',
     'IsNotEmpty');

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

implementation

uses cls_HejIndData,cls_HejMarrData;

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

  result := result + Format(CCompTypeOp[CompType],[string(CompValue)]);
end;

function TFilterRule.toPasStruct: String;
begin
  result := '(';
  result := result+'Concat:'+CConcat[Concat];
  result := result+';DataField:'+inttostr(DataField);
  result := result+';IndRedir:'+CindRedir[IndRedir];
  result := result+';CompType:'+CCompType[CompType];
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

