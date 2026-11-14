unit DeDeBPL;

// DeDe Symbol File Format
// DSF!    - Magic
// BYTE    - Flag ( 0 = Delphi3, 1=Delphi4, 2=Delphi5, 3=Delphi2, 4=Delphi6, 5,6,7 - Reserved)
// DWORD   - Extended header value, present when flag bit $40 is set
// WORD    - Record Count
// BYTE    - Pattern Length
// DWORD   - Patterns Offset
// DWORD   - Names Offset
// PS      - File Comment
//
// Patterns Block - "Record Count" entries with Length "Pattern Length"
//
// Names Block - "Record Count" entries of Pascal Strings
//

interface

Uses Classes;

const
  DSF_FLAG_EXTENDED_HEADER = $40;

Procedure SaveBPLSymbolFile(Bytes,Names : TMemoryStream;
                            sFileName : String;
                            mode,patsz : Byte;
                            recnum : LongInt;
                            comment : String);

Function LoadBPLSymbolFile(Var Bytes,Names : TMemoryStream;
                            sFileName : String;
                            var mode,patsz : Byte;
                            var recnum : LongInt;
                            var comment : String;
                            var indexarr : TBoundArray) : Boolean;

implementation

Uses SysUtils, DeDeAnsiStream, DeDeZip;

Type DWORD = LongWord;

Procedure SaveBPLSymbolFile(
  Bytes,Names : TMemoryStream;
  sFileName : String;
  mode,patsz : Byte;
  recnum : LongInt;
  comment : String);
Var OutF : TMemoryStream;
    s : String;
    b : Byte;
    w : Word;
    dw,dwc,dws,dwExtendedHeader : DWORD;
    HeaderOffsetShift: Integer;
Begin
  OutF:=TMemoryStream.Create;
  Try
    // Write Magic
    s:='DSF!';
    WriteAnsiString(OutF, s);
    // Write Flags
    OutF.WriteBuffer(mode,1);
    HeaderOffsetShift := 0;
    if (mode and DSF_FLAG_EXTENDED_HEADER) <> 0 then
    begin
      dwExtendedHeader := 0;
      OutF.WriteBuffer(dwExtendedHeader, SizeOf(dwExtendedHeader));
      HeaderOffsetShift := SizeOf(dwExtendedHeader);
    end;
    // Write Record Count
    w:=recnum;
    OutF.WriteBuffer(w,2);
    // Write Pattern
    OutF.WriteBuffer(patsz,1);
    // Write SYM Offset (for now zerro)
    dwc:=0;
    OutF.WriteBuffer(dwc,4);
    // Write STR Offset (for now zerro)
    dws:=0;
    OutF.WriteBuffer(dws,4);
    // Write Comment
    b:=AnsiByteLength(comment);
    OutF.WriteBuffer(b,1);
    WriteAnsiString(OutF, comment);
    // Write SYMS
    dwc:=OutF.Position;
    Bytes.Seek(0,soFromBeginning);
    For dw:=0 To Bytes.Size-1 Do
     Begin
      Bytes.ReadBuffer(b,1);
      OutF.WriteBuffer(b,1);
     End;
    // Write STRs
    dws:=OutF.Position;
    Names.Seek(0,soFromBeginning);
    For dw:=0 To Names.Size-1 Do
     Begin
      Names.ReadBuffer(b,1);
      OutF.WriteBuffer(b,1);
     End;
    // Write SYM Offset (for now zerro)
    OutF.Seek(8 + HeaderOffsetShift,soFromBeginning);
    OutF.WriteBuffer(dwc,4);
    // Write STR Offset (for now zerro)
    OutF.Seek(12 + HeaderOffsetShift,soFromBeginning);
    OutF.WriteBuffer(dws,4);

    WriteZipEntryFromStream(sFileName, sFileName, OutF);
  Finally
    OutF.Free;
  End;
End;

Function LoadBPLSymbolFile(
  Var Bytes,Names : TMemoryStream;
  sFileName : String;
  var mode,patsz : Byte;
  var recnum : LongInt;
  var comment : String;
  var indexarr : TBoundArray) : Boolean;
var InF : TMemoryStream;
    s : String;
    b : Byte;
    w : Word;
    dw,dwc,dws,dwExtendedHeader : DWORD;
begin
  Bytes.Clear;
  Names.Clear;

  InF:=TMemoryStream.Create;
  Result:=False;
  Try
    ExtractZipEntryToStream(sFileName, ExtractFileName(sFileName), InF);
    InF.Seek(0,soFromBeginning);

    // Read Magic
    s := ReadAnsiString(InF, 4);
    If s<>'DSF!' Then Exit;
    // Read Flags
    InF.ReadBuffer(mode,1);
    if (mode and DSF_FLAG_EXTENDED_HEADER) <> 0 then
      InF.ReadBuffer(dwExtendedHeader, SizeOf(dwExtendedHeader));
    // Read Record Count
    InF.ReadBuffer(w,2);
    recnum:=w;
    // Read Pattern Size
    InF.ReadBuffer(patsz,1);
    // Read SYM Offset
    InF.ReadBuffer(dwc,4);
    // Read STR Offset
    InF.ReadBuffer(dws,4);
    // Read Comment
    InF.ReadBuffer(b,1);
    comment := ReadAnsiString(InF, b);

    // Read SYMS
    InF.Seek(dwc,soFromBeginning);
    For dw:=0 To (recnum*patsz)-1 Do
     Begin
      InF.ReadBuffer(b,1);
      Bytes.WriteBuffer(b,1);
     End;
    // Read STRs
    SetLength(indexarr, recnum);
    InF.Seek(dws, soFromBeginning);
    dw:=0;
    Repeat
      try
        InF.ReadBuffer(b,1);
        s := ReadAnsiString(InF, b);
      except
        on E: Exception do
          raise EReadError.CreateFmt(
            'Invalid DSF name record at index %d: %s', [dw, E.Message]);
      end;
      // Creating Index Array
      indexarr[dw]:=Names.Position;
      Names.WriteBuffer(b,1);
      WriteAnsiBytes(Names,s,b);
      Inc(dw);
    Until dw>=recnum;

    Result:=True;
  Finally
   InF.Free;
  End;
end;

end.
