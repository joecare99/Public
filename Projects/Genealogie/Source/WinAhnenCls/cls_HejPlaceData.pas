unit cls_HejPlaceData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db, cls_HejBase;

type
  TEnumHejPlaceDatafields=(
    hplace_ID=-1,
    hplace_Name =0,
    hplace_Zip =1,
    hplace_State=2,
    hplace_District=3,
    hplace_GOV=4,
    hplace_Country=5,
    hplace_PoliticalName=6,
    hplace_Parish=7,
    hplace_County=8,
    hplace_Shortname=9,
    hplace_Longitude=10,
    hplace_Magnitude=11,
    hplace_MaidenheadLoc=12);

  TFieldSset=set of byte;

const
  CHejPlaceDataDesc:array[TEnumHejPlaceDatafields]of string=
    ('ID',
    'PlaceName',
    'ZIPCode',
    'State',
    'District',
    'GOV',
    'Country',
    'PolName',
    'Parish',
    'County',
    'ShortName',
    'Longitude',
    'Magnitude',
    'MaidenheadLoc');

type


 PHejPlaceData = ^THejPlaceData;

 { THejPlaceData }

 THejPlaceData = packed record
private
  function GetData(idx: TEnumHejPlaceDatafields): Variant;
  procedure SetData(idx: TEnumHejPlaceDatafields; AValue: Variant);
public
  function toString:String;
  function ToPasStruct: String;
  Procedure Clear;
  function TestStreamHeader(const st: TStream): boolean;
  Procedure ReadFromStream(const st:TStream);
  Procedure WriteToStream(const st:TStream);
  Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
  Procedure UpdateDataset(const ds:TDataSet);
  function Equals(aValue:THejPlaceData):boolean;
    property Data[idx:TEnumHejPlaceDatafields]:Variant read GetData write SetData;
 public
       ID:integer;
       PlaceName,
       ZIPCode,
       State,
       District,
       GOV,
       Country,
       PolName,
       Parish,
       County,
       ShortName,
       Longitude,
       Magnitude,
       MaidenheadLoc:string;
 end;

 { TClsHejPlaces }

 TClsHejPlaces=class(TClsHejBase)
 private
    FPlaceArray:array of THejPlaceData;
    FActIndex:integer;
    function GetActualPlace: THejPlaceData;
    function GetData(ind: integer; idx: TEnumHejPlaceDatafields): variant;
    function GetPlace(index: integer): THejPlaceData;
    procedure SetActualPlace(AValue: THejPlaceData);
    procedure SetData(ind: integer; idx: TEnumHejPlaceDatafields; AValue: variant
      );
 protected
     function GetCount: integer;override;

 public
    Property Place[index:integer]:THejPlaceData read GetPlace;
    Property ActualPlace:THejPlaceData read GetActualPlace write SetActualPlace;
    Property Data[ind:integer;idx:TEnumHejPlaceDatafields]:variant read GetData write SetData;default;
 public
   Function TestStreamHeader(st:Tstream):boolean;override;
    Procedure Clear;override;
    Procedure SetPlace(aPlace:THejPlaceData);overload;
    Function IndexOf(aPlaceName:Variant):integer;override;
    Procedure ReadfromStream(st: Tstream; {%H-}cls: TClsHejBase=nil); override;
    PRocedure WriteToStream(st:TStream);override;
    Destructor Destroy; override;
 end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{ TClsHejPlaces }

procedure TClsHejPlaces.SetActualPlace(AValue: THejPlaceData);
begin
  if FPlaceArray[FActIndex].Equals(AValue) then Exit;
    FPlaceArray[FActIndex]:=AValue;
end;

procedure TClsHejPlaces.SetData(ind: integer; idx: TEnumHejPlaceDatafields;
  AValue: variant);

begin
  if ind=-1 then
    ind := FActIndex;
  if  (ind >=0) and (ind <= high(FPlaceArray)) then
    FPlaceArray[ind].Data[idx] := AValue;
end;

function TClsHejPlaces.TestStreamHeader(st: Tstream): boolean;
begin
  result := THejPlaceData.TestStreamHeader(st);
end;

procedure TClsHejPlaces.Clear;
begin
  setlength(FPlaceArray,0);
end;

procedure TClsHejPlaces.SetPlace(aPlace: THejPlaceData);
var
  lPlac: Integer;
