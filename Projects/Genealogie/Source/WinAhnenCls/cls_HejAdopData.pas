unit cls_HejAdopData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db, cls_HejBase;

type
  TEnumHejAdopDatafields=(
    hadop_ID=-1,
    hadop_idPerson =0,
    hadop_idFather =1,
    hadop_idMother =2);

  TMarrFieldSset=set of byte;

const
  CHejAdopDataDesc:array[TEnumHejAdopDatafields]of string=
    ('ID',
    'idPerson',
    'idFather_adop',
    'idMother_adop');

type


 PHejAdopData = ^THejAdopData;

 { THejAdopData }

 THejAdopData = packed record
private
  function GetData(idx: TEnumHejAdopDatafields): Variant;
  procedure SetData(idx: TEnumHejAdopDatafields; AValue: Variant);
public
  function toString:String;
  function ToPasStruct:String;
  Procedure Clear;
  function TestStreamHeader(const st: TStream): boolean;
  Procedure ReadFromStream(const st:TStream);
  Procedure WriteToStream(const st:TStream);
  Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
  Procedure UpdateDataset(const ds:TDataSet);
  function Equals(aValue:THejAdopData):boolean;
    property Data[idx:TEnumHejAdopDatafields]:Variant read GetData write SetData;
 public
       ID,
       idPerson,
       idFather_adop,
       idMother_adop:integer;
 end;

 { TClsHejData }

 { TClsHejAdoptions }

 TClsHejAdoptions=class(TClsHejBase)
 private
    FAdopArray:array of THejAdopData;
    FActIndex:integer;
    function GetActualAdop: THejAdopData;
    function GetAdoption(index: integer): THejAdopData;
    procedure SetActualAdop(AValue: THejAdopData);
 protected
    function GetCount: integer;override;
 public
    function GetData(ind: integer; idx: TEnumHejAdopDatafields): variant;
    procedure SetData(ind: integer; idx: TEnumHejAdopDatafields; AValue: variant
      );
    PRocedure ReplacePerson(aInd,aInd2:integer);
    Property Adoption[index:integer]:THejAdopData read GetAdoption;
    Property ActualAdop:THejAdopData read GetActualAdop write SetActualAdop;
    Property Data[ind:integer;idx:TEnumHejAdopDatafields]:variant read GetData write SetData;default;
 public
    Function TestStreamHeader(st:Tstream):boolean;override;
    function IndexOf(Krit: variant): integer; override;
    Procedure Clear;Override;
    Procedure Append(Sender:TObject=nil);
    procedure ReadfromStream(st: Tstream; {%H-}cls: TClsHejBase=nil); override;
    PRocedure WriteToStream(st:TStream);override;
    Destructor Destroy; override;
 end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{ TClsHejAdoptions }

procedure TClsHejAdoptions.SetActualAdop(AValue: THejAdopData);
begin
  if FAdopArray[FActIndex].Equals(AValue) then Exit;
    FAdopArray[FActIndex]:=AValue;
end;

procedure TClsHejAdoptions.SetData(ind: integer; idx: TEnumHejAdopDatafields;
  AValue: variant);

begin
  if ind=-1 then
    ind:=FActIndex;
  if  (ind >=0) and (ind <= high(FAdopArray)) then
    FAdopArray[ind].Data[idx] := AValue;
end;

procedure TClsHejAdoptions.ReplacePerson(aInd, aInd2: integer);
var
  i: Integer;
begin
  for i := 0 to high(FAdopArray) do
    begin
      if FAdopArray[i].idPerson= aInd then
        FAdopArray[i].idPerson:= aInd2;
      if FAdopArray[i].idFather_adop= aInd then
        FAdopArray[i].idFather_adop:= aInd2;
      if FAdopArray[i].idMother_adop= aInd then
        FAdopArray[i].idMother_adop:= aInd2;
    end;
end;

function TClsHejAdoptions.TestStreamHeader(st: Tstream): boolean;
begin
  result := THejAdopData.TestStreamHeader(st);
