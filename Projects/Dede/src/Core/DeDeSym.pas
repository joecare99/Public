unit DeDeSym;
//////////////////////////
// Last Change: 21.II.2001
//////////////////////////

interface

Uses Classes, DeDeClasses, DeDeConstants;

// DeDe Symbols ///////////////////////////////////////////////////////
Type
  TDeDePatternIndex = class
  public
    Index: Integer;
  end;

  TDeDeSymbol = Class
  private
    FPatternIndexes: array[Byte] of TList;
    FPatternIndexBuilt: Boolean;
    procedure ClearPatternIndexes;
  protected
    procedure UpdateFirstByteSet;
  public
    Sym   : TMemoryStream;
    Str   : TMemoryStream;
    Index : TBoundArray;
    Count : Integer;
    Comment : String;
    Mode  : Byte;
    PatternSize : Byte;
    FileName : String;
    Constructor Create; virtual;
    Function LoadSymbol(AsFileName : String) : Boolean;
    function FindMatches(const APattern: TSymBuffer;
      AVersionMask: Byte; AMatches: TStrings): Integer;
    Destructor Destroy; override;
  End;

  function GetVersionedDSFName(const ACompilerVersion: string): string;

  Function UnlinkCalls(Var buff : TSymBuffer; Level : byte = 0; RVA : DWORD = 0) : Boolean;
  Function GetDSFVersion(Sym : TDeDeSymbol) : String;
  procedure ParseExportName(var sExport : String);
  procedure ParseExportParam(var sParam : String);
  procedure ParseExportParamFlags(sFlags : String; var beg, en : String);
  function DCUFixParams(s : String) : String;
  function DCUExculdeParamNames(s : String) : String;

var BPLPEHeader : TPEHeader;

    FirstByteSet : TDeDeByteSet;

implementation

Uses
  DeDeDisASM, DisASM, HexTools, DeDeBPL, SysUtils,
  crc32, DeDeRes, DeDeCoreServices, DeDeClassHandle;

function InCodeSegment(s : String) : Boolean; overload;
var rva,i : dword;
    DELTA_PHYS : DWORD;
begin
  Result:=False;
  If Length(s)<>8 Then Exit;
  For i:=1 to length(s) do if not (s[i] in ['0'..'9', 'A'..'F']) then Exit;
  rva:=Hex2DWORD(s);

  DELTA_PHYS := BPLPEHeader.IMAGE_BASE
    + BPLPEHeader.Objects[1].RVA
    - BPLPEHeader.Objects[1].PHYSICAL_OFFSET;

  Result:=((RVA-DELTA_PHYS)>=BPLPEHeader.Objects[1].PHYSICAL_OFFSET)
      and ((RVA-DELTA_PHYS)<=BPLPEHeader.Objects[1].PHYSICAL_OFFSET+BPLPEHeader.Objects[1].PHYSICAL_SIZE)
end;

function InCodeSegment(rva : dword) : Boolean; overload;
var DELTA_PHYS : DWORD;
begin
  //Result:=False;
  DELTA_PHYS:=  BPLPEHeader.IMAGE_BASE
               +BPLPEHeader.Objects[1].RVA
               -BPLPEHeader.Objects[1].PHYSICAL_OFFSET;
  Result:=((RVA-DELTA_PHYS)>=BPLPEHeader.Objects[1].PHYSICAL_OFFSET)
      and ((RVA-DELTA_PHYS)<=BPLPEHeader.Objects[1].PHYSICAL_OFFSET+BPLPEHeader.Objects[1].PHYSICAL_SIZE)
end;


function Power(x,y : DWORD) : DWORD;
var i : Integer;
begin
  result:=1;
  for i:=1 to y do result:=result*x;
end;

// CRC of bytes aof called procedures
Procedure MakeCallCRC(var CRC : DWORD; buff : TSymBuffer; ipos : Integer; RVA : DWORD);
var dwOffset : DWORD;
    Offs : LongInt;
    i : Integer;
    pbuf : TSymBuffer;
    ImageFile: ThePEFile;
    ImageHeader: TPEHeader;
    ClassesDumper: TClassesDumper;
