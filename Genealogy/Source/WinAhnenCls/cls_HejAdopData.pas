/// <summary>
/// Unit for managing adoption data in the genealogy application.
/// </summary>
/// <remarks>
/// This unit provides data structures and classes for storing and manipulating
/// adoption information, including relationships between adopted children and
/// their adoptive parents. It supports stream-based serialization and database
/// integration.
/// </remarks>
unit cls_HejAdopData;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,variants,db, cls_HejBase;

type
  /// <summary>
  /// Enumeration of field identifiers for adoption data records.
  /// </summary>
  /// <remarks>
  /// Used to access specific fields in THejAdopData records through the Data property.
  /// </remarks>
  TEnumHejAdopDatafields=(
    /// <summary>Record ID field (-1 for internal use)</summary>
    hadop_ID=-1,
    /// <summary>ID of the adopted person</summary>
    hadop_idPerson =0,
    /// <summary>ID of the adoptive father</summary>
    hadop_idFather =1,
    /// <summary>ID of the adoptive mother</summary>
    hadop_idMother =2);

  /// <summary>
  /// Set type for field selection (currently unused in this unit).
  /// </summary>
  TMarrFieldSset=set of byte;

const
  /// <summary>
  /// Array containing string descriptions for each adoption data field.
  /// </summary>
  /// <remarks>
  /// Maps TEnumHejAdopDatafields enumeration values to their string representations
  /// for display and serialization purposes.
  /// </remarks>
  CHejAdopDataDesc:array[TEnumHejAdopDatafields]of string=
    ('ID',
    'idPerson',
    'idFather_adop',
    'idMother_adop');

type


 /// <summary>
 /// Pointer type to THejAdopData record.
 /// </summary>
 PHejAdopData = ^THejAdopData;

 { THejAdopData }

 /// <summary>
 /// Record structure for storing adoption data.
 /// </summary>
 /// <remarks>
 /// This packed record stores information about adoption relationships including
 /// the adopted person and their adoptive parents. Supports serialization to/from
 /// streams and datasets, and provides indexed access to fields through the Data property.
 /// </remarks>
 THejAdopData = packed record
private
  /// <summary>
  /// Gets the value of a specific field by its enumeration identifier.
  /// </summary>
  /// <param name="idx">Field identifier from TEnumHejAdopDatafields</param>
  /// <returns>Variant containing the field value, or Null if field is invalid</returns>
  function GetData(idx: TEnumHejAdopDatafields): Variant;
  /// <summary>
  /// Sets the value of a specific field by its enumeration identifier.
  /// </summary>
  /// <param name="idx">Field identifier from TEnumHejAdopDatafields</param>
  /// <param name="AValue">New value to assign to the field</param>
  procedure SetData(idx: TEnumHejAdopDatafields; AValue: Variant);
