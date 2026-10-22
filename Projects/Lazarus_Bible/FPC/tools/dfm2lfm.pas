program DfmToLfm;
uses SysUtils, Classes;
var raw, InS, OutS: TMemoryStream;
    Dest: TFileStream;
    i, pos, N: Integer;
    fname: string;
    b0, b1, b2, b3: Byte;
begin
  if ParamCount <> 1 then begin writeln('dfm2lfm <file.dfm>'); halt(1); end;
  fname := ParamStr(1);
  raw := TMemoryStream.Create;
  raw.LoadFromFile(fname);
  N := raw.Size;
  pos := -1;
  for i := 0 to N - 4 do
  begin
    b0 := PByte(raw.Memory)[i];
    b1 := PByte(raw.Memory)[i + 1];
    b2 := PByte(raw.Memory)[i + 2];
    b3 := PByte(raw.Memory)[i + 3];
    if (b0 = $54) and (b1 = $50) and (b2 = $46) and (b3 = $30) then
    begin
      pos := i; break;
    end;
  end;
  if pos < 0 then begin writeln('TPF0 marker not found in ', fname); raw.Free; halt(2); end;

  InS := TMemoryStream.Create;
  OutS := TMemoryStream.Create;
  Dest := nil;
  try
    InS.CopyFrom(raw, raw.Size);
    InS.Position := pos;
    try
      ObjectBinaryToText(InS, OutS);
    except
      on E: Exception do
      begin
        writeln('convert failed for ', fname, ': ', E.Message);
        halt(3);
      end;
    end;
    OutS.Position := 0;
    Dest := TFileStream.Create(fname + '.lfm.txt', fmCreate);
    Dest.CopyFrom(OutS, OutS.Size);
  finally
    InS.Free;
    OutS.Free;
    Dest.Free;
    raw.Free;
  end;
  writeln('converted ', fname);
end.
