unit cls_HejMarrData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db,cls_HejBase, cls_HejIndData;

type
  TEnumHejMarrDatafields=(
    hmar_ID=-1,
    hmar_idPerson =0,
    hmar_idSpouse =1,
    hmar_MarrChrchDay=2,
    hmar_MarrChrchMonth=3,
    hmar_MarrChrchYear=4,
    hmar_MarrChrchPlace=5,
    hmar_MarrChrchWitness=6,
    hmar_MarrStateDay=7,
    hmar_MarrStateMonth=8,
    hmar_MarrStateYear=9,
    hmar_MarrStatePlace=10,
    hmar_MarrStateWitness=11,
    hmar_Kind=12,
    hmar_DivorceDay=13,
    hmar_DivorceMonth=14,
    hmar_DivorceYear=15,
    hmar_DivorcePlace=16,
    hmar_MarrChrchSource=17,
    hmar_MarrStateSource=18,
    hmar_DivorceSource=19,
    hmar_Indj=20,
    hmar_Indm=21
    );

  TMarrFieldSset=set of byte;

const
  CHejMarrDataDesc:array[TEnumHejMarrDatafields]of string=
    ('ID',
    'idPerson',
    'idSpouse',
    'MarrChrchDay',
    'MarrChrchMonth',
    'MarrChrchYear',
    'MarrChrchplace',
    'MarrChrchWitness',
    'MarrStateDay',
    'MarrStateMonth',
    'MarrStateYear',
    'MarrStatePlace',
    'MarrStateWitness',
    'Kind',
    'DivorceDay',
    'DivorceMonth',
    'DivorceYear',
    'DivorcePlace',
    'MarrChrchSource',
    'MarrStateSource',
    'DivorceSource',
    'Indj',
    'Indm');

  CMarrPlaceData = [hmar_MarrChrchPlace, hmar_MarrStatePlace, hmar_DivorcePlace];

  CMarrSourceData = [hmar_MarrChrchSource, hmar_MarrStateSource, hmar_DivorceSource];

type


 PHejMarrData = ^THejMarrData;

 { THejMarrData }

 THejMarrData = packed record
private
  function GetData(idx: TEnumHejMarrDatafields): Variant;
  function GetValue: Double;
  procedure SetData(idx: TEnumHejMarrDatafields; AValue: Variant);
public
  function ToString:String;
  function ToPasStruct:String;
  function PlaceCount:integer;
  function SourceCount:integer;
  function GetDateData(idx: TEnumHejMarrDatafields): string;
  Procedure Clear;
  Procedure ReadFromStream(const st:TStream);
  Procedure WriteToStream(const st:TStream);
  function  TestStreamHeader(const st:TStream):boolean;
  Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
  Procedure UpdateDataset(const ds:TDataSet);
  function Equals(aValue:THejMarrData;OnlyData:boolean=False):boolean;
  property Data[idx:TEnumHejMarrDatafields]:Variant read GetData write SetData;
  property Value:Double read GetValue;
 public
       ID,
       idPerson,
       idSpouse:integer;
       MarrChrchDay,
       MarrChrchMonth,
       MarrChrchYear,
       MarrChrchplace,
       MarrChrchWitness,
       MarrStateDay,
       MarrStateMonth,
       MarrStateYear,
       MarrStatePlace,
       MarrStateWitness,
       Kind,
       DivorceDay,
       DivorceMonth,
       DivorceYear,
       DivorcePlace,
       MarrChrchSource,
       MarrStateSource,
       DivorceSource,
       Indj,
       Indm:string;
       revIdx:integer;
 end;

 { TClsHejData }

 { TClsHejMarriages }

 TClsHejMarriages=class(TClsHejBase)
 private
    FMarrArray:array of THejMarrData;
    FActIndex:integer;
    function GetActualMarr: THejMarrData;
    function GetData(Marr: integer; idx: TEnumHejMarrDatafields): variant;
    function GetMarriage(index: integer): THejMarrData;
    procedure SetActualMarr(AValue: THejMarrData);
 protected
    function GetCount: integer;override;
 public
    procedure SetData(Marr: integer; idx: TEnumHejMarrDatafields; AValue: variant
      );
    function GetDateData(Marr: integer; idx: TEnumHejMarrDatafields): string;
    Procedure Seek(ID:integer);
    Function GetActID:integer;
    Property Marriage[index:integer]:THejMarrData read GetMarriage;
    Property ActualMarr:THejMarrData read GetActualMarr write SetActualMarr;
    Property Data[ind:integer;idx:TEnumHejMarrDatafields]:variant read GetData write SetData;default;
 public
    Function TestStreamHeader(st:Tstream):boolean;override;
    function IndexOf(Krit: variant): integer; override;
    Procedure Clear;override;
    procedure ReadfromStream(st:Tstream;Idiv:TClsHejBase=nil);Override;
    PRocedure WriteToStream(st:TStream);override;
    Destructor Destroy; override;
    PRocedure Append(Sender:TObject=nil);
    Procedure SetRevIdx(aRevIdx:integer);
    Procedure ActualMarrSetLink(idPerson,idSpouse:integer);
 end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{ TClsHejMarriages }

