program ZLibZipSpike;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, ZLib;

type
  TByteArray = array of Byte;

function LoadBytes(const FileName: string): TByteArray;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Result, Stream.Size);
    if Length(Result) > 0 then
      Stream.ReadBuffer(Result[0], Length(Result));
  finally
    Stream.Free;
  end;
end;

procedure SaveBytes(const FileName: string; const Bytes: TByteArray);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if Length(Bytes) > 0 then
      Stream.WriteBuffer(Bytes[0], Length(Bytes));
  finally
    Stream.Free;
  end;
end;

procedure VerifyRawDeflate(const Compressed, Expected: TByteArray);
var
  ZStream: TZStreamRec;
  Output: TByteArray;
  Code: Integer;
begin
  if (Length(Compressed) = 0) or (Length(Expected) = 0) then
    raise Exception.Create('The spike requires non-empty input data');

  SetLength(Output, Length(Expected));
  FillChar(ZStream, SizeOf(ZStream), 0);
  ZStream.next_in := PAnsiChar(@Compressed[0]);
  ZStream.avail_in := Length(Compressed);
  ZStream.next_out := PAnsiChar(@Output[0]);
  ZStream.avail_out := Length(Output);

  Code := InflateInit2_(ZStream, -15, ZLIB_VERSION, SizeOf(ZStream));
  if Code <> Z_OK then
    raise Exception.CreateFmt('InflateInit2 failed: %d', [Code]);
  try
    Code := inflate(ZStream, Z_FINISH);
    if Code <> Z_STREAM_END then
      raise Exception.CreateFmt('Raw inflate failed: %d', [Code]);
    if ZStream.total_out <> Length(Expected) then
      raise Exception.CreateFmt('Inflated size mismatch: %d <> %d',
        [ZStream.total_out, Length(Expected)]);
    if not CompareMem(@Output[0], @Expected[0], Length(Expected)) then
      raise Exception.Create('Inflated bytes differ from the ZIP member');
  finally
    inflateEnd(ZStream);
  end;
end;

function CompressRawDeflate(const Input: TByteArray): TByteArray;
var
  ZStream: TZStreamRec;
  Output: TByteArray;
  Code: Integer;
begin
  if Length(Input) = 0 then
    raise Exception.Create('The spike requires non-empty input data');

  SetLength(Output, Length(Input) + 65536);
  FillChar(ZStream, SizeOf(ZStream), 0);
  ZStream.next_in := PAnsiChar(@Input[0]);
  ZStream.avail_in := Length(Input);
  ZStream.next_out := PAnsiChar(@Output[0]);
  ZStream.avail_out := Length(Output);

  Code := DeflateInit2_(ZStream, Z_DEFAULT_COMPRESSION, Z_DEFLATED,
    -15, 8, Z_DEFAULT_STRATEGY, ZLIB_VERSION, SizeOf(ZStream));
  if Code <> Z_OK then
    raise Exception.CreateFmt('DeflateInit2 failed: %d', [Code]);
  try
    Code := deflate(ZStream, Z_FINISH);
    if Code <> Z_STREAM_END then
      raise Exception.CreateFmt('Raw deflate failed: %d', [Code]);
    SetLength(Output, ZStream.total_out);
    Result := Output;
  finally
    deflateEnd(ZStream);
  end;
end;

procedure Run;
var
  Compressed, Expected, Recompressed: TByteArray;
begin
  if ParamCount <> 3 then
    raise Exception.Create(
      'Usage: ZLibZipSpike <raw-deflate> <expected-member> <output-raw-deflate>');

  Compressed := LoadBytes(ParamStr(1));
  Expected := LoadBytes(ParamStr(2));
  VerifyRawDeflate(Compressed, Expected);

  Recompressed := CompressRawDeflate(Expected);
  SaveBytes(ParamStr(3), Recompressed);
  VerifyRawDeflate(Recompressed, Expected);

  Writeln('Raw ZIP DEFLATE passed: input=', Length(Compressed),
    ' bytes, output=', Length(Recompressed), ' bytes, member=',
    Length(Expected), ' bytes.');
end;

begin
  try
    Run;
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, 'ZLibZipSpike: ', E.Message);
      Halt(1);
    end;
  end;
end.
