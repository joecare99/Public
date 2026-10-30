unit DeDeAnsiStream;

interface

uses
  Classes;

type
  TAnsiByteBuffer = array of Byte;

function AnsiByteLength(const Value: string): Integer;
function ReadAnsiString(AStream: TStream; ByteCount: Integer): string;
procedure WriteAnsiString(AStream: TStream; const Value: string);
procedure WriteAnsiBytes(AStream: TStream; const Value: string;
  ByteCount: Integer);
procedure AppendLengthPrefixedAnsiString(var Buffer: TAnsiByteBuffer;
  const Value: string);

implementation

uses
  SysUtils;

function AnsiByteLength(const Value: string): Integer;
begin
  Result := Length(AnsiString(Value));
end;

function ReadAnsiString(AStream: TStream; ByteCount: Integer): string;
var
  Bytes: AnsiString;
begin
  Result := '';
  if ByteCount = 0 then
    Exit;
  SetLength(Bytes, ByteCount);
  AStream.ReadBuffer(Bytes[1], ByteCount);
  Result := string(Bytes);
end;

procedure WriteAnsiString(AStream: TStream; const Value: string);
var
  Bytes: AnsiString;
begin
  Bytes := AnsiString(Value);
  if Length(Bytes) > 0 then
    AStream.WriteBuffer(Bytes[1], Length(Bytes));
end;

procedure WriteAnsiBytes(AStream: TStream; const Value: string;
  ByteCount: Integer);
var
  Bytes: AnsiString;
begin
  if ByteCount = 0 then
    Exit;
  Bytes := AnsiString(Value);
  AStream.WriteBuffer(Bytes[1], ByteCount);
end;

procedure AppendLengthPrefixedAnsiString(var Buffer: TAnsiByteBuffer;
  const Value: string);
var
  Bytes: AnsiString;
  ByteCount, BufferLength: Integer;
begin
  Bytes := AnsiString(Value);
  ByteCount := Length(Bytes);
  BufferLength := Length(Buffer);
  SetLength(Buffer, BufferLength + SizeOf(ByteCount) + ByteCount);
  Move(ByteCount, Buffer[BufferLength], SizeOf(ByteCount));
  if ByteCount > 0 then
    Move(Bytes[1], Buffer[BufferLength + SizeOf(ByteCount)], ByteCount);
end;

end.