function TClsHejMarriages.IndexOf(Krit: variant): integer;

var
  i: Integer;
begin
  result := -1;
  if VarIsArray(Krit) then
    begin
      if (VarArrayHighBound(Krit,1)<1) or
        not VarIsNumeric(Krit[0]) or
        not VarIsNumeric(Krit[1]) then exit;
    for i := 0 to High(FMarrArray) do
      if (FMarrArray[i].idPerson = Krit[0]) and
        (FMarrArray[i].idSpouse = Krit[1]) then
        exit(i);
    end
  else
  if VarIsFloat(Krit) then
    begin
      // Todo: Suche nach Datum
      runerror(211);
    end
  else
  if VarIsNumeric(Krit) then
    begin
      if Krit = -1 then
        exit(FActIndex)
      else
        exit(Krit);
    end;

end;

procedure TClsHejMarriages.SetData(Marr: integer; idx: TEnumHejMarrDatafields;
  AValue: variant);

begin
  if Marr = -1 then
    Marr:= FActIndex;
  if (Marr >=0) and (Marr <= high(FMarrArray)) then
    FMarrArray[FActIndex].Data[idx] := AValue;
end;

function TClsHejMarriages.GetDateData(Marr: integer; idx: TEnumHejMarrDatafields
  ): string;
begin
  if Marr = -1 then
    Marr := FActIndex;
  result := FMarrArray[marr].GetDateData(idx);
end;

procedure TClsHejMarriages.Seek(ID: integer);
begin
  if (ID >=0) and (ID <= high(FMarrArray)) then
     FActIndex:=ID;
end;

function TClsHejMarriages.TestStreamHeader(st: Tstream): boolean;
 begin
    result := THejMarrData.TestStreamHeader(st);
end;

procedure TClsHejMarriages.Clear;
begin
  setlength(FMarrArray,0);
end;

procedure TClsHejMarriages.ReadfromStream(st: Tstream; Idiv: TClsHejBase);

const cDSIncr=100;
var
  by: Byte;
    lMarrCount, i: Integer;
begin
  lMarrCount := 0;
  if not TestStreamHeader(st) then
    exit;
  repeat
  by:=st.ReadByte;
  st.Seek(-1,soCurrent);
  if by in [49..57] then
    begin
      inc (lMarrCount);
      if lMarrCount>length(FMarrArray) then
        setlength(FMarrArray,length(FMarrArray)+cDSIncr);
      FMarrArray[lMarrCount-1].ReadFromStream(st);
      FMarrArray[lMarrCount-1].ID := lMarrCount-1;
    end;
  until not(by in [49..57]);
  setlength(FMarrArray,lMarrCount);
  if Assigned(Idiv)and Idiv.InheritsFrom(TClsHejIndividuals) then
    for i := 0 to lMarrCount-1 do
      begin
      TClsHejIndividuals(Idiv).AppendMarriage(FMarrArray[i].idPerson,i);
      // Setze rv-Index
      end;
end;

