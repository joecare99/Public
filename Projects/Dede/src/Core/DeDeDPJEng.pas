unit DeDeDPJEng;

////////////////////////////////////////////////////////////////////////////////
// The .DPJ Engine functions for saving and loading .DPJ files
//
////////////////////////////////////////////////////////////////////////////////
// .DPJ Format
//
// DWORD      Ident  'DPJ!'
// QWORD      DPJ version  (4 chars - the current .DPJ version '1.01'
// QWORD      DeDe version (4 chars - minimal DeDe version needed to open
//                         (    the file - '2.50'
// STRPAS     Project name
// STRPAS     Full path to target executable
//
// CLASS_DATA_STREAM    - All classes data
// MEM_DUMP_STREAM      - BSS and DATA sections dumped from memory
// USER_SETTINGS_STREAM - User config (DSF and DOI files to load, etc.)
// USER_MACRO_STREAM    - User macros (COMMENT and EMUL)
//
//


interface

uses Classes, DeDeEditText;

const
  DPJCommentRecordBytes = 104;

Procedure LoadDPJFile(FsFileName : String);
Procedure SaveDPJFile(FsFileName : String);
function ReadDPJRawString(AStream: TStream; ByteCount: Integer): string;
procedure WriteDPJRawString(AStream: TStream; const Value: string);
function ReadDPJStringValue(AStream: TStream): string;
procedure WriteDPJStringValue(AStream: TStream; const Value: string);
procedure ReadDPJCommentRecords(AStream: TStream;
  var AComments: TCommentArray; var ACount: Integer);
procedure WriteDPJCommentRecords(AStream: TStream;
  const AComments: TCommentArray; ACount: Integer);

implementation

{ TDPJFile }

Uses VCLUnZip, VCLZip, SysUtils, DeDeConstants, MainUnit, Windows,
     DeDeCoreServices,
     CRC32, DeDeSym, DeDeReg, DeDeClasses, DeDeAnsiStream;

var
   Stream : TMemoryStream;

const
   DPJVersion = '1.00';

function ReadDPJRawString(AStream: TStream; ByteCount: Integer): string;
begin
  Result := DeDeAnsiStream.ReadAnsiString(AStream, ByteCount);
end;

procedure WriteDPJRawString(AStream: TStream; const Value: string);
begin
  DeDeAnsiStream.WriteAnsiString(AStream, Value);
end;

function ReadDPJStringValue(AStream: TStream): string;
var
  ByteCount: Integer;
begin
  AStream.ReadBuffer(ByteCount, SizeOf(ByteCount));
  Result := ReadDPJRawString(AStream, ByteCount);
end;

procedure WriteDPJStringValue(AStream: TStream; const Value: string);
var
  ByteCount: Integer;
begin
  ByteCount := DeDeAnsiStream.AnsiByteLength(Value);
  AStream.WriteBuffer(ByteCount, SizeOf(ByteCount));
  DeDeAnsiStream.WriteAnsiString(AStream, Value);
end;

procedure ReadDPJCommentRecords(AStream: TStream;
  var AComments: TCommentArray; var ACount: Integer);
var
  I: Integer;
  RemainingBytes: Int64;
begin
  AStream.ReadBuffer(ACount, SizeOf(ACount));
  RemainingBytes := AStream.Size - AStream.Position;
  if (ACount < 0) or (RemainingBytes < 0) or
     (Int64(ACount) > RemainingBytes div DPJCommentRecordBytes) then
    raise EReadError.Create('Invalid DPJ comment record count');
  SetLength(AComments, ACount);
  // Reject truncated records before allocating from the file-supplied count.
  // The target stores 104 bytes from each 260-byte in-memory comment record.
  for I := 0 to ACount - 1 do
    AStream.ReadBuffer(AComments[I], DPJCommentRecordBytes);
end;

procedure WriteDPJCommentRecords(AStream: TStream;
  const AComments: TCommentArray; ACount: Integer);
var
  I: Integer;
begin
  AStream.WriteBuffer(ACount, SizeOf(ACount));
  for I := 0 to ACount - 1 do
    AStream.WriteBuffer(AComments[I], DPJCommentRecordBytes);
end;

procedure SaveMagicStringValue(s : String);
begin
   WriteDPJRawString(Stream, s);
end;

procedure SaveStringValue(s : String);
begin
   WriteDPJStringValue(Stream, s);
end;

procedure SaveDWORDValue(i : LongWord);
begin
   Stream.WriteBuffer(i, 4);
end;

procedure SaveIntegerValue(i : Integer);
begin
   Stream.WriteBuffer(i, 4);
end;

procedure SaveByteValue(b : Byte);
begin
   Stream.WriteBuffer(b, 1);
end;