public
  /// <summary>
  /// Converts the adoption data to a human-readable string representation.
  /// </summary>
  /// <returns>String showing person ID and adoptive parent IDs if non-zero</returns>
  function toString:String;
  /// <summary>
  /// Converts the adoption data to a Pascal record structure format.
  /// </summary>
  /// <returns>String representing the data in Pascal record syntax</returns>
  function ToPasStruct:String;
  /// <summary>
  /// Clears all data fields, resetting integers to 0 and strings to empty.
  /// </summary>
  Procedure Clear;
  /// <summary>
  /// Tests if a stream contains the expected adoption data header.
  /// </summary>
  /// <param name="st">Stream to test for the header</param>
  /// <returns>True if the stream contains a valid 'adop' header, False otherwise</returns>
  /// <remarks>Stream position is restored if header is not found</remarks>
  class function TestStreamHeader(const st: TStream): boolean;static;
  /// <summary>
  /// Reads adoption data from a stream in the application's custom format.
  /// </summary>
  /// <param name="st">Stream containing the adoption data</param>
  /// <remarks>Handles encoding conversion from ANSI to UTF-8</remarks>
  Procedure ReadFromStream(const st:TStream);
  /// <summary>
  /// Writes adoption data to a stream in the application's custom format.
  /// </summary>
  /// <param name="st">Stream to write the adoption data to</param>
  /// <remarks>Handles encoding conversion from UTF-8 to ANSI</remarks>
  Procedure WriteToStream(const st:TStream);
  /// <summary>
  /// Reads adoption data from a dataset record.
  /// </summary>
  /// <param name="idx">Index/ID to locate in the dataset</param>
  /// <param name="ds">Dataset containing the adoption data</param>
  Procedure ReadFromDataset(idx:integer;const ds:TDataSet);
  /// <summary>
  /// Updates or inserts the adoption data into a dataset.
  /// </summary>
  /// <param name="ds">Dataset to update with the adoption data</param>
  /// <remarks>Will edit existing record or append new record as needed. Changes are posted only if data differs</remarks>
  Procedure UpdateDataset(const ds:TDataSet);
  /// <summary>
  /// Compares this adoption data record with another for equality.
  /// </summary>
  /// <param name="aValue">Another THejAdopData record to compare with</param>
  /// <returns>True if all fields (except ID) are equal, False otherwise</returns>
  function Equals(aValue:THejAdopData):boolean;
    /// <summary>
    /// Indexed property for accessing adoption data fields by enumeration.
    /// </summary>
    /// <param name="idx">Field identifier from TEnumHejAdopDatafields</param>
    property Data[idx:TEnumHejAdopDatafields]:Variant read GetData write SetData;
 public
       /// <summary>Internal record ID</summary>
       ID,
       /// <summary>ID of the adopted person</summary>
       idPerson,
       /// <summary>ID of the adoptive father (0 if not applicable)</summary>
       idFather_adop,
       /// <summary>ID of the adoptive mother (0 if not applicable)</summary>
       idMother_adop:integer;
 end;

 { TClsHejData }

 { TClsHejAdoptions }

 /// <summary>
 /// Class for managing a collection of adoption records.
 /// </summary>
 /// <remarks>
 /// Inherits from TClsHejBase and provides functionality to store, retrieve,
 /// and manipulate multiple adoption records. Supports stream-based serialization
 /// and array-based storage with dynamic sizing.
 /// </remarks>
 TClsHejAdoptions=class(TClsHejBase)
 private
    /// <summary>Dynamic array storing all adoption records</summary>
    FAdopArray:array of THejAdopData;
    /// <summary>Index of the currently active adoption record</summary>
    FActIndex:integer;
    /// <summary>
    /// Gets the currently active adoption record.
    /// </summary>
    /// <returns>The adoption record at the current index</returns>
    function GetActualAdop: THejAdopData;
    /// <summary>
    /// Gets a specific adoption record by index.
    /// </summary>
    /// <param name="index">Index of the adoption record to retrieve</param>
    /// <returns>The adoption record at the specified index</returns>
    function GetAdoption(index: integer): THejAdopData;
    /// <summary>
    /// Sets the currently active adoption record.
    /// </summary>
    /// <param name="AValue">New adoption data to set as the current record</param>
    procedure SetActualAdop(AValue: THejAdopData);
 protected
    /// <summary>
    /// Gets the count of adoption records in the collection.
    /// </summary>
    /// <returns>Number of adoption records stored</returns>
    function GetCount: integer;override;
 public
    /// <summary>
    /// Gets a data field value from a specific adoption record.
    /// </summary>
    /// <param name="ind">Index of the adoption record (-1 for current record)</param>
    /// <param name="idx">Field identifier</param>
    /// <returns>Variant containing the field value</returns>
    function GetData(ind: integer; idx: TEnumHejAdopDatafields): variant;
    /// <summary>
    /// Sets a data field value in a specific adoption record.
    /// </summary>
    /// <param name="ind">Index of the adoption record (-1 for current record)</param>
    /// <param name="idx">Field identifier</param>
    /// <param name="AValue">New value to set</param>
    procedure SetData(ind: integer; idx: TEnumHejAdopDatafields; AValue: variant
      );
    /// <summary>
    /// Replaces all occurrences of a person ID with a new ID.
    /// </summary>
    /// <param name="aInd">Old person ID to replace</param>
    /// <param name="aInd2">New person ID to use</param>
    /// <remarks>Updates person, father, and mother IDs in all adoption records</remarks>
    PRocedure ReplacePerson(aInd,aInd2:integer);
    /// <summary>
    /// Property to access adoption records by index.
    /// </summary>
    /// <param name="index">Index of the adoption record</param>
    Property Adoption[index:integer]:THejAdopData read GetAdoption;
    /// <summary>
    /// Property to get or set the currently active adoption record.
    /// </summary>
    Property ActualAdop:THejAdopData read GetActualAdop write SetActualAdop;
    /// <summary>
    /// Default indexed property for accessing adoption data fields.
    /// </summary>
    /// <param name="ind">Index of the adoption record (-1 for current)</param>
    /// <param name="idx">Field identifier</param>
    Property Data[ind:integer;idx:TEnumHejAdopDatafields]:variant read GetData write SetData;default;
 public
    /// <summary>
    /// Tests if a stream contains the expected adoption data header.
    /// </summary>
    /// <param name="st">Stream to test</param>
    /// <returns>True if the stream contains a valid adoption header</returns>
    Function TestStreamHeader(st:Tstream):boolean;override;
    /// <summary>
    /// Finds the index of an adoption record by person ID.
    /// </summary>
    /// <param name="Krit">Person ID to search for</param>
    /// <returns>Index of the adoption record, or -1 if not found</returns>
    function IndexOf(Krit: variant): integer; override;
    /// <summary>
    /// Clears all adoption records from the collection.
    /// </summary>
    Procedure Clear;Override;
    /// <summary>
    /// Appends a new empty adoption record to the collection.
    /// </summary>
    /// <param name="Sender">Optional sender object (not used)</param>
    Procedure Append(Sender:TObject=nil);
    /// <summary>
    /// Reads multiple adoption records from a stream.
    /// </summary>
    /// <param name="st">Stream containing the adoption data</param>
    /// <param name="cls">Optional base class parameter (not used)</param>
    procedure ReadfromStream(st: Tstream; {%H-}cls: TClsHejBase=nil); override;
    /// <summary>
    /// Writes all adoption records to a stream.
    /// </summary>
    /// <param name="st">Stream to write the adoption data to</param>
    PRocedure WriteToStream(st:TStream);override;
    /// <summary>
    /// Destructor that cleans up the adoption array.
    /// </summary>
    Destructor Destroy; override;
 end;

