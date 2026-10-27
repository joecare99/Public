unit DeDeClasses;
//////////////////////////
// Last Change: 03.X.2001
//////////////////////////

interface

uses Classes, DeDeConstants;

type
  DWORD = LongWord;

const
      DATA_FOR_PE_HEADER_OFFSET = $3C;
      PE_HEADER_SIZE = $F8;
      MAX_PE_PLUS_DELTA = $F;

Type TPEObjectBuffer = array [1..40] of Byte;


Type TPaternQuery = Class(TObject)
       public
         buffer : Array of Byte;
         mask   : Array of Boolean;
         size   : LongInt;
         procedure SetPattern(AsPattern : String);
         procedure SetString(AsString : String);
         function GetPattern : String;
         function GetByte(Index : LongInt) : Integer;
     End;

Type THeaderType = (htNone,htDFM);     

Type TPEStream = Class (TMemoryStream)
       protected
         FlBackupPos : Longint;
       public
         procedure ReadBufferA(var buffer : array of byte; size : Dword);
         function ReadStringA(Size: DWORD): string;
         procedure WriteBufferA(var buffer : array of byte; size : Dword);
         function ReadByte : Byte;
         function ReadWord : Word;
         function ReadDWord : DWord;
         function ReadByteA : Byte;
         function ReadWordA : Word;
         function ReadDWordA : DWord;
         function ReadWordF : Word;
         function ReadDWordF : DWord;
         function ReadWordFA : Word;
         function ReadDWordFA : DWord;
         function PatternMach(APattern : TPaternQuery) : Boolean;
         procedure DumpCodeToFile(FromO,ToO : DWORD; sFileName : String; HT : THeaderType);
         procedure BeginSearch;
         procedure EndSearch;
     End;

Type ThePEFile = Class(TObject)
       protected
          Stream : TPEStream;
       public
          sFileName : String;
          constructor Create(AsFileName : String);
          destructor Destroy; override;
          procedure Seek(Offset : DWord);
          procedure Read(var b1,b2,b3,b4 : Byte); overload;
          procedure Read(var b1,b2 : Byte); overload;
          procedure Read(var b1 : Byte); overload;
          procedure Write(b : Byte);
          function FilePos : Integer;
          function FileSize : Integer;
          property PEStream : TPEStream read Stream;
     End;

Type TPEObject = object
       DATA: TPEObjectBuffer;
       OBJECT_NAME : String;
       VIRTUAL_SIZE, RVA, PHYSICAL_OFFSET,
       PHYSICAL_SIZE, FLAGS : DWORD;
       PointerToRelocations,PointerToLinenumbers,
       NumberOfRelocations,NumberOfLinenumbers : DWORD;
       InfoAddress : DWORD;
       Procedure Process;
       Function DecodeFlags(AdwFlags : DWORD) : String;
       Procedure MakeBuffer;
     End;

Type TPEHeaderBuffer = array [1..PE_HEADER_SIZE+MAX_PE_PLUS_DELTA] of Byte;


  TPEHeader = class (TObject)
  protected
    Procedure Process(PFile: ThePEFile);
    Procedure ProcessObjects;
  public
    ELFDumped : Boolean;
    //DATA : TPEHeaderBuffer;
    PEPlusDelta : DWORD;
    PEHeaderOffset : DWORD;

    Signature : String;
    CPU : String;
    ObjectNum : Word;
    TimeStamp : DWORD;
    SymTblOffset : DWORD;
    SymNum : Word;
    OptionalPEType : String;
    NT_HDR_SIZE : Word;
    FLAGS : Array [1..16] of Boolean;
    wFlags : DWORD;
    LMAJOR_MINOR : String;
    SizeOfCode : DWORD;
    SizeOfInitializedData : DWORD;
    SizeOfUninitializedData : DWORD;
    RVA_ENTRYPOINT : DWORD;
    BaseOfCode,BaseOfData : DWORD;
    IMAGE_BASE: DWORD;
    OBJECT_ALIGN, FILE_ALIGN : DWORD;
    OSMAJOR_MINOR : DWORD;
    USERMAJOR_MINOR : DWORD;
    SUBSYSMAJOR_MINOR : DWORD;
    IMAGE_SIZE, HEADER_SIZE, FILE_CHECKSUM  : DWORD;
    SUBSYSTEM : String;
    DLL_FLAGS : String;
    STACK_RESERVE_SIZE, STACK_COMMIT_SIZE : DWORD;
    HEAP_RESERVE_SIZE, HEAP_COMMIT_SIZE : DWORD;
    LoaderFlags : DWORD;
    VA_ARRAY_SIZE : DWORD;

    EXPORT_TABLE_RVA, TOTAL_EXPORT_DATA_SIZE,
    IMPORT_TABLE_RVA, TOTAL_IMPORT_DATA_SIZE,
    RESOURCE_TABLE_RVA, TOTAL_RESOURCE_DATA_SIZE,
    EXCEPTION_TABLE_RVA, TOTAL_EXCEPTION_DATA_SIZE,
    SECURITY_TABLE_RVA, TOTAL_SECURITY_DATA_SIZE : DWORD;
    FIXUP_TABLE_RVA, TOTAL_FIXUP_DATA_SIZE,
    DEBUG_TABLE_RVA, TOTAL_DEBUG_DIRECTORIES,
    IMAGE_DESCRIPTION_RVA, TOTAL_DESCRIPTION_SIZE,
    MACHINE_SPECIFIC_RVA, MACHINE_SPECIFIC_SIZE,
    THREAD_LOCAL_STORAGE_RVA, TOTAL_TLS_SIZE : DWORD;
    Load_Config_Table_RVA, Load_Config_Table_Size : DWORD;
    Bound_Import_RVA, Bound_Import_Size : DWORD;
    IAT_RVA, IAT_Size : DWORD;
    Delay_Import_Descriptor_RVA, Delay_Import_Descriptor_Size : DWORD;
    COM_Runtime_Header_RVA, COM_Runtime_Header_Size : DWORD;
    Objects : Array [1..50] of TPEObject;

    Procedure Dump(PFile : ThePEFile);
    Procedure DumpELFFile(PFile : ThePEFile);
    Function GetPEObjectData(AsRVA : String; Var AiOffset, AiSize : LongInt) : Boolean;
    Function GetSectionIndex(AsSect : String) : Integer;
    Function GetSectionIndexByRVA(RVA: DWORD): Integer;
    Function GetSectionIndexEx(AsSect : String) : Integer;
    Destructor Destroy; override;
  End;

Type TResDirEntry = Record
       NAME_RVA, INTEGER_ID,
       DATA_ENTRY_RVA, SUBDIR_RVA : Word;
     End;


Type TPEResDirEntry = Object
       FLAGS, NameEntry, IDEntry : LongInt;
       DateTimeStamp : String;
       Version : String;
       Count : Integer;
       Entries : Array of TResDirEntry;
     End;

Type TPEResDir = Object
        DATA : Array of Byte;
        DirEntry : Array of TPEResDirEntry;
        Procedure Process;
     End;

Type TFixupBlockData = Record
        Offset, Size : DWORD;
     End;

Type TPEFixupTable = Object
       FileName : String;
       BlocksCount : Word;
       DATA : Array of TFixupBlockData;
       Procedure CollectInfo(ABaseOffset,ASize : DWord);
       Procedure GetData(AiBlock : Word; AList : TStrings);
     End;

Type TPEImportData = Object
       FileName : String;
       DLLCount, ProcCount : Integer;
       Procedure CollectInfo(APhysOffset,RVA : DWord;
         AList : TStrings); overload;
       Procedure CollectInfo(AFile: ThePEFile; APhysOffset,RVA : DWord;
         AList : TStrings); overload;
     End;


Type TPETLSTable = Object
       FileName : String;
       START_DATA_BLOCK_VA,
       END_DATA_BLOCK_VA,
       INDEX_VA, CALLBACK_TABLE_VA : String;
       Procedure Process(PhysOffset : DWORD);
     End;

Type TExportFuncData = Record
       Name : String;
       Offset : String;
       Ordinal : LongInt;
       NameAddress : DWORD;
     End;

Type TPEExports = Object
        FileName : String;
        DATE_TIME_STAMP : String;
        VERSION : String;
        Name_RVA : String;
        Ordinal_Base : LongInt;
        Address_Table_Entries, Number_of_Name_Pointers : LongInt;
        Export_Address_Table_RVA,
        Name_Pointer_RVA,
        Ordinal_Table_RVA : String;
        FUNC_DATA : Array of TExportFuncData;
        Procedure Process(AdwAddress,ARVA : DWORD);
     End;


Function HexChar(Ab : Byte) : Char;
Function _Chr(Ab : Byte) : Char;
Function Chr1(Ab : Byte) : String;

// This var must not be created or freed !!!!
// If must be assigned from Application witch
// uses this unit. This application have to
// create and destroy PEFile !!!
Var PEFile : ThePEFile;


Type TOnSeek = Procedure(dw : DWORD) of Object;


Type TRVAConverter = Object
         ImageBase : DWORD;
         PhysOffset : DWORD;
         CodeRVA : DWORD;
         function GetRVA(AsPhys : DWORD) : DWORD; overload;
         function GetPhys(AsRVA : DWORD) : DWORD; overload;
         function GetRVA(AsPhys : String) : String; overload;
         function GetPhys(AsRVA : String) : String; overload;
     End;

Type TDFMProjectUnitEntrie = record
        Characteristic : Word;
        Name : String;
     end;