procedure SaveBooleanValue(b : Boolean);
var bt : Byte;
begin
   if b then bt:=1 else bt:=0;
   SaveByteValue(bt);
end;


procedure SaveStringListValues(sl : TStringList);
var i : Integer;
begin
  SaveDWORDValue(sl.Count);
  For i:=0 to sl.Count-1 do SaveStringValue(sl[i]);
end;

procedure SaveTStringsValues(sl : TStrings);
var i : Integer;
begin
  SaveDWORDValue(sl.Count);
  For i:=0 to sl.Count-1 do SaveStringValue(sl[i]);
end;

procedure SaveStringListValuesAndPointers(sl : TStringList);
var i : Integer;
begin
  SaveDWORDValue(sl.Count);
  For i:=0 to sl.Count-1 do
    begin
      SaveStringValue(sl[i]);
      SaveDWORDValue(LongWord(sl.Objects[i]));
    end;
end;


procedure CalcCRC32OfFile(sFileName : String);
var MemStr : TMemoryStream;
    bytesRead : cardinal;
    buff : Array of Byte;
begin
  MemStr:=TMemoryStream.Create;
  try
    MemStr.LoadFromFile(sFileName);
    MemStr.Seek(0,soFromBeginning);
    SetLength(buff,400);
    CRC32.crc32val:=0;
    bytesRead:=MemStr.Read(buff[1],400);
    if bytesRead>0 then CRC32.updatecrc(buff,bytesRead);

{    While MemStr.Position<MemStr.Size do
      begin
        bytesRead:=MemStr.Read(buff[1],100);
        if bytesRead>0 then CRC32.updatecrc(buff,bytesRead);
        if bytesRead<>100 then break;
      end
}  finally
    MemStr.Free;
  end;
end;

procedure ProcessStreamForLoadingDPJ;
const
   mDPJError = 'DeDe project loading error.';
var
   FileVer, s : string;
   i, j : integer;
   p : Pointer;
begin
   s := ReadDPJRawString(Stream, 4);
   if s <> 'DPJ!' then begin
//   Invalid DeDe project
      MessageBox(0, PChar('Invalid DeDe project'), mDPJError, MB_OK);
   end; { if }
   s := ReadDPJRawString(Stream, 4);
   if s > DPJVersion then begin
//   Not supported DPJ version
      MessageBox(0, PChar('Unsupported project version ('+s+')'), mDPJError, MB_OK);
   end; { if }
   FileVer := s;
   s := ReadDPJRawString(Stream, 4);
   if s > TargetDeDeVersion then begin
//   Not supported DeDe version
      MessageBox(0, PChar('Unsupported DeDe version ('+s+')'), mDPJError, MB_OK);
   end; { if }
// Read Project Name
   DeDeMainForm.FsProjectName := ReadDPJStringValue(Stream);
// Read File Name
   DeDeMainForm.FsFileName := ReadDPJStringValue(Stream);
// Read comments
   ReadDPJCommentRecords(Stream, DeDeEditText.Comments,
     DeDeEditText.CommentsCount);
end;



procedure ProcessStreamForSavingDPJ;
var
   s : string;
   i, sz : integer;
   p : Pointer;
   buff : Array of Byte;