implementation

uses dateutils,LConvEncoding,dm_GenData2;
{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

{ TClsHejAdoptions }

/// <summary>
/// Implementation of TClsHejAdoptions methods
/// </summary>

procedure TClsHejAdoptions.SetActualAdop(AValue: THejAdopData);
begin
  if FAdopArray[FActIndex].Equals(AValue) then Exit;
    FAdopArray[FActIndex]:=AValue;
end;

procedure TClsHejAdoptions.SetData(ind: integer; idx: TEnumHejAdopDatafields;
  AValue: variant);

begin
  /// Use current index if ind is -1
  if ind=-1 then
    ind:=FActIndex;
  if  (ind >=0) and (ind <= high(FAdopArray)) then
    FAdopArray[ind].Data[idx] := AValue;
end;

procedure TClsHejAdoptions.ReplacePerson(aInd, aInd2: integer);
var
  i: Integer;
begin
  /// Iterate through all adoption records and replace matching IDs
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
  /// Verify stream header before reading
  if not TestStreamHeader(st) then
    exit;
  /// Read adoption records until no more numeric indicators found
  repeat
  by:=st.ReadByte;
  st.Seek(-1,soCurrent);
  /// Bytes 49-57 are ASCII '1'-'9', indicating data records
  if by in [49..57] then
    begin
      inc(lAdopCount);
      /// Dynamically grow array in chunks for efficiency
      if lAdopCount> length(FAdopArray) then
        setlength(FAdopArray,length(FAdopArray)+cDSIncr);
      FAdopArray[lAdopCount-1].ReadFromStream(st);
      FAdopArray[lAdopCount-1].ID := lAdopCount-1;
    end;
  until not(by in [49..57]);
  /// Trim array to actual size
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

/// <summary>
/// Implementation of THejAdopData methods
/// </summary>

function THejAdopData.GetData(idx: TEnumHejAdopDatafields): Variant;
begin
  /// Map enumeration values to record fields
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

class function THejAdopData.TestStreamHeader(const st: TStream): boolean;

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
  /// Read stream byte by byte until newline or end of stream
  while (by <> 10) and (st.Position <st.Size) do
     begin
       by := st.ReadByte;
       /// Bytes >= 32 are printable characters
       if by >=32 then
          lActStr := lActStr+char(by)
       else
         /// Handle field delimiters and line endings
         if by in [10,15] then
           begin
             /// Break if 'ortv' marker found (next section)
             if (lAktField = 0) and (lActStr='ortv') then
               break;
             /// Convert encoding and store field value
             data[TEnumHejAdopDatafields(lAktField)] := ConvertEncoding(lActStr,EncodingAnsi,EncodingUTF8);
             if by = 15 then

                 inc(lAktField);

             lActStr:='';
           end
        /// Byte 16 represents embedded line breaks
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

  /// <summary>
  /// Helper function to check if field needs updating and update it if different.
  /// </summary>
  /// <param name="vDest">Destination field in dataset</param>
  /// <param name="vSource">Source value to compare and set</param>
  /// <returns>True if value was different and updated, False otherwise</returns>
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
      /// Edit existing record or append new one
      if ds.Locate(ds.Fields[0].Name,ID,[]) then
        ds.Edit
      else
        begin
        ds.Append;
         Fchanged :=true;
         ds.Fields[0].AsInteger := ID;
        end;
      /// Update fields and track if any changes were made
      for i := 0 to ds.FieldCount-1 do
        case i of
          0..2 : Fchanged := CheckandUpdate(ds.Fields[i],Data[TEnumHejAdopDatafields(i-1)]) or Fchanged ;
        else
        end;
      /// Only post if data actually changed
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