begin
  // Search Places
  lPlac := IndexOf(aPlace.PlaceName);
  if lPLac =-1 then
    begin
      setlength(FPlaceArray,length(FPlaceArray)+1);
      lPlac:=high(FPlaceArray);
      FActIndex:=lPlac;
    end;
  FPlaceArray[lPlac] := aPlace;
  FPlaceArray[lPlac].ID := lPlac;
end;

function TClsHejPlaces.IndexOf(aPlaceName: Variant): integer;
var
  i: Integer;
begin
  // Todo: Better Algorithm
  result := -1;
  for i := 0 to high(FPlaceArray) do
    if FPlaceArray[i].PlaceName = aPlaceName then
      exit(i);
end;

procedure TClsHejPlaces.ReadfromStream(st: Tstream; cls: TClsHejBase);
const cDSIncr=100;
var
  by: Byte;
  bb:array[0..7] of char;
  lPlaceCount: Integer;
begin
  lPlaceCount := 0;
  if not TestStreamHeader(st) then
    exit;
  repeat
  by:=st.ReadByte;
  st.Seek(-1,soCurrent);
  if by = ord('q') then
    begin
      st.ReadBuffer(bb{%H-},length(bb));
      st.seek(-length(bb),soCurrent);
      if bb='quellv'#13#10 then
        by:=0;
    end;
  if (by >=32) then
    begin
      inc(lPlaceCount);
      if lPlaceCount>length(FPlaceArray) then
      setlength(FPlaceArray,length(FPlaceArray)+cDSIncr);
      FPlaceArray[lPlaceCount-1].ReadFromStream(st);
    end;
  until not (by >=32);
  SetLength(FPlaceArray,lPlaceCount);
end;

procedure TClsHejPlaces.WriteToStream(st: TStream);
const cHdr:array[0..5] of char = 'ortv'#13#10;
var
  i: Integer;
begin
  st.Write(cHdr,length(cHdr));
  for i := 0 to high(FPlaceArray) do
    FPlaceArray[i].WriteToStream(st);
end;

destructor TClsHejPlaces.Destroy;
begin
  setlength(FPlaceArray,0);
  inherited Destroy;
end;

function TClsHejPlaces.GetActualPlace: THejPlaceData;
begin
  result := FPlaceArray[FActIndex];
end;

function TClsHejPlaces.GetCount: integer;
begin
  result := length(FPlaceArray);
end;

function TClsHejPlaces.GetData(ind: integer; idx: TEnumHejPlaceDatafields
  ): variant;
begin
  if (ind >= 0) and (ind <= high(FPlaceArray)) then
    result := FPlaceArray[ind].Data[idx];
end;

function TClsHejPlaces.GetPlace(index: integer): THejPlaceData;
begin
  if (index>=0) and (index <=high(FPlaceArray)) then
    result := FPlaceArray[index];
end;

{ TClsHejData }

function THejPlaceData.GetData(idx: TEnumHejPlaceDatafields): Variant;
begin
  case idx of
    hplace_ID: Result := ID ;
    hplace_Name: Result := PlaceName ;
    hplace_Zip: Result := ZIPCode ;
    hplace_State: Result := State ;
    hplace_District: Result := District ;
    hplace_GOV: Result := GOV ;
    hplace_Country: Result := Country ;
    hplace_PoliticalName: Result := PolName ;
    hplace_Parish: Result := Parish ;
    hplace_County: Result := County ;
    hplace_Shortname: Result := ShortName ;
    hplace_Longitude: Result := Longitude ;
    hplace_Magnitude: Result := Magnitude ;
    hplace_MaidenheadLoc: Result := MaidenheadLoc ;
  else
    result := Null;
  end;
end;

procedure THejPlaceData.SetData(idx: TEnumHejPlaceDatafields; AValue: Variant);
begin
    case idx of
      hplace_ID: ID := AValue ;
      hplace_Name: PlaceName := AValue ;
      hplace_Zip: ZIPCode := AValue ;
      hplace_State: State := AValue ;
      hplace_District: District := AValue ;
      hplace_GOV: GOV := AValue ;
      hplace_Country: Country := AValue ;
      hplace_PoliticalName: PolName := AValue ;
      hplace_Parish: Parish := AValue ;
      hplace_County: County := AValue ;
      hplace_Shortname: ShortName := AValue ;
      hplace_Longitude: Longitude := AValue ;
      hplace_Magnitude: Magnitude := AValue ;
      hplace_MaidenheadLoc: MaidenheadLoc := AValue ;
    end;
