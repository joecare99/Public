unit cls_HejSourceData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db, cls_HejBase;

type
  TEnumHejSourDatafields=(
    hsour_ID=-1,
    hsour_Title =0,
    hsour_Abk =1,
    hsour_Ereign=2,
    hsour_Von=3,
    hsour_Bis=4,
    hsour_Standort=5,
    hsour_Publ=6,
    hsour_Rep=7,
    hsour_Bem=8,
    hsour_Bestand=9,
    hsour_Med=10);

  TMarrFieldSset=set of byte;

const
  CHejSourDataDesc:array[TEnumHejSourDatafields]of string=
    ('ID',
    'Title',
    'Abk',
    'Ereignisse',
    'Von',
    'Bis',
    'Standort',
    'Publ',
    'Rep',
    'Bem',
    'Bestand',
    'Med');

type


 PHejSourData = ^THejSourData;

 { THejSourData }
 THejSourData = packed record
private
  function GetData(idx: TEnumHejSourDatafields): Variant;
  procedure SetData(idx: TEnumHejSourDatafields; AValue: Variant);
public
  function toString:String;
   function ToPasStruct: String;
  Procedure Clear;
  function TestStreamHeader(const st: TStream): boolean;
  Procedure ReadFromStream(const st:TStream);
  Procedure WriteToStream(const st:TStream);
  Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
  Procedure UpdateDataset(const ds:TDataSet);
  function Equals(aValue:THejSourData):boolean;
    property Data[idx:TEnumHejSourDatafields]:Variant read GetData write SetData;
 public
       ID:integer;
       Title,
       Abk,
       Ereignisse,
       Von,
       Bis,
       Standort,
       Publ,
       Rep,
       Bem,
       Bestand,
       Med:string;
 end;

 { TClsHejSources }

 TClsHejSources=class(TClsHejBase)
 private
    FSourArray:array of THejSourData;
    FActIndex:integer;
    function GetActualSour: THejSourData;
    function GetData(ind: integer; idx: TEnumHejSourDatafields): variant;
    function GetSource(index: integer): THejSourData;
    procedure SetActualSour(AValue: THejSourData);
    procedure SetData(ind: integer; idx: TEnumHejSourDatafields; AValue: variant
      );
 protected
    function GetCount: integer;override;
 public
    Property Source[index:integer]:THejSourData read GetSource;
    Property ActualSour:THejSourData read GetActualSour write SetActualSour;
    Property Data[ind:integer;idx:TEnumHejSourDatafields]:variant read GetData write SetData;default;
 public
    Function TestStreamHeader(st:Tstream):boolean;override;
    Procedure Clear;override;
    Procedure SetSource(aSource:THejSourData);overload;
    Function NewSource(aSource:String):integer;
    Function IndexOf(aSourceTitle:variant):integer;override;
    procedure ReadfromStream(st: Tstream; {%H-}cls: TClsHejBase=nil); override;
    PRocedure WriteToStream(st:TStream);override;
    Destructor Destroy; override;
 end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;

{ TClsHejSources }

procedure TClsHejSources.SetActualSour(AValue: THejSourData);
begin
  if FSourArray[FActIndex].Equals(AValue) then Exit;
    FSourArray[FActIndex]:=AValue;
end;

procedure TClsHejSources.SetData(ind: integer; idx: TEnumHejSourDatafields;
  AValue: variant);

begin
  if (ind <> FActIndex) and (ind >=0) and (ind <= high(FSourArray)) then
    FActIndex := ind;
  if FActIndex = ind then
    FSourArray[FActIndex].Data[idx] := AValue;
end;

function TClsHejSources.TestStreamHeader(st: Tstream): boolean;
begin
   result := THejSourData.TestStreamHeader(st);
end;

procedure TClsHejSources.Clear;
begin
  setlength(FSourArray,0)
end;