begin
   Stream.Clear;
   /////////////////////////////////////////////////////////////////////////////
   // Save DPJ and DeDe versions
   /////////////////////////////////////////////////////////////////////////////
   s:='DPJ!' + DPJVersion + TargetDeDeVersion;
   WriteDPJRawString(Stream, Copy(s, 1, 12));

   /////////////////////////////////////////////////////////////////////////////
   // Save pre-dump data
   /////////////////////////////////////////////////////////////////////////////
   // Project name
      SaveStringValue(DeDeMainForm.FsProjectName);
   // Target file name and path
      SaveStringValue(DeDeMainForm.FsFileName);
   // Target file CRC32
      CalcCRC32OfFile(DeDeMainForm.FsFileName);
      SaveDWORDValue(CRC32.crc32val);
   // Symbols to load
      SaveMagicStringValue('SYM');
      SaveDWORDValue(DeDeMainForm.SymbolsList.Count);
      For i:=0 to DeDeMainForm.SymbolsList.Count-1 do
        Begin
          s:=ExtractFileName(TDeDeSymbol(DeDeMainForm.SymbolsList[i]).FileName);
          SaveStringValue(s);
        End;
   // DeDeReg values
      SaveMagicStringValue('DEDEREG');
      SaveBooleanValue(DeDeReg.bWARN_ON_FILE_OVERWRITE);
      SaveBooleanValue(DeDeReg.bNOT_ALLOW_EXISTING_DIR);
      SaveBooleanValue(DeDeReg.bDumpAll);
      SaveBooleanValue(DeDeReg.bObjPropRef);
      SaveIntegerValue(DeDeReg.iSTRING_REF_TYPE);
      SaveBooleanValue(DeDeReg.bSMARTMODE);
      SaveBooleanValue(DeDeReg.bUseDOI);
      SaveBooleanValue(DeDeReg.bDontShowUnkRefs);
      SaveBooleanValue(DeDeReg.bRegisterShellExt);
   // Dump specific values
      SaveBooleanValue(DeDeClasses.bBSS);
      SaveBooleanValue(DeDeClasses.bDebug);
      SaveBooleanValue(DeDeClasses.bUserProcs);
      SaveBooleanValue(DeDeClasses.GlobCBuilder);
      SaveBooleanValue(DeDeClasses.GlobDelphi2);
      SaveStringListValues(DeDeClasses.ProcRefOffsets);
      SaveStringListValues(DeDeClasses.ProcRefNames);
      SaveStringValue(DeDeClasses.DelphiVersion);
   // More delphi version constants
      SaveStringValue(DeDeMainForm.sDelphiVersion);
      SaveIntegerValue(DeDeCoreContext.DelphiVersionCompatibility);
   // DeDeMainForm string lists
      SaveStringListValuesAndPointers(DeDeMainForm.DFMFormList);
      SaveTStringsValues(DeDeMainForm.PIUL.Items);
      SaveStringListValues(DeDeMainForm.PASNameList);
      SaveIntegerValue(DeDeCoreContext.ClassCount);
   /////////////////////////////////////////////////////////////////////////////
   // Save ClassesDumper object
   /////////////////////////////////////////////////////////////////////////////
      SaveMagicStringValue('CLASSESDUMPER');
      DeDeMainForm.ClassesDumper.GetBufferForDPJSave(buff,sz);
      SetLength(buff,sz);
      DeDeMainForm.ClassesDumper.GetBufferForDPJSave(buff,sz);
      SaveDWORDValue(sz);
      Stream.WriteBuffer(buff[0], sz);
   /////////////////////////////////////////////////////////////////////////////
   // Save DeDeMainForm additional stuff
   /////////////////////////////////////////////////////////////////////////////
      SaveStringListValues(DeDeMainForm.DFMFormList);
      SaveStringListValues(DeDeMainForm.UnitList);
      SaveStringListValues(DeDeMainForm.DFMNameList);
      SaveStringListValues(DeDeMainForm.PASNameList);
      SaveStringListValues(DeDeMainForm.CurrNames);
      SaveStringListValues(DeDeMainForm.CurrIDs);
      SaveStringListValues(DeDeMainForm.SymbolsPath);
      SaveBooleanValue(DeDeMainForm.FbMemFump);
      SaveBooleanValue(DeDeMainForm.FbProcessed);
      SaveBooleanValue(DeDeMainForm.FbFailed);
      SaveBooleanValue(DeDeMainForm.FbCutSelfPtr);
      SaveDWORDValue(ORD(DeDeMainForm.FFileType));
      SaveStringValue(DeDeMainForm.FsFileName);
      SaveStringValue(DeDeMainForm.FsProjectName);
      SaveStringValue(DeDeMainForm.DeDeProjectFileName);
      SaveStringValue(DeDeMainForm.FsLoadedDOIFile);

   // Write comments
   WriteDPJCommentRecords(Stream, DeDeEditText.Comments,
     DeDeEditText.CommentsCount);

   { Phew! :)) }
end;


procedure LoadDPJFile(FsFileName: String);
var UnZip : TVCLUnzip;
begin
  Stream := TMemoryStream.Create;
  Try
   UnZip := TVCLUnZip.Create(nil);
   Try
     UnZip.ZipName := FsFileName;
     UnZip.UnZipToStream(Stream,ExtractFileName(FsFileName));
     Stream.Seek(0, soFromBeginning);
   Finally
     UnZip.Free;
   End;
   ProcessStreamForLoadingDPJ;
   MessageBox(0, 'DeDe Project loaded !', '', MB_OK);
  Finally
   Stream.Free;
   Stream := nil;
  End;
end;


procedure SaveDPJFile(FsFileName: String);
var Zip : TVCLZip;
begin
   Stream := TMemoryStream.Create;
   DeleteFile(PChar(FsFileName));
   ProcessStreamForSavingDPJ;
   Zip := TVCLZip.Create(nil);
   Try
      Zip.ZipName := FsFileName;
      Stream.Seek(0, soFromBeginning);
      Zip.ZipFromStream(Stream, FsFileName);
      MessageBox(0, 'DeDe Project saved !', '', MB_OK);
   Finally
      Zip.Free;
   End;
   Stream.Free;
end;



end.