Type TDFMProjectHeader = Class(TObject)
        protected
        public
          FPASList : TStringList;
          FDFMList : TStringList;
          Characteristic1,Characteristic2 : DWORD;
          ProjectName : String;
          ProjectChar : WORD;
          UnitEntriesCount : WORD;
          UnitEntries : Array  of TDFMProjectUnitEntrie;
          Procedure Dump(PEStream : TPEStream; Offset : LongInt);
          Constructor Create;
          Destructor Destroy; override;
     end;


Type TFieldRec = Class
        sName  : String;
        dwID   : DWORD;
        wFlag  : WORD;
     End;


Type TFieldData = Class
       protected
        Procedure ClearFields;
       public
        Count : Integer;
        Ptr   : DWORD;
        Fields : TList;
        Constructor Create;
        Destructor Destroy; override;
        Procedure AddField(Name : String; ID : DWORD; Flag : Word);
        Function GetFieldName(ID : DWORD) : String;
        Function GetFieldIdx(ID : DWORD) : Integer;
     End;

Type TMethodRec = Class
        sName  : String;
        dwRVA   : DWORD;
        dwVMTOffset : DWORD;
        wFlag  : WORD;
     End;

Const
  METHOD_VMT_OFFSET_NONE = $FFFFFFFF;


Type TMethodData = Class
       protected
        Procedure ClearMethods;
       public
        Count : Integer;
        Methods : TList;
        Constructor Create;
        Destructor Destroy;  override;
        Procedure AddMethod(Name : String; RVA : DWORD; Flag : Word);
        Function MethodIndexByRVA(RVA : DWORD) : Integer;
        Function ProcEntryPossible(RVA : DWORD) : Boolean;
     End;

Function GetDelphiVersion(PEFile : ThePEFile) : String; overload;
Function GetDelphiVersion(APEFile: ThePEFile; APEHeader: TPEHeader;
  AIsELF, ACBuilder, ADelphi2: Boolean): String; overload;
Function GetDelphiVersionFromImports(sFileName : String;
  lImpOffset,lImpRVA : DWORD) : String; overload;
Function GetDelphiVersionFromImports(APEFile: ThePEFile;
  APEHeader: TPEHeader; const AFileName: string): String; overload;
Function GetDelphiVersionFromImportNames(AImportNames: TStrings;
  AIsCBuilder: Boolean): String;

var    GlobAbort : Boolean;
       GlobError : String;

//BOZA       PEStream : TPEStream;
       PEHeader : TPEHeader;
       ProcRefOffsets : TStringList;
       ProcRefNames : TStringList;
       DelphiVersion : String;
       GlobCBuilder : Boolean;
       GlobDelphi2  : Boolean;

       // moved here from MainUnit
       bDebug, bUserProcs, bBSS, bELF : Boolean;

////////////////////////////////////////////////////
//    Some functions needed for IDA MAP file export
// and loading .sym file into SoftIce
////////////////////////////////////////////////////
Function DeDeStrToIDAStr(sDeDeStr : String) : String;
function GetSoftIceDir : String;
function SoftIceIsActive : Boolean;


implementation

Uses
  SysUtils, HEXTools, IniFiles, DeDeRes, DeDeELFClasses, DeDeAnsiStream,
  DeDeBinaryReader, DeDeBinaryTypes
{$IFDEF MSWINDOWS}
  , Windows, Registry
{$ENDIF}
  ;



{ TPEStream }

procedure TPEStream.BeginSearch;
begin
  FlBackupPos:=Position;
end;

procedure TPEStream.DumpCodeToFile(FromO, ToO: DWORD; sFileName: String; HT : THeaderType);
Var TmpStream : TMemoryStream;
    b : Byte;
    i : DWORD;
begin
  TmpStream:=TMemoryStream.Create;
  Try
   //Puts DFM Header
   If HT=htDFM Then For i:=0 To 15 Do TmpStream.WriteBuffer(arrDFM_HEADER[i],1);

   Try
    Seek(FromO,soFromBeginning);
    For i:=0 To ToO-FromO Do
      Begin
        b:=ReadByte;
        TmpStream.WriteBuffer(b,1);
      End;
    TmpStream.SaveToFile(sFileName);
   Except
   End;
  Finally
    TmpStream.Free;
  End;
end;

procedure TPEStream.EndSearch;
begin
   Position:=FlBackupPos;
end;

function TPEStream.PatternMach(APattern: TPaternQuery): Boolean;
var b  : Byte;
    bi : Integer;
    bMatch : Boolean;
    i : LongInt;
begin
   i:=0;
   bMatch:=True;
   While (bMatch) and (i<APattern.size) Do
    begin
     try
       ReadBuffer(b,1);
     except
       Result:=False;
       GlobAbort:=True;
       Exit;
     end;
     bi:=APattern.GetByte(i);
     bMatch:=(b=bi) or (bi=-10);
     Inc(i);
    end;

   Result:=bMatch;
end;

procedure TPEStream.ReadBufferA(var buffer: array of byte; size: Dword);
begin
   ReadBuffer(buffer,size);
   Seek(-size,soFromCurrent)
end;

function TPEStream.ReadStringA(Size: DWORD): string;
begin
  Result := DeDeAnsiStream.ReadAnsiString(Self, Integer(Size));
end;

function TPEStream.ReadByte: Byte;
var b : Byte;
begin
  ReadBuffer(b,1);
  Result:=b;
end;

function TPEStream.ReadByteA: Byte;
var b : Byte;
begin
  ReadBuffer(b,1);
  Seek(-1,soFromCurrent);
  Result:=b;
end;

function TPEStream.ReadDWord: DWord;
Var dw : DWORD;
    //b1,b2,b3,b4 : Byte;
begin
  ReadBuffer(dw,4);
  Result:=dw;
end;

function TPEStream.ReadDWordA: DWord;
var buffer : Array of Byte;
begin
  SetLength(buffer,4);
  Read(buffer,4);
  Seek(-4,soFromCurrent);
  Result:=BA2DWORD(buffer);
end;

function TPEStream.ReadDWordF: DWord;
var d : DWORD;
begin
  ReadBuffer(d,4);
  Result:=d;
end;

function TPEStream.ReadDWordFA: DWord;
var d : DWORD;
begin
  ReadBuffer(d,4);
  Seek(-4,soFromCurrent);
  Result:=d;
end;

function TPEStream.ReadWord: Word;
var buffer : Array of Byte;
begin
  SetLength(buffer,2);
  Read(buffer,2);
  Result:=BA2WORD(buffer);
end;

function TPEStream.ReadWordA: Word;
var buffer : Array of Byte;
begin
  SetLength(buffer,2);
  Read(buffer,2);
  Seek(-2,soFromCurrent);
  Result:=BA2WORD(buffer);end;

function TPEStream.ReadWordF: Word;
var w : Word;
begin
  ReadBuffer(w,2);
  Result:=w;
end;

function TPEStream.ReadWordFA: Word;
var w : Word;
begin
  ReadBuffer(w,2);
  Seek(-2,soFromCurrent);
  Result:=w;
end;

procedure TPEStream.WriteBufferA(var buffer: array of byte; size: Dword);
begin
   WriteBuffer(buffer,size);
   Seek(-size,soFromCurrent)
end;

{ TPaternQuery }

function TPaternQuery.GetByte(Index: LongInt): Integer;
begin
  If index>size then
     Result:=-1
     Else If not mask[index]
        then Result:=-10
        else Result:=buffer[index];
end;

function TPaternQuery.GetPattern: String;
var i : Integer;
begin
  Result:='';
  For i:=0 To Size-1 Do
    If mask[i] then Result:=Result+Byte2HEX(buffer[i])
               else Result:=Result+'xx';
End;

procedure TPaternQuery.SetPattern(AsPattern: String);
Var sHex : String;
    i  : Integer;
begin
  Size:=Length(AsPattern) div 2;
  SetLength(buffer,Size);
  SetLength(mask,Size);
  For i:=0 to (Length(AsPattern) div 2)-1 Do
    Begin
      sHex:=Copy(AsPattern,(i*2)+1,2);
      If AnsiUpperCase(sHex)='XX' Then
        Begin
          buffer[i]:=0;
          mask[i]:=false;
        End
        Else Begin
          buffer[i]:=HEX2Byte(sHex);
          mask[i]:=true;
        End;
    End;
end;

procedure TPaternQuery.SetString(AsString: String);
Var i  : Integer;
begin
  Size:=Length(AsString);
  SetLength(buffer,Size);
  SetLength(mask,Size);
  For i:=0 to Length(AsString)-1 Do
    Begin
      buffer[i]:=ORD(AsString[i+1]);
      mask[i]:=true;
    End;
end;

{ TRVAConverter }

function TRVAConverter.GetPhys(AsRVA: DWORD): DWORD;
begin
  Result:=AsRVA-ImageBase-CodeRVA+PhysOffset;
end;

function TRVAConverter.GetRVA(AsPhys: DWORD): DWORD;
begin
  Result:=AsPhys+ImageBase+CodeRVA-PhysOffset;
end;

function TRVAConverter.GetPhys(AsRVA: String): String;
begin
  Result:=DWORD2HEX(HEX2DWORD(AsRVA)-ImageBase-CodeRVA+PhysOffset);
end;

function TRVAConverter.GetRVA(AsPhys: String): String;
begin
  Result:=DWORD2HEX(HEX2DWORD(AsPhys)+ImageBase+CodeRVA-PhysOffset);
end;


{ TDFMProjectHeader }


constructor TDFMProjectHeader.Create;
begin
   Inherited Create;

   FPASList:=TStringList.Create;
   FDFMList:=TStringList.Create;
