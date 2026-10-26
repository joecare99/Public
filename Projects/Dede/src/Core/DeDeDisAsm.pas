unit DeDeDisAsm;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

//////////////////////////
// Last Change: 11.I.2001
//////////////////////////

interface

uses Classes, DeDeClasses, DeDeSym, DeDeClassHandle,
  DeDeCoreServices;

type DWORD = LongWord;

const IMPORT_REF_BEG = 'FF25';
      IMPORT_REF_END = '8BC0';

procedure DisassembleProc(NameP,S : String; var DasmList : TStringList; bNotClearText : Boolean = True; Custom : Boolean = False; EmulateOnly : Boolean = False; dwEmulateToOffset : DWORD = 0);
function OffsetInSegment(Offset : DWORD; Segment : String) : boolean;
function GetNextProcRVA(dwRVA : DWORD; var bFound : Boolean; bSkipBetweenCodeFillRecognition : Boolean = False) : DWORD;
Function OffsetShouldCorrect(ins1 : String) : Boolean;

Type TDisassemblerOptions = record
       Imports : Boolean;
       EnglishStrings : Boolean;
       NonEnglishStrings : Boolean;
     end;

var DFMNameList : TStringList;
    PASNameList : TStringList;
    UnitList : TStringList;
    ControlNames, ControlIDs, DFMText : TStringList;
    FOpCodeList : TList;
    PEStream : TPEStream;
    RVAConverter : TRVAConverter;
    bTryExcept : Integer;
    SymbolsList : TList;
    SEHPtrList,ENDPtrList : TStringList;
    ClsDmp : TClassDumper;
    GlobGetImports  :Boolean;
    GlobBEmulation : Boolean;
    GlobCustomEmulInit : Boolean;
    GlobMORE : Boolean;
    GlobDontCutStringReferences : Boolean;
    DisassemblerOptions : TDisassemblerOptions;
    bErrorsAsFile : Boolean;
    sDisAsmErrors : String;
    ProcRva : DWORD;

Function GetSymbolReference(AwdOffset : DWORD) : String;
function GetImportReference(AsOffset : String) : String;
Function GetControlClassEx(sClassName, sControlName : String) : String;
Function GetEventPrototype(sClassName, sHandlerName : String) : String;

///////////////////////////////////////////////////
// InitExe/InitUnits functions
///////////////////////////////////////////////////
Function GetInitUnitsProcRVA : DWORD;

implementation

uses DisASM, DisAsmTables, HEXTools, SysUtils, DeDeReg, DeDeConstants,
     DeDeClassEmulator, DeDeRes, DeDeOffsInf, DeDeExpressions, DeDeAnsiStream;

Var rva : DWORD;

Var LastPush : DWORD;
    sz : Integer;
    bCommentNext, bTryBlockFound, bControlRef : Boolean;
    LastJump : DWORD;

function CurrentPEStream: TPEStream;
var
  ImageFile: ThePEFile;
begin
  ImageFile := nil;
  if DeDeCoreContext <> nil then
    ImageFile := DeDeCoreContext.PEFile;
  if ImageFile <> nil then
    Result := ImageFile.PEStream
  else
    Result := PEStream;
  if Result = nil then
    raise EInvalidOp.Create('No PE stream is available to the disassembler');
end;

function CurrentPEConverter: TRVAConverter;
var
  ImageHeader: TPEHeader;
  CodeIndex: Integer;
begin
  Result := RVAConverter;
  if DeDeCoreContext = nil then
    Exit;
  ImageHeader := DeDeCoreContext.PEHeader;
  if ImageHeader = nil then
    Exit;
  if ImageHeader.ELFDumped then
    CodeIndex := ImageHeader.GetSectionIndexEx('.text')
  else
    CodeIndex := 1;
  if (CodeIndex < 1) or (CodeIndex > ImageHeader.ObjectNum) then
    Exit;
  Result.ImageBase := ImageHeader.IMAGE_BASE;
  Result.PhysOffset := ImageHeader.Objects[CodeIndex].PHYSICAL_OFFSET;
  Result.CodeRVA := ImageHeader.Objects[CodeIndex].RVA;
end;

function CurrentPEGetPhys(ARVA: DWORD): DWORD;
var
  Converter: TRVAConverter;
begin
  Converter := CurrentPEConverter;
  Result := Converter.GetPhys(ARVA);
end;

function CurrentPEGetRVA(AOffset: DWORD): DWORD;
var
  Converter: TRVAConverter;
begin
  Converter := CurrentPEConverter;
  Result := Converter.GetRVA(AOffset);
end;

function TryGetCallerStackCleanup(ABytes: PByte; ASize: Integer;
  out ACleanupBytes: LongWord): Boolean;
var
  CleanupValue: LongWord;
begin
  Result := False;
  ACleanupBytes := 0;
  if (ABytes = nil) or (ASize < 3) then
    Exit;
  if (ABytes[0] = $83) and (ABytes[1] = $C4) then
  begin
    CleanupValue := ABytes[2];
    if (CleanupValue < 4) or (CleanupValue > $7F) then
      Exit;
  end
  else if (ABytes[0] = $81) and (ABytes[1] = $C4) and (ASize >= 6) then
  begin
    CleanupValue := LongWord(ABytes[2]) or
      (LongWord(ABytes[3]) shl 8) or
      (LongWord(ABytes[4]) shl 16) or
      (LongWord(ABytes[5]) shl 24);
    if (CleanupValue < 4) or (CleanupValue > $10000) then
      Exit;
  end
  else
    Exit;
  ACleanupBytes := CleanupValue;
  Result := True;
end;

function GetX86RegisterWriteMask(ABytes: PByte; ASize: Integer;
  out AWriteMask: Byte): Boolean;
var
  Position, Opcode, SecondOpcode, ModRM, RegisterIndex, GroupIndex: Integer;
  ModValue, RMValue: Integer;
begin
  Result := False;
  AWriteMask := 0;
  if (ABytes = nil) or (ASize <= 0) then
    Exit;
  Position := 0;
  while (Position < ASize) and
    (ABytes[Position] in [$26, $2E, $36, $3E, $64, $65, $66, $67,
      $F0, $F2, $F3]) do
    Inc(Position);
  if Position >= ASize then
    Exit;
  Opcode := ABytes[Position];
  if (Opcode >= $B8) and (Opcode <= $BF) then
  begin
    RegisterIndex := Opcode - $B8;
    if RegisterIndex < 3 then
      AWriteMask := 1 shl RegisterIndex;
    Exit(True);
  end;
  if (Opcode >= $B0) and (Opcode <= $B7) then
  begin
    RegisterIndex := Opcode - $B0;
    if RegisterIndex < 4 then
      AWriteMask := 1 shl (RegisterIndex and 3);
    Exit(True);
  end;
  if (Opcode >= $40) and (Opcode <= $4F) then
  begin
    RegisterIndex := Opcode and $07;
    if RegisterIndex < 3 then
      AWriteMask := 1 shl RegisterIndex;
    Exit(True);
  end;
  if (Opcode >= $58) and (Opcode <= $5F) then
  begin
    RegisterIndex := Opcode - $58;
    if RegisterIndex < 3 then
      AWriteMask := 1 shl RegisterIndex;
    Exit(True);
  end;
  if (Opcode >= $50) and (Opcode <= $57) or
    (Opcode in [$68, $6A, $90, $9C, $9D, $C2, $C3, $E8, $E9, $EB]) or
    (Opcode >= $70) and (Opcode <= $7F) then
    Exit(True);

  if Opcode = $0F then
  begin
    if Position + 1 >= ASize then
      Exit;
    SecondOpcode := ABytes[Position + 1];
    if (SecondOpcode >= $80) and (SecondOpcode <= $8F) then
      Exit(True);
    if not (SecondOpcode in [$B6, $B7, $BE, $BF]) then
      Exit;
    if Position + 2 >= ASize then
      Exit;
    ModRM := ABytes[Position + 2];
    RegisterIndex := (ModRM shr 3) and $07;
    if RegisterIndex < 3 then
      AWriteMask := 1 shl RegisterIndex;
    Exit(True);
  end;

  if not (Opcode in [$01, $03, $09, $0B, $11, $13, $19, $1B,
    $21, $23, $29, $2B, $31, $33, $39, $3B, $80, $81, $83,
    $87, $89, $8B, $8D, $C6, $C7, $FF]) then
    Exit;
  if Position + 1 >= ASize then
    Exit;
  ModRM := ABytes[Position + 1];
  ModValue := (ModRM shr 6) and $03;
  RegisterIndex := (ModRM shr 3) and $07;
  RMValue := ModRM and $07;
  GroupIndex := RegisterIndex;
  case Opcode of
    $03, $0B, $13, $1B, $23, $2B, $33, $8B, $8D:
      if RegisterIndex < 3 then
        AWriteMask := 1 shl RegisterIndex;
    $87:
      begin
        if RegisterIndex < 3 then
          AWriteMask := AWriteMask or (1 shl RegisterIndex);
        if (ModValue = 3) and (RMValue < 3) then
          AWriteMask := AWriteMask or (1 shl RMValue);
      end;
    $01, $09, $11, $19, $21, $29, $31, $89:
      if (ModValue = 3) and (RMValue < 3) then
        AWriteMask := 1 shl RMValue;
    $39, $3B:
      AWriteMask := 0;
    $80, $81, $83:
      if (GroupIndex <> 7) and (ModValue = 3) and (RMValue < 3) then
        AWriteMask := 1 shl RMValue;
    $C6, $C7:
      if (GroupIndex = 0) and (ModValue = 3) and (RMValue < 3) then
        AWriteMask := 1 shl RMValue;
    $FF:
      if (GroupIndex in [0, 1]) and (ModValue = 3) and (RMValue < 3) then
        AWriteMask := 1 shl RMValue;
  end;
  Result := True;