procedure TClsHejMarriages.WriteToStream(st: TStream);
const cHdr:array[0..4] of char = 'mrg'#13#10;
var
  i: Integer;
begin
  st.Write(cHdr,length(cHdr));
  for i := 0 to high(FMarrArray) do
    FMarrArray[i].WriteToStream(st);
end;

destructor TClsHejMarriages.Destroy;
begin
  setlength(FMarrArray,0);
  inherited Destroy;
end;

procedure TClsHejMarriages.Append(Sender: TObject);
begin
  SetLength(FMarrArray,length(FMarrArray)+1);
  FActIndex:=high(FMarrArray);
  FMarrArray[FActIndex].id :=FActIndex;
end;

procedure TClsHejMarriages.SetRevIdx(aRevIdx: integer);
begin
  if (FMarrArray[FActIndex].idPerson=FMarrArray[aRevIdx].idSpouse) and
     (FMarrArray[FActIndex].idSpouse=FMarrArray[aRevIdx].idPerson) then
       begin
  FMarrArray[FActIndex].revIdx:=aRevIdx;
  FMarrArray[aRevIdx].revIdx:=FActIndex;
       end;
end;

procedure TClsHejMarriages.ActualMarrSetLink(idPerson, idSpouse: integer);
begin
  FMarrArray[FActIndex].idPerson:=idPerson;
  FMarrArray[FActIndex].idSpouse:=idSpouse;
end;

function TClsHejMarriages.GetActID: integer;
begin
  result := FActIndex;
end;

function TClsHejMarriages.GetActualMarr: THejMarrData;
begin
  result := FMarrArray[FActIndex];
end;

function TClsHejMarriages.GetData(Marr: integer; idx: TEnumHejMarrDatafields
  ): variant;
begin
  if Marr=-1 then
    Marr:= FActIndex;
  if (Marr >= 0) and (Marr <= high(FMarrArray)) then
    result := FMarrArray[Marr].Data[idx];
end;

function TClsHejMarriages.GetMarriage(index: integer): THejMarrData;
begin
  if (index>=0) and (index <=high(FMarrArray)) then
    result := FMarrArray[index];
end;

function TClsHejMarriages.GetCount: integer;
begin
  result := length(FMarrArray);
end;

procedure TClsHejMarriages.SetActualMarr(AValue: THejMarrData);

begin
  if FMarrArray[FActIndex].Equals(AValue,true) then Exit;
  AValue.ID := FActIndex;
  AValue.idPerson := FMarrArray[FActIndex].idPerson;
  AValue.idSpouse := FMarrArray[FActIndex].idSpouse;
  AValue.revIdx := FMarrArray[FActIndex].revIdx;
  FMarrArray[FActIndex]:=AValue;
  if (AValue.revIdx <>0) or ((FMarrArray[0].revIdx=FActIndex) and (FActIndex>0)) then
    begin
      AValue.revIdx := FActIndex;
      AValue.ID := FMarrArray[FActIndex].revIdx;
      AValue.idSpouse := FMarrArray[FActIndex].idPerson;
      AValue.idPerson := FMarrArray[FActIndex].idSpouse;
      FMarrArray[AValue.ID]:=AValue;
    end;
end;

{ TClsHejData }

function THejMarrData.GetData(idx: TEnumHejMarrDatafields): Variant;
begin
  case idx of
    hmar_ID: Result := ID ;
    hmar_idPerson: Result := idPerson ;
    hmar_idSpouse: Result := idSpouse ;
    hmar_MarrChrchDay: Result := MarrChrchDay ;
    hmar_MarrChrchMonth: Result := MarrChrchMonth ;
    hmar_MarrChrchYear: Result := MarrChrchYear ;
    hmar_MarrChrchplace: Result := MarrChrchplace ;
    hmar_MarrChrchWitness: Result := MarrChrchWitness ;
    hmar_MarrStateDay: Result := MarrStateDay ;
    hmar_MarrStateMonth: Result := MarrStateMonth ;
    hmar_MarrStateYear: Result := MarrStateYear ;
    hmar_MarrStatePlace: Result := MarrStatePlace ;
    hmar_MarrStateWitness: Result := MarrStateWitness ;
    hmar_Kind: Result := Kind ;
    hmar_DivorceDay: Result := DivorceDay ;
    hmar_DivorceMonth: Result := DivorceMonth ;
    hmar_DivorceYear: Result := DivorceYear ;
    hmar_DivorcePlace: Result := DivorcePlace ;
    hmar_MarrChrchSource: Result := MarrChrchSource ;
    hmar_MarrStateSource: Result := MarrStateSource ;
    hmar_DivorceSource: Result := DivorceSource ;
    hmar_Indj: Result := Indj ;
    hmar_Indm: Result := Indm ;
  else
    result := Null;
  end;