end;

function TClsHejAdoptions.IndexOf(Krit: variant): integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to High(FActIndex) do
    if FAdopArray[i].idPerson=Krit then
      exit(i);
end;

procedure TClsHejAdoptions.Clear;
begin
  setlength(FAdopArray,0);
end;

procedure TClsHejAdoptions.Append(Sender: TObject);
begin
  Setlength(FAdopArray,High(FAdopArray)+2);
  FActIndex := high(FAdopArray);
  FAdopArray[FActIndex].ID:=FActIndex;
end;

procedure TClsHejAdoptions.ReadfromStream(st: Tstream; cls: TClsHejBase);
const cDSIncr=100;
var
  by: Byte;
  lAdopCount: Integer;
begin
  lAdopCount := 0;
  if not TestStreamHeader(st) then
    exit;
  repeat
  by:=st.ReadByte;
  st.Seek(-1,soCurrent);
  if by in [49..57] then
    begin
      inc(lAdopCount);
      if lAdopCount> length(FAdopArray) then
        setlength(FAdopArray,length(FAdopArray)+cDSIncr);
      FAdopArray[lAdopCount-1].ReadFromStream(st);
      FAdopArray[lAdopCount-1].ID := lAdopCount-1;
    end;
  until not(by in [49..57]);
  SetLength(FAdopArray,lAdopCount);
end;

procedure TClsHejAdoptions.WriteToStream(st: TStream);
const cHdr:array[0..5] of char = 'adop'#13#10;
var
  i: Integer;
begin
  st.Write(cHdr,length(cHdr));
  for i := 0 to high(FAdopArray) do
    FAdopArray[i].WriteToStream(st);
end;

destructor TClsHejAdoptions.Destroy;
begin
  SetLength(FAdopArray,0);
  inherited Destroy;
end;

function TClsHejAdoptions.GetActualAdop: THejAdopData;
begin
  result := FAdopArray[FActIndex];
end;

function TClsHejAdoptions.GetCount: integer;
begin
  result := length(FAdopArray);
end;

function TClsHejAdoptions.GetData(ind: integer; idx: TEnumHejAdopDatafields
  ): variant;
begin
  if ind=-1 then
    ind:=FActIndex;
  if (ind >= 0) and (ind <= high(FAdopArray)) then
    result := FAdopArray[ind].Data[idx];
end;

function TClsHejAdoptions.GetAdoption(index: integer): THejAdopData;
begin
  if (index>=0) and (index <=high(FAdopArray)) then
    result := FAdopArray[index];
end;

{ TClsHejData }

function THejAdopData.GetData(idx: TEnumHejAdopDatafields): Variant;
begin
  case idx of
    hadop_ID: Result := ID ;
    hadop_idPerson: Result := idPerson ;
    hadop_idFather: Result := idFather_adop ;
    hadop_idMother: Result := idMother_adop ;
  else
    result := Null;
  end;
end;

procedure THejAdopData.SetData(idx: TEnumHejAdopDatafields; AValue: Variant);
begin
    case idx of
      hadop_ID: ID := AValue ;
      hadop_idPerson: idPerson := AValue ;
      hadop_idFather: idFather_adop := AValue ;
      hadop_idMother: idMother_adop := AValue ;
    end;
end;

function THejAdopData.toString: String;
begin
   Result := Inttostr(idPerson);
   if idFather_adop <>0 then
     result := result + ' aV:'+inttostr(idFather_adop);
   if idMother_adop <>0 then
     result := result + ' aM:'+inttostr(idMother_adop);
end;

function THejAdopData.ToPasStruct: String;
var
  lFld: TEnumHejAdopDatafields;
begin
  result := '(';
  for lFld in TEnumHejAdopDatafields do
    begin
      if  lFld <> hadop_ID then
        result := result+';';
//     if lFld <=hadop_idMother then
       result :=result+ CHejAdopDataDesc[lFld]+':'+inttostr(Data[lFld])