begin
  ClassesDumper := TClassesDumper(DeDeCoreContext.ClassesDumper);
  if ClassesDumper <> nil then
  begin
    ImageFile := ClassesDumper.PEFile;
    ImageHeader := ClassesDumper.PEHeader;
  end
  else
  begin
    ImageFile := DeDeClasses.PEFile;
    ImageHeader := DeDeClasses.PEHeader;
  end;
  if (ImageFile = nil) or (ImageHeader = nil) then
    Exit;

  dwOffset:=0;
  if iPos>_PatternSize-4 then exit;
  for i:=0 to 3 do dwOffset:=dwOffset+buff[iPos+i]*Power(256,i);

 // This offset is relative and should be corrected
  dwOffset:=dwOffset+iPos+5;

  Offs:=ImageHeader.Objects[1].PHYSICAL_OFFSET -
    ImageHeader.Objects[1].RVA - ImageHeader.IMAGE_BASE + RVA;

  if buff[iPos+3]=$FF  then Offs:=Offs+(dwOffset-$FFFFFFFF)
                       else Offs:=Offs+dwOffset;

  if Offs>ImageFile.PEStream.Size-_PatternSize then exit;
  if Offs<0 then exit;
  
  ImageFile.PEStream.BeginSearch;
  FillChar(pbuf,sizeof(pbuf),0);
  Try
    ImageFile.PEStream.Seek(Offs,soFromBeginning);
    ImageFile.PEStream.ReadBuffer(pbuf[1],_PatternSize);

    // The function that is called is export;
    if (pbuf[1]=$FF) and (pbuf[2]=$25) then exit;

    UnlinkCalls(pbuf,1);
    crc32.crc32val:=CRC;
    crc32.updatecrc(pbuf,_PatternSize);
    CRC:=crc32.crc32val;
  Finally
    ImageFile.PEStream.EndSearch;
  End;
End;

Function UnlinkCalls(Var buff : TSymBuffer; Level : byte = 0; RVA : DWORD = 0) : Boolean;
var s{,ins}   : String;
    j,k,i{,ps} : Integer;
    CRC : DWORD;
    DASM: TDisAsm;