end;

function THejMarrData.GetValue: Double;
var
  lDate: TDateTime;
begin
  result := -1e-10;
  if TryStrToDate(GetDateData(hmar_MarrChrchDay),lDate) then
    exit(lDate)
  else
    if TryStrToDate(GetDateData(hmar_MarrStateDay),lDate) then
      exit(lDate)

end;

procedure THejMarrData.SetData(idx: TEnumHejMarrDatafields; AValue: Variant);
begin
    case idx of
      hmar_ID: ID := AValue ;
      hmar_idPerson: idPerson := AValue ;
      hmar_idSpouse: idSpouse := AValue ;
      hmar_MarrChrchDay: MarrChrchDay := AValue ;
      hmar_MarrChrchMonth: MarrChrchMonth := AValue ;
      hmar_MarrChrchYear: MarrChrchYear := AValue ;
      hmar_MarrChrchplace: MarrChrchplace := AValue ;
      hmar_MarrChrchWitness: MarrChrchWitness := AValue ;
      hmar_MarrStateDay: MarrStateDay := AValue ;
      hmar_MarrStateMonth: MarrStateMonth := AValue ;
      hmar_MarrStateYear: MarrStateYear := AValue ;
      hmar_MarrStatePlace: MarrStatePlace := AValue ;
      hmar_MarrStateWitness: MarrStateWitness := AValue ;
      hmar_Kind: Kind := AValue;
      hmar_DivorceDay: DivorceDay := AValue ;
      hmar_DivorceMonth: DivorceMonth := AValue ;
      hmar_DivorceYear: DivorceYear := AValue ;
      hmar_DivorcePlace: DivorcePlace := AValue ;
      hmar_MarrChrchSource: MarrChrchSource := AValue ;
      hmar_MarrStateSource: MarrStateSource := AValue ;
      hmar_DivorceSource: DivorceSource := AValue ;
      hmar_Indj: Indj:=AValue;
      hmar_Indm: Indm:=AValue;
    else
    end;
end;

function THejMarrData.ToString: String;
begin
  Result:='';
  if  MarrChrchDay+MarrChrchMonth+MarrChrchYear <> '' then
    Result := result +' ooK'+MarrChrchDay+'.'+MarrChrchMonth+'.'+MarrChrchYear;
  delete(result,1,1);
end;

function THejMarrData.ToPasStruct: String;
var
  lFld: TEnumHejMarrDatafields;