//     else
//       result :=result+ CHejAdopDataDesc[lFld]+':'''+Data[lFld]+''''
    end;
  result := result+'{%H-})';
end;

procedure THejAdopData.Clear;
var
  I: TEnumHejAdopDatafields;
begin
    for I in TEnumHejAdopDatafields do
      if I <=  hadop_idMother then
        Data[I]:=0
      else
        Data[I]:='';
end;

function THejAdopData.TestStreamHeader(const st: TStream): boolean;

  var Hdr:array[0..5]of char;
  begin
    st.ReadBuffer(Hdr{%H-},Length(Hdr));
    result:= Hdr='adop'#13#10;
    if not result then
      st.Seek(-length(Hdr),soCurrent);
end;

procedure THejAdopData.ReadFromStream(const st: TStream);
var
  by: Byte;
  lAktField: Integer;
  lActStr: String;
begin
  by := 0 ;
  lAktField :=0;
  ID:=-1;
  lActStr := '';
  while (by <> 10) and (st.Position <st.Size) do
     begin
       by := st.ReadByte;
       if by >=32 then
          lActStr := lActStr+char(by)
       else
         if by in [10,15] then
           begin
             data[TEnumHejAdopDatafields(lAktField)] := ConvertEncoding(lActStr,EncodingAnsi,EncodingUTF8);
             if by = 15 then

                 inc(lAktField);

             lActStr:='';
           end
        else if by=16 then
            lActStr:=lActStr+LineEnding;
     end;
end;

procedure THejAdopData.WriteToStream(const st: TStream);
var
  lActStr: String;
  lAktfield: TEnumHejAdopDatafields;

begin
  for lAktfield in TEnumHejAdopDatafields do
    if (lAktField <> hadop_ID) then
     begin
       lActStr := ConvertEncoding(data[lAktField],EncodingUTF8,EncodingAnsi);
       lActStr :=StringReplace(lActStr,#15,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,#16,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,LineEnding,#16,[rfReplaceAll]);
       if (lAktField <> hadop_idPerson) then
           st.WriteByte(15);
       if length(lActStr) >0 then
         st.WriteBuffer(lActStr[1],length(lActStr));
     end;
  st.WriteBuffer(LineEnding[1],length(LineEnding));
end;

procedure THejAdopData.ReadFromDataset(idx: integer; const ds: TDataSet);

var
   i: Integer;

begin
  if ds.Active then
    begin
      ds.Locate(ds.Fields[0].Name,idx,[]);
      for i := 0 to ds.FieldCount-1 do
        case i of
          0..2 : Data[TEnumHejAdopDatafields(i-1)]:=ds.Fields[i].AsVariant;
        else
        end;
    end;
end;

procedure THejAdopData.UpdateDataset(const ds: TDataSet);
var
  i: Integer;
  FChanged: Boolean;

  function CheckAndUpdate(const vDest:TField;const vSource:variant):boolean;

  begin
    result := vDest.AsVariant <> vSource;
    if result then
      vDest.AsVariant:= vSource;
  end;

begin
  if ds.Active then
    begin
      FChanged := false;
      if ds.Locate(ds.Fields[0].Name,ID,[]) then
        ds.Edit
      else
        begin
        ds.Append;
         Fchanged :=true;
         ds.Fields[0].AsInteger := ID;
        end;
      for i := 0 to ds.FieldCount-1 do
        case i of
          0..2 : Fchanged := CheckandUpdate(ds.Fields[i],Data[TEnumHejAdopDatafields(i-1)]) or Fchanged ;
        else
        end;
      if FChanged then
        ds.Post
      else
        ds.Cancel;
    end;
end;

function THejAdopData.Equals(aValue: THejAdopData): boolean;
var
  I: TEnumHejAdopDatafields;
begin
   Result := true;
   for I in TEnumHejAdopDatafields do
     if ord(I) >  ord(hadop_ID) then
       Result := Result and (Data[I] = aValue.Data[I]);
end;


end.

