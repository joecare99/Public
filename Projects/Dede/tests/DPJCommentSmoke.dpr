program DPJCommentSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeEditText, DeDeDPJEng, DeDeAnsiStream;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

var
  SourceComments, LoadedComments: TCommentArray;
  SourceCount, LoadedCount: Integer;
  StringValue: string;
  AnsiBuffer: TAnsiByteBuffer;
  InvalidCount: Integer;
  InvalidCountRejected: Boolean;
  Stream: TMemoryStream;
begin
  SetLength(SourceComments, 2);
  SourceComments[0].cmtRVA := $12345678;
  SourceComments[0].Comment := 'first comment';
  SourceComments[1].cmtRVA := $ABCDEF01;
  SourceComments[1].Comment := 'second comment';
  SourceCount := Length(SourceComments);
  Stream := TMemoryStream.Create;
  try
    WriteDPJRawString(Stream, 'DPJ!1.003.50');
    Require(Stream.Size = 12, 'DPJ header was not written as ANSI bytes');
    Stream.Position := 0;
    Require(ReadDPJRawString(Stream, 12) = 'DPJ!1.003.50',
      'DPJ header ANSI bytes did not roundtrip');

    Stream.Clear;
    WriteDPJStringValue(Stream, 'Legacy');
    Require(Stream.Size = SizeOf(Integer) + Length(AnsiString('Legacy')),
      'DPJ string length is not measured in ANSI bytes');
    Stream.Position := 0;
    StringValue := ReadDPJStringValue(Stream);
    Require(StringValue = 'Legacy', 'Length-prefixed DPJ string changed');

    SetLength(AnsiBuffer, 0);
    AppendLengthPrefixedAnsiString(AnsiBuffer, 'ClassName');
    Require(Length(AnsiBuffer) =
      SizeOf(Integer) + AnsiByteLength('ClassName'),
      'DPJ class-buffer string has an incorrect byte length');
    Stream.Clear;
    Stream.WriteBuffer(AnsiBuffer[0], Length(AnsiBuffer));
    Stream.Position := 0;
    Require(ReadDPJStringValue(Stream) = 'ClassName',
      'DPJ class-buffer string did not roundtrip');

    Stream.Clear;
    WriteAnsiBytes(Stream, 'LegacyTail', 6);
    Require(Stream.Size = 6, 'ANSI byte-prefix length changed');
    Stream.Position := 0;
    Require(ReadAnsiString(Stream, 6) = 'Legacy',
      'ANSI byte-prefix content changed');

    Stream.Clear;
    WriteDPJCommentRecords(Stream, SourceComments, SourceCount);
    Require(Stream.Size = SizeOf(SourceCount) + 2 * DPJCommentRecordBytes,
      'DPJ comments do not use the reference record width');
    Stream.Position := 0;
    ReadDPJCommentRecords(Stream, LoadedComments, LoadedCount);
    Require(LoadedCount = SourceCount, 'Comment count changed on roundtrip');
    Require(LoadedComments[0].cmtRVA = SourceComments[0].cmtRVA,
      'First comment RVA changed on roundtrip');
    Require(LoadedComments[0].Comment = SourceComments[0].Comment,
      'First comment text changed on roundtrip');
    Require(LoadedComments[1].cmtRVA = SourceComments[1].cmtRVA,
      'Second comment RVA changed on roundtrip');
    Require(LoadedComments[1].Comment = SourceComments[1].Comment,
      'Second comment text changed on roundtrip');

    Stream.Clear;
    InvalidCount := High(Integer);
    Stream.WriteBuffer(InvalidCount, SizeOf(InvalidCount));
    Stream.Position := 0;
    InvalidCountRejected := False;
    try
      ReadDPJCommentRecords(Stream, LoadedComments, LoadedCount);
    except
      on E: EReadError do
        InvalidCountRejected := True;
    end;
    Require(InvalidCountRejected,
      'Oversized comment count was not rejected before allocation');
    WriteLn('DPJ comment serialization smoke test passed');
  finally
    Stream.Free;
  end;
end.
