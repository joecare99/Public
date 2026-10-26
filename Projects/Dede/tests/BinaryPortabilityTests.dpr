program BinaryPortabilityTests;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeBinaryTypes, DeDeBinaryReader, DeDeCoreServices,
  DeDeBSS, DisASM;

type
  TConfirmRecorder = class
  public
    Accepted: Boolean;
    Calls: Integer;
    function OnConfirm(const ATitle, AMessage: string): Boolean;
  end;

function TConfirmRecorder.OnConfirm(const ATitle, AMessage: string): Boolean;
begin
  Inc(Calls);
  Result := Accepted;
end;

procedure Check(ACondition: Boolean; const AMessage: string);
begin
  if not ACondition then
    raise Exception.Create(AMessage);
end;

procedure TestOffsetBoundaries;
var
  Offset: TPE32FileOffset;
  TypedRVA: TPE32RVA;
begin
  Check(TryAddPE32FileOffset(0, 0, Offset) and (LongWord(Offset) = 0),
    'Zero offset addition failed');
  Check(TryAddPE32FileOffset($7FFFFFFF, 0, Offset) and
    (LongWord(Offset) = $7FFFFFFF), 'Signed boundary changed');
  Check(TryAddPE32FileOffset($80000000, 0, Offset) and
    (LongWord(Offset) = $80000000), 'Unsigned high-bit boundary changed');
  Check(TryAddPE32FileOffset($FFFFFFFE, 1, Offset) and
    (LongWord(Offset) = $FFFFFFFF), 'Maximum PE32 offset addition failed');
  Check(not TryAddPE32FileOffset($FFFFFFFF, 1, Offset),
    'PE32 offset overflow was accepted');
  Check(TryGetPE32RVA($00400000, $00400000, TypedRVA) and
    (LongWord(TypedRVA) = 0), 'Image-base RVA conversion failed');
  Check(TryGetPE32RVA($00400000, $FFFFFFFF, TypedRVA) and
    (LongWord(TypedRVA) = $FFBFFFFF), 'High RVA conversion failed');
  Check(not TryGetPE32RVA($00400000, $003FFFFF, TypedRVA),
    'Address below image base was accepted');
end;

procedure TestLittleEndianReadsAndPosition;
var
  Stream: TMemoryStream;
  Reader: TDeDeBinaryReader;
  Buffer: array[0..7] of Byte;
begin
  Buffer[0] := $78;
  Buffer[1] := $56;
  Buffer[2] := $34;
  Buffer[3] := $12;
  Buffer[4] := $AB;
  Buffer[5] := $CD;
  Buffer[6] := $EF;
  Buffer[7] := $90;
  Stream := TMemoryStream.Create;
  try
    Stream.WriteBuffer(Buffer[0], SizeOf(Buffer));
    Stream.Position := 3;
    Reader := TDeDeBinaryReader.Create(Stream);
    try
      Check(Reader.ReadUInt8At(0) = $78, 'Byte read failed');
      Check(Reader.ReadUInt16LEAt(0) = $5678, '16-bit LE read failed');
      Check(Reader.ReadUInt32LEAt(0) = $12345678, '32-bit LE read failed');
      Check(Reader.ReadUInt16LEAt(4) = $CDAB, 'High-byte 16-bit read failed');
      Check(Stream.Position = 3, 'Reader did not preserve stream position');
    finally
      Reader.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TestReadBounds;
var
  Stream: TMemoryStream;
  Reader: TDeDeBinaryReader;
  Raised: Boolean;
  Buffer: array[0..3] of Byte;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  Stream := TMemoryStream.Create;
  try
    Stream.WriteBuffer(Buffer[0], SizeOf(Buffer));
    Reader := TDeDeBinaryReader.Create(Stream);
    try
      Raised := False;
      try
        Reader.ReadUInt32LEAt($7FFFFFFF);
      except
        on EDeDeBinaryBounds do
          Raised := True;
      end;
      Check(Raised, 'Large positive offset was not rejected');

      Raised := False;
      try
        Reader.ReadUInt8At($80000000);
      except
        on EDeDeBinaryBounds do
          Raised := True;
      end;
      Check(Raised, 'High-bit offset was not rejected');

      Raised := False;
      try
        Reader.ReadUInt32LEAt($FFFFFFFF);
      except
        on EDeDeBinaryBounds do
          Raised := True;
      end;
      Check(Raised, 'Maximum PE32 offset was not rejected');
    finally
      Reader.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TestDisassemblerBounds;