end;

destructor TDFMProjectHeader.Destroy;
begin
   FPASList.Free;
   FDFMList.Free;

   Inherited Destroy;
end;

procedure TDFMProjectHeader.Dump(PEStream: TPEStream; Offset: Integer);
var b1,b2,b3,b4 : Byte;
    s : String;
    c : Word;
    i,j : LongInt;
    bAddUnit : Boolean;
begin
  // Should be improved to search for system and sysconst units, and from there to
  // to get the project header, not from the compiler ident !!!!
  // Rerteive Information
  With PEStream Do
  Begin
     BeginSearch;
     Seek(Offset+iPROJECT_OFFSET-$10,soFromBeginning);
     GlobError:=err_proj_header_incorrect;
     Try
       ReadBuffer(b1,1);ReadBuffer(b2,1);ReadBuffer(b3,1);ReadBuffer(b4,1);
       Characteristic1:=b1+b2*256+(b3+b4*256)*256*256;
       ReadBuffer(b1,1);ReadBuffer(b2,1);ReadBuffer(b3,1);ReadBuffer(b4,1);
       Characteristic2:=b1+b2*256+(b3+b4*256)*256*256;
       SetLength(UnitEntries,Characteristic2);
       UnitEntriesCount:=Characteristic2-1;
       For i:=0 To UnitEntriesCount Do
        Begin
         ReadBuffer(b1,1);ReadBuffer(b2,1);
         c:=b1+b2*256;
         ReadBuffer(b1,1);
         s:='';
         While b1<>0 Do
          Begin
           s:=s+CHR(b1);
           ReadBuffer(b1,1);
          End;
         If i=0 Then
           Begin
             // Application Data
             ProjectName:=s;
             ProjectChar:=c;
           End
           Else Begin
             // Unit Data
             UnitEntries[i].Name:=s;
             UnitEntries[i].Characteristic:=c;
           End;
       End;
     Finally
       EndSearch;
     End;
  End;

   // Processing Files

   // Adding PAS files to create
   FPASList.Clear;
   FDFMList.Clear;
   GlobError:=err_invalid_unit_flag;
   For i:=1 To UnitEntriesCount Do
   If UnitEntries[i].Characteristic AND $10 = 0
   Then
   Begin
    bAddUnit:=True;
    For j:=1 To iMAX_STANDART_UNITS_COUNT Do
    If arrPROJECT_STANDART_UNITS[j]=UnitEntries[i].Name
    Then begin
    bAddUnit:=False;
    Break;
    End;
    If bAddUnit
    Then FPASList.Add(UnitEntries[i].Name+'.PAS');
   End;
end;

Function GetDelphiVersion(PEFile : ThePEFile) : String;
begin
  Result := GetDelphiVersion(PEFile, PEHeader, bELF,
    GlobCBuilder, GlobDelphi2);
end;

Function GetDelphiVersion(APEFile: ThePEFile; APEHeader: TPEHeader;
  AIsELF, ACBuilder, ADelphi2: Boolean) : String;
const
  IDS = 'TControl';
var
  PEFile: ThePEFile;
  PEHeader: TPEHeader;
  Reader: TDeDeBinaryReader;
  Delta, DW, DW1: DWORD;
  Cursor, SectionStart, SectionEnd, StringOffset, VMTFieldOffset: Int64;
  I: Integer;
  b1,b2 : Byte;
  s : String;

  function InCODE(DW : DWORD) : boolean;
  var
    CodeStart, CodeEnd: UInt64;
  begin
    CodeStart := UInt64(PEHeader.IMAGE_BASE) +
      PEHeader.Objects[1].RVA;
    CodeEnd := CodeStart + PEHeader.Objects[1].PHYSICAL_SIZE;
    Result := (UInt64(DW) > CodeStart) and (UInt64(DW) < CodeEnd);
  end;

Begin
  PEFile := APEFile;
  PEHeader := APEHeader;
  Result:='<check failed>';
  if (PEFile = nil) or (PEHeader = nil) then
    raise EArgumentNilException.Create('PE image');
  if PEHeader.ObjectNum = 0 then
    Exit;

  Delta:=PEHeader.IMAGE_BASE + (PEHeader.Objects[1].RVA) -
    PEHeader.Objects[1].PHYSICAL_OFFSET;
  SectionStart := PEHeader.Objects[1].PHYSICAL_OFFSET;
  SectionEnd := SectionStart + PEHeader.Objects[1].PHYSICAL_SIZE;
  if SectionEnd > PEFile.PEStream.Size then
    SectionEnd := PEFile.PEStream.Size;
  if SectionEnd > Int64(High(DWORD)) + 1 then
    SectionEnd := Int64(High(DWORD)) + 1;
  if SectionEnd - SectionStart < 4 then
    Exit;

  Reader := TDeDeBinaryReader.Create(PEFile.PEStream);
  try
    Cursor := SectionStart;
    while Cursor <= SectionEnd - 4 do
    begin
      DW := Reader.ReadUInt32LEAt(TPE32FileOffset(Cursor));
      if (DW - Delta) = DWORD(Cursor + 4) then
      begin
        if Cursor + 6 <= SectionEnd then
        begin
          b1 := Reader.ReadUInt8At(TPE32FileOffset(Cursor + 4));
          if b1 <= 16 then
          begin
            b2 := Reader.ReadUInt8At(TPE32FileOffset(Cursor + 5));
            StringOffset := Cursor + 6;
            if StringOffset + b2 + 4 <= SectionEnd then
            begin
              s := '';
              for I := 0 to b2 - 1 do
                s := s + Chr(Reader.ReadUInt8At(
                  TPE32FileOffset(StringOffset + I)));
              DW := Reader.ReadUInt32LEAt(
                TPE32FileOffset(StringOffset + b2));
              if InCODE(DW) then
              begin
                DW1 := DW - PEHeader.IMAGE_BASE -
                  PEHeader.Objects[1].RVA +
                  PEHeader.Objects[1].PHYSICAL_OFFSET;
                VMTFieldOffset := Int64(DW1) - 40;
                if (VMTFieldOffset >= SectionStart) and
                  (VMTFieldOffset + 4 <= SectionEnd) then
                begin
                  DW := Reader.ReadUInt32LEAt(
                    TPE32FileOffset(VMTFieldOffset));
                  if s=IDS then
                  begin
                    case DW of
              $0:
              begin
                Result:='D3';
              end;
              $B4,$114:   {cbuilder}
              begin
                if ACBuilder then
                  Result:='BCB4'
                else
                  Result:='D4';
              end;
              $120:
              begin
                if ACBuilder then
                 Result:='BCB5'
                else
                 Result:='D5';
              end;
              $138:
              begin
                if AIsELF then
                 Result:='Kylix';
              end;
              $128:
              begin
                if ACBuilder then
                  Result:='BCB6?'
                else
                  Result:='D6 CLX';
              end;

              $15C, $160:
              begin
                if ACBuilder then
                  Result:='BCB6?'
                else
                  Result:='D6';
              end;
              $2F0:
              begin
                if ACBuilder then
                  Result:='BCB6?'
                else
                  Result:='D6';
              end;
              $2F8:
              begin
                if ACBuilder then
                  Result:='BCB7'
                else
                  Result:='D7';
              end
              else
                Result:='<unknown version>';
                    end;
                    Exit;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      Inc(Cursor, 4);
    end;
  finally
    Reader.Free;
  end;

  If ADelphi2 Then Result:='D2';

End;

Function GetDelphiVersionFromImportNames(AImportNames: TStrings;
  AIsCBuilder: Boolean): String;