Begin
   DASM := TDisAsm.Create;
   try
   j:=1;
   if Level=0 then CRC:=0;
   Repeat
     s:=DASM.GetInstruction(PAnsiChar(@buff[j]),k,Length(buff)-j+1);

     if k=5 then
       begin
         // 5 byte instructions
         // E8XXXXXXXX   - Call address (same segment)
         // 9AXXXXXXXX   - Call address (other segment)
         // 68XXXXXXXX   - Push address (same segment)
         // B8-BF        - Mov reg32, value **! these ones are neseccary !!!
         ///A0-A3        - eax,al moves
         // E9xxxxxxxx   - Long jump

         ////////////////////////////////////////////////////
         //// FOR NEW DSF ENGINE - CRC CHECK INCLUDED
         ////////////////////////////////////////////////////
         if (Level=0) and (DeDeCoreContext <> nil) and
           DeDeCoreContext.BuildCallCRC then
            if (buff[j] in [$E8,$9A])
                 then MakeCallCRC(CRC, buff, j+1, RVA);
         ////////////////////////////////////////////////////

         if buff[j] in [$E8,$E9,$9A,$A0..$A3,$A9]
            then begin
              for i:=1 to 4 do buff[j+i]:=0;
              if DeDeCoreContext <> nil then
                Inc(DeDeCoreContext.Normalized5ByteInstructions);
            end;

         /////////////////////////////////////////////////////////
         // Normalize absolute operands in the signature.
         /////////////////////////////////////////////////////////
         if buff[j] in [$68,$B8..$BF]
           then begin
                  for i:=1 to 4 do buff[j+i]:=0;
                  if DeDeCoreContext <> nil then
                    Inc(DeDeCoreContext.Normalized5ByteInstructions);
           end;
       end;

     if k=6 then
       begin
         // 6 byte instructions
         //
         // FF05xxxxxxxx - Inc dword ptr [offset]
         // FF0Dxxxxxxxx - Dec dword ptr [offset]
         // FF15xxxxxxxx - Call dword ptr [offset]
         // FF1Dxxxxxxxx - Call [offset]
         // FF25xxxxxxxx - Jmp dword ptr [offset]
         // FF2Dxxxxxxxx - Jmp [offset]
         // FF35xxxxxxxx - Push dword ptr [offset]
         //
         // 86 - xchg [offset], reg16
         // 8A - mov reg16, byte ptr [offset]
         // 8B - mov reg32, dword ptr [offset]
         // 8C - mov word ptr [offset], segreg
         // 8D - lea reg32, [offset]
         // 8E - mov segreg, word prt [offset]
         //
         // C5 - lds reg32, [offset]
         //
         // D8..DF, second byte in [05,0D..35,3D] -> FPU instructions
         //     that works with relative offsets

         ////////////////////////////////////////////////////
         //// FOR NEW DSF ENGINE - CRC CHECK INCLUDED
         ////////////////////////////////////////////////////
         //if Level=0 then
         //   if (buff[j]=$FF) and (buff[j+1] in [$15,$1D])
         //        then MakeCallCRC(CRC, buff, j+2);
         ////////////////////////////////////////////////////

         if     ((buff[j] in [$FF])  and (buff[j+1] in [$05,$0D,$15,$1D,$25,$2D,$35]))
         or ((buff[j] in [$84..$8F, $C4..$C5]) and (buff[j+1] in [$05,$0D,$15,$1D,$25,$2D,$35,$3D,$80..$83,$85..$8B,$8D..$93,$95..$9B,$9D..$A3,$A5..$AB,$AD..$B3,$B5..$BB,$BD..$BF]))
         or ((buff[j]=$0F) and (buff[j+1] in [$84,$85])
         or ((buff[j] in [$D8..$DF]) and (buff[j+1] in [$05,$0D,$15,$1D,$25,$2D,$35,$3D]))
         or (buff[j]=$C7))

            then begin
              for i:=2 to 5 do buff[j+i]:=0;
              if DeDeCoreContext <> nil then
                Inc(DeDeCoreContext.Normalized6ByteInstructions);
            end;
       end;

     if k=7 then
       begin
         // 7 byte instructions
         // 80 ..83  - add, or, adc, sbb, and, sub, xor, cmp
         //       ?? ptr [offset], imidiate_??_data
         /// FF0485xxxxxxxx         inc  dword ptr [offset+eax*4]
         /// FF0D85xxxxxxxx         dec  dword ptr [offset+eax*4]
         /// FF1485xxxxxxxx         call dword ptr [offset+eax*4]
         /// FF1C85xxxxxxxx         call [$offset+eax*4]
         /// FF2485xxxxxxxx         jmp  dword ptr [offset+eax*4]
         /// FF2C85xxxxxxxx         jmp  [offset+eax*4]
         /// FF3485xxxxxxxx         push dword ptr [offset+eax*4]
         /// C605xxxxxxxxYY         mov  byte ptr [$48BB0D], $YY
         /// 8B0485xxxxxxxx
         //
         //  FPU Stuff
         //  D8..DF, 0C..3C|04..34, 05..F5|0D..FD
         if (   (buff[j+0] in [$C6, $80..$83]) and  (buff[j+1] in [$05,$0D,$15,$1D,$25,$2D,$35,$3D,$85,$8D,$95,$9D,$A5,$AD,$B5,$BD]))
            or ((buff[j+0] in [$D8..$DF,$8B,$FF]) and (buff[j+1] in [$04,$0C,$14,$1C,$24,$2C,$34]) and (buff[j+2] in [$05,$0D,$15,$1D,$25,$2D,$35,$3D,$85,$8D,$95,$9D,$A5,$AD,$B5,$BD,$C5,$CD,$E5,$ED,$F5,$FD])
            or ((buff[j+0] in [$C7]) and (buff[j+1] in [$40..$7F])))
            then begin
              if (buff[j+0] in [$C7])
                then for i:=3 to 6 do buff[j+i]:=0
                else for i:=2 to 5 do buff[j+i]:=0;
                if DeDeCoreContext <> nil then
                  Inc(DeDeCoreContext.Normalized7ByteInstructions);
            end;
       end;

     if k=10 then
       begin
         // 10 byte instructions
         //
         // 81 - add, or, adc, sbb, and, sub, xor, cmp
         //       dword ptr [offset], imidiate_dword_data
         //
         // C705 - mov dword ptr [offset], imidiate_dword_data
         //
         // 69 [05,0D..35,3D] -> imul reg, [offset], imm_data
         if (    (buff[j+0] in [$81])
            and (buff[j+1] in [$05,$0D,$15,$1D,$25,$2D,$35,$3D,
                               $85,$8D,$95,$9D,$A5,$AD,$B5,$BD]))
             or ((buff[j]=$C7) {and (buff[j+1]=$05)})
             or ((buff[j]=$69) and (buff[j+1] in [$05,$0D,$15,$1D,$25,$2D,$35,$3D]))
            then begin
              for i:=2 to 5 do buff[j+i]:=0;
              if DeDeCoreContext <> nil then
                Inc(DeDeCoreContext.Normalized10ByteInstructions);
            end;
       end;
     j:=j+k;
   Until (j>=_PatternSize) or (s='ret');

   Result:=j>=3;

   For i:=j to _PatternSize do
       buff[i]:=0;