procedure TClsHejSources.SetSource(aSource: THejSourData);
var
  lSrc: Integer;
begin
  // Search Places
  lSrc := IndexOf(aSource.Title);
  if lSrc =-1 then
    begin
      setlength(FSourArray,length(FSourArray)+1);
      lSrc:=high(FSourArray);
      FActIndex:=lSrc;
    end;
  FSourArray[lSrc] := aSource;
  FSourArray[lSrc].ID := lSrc;
end;

function TClsHejSources.NewSource(aSource: String): integer;
begin
   setlength(FSourArray,high(FSourArray)+2);
   FActIndex:=high(FSourArray);
   FSourArray[FActIndex].Title:=aSource;
   FSourArray[FActIndex].id:=FActIndex;
   result := FActIndex;
end;

function TClsHejSources.IndexOf(aSourceTitle: variant): integer;
var
  i: Integer;
begin
  // Todo: Better Algorithm
  result := -1;
  for i := 0 to high(FSourArray) do
    if FSourArray[i].Title = aSourceTitle then
      exit(i);
end;

procedure TClsHejSources.ReadfromStream(st: Tstream; cls: TClsHejBase);
const cDSIncr=100;
var
  lSourceCount:integer;
begin
  lSourceCount := 0;
   if not TestStreamHeader(st) then
     exit;
  while st.Position<st.Size do
    begin
      inc(lSourceCount);
      if lSourceCount> length(FSourArray) then
        setlength(FSourArray,length(FSourArray)+cDSIncr);
      FSourArray[lSourceCount-1].ReadFromStream(st);
      FSourArray[lSourceCount-1].ID := lSourceCount-1;
    end;
  setlength(FSourArray,lSourceCount);
end;

procedure TClsHejSources.WriteToStream(st: TStream);
const cHdr:array[0..7] of char = 'quellv'#13#10;
var
  i: Integer;
begin
  st.Write(cHdr,length(cHdr));
  for i := 0 to high(FSourArray) do
    FSourArray[i].WriteToStream(st);
end;

destructor TClsHejSources.Destroy;
begin
  setlength(FSourArray,0);
  inherited Destroy;
end;

function TClsHejSources.GetActualSour: THejSourData;
begin
  result := FSourArray[FActIndex];
end;

function TClsHejSources.GetCount: integer;
begin
  result := length(FSourArray)
end;

function TClsHejSources.GetData(ind: integer; idx: TEnumHejSourDatafields
  ): variant;
begin
  if (ind >= 0) and (ind <= high(FSourArray)) then
    result := FSourArray[ind].Data[idx];
end;

function TClsHejSources.GetSource(index: integer): THejSourData;
begin
  if (index>=0) and (index <=high(FSourArray)) then
    result := FSourArray[index];
end;

{ TClsHejData }

function THejSourData.GetData(idx: TEnumHejSourDatafields): Variant;
begin
  case idx of
    hsour_ID: Result := ID ;
    hsour_Title: Result := Title ;
    hsour_Abk: Result := Abk ;
    hsour_Ereign: Result := Ereignisse ;
    hsour_Von: Result := Von ;
    hsour_Bis: Result := Bis ;
    hsour_Standort: Result := Standort ;
    hsour_Publ: Result := Publ ;
    hsour_Rep: Result := Rep ;
    hsour_Bem: Result := Bem ;
    hsour_Bestand: Result := Bestand ;
    hsour_Med: Result := Med ;
  else
    result := Null;
  end;
end;

procedure THejSourData.SetData(idx: TEnumHejSourDatafields; AValue: Variant);
begin
    case idx of
      hsour_ID: ID := AValue ;
      hsour_Title: Title := AValue ;
      hsour_Abk: Abk := AValue ;
      hsour_Ereign: Ereignisse := AValue ;
      hsour_Von: Von := AValue ;
      hsour_Bis: Bis := AValue ;
      hsour_Standort: Standort := AValue ;
      hsour_Publ: Publ := AValue ;
      hsour_Rep: Rep := AValue ;
      hsour_Bem: Bem := AValue ;
      hsour_Bestand: Bestand := AValue ;
      hsour_Med: Med := AValue ;
    end;