var
  I: Integer;
  VersionNumber: string;
  ImportName: string;

  function Matches(const AExpectedName: string): Boolean;
  begin
    ImportName := AImportNames[I];
    while (ImportName <> '') and
      (ImportName[Length(ImportName)] = #0) do
      Delete(ImportName, Length(ImportName), 1);
    Result := SameText(ImportName, AExpectedName);
  end;

begin
  Result := '';
  if AImportNames = nil then
    Exit;
  VersionNumber := '';
  for I := 0 to AImportNames.Count - 1 do
  begin
    if Matches('VCL30.bpl') or Matches('VCL30.dpl') then
      VersionNumber := '3'
    else if Matches('VCL40.bpl') or Matches('VCL40.dpl') then
      VersionNumber := '4'
    else if Matches('VCL50.bpl') or Matches('VCL50.dpl') then
      VersionNumber := '5'
    else if Matches('VCL60.bpl') or Matches('VCL60.dpl') then
      VersionNumber := '6'
    else if Matches('VCL70.bpl') or Matches('VCL70.dpl') then
      VersionNumber := '7'
    else if Matches('VCL80.bpl') or Matches('VCL80.dpl') then
      VersionNumber := '8'
    else if Matches('VCL90.bpl') or Matches('VCL90.dpl') then
      VersionNumber := '2005'
    else if Matches('VCL100.bpl') or Matches('VCL100.dpl') then
      VersionNumber := '2006'
    else if Matches('VCL110.bpl') or Matches('VCL110.dpl') then
      VersionNumber := '2007'
    else if Matches('VCL120.bpl') or Matches('VCL120.dpl') then
      VersionNumber := '2009';
    if VersionNumber <> '' then
      Break;
  end;
  if VersionNumber = '' then
    Exit;
  if AIsCBuilder then
    Result := 'BCB' + VersionNumber
  else
    Result := 'D' + VersionNumber;
end;

Function GetDelphiVersionFromImports(sFileName : String;
  lImpOffset,lImpRVA : DWORD) : String;
var PEImportData : TPEImportData;
    TmpList : TStringList;
    idx : Integer;
    s : String;
    IsCBuilder: Boolean;
Begin
  Result:='<unknown>';
  PEImportData.FileName:=sFileName;

  TmpList:=TStringList.Create;
  Try
    PEImportData.CollectInfo(lImpOffset, lImpRVA, TmpList);

    idx:=PEHeader.GetSectionIndexEx('CODE');
    if (idx < 1) or (idx > PEHeader.ObjectNum) then
      Exit;
    PEFile.PEStream.BeginSearch;
    Try
      PEFile.PEStream.Seek(PEHeader.Objects[idx].PHYSICAL_OFFSET+5,soFromBeginning);
      s := PEFile.PEStream.ReadStringA(3);
    Finally
      PEFile.PEStream.EndSearch;
    End;

    IsCBuilder := s = 'C++';
    Result := GetDelphiVersionFromImportNames(TmpList, IsCBuilder);
    if Result = '' then
      Result := 'Console';
      
  Finally
    TmpList.Free;
  End;
End;

Function GetDelphiVersionFromImports(APEFile: ThePEFile;
  APEHeader: TPEHeader; const AFileName: string): String;
var
  I, ImportSectionIndex: Integer;
  ImportOffset, ImportRVA, SectionRVA, SectionSize: DWORD;
  PreviousPEFile: ThePEFile;
  PreviousPEHeader: TPEHeader;
begin
  Result := '<unknown>';
  if (APEFile = nil) or (APEHeader = nil) then
    raise EArgumentNilException.Create('PE image');
  if APEHeader.IMPORT_TABLE_RVA = 0 then
    Exit;

  ImportRVA := APEHeader.IMPORT_TABLE_RVA;
  ImportSectionIndex := -1;
  for I := 1 to APEHeader.ObjectNum do
  begin
    SectionRVA := APEHeader.Objects[I].RVA;
    SectionSize := APEHeader.Objects[I].PHYSICAL_SIZE;
    if (ImportRVA >= SectionRVA) and
      (ImportRVA - SectionRVA < SectionSize) then
    begin
      ImportSectionIndex := I;
      Break;
    end;
  end;
  if ImportSectionIndex < 1 then
    Exit;
  ImportOffset := APEHeader.Objects[ImportSectionIndex].PHYSICAL_OFFSET +
    (ImportRVA - APEHeader.Objects[ImportSectionIndex].RVA);

  PreviousPEFile := PEFile;
  PreviousPEHeader := PEHeader;
  PEFile := APEFile;
  PEHeader := APEHeader;
  try
    Result := GetDelphiVersionFromImports(AFileName, ImportOffset,
      ImportRVA);
  finally
    PEFile := PreviousPEFile;
    PEHeader := PreviousPEHeader;
  end;
end;


{ TFieldData }

procedure TFieldData.AddField(Name : String; ID : DWORD; Flag : Word);
var Field : TFieldRec;
begin
  Field:=TFieldRec.Create;
  Field.sName:=Name;
  Field.dwID:=ID;
  Field.wFlag:=Flag;
  Fields.Add(Field);
end;

Function TFieldData.GetFieldName(ID : DWORD) : String;
var Field : TFieldRec;
    i : Integer;
begin
  Result:='';
  For i:=0 to Fields.Count-1 Do
    begin
      Field:=TFieldRec(Fields[i]);
      if Field.dwID=ID then
        begin
          Result:=Field.sName;
          Break;
        end;
    end;
end;

Function TFieldData.GetFieldIdx(ID : DWORD) : Integer;
var Field : TFieldRec;
    i : Integer;
begin
  Result:=-1;
  For i:=0 to Fields.Count-1 Do
    begin
      Field:=TFieldRec(Fields[i]);
      if Field.dwID=ID then
        begin
          Result:=i;
          Break;
        end;
    end;
end;


procedure TFieldData.ClearFields;
var i : Integer;
begin
  For i:=Fields.Count-1 downto 0 Do
     TFieldRec(Fields[i]).Free;
end;

constructor TFieldData.Create;
begin
  Inherited Create;

  Fields:=TList.Create;
end;

destructor TFieldData.Destroy;
begin
  ClearFields;
  Fields.Free;

  Inherited Destroy;
end;


{ TMethodData }

procedure TMethodData.AddMethod(Name: String; RVA: DWORD; Flag: Word);
var Field : TMethodRec;
begin
  Field:=TMethodRec.Create;
  Field.sName:=Name;
  Field.dwRVA:=RVA;
  Field.dwVMTOffset:=METHOD_VMT_OFFSET_NONE;
  Field.wFlag:=Flag;
  Methods.Add(Field);
end;

procedure TMethodData.ClearMethods;
var i : Integer;
begin
  For i:=Methods.Count-1 downto 0 Do
     TMethodRec(Methods[i]).Free;
end;

constructor TMethodData.Create;
begin
  Inherited Create;

  Methods:=TList.Create;
end;

destructor TMethodData.Destroy;
begin
  ClearMethods;
  Methods.Free;

  Inherited Destroy;
end;

function TMethodData.MethodIndexByRVA(RVA: DWORD): Integer;
var i : Integer;
begin
  For i:=0 To Methods.Count-1 Do
    If TMethodRec(Methods[i]).dwRVA=RVA Then
       Begin
         Result:=i;
         Exit;
       End;
  Result:=-1;     
end;


Function _Chr(Ab : Byte) : Char;
Begin
  If Ab=0 Then Result:='.'
     Else Result:=Chr(Ab);
End;

Function Chr1(Ab : Byte) : String;
Begin
  If Ab=0 Then Result:=''
     Else Result:=Chr(Ab);
End;

Function HexChar(Ab : Byte) : Char;
Begin
  If Ab in [32..ORD('z')]
     Then Result:=Chr(Ab)
     Else Result:='.';
End;


function TMethodData.ProcEntryPossible(RVA: DWORD): Boolean;
var i : Integer;
    dw : DWORD;
begin
  Result:=False;
  For i:=0 To Methods.Count-1 Do
    Begin
      dw:=TMethodRec(Methods[i]).dwRVA;
      If dw=RVA then
         begin
           Result:=True;
           Exit;
         end;
    End;
end;

{ TPEObject }

function TPEObject.DecodeFlags(AdwFlags: DWORD): String;
var TmpStr : String;
begin
   Result:='';
   If AdwFlags and $8>0 Then Result:=Result+txt_sect8;
   If AdwFlags and $20>0 Then Result:=Result+txt_sect20;
   If AdwFlags and $40>0 Then Result:=Result+txt_sect40;
   If AdwFlags and $80>0 Then Result:=Result+txt_sect80;
   If AdwFlags and $200>0 Then Result:=Result+txt_sect200;
   If AdwFlags and $800>0 Then Result:=Result+txt_sect800;
   If AdwFlags and $1000>0 Then Result:=Result+txt_sect1000;
   TmpStr:=DWord2Hex(AdwFlags);
   While Length(TmpStr)<8 Do TmpStr:='0'+TmpStr;
   Case TmpStr[3] of
     '1': Result:=Result+txt_align_on_a+'1-byte'+txt_boundary;
     '2': Result:=Result+txt_align_on_a+'2-byte'+txt_boundary;
     '3': Result:=Result+txt_align_on_a+'4-byte'+txt_boundary;
     '4': Result:=Result+txt_align_on_a+'8-byte'+txt_boundary;
     '5': Result:=Result+txt_align_on_a+'16-byte'+txt_boundary;
     '6': Result:=Result+txt_align_on_a+'32-byte'+txt_boundary;
     '7': Result:=Result+txt_align_on_a+'64-byte'+txt_boundary;
     '8': Result:=Result+txt_align_on_a+'128-byte'+txt_boundary;
     '9': Result:=Result+txt_align_on_a+'256-byte'+txt_boundary;
     'A': Result:=Result+txt_align_on_a+'512-byte'+txt_boundary;
     'B': Result:=Result+txt_align_on_a+'1024-byte'+txt_boundary;
     'C': Result:=Result+txt_align_on_a+'2048-byte'+txt_boundary;
     'D': Result:=Result+txt_align_on_a+'4096-byte'+txt_boundary;
     'E': Result:=Result+txt_align_on_a+'8192-byte'+txt_boundary;
   End;
   If AdwFlags and $1000000>0 Then Result:=Result+txt_sect1000000;
   If AdwFlags and $2000000>0 Then Result:=Result+txt_sect2000000;
   If AdwFlags and $4000000>0 Then Result:=Result+txt_sect4000000;
   If AdwFlags and $8000000>0 Then Result:=Result+txt_sect8000000;
   If AdwFlags and $10000000>0 Then Result:=Result+txt_sect10000000;
   If AdwFlags and $20000000>0 Then Result:=Result+txt_sect20000000;
   If AdwFlags and $40000000>0 Then Result:=Result+txt_sect40000000;
   If AdwFlags and $80000000>0 Then Result:=Result+txt_sect80000000;
end;

procedure TPEObject.MakeBuffer;
Var i : Integer;
    val : DWORD;
begin
  // adding object name
  For i:=1 To Length(OBJECT_NAME) Do
     DATA[i]:=ORD(OBJECT_NAME[i]);
  For i:=Length(OBJECT_NAME)+1 To 8 Do
     DATA[i]:=0;
  Val:=VIRTUAL_SIZE;
  DATA[9]:=Val mod 256;Val:=Val div 256;
  DATA[10]:=Val mod 256;Val:=Val div 256;
  DATA[11]:=Val mod 256;Val:=Val div 256;
  DATA[12]:=Val mod 256;
  Val:=RVA;
  DATA[13]:=Val mod 256;Val:=Val div 256;
  DATA[14]:=Val mod 256;Val:=Val div 256;
  DATA[15]:=Val mod 256;Val:=Val div 256;
  DATA[16]:=Val mod 256;
  Val:=PHYSICAL_SIZE;
  DATA[17]:=Val mod 256;Val:=Val div 256;
  DATA[18]:=Val mod 256;Val:=Val div 256;
  DATA[19]:=Val mod 256;Val:=Val div 256;
  DATA[20]:=Val mod 256;
  Val:=PHYSICAL_OFFSET;
  DATA[21]:=Val mod 256;Val:=Val div 256;
  DATA[22]:=Val mod 256;Val:=Val div 256;
  DATA[23]:=Val mod 256;Val:=Val div 256;
  DATA[24]:=Val mod 256;
  Val:=PointerToRelocations;
  DATA[25]:=Val mod 256;Val:=Val div 256;
  DATA[26]:=Val mod 256;Val:=Val div 256;
  DATA[27]:=Val mod 256;Val:=Val div 256;
  DATA[28]:=Val mod 256;
  Val:=PointerToLinenumbers;
  DATA[29]:=Val mod 256;Val:=Val div 256;
  DATA[30]:=Val mod 256;Val:=Val div 256;
  DATA[31]:=Val mod 256;Val:=Val div 256;
  DATA[32]:=Val mod 256;
  Val:= NumberOfRelocations;
  DATA[33]:=Val mod 256;Val:=Val div 256;
  DATA[34]:=Val mod 256;
  Val:=NumberOfLinenumbers;
  DATA[35]:=Val mod 256;Val:=Val div 256;
  DATA[36]:=Val mod 256;
  Val:=FLAGS;
  DATA[37]:=Val mod 256;Val:=Val div 256;
  DATA[38]:=Val mod 256;Val:=Val div 256;
  DATA[39]:=Val mod 256;Val:=Val div 256;
  DATA[40]:=Val mod 256;
end;

procedure TPEObject.Process;
begin
 // Object Table: begins from 1F8h, 40 bytes as follows:
 //*1..8   - object name
 //*12..9  - virtual size (when loaded into memory)
 //*16..13 - RVA (virtual address);
 //*20..17 - size (of raw data);
 //*24..21 - offset (pointer to raw data);
 // 28..25 - PointerToRelocations
 // 32..29 - PointerToLinenumbers
 // 34..33 - NumberOfRelocations
 // 36..35 - NumberOfLinenumbers
 //*40..37 - flags (Characteristics);
 //                                       [ name              ]
 // [virtual size ]  [RVA           ]     [ Size   ]  [ Offset]
 // [ PtrToRelocs.]  [ PtrToLinNum. ]     [NOR][NOL]  [ Flags ]
   OBJECT_NAME:=Chr1(DATA[1])+Chr1(DATA[2])+Chr1(DATA[3])+Chr1(DATA[4])
         +Chr1(DATA[5])+Chr1(DATA[6])+Chr1(DATA[7])+Chr1(DATA[8]);
   RVA:=(DATA[16]*256+DATA[15])*256*256+DATA[14]*256+DATA[13];
   PHYSICAL_OFFSET:=(DATA[24]*256+DATA[23])*256*256+DATA[22]*256+DATA[21];
   PHYSICAL_SIZE:=(DATA[20]*256+DATA[19])*256*256+DATA[18]*256+DATA[17];
   VIRTUAL_SIZE:=(DATA[12]*256+DATA[11])*256*256+DATA[10]*256+DATA[9];
   FLAGS:=(DATA[40]*256+DATA[39])*256*256+DATA[38]*256+DATA[37];

   PointerToRelocations:=(DATA[28]*256+DATA[27])*256*256+DATA[26]*256+DATA[25];
   PointerToLinenumbers:=(DATA[32]*256+DATA[31])*256*256+DATA[30]*256+DATA[29];
   NumberOfRelocations:=DATA[34]*256+DATA[33];
   NumberOfLinenumbers:=DATA[36]*256+DATA[35];
end;

{ TPEHeader }

destructor TPEHeader.Destroy;
begin

  inherited;
end;

procedure TPEHeader.Dump(PFile : ThePEFile);
var PEFile: ThePEFile;
    SignatureValue, lPEHOffset : DWORD;
    b1,b2 : Byte;
    j,k : Integer;
begin
  PEFile := PFile;
  PEFile.PEStream.Seek(0, soFromBeginning);
  PEFile.PEStream.ReadBuffer(SignatureValue, SizeOf(SignatureValue));
  if SignatureValue = ELF_MAGIC then
  begin
    DumpElfFile(PFile);
    Exit;
  end;

  ELFDumped := False;

  PEFile.PEStream.Seek(0, SoFromBeginning);
  PEFile.Seek(DATA_FOR_PE_HEADER_OFFSET);
  PEFile.Read(b1, b2);
  lPEHOffset := b1 + b2*256;

  PEHeaderOffset := lPEHOffset;

  Process(PFile);
  PEFile.Seek(PE_HEADER_SIZE + lPEHOffset + PEPlusDelta);
  For j:=1 To ObjectNum Do
  Begin
    //Objects[j]:=TPEObject.Create;
    Objects[j].InfoAddress:=PEFile.FilePos;

    Objects[j].OBJECT_NAME := PEFile.Stream.ReadStringA(8);
    For k:=1 to 8 do
    if Objects[j].OBJECT_NAME[k] = #0 then
    begin
      Objects[j].OBJECT_NAME := Copy(Objects[j].OBJECT_NAME,1,k-1);
      Break;
    end;

    PEFile.Stream.ReadBuffer(Objects[j].VIRTUAL_SIZE,4);
    PEFile.Stream.ReadBuffer(Objects[j].RVA,4);
    PEFile.Stream.ReadBuffer(Objects[j].PHYSICAL_SIZE,4);
    PEFile.Stream.ReadBuffer(Objects[j].PHYSICAL_OFFSET,4);
    PEFile.Stream.ReadBuffer(Objects[j].PointerToRelocations,4);
    PEFile.Stream.ReadBuffer(Objects[j].PointerToLinenumbers,4);
    PEFile.Stream.ReadBuffer(Objects[j].NumberOfRelocations,2);
    PEFile.Stream.ReadBuffer(Objects[j].NumberOfLinenumbers,2);
    PEFile.Stream.ReadBuffer(Objects[j].FLAGS,4);
  End;

  //ProcessObjects;
end;

procedure TPEHeader.DumpELFFile(PFile : ThePEFile);
var  PEHeader: TPEHeader;
     ElfFile : TELFFile;
     i,idx : Integer;
     tmp : TPEObject;
begin
  PEHeader := Self;
  ElfFile:=TELFFile.Create(PFile.sFileName);
  try
    ElfFile.Dump;

    PEHeader.ELFDumped:=True;
    PEHeader.Signature:='ELF';
    PEHeader.ObjectNum:=ElfFile.ELFHeader.SectionsCount;
    if PEHeader.ObjectNum>High(PEHeader.Objects) then Raise Exception.Create('Too many ELF sections!');
    //First Section is NULL
    for i:=1 to PEHeader.ObjectNum-1 do
      begin
        PEHeader.Objects[i].OBJECT_NAME:=ElfFile.ELFHeader.Sections[i].SectionName;
        PEHeader.Objects[i].VIRTUAL_SIZE:=ElfFile.ELFHeader.Sections[i].SHDR.sh_size;
        PEHeader.Objects[i].RVA:=ElfFile.ELFHeader.Sections[i].SHDR.sh_addr;
        PEHeader.Objects[i].PHYSICAL_OFFSET:=ElfFile.ELFHeader.Sections[i].SHDR.sh_offset;
        PEHeader.Objects[i].PHYSICAL_SIZE:=ElfFile.ELFHeader.Sections[i].SHDR.sh_size;;
        PEHeader.Objects[i].FLAGS:=ElfFile.ELFHeader.Sections[i].SHDR.sh_flags;
      end;
    PEHeader.RVA_ENTRYPOINT:=ElfFile.ELFHeader.ELF32HDR.e_entry;
    PEHeader.BaseOfCode:=PEHeader.GetSectionIndex('.text');
    idx:=PEHeader.GetSectionIndex('.rodata');

    //Move the class data section first
    if idx>1 then begin
      tmp:=PEHeader.Objects[idx];
      PEHeader.Objects[idx]:=PEHeader.Objects[1];
      PEHeader.Objects[1]:=tmp;
    end;

    PEHeader.IMAGE_BASE:=0;
  finally
    ElfFile.Free;
  end;
end;

function TPEHeader.GetPEObjectData(AsRVA: String; Var AiOffset,
  AiSize: Integer): Boolean;
Var i : Integer;
begin
  For i:=1 To ObjectNum Do
   Begin
     If Objects[i].RVA=Hex2DWord(AsRVA) Then Break;
   End;
 If Objects[i].RVA=Hex2DWord(AsRVA)
  Then Begin
    Result:=True;
    AiOffset:=Objects[i].PHYSICAL_OFFSET;
    AiSize:=Objects[i].PHYSICAL_SIZE;
  End
  Else Begin
    For i:=1 To ObjectNum Do
     Begin
       If Objects[i].RVA>Hex2DWord(AsRVA) Then Break;
     End;
     AiOffset:=Objects[i-1].PHYSICAL_OFFSET+(Hex2DWord(AsRVA)-Objects[i-1].RVA);
     AiSize:=-1;
     If Hex2DWORD(AsRVA)=0
      Then Result:=False
      Else Result:=True; 
  End;
end;

function TPEHeader.GetSectionIndex(AsSect: String): Integer;
Var i : Integer;
begin
//  Result:=GetSectionIndexEx(AsSect);
  Result:=-1;
  If ObjectNum=0 Then Exit;
  For i:=1 To ObjectNum Do
    If Objects[i].OBJECT_NAME=AsSect Then Break;
  If Objects[i].OBJECT_NAME=AsSect Then Result:=i;
end;

function TPEHeader.GetSectionIndexByRVA(RVA: DWORD): Integer;
Var
  PEHeader: TPEHeader;
  i : Integer;
begin
  PEHeader := Self;
  Result:=-1;
  If ObjectNum=0 Then Exit;
{  for i:=1 to PEHeader.ObjectNum Do
    If ABS(PEHeader.Objects[i].RVA-RVA)<$10 then break;

  If ABS(PEHeader.Objects[i].RVA-RVA)<$10 then Result:=i;}
  for i:=1 to PEHeader.ObjectNum Do
    If PEHeader.Objects[i].RVA=RVA then break;

  If PEHeader.Objects[i].RVA=RVA then Result:=i;

end;

function TPEHeader.GetSectionIndexEx(AsSect: String): Integer;
var i : Integer;
    RVA : DWORD;
    PEHeader: TPEHeader;
begin
  PEHeader := Self;
  Result:=-1;
  //Elf file support. The mapping is not exactly 100% :(
  if ELFDumped then begin
    if AsSect='CODE' then AsSect:='.text';
    if AsSect='DATA' then AsSect:='.data';
    if AsSect='.idata' then AsSect:='.dynsym';
    if AsSect='.rsrc' then AsSect:='borland.resdata';
    if AsSect='BSS' then AsSect:='.bss';
    Result:=GetSectionIndex(AsSect);
  end
  else begin
    if AsSect='CODE' then Result:=GetSectionIndexByRVA(self.BaseOfCode);
    if AsSect='DATA' then Result:=GetSectionIndexByRVA(self.BaseOfData);
    if AsSect='.idata' then Result:=GetSectionIndexByRVA(self.IMPORT_TABLE_RVA);
    if AsSect='.rsrc' then Result:=GetSectionIndexByRVA(self.RESOURCE_TABLE_RVA);
    if AsSect='BSS' then
      begin
        Result:=-1;
        RVA:=self.BaseOfData;
        If ObjectNum=0 Then Exit;
        // Try to find the BSS section as the first section after the data section
        // that has zero phisical length. This will not be 0 length if the file is
        // memory mirror
        for i:=1 to PEHeader.ObjectNum Do
          If (PEHeader.Objects[i].RVA>RVA) and (PEHeader.Objects[i].PHYSICAL_SIZE=0) then break;

        If (PEHeader.Objects[i].RVA>RVA) and (PEHeader.Objects[i].PHYSICAL_SIZE=0) then Result:=i;
        if Result<>-1 then exit;

        //now return it as the 3-th section
        Result:=3;
      end;
   end;
end;


procedure TPEHeader.Process(PFile: ThePEFile);
var
  PEFile: ThePEFile;
  wCPU,wSubSys, wDLL, wOptionalPEType : Word;
  lPEHOffset : Word;
  b1,b2 : Byte;
begin
  PEFile := PFile;
  // PE Header:

  PEFile.PEStream.Seek(DATA_FOR_PE_HEADER_OFFSET,soFromBeginning);
  PEFile.PEStream.ReadBuffer(lPEHOffset,2);
  PEFile.PEStream.Seek(lPEHOffset,soFromBeginning);

  {REAL PE HEADER}
  Signature := PEFile.PEStream.ReadStringA(4);
  If Copy(Signature,1,2)<>'PE' Then
    Raise Exception.Create(err_bad_signature+Copy(Signature,1,2)+#13#10+err_d1_not_supported);

  PEFile.PEStream.ReadBuffer(wCPU,2);
  Case wCPU of
       0: CPU:='unknown';
    $184: CPU:='Alpha AXP';
    $1c0: CPU:='ARM';
    $284: CPU:='Alpha AXP?64-bit';
    $14c: CPU:='386 and later';
     333: CPU:='486';
     334: CPU:='586';
    $200: CPU:='Intel IA64';
    $268: CPU:='Motorola 68000 series';
    $266: CPU:='MIPS16';
    $366: CPU:='MIPS with FPU';
    $466: CPU:='MIPS16 with FPU';
    $1f0: CPU:='Power PC, little endian';
    $162: CPU:='R3000';
    $166: CPU:='MIPS?little endian';
    $168: CPU:='R10000';
    $1a2: CPU:='Hitachi SH3';
    $1a6: CPU:='Hitachi SH4';
    $1c2: CPU:='MACHINE_THUMB';
    Else CPU:=IntToHex(wCPU,2);
  End;

  PEFile.PEStream.ReadBuffer(ObjectNum,2);
  PEFile.PEStream.ReadBuffer(TimeStamp,4);
  PEFile.PEStream.ReadBuffer(SymTblOffset,4);
  PEFile.PEStream.ReadBuffer(SymNum,4);
  PEFile.PEStream.ReadBuffer(NT_HDR_SIZE,2);

  //Note: wFlag is a bit mask and must be OR-ed
  PEFile.PEStream.ReadBuffer(wFlags,2);
  FLAGS[1]:=wFlags and $1 > 0;
  FLAGS[2]:=wFlags and $2 > 0;
  FLAGS[3]:=wFlags and $4 > 0;
  FLAGS[4]:=wFlags and $8 > 0;
  FLAGS[5]:=wFlags and $10 > 0;
  FLAGS[6]:=wFlags and $20 > 0;
  FLAGS[7]:=wFlags and $40 > 0;
  FLAGS[8]:=wFlags and $80 > 0;
  FLAGS[9]:=wFlags and $100 > 0;
  FLAGS[10]:=wFlags and $200 > 0;
  FLAGS[11]:=wFlags and $400 > 0;
  FLAGS[13]:=wFlags and $1000 > 0;
  FLAGS[14]:=wFlags and $2000 > 0;
  FLAGS[15]:=wFlags and $4000 > 0;
  FLAGS[16]:=wFlags and $8000 > 0;

  PEFile.PEStream.ReadBuffer(wOptionalPEType,2);
  {OPTIONAL PE HEADER}
  PEFile.Read(b1,b2);
  LMAJOR_MINOR:=IntToStr(b1)+'.'+IntToStr(b2);
  PEFile.PEStream.ReadBuffer(SizeOfCode,4);
  PEFile.PEStream.ReadBuffer(SizeOfInitializedData,4);
  PEFile.PEStream.ReadBuffer(SizeOfUninitializedData,4);
  PEFile.PEStream.ReadBuffer(RVA_ENTRYPOINT,4);
  PEFile.PEStream.ReadBuffer(BaseOfCode,4);
  PEFile.PEStream.ReadBuffer(BaseOfData,4);

  PEFile.PEStream.ReadBuffer(IMAGE_BASE,4);
  PEFile.PEStream.ReadBuffer(OBJECT_ALIGN,4);
  PEFile.PEStream.ReadBuffer(FILE_ALIGN,4);
  PEFile.PEStream.ReadBuffer(OSMAJOR_MINOR,4);
  PEFile.PEStream.ReadBuffer(USERMAJOR_MINOR,4);
  PEFile.PEStream.ReadBuffer(SUBSYSMAJOR_MINOR,4);

  // Reading Reserved Flag
  PEFile.PEStream.ReadBuffer(IMAGE_SIZE,4);

  PEFile.PEStream.ReadBuffer(IMAGE_SIZE,4);
  PEFile.PEStream.ReadBuffer(HEADER_SIZE,4);
  PEFile.PEStream.ReadBuffer(FILE_CHECKSUM,4);
  PEFile.PEStream.ReadBuffer(wSubSys,2);
  Case wSubSys Of
    0: SUBSYSTEM:='Unknown';
    1: SUBSYSTEM:='Device Driver Or Native';
    2: SUBSYSTEM:='Windows?GUI';
    3: SUBSYSTEM:='Windows?CUI';
    5: SUBSYSTEM:='OS/2 CUI';
    7: SUBSYSTEM:='Posix CUI';
    9: SUBSYSTEM:='Windows CE';
    10: SUBSYSTEM:='EFI application';
    11: SUBSYSTEM:='EFI Boot Service';
    12: SUBSYSTEM:='EFI Runtime Service'
    Else SUBSYSTEM:=IntToHex(wSubSys,2);
  End;
  PEFile.PEStream.ReadBuffer(wDLL,2);
  Case wDLL Of
    $1    : DLL_FLAGS:='Per-Process Library Initialization';
    $2    : DLL_FLAGS:='Per-Process Library Termination';
    $4    : DLL_FLAGS:='Per-Thread Library Initialization';
    $8    : DLL_FLAGS:='Per-Thread Library Termination';
    $800  : DLL_FLAGS:='Do not bind image';
    $2000 : DLL_FLAGS:='Driver is a WDM Driver';
    $8000 : DLL_FLAGS:='Image is Terminal Server aware'
    Else DLL_FLAGS:=IntToHex(wDLL,2);
  End;

  PEFile.PEStream.ReadBuffer(STACK_RESERVE_SIZE,4);
  PEFile.PEStream.ReadBuffer(STACK_COMMIT_SIZE,4);
  PEFile.PEStream.ReadBuffer(HEAP_RESERVE_SIZE,4);
  PEFile.PEStream.ReadBuffer(HEAP_COMMIT_SIZE,4);
  PEFile.PEStream.ReadBuffer(LoaderFlags,4);
  PEFile.PEStream.ReadBuffer(VA_ARRAY_SIZE,4);

  PEFile.PEStream.ReadBuffer(EXPORT_TABLE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_EXPORT_DATA_SIZE,4);
  PEFile.PEStream.ReadBuffer(IMPORT_TABLE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_IMPORT_DATA_SIZE,4);
  PEFile.PEStream.ReadBuffer(RESOURCE_TABLE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_RESOURCE_DATA_SIZE,4);
  PEFile.PEStream.ReadBuffer(EXCEPTION_TABLE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_EXCEPTION_DATA_SIZE,4);
  PEFile.PEStream.ReadBuffer(SECURITY_TABLE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_SECURITY_DATA_SIZE,4);
  PEFile.PEStream.ReadBuffer(FIXUP_TABLE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_FIXUP_DATA_SIZE,4);
  PEFile.PEStream.ReadBuffer(DEBUG_TABLE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_DEBUG_DIRECTORIES,4);
  PEFile.PEStream.ReadBuffer(IMAGE_DESCRIPTION_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_DESCRIPTION_SIZE,4);
  PEFile.PEStream.ReadBuffer(MACHINE_SPECIFIC_RVA,4);
  PEFile.PEStream.ReadBuffer(MACHINE_SPECIFIC_SIZE,4);
  PEFile.PEStream.ReadBuffer(THREAD_LOCAL_STORAGE_RVA,4);
  PEFile.PEStream.ReadBuffer(TOTAL_TLS_SIZE,4);


  PEFile.PEStream.ReadBuffer(Load_Config_Table_RVA,4);
  PEFile.PEStream.ReadBuffer(Load_Config_Table_Size,4);
  PEFile.PEStream.ReadBuffer(Bound_Import_RVA,4);
  PEFile.PEStream.ReadBuffer(Bound_Import_Size,4);
  PEFile.PEStream.ReadBuffer(IAT_RVA,4);
  PEFile.PEStream.ReadBuffer(IAT_Size,4);
  PEFile.PEStream.ReadBuffer(Delay_Import_Descriptor_RVA,4);
  PEFile.PEStream.ReadBuffer(Delay_Import_Descriptor_Size,4);
  PEFile.PEStream.ReadBuffer(COM_Runtime_Header_RVA,4);
  PEFile.PEStream.ReadBuffer(COM_Runtime_Header_Size,4);

  PEPlusDelta:=0;
end;

procedure TPEHeader.ProcessObjects;
var i : Integer;
begin
  For i:=1 To ObjectNum Do
     Objects[i].Process;
end;

{ TPEResDir }

procedure TPEResDir.Process;
var i,j,SubNameCount, SubIDCount : Word;
    ResDirCount : Word;
    Flag : Word;
begin
  i:=1;
  ResDirCount:=0;
  Repeat
     Flag:=DATA[i+1]*256+DATA[i];
     If Flag<>0 Then Break;
     SubNameCount:=DATA[13+i]*256+DATA[12+i];
     SubIDCount:=DATA[15+i]*256+DATA[14+i];
     i:=i+16+(SubIDCount+SubNameCount)*8;
     Inc(ResDirCount);
  Until False;

  SetLength(DirEntry,ResDirCount+1);
  i:=0;
  ResDirCount:=0;
 Try
  Repeat
     Flag:=DATA[i+2]*256+DATA[i+1];
     If Flag<>0 Then Break;
     SubNameCount:=DATA[i+14]*256+DATA[i+13];
     SubIDCount:=DATA[i+16]*256+DATA[i+15];
     DirEntry[ResDirCount].FLAGS:=Flag;
     DirEntry[ResDirCount].Version:=IntToStr(DATA[i+10]*256+DATA[i+9])+'.'+IntToStr(DATA[i+12]*256+DATA[i+11]);
     DirEntry[ResDirCount].NameEntry:=DATA[i+14]*256+DATA[i+13];
     DirEntry[ResDirCount].IDEntry:=DATA[i+16]*256+DATA[i+15];
     DirEntry[ResDirCount].DateTimeStamp:=Byte2Hex(DATA[i+8])
      +Byte2Hex(DATA[i+7])+Byte2Hex(DATA[i+6])+Byte2Hex(DATA[i+5]);
     SetLength(DirEntry[ResDirCount].Entries,SubIDCount+SubNameCount);
     For j:=1 To SubIDCount+SubNameCount Do
      With DirEntry[ResDirCount].Entries[j] Do
        Begin
          NAME_RVA:=DATA[i+(j-1)*8+2]*256+DATA[i+(j-1)*8+1];
          INTEGER_ID:=DATA[i+(j-1)*8+4]*256+DATA[i+(j-1)*8+3];
          DATA_ENTRY_RVA:=DATA[i+(j-1)*8+6]*256+DATA[i+(j-1)*8+5];
          SUBDIR_RVA:=DATA[i+(j-1)*8+8]*256+DATA[i+(j-1)*8+7];
        End;
     i:=16+(SubIDCount+SubNameCount)*8;
     Inc(ResDirCount);
  Until ResDirCount=50;
 Except
   on E: Exception do
     raise EReadError.CreateFmt(
       'PE resource directory parsing failed after %d entries: %s',
       [ResDirCount, E.Message]);
 End;

end;

{ TPEFixupTable }

procedure TPEFixupTable.CollectInfo;
var i, Count : DWORD;
    f : File of Byte;
    b1,b2,b3,b4 : Byte;
begin
  BlocksCount:=0;
  System.Assign(f,FileName);
  System.Reset(f);
  i:=ABaseOffset;
  Repeat
     System.Seek(f,i+4);
     System.Read(f,b1,b2,b3,b4);
     Count:=b1+b2*256+(b3+b4*256)*256*256;
     i:=i+Count;
     Inc(BlocksCount);
  Until (i>=ABaseOffset+ASize) or (Count=0);

  SetLength(DATA,BlocksCount);
  BlocksCount:=0;
  i:=ABaseOffset;
  Repeat
     System.Seek(f,i+4);
     System.Read(f,b1,b2,b3,b4);
     Count:=b1+b2*256+(b3+b4*256)*256*256;
     Inc(BlocksCount);
     DATA[BlocksCount-1].Offset:=i;
     DATA[BlocksCount-1].Size:=Count;
     i:=i+Count;
  Until(i>=ABaseOffset+ASize) or (Count=0);
  System.Close(f);
end;

procedure TPEFixupTable.GetData(AiBlock: Word; AList: TStrings);
var f : File of Byte;
    b1,b2,b3,b4 : Byte;
    blocksize,i : Word;
begin
  AList.Clear;
  System.Assign(f,FileName);
  System.Reset(f);
  System.Seek(f,DATA[AiBlock-1].Offset);
  System.Read(f,b1,b2,b3,b4);
  AList.Add(Format('Fixup Block N%d  Page RVA:%d',[AiBlock,b1+b2*256+(b3+b4*256)*256*256]));
  System.Read(f,b1,b2,b3,b4);
  AList.Add('');
  blocksize:=b1+b2*256+(b3+b4*256)*256*256;
  For i:=5 To blocksize div 2 Do
   Begin
    System.Read(f,b1,b2);
    AList.Add(Byte2Hex(b1)+Byte2Hex(b2));
   End;
  System.Close(f);
end;

{ TPEImportData }

procedure TPEImportData.CollectInfo(APhysOffset, RVA: DWord;
  AList: TStrings);
begin
  if PEFile = nil then
    raise Exception.Create(err_no_pefile_assigned);
  CollectInfo(PEFile, APhysOffset, RVA, AList);
end;

procedure TPEImportData.CollectInfo(AFile: ThePEFile;
  APhysOffset, RVA: DWord; AList: TStrings);
var
  Delta: Int64;
  DescriptorOffset, NameOffset, ThunkOffset, ProcNameOffset: Int64;
  NameRVA, ThunkRVA, ProcRVA: DWORD;
  ProcAddress, ProcHint, ProcName, DLLName: string;
  Reader: TDeDeBinaryReader;

  function FileOffset(const AOffset: Int64): TPE32FileOffset;
  begin
    if (AOffset < 0) or (AOffset > High(LongWord)) then
      raise EDeDeBinaryBounds.CreateFmt(
        'PE import data offset is outside PE32 range: %s',
        [IntToHex(AOffset, 16)]);
    Result := TPE32FileOffset(AOffset);
  end;

  function RVAOffset(ARVA: DWORD): TPE32FileOffset;
  begin
    Result := FileOffset(Int64(ARVA) + Delta);
  end;

  function ReadNullTerminatedString(AOffset: TPE32FileOffset): string;
  var
    Position: Int64;
    Value: Byte;
  begin
    Result := '';
    Position := LongWord(AOffset);
    repeat
      Value := Reader.ReadUInt8At(FileOffset(Position));
      if Value = 0 then
        Exit;
      Result := Result + Chr(Value);
      Inc(Position);
    until False;
  end;

begin
  if AFile = nil then
    raise Exception.Create(err_no_pefile_assigned);
  if AList = nil then
    raise EArgumentNilException.Create('AList');
  DLLCount := 0;
  ProcCount := 0;
  Delta := Int64(APhysOffset) - RVA;
  DescriptorOffset := APhysOffset;
  AList.Clear;
  Reader := TDeDeBinaryReader.Create(AFile.PEStream);
  try
    try
    while True do
    begin
      NameRVA := Reader.ReadUInt32LEAt(
        FileOffset(DescriptorOffset + 12));
      ThunkRVA := Reader.ReadUInt32LEAt(
        FileOffset(DescriptorOffset + 16));
      if (NameRVA = 0) and (ThunkRVA = 0) then
        Break;
      if (NameRVA = 0) or (ThunkRVA = 0) then
        raise EReadError.CreateFmt(
          'Invalid import descriptor at file offset %s',
          [IntToHex(DescriptorOffset, 8)]);

      NameOffset := LongWord(RVAOffset(NameRVA));
      ThunkOffset := LongWord(RVAOffset(ThunkRVA));
      DLLName := ReadNullTerminatedString(
        TPE32FileOffset(NameOffset));
      AList.Add(DLLName + #0);
      Inc(DLLCount);

      while True do
      begin
        ProcRVA := Reader.ReadUInt32LEAt(
          FileOffset(ThunkOffset));
        if ProcRVA = 0 then
          Break;
        ProcHint := DWord2HEX(ProcRVA and $80000000);
        ProcAddress := DWord2HEX(ProcRVA and $7FFFFFFF);
        if ProcHint <> '80000000' then
        begin
          ProcNameOffset := Int64(LongWord(RVAOffset(ProcRVA))) + 2;
          ProcName := ReadNullTerminatedString(
            FileOffset(ProcNameOffset));
        end
        else
        begin
          ProcName := 'Ordinal:' + ProcAddress;
          ProcAddress := '00000000';
        end;
        AList.Add(' ' + ProcName +
          Format(',%sh,%s', [ProcAddress, ProcHint]));
        Inc(ProcCount);
        Inc(ThunkOffset, 4);
      end;
      Inc(DescriptorOffset, 20);
    end;
  except
    on E: Exception do
      raise EReadError.CreateFmt(
        'Import table parse failed at descriptor %s (delta %s): %s',
        [IntToHex(DescriptorOffset, 8), IntToHex(Delta, 16), E.Message]);
  end;
  finally
    Reader.Free;
  end;
end;

{ TPETLSTable }

procedure TPETLSTable.Process;
var f : File of Byte;
    b1,b2,b3,b4 : Byte;
begin
  System.Assign(f,FileName);
  System.ReSet(f);
  System.Seek(f,PhysOffset);
  System.Read(f,b1,b2,b3,b4);
  START_DATA_BLOCK_VA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1);
  System.Read(f,b1,b2,b3,b4);
  END_DATA_BLOCK_VA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1);
  System.Read(f,b1,b2,b3,b4);
  INDEX_VA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1);
  System.Read(f,b1,b2,b3,b4);
  CALLBACK_TABLE_VA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1);
  System.Close(f);