end;

function THejPlaceData.toString: String;
begin
   Result := PlaceName;
   if County <>'' then
   Result := result +', '+County;
   if Country <>'' then
   Result := result +', '+Country;
   if State <>'' then
   Result := result +', '+State;
end;

function THejPlaceData.ToPasStruct: String;
var
  lFld: TEnumHejPlaceDatafields;
begin
  result := '(';
  for lFld in TEnumHejPlaceDatafields do
    begin
      if  lFld <> hplace_ID then
        result := result+';';
     if lFld <=hplace_ID then
       result :=result+ CHejPlaceDataDesc[lFld]+':'+inttostr(Data[lFld])
     else
       result :=result+ CHejPlaceDataDesc[lFld]+':'''+Data[lFld]+''''
    end;
  result := result+'{%H-})';
end;

procedure THejPlaceData.Clear;
var
  I: TEnumHejPlaceDatafields;
begin
    for I in TEnumHejPlaceDatafields do
      if I <=  hplace_ID then
        Data[I]:=0
      else
        Data[I]:='';
end;

function THejPlaceData.TestStreamHeader(const st: TStream): boolean;

  var Hdr:array[0..5]of char;
  begin
    st.ReadBuffer(Hdr{%H-},Length(Hdr));
    result:= Hdr='ortv'#13#10;
    if not result then
      st.Seek(-length(Hdr),soCurrent);
end;


procedure THejPlaceData.ReadFromStream(const st: TStream);
var
  by: Byte;
  lAktField: Integer;
  lActStr: String;
begin
  by := 0 ;
  lAktField :=0;
  lActStr := '';
  ID := -1;
  while (by <> 10) and (st.Position <st.Size) do
     begin
       by := st.ReadByte;
       if by >=32 then
          lActStr := lActStr+char(by)
       else
         if by in [10,15] then
           begin
             data[TEnumHejPlaceDatafields(lAktField)] := ConvertEncoding(lActStr,EncodingAnsi,EncodingUTF8);
             if by = 15 then

                 inc(lAktField);

             lActStr:='';
           end
        else if by=16 then
            lActStr:=lActStr+LineEnding;
     end;
end;

procedure THejPlaceData.WriteToStream(const st: TStream);
var
  lActStr: String;
  lAktfield: TEnumHejPlaceDatafields;

begin
  for lAktfield in TEnumHejPlaceDatafields do
    if (lAktField <> hplace_ID) then
     begin
       lActStr := ConvertEncoding(data[lAktField],EncodingUTF8,EncodingAnsi);
       lActStr :=StringReplace(lActStr,#15,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,#16,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,LineEnding,#16,[rfReplaceAll]);
       if (lAktField <> hplace_Name) then
           st.WriteByte(15);
       if length(lActStr) >0 then
         st.WriteBuffer(lActStr[1],length(lActStr));
     end;
  st.WriteBuffer(LineEnding[1],length(LineEnding));
end;

procedure THejPlaceData.ReadFromDataset(idx: integer; const ds: TDataSet);


var
   i: Integer;

begin
  if ds.Active then
    begin
      ds.Locate(ds.Fields[0].Name,idx,[]);
      for i := 0 to ds.FieldCount-1 do
         Data[TEnumHejPlaceDatafields(i)]:=ds.Fields[i].AsVariant;
    end;
end;

procedure THejPlaceData.UpdateDataset(const ds: TDataSet);
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
         Fchanged := CheckandUpdate(ds.Fields[i],Data[TEnumHejPlaceDatafields(i-1)]) or Fchanged ;
      if FChanged then
        ds.Post
      else
        ds.Cancel;
    end;
end;

function THejPlaceData.Equals(aValue: THejPlaceData): boolean;
var
  I: TEnumHejPlaceDatafields;
begin
   Result := true;
   for I in TEnumHejPlaceDatafields do
     if ord(I) >  ord(hplace_ID) then
       Result := Result and (Data[I] = aValue.Data[I]);
end;


end.