end;

function THejSourData.toString: String;
begin
   Result := Title;
end;

function THejSourData.ToPasStruct: String;
var
  lFld: TEnumHejSourDatafields;
begin
   result := '(';
  for lFld in TEnumHejSourDatafields do
    begin
      if  lFld <> hsour_ID then
        result := result+';';
     if lFld <=hsour_ID then
       result :=result+ CHejSourDataDesc[lFld]+':'+inttostr(Data[lFld])
     else
       result :=result+ CHejSourDataDesc[lFld]+':'''+Data[lFld]+''''
    end;
  result := result+'{%H-})';
end;

procedure THejSourData.Clear;
var
  I: TEnumHejSourDatafields;
begin
    for I in TEnumHejSourDatafields do
      if ord(I) <=  ord(hsour_ID) then
        Data[I]:=0
      else
        Data[I]:='';
end;

function THejSourData.TestStreamHeader(const st: TStream): boolean;

  var Hdr:array[0..7]of char;
  begin
    st.ReadBuffer(Hdr{%H-},Length(Hdr));
    result:= Hdr='quellv'#13#10;
    if not result then
      st.Seek(-length(Hdr),soCurrent);
end;


procedure THejSourData.ReadFromStream(const st: TStream);
var
  by: Byte;
  lAktField: Integer;
  lActStr: String;
begin
  by := 0 ;
  lAktField :=0;
  ID := -1;
  lActStr := '';
  while (by <> 10) and (st.Position <st.Size) do
     begin
       by := st.ReadByte;
       if by >=32 then
          lActStr := lActStr+char(by)
       else
         if by in [10,15] then
           begin
             data[TEnumHejSourDatafields(lAktField)] := ConvertEncoding(lActStr,EncodingAnsi,EncodingUTF8);
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

procedure THejSourData.WriteToStream(const st: TStream);
var
  lActStr: String;
  lAktfield: TEnumHejSourDatafields;

begin
  for lAktfield in TEnumHejSourDatafields do
    if (lAktField <> hsour_ID) then
     begin
       lActStr := ConvertEncoding(data[lAktField],EncodingUTF8,EncodingAnsi);
       lActStr :=StringReplace(lActStr,#15,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,#16,#32,[rfReplaceAll]);
       lActStr :=StringReplace(lActStr,LineEnding,#16,[rfReplaceAll]);
       if (lAktField <> hsour_Title) then
           st.WriteByte(15);
       if length(lActStr) >0 then
         st.WriteBuffer(lActStr[1],length(lActStr));
     end;
  st.WriteBuffer(LineEnding[1],length(LineEnding));
end;

procedure THejSourData.ReadFromDataset(idx: integer; const ds: TDataSet);

var
   i: Integer;
begin
  if ds.Active then
    begin
      ds.Locate(ds.Fields[0].Name,idx,[]);
      for i := 0 to ds.FieldCount-1 do
        Data[TEnumHejSourDatafields(i-1)]:=ds.Fields[i].AsVariant;
    end;
end;

procedure THejSourData.UpdateDataset(const ds: TDataSet);
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
         Fchanged := CheckandUpdate(ds.Fields[i],Data[TEnumHejSourDatafields(i-1)]) or Fchanged ;

      if FChanged then
        ds.Post
      else
        ds.Cancel;
    end;
end;

function THejSourData.Equals(aValue: THejSourData): boolean;
var
  I: TEnumHejSourDatafields;
begin
   Result := true;
   for I in TEnumHejSourDatafields do
     if ord(I) >  ord(hsour_ID) then
       Result := Result and (Data[I] = aValue.Data[I]);
end;


end.