end;

{ TPEExports }

procedure TPEExports.Process(AdwAddress,ARVA: DWORD);
var b1,b2,b3,b4 : Byte;
    i : LongInt;
    TmpStr : String;
begin
   If PEFile=nil Then
      Raise Exception.Create(err_no_pefile_assigned);
   {Reading Export Directory Table}
   PEFile.Seek(AdwAddress+4);
   PEFile.Read(b1,b2,b3,b4);
   DATE_TIME_STAMP:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1);
   PEFile.Read(b1,b2,b3,b4);
   VERSION:=Format('%d.%d',[b1+256*b2,b3+256*b4]);
   PEFile.Read(b1,b2,b3,b4);
   Name_RVA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1)+'h';
   PEFile.Read(b1,b2,b3,b4);
   Ordinal_Base:=(b1+b2*256)+(b3+b4*256)*256*256;
   PEFile.Read(b1,b2,b3,b4);
   Address_Table_Entries:=(b1+b2*256)+(b3+b4*256)*256*256;
   PEFile.Read(b1,b2,b3,b4);
   Number_of_Name_Pointers:=(b1+b2*256)+(b3+b4*256)*256*256;
   PEFile.Read(b1,b2,b3,b4);
   Export_Address_Table_RVA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1)+'h';
   PEFile.Read(b1,b2,b3,b4);
   Name_Pointer_RVA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1)+'h';
   PEFile.Read(b1,b2,b3,b4);
   Ordinal_Table_RVA:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1)+'h';

   SetLength(FUNC_DATA,Address_Table_Entries+1);

   {Reading Export Address Table}
   PEFile.Seek(Hex2DWORD(Export_Address_Table_RVA)-ARVA+AdwAddress);
   For i:=1 To Address_Table_Entries Do
    Begin
      PEFile.Read(b1,b2,b3,b4);
      FUNC_DATA[i].Offset:=Byte2Hex(b4)+Byte2Hex(b3)+Byte2Hex(b2)+Byte2Hex(b1)+'h';
    End;

   {Reading Export Name Pointer Table}
   PEFile.Seek(Hex2DWORD(Name_Pointer_RVA)-ARVA+AdwAddress);
   For i:=1 To Address_Table_Entries Do
    Begin
      PEFile.Read(b1,b2,b3,b4);
      FUNC_DATA[i].NameAddress:=(b1+b2*256)+(b3+b4*256)*256*256;
    End;

   {Reading Export Ordinal Table}
   PEFile.Seek(Hex2DWORD(Ordinal_Table_RVA)-ARVA+AdwAddress);
   For i:=1 To Address_Table_Entries Do
    Begin
      PEFile.Read(b1,b2);
      FUNC_DATA[i].Ordinal:=(b1+b2*256);
    End;

   {Reading Export Name Table}
   For i:=1 To Address_Table_Entries Do
    Begin
      PEFile.Seek(FUNC_DATA[i].NameAddress-ARVA+AdwAddress);
      TmpStr:='';
      Repeat
        PEFile.Read(b1);
        TmpStr:=TmpStr+Chr(b1);
      Until b1=0;
      TmpStr:=Copy(TmpStr,1,Length(TmpStr)-1);
      FUNC_DATA[i].Name:=TmpStr;
    End;