////////////////////////////////////////////////////
//// FOR NEW DSF ENGINE - CRC CHECK INCLUDED
////////////////////////////////////////////////////
   if CRC<>0 then
    begin
      buff[_PatternSize-0]:=CRC;
      buff[_PatternSize-1]:=CRC shr 8;
      buff[_PatternSize-2]:=CRC shr 16;
      buff[_PatternSize-3]:=CRC shr 24;
    end;
   finally
     DASM.Free;
   end;
End;


{ TDeDeSymbol }

constructor TDeDeSymbol.Create;
begin
  Inherited Create;

  Sym:=TMemoryStream.Create;
  Str:=TMemoryStream.Create;
end;

destructor TDeDeSymbol.Destroy;
begin
  ClearPatternIndexes;
  Sym.Free;
  Str.Free;

  Inherited Destroy;
end;

function TDeDeSymbol.LoadSymbol(AsFileName: String): Boolean;
begin
  Result:=False;
  Sym.Clear;
  Str.Clear;

  Try
    FileName:=AsFileName;
    Result := DeDeBPL.LoadBPLSymbolFile(sym, str, AsFileName, mode, PatternSize,
      Count,Comment,Index);

    UpdateFirstByteSet;
  Except
    on E: Exception do
    begin
      DeDeCoreContext.ReportWarning(err_load_symfile + AsFileName +
        '": ' + E.ClassName + ': ' + E.Message);
      Result := False;
    end;
  End;
end;

function TDeDeSymbol.FindMatches(const APattern: TSymBuffer;
  AVersionMask: Byte; AMatches: TStrings): Integer;
var
  I, PatternIndex: Integer;
  Pattern: TSymBuffer;
  PatternIndexes: TList;
  PatternItem: TDeDePatternIndex;
  NameLength: Byte;
  NameOffset: Int64;
  SymbolName: string;
  SymbolNameBytes: AnsiString;
  PreviousSymPosition, PreviousStrPosition: Int64;
begin
  if AMatches = nil then
    raise EArgumentNilException.Create('AMatches');
  Result := 0;
  if ((Mode and AVersionMask) = 0) or (PatternSize <> _PatternSize) then
    Exit;
  if (Count < 0) or
    (Int64(Count) * PatternSize > Sym.Size) then
    raise EReadError.Create('Invalid DSF pattern table size');
  if not FPatternIndexBuilt then
    UpdateFirstByteSet;
  PatternIndexes := FPatternIndexes[APattern[1]];
  if PatternIndexes = nil then
    Exit;

  PreviousSymPosition := Sym.Position;
  PreviousStrPosition := Str.Position;
  try
    for I := 0 to PatternIndexes.Count - 1 do
    begin
      PatternItem := TDeDePatternIndex(PatternIndexes[I]);
      PatternIndex := PatternItem.Index;
      Sym.Seek(Int64(PatternIndex) * PatternSize, soFromBeginning);
      Sym.ReadBuffer(Pattern[1], PatternSize);
      if not CompareMem(@APattern[1], @Pattern[1], PatternSize) then
        Continue;

      NameOffset := Index[PatternIndex];
      if (NameOffset < 0) or (NameOffset >= Str.Size) then
        raise EReadError.CreateFmt(
          'Invalid DSF name offset at index %d', [PatternIndex]);
      Str.Seek(NameOffset, soFromBeginning);
      Str.ReadBuffer(NameLength, SizeOf(NameLength));
      if Int64(NameLength) > Str.Size - Str.Position then
        raise EReadError.CreateFmt(
          'Truncated DSF name at index %d', [PatternIndex]);
      SetLength(SymbolNameBytes, NameLength);
      if NameLength > 0 then
        Str.ReadBuffer(SymbolNameBytes[1], NameLength);
      SymbolName := string(SymbolNameBytes);
      if AMatches.IndexOf(SymbolName) < 0 then
        AMatches.Add(SymbolName);
    end;

  finally
    Sym.Seek(PreviousSymPosition, soFromBeginning);
    Str.Seek(PreviousStrPosition, soFromBeginning);
  end;
  Result := AMatches.Count;
