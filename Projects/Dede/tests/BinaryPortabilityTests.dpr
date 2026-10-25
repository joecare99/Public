program BinaryPortabilityTests;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeBinaryTypes, DeDeBinaryReader;

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

begin
  try
    TestOffsetBoundaries;
    TestLittleEndianReadsAndPosition;
    TestReadBounds;
    Writeln('PE32 binary portability tests passed');
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