end;

{ ThePEFile }

constructor ThePEFile.Create(AsFileName: String);
begin
   Inherited Create;

   sFileName:=AsFileName;
   Stream:=TPEStream.Create;
   If AsFileName<>'' Then
      Stream.LoadFromFile(AsFileName);
end;

destructor ThePEFile.Destroy;
begin
   If Stream<>nil Then
     Begin
       Stream.Free;
       Stream:=nil;
     End;

   Inherited Destroy;
end;

procedure ThePEFile.Read(var b1, b2, b3, b4: Byte);
begin
  b1:=Stream.ReadByte;
  b2:=Stream.ReadByte;
  b3:=Stream.ReadByte;
  b4:=Stream.ReadByte;
end;

procedure ThePEFile.Read(var b1, b2: Byte);
begin
  b1:=Stream.ReadByte;
  b2:=Stream.ReadByte;
end;

function ThePEFile.FilePos: Integer;
begin
  Result:=Stream.Position;
end;

procedure ThePEFile.Read(var b1: Byte);
begin
  b1:=Stream.ReadByte;
end;

procedure ThePEFile.Seek(Offset: DWord);
begin
   Stream.Seek(Offset,soFromBeginning);
end;

function ThePEFile.FileSize: Integer;
begin
  Result:=Stream.Size;