end;

procedure TDeDeSymbol.ClearPatternIndexes;
var
  I, J: Integer;
  PatternIndexes: TList;
begin
  for I := Low(FPatternIndexes) to High(FPatternIndexes) do
  begin
    PatternIndexes := FPatternIndexes[I];
    if PatternIndexes = nil then
      Continue;
    for J := 0 to PatternIndexes.Count - 1 do
      TDeDePatternIndex(PatternIndexes[J]).Free;
    PatternIndexes.Free;
    FPatternIndexes[I] := nil;
  end;
  FPatternIndexBuilt := False;
end;

function GetVersionedDSFName(const ACompilerVersion: string): string;
begin
  if SameText(ACompilerVersion, 'D2') then
    Result := 'vcl2.dsf'
  else if SameText(ACompilerVersion, 'D3') or
    SameText(ACompilerVersion, 'BCB3') then
    Result := 'vcl3.dsf'
  else if SameText(ACompilerVersion, 'D4') or
    SameText(ACompilerVersion, 'BCB4') then
    Result := 'vcl4.dsf'
  else if SameText(ACompilerVersion, 'D5') or
    SameText(ACompilerVersion, 'BCB5') then
    Result := 'vcl5.dsf'
  else if SameText(ACompilerVersion, 'D6') or
    SameText(ACompilerVersion, 'D6 CLX') then
    Result := 'vcl6.dsf'
  else if SameText(ACompilerVersion, 'D7') then
    Result := 'vcl7.dsf'
  else
    Result := '';
end;

Function GetDSFVersion(Sym : TDeDeSymbol) : String;
var ident : Integer;
Begin
  Result:='unknown';

  ident:=Sym.PatternSize;

  If ident=$F Then
    Begin
      Result:='1.0';
      Exit;
    End;

  If ident=32 Then
    Begin
      Result:='1.2';
      Exit;
    End;

  If ident=40 Then
    Begin
      Result:='2.0';
      Exit;
    End;

  If ident=50 Then
    Begin
      Result:='2.1';
      Exit;
    End;
End;


Procedure ParseExportParamFlags(sFlags : String; var beg, en : String);
var i : Integer;
Begin
  en:='';beg:='';
  i:=1;
  While i<=Length(sFlags) Do
     begin
       case sFlags[i] of
         // i = integer
         'i' : en:=en+'; Integer';
         // j = int64
         'j' : en:=en+'; Int64';
         // g = extended
         'g' : en:=en+'; Extended';
         // ui = Cardinal
         'u' : begin
                 Inc(i);
                 //ui = Cardinal
                 If Copy(sFlags,i,1)='i' then en:=en+'; Cardinal';
               end;
          
          // p = Pointer
         'p' : en:=en+'; Pointer';
         'x' : begin
                 Inc(i);
                 //xi = Array of
                 If Copy(sFlags,i,1)='i' then beg:='Array Of ';
                 if Copy(sFlags,i,1)='t' then
                   begin
                      //xt1 = String
                      en:=en+'; String';
                      //inc(i);
                      //If Copy(sFlags,i,1)='1' then en:=en+'; String';
                   end;
               end;
         // vt1 VAR
         'v' : begin
                 Inc(i);
                 if Copy(sFlags,i,1)='t' then
                   begin
                      //xt1 = String
                      en:=en+'; VAR';
                      //inc(i);
                      //If Copy(sFlags,i,1)='1' then en:=en+'; String';
                   end;
               end;

       end;
       inc(i);
     end;

  If copy(en,Length(en)-8,9)='; Pointer' then
    en:=Copy(en,1,Length(en)-9);
