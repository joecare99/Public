unit DeDeBinaryTypes;

interface

type
  TPE32RVA = type LongWord;
  TPE32VA = type LongWord;
  TPE32FileOffset = type LongWord;

function TryAddPE32FileOffset(const ABase, ADelta: TPE32FileOffset;
  out AResult: TPE32FileOffset): Boolean;
function TryGetPE32RVA(const AImageBase, AVirtualAddress: TPE32VA;
  out ARVA: TPE32RVA): Boolean;

implementation

function TryAddPE32FileOffset(const ABase, ADelta: TPE32FileOffset;
  out AResult: TPE32FileOffset): Boolean;
begin
  Result := ABase <= High(LongWord) - ADelta;
  if Result then
    AResult := TPE32FileOffset(LongWord(ABase) + LongWord(ADelta))
  else
    AResult := 0;
end;

function TryGetPE32RVA(const AImageBase, AVirtualAddress: TPE32VA;
  out ARVA: TPE32RVA): Boolean;
begin
  Result := AVirtualAddress >= AImageBase;
  if Result then
    ARVA := TPE32RVA(LongWord(AVirtualAddress) - LongWord(AImageBase))
  else
    ARVA := 0;
end;

end.