begin
  result := '(';
  for lFld in TEnumHejMarrDatafields do
    begin
      if  lFld <> hmar_id then
        result := result+';';
     if lFld <=hmar_idSpouse then
       result :=result+ CHejMarrDataDesc[lFld]+':'+inttostr(Data[lFld])
     else
       result :=result+ CHejMarrDataDesc[lFld]+':'''+Data[lFld]+''''
    end;
  result := result+'{%H-})';
end;

function THejMarrData.PlaceCount: integer;
var lMdf:TEnumHejMarrDatafields;
begin
  result := 0;
  for lMdf in CMarrPlaceData do
    if Data[lMdf] <> '' then
       result := result+ 1;
end;

function THejMarrData.SourceCount: integer;
var lMdf:TEnumHejMarrDatafields;
begin
  result := 0;
  for lMdf in CMarrSourceData do
    if Data[lMdf] <> '' then
       result := result+ 1;
end;

function THejMarrData.GetDateData(idx: TEnumHejMarrDatafields): string;
begin
  result := HejDate2DateStr(data[idx],
  Data[TEnumHejMarrDatafields(ord(idx)+1)],
  Data[TEnumHejMarrDatafields(ord(idx)+2)]);
end;

procedure THejMarrData.Clear;
var
  I: TEnumHejMarrDatafields;
begin
    for I in TEnumHejMarrDatafields do
      if ord(I) <=  ord(hmar_idSpouse) then
        Data[I]:=0
      else
        Data[I]:='';
end;

procedure THejMarrData.ReadFromStream(const st: TStream);
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
             data[TEnumHejMarrDatafields(lAktField)] := ConvertEncoding(lActStr,EncodingAnsi,EncodingUTF8);
             if by = 15 then
               begin
                 inc(lAktField);
               end;
             lActStr:='';
           end
        else if by=16 then
            lActStr:=lActStr+LineEnding;
     end;
end;

procedure THejMarrData.WriteToStream(const st: TStream);
var
  lActStr: String;
  lAktfield: TEnumHejMarrDatafields;

begin
  for lAktfield in TEnumHejMarrDatafields do
    if (lAktField <> hmar_ID) then
     begin
       lActStr := ConvertEncoding(data[lAktField],EncodingUTF8,EncodingAnsi);
       lActStr :=StringReplace(lActStr,#15,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,#16,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,LineEnding,#16,[rfReplaceAll]);
       if (lAktField <> hmar_idPerson) then
           st.WriteByte(15);
       if length(lActStr) >0 then
         st.WriteBuffer(lActStr[1],length(lActStr));
     end;
  st.WriteBuffer(LineEnding[1],length(LineEnding));
end;

function THejMarrData.TestStreamHeader(const st: TStream): boolean;

  var Hdr:array[0..4]of char;
  begin
    st.ReadBuffer(Hdr{%H-},Length(Hdr));
    result:= Hdr='mrg'#13#10;
    if not result then
      st.Seek(-length(Hdr),soCurrent);
end;

procedure THejMarrData.ReadFromDataset(idx: integer; const ds: TDataSet);


  function Convertjn(aValue:String):String;

  var
    i: Integer;
  begin
    result := aValue;
    for i := 0 to high(SR_Array_jn) div 2 do
      if SR_Array_jn[i*2+1]=aValue then
        exit(SR_Array_jn[i*2])
  end;

  function ConvertDModif(aValue:String):String;

  var
    i: Integer;
  begin
    result := aValue;
    for i := 0 to high(SR_Array_DModif) div 2 do
      if SR_Array_DModif[i*2+1]=aValue then
        exit(SR_Array_DModif[i*2])
  end;

var
  lDate: TDateTime;
  lDateModif: String;
  lDst, i: Integer;
begin
  if ds.Active then
    begin
      ds.Locate(ds.Fields[0].Name,idx,[]);
      for i := 0 to ds.FieldCount-1 do
        case i of
          0..1 : Data[TEnumHejMarrDatafields(i-1)]:=ds.Fields[i].AsVariant;
    //      5 : Data[TEnumHejMarrDatafields(i-1)]:=convertSex(ds.Fields[i].AsString);
          2,7,12: // MarrChrchdate
             begin
               case i of
                 2:lDst := ord(hmar_MarrChrchDay);
                 7:lDst := ord(hmar_MarrStateDay);
                 12:lDst := ord(hmar_DivorceDay);
                 else
                   lDst := -2;
               end;
               lDateModif := ConvertDModif(ds.Fields[i+1].AsString);
               if ds.Fields[i].IsNull then
                 begin
                   if lDateModif ='' then
                     data[TEnumHejMarrDatafields(lDst)]:=''
                   else
                data[TEnumHejMarrDatafields(lDst)]:=lDateModif;
               data[TEnumHejMarrDatafields(lDst+1)]:='';
               data[TEnumHejMarrDatafields(lDst+2)]:='';
                 end
               else
               lDate:=ds.Fields[i].AsDateTime;
               if lDateModif ='' then
                 data[TEnumHejMarrDatafields(lDst)]:=DayOf(lDate)
               else
                 data[TEnumHejMarrDatafields(lDst)]:=lDateModif;
               data[TEnumHejMarrDatafields(lDst+1)]:=MonthOf(lDate);
               data[TEnumHejMarrDatafields(lDst+2)]:=YearOf(lDate);
             end;
          3,8,13:; // Wird in i-1 behandelt
          4: data[hmar_MarrChrchplace] := ds.Fields[i].AsString;
          5: data[hmar_MarrChrchWitness] := ds.Fields[i].AsString;
          6: data[hmar_MarrChrchSource] := ds.Fields[i].AsString;
          9: data[hmar_MarrStatePlace] := ds.Fields[i].AsString;
          10: data[hmar_MarrStateWitness] := ds.Fields[i].AsString;
          11: data[hmar_MarrStateSource] := ds.Fields[i].AsString;
          14: data[hmar_DivorcePlace] := ds.Fields[i].AsString;
          15: data[hmar_DivorceSource] := ds.Fields[i].AsString;
        else
        end;
    end;
end;

procedure THejMarrData.UpdateDataset(const ds: TDataSet);
var
  i, lDst: Integer;
  FChanged: Boolean;
  lDateModif: String;
  lYear,lMonth,lDay:string;
  lDate: TDateTime;
  lYearn,lMonthn,lDayn: integer;

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
          0..1 : Fchanged := CheckandUpdate(ds.Fields[i],Data[TEnumHejMarrDatafields(i-1)]) or Fchanged ;

          2,7,12: // MarrChrchdate
             begin
               case i of
                 2:lDst := ord(hmar_MarrChrchDay);
                 7:lDst := ord(hmar_MarrStateDay);
                 12:lDst := ord(hmar_DivorceDay);
                 else
                   lDst := -2;
               end;
               lDateModif := '';
               lYear :=  data[TEnumHejMarrDatafields(lDst+2)];
               lMonth:=data[TEnumHejMarrDatafields(lDst+1)];
               lDay:=data[TEnumHejMarrDatafields(lDst)];
               if (lYear='') or not trystrtoint(lYear,lYearn) then
                 Fchanged := CheckAndUpdate(ds.Fields[i],null) or FChanged
               else begin
                 if (copy(lDay,1,1)>='0') and (copy(lDay,1,1)<='9') and tryStrtoint(lDay,lDayn) and TryStrToInt(lMonth,lMonthn) and
                   TryEncodeDate(lYearn,lMonthn,lDayn,lDate) then
               else
                 begin
                   lDateModif := data[TEnumHejMarrDatafields(lDst)];
                   if TryStrToInt(lMonth,lMonthn) and TryEncodeDate(lYearn,lMonthn,1,lDate) then
                   else
                     tryEncodeDate(lYearn,1,1,lDate);
                 end;
                                Fchanged := CheckAndUpdate(ds.Fields[i],lDate) or FChanged;
                 end;
               Fchanged := CheckAndUpdate(ds.Fields[i+1],lDateModif) or FChanged;
             end;
          3,8,13:; // Wird in i-1 behandelt
          4: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_MarrChrchplace]) or FChanged;
          5: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_MarrChrchWitness]) or FChanged;
          6: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_MarrChrchSource]) or FChanged;
          9: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_MarrStatePlace]) or FChanged;
          10: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_MarrStateWitness]) or FChanged;
          11: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_MarrStateSource]) or FChanged;
          14: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_DivorcePlace]) or FChanged;
          15: Fchanged := CheckAndUpdate(ds.Fields[i] , data[hmar_DivorceSource]) or FChanged;
        else
        end;
      if FChanged then
        ds.Post
      else
        ds.Cancel;
    end;
end;

function THejMarrData.Equals(aValue: THejMarrData; OnlyData: boolean): boolean;
var
  I: TEnumHejMarrDatafields;
begin
   Result := true;
   for I in TEnumHejMarrDatafields do
     if (ord(I) >  ord(hmar_id)) and (not OnlyData or (ord(I) >  ord(hmar_idSpouse))) then
       Result := Result and (Data[I] = aValue.Data[I]);
end;

end.