end;

function IsX86BranchInstruction(ABytes: PByte; ASize: Integer): Boolean;
var
  Position, Opcode, SecondOpcode: Integer;
begin
  Result := False;
  if (ABytes = nil) or (ASize <= 0) then
    Exit;
  Position := 0;
  while (Position < ASize) and
    (ABytes[Position] in [$26, $2E, $36, $3E, $64, $65, $66, $67,
      $F0, $F2, $F3]) do
    Inc(Position);
  if Position >= ASize then
    Exit;
  Opcode := ABytes[Position];
  Result := (Opcode in [$C2, $C3, $E8, $E9, $EA, $EB]);
  if (Opcode >= $70) and (Opcode <= $7F) then
    Result := True;
  if (Opcode = $0F) and (Position + 1 < ASize) then
  begin
    SecondOpcode := ABytes[Position + 1];
    Result := (SecondOpcode >= $80) and (SecondOpcode <= $8F);
  end;
  if (Opcode = $FF) and (Position + 1 < ASize) then
    Result := ((ABytes[Position + 1] shr 3) and $07) in [2, 3, 4, 5];
end;

procedure RecordDisasmReference(Param: Pointer; Ref: TdaRef;
  RefSize: Integer; var ResultText: string);
var
  IsFrameBase: Boolean;
begin
  if DeDeCoreContext = nil then
    Exit;
  IsFrameBase :=
    ((Ref.MultiplyReg1 <> 0) and (Ref.ARegister1 = rEbp) and
      (Ref.MultiplyReg2 = 0)) or
    ((Ref.MultiplyReg2 <> 0) and (Ref.ARegister2 = rEbp) and
      (Ref.MultiplyReg1 = 0));
  if IsFrameBase then
    DeDeCoreContext.CrossReferences.RecordFrameAccess(
      ProcRva, rva, Ref.Immidiate, RefSize);
end;

Function UnitIncluded(s : String) : Boolean;
var sUnit : String;
    i : Integer;
Begin
  Result:=True;
  If (UnitList=nil) or (UnitList.Count=0) Then Exit;
  Result:=False;
  i:=Pos('.',s);
  sUnit:=AnsiUpperCase(Copy(s,1,i-1));
  For i:=0 To UnitList.Count-1 Do
   If AnsiUpperCase(UnitList[i])=sUnit
      Then Begin
        Result:=True;
        Break;
      End;
End;

Procedure TruncAll(Var s : String);
Begin
  While Copy(s,1,1)=' ' Do s:=Copy(s,2,Length(s)-1);
  While Copy(s,Length(s),1)=' ' Do s:=Copy(s,1,Length(s)-1);
End;

function OffsetInSegment(Offset : DWORD; Segment : String) : boolean;
var rva,size,ib : DWORD;
    i : Integer;
    ImageHeader: TPEHeader;
begin
  ImageHeader := DeDeCoreContext.PEHeader;
  if ImageHeader = nil then
    raise EInvalidOp.Create('No PE header is available to the disassembler');
  Result:=False;
  i:=ImageHeader.GetSectionIndexEx(Segment);
  If i<1 Then
    begin
    // Correction due to the lame idea of finding sections by name!!!
    if Segment='CODE' then
      i:=ImageHeader.GetSectionIndexByRVA(ImageHeader.BaseOfCode);

    if i=-1 then Exit;
    end;
    
  rva:=ImageHeader.Objects[i].RVA;
  size:=ImageHeader.Objects[i].VIRTUAL_SIZE;
  ib:=ImageHeader.IMAGE_BASE;
  Result:=(Offset>=ib+rva) and (Offset<=ib+rva+size);
end;


// Reads a string according to the specified
// string references options
function GetStringReference(AsOffset : String) : String;
const sFILL = sREF_TEXT_REF_STRING_OR+' ';
var b : Byte;
    dwOffset, rva : DWORD;
    bOK : Boolean;
    s : String;
    i : Integer;
    idx : Integer;
    ImageHeader: TPEHeader;