End;

procedure ParseExportParam(var sParam : String);
var s, ss, s1, s0, beg, mid, en, sf, sf0, sp, sfx : String;
    i,len : Integer;
    bChanges, bSkip, bFirst, bFlag : Boolean;
begin
    sp:=sParam+' ';
    s:='';
    i:=Pos('$',sp);
    s0:=Copy(sp,1,i-1);
    bFirst:=True;
    repeat
      bChanges:=False;
      i:=Pos('$',sp);
      If i=0 Then
         begin
           s:=s+sp;
           break;
         end;
      repeat inc(i) until Copy(sp,i,1)[1] in ['0'..'9',' '];

      // Here the flags at the beginning of a params are parsed
      sf0:=Copy(sp,1,i-1);
      If bFirst Then
         Begin
           bFirst:=False;
           ParseExportParamFlags(sf0,beg,en);
           If Copy(en,1,2)='; ' then en:=Copy(en,3,Length(en)-2);
           s:=s+beg+en;
         End;
      //

      If Copy(sp,i,1)<>' ' Then
        Begin
          dec(i);ss:='';
          repeat inc(i); ss:=ss+Copy(sp,i,1) until not (Copy(sp,i,1)[1] in ['0'..'9']);
          ss:=Copy(ss,1,Length(ss)-1);
          len:=StrToInt(ss);
          mid:='';
          If not (   (Pos('$',Copy(sp,i,len))<>0)
                 and (Pos('%',Copy(sp,i,len))=0))
                 then if (len>3) then mid:=Copy(sp,i,len);
          inc(i,len);

          // Parsing Flags Meaning
          en:='';beg:='';sf:='';
          while (i<Length(sp)) and (Copy(sp,i,1)[1] in ['a'..'z']) do
             Begin
              sf:=sf+sp[i];
              Inc(i);
             End;

          ParseExportParamFlags(sf,beg,en);

          s:=s+'; '+beg+mid+en;
          If i<>Length(sp) then sp:=Copy(sp,i,Length(sp)-i+1)
                           else sp:='';
          If (sp<>'') and (Copy(sp,1,1)[1] in ['0'..'9']) Then sp:='$'+sp;
          bChanges:=True;
        End;
    until not bChanges;

    ss:=s;s:='';
    bChanges:=True;bSkip:=False;
    For i:=1 To Length(ss) Do
      Case ss[i] of
        '@' : if bSkip then s1:=s1+'.'
                       else s:=s+'.';
        '%' : begin
                if bChanges
                   then begin
                     bSkip:=True;
                     s1:='';
                   end
                   else begin
                     bSkip:=False;
                     If Copy(s1,1,3)='Set' Then s1:=Copy(s1,4,Length(s1)-3);
                     s1:=s1+' ';
                     ParseExportParam(s1);
                     If Copy(s1,1,2)='; ' Then s1:=Copy(s1,3,Length(s1)-2);
                     If Copy(s1,Length(s1)-2,3)=';  ' Then s1:=Copy(s1,1,Length(s1)-3);
                     If Copy(s1,Length(s1)-1,2)='; ' Then s1:=Copy(s1,1,Length(s1)-2);
                     If Copy(s1,Length(s1),1)=' ' Then s1:=Copy(s1,1,Length(s1)-1);

                     s:=s+'['+s1+']';
                   end;
                bChanges:=not bChanges;
              end;
        Else if bSkip then s1:=s1+ss[i]
                      else s:=s+ss[i];
      End;
    s:=s0+s;
    sfx:='';
    bFlag:=False;
    For i:=1 To Length(s) Do
     Begin
       If bFlag then
         if s[i] in [#32,';']
            then begin
               if s[i]=#32 Then if Copy(sfx,Length(sfx),1)<>#32 then sfx:=sfx+' ';
               continue;
            end
            else bFlag:=False;
       If (s[i]=';') and (not bFlag) Then
         begin
           bFlag:=True;
           sfx:=sfx+';';
           continue;
         end;
       sfx:=sfx+s[i];
     End;
   sParam:=sfx;
end;

procedure ParseExportName(var sExport : String);
var s1 : String;
    i : Integer;
begin
  s1:='';
  For i:=1 To Length(sExport) Do
    Case sExport[i] of
      '@' : s1:=s1+'.'
      Else s1:=s1+sExport[i];
    End;
  sExport:=s1;
end;


function DCUFixParams(s : String) : String;
var  iPos, len : Integer;
    i : Integer;

const fixups_count=3;
      fixups : array [1..fixups_count,1..2] of String =
        (
          ('array[$0..-$1]'         ,'array')
         ,('false..true'            ,'boolean')
         ,('$'                      ,'')

        );
begin
  i:=0;
  // Dont use "for-loop" here !!!!
  // The order of appling fixups is important
  //
  // For i:=0 to fixoups_count do
  // Here the compiler can produce code that decrements from max value
  // instead of increment from min that will fuck up the result
  repeat
    iPos:=Pos(fixups[i+1,1],s);
    While iPos<>0 Do
     Begin
       len:=Length(fixups[i+1,1]);
       s:=Copy(s,1,iPos-1)+fixups[i+1,2]+Copy(s,iPos+len,Length(s)-iPos-len+1);
       iPos:=Pos(fixups[i+1,1],s);
     End;
     Inc(i);
  until i>=fixups_count;

  Result:=s;  
end;

// This should replace param names with param type name
//
// (sParam1, sParam2 : Stirng; dwParam3 : DWORD) -> (String; String; DWORD;)
function DCUExculdeParamNames(s : String) : String;
var s0,s1,s2,ss,st : String;
    iPos, iPos2, i : Integer;
    TmpLst : TStringList;
begin
  iPos:=Pos('(',s);
  s1:=Copy(s,1,iPos); s:=Copy(s,iPos+1,Length(s)-iPos);
  iPos:=Pos(')',s);
  s2:=Copy(s,iPos,Length(s)-iPos+1); s:=Copy(s,1,iPos-1);

  // Replacing
  s0:='';
  TmpLst:=TStringList.Create;
  Try
    iPos:=Pos(':',s);
    while iPos<>0 do
      begin
        iPos2:=Pos(';',s);
        if iPos2=0 then
          begin
            iPos2:=Length(s)+1;
            s:=s+';';
          end;
        ss:=Copy(s,1,iPos-1);
        st:=Copy(s,iPos+1,iPos2-iPos-1);
        st:=Trim(st)+';';
        TmpLst.CommaText:=ss;
        s:=Copy(s,iPos2+1,Length(s)-iPos2);
        iPos:=Pos(':',s);

        for iPos2:=1 to TmpLst.Count Do s0:=s0+st;
      end;
  Finally
    TmpLst.Free;
  End;
  Result:=s1+s0+s2;

  i:=Pos(';)',Result);
  if i<>0 then Result:=Copy(Result,1,i-1)+Copy(Result,i+1,Length(Result)-i);
  s:=Result;

  Result:='';
  For i:=1 to Length(s) Do
    if s[i]<>' ' then Result:=Result+s[i];

end;

procedure TDeDeSymbol.UpdateFirstByteSet;
var
  I: Integer;
  Buffer: TSymBuffer;
  PatternIndex: TDeDePatternIndex;
begin
  ClearPatternIndexes;
  if PatternSize <> _PatternSize then
    Exit;
  Sym.Seek(0,soFromBeginning);
  for I := 0 to Count - 1 do
  begin
    Sym.ReadBuffer(Buffer[1], _PatternSize);
    FirstByteSet := FirstByteSet + [Buffer[1]];
    if FPatternIndexes[Buffer[1]] = nil then
      FPatternIndexes[Buffer[1]] := TList.Create;
    PatternIndex := TDeDePatternIndex.Create;
    PatternIndex.Index := I;
    FPatternIndexes[Buffer[1]].Add(PatternIndex);
  end;
  FPatternIndexBuilt := True;
end;

initialization
  FirstByteSet:=[];

end.