var
  Disassembler: TDisAsm;
  Bytes: array[0..4] of AnsiChar;
  Size: Integer;
  Decoded: string;
  Raised: Boolean;
begin
  FillChar(Bytes, SizeOf(Bytes), 0);
  Bytes[0] := #$90;
  Disassembler := TDisAsm.Create;
  try
    Size := 0;
    Decoded := Disassembler.GetInstruction(@Bytes[0], Size, 1);
    Check((Size = 1) and (Decoded <> ''),
      'A complete one-byte instruction was not decoded');

    Bytes[0] := #$E8;
    Size := 0;
    Raised := False;
    try
      Disassembler.GetInstruction(@Bytes[0], Size, 4);
    except
      on EDisAsmError do
        Raised := True;
    end;
    Check(Raised, 'A truncated relative-call operand was read past its buffer');
  finally
    Disassembler.Free;
  end;
end;

procedure TestPE32OffsetStorage;
var
  Context: TDeDeCoreContext;
begin
  Context := TDeDeCoreContext.Create;
  try
    Context.AddDFMForm('HighOffset',
      TPE32FileOffset($F0001234));
    Check(LongWord(Context.GetDFMFileOffset(0)) = $F0001234,
      'PE32 DFM file offset was truncated to a host pointer width');
  finally
    Context.Free;
  end;
end;

procedure TestPE32DWordListStorage;
var
  Values: TPE32DWordList;
begin
  Values := TPE32DWordList.Create;
  try
    Values.AddUndefined;
    Values.Add($F0001234);
    Values.Add(0);
    Check(Values.Count = 3, 'PE32 value-list count changed');
    Check(not Values.IsDefined(0), 'Undefined PE32 value became defined');
    Check(Values[0] = 0, 'Undefined PE32 value did not read as zero');
    Check(Values.IsDefined(2), 'Defined zero PE32 value became undefined');
    Check(Values[1] = $F0001234,
      'High-bit PE32 value was changed by list storage');
    Check(Values.IndexOf($F0001234) = 1,
      'PE32 value-list lookup failed');
    Values[1] := $FFFFFFFF;
    Check(Values[1] = $FFFFFFFF,
      'PE32 value-list update truncated the high bit');
    Values.Delete(1);
    Check(Values.Count = 2, 'PE32 value-list deletion failed');
    Check(Values.IsDefined(1) and (Values[1] = 0),
      'PE32 value-list deletion changed the following item');
  finally
    Values.Free;
  end;
end;

procedure TestConfirmationService;
var
  Context: TDeDeCoreContext;
  Recorder: TConfirmRecorder;
begin
  Context := TDeDeCoreContext.Create;
  Recorder := TConfirmRecorder.Create;
  try
    Check(not Context.Confirm('test', 'no callback'),
      'Missing interaction callback was not denied by default');
    Recorder.Accepted := False;
    Context.OnConfirm := Recorder.OnConfirm;
    Check(not Context.Confirm('test', 'denied'),
      'A denied interaction callback was accepted');
    Recorder.Accepted := True;
    Check(Context.Confirm('test', 'accepted'),
      'An accepted interaction callback was rejected');
    Check(Recorder.Calls = 2, 'Interaction callback call count changed');
  finally
    Recorder.Free;
    Context.Free;
  end;
end;

procedure TestUnavailableProcessMemoryService;
{$IFNDEF MSWINDOWS}
var
  BSS: TBSS;
  Raised: Boolean;
{$ENDIF}
begin
{$IFNDEF MSWINDOWS}
  BSS := TBSS.Create;
  try
    Raised := False;
    try
      BSS.Dump('');
    except
      on E: EDeDeServiceUnavailable do
      begin
        Raised := Pos('BSS/DATA process dumping', E.Message) > 0;
      end;
    end;
    Check(Raised,
      'Unsupported process-memory service did not report unavailability');
  finally
    BSS.Free;
  end;
{$ENDIF}
end;

begin
  try
    TestOffsetBoundaries;
    TestLittleEndianReadsAndPosition;
    TestReadBounds;
    TestDisassemblerBounds;
    TestPE32OffsetStorage;
    TestPE32DWordListStorage;
    TestConfirmationService;
    TestUnavailableProcessMemoryService;
    Writeln('PE32 binary portability tests passed');
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