begin
  ImageHeader := DeDeCoreContext.PEHeader;
  if ImageHeader = nil then
    raise EInvalidOp.Create('No PE header is available for string lookup');
  idx:=ImageHeader.GetSectionIndexEx('DATA');

   if (not DisassemblerOptions.EnglishStrings)
     and (not DisassemblerOptions.NonEnglishStrings) then Exit;

   rva:=HEX2DWORD(AsOffset);  
   if ((RVA-ImageHeader.IMAGE_BASE)>=ImageHeader.Objects[idx].RVA)
     and ((RVA-ImageHeader.IMAGE_BASE)<=ImageHeader.Objects[idx].RVA+ImageHeader.Objects[idx].VIRTUAL_SIZE)
     then dwOffset:=rva-ImageHeader.IMAGE_BASE-ImageHeader.Objects[idx].RVA+ImageHeader.Objects[idx].PHYSICAL_OFFSET
     else dwOffset:=CurrentPEGetPhys(rva);


   CurrentPEStream.Seek(dwOffset,soFromBeginning);
   CurrentPEStream.ReadBuffer(b,1);
   bOK:=False;
   While b in STRING_REF_CHARSET Do
    Begin
      If not (b in [10,13]) Then Result:=Result+CHR(b);
      CurrentPEStream.ReadBuffer(b,1);
      If b in (STRING_REF_CHARSET - [10,13]) then bOK:=True;
    End;

  // Check Disassembly Options
  if (DisassemblerOptions.NonEnglishStrings)
    and (not DisassemblerOptions.EnglishStrings) then
      begin
        bOK:=False;
        for i:=1 to Length(Result) do
             bOk:=bOK or (Result[i] in [#192..#255]);
      end;

  If (b<>0) or not (bOK)
     Then Result:=''
     Else Begin
       If Length(Result)<35 Then Exit;
       If GlobDontCutStringReferences then Exit;
       s:=Result;
       Result:=Copy(s,1,35);
       s:=Copy(s,36,Length(s)-35);
       While Length(s)>35 Do
         Begin
           Result:=Result+#13#10+sFILL+Copy(s,1,35);
           s:=Copy(s,36,Length(s)-35);
         End;
       If s<>'' Then Result:=Result+#13#10+sFILL+s;
     End;
end;



function GetDWORDConstantReference(AsOffset : String) : String;
var dw, dwOffset : DWORD;
begin
   dwOffset:=CurrentPEGetPhys(HEX2DWORD(AsOffset));
   CurrentPEStream.Seek(dwOffset,soFromBeginning);
   CurrentPEStream.ReadBuffer(dw,4);
   Result:=IntToStr(dw);
end;



// Description : Finds the DLL name and Import name of
//              a import call reference.
//
// Last Modified : N/A
//
function GetImportReference(AsOffset : String) : String;
var iRVA, iPhys, ProcOffset, DLLOffset : DWORD;
    Delta1, Delta2: LongInt;
    iIDX : Byte;
    ImgBase : DWORD;
    wdiRVA,itbl : LongInt;
    {b1,b2,b3,b4,}b : Byte;
    ProcName, DLLName : String;
    ImageHeader: TPEHeader;
//    Pattern : TPaternQuery;
//    i : Integer;
begin
  ImageHeader := DeDeCoreContext.PEHeader;
  if ImageHeader = nil then
    raise EInvalidOp.Create('No PE header is available for import lookup');
  Result:='';
  DLLName:='';
  ProcName:='';

  if ImageHeader.ELFDumped then Exit;

  // Skip import references if set
  if not DisassemblerOptions.Imports then exit;

  if not bImportReferences then Exit;

  // Get the '.idata' section characteristics
  if ImageHeader.ELFDumped then iIDX:=ImageHeader.GetSectionIndexEx('.idata')
  else begin
    iIDX:=ImageHeader.GetSectionIndex('.idata');
    if iIDX=255 then
      iIDX:=ImageHeader.GetSectionIndexByRVA(ImageHeader.IMPORT_TABLE_RVA);
  end;

  iRVA:=ImageHeader.Objects[iIDX].RVA;
  iPhys:=ImageHeader.Objects[iIDX].PHYSICAL_OFFSET;
  // and some PE file characteristics
  ImgBase:=ImageHeader.IMAGE_BASE;

  // Convert value for RVA to Phys
  Delta1:=iPhys-iRVA-ImgBase;
  // Convert value relative offsets in  Import Tables
  Delta2:=iPhys-iRVA;

  wdiRVA:=HEX2DWORD(AsOffset);

  // The physical offset of the imported proc entry
  // in the DLL Import Lookup Table
  itbl:=wdiRVA+Delta1;
  // Goes there
  CurrentPEStream.Seek(itbl,soFromBeginning);
  // Reads the relative offset of the
  // entry in the Import Hint/Name Table
  CurrentPEStream.ReadBuffer(ProcOffset,4);
  // Corrects the offset to physical
  ProcOffset:=ProcOffset+Delta2;

  // Finds the DLL string ossfet
  Repeat
    CurrentPEStream.Seek(-8,soFromCurrent);
    CurrentPEStream.ReadBuffer(DLLOffset,4);
    If DLLOffset=0 Then Break;
  Until (CurrentPEStream.Position<=iPhys);

  If DLLOffset<>0 Then
   begin
      Result:='';
      Exit;
      Raise Exception.Create(err_import_ref);
   end;
  // Reads the first value in the DLL Import Lookup Table
  CurrentPEStream.ReadBuffer(DLLOffset,4);
  // Corrects the offset to physical
  DLLOffset:=DLLOffset+Delta2;

  // Goes to the import name offset
  CurrentPEStream.Seek(ProcOffset+2,soFromBeginning);
  ProcName:='';

  // Reads the import name
  Try
  CurrentPEStream.ReadBuffer(b,1);
  While b<>0 Do
   Begin
     ProcName:=ProcName+Chr(b);
     CurrentPEStream.ReadBuffer(b,1);
   End;
  Except
   Exit;
  End;


  // Goes to the dll name offset
  CurrentPEStream.Seek(DLLOffset,soFromBeginning);
  DLLName:='';

  Repeat
    CurrentPEStream.ReadBuffer(b,1);
    CurrentPEStream.Seek(-2,soFromCurrent);
  Until b<>0;
  DLLName:=Chr(b)+DLLName;
  // Reads the dll name
  CurrentPEStream.ReadBuffer(b,1);
  While b<>0 Do
   Begin
     DLLName:=Chr(b)+DLLName;
     CurrentPEStream.Seek(-2,soFromCurrent);
     CurrentPEStream.ReadBuffer(b,1);
   End;

  b:=Pos('.',DLLName);
  If b<>0 Then DLLName:=Copy(DLLName,1,b-1);
  if GlobCBuilder then Result:=ProcName
                  else Result:=DLLName+'.'+ProcName;
end;


// Returns true is the instruction has a relative address
// operand, that should be set to the absolute RVA in CODE section
Function OffsetShouldCorrect(ins1 : String) : Boolean;
Begin
  Result:=
    (ins1='call') or
    (ins1='jmp') or
    (ins1='jo') or
    (ins1='jno') or
    (ins1='jb') or
    (ins1='jnb') or
    (ins1='je') or
    (ins1='jne') or
    (ins1='jbe') or
    (ins1='jnbe') or
    (ins1='js') or
    (ins1='jns') or
    (ins1='jp') or
    (ins1='jnp') or
    (ins1='jl') or
    (ins1='jnl') or
    (ins1='jle') or
    (ins1='jnle') or
    (ins1='jz') or
    (ins1='jnz');
End;


// Description : Returns NULL string if the offset
//              specified in the operand is not in
//              the code section. There are 2 different
//              cases - PUSH and MOV.
//
// Last Modified : April 2000
//
function OffsetMightBeString(ins1,dta : String) : String;
var i : Integer;
    ofs{, sgm }: String;

begin
  Result:='';
  If (ins1='push')
     Then Begin
       ofs:=Copy(dta,2,Length(dta)-1);
       If (Copy(dta,1,1)='$') and (OffsetInSegment(HEX2DWORD(ofs),'CODE')) Then
         Begin
          Result:=ofs;
          Exit;
         End;
       if GlobCBuilder then
           If (Copy(dta,1,1)='$') and (OffsetInSegment(HEX2DWORD(ofs),'DATA')) Then
             Begin
              Result:=ofs;
              Exit;
             End;
     End;

  // all that is like mov %something%,$OFFSET%something%
  // is a potential string reference
  If ins1='mov' Then
     Begin
       i:=Pos(',',dta);
       If i<>0 Then
         Begin
           ofs:=Copy(dta,i+1,Length(dta)-i);
           TruncAll(ofs);
           If (ofs<>'') and (ofs[1]='$') Then
             Begin
               ofs:=Copy(ofs,2,Length(ofs)-1);
               If OffsetInSegment(HEX2DWORD(ofs),'CODE') Then
                 Begin
                   Result:=ofs;
                   Exit;
                 End;
               if GlobCBuilder then
                   If OffsetInSegment(HEX2DWORD(ofs),'DATA') Then
                     Begin
                       Result:=ofs;
                       Exit;
                     End;
             End;
         End;
     End;
end;


// Description : Finds Symbol CALL references
//
// Last Modified : April 2000
//
Function GetSymbolReference(AwdOffset : DWORD) : String;
Var buff,buff1 : TSymBuffer;
    bk,phys : Cardinal;
    i,j : Integer;
    Sym : TDeDeSymbol;
    s,sc : String;
    b : Byte;
    OffsInfStr : TOffsInfStruct;
    RefLst, SmartLst : TStringList;
    bFound : Boolean;
Begin
  Result:='';
  OffsInfStr:=nil;
  // saves the PEStream postion
  bk:=CurrentPEStream.Position;
  // Gets the physical offset of the addres of
  // the procedure thet is being called
  phys:=CurrentPEGetPhys(HEX2DWORD(DWORD2HEX(AwdOffset)));
  if Int64(phys)+_PatternSize>=CurrentPEStream.Size then exit;

  if bSMARTMODE Then
    begin
      sc:=GetRegVal(rgEAX);
      OffsInfStr:=OffsInfArchive.GetOffsInfoByClassName(sc);
    end;

  RefLst:=TStringList.Create;
  SmartLst:=TStringList.Create;
  Try
    CurrentPEStream.Seek(phys,soFromBeginning);
    // reads the procedure bytes in buff1
    CurrentPEStream.ReadBuffer(buff[1],_PatternSize);

    // if the first read byte is not found in the
    // First byte set then skip searching fo that reference
    if FirstByteSet*[buff[1]]=[] then Exit;

    // removes all absolute offsets
    UnlinkCalls(buff,0,rva);

    // Loops among the all loaded symbols
    For i:=0 To SymbolsList.Count-1 Do
      Begin
        // Gets a symbol
        Sym:=TDeDeSymbol(SymbolsList[i]);

        // the current symbol file is not for the current Delphi version
        // so process next DSF
        if (Sym.Mode and DeDeCoreContext.DelphiVersionCompatibility)=0 then Continue;

        // initializes the streams
        Sym.Sym.Seek(0,soFromBeginning);
        Sym.Str.Seek(0,soFromBeginning);
        // Loops among the entries
        For j:=0 To Sym.Count-1 Do
          Begin
            // Reads the pattern
            Sym.Sym.ReadBuffer(buff1[1],_PatternSize);
            // and compare it to buff1
            If CompareMem(@buff[1],@buff1[1],_PatternSize) Then
               Begin
                 // If equal, then a reference is found
                 // goes to the offset of the procedure name
                 // in the DeDeSymbol object
                 Sym.Str.Seek(Sym.Index[j],soFromBeginning);
                 Sym.Str.ReadBuffer(b,1);
                 // Reads the procedure name
                 s := ReadAnsiString(Sym.Str,b);
                 // And add it to the reference list
                 RefLst.Add(s);
               End;
          End;
      End;
  Finally
    // restores the PEStream position
    CurrentPEStream.Seek(bk,soFromBeginning);

    // Gets only those DSF references in which names
    // the EAX class name or it's parents is included
    if (bSMARTMODE) and (sc<>'') then
      begin
        bFound:=False;
        For i:=0 to RefLst.Count-1 Do
          if Pos(LowerCase(sc),LowerCase(RefLst[i]))<>0
            then begin
              bFound:=True;
              SmartLst.Add(RefLst[i]);
            end;

        if (not bFound) and (OffsInfStr<>nil) then
          for j:=0 to OffsInfStr.FHierarchyList.Count-1 do
            begin
              sc:=OffsInfStr.FHierarchyList[j];

              For i:=0 to RefLst.Count-1 Do
                if Pos(sc,RefLst[i])<>0
                  then begin
                    bFound:=True;
                    SmartLst.Add(RefLst[i]);
                  end;

              if bFound then Break;
            end;

         if bFound then RefLst.Assign(SmartLst);
      end;

    // Max 6 references
    While RefLst.Count>MAX_DSF_REFERENCES_COUNT do RefLst.Delete(RefLst.Count-1);

    For i:=0 to RefLst.Count-1 Do
      if i=0 then RefLst[i]:=sREF_TEXT_REF_DSF+' '+RefLst[i]
             else RefLst[i]:=sREF_TEXT_REF_DSF_OR+' '+RefLst[i];
    RefLst.Add('|');

    Result:=#13#10+RefLst.Text;

    RefLst.Free;
    SmartLst.Free;
  End;

End;


// Description : Finds CALL references
//
// Last Modified : N/A
//
Function RefCall(var ss : String; AwdOffset : DWORD) : String;
var b1,b2,b3,b4 : Byte;
    phys,ofs,bk : DWORD;
    s : String;
    i,j : Integer;
    cd : TClassDumper;
Begin
  Result:='';
  phys:=CurrentPEGetPhys(AwdOffset);
  if phys>=CurrentPEStream.Size Then Exit;

  // Reads the first 2 bytes of the procedure
  // that is being called.
  bk:=CurrentPEStream.Position;
  Try
    CurrentPEStream.Seek(phys,soFromBeginning);
    CurrentPEStream.ReadBuffer(b1,1);
    CurrentPEStream.ReadBuffer(b2,1);

    //In the case of import call
    If (b1=$FF) and (b2=$25) Then
      Begin
        CurrentPEStream.ReadBuffer(b1,1);
        CurrentPEStream.ReadBuffer(b2,1);
        CurrentPEStream.ReadBuffer(b3,1);
        CurrentPEStream.ReadBuffer(b4,1);
        ofs:=b1+b2*256+256*256*(b3+b4*256);
        // Gets the import function name
        If GlobGetImports Then
          begin
            //Dont
            Try
              s:=GetImportReference(DWORD2HEX(ofs));
            Except
              on e:Exception do Raise Exception.Create('Cant resolve import reference ');
            End;
            If s<>'' Then
            begin
              if DeDeCoreContext <> nil then
                DeDeCoreContext.CrossReferences.ResolveImportCall(
                  ProcRva, rva, s);
              Result:=#13#10+sREF_TEXT_IMPORT+' '+s+'()'#13#10+'|'+#13#10;
            end;
          end;
      End;
   Finally
     CurrentPEStream.Seek(bk,soFromBeginning);
   End;

  // If no other call reference is found then
  // searches for a SymbolReference
  If Result='' Then Result:=GetSymbolReference(AwdOffset);


  // This should find published/VIRT/USER
  // procedure call references
  if Result=#13#10'|'#13#10 then
    If ClsDmp<>nil Then
    For j:=0 To TClassesDumper(DeDeCoreContext.ClassesDumper).Classes.Count-1 Do
     Begin
       cd:=TClassDumper(
         TClassesDumper(DeDeCoreContext.ClassesDumper).Classes[j]);
        For i:=0 To cd.MethodData.Count-1 Do
          If TMethodRec(cd.MethodData.Methods[i]).dwRVA=AwdOffset
             Then Begin
                Result:=#13#10+sREF_TEXT_PUBLISHED+' '+cd.FsClassName+'.'+TMethodRec(cd.MethodData.Methods[i]).sName+'()'#13#10+'|'+#13#10;
                Exit;
             End;
     End;

  // If no other call reference is found
  // then name proc UNITOFFSET.PROC_OFFSET
  if Result=#13#10'|'#13#10 then
    if bUnitReferences then
      begin
        For i:=0 To TClassesDumper(DeDeCoreContext.ClassesDumper)
          .PackageInfoTable.dwUnitCount-2 do
           if (AwdOffset>=TClassesDumper(DeDeCoreContext.ClassesDumper)
              .PackageInfoTable.UnitsStartPtrs[i])
            and (AwdOffset<=TClassesDumper(DeDeCoreContext.ClassesDumper)
              .PackageInfoTable.UnitsStartPtrs[i+1])
               then begin
                  Result:=#13#10+sREF_TEXT_REF_DSF+' '+
                          TClassesDumper(DeDeCoreContext.ClassesDumper)
                          .PackageInfoTable.UnitsNames[i]+
                          '.Proc_'+DWORD2HEX(AwdOffset)+Result;
                  Break;
               end;
      end
      else Result:=#13#10#13#10;
End;


// Gets the ClassName of the ControlName
// Uses the DFMText TStringList to find it
Function GetControlClass(sControlName : String) : String;
var i,j : Integer;
Begin
 Result:='N.A.';

 // If DFMText is not loaded then use the Ex function
 // The class name is get from ClsDmp
 If (DFMText.Count=0) and (ClsDmp<>nil) then Result:=GetControlClassEx(ClsDmp.FsClassName,sControlName)
 else
   For i:=0 To DFMText.Count-1 Do
    Begin
     j:=Pos(sControlName+':',DFMText[i]);
     If j<>0 Then
       Begin
         Result:=Copy(DFMText[i],j+2+Length(sControlName),Length(DFMText[i])-j-Length(sControlName)-1);
         Break;
       End;
    End;
End;


// Gets the ClassName of the ControlName
// Uses the DFMText TStringList to find it
Function GetControlClassEx(sClassName, sControlName : String) : String;
var i,j : Integer;
    blah : TStringList;
Begin
 Result:='N.A.';

 blah:=TClassesDumper(DeDeCoreContext.ClassesDumper)
   .GetDFMTXTDATA(sClassName);
 if blah=nil then exit;

 For i:=0 To blah.Count-1 Do
  Begin
   j:=Pos(sControlName+':',blah[i]);
   If (j<>0) and (Pos('''',blah[i])=0) Then
     Begin
       Result:=Copy(blah[i],j+2+Length(sControlName),Length(blah[i])-j-Length(sControlName)-1);
       Break;
     End;
  End;
End;

// Gets the event prototype searching the class data provided from classes.lst
Function GetEventPrototype(sClassName, sHandlerName : String) : String;
var i,j,jPos : Integer;
    blah : TStringList;
    sType, sEvent, sEventType : String;
Begin
 Result:='procedure(Sender : TObject);';

 blah:=TClassesDumper(DeDeCoreContext.ClassesDumper)
   .GetDFMTXTDATA(sClassName);
 if blah=nil then exit;

 sEvent:='';
 For i:=1 to blah.Count-1 Do
   begin
    j:=Pos(' = '+sHandlerName,blah[i]);
    If (j<>0) and (Pos('''',blah[i])=0) Then
      begin
       sEvent:=Trim(Copy(blah[i],1,j));
       break;
      end;
   end;
 if sEvent='' then exit;

 blah:=DeDeCoreContext.ClassInfoList;
 if blah=nil then exit;

 jPos:=0;
 For i:=0 To blah.Count-1 Do
  Begin
   j:=Pos(sType+'(',blah[i]);
   If (j<>0) Then
     Begin
       jPos:=i;
       break;
     End;
  End;
 if jPos=0 then exit;

 sEventType:='';
 For i:=jPos to blah.Count-1 Do
   begin
    j:=Pos(sEvent+':',blah[i]);
    If (j<>0) Then
      begin
       sEventType:=Trim(Copy(blah[i],j+1,Length(blah[i])-j));
       break;
      end;
   end;
 if sEventType='' then exit;

 For i:=0 To blah.Count-1 Do
  Begin
   j:=Pos(sEventType+'=',blah[i]);
   If (j<>0) Then
     Begin
       Result:=Copy(blah[i],j+1,Length(blah[i])-j);
       break;
     End;
  End;

end;


// Description : Finds a control references
//
// TODO : ControlIDs and ControlNames should be
//        cut from DeDeDisAsm and ClsDmp.Fields object
//        should be used instead
//
// Last Moified : N/A
//
Function ControlRef(dta : String; sReg, sDestReg : String): String;
var ce, cn, s,st : String;
    i : Integer;
    cls : TClassDumper;
Begin
  s:=''; dta:=dta+']'; i:=1;
  while dta[i]<>']' do inc(i);
  dta:=copy(dta,1,i-1);

  // Offset list is stored with this mask (8 zeros)
  While Length(dta)<8 Do dta:='0'+dta;

  // Get Owner Class Name from Class Emulator
  ce:=DeDeClassEmulator.GetRegVal(Str2TRegister(sReg));

  // Get TClassDump data from class emulator class name
  cls:=nil;
  if (GlobBEmulation) and (not GlobCBuilder) and (ce<>'')
      then cls:=TClassesDumper(DeDeCoreContext.ClassesDumper)
        .GetClassWFields(ce);

  // If not such class then use the current !!!
  if cls=nil then i:=ControlIDs.IndexOf(dta)
             else i:=cls.FieldData.GetFieldIdx(HEX2DWORD(dta));

  If i<>-1 Then
    Begin
      if cls=nil then cn:=ControlNames[i]
                 else cn:=cls.FieldData.GetFieldName(HEX2DWORD(dta));

      if cls=nil then st:=GetControlClass(cn)
                 else st:=GetControlClassEx(ce,cn);

      if cls=nil then ce:='' else ce:=ce+'.';
      Result:=#13#10+sREF_TEXT_CONTROL+' '+ce+cn+' : '+st+''+#13#10+'|'+#13#10;


      // Change Class Emulator Register Classes
      DeDeClassEmulator.SetRegVal(Str2TRegister(sDestReg),st);
      bControlRef:=True;
    End
    Else Begin
      if (GlobBEmulation) and (ce<>'') then
       begin
          bControlRef:=True;
          if OffsInfArchive.GetReferenceEx(ce,HEX2DWORD(dta),rtMOV,cn,st)
           then begin
             if st<>'' then cn:=ce+'.'+cn+' : '+st
                       else cn:=ce+'.'+cn;
             Result:=#13#10+sREF_TEXT_FIELD+' '+cn+#13#10+'|'+#13#10;

             // Set That Source has been accessed - Inc Time-To-Live
             ExpireCounter[Str2TRegister(sReg)]:=ExpireCount;
           end
           else if HEX2DWORD(dta)<>0 then
              begin
                st:='';
                cn:=ce+'.'+'OFFS_'
                    // Remove the first 4 zeros
                    +Copy(dta,5,4);
                Result:=#13#10+sREF_TEXT_FIELD+' '+cn+#13#10+'|'+#13#10;
              end;

          // Change Class Emulator Register Classes
          DeDeClassEmulator.SetRegVal(Str2TRegister(sDestReg),st);
       end
       // In sDestReg is put unrecognized public field of the Form - so cut this register
       else ClearRegister(Str2TRegister(sDestReg));   
    End;
End;


// Returns true if the current instruction is
// the beginning of a TRY block
Function IsTryExceptBlock : Boolean;
var bk : DWORD;
    ph : DWORD;
    t_e_str : String;
Begin
   // sTRY_1e = '64FF30648920';// push dword ptr fs:[eax]; mov fs:[eax], esp
   // sTRY_2e = '64FF32648922';// push dword ptr fs:[edx]; mov fs:[edx], esp
   // sTRY_3e = '64FF31648921';// push dword ptr fs:[ecx]; mov fs:[ecx], esp
   bk:=CurrentPEStream.Position;
   Try
     ph:=CurrentPEGetPhys(RVA);
     CurrentPEStream.Seek(ph,soFromBeginning);
     SetLength(t_e_str,6);
     CurrentPEStream.ReadBuffer(t_e_str[1],6);
     Result:=   (t_e_str=#$64#$FF#$30#$64#$89#$20)
             or (t_e_str=#$64#$FF#$32#$64#$89#$22)
             or (t_e_str=#$64#$FF#$31#$64#$89#$21);
   Finally
     CurrentPEStream.Seek(bk,soFromBeginning);
   End;
End;

// Returns true if the current instruction is
// the beginning of a EXCEPT-END block
Function IsExceptBlock : Boolean;
var bk : DWORD;
    ph : DWORD;
    b : Byte;
    t_e_str : String;
Begin
   bk:=CurrentPEStream.Position;
   Try
     ph:=CurrentPEGetPhys(RVA);
     CurrentPEStream.Seek(ph+3,soFromBeginning);
     SetLength(t_e_str,1);
     CurrentPEStream.ReadBuffer(t_e_str[1],1);
     Result:=t_e_str[1]=#$EB;
     If Result Then Begin
       CurrentPEStream.ReadBuffer(b,1);
       LastPush:=rva+b+5;
     End;
   Finally
     CurrentPEStream.Seek(bk,soFromBeginning);
   End;
End;


// Returns true if the current instruction is
// the beginning of a FINALLY-END block
Function IsFinallyBlock : Boolean;
var bk : DWORD;
    ph,dw : DWORD;
    t_e_str : String;
Begin
   bk:=CurrentPEStream.Position;
   Try
     ph:=CurrentPEGetPhys(RVA);
     CurrentPEStream.Seek(ph+3,soFromBeginning);
     SetLength(t_e_str,1);
     CurrentPEStream.ReadBuffer(t_e_str[1],1);
     Result:=t_e_str[1]=#$68;
     If Result Then Begin
       CurrentPEStream.ReadBuffer(dw,4);
       LastPush:=dw;
     End;
   Finally
     CurrentPEStream.Seek(bk,soFromBeginning);
   End;
End;

// If the current RVA is the END rva of a
// try-except or try-finally block then
// the reference is attached
function ReachedEND : String;
var i : Integer;
Begin
 Result:='';
 For i:=ENDPtrList.Count-1 DownTo 0 Do
   If StrToInt64(ENDPtrList[i])=rva
     Then Begin
       ENDPtrList.Delete(i);
       Result:=#13#10+sREF_TEXT_END+#13#10+'|'#13#10;
     End;
End;


// If the current RVA is the EXCEPT rva of a
// try-except block then the reference is attached
Function ReachedExcept : String;
var i : Integer;
Begin
 Result:='';
 For i:=SEHPtrList.Count-1 DownTo 0 Do
   If StrToInt(SEHPtrList[i])=rva
     Then Begin
       SEHPtrList.Delete(i);
       Result:=#13#10+sREF_TEXT_EXCEPT+#13#10+'|'#13#10;
     End;
End;

// Here different references are find
// and comments are glued to the code
// ss is the ASM line
function ReplaseReferences(var ss : String) : String;
Var ins1,dta, sof, ofs  : String;
    i,ps : Integer;
    idx : ShortInt;
    dwdta,bk : Cardinal;
Begin
   Result:='';
   // Finds the firts space in the string
   i:=Pos(#32,ss);
   // Gets the instruction
   ins1:=Copy(ss,1,i-1);
   // Gets the operands
   dta:=Copy(ss,i+1,Length(ss)-i);
   // Removes spaces at the beginning and at the and
   TruncAll(dta);
   // If not operands then nothing to handle
   If dta='' Then Exit;


   ///////////////////////////////////////////////
   //// try-finally and try-except references ////
   ///////////////////////////////////////////////

   // Put END if needed
   If ENDPtrList.Count<>0 Then
      Result:=ReachedEND;

   // Put EXCEPT if needed
   If SEHPtrList.Count<>0
      Then Result:=Result+ReachedExcept;

   If bCommentNext Then
     Begin
       // the instruction after the next push should be marked as FINALY
       Result:=Result+#13#10+sREF_TEXT_FINALLY+#13#10+'|'#13#10;
       bCommentNext:=False;
     End;

   // saves last push - to be proceeded if try is detected
   If (ins1='push') and (Copy(dta,1,1)='$') then LastPush:=HEX2DWORD(Copy(dta,2,Length(dta)-1));
   // Check For TRY
   bTryBlockFound:=False;
   If    (ss='push    dword ptr fs:[eax]')
      or (ss='push    dword ptr fs:[ecx]')
      or (ss='push    dword ptr fs:[edx]')
      Then Begin
        // Try-Exept-Finally Detected
        If (IsTryExceptBlock) Then
           Begin
            SEHPtrList.Add(IntToStr(LastPush));
            Result:=#13#10+sREF_TEXT_TRY+#13#10+'|'#13#10;
            bTryBlockFound:=True;
           End;
      End;

   // Check For EXCEPT or FINALLY
   If    (ss='mov     fs:[eax], edx')
      Then Begin
        // Try-Exept-Finally Detected
        If (IsExceptBlock) Then
           Begin
            // pushed the END offset
            ENDPtrList.Add(IntToStr(LastPush));
           End;
        If (IsFinallyBlock) Then
           Begin
             // removes the try pushed offset
             If SEHPtrList.Count<>0 Then SEHPtrList.Delete(SEHPtrList.Count-1);
             // pushed the END offset
             ENDPtrList.Add(IntToStr(LastPush));
             // one ret should be skiped
             Inc(bTryExcept);
             // next instruction should be commented with FINALLY
             bCommentNext:=True;
           End;
      End;


   ///////////////////////////////////////////////
   ///////////// Control References //////////////
   ///////////////////////////////////////////////
   //
   // normaly they are : mov eax, [eax+$xxxx]
   //               or : mov eax, [ebx+$xxxx]
   //               or : mov eax, [esi+$xxxx]
   //               or : mov edx, [eax+$xxxx]
   //
   // $xxxx is the control ID, specified in the ClassInfo block
   //
{   ps:=Pos(', [eax+$',dta);
   if ps=0 then ps:=Pos(', [ebx+$',dta);
   if ps=0 then ps:=Pos(', [esi+$',dta);
   if ps=0 then ps:=Pos(', [edx+$',dta);}
   ps:=Pos('[eax+$',dta);
   if ps=0 then ps:=Pos('[ebx+$',dta);
   if ps=0 then ps:=Pos('[esi+$',dta);
   if ps=0 then ps:=Pos('[edx+$',dta);
   If (ps<>0) and ((ins1='mov') or (ins1='lea') or (ins1='cmp')) Then
      Begin
        Dec(ps,2); //Correction for ', '
        sof:=ControlRef(Copy(dta,ps+8,4),Copy(dta,ps+3,3),Copy(dta,ps-3,3));
        If sof<>'' Then
          Begin
            Result:=Result+sof;
            Exit;
          End;
      End;


   ///////////////////////////////////////////////
   ///////////// String References ///////////////
   ///////////////////////////////////////////////
   //
   // if a 'push offset' or 'mov register, offset'
   // and this offset is in the CODE section it
   // can contain a string. Check this
   //
   If (ins1='push') or (ins1='mov') Then
     Begin
       ofs:=OffsetMightBeString(ins1,dta);
       If ofs<>''
         Then Begin
           bk:=CurrentPEStream.Position;
           Try
             If not bTryBlockFound Then
              begin
               sof:=GetStringReference(ofs);
               If sof<>'' Then
                   Result:=Result+#13#10+sREF_TEXT_REF_STRING+' '''+sof+''''#13#10+'|'#13#10;
              end;     
           Finally
             CurrentPEStream.Seek(bk,soFromBeginning);
           End;
           Exit;
         End
         Else Begin
           // It could be mov eax, dword ptr [$offset]
           // and this can be a handle to a form or also
           // it can be a Constant Reference
           // this can be imroved in future
         End;
       End;

   ///////////////////////////////////////////////
   ////////////// Call References ////////////////
   ///////////////////////////////////////////////
   //
   // First of all it the instruction is a relative
   // jump or call then the real RVA should be shown !
   //
   If OffsetShouldCorrect(ins1) Then
     Begin
       Case dta[1] of
         '-' : idx:=-1;
         '+' : idx:=1
         else Exit;
       End;
       sof:=Copy(dta,3,Length(dta)-2);
       dwdta:=idx*HEX2DWORD(sof);
       dwdta:=dwdta+rva+sz;
       while Length(ins1)<8 do ins1:=ins1+' ';
       ss:=ins1+DWORD2HEX(dwdta);

       // This finds all the call references
       if ins1='call    ' then
          Result:=RefCall(ss,dwdta);
       exit;
     End;
End;

// procedure DisassembleProc(NameP,S : String; var DasmList : TStringList; bNotClearText : Boolean = True; Custom : Boolean = False);
//
// Description : Disaasembles procedure.
//
//     DeDeDisAsm.PEStream, PEHeader, RVAConverter, DFMText,
//               , ControlIDs, ControlNames, ClsDmp and SymbolList
//     should be set before calling this procedure. Their meaning is
//     the following:
//
//       *) PEStream is the file, if not set exception will occure
//       *) PEHeader is the PE header of the file, if not set exception will occure
//       *) RVAConverter is used to convert RVAs to Physical offsets, if not set exception will occure
//       *) DFMText is the text representation of the DFM resources of the current form.
//           if not set control references will not have the class names of controls
//       *) ControlIDs and ControlNames are the IDs and names of the controls in the form
//           if not set no control references will be found
//       *) ClsDmp is the TClassDumper object of the current class
//           if not set no published/VIRT/USER proc references will be found
//       *) SymbolList is a TList with loaded TDeDeSymbol objects
//           if not set no calls to VCL and other BPLs will be found
//
//    Parameter Description:
//       NameP         : Unit name
//       S             : Procedure Name
//       DasmList      : A TStringList that will contain the result
//                       of disassembling. This object should not be
//                       created before calling the DisassembleProc().
//                       If is created from the procedure itself. The
//                       calling procedure should free this object after
//                       assign the lines to another TStringList or after
//                       saving it to a file. 
//       bNotClearText : If Flase then NameP is the unit name and
//                       S is the rocedure name, that should exist in the
//                       ClsDmp object MethodList.
//                       If True then NameP is the unit name, ending with
//                       '.pas' and S is the full name of the procedure
//                       like in pascal implementation part. For example:
//                       NameP = Unit11.pas
//                       s     = procedure TForm11.CaptionMaskMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
//                       (NOTE: this flag is used to differ normal disassembly from
//                        saving a Delphi project space. There is no special reason of
//                        having this parameter and DisassemblerProc() does the same
//                        things in the both cases. The default value is TRUE)
//       Custom        : If TRUE then the DisassembleProc will not seek for the
//                       proc RVA addres and will start to dissasebmle from the current
//                       position of the CurrentPEStream. If this parameter is not specified then
//                        the default value is FALSE
//
//       EmulateOnly   : If TRUE then ptocedure is only emulated to dwEmulateToOffset offset.
//                       This is used to initialize registes when disassembling subprocedures
//
//      dwEmulateToOffset : The end offset (excluding it) to where the procedure should be
//                       emulated. If this offset is beyond the end of the procedure emulation
//                       ends with the end of the procedure. If it is zero then no emulation is
//                       done at all.
//
// Last Modified : 11.I.2001
//
procedure DisassembleProc(NameP,S : String; var DasmList : TStringList; bNotClearText : Boolean = True; Custom : Boolean = False; EmulateOnly : Boolean = False; dwEmulateToOffset : DWORD = 0);
var iStopIndex, i,k,locpos, InstrId : Integer;
    CallReferenceIndex, PendingCallIndex, RegisterIndex: Integer;
    RegisterWriteMask: Byte;
    LastRegisterWriteRVA: array[0..2] of DWORD;
    HasLastRegisterWrite: array[0..2] of Boolean;
    CallerCleanupBytes: LongWord;
    ss : String;
    DASM : TDisAsm;
    pc: AnsiString;
    op,srf,locvar : String;

begin
  // Creates The Result
  DasmList:=TStringList.Create;

  if not Custom then
    if GlobBEmulation then
      if not GlobCustomEmulInit
          then InitNewEmulation('','','','');

  rva:=0;
  PendingCallIndex := -1;
  If Not Custom Then
  Begin
  // This retreives the RVA offsets of the first instruction
  // and moves the steram pointer to this offset
   If bNotClearText Then
     Begin
       i:=Pos('.',NameP);
       NameP:=Copy(NameP,1,i-1);
     End;

    If bNotClearText Then
     Begin
      i:=Pos('.',S);
      s:=Copy(s,i+1,Length(s)-i);
      i:=Pos('(',s);
      s:=Copy(s,1,i-1);
     End;

    rva:=ClsDmp.GetMethodRVA(s);

    if GlobBEmulation then
      if not GlobCustomEmulInit then
         InitNewEmulation(ClsDmp.FsClassName,'','','');

    ss:=DWORD2HEX(CurrentPEGetPhys(rva));
    CurrentPEStream.Seek(HEX2DWORD(ss),soFromBeginning);
  End
  // Else if bCustom=True, the Stream is set to this first
  // instruction and need just to get its RVA address
  Else rva:=CurrentPEGetRVA(CurrentPEStream.Position);

  If rva=0 then Exit;
  ProcRva:=rva;
  if DeDeCoreContext <> nil then
    DeDeCoreContext.CrossReferences.BeginRoutine(ProcRva);
  for RegisterIndex := 0 to 2 do
  begin
    HasLastRegisterWrite[RegisterIndex] := False;
    LastRegisterWriteRVA[RegisterIndex] := 0;
  end;

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//////////// The Main Diassembly Loop /////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

   // Creates the OPCODE_to_ASM disassembler object
   DASM:=TDisAsm.Create;
   DASM.OnRef:=RecordDisasmReference;

   // The number of the current instruction
   InstrId:=0;
   // Stop if this insruction number is reached.
   iStopIndex:=-1;

    Try
     Try
      // Clears SEH List (try_except and try_finally blocks)
      SEHPtrList.Clear;

      // Initialize the number of found TRY blocks to 0
      // (this is used for the both try_finally and
      // for try_except blocks)
      bTryExcept:=0;

      // Clears the list with END_try and END_fynally offsets
      ENDPtrList.Clear;

      // Initialize the last short jump otside the current RVA
      // to 'not present'
      LastJump:=0;

      // Inititaliza the size of the last instruction in bytes to 0
      sz:=0;

      Repeat
        Repeat
          // Sets lenth in bytes of the largest instruction
          SetLength(pc,17);
          // Reads next byets
          CurrentPEStream.ReadBuffer(pc[1],16);
          // Disassembels them
          ss:=DASM.GetInstruction(PAnsiChar(pc),sz,16);
          Inc(InstrId);

          CallReferenceIndex := -1;
          if DeDeCoreContext <> nil then
          begin
            if PendingCallIndex >= 0 then
            begin
              if TryGetCallerStackCleanup(@pc[1], sz, CallerCleanupBytes) then
                DeDeCoreContext.CrossReferences.SetCallerCleanup(
                  PendingCallIndex, CallerCleanupBytes);
              PendingCallIndex := -1;
            end;
            DeDeCoreContext.CrossReferences.RecordRoutineInstruction(
              ProcRva, rva, @pc[1], sz);
            CallReferenceIndex :=
              DeDeCoreContext.CrossReferences.AddX86Instruction(
                ProcRva, rva, @pc[1], sz);
            if CallReferenceIndex >= 0 then
            begin
              for RegisterIndex := 0 to 2 do
                if HasLastRegisterWrite[RegisterIndex] then
                  DeDeCoreContext.CrossReferences.AddRegisterWriteEvidence(
                    CallReferenceIndex, RegisterIndex,
                    LastRegisterWriteRVA[RegisterIndex]);
              PendingCallIndex := CallReferenceIndex;
            end;
          end;

          if (CallReferenceIndex >= 0) or
            IsX86BranchInstruction(@pc[1], sz) then
          begin
            for RegisterIndex := 0 to 2 do
              HasLastRegisterWrite[RegisterIndex] := False;
          end
          else if not GetX86RegisterWriteMask(@pc[1], sz,
            RegisterWriteMask) then
          begin
            for RegisterIndex := 0 to 2 do
              HasLastRegisterWrite[RegisterIndex] := False;
          end
          else
            for RegisterIndex := 0 to 2 do
              if (RegisterWriteMask and (1 shl RegisterIndex)) <> 0 then
              begin
                HasLastRegisterWrite[RegisterIndex] := True;
                LastRegisterWriteRVA[RegisterIndex] := rva;
              end;

          // If the current instruction is a short jump ahead
          // then sets the LastJump
          If (ORD(pc[1]) in [$70..$7F,$EB]) and
             (ORD(pc[2])<$7F) Then
             if LastJump<rva+2+ORD(pc[2])
                then LastJump:=rva+2+ORD(pc[2]);

          // If the last short jump ahead is passed
          // sets the last jump to zero
          If LastJump<=rva Then LastJump:=0;

          // Finds all kind of references and attches them before
          // the disassembeld instruction
          bControlRef:=False;

            srf:=ReplaseReferences(ss);

            // More references !!!
            if     (GlobBEmulation)
               // if control reference is found then skip emulation
               and (not bControlRef) then
             begin
                EmulateInstruction(pc,sz,ss,ss);
                If bReference then
                  begin
                    if srf='' then srf:=#13#10;
                    ///////////////////////////////////////////////////////
                    // srf:=srf+'* '+sReference+#13#10+'|'#13#10;
                    // '* ' was removed when made references texts standart
                    ///////////////////////////////////////////////////////
                    srf:=srf+sReference+#13#10+'|'#13#10;
                  end;
             end;


            //Gets Local Var References
            locpos:=Pos('[ebp-$',ss);
            if locpos=0 then locpos:=Pos('[ebp+$FFFF',ss);
            if locpos<>0 then
              begin
                locvar:=Copy(ss,locpos,locpos+10);
                locpos:=Pos(']',locvar);
                locvar:=Copy(locvar,1,locpos);
                AddNewExpression(ProcRVA,locvar,'');
              end;

            // Gets the string representation of OPCODEs
            op:='';
            For k:=1 To sz Do op:=op+Byte2HEX(ORD(pc[k]));
            While Length(op)<20 Do op:=op+' ';

            // Adds the current instruction and references to the
            // result StringList
            if not EmulateOnly then
               DasmList.Add(srf+DWord2HEX(rva)+'   '+op+'   '+ss);

          // Calculates the RVA address of the next instruction
          rva:=rva+sz;

          // If it is emulation and end offset is reached then exit proc
          if (EmulateOnly) and (rva>=dwEmulateToOffset) then exit;

          // Moves the pointer in the stream at the beginning
          // of the next instruction according to the last
          // instruction size in bytes. 16 is the max length of
          // an instruction
          CurrentPEStream.Seek(sz-16,soFromCurrent);

          // This is especially for the Delphi compiler
          // This can be and of a procedure. This is
          // used to find the end of the DPR code and
          // in some other special cases
          if (ss='add     [eax], al') and (SEHPtrList.Count=0) then
              break;

          // This is the first instruction and it is jump to offset. Probably
          // from import section. Stop Disassembly after.
          If (ORD(pc[1])=$FF) and (ORD(pc[2])=$25) and (InstrId=1)
             Then iStopIndex:=2;

          // If we should stop then exit
          if InstrId=iStopIndex then exit;

        // Repeats disassembly until a 'RET' has been reached
        Until copy(ss,1,3)='ret';

        // Decreases the number of try blocks
        Dec(bTryExcept);

        // Adds an empty line to the result StringList
        DasmList.Add('');

      // Repeats until all try blocks has been closed
      Until (SEHPtrList.Count=0) and (bTryExcept<0) and (LastJump=0);

     Except
      On E:Exception Do
        sDisAsmErrors:=sDisAsmErrors+#13#10+
            'Exception: '+E.Message+#13#10+
            'Proc Name: '+NameP+'.'+s+#13#10+
            'Last Instruction: '+DWord2HEX(rva)+'   '+op+'   '+ss+#13#10+
            'Current Position: '+IntToHex(CurrentPEStream.Position,8)+
            #13#10;
     End;
    Finally
      // Frees the TDASM object
      DASM.Free;

      // Restore Disassembly Options. They should be set before every call to DiassembleProc!!
      DisassemblerOptions.Imports:=True;
      DisassemblerOptions.EnglishStrings:=True;
      DisassemblerOptions.NonEnglishStrings:=True;
    End;
    
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//////////// End Of The Main Diassembly Loop //////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
end;


function GetNextProcRVA(dwRVA : DWORD; var bFound : Boolean; bSkipBetweenCodeFillRecognition : Boolean = False) : DWORD;
var  DASM : TDisAsm;
     phys : DWORD;
     pc : AnsiString;
     ss : String;
     sz{,i} : LongInt;

  procedure StopAtStreamEnd;
  begin
    bFound:=False;
    Result:=0;
    DeDeCoreContext.ReportWarning(Format(
      'Procedure scan from RVA %s stopped at file offset %s (stream size %s)',
      [DWORD2HEX(dwRVA),IntToStr(CurrentPEStream.Position),
       IntToStr(CurrentPEStream.Size)]));
  end;
begin
   DASM:=TDisAsm.Create;

   try
     bFound:=False;
     phys:=CurrentPEGetPhys(dwRVA);
     CurrentPEStream.Seek(phys,soFromBeginning);
     rva:=dwRVA;

     Result:=0;
     if (phys<=0) then Exit;
     if (phys>=CurrentPEStream.Size) then Exit; 

     SEHPtrList.Clear;
     bTryExcept:=0;
     ENDPtrList.Clear;
     LastJump:=0;
     sz:=0;
     Repeat
       Repeat
          if CurrentPEStream.Position>CurrentPEStream.Size-16 then
          begin
            StopAtStreamEnd;
            Exit;
          end;
          SetLength(pc,17);
          CurrentPEStream.ReadBuffer(pc[1],16);
          ss:=DASM.GetInstruction(PAnsiChar(pc),sz,16);
          if (sz<1) or (sz>16) then
          begin
            DeDeCoreContext.ReportWarning(Format(
              'Procedure scan from RVA %s stopped on invalid instruction size %d',
              [DWORD2HEX(dwRVA),sz]));
            Exit;
          end;

          If (ORD(pc[1]) in [$70..$7F,$EB]) and
             (ORD(pc[2])<$7F) Then
             if LastJump<rva+2+ORD(pc[2])
                then LastJump:=rva+2+ORD(pc[2]);
          If LastJump<=rva Then LastJump:=0;

          If ENDPtrList.Count<>0 Then ReachedEND;
          If SEHPtrList.Count<>0 Then ReachedExcept;

          If ORD(pc[1])=$68 then LastPush:=ORD(pc[2])+ORD(pc[3])*256+(ORD(pc[4])+ORD(pc[5])*256)*256*256;
          bTryBlockFound:=False;
          If Copy(pc,1,6)=#$64#$FF#$30#$64#$89#$20 Then
              Begin
                 SEHPtrList.Add(IntToStr(LastPush));
                 bTryBlockFound:=True;
              End;

          If Copy(pc,1,3)=#$64#$89#$10
             Then Begin
               If pc[4]=#$EB Then ENDPtrList.Add(IntToStr(LastPush));
               If pc[4]=#$68 Then
                  Begin
                    If SEHPtrList.Count<>0 Then SEHPtrList.Delete(SEHPtrList.Count-1);
                    ENDPtrList.Add(IntToStr(LastPush));
                    Inc(bTryExcept);
                   End;
             End;

           rva:=rva+sz;
           CurrentPEStream.Seek(sz-16,soFromCurrent);

           if (ORD(pc[1])=0) and (ORD(pc[2])=0) then break;
        Until Copy(ss,1,3)='ret';

        Dec(bTryExcept);
      Until (SEHPtrList.Count=0) and (bTryExcept<0) and (LastJump=0);

      Result:=rva;
      If bSkipBetweenCodeFillRecognition then Exit;


      //Result:=0;


      // separators
      // 1 byte : 90       nop
      // 2 byte : 8BC0     mov eax, eax
      // 3 byte : 8D4000   lea eax, [eax+00]
      // end_of_procs = 0000, 00FFFFFF
     bFound:=True;
     If (pc[sz+1]=#$90) then Inc(rva,1) else
     If (pc[sz+1]=#$8B) and (pc[sz+2]=#$C0) then Inc(rva,2) else
     If (pc[sz+1]=#$8D) and (pc[sz+2]=#$40) and (pc[sz+3]=#$00) then Inc(rva,3) else

     If (pc[sz+1] in [#$55,#$83]) then asm NOP end else
       begin
         //bFound:=False;
         //procs starting with 00 or FF are not procs
         If (pc[sz+1]=#$FF) then bFound:=False;
         if (pc[sz+1]=#$00) and (pc[sz+2] in [#$00,#$FF]) then bFound:=False;
         //procs finishing with 0000 are not procs
         if (ORD(pc[1])=0) and (ORD(pc[2])=0) then bFound:=False;

         if not bFound then
          begin
           repeat
              if CurrentPEStream.Position>=CurrentPEStream.Size then
              begin
                StopAtStreamEnd;
                Exit;
              end;
              CurrentPEStream.ReadBuffer(pc[1],1);
              Inc(rva);
            until pc[1] in [#$55,#$83];
           bFound:=pc[1] in [#$55,#$83]
         end;

       end;

     Result:=rva;

  Finally
    DASM.Free;
  End;
end;

//////////////////////////////////////////////////////
//   Seeks InitUnits routine from system.pas
// and returns its phisical offset
/////////////////////////////////////////////////////
Function GetInitUnitsProcRVA : DWORD;
var l, iiDW : DWORD;
    buff : TSymBuffer;
    ImageFile: ThePEFile;
begin
  iiDW:=0;
  ImageFile := DeDeCoreContext.PEFile;
  if ImageFile = nil then
    raise EInvalidOp.Create('No PE file is available for unit initialization');
  ImageFile.PEStream.BeginSearch;
  Try
    For l:=0 to ImageFile.PEStream.Size-sizeOf(buff)-1 Do
      begin
        ImageFile.PEStream.Seek(l,soFromBeginning);
        ImageFile.PEStream.ReadBuffer(buff,sizeof(buff));

        If DelphiVersion='D2' then
         begin
            If (buff[1]=$55) and (buff[12]=$85) and (buff[13]=$C0) and (buff[14]=$74) and (buff[15]=$4B)
             then begin
                UnlinkCalls(buff);
                if CompareMem(@buff[1], @D2_InitUnitsIdent[1], 49) then
                  begin
                    // InitInstance Procedure Found
                    iiDW:=l;
                    break;
                  end;
             end;
         end; {Delphi5 Recognition}

        If DelphiVersion='D3' then
         begin
            If (buff[1]=$55) and (buff[12]=$85) and (buff[13]=$C0) and (buff[14]=$74) and (buff[15]=$4B)
             then begin
                UnlinkCalls(buff);
                if CompareMem(@buff[1], @D3_InitUnitsIdent[1], 49) then
                  begin
                    // InitInstance Procedure Found
                    iiDW:=l;
                    break;
                  end;
             end;
         end; {Delphi5 Recognition}

        If DelphiVersion='D4' then
         begin
            If (buff[1]=$55) and (buff[12]=$85) and (buff[13]=$C0) and (buff[14]=$74) and (buff[15]=$4B)
             then begin
                UnlinkCalls(buff);
                if CompareMem(@buff[1], @D4_InitUnitsIdent[1], 49) then
                  begin
                    // InitInstance Procedure Found
                    iiDW:=l;
                    break;
                  end;
             end;
         end; {Delphi4 Recognition}

        If DelphiVersion='D5' then
         begin
            If (buff[1]=$55) and (buff[12]=$85) and (buff[13]=$C0) and (buff[14]=$74) and (buff[15]=$4B)
             then begin
                UnlinkCalls(buff);
                if CompareMem(@buff[1], @D4_InitUnitsIdent[1], 49) then
                  begin
                    // InitInstance Procedure Found
                    iiDW:=l;
                    break;
                  end;
             end;
         end; {Delphi5 Recognition}

        If (DelphiVersion='D6') or (DelphiVersion='D6 CLX') then
         begin
            If (buff[1]=$55) and (buff[12]=$85) and (buff[13]=$C0) and (buff[14]=$74) and (buff[15]=$4B)
             then begin
                UnlinkCalls(buff);
                if CompareMem(@buff[1], @D6_InitUnitsIdent[1], 49) then
                  begin
                    // InitInstance Procedure Found
                    iiDW:=l;
                    break;
                  end;
             end;
         end; {Delphi6 Recognition}

        If DelphiVersion='DConsole' then
         begin
            If (buff[1]=$55) and (buff[12]=$85) and (buff[13]=$C0) and (buff[14]=$74) and (buff[15]=$4B)
             then begin
                UnlinkCalls(buff);
                if CompareMem(@buff[1], @D6_InitUnitsIdent[1], 49) then
                  begin
                    // InitInstance Procedure Found
                    iiDW:=l;
                    break;
                  end;
             end;
         end; {Delphi6 Recognition}

      end;
  Finally
    ImageFile.PEStream.EndSearch;
  End;

  Result:=iiDW;
End;

initialization
  UnitList:=TStringList.Create;
  SEHPtrList:=TStringList.Create;
  ENDPtrList:=TStringList.Create;
  DFMText:=TStringList.Create;
  ControlNames:=TStringList.Create;
  ControlIds:=TStringList.Create;
  DisassemblerOptions.Imports:=True;
  DisassemblerOptions.EnglishStrings:=True;
  DisassemblerOptions.NonEnglishStrings:=True;

finalization
  UnitList.Free;
  SEHPtrList.Free;
  ENDPtrList.Free;
  DFMText.Free;
  ControlNames.Free;
  ControlIDs.Free;

end.