end;

procedure ThePEFile.Write(b: Byte);
begin
  Stream.WriteBuffer(b,1);
end;

////////////////////////////////////////////////////
//    This removes chars that has special meaning
// in IDA and SoftIce
////////////////////////////////////////////////////
Function DeDeStrToIDAStr(sDeDeStr : String) : String;
var i : Integer;
begin
  Result:='';
  For i:=1 to Length(sDeDeStr) Do
    case sDeDeStr[i] of
      #32: //Result:=Result+sDeDeStr[i] Explicitly remove intervals
      else Result:=Result+sDeDeStr[i];
    end;
end;

/////////////////////////////////////
// Returns SoftIce install directory
// if SoftIce is installed
/////////////////////////////////////
function GetSoftIceDir : String;
{$IFDEF MSWINDOWS}
const SICE_KEY = 'SOFTWARE\NuMega\SoftICE';
      INSTALL_DIR  = 'InstallDir';
var reg : TRegistry;
begin
  Result:='';
  reg:=TRegistry.Create;
  Try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if not reg.KeyExists(SICE_KEY) then Exit;
    reg.OpenKey(SICE_KEY,False);
    Result:=reg.ReadString(INSTALL_DIR);
  Finally
    reg.Free;
  End;
end;
{$ELSE}
begin
  Result := '';
end;
{$ENDIF}

/////////////////////////////////////
// Returns true if SoftIce is active
/////////////////////////////////////
function SoftIceIsActive : Boolean;
{$IFDEF MSWINDOWS}
const SICE_FILES : Array [1..3] of String = ('SICE','SIWVID','NTICE');
var hFile : Cardinal;
    i : Integer;
begin
  Result:=False;
  For i:=1 To 3 Do
    Begin
      hFile:=CreateFile(PChar('\\.\'+SICE_FILES[i]), GENERIC_READ or GENERIC_WRITE,
                        FILE_SHARE_READ or FILE_SHARE_WRITE,
                        nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

      if hFile<>INVALID_HANDLE_VALUE
        then begin
          Result:=True;
          CloseHandle(hFile);
          exit;
        end;
    End;   
end;
{$ELSE}
begin
  Result := False;
end;
{$ENDIF}


initialization
  GlobAbort:=False;
  ProcRefOffsets:=TStringList.Create;
  ProcRefNames:=TStringList.Create;
  PEFile:=nil;
  
finalization
  ProcRefOffsets.Clear;
  ProcRefNames.Clear;    
end.
