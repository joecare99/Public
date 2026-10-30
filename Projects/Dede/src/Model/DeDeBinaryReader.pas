unit DeDeBinaryReader;

interface

uses
  Classes, SysUtils, DeDeBinaryTypes;

type
  EDeDeBinaryBounds = class(EReadError);

  TDeDeBinaryReader = class
  private
    FStream: TStream;
    procedure CheckRange(const AOffset: TPE32FileOffset;
      ACount: LongWord);
  public
    constructor Create(AStream: TStream);
    function ReadUInt8At(const AOffset: TPE32FileOffset): Byte;
    function ReadUInt16LEAt(const AOffset: TPE32FileOffset): Word;
    function ReadUInt32LEAt(const AOffset: TPE32FileOffset): LongWord;
    procedure ReadBytesAt(const AOffset: TPE32FileOffset;
      var ABuffer; ACount: LongWord);
    property Stream: TStream read FStream;
  end;

implementation

constructor TDeDeBinaryReader.Create(AStream: TStream);
begin
  inherited Create;
  if AStream = nil then
    raise EArgumentNilException.Create('AStream');
  FStream := AStream;
end;

procedure TDeDeBinaryReader.CheckRange(const AOffset: TPE32FileOffset;
  ACount: LongWord);
var
  Offset64, Count64, StreamSize: Int64;
begin
  Offset64 := LongWord(AOffset);
  Count64 := ACount;
  StreamSize := FStream.Size;
  if (Offset64 > StreamSize) or (Count64 > StreamSize - Offset64) then
    raise EDeDeBinaryBounds.CreateFmt(
      'Read at file offset %.8x with size %u exceeds stream size %u',
      [LongWord(AOffset), ACount, StreamSize]);
end;

function TDeDeBinaryReader.ReadUInt8At(
  const AOffset: TPE32FileOffset): Byte;
var
  SavedPosition: Int64;
begin
  CheckRange(AOffset, 1);
  SavedPosition := FStream.Position;
  try
    FStream.Position := LongWord(AOffset);
    FStream.ReadBuffer(Result, SizeOf(Result));
  finally
    FStream.Position := SavedPosition;
  end;
end;

function TDeDeBinaryReader.ReadUInt16LEAt(
  const AOffset: TPE32FileOffset): Word;
var
  Buffer: array[0..1] of Byte;
  SavedPosition: Int64;
begin
  CheckRange(AOffset, SizeOf(Buffer));
  SavedPosition := FStream.Position;
  try
    FStream.Position := LongWord(AOffset);
    FStream.ReadBuffer(Buffer[0], SizeOf(Buffer));
  finally
    FStream.Position := SavedPosition;
  end;
  Result := Word(Buffer[0]) or (Word(Buffer[1]) shl 8);
end;

function TDeDeBinaryReader.ReadUInt32LEAt(
  const AOffset: TPE32FileOffset): LongWord;
var
  Buffer: array[0..3] of Byte;
  SavedPosition: Int64;
begin
  CheckRange(AOffset, SizeOf(Buffer));
  SavedPosition := FStream.Position;
  try
    FStream.Position := LongWord(AOffset);
    FStream.ReadBuffer(Buffer[0], SizeOf(Buffer));
  finally
    FStream.Position := SavedPosition;
  end;
  Result := LongWord(Buffer[0]) or
    (LongWord(Buffer[1]) shl 8) or
    (LongWord(Buffer[2]) shl 16) or
    (LongWord(Buffer[3]) shl 24);
end;

procedure TDeDeBinaryReader.ReadBytesAt(const AOffset: TPE32FileOffset;
  var ABuffer; ACount: LongWord);
var
  SavedPosition: Int64;
begin
  CheckRange(AOffset, ACount);
  if ACount = 0 then
    Exit;
  SavedPosition := FStream.Position;
  try
    FStream.Position := LongWord(AOffset);
    FStream.ReadBuffer(ABuffer, ACount);
  finally
    FStream.Position := SavedPosition;
  end;
end;

end.
