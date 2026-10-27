unit DeDeXRef;

interface

uses
  Classes, SysUtils;

type
  TDeDeXRefKind = (dxkDirectCall, dxkIndirectCall);

  TDeDeXRef = class
  public
    SourceRoutineVA: LongWord;
    SourceInstructionVA: LongWord;
    TargetVA: LongWord;
    HasTarget: Boolean;
    IndirectOperandVA: LongWord;
    HasIndirectOperandVA: Boolean;
    Kind: TDeDeXRefKind;
    TargetName: string;
    TargetResolution: string;
    TargetNameSource: string;
    TargetNameConfidence: string;
    HasCallerCleanup: Boolean;
    CallerCleanupBytes: LongWord;
    CallerCleanupConflict: Boolean;
    HasEAXWriteBeforeCall: Boolean;
    EAXWriteInstructionVA: LongWord;
    HasECXWriteBeforeCall: Boolean;
    ECXWriteInstructionVA: LongWord;
    HasEDXWriteBeforeCall: Boolean;
    EDXWriteInstructionVA: LongWord;
  end;

  TDeDeRoutineEvidence = class
  private
    FFrameAccesses: TList;
  public
    RoutineVA: LongWord;
    RoutineName: string;
    RoutineNameConflict: Boolean;
    RoutineNameResolution: string;
    RoutineNameSource: string;
    RoutineNameConfidence: string;
    HasDisassemblyBody: Boolean;
    IsDirectCallTarget: Boolean;
    FrameProloguePending: Boolean;
    FramePrologueChecked: Boolean;
    HasFramePointerPrologue: Boolean;
    HasCalleeCleanup: Boolean;
    CalleeCleanupBytes: LongWord;
    CalleeCleanupConflict: Boolean;
    HasCallSiteCleanup: Boolean;
    CallSiteCleanupBytes: LongWord;
    CallSiteCleanupConflict: Boolean;
    CallSiteCleanupCount: Integer;
    constructor Create;
    destructor Destroy; override;
    function AddFrameAccess(AOffset: LongWord;
      AOperandSize: Integer; AInstructionVA: LongWord): Integer;
    function StackArgumentEvidence: string;
    function StackCleanupWordCount: Integer;
    property FrameAccesses: TList read FFrameAccesses;
  end;

  TDeDeFrameAccess = class
  public
    StackOffset: LongWord;
    OperandSize: Integer;
    AccessCount: Integer;
    InstructionVAs: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure AddInstruction(AVA: LongWord);
    function StackWordSlotIndex: Integer;
  end;

  TDeDeXRefList = class
  private
    FItems: TList;
    FRoutines: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TDeDeXRef;
    function GetRoutineCount: Integer;
    function GetRoutine(Index: Integer): TDeDeRoutineEvidence;
    function FindRoutine(ARoutineVA: LongWord): Integer;
    function EnsureRoutine(ARoutineVA: LongWord): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure BeginRoutine(ARoutineVA: LongWord);
    procedure MarkDirectCallTarget(ARoutineVA: LongWord);
    procedure RecordRoutineInstruction(ARoutineVA, AInstructionVA: LongWord;
      ABytes: PByte; ASize: Integer);
    procedure RecordFrameAccess(ARoutineVA: LongWord;
      AInstructionVA, AStackOffset: LongWord; AOperandSize: Integer);
    function FindRoutineEvidence(ARoutineVA: LongWord):
      TDeDeRoutineEvidence;
    function AddX86Instruction(ARoutineVA, AInstructionVA: LongWord;
      ABytes: PByte; ASize: Integer): Integer;
    procedure SetCallerCleanup(AReferenceIndex: Integer;
      ACleanupBytes: LongWord);
    procedure AddRegisterWriteEvidence(AReferenceIndex, ARegisterIndex: Integer;
      AInstructionVA: LongWord);
    procedure ResolveKnownMethod(ARoutineVA: LongWord;
      const AQualifiedName: string);
    procedure ResolveDSFSymbol(ARoutineVA: LongWord;
      const ASymbolName: string);
    procedure MarkDSFSymbolAmbiguous(ARoutineVA: LongWord);
    procedure ResolveImportCall(ARoutineVA, AInstructionVA: LongWord;
      const AImportName: string);
    procedure ResolveImportIATCall(ARoutineVA, AInstructionVA,
      AIATVA: LongWord; const AImportName: string);
    function ToJSON: string;
    function RoutinesToJSON: string;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDeDeXRef read GetItem; default;
    property RoutineCount: Integer read GetRoutineCount;
    property Routines[Index: Integer]: TDeDeRoutineEvidence
      read GetRoutine;
  end;

implementation

function JSONHex(AValue: LongWord): string;
begin
  Result := '"0x' + IntToHex(AValue, 8) + '"';
end;

function JSONString(const AValue: string): string;
var
  I: Integer;
begin
  Result := '"';
  for I := 1 to Length(AValue) do
    case AValue[I] of
      '"': Result := Result + '\"';
      '\': Result := Result + '\\';
      #8: Result := Result + '\b';
      #9: Result := Result + '\t';
      #10: Result := Result + '\n';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
    else
      if Ord(AValue[I]) < 32 then
        Result := Result + '\u00' + IntToHex(Ord(AValue[I]), 2)
      else
        Result := Result + AValue[I];
    end;
  Result := Result + '"';
end;

constructor TDeDeXRefList.Create;
begin
  inherited Create;
  FItems := TList.Create;
  FRoutines := TList.Create;
end;

destructor TDeDeXRefList.Destroy;
begin
  Clear;
  FItems.Free;
  FRoutines.Free;
  inherited Destroy;
end;

procedure TDeDeXRefList.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    TDeDeXRef(FItems[I]).Free;
  FItems.Clear;
  for I := 0 to FRoutines.Count - 1 do
    TDeDeRoutineEvidence(FRoutines[I]).Free;
  FRoutines.Clear;
end;

function TDeDeXRefList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TDeDeXRefList.GetItem(Index: Integer): TDeDeXRef;
begin
  Result := TDeDeXRef(FItems[Index]);
end;

function TDeDeXRefList.GetRoutineCount: Integer;
begin
  Result := FRoutines.Count;
end;

function TDeDeXRefList.GetRoutine(Index: Integer): TDeDeRoutineEvidence;
begin
  Result := TDeDeRoutineEvidence(FRoutines[Index]);
end;

function TDeDeXRefList.FindRoutine(ARoutineVA: LongWord): Integer;
var
  I: Integer;
begin
  for I := 0 to FRoutines.Count - 1 do
    if TDeDeRoutineEvidence(FRoutines[I]).RoutineVA = ARoutineVA then
      Exit(I);
  Result := -1;
end;

function TDeDeXRefList.EnsureRoutine(ARoutineVA: LongWord): Integer;
var
  Routine: TDeDeRoutineEvidence;
begin
  Result := FindRoutine(ARoutineVA);
  if Result >= 0 then
    Exit;
  Routine := TDeDeRoutineEvidence.Create;
  Routine.RoutineVA := ARoutineVA;
  FRoutines.Add(Routine);
  Result := FRoutines.Count - 1;
end;

function TDeDeXRefList.FindRoutineEvidence(
  ARoutineVA: LongWord): TDeDeRoutineEvidence;
var
  RoutineIndex: Integer;
begin
  RoutineIndex := FindRoutine(ARoutineVA);
  if RoutineIndex >= 0 then
    Result := TDeDeRoutineEvidence(FRoutines[RoutineIndex])
  else
    Result := nil;
end;

procedure TDeDeXRefList.BeginRoutine(ARoutineVA: LongWord);
var
  Routine: TDeDeRoutineEvidence;
begin
  Routine := TDeDeRoutineEvidence(FRoutines[EnsureRoutine(ARoutineVA)]);
  Routine.HasDisassemblyBody := True;
end;

procedure TDeDeXRefList.MarkDirectCallTarget(ARoutineVA: LongWord);
begin
  TDeDeRoutineEvidence(FRoutines[EnsureRoutine(ARoutineVA)])
    .IsDirectCallTarget := True;
end;

constructor TDeDeRoutineEvidence.Create;
begin
  inherited Create;
  FFrameAccesses := TList.Create;
end;

destructor TDeDeRoutineEvidence.Destroy;
var
  I: Integer;
begin
  for I := 0 to FFrameAccesses.Count - 1 do
    TDeDeFrameAccess(FFrameAccesses[I]).Free;
  FFrameAccesses.Free;
  inherited Destroy;
end;

constructor TDeDeFrameAccess.Create;
begin
  inherited Create;
  InstructionVAs := TStringList.Create;
end;

destructor TDeDeFrameAccess.Destroy;
begin
  InstructionVAs.Free;
  inherited Destroy;
end;

procedure TDeDeFrameAccess.AddInstruction(AVA: LongWord);
var
  VAString: string;
begin
  VAString := IntToHex(AVA, 8);
  if InstructionVAs.IndexOf(VAString) < 0 then
  begin
    InstructionVAs.Add(VAString);
    Inc(AccessCount);
  end;
end;

function TDeDeFrameAccess.StackWordSlotIndex: Integer;
begin
  if (StackOffset < 8) or (((StackOffset - 8) mod 4) <> 0) then
    Result := -1
  else
    Result := (StackOffset - 8) div 4;
end;

function TDeDeRoutineEvidence.AddFrameAccess(AOffset: LongWord;
  AOperandSize: Integer; AInstructionVA: LongWord): Integer;
var
  I: Integer;
  Access: TDeDeFrameAccess;
begin
  for I := 0 to FFrameAccesses.Count - 1 do
  begin
    Access := TDeDeFrameAccess(FFrameAccesses[I]);
    if (Access.StackOffset = AOffset) and
      (Access.OperandSize = AOperandSize) then
    begin
      Access.AddInstruction(AInstructionVA);
      Exit(I);
    end;
  end;
  Access := TDeDeFrameAccess.Create;
  Access.StackOffset := AOffset;
  Access.OperandSize := AOperandSize;
  Access.AddInstruction(AInstructionVA);
  FFrameAccesses.Add(Access);
  Result := FFrameAccesses.Count - 1;
end;

function TDeDeRoutineEvidence.StackArgumentEvidence: string;
var
  I: Integer;
  Access: TDeDeFrameAccess;
  CleanupBytes: LongWord;
  HasCleanupEvidence: Boolean;
begin
  if CallSiteCleanupConflict or CalleeCleanupConflict then
  begin
    Result := 'conflicting';
    Exit;
  end;
  if FFrameAccesses.Count = 0 then
  begin
    if (HasCallSiteCleanup and (CallSiteCleanupBytes > 0)) or
      (HasCalleeCleanup and (CalleeCleanupBytes > 0)) then
      Result := 'cleanup_only'
    else
      Result := '';
    Exit;
  end;
  HasCleanupEvidence := False;
  CleanupBytes := 0;
  if HasCallSiteCleanup then
  begin
    HasCleanupEvidence := True;
    CleanupBytes := CallSiteCleanupBytes;
  end;
  if HasCalleeCleanup and (CalleeCleanupBytes > 0) then
  begin
    if HasCleanupEvidence and (CleanupBytes <> CalleeCleanupBytes) then
    begin
      Result := 'conflicting';
      Exit;
    end;
    HasCleanupEvidence := True;
    CleanupBytes := CalleeCleanupBytes;
  end;
  if not HasCleanupEvidence then
  begin
    Result := 'frame_access_only';
    Exit;
  end;
  for I := 0 to FFrameAccesses.Count - 1 do
  begin
    Access := TDeDeFrameAccess(FFrameAccesses[I]);
    if (Access.StackOffset < 8) or
      (Access.StackOffset + LongWord(Access.OperandSize) > 8 + CleanupBytes) then
    begin
      Result := 'conflicting';
      Exit;
    end;
  end;
  Result := 'matched';
end;

function TDeDeRoutineEvidence.StackCleanupWordCount: Integer;
var
  CleanupBytes: LongWord;
  HasCleanupEvidence: Boolean;
begin
  Result := -1;
  if CallSiteCleanupConflict or CalleeCleanupConflict then
    Exit;
  HasCleanupEvidence := False;
  CleanupBytes := 0;
  if HasCallSiteCleanup then
  begin
    CleanupBytes := CallSiteCleanupBytes;
    HasCleanupEvidence := True;
  end;
  if HasCalleeCleanup and (CalleeCleanupBytes > 0) then
  begin
    if HasCleanupEvidence and (CleanupBytes <> CalleeCleanupBytes) then
      Exit;
    CleanupBytes := CalleeCleanupBytes;
    HasCleanupEvidence := True;
  end;
  if not HasCleanupEvidence or (CleanupBytes mod 4 <> 0) then
    Exit;
  Result := CleanupBytes div 4;
end;

procedure TDeDeXRefList.RecordRoutineInstruction(ARoutineVA,
  AInstructionVA: LongWord; ABytes: PByte; ASize: Integer);
var
  Routine: TDeDeRoutineEvidence;
  RoutineIndex: Integer;
  CleanupBytes: LongWord;
begin
  if (ABytes = nil) or (ASize <= 0) then
    Exit;
  RoutineIndex := FindRoutine(ARoutineVA);
  if RoutineIndex < 0 then
  begin
    RoutineIndex := EnsureRoutine(ARoutineVA);
  end;
  Routine := TDeDeRoutineEvidence(FRoutines[RoutineIndex]);
  if not Routine.FramePrologueChecked then
  begin
    if Routine.FrameProloguePending then
    begin
      Routine.FrameProloguePending := False;
      Routine.FramePrologueChecked := True;
      if (AInstructionVA = ARoutineVA + 1) and (ASize >= 2) and
        (((ABytes[0] = $8B) and (ABytes[1] = $EC)) or
         ((ABytes[0] = $89) and (ABytes[1] = $E5))) then
        Routine.HasFramePointerPrologue := True;
    end
    else if AInstructionVA = ARoutineVA then
    begin
      if (ASize = 1) and (ABytes[0] = $55) then
        Routine.FrameProloguePending := True
      else
      begin
        Routine.FramePrologueChecked := True;
        Routine.HasFramePointerPrologue :=
          (ASize >= 2) and (((ABytes[0] = $8B) and (ABytes[1] = $EC)) or
          ((ABytes[0] = $89) and (ABytes[1] = $E5)));
      end;
    end;
  end;
  if not (ABytes^ in [$C2, $C3]) then
    Exit;
  if (ABytes^ = $C2) and (ASize < 3) then
    Exit;
  if ABytes^ = $C2 then
    CleanupBytes := LongWord(ABytes[1]) or (LongWord(ABytes[2]) shl 8)
  else
    CleanupBytes := 0;
  if not Routine.HasCalleeCleanup then
  begin
    Routine.CalleeCleanupBytes := CleanupBytes;
    Routine.HasCalleeCleanup := True;
  end
  else if Routine.CalleeCleanupBytes <> CleanupBytes then
    Routine.CalleeCleanupConflict := True;
end;

procedure TDeDeXRefList.RecordFrameAccess(ARoutineVA,
  AInstructionVA, AStackOffset: LongWord; AOperandSize: Integer);
var
  RoutineIndex: Integer;
  Routine: TDeDeRoutineEvidence;
begin
  RoutineIndex := FindRoutine(ARoutineVA);
  if RoutineIndex < 0 then
    Exit;
  Routine := TDeDeRoutineEvidence(FRoutines[RoutineIndex]);
  if not Routine.HasFramePointerPrologue or
    (AStackOffset < 8) or (AStackOffset > $1000) or
    not (AOperandSize in [1, 2, 4, 8, 10]) then
    Exit;
  Routine.AddFrameAccess(AStackOffset, AOperandSize, AInstructionVA);
end;

function TDeDeXRefList.AddX86Instruction(ARoutineVA,
  AInstructionVA: LongWord; ABytes: PByte; ASize: Integer): Integer;
var
  Reference: TDeDeXRef;
  Displacement: Int64;
  UnsignedDisplacement: LongWord;
  Target: Int64;
  I: Integer;
  Kind: TDeDeXRefKind;
  HasTarget: Boolean;
  TargetVA: LongWord;
  HasIndirectOperandVA: Boolean;
  IndirectOperandVA: LongWord;
begin
  if (ABytes = nil) or (ASize <= 0) then
    Exit(-1);

  HasTarget := False;
  TargetVA := 0;
  HasIndirectOperandVA := False;
  IndirectOperandVA := 0;
  if (ABytes^ = $E8) and (ASize >= 5) then
  begin
    UnsignedDisplacement :=
      LongWord(ABytes[1]) or
      (LongWord(ABytes[2]) shl 8) or
      (LongWord(ABytes[3]) shl 16) or
      (LongWord(ABytes[4]) shl 24);
    if UnsignedDisplacement >= $80000000 then
      Displacement := Int64(UnsignedDisplacement) - $100000000
    else
      Displacement := UnsignedDisplacement;
    Target := Int64(AInstructionVA) + 5 + Displacement;
    TargetVA := LongWord(Target and $FFFFFFFF);
    HasTarget := True;
    Kind := dxkDirectCall;
  end
  else if (ABytes^ = $FF) and (ASize >= 2) then
  begin
    I := (ABytes[1] shr 3) and $07;
    if (I <> 2) and (I <> 3) then
      Exit(-1);
    Kind := dxkIndirectCall;
    if (((ABytes[1] shr 6) and $03) = 0) and
      ((ABytes[1] and $07) = 5) and (ASize >= 6) then
    begin
      HasIndirectOperandVA := True;
      IndirectOperandVA := LongWord(ABytes[2]) or
        (LongWord(ABytes[3]) shl 8) or
        (LongWord(ABytes[4]) shl 16) or
        (LongWord(ABytes[5]) shl 24);
    end;
  end
  else
    Exit(-1);

  for I := 0 to FItems.Count - 1 do
  begin
    Reference := TDeDeXRef(FItems[I]);
    if (Reference.SourceRoutineVA = ARoutineVA) and
      (Reference.SourceInstructionVA = AInstructionVA) and
      (Reference.Kind = Kind) then
      Exit(I);
  end;

  Reference := TDeDeXRef.Create;
  Reference.SourceRoutineVA := ARoutineVA;
  Reference.SourceInstructionVA := AInstructionVA;
  Reference.TargetVA := TargetVA;
  Reference.HasTarget := HasTarget;
  Reference.Kind := Kind;
  Reference.IndirectOperandVA := IndirectOperandVA;
  Reference.HasIndirectOperandVA := HasIndirectOperandVA;
  Reference.HasCallerCleanup := False;
  Reference.CallerCleanupBytes := 0;
  Reference.CallerCleanupConflict := False;
  FItems.Add(Reference);
  Result := FItems.Count - 1;
end;

procedure TDeDeXRefList.SetCallerCleanup(AReferenceIndex: Integer;
  ACleanupBytes: LongWord);
var
  Reference: TDeDeXRef;
  RoutineIndex: Integer;
  Routine: TDeDeRoutineEvidence;
begin
  Reference := TDeDeXRef(FItems[AReferenceIndex]);
  if Reference.HasCallerCleanup then
  begin
    if Reference.CallerCleanupBytes <> ACleanupBytes then
    begin
      Reference.CallerCleanupConflict := True;
      if Reference.HasTarget then
      begin
        RoutineIndex := FindRoutine(Reference.TargetVA);
        if RoutineIndex >= 0 then
          TDeDeRoutineEvidence(FRoutines[RoutineIndex])
            .CallSiteCleanupConflict := True;
      end;
    end;
    Exit;
  end;
  Reference.HasCallerCleanup := True;
  Reference.CallerCleanupBytes := ACleanupBytes;
  if not Reference.HasTarget then
    Exit;
  RoutineIndex := FindRoutine(Reference.TargetVA);
  if RoutineIndex < 0 then
    RoutineIndex := EnsureRoutine(Reference.TargetVA);
  Routine := TDeDeRoutineEvidence(FRoutines[RoutineIndex]);
  if Routine.HasCallSiteCleanup then
  begin
    if Routine.CallSiteCleanupBytes <> ACleanupBytes then
      Routine.CallSiteCleanupConflict := True;
  end
  else
  begin
    Routine.HasCallSiteCleanup := True;
    Routine.CallSiteCleanupBytes := ACleanupBytes;
  end;
  Inc(Routine.CallSiteCleanupCount);
end;

procedure TDeDeXRefList.AddRegisterWriteEvidence(AReferenceIndex,
  ARegisterIndex: Integer; AInstructionVA: LongWord);
var
  Reference: TDeDeXRef;
begin
  Reference := TDeDeXRef(FItems[AReferenceIndex]);
  case ARegisterIndex of
    0:
      begin
        Reference.HasEAXWriteBeforeCall := True;
        Reference.EAXWriteInstructionVA := AInstructionVA;
      end;
    1:
      begin
        Reference.HasECXWriteBeforeCall := True;
        Reference.ECXWriteInstructionVA := AInstructionVA;
      end;
    2:
      begin
        Reference.HasEDXWriteBeforeCall := True;
        Reference.EDXWriteInstructionVA := AInstructionVA;
      end;
  else
    raise EArgumentOutOfRangeException.Create('ARegisterIndex');
  end;
end;

procedure TDeDeXRefList.ResolveKnownMethod(ARoutineVA: LongWord;
  const AQualifiedName: string);
var
  I: Integer;
  Reference: TDeDeXRef;
  Routine: TDeDeRoutineEvidence;
begin
  for I := 0 to FRoutines.Count - 1 do
  begin
    Routine := TDeDeRoutineEvidence(FRoutines[I]);
    if Routine.RoutineVA = ARoutineVA then
      if (Routine.RoutineNameSource = 'built_in_dsf') or
        (Routine.RoutineNameResolution = 'ambiguous_dsf_symbol') then
      begin
        Routine.RoutineName := AQualifiedName;
        Routine.RoutineNameConflict := False;
        Routine.RoutineNameResolution := 'known_class_method';
        Routine.RoutineNameSource := 'class_metadata';
        Routine.RoutineNameConfidence := 'exact_address';
      end
      else if not Routine.RoutineNameConflict then
      begin
        if Routine.RoutineName = '' then
        begin
          Routine.RoutineName := AQualifiedName;
          Routine.RoutineNameResolution := 'known_class_method';
          Routine.RoutineNameSource := 'class_metadata';
          Routine.RoutineNameConfidence := 'exact_address';
        end
        else if Routine.RoutineName <> AQualifiedName then
        begin
          Routine.RoutineName := '';
          Routine.RoutineNameConflict := True;
          Routine.RoutineNameResolution := 'ambiguous_class_method';
          Routine.RoutineNameSource := '';
          Routine.RoutineNameConfidence := '';
        end;
      end;
  end;
  for I := 0 to FItems.Count - 1 do
  begin
    Reference := TDeDeXRef(FItems[I]);
    if Reference.HasTarget and (Reference.TargetVA = ARoutineVA) then
      if (Reference.TargetResolution = 'known_dsf_symbol') or
        (Reference.TargetResolution = 'ambiguous_dsf_symbol') then
      begin
        Reference.TargetName := AQualifiedName;
        Reference.TargetResolution := 'known_class_method';
        Reference.TargetNameSource := 'class_metadata';
        Reference.TargetNameConfidence := 'exact_address';
      end
      else if (Reference.TargetResolution <> 'ambiguous_class_method') and
        (Reference.TargetResolution <> 'known_import') and
        (Reference.TargetResolution <> 'ambiguous_target') then
      begin
        if Reference.TargetName = '' then
        begin
          Reference.TargetName := AQualifiedName;
          Reference.TargetResolution := 'known_class_method';
          Reference.TargetNameSource := 'class_metadata';
          Reference.TargetNameConfidence := 'exact_address';
        end
        else if Reference.TargetName <> AQualifiedName then
        begin
          Reference.TargetName := '';
          Reference.TargetResolution := 'ambiguous_class_method';
          Reference.TargetNameSource := '';
          Reference.TargetNameConfidence := '';
        end;
      end;
  end;
end;

procedure TDeDeXRefList.ResolveDSFSymbol(ARoutineVA: LongWord;
  const ASymbolName: string);
var
  I: Integer;
  Routine: TDeDeRoutineEvidence;
  Reference: TDeDeXRef;
begin
  if ASymbolName = '' then
    Exit;
  Routine := TDeDeRoutineEvidence(FRoutines[EnsureRoutine(ARoutineVA)]);
  if not Routine.RoutineNameConflict and
    (Routine.RoutineNameSource <> 'class_metadata') then
  begin
    if Routine.RoutineName = '' then
    begin
      Routine.RoutineName := ASymbolName;
      Routine.RoutineNameResolution := 'known_dsf_symbol';
      Routine.RoutineNameSource := 'built_in_dsf';
      Routine.RoutineNameConfidence := 'exact_pattern';
    end
    else if (Routine.RoutineNameSource = 'built_in_dsf') and
      (Routine.RoutineName <> ASymbolName) then
    begin
      Routine.RoutineName := '';
      Routine.RoutineNameConflict := True;
      Routine.RoutineNameResolution := 'ambiguous_dsf_symbol';
      Routine.RoutineNameSource := '';
      Routine.RoutineNameConfidence := '';
    end;
  end;

  for I := 0 to FItems.Count - 1 do
  begin
    Reference := TDeDeXRef(FItems[I]);
    if not Reference.HasTarget or (Reference.TargetVA <> ARoutineVA) then
      Continue;
    if (Reference.TargetResolution = 'known_class_method') or
      (Reference.TargetResolution = 'known_import') or
      (Reference.TargetResolution = 'ambiguous_class_method') or
      (Reference.TargetResolution = 'ambiguous_target') or
      (Reference.TargetResolution = 'ambiguous_dsf_symbol') then
      Continue;
    if Reference.TargetName = '' then
    begin
      Reference.TargetName := ASymbolName;
      Reference.TargetResolution := 'known_dsf_symbol';
      Reference.TargetNameSource := 'built_in_dsf';
      Reference.TargetNameConfidence := 'exact_pattern';
    end
    else if (Reference.TargetNameSource = 'built_in_dsf') and
      (Reference.TargetName <> ASymbolName) then
    begin
      Reference.TargetName := '';
      Reference.TargetResolution := 'ambiguous_dsf_symbol';
      Reference.TargetNameSource := '';
      Reference.TargetNameConfidence := '';
    end;
  end;
end;

procedure TDeDeXRefList.MarkDSFSymbolAmbiguous(ARoutineVA: LongWord);
var
  I: Integer;
  Routine: TDeDeRoutineEvidence;
  Reference: TDeDeXRef;
begin
  Routine := TDeDeRoutineEvidence(FRoutines[EnsureRoutine(ARoutineVA)]);
  if (Routine.RoutineNameSource = 'class_metadata') or
    (Routine.RoutineNameResolution = 'ambiguous_class_method') then
    Exit;
  Routine.RoutineName := '';
  Routine.RoutineNameConflict := True;
  Routine.RoutineNameResolution := 'ambiguous_dsf_symbol';
  Routine.RoutineNameSource := '';
  Routine.RoutineNameConfidence := '';
  for I := 0 to FItems.Count - 1 do
  begin
    Reference := TDeDeXRef(FItems[I]);
    if not Reference.HasTarget or (Reference.TargetVA <> ARoutineVA) then
      Continue;
    if (Reference.TargetResolution = 'known_class_method') or
      (Reference.TargetResolution = 'known_import') or
      (Reference.TargetResolution = 'ambiguous_class_method') or
      (Reference.TargetResolution = 'ambiguous_target') then
      Continue;
    Reference.TargetName := '';
    Reference.TargetResolution := 'ambiguous_dsf_symbol';
    Reference.TargetNameSource := '';
    Reference.TargetNameConfidence := '';
  end;
end;

procedure TDeDeXRefList.ResolveImportCall(ARoutineVA,
  AInstructionVA: LongWord; const AImportName: string);
var
  I: Integer;
  Reference: TDeDeXRef;
begin
  if AImportName = '' then
    Exit;
  for I := 0 to FItems.Count - 1 do
  begin
    Reference := TDeDeXRef(FItems[I]);
    if (Reference.SourceRoutineVA = ARoutineVA) and
      (Reference.SourceInstructionVA = AInstructionVA) and
      (Reference.Kind = dxkDirectCall) then
    begin
      if (Reference.TargetName <> '') and
        (Reference.TargetName <> AImportName) then
      begin
        Reference.TargetName := '';
        Reference.TargetResolution := 'ambiguous_target';
        Reference.TargetNameSource := '';
        Reference.TargetNameConfidence := '';
      end
      else
      begin
        Reference.TargetName := AImportName;
        Reference.TargetResolution := 'known_import';
        Reference.TargetNameSource := 'pe_import_table';
        Reference.TargetNameConfidence := 'exact_import';
      end;
    end;
  end;
end;

procedure TDeDeXRefList.ResolveImportIATCall(ARoutineVA,
  AInstructionVA, AIATVA: LongWord; const AImportName: string);
var
  I: Integer;
  Reference: TDeDeXRef;
begin
  if AImportName = '' then
    Exit;
  for I := 0 to FItems.Count - 1 do
  begin
    Reference := TDeDeXRef(FItems[I]);
    if (Reference.SourceRoutineVA = ARoutineVA) and
      (Reference.SourceInstructionVA = AInstructionVA) and
      (Reference.Kind = dxkIndirectCall) and
      Reference.HasIndirectOperandVA and
      (Reference.IndirectOperandVA = AIATVA) then
    begin
      if (Reference.TargetName <> '') and
        (Reference.TargetName <> AImportName) then
      begin
        Reference.TargetName := '';
        Reference.TargetResolution := 'ambiguous_target';
        Reference.TargetNameSource := '';
        Reference.TargetNameConfidence := '';
      end
      else
      begin
        Reference.TargetName := AImportName;
        Reference.TargetResolution := 'known_import';
        Reference.TargetNameSource := 'pe_import_table';
        Reference.TargetNameConfidence := 'exact_import';
      end;
    end;
  end;
end;

function TDeDeXRefList.ToJSON: string;
var
  I: Integer;
  Reference: TDeDeXRef;
  KindName: string;
begin
  Result := '[';
  for I := 0 to FItems.Count - 1 do
  begin
    if I > 0 then
      Result := Result + ',';
    Reference := TDeDeXRef(FItems[I]);
    if Reference.Kind = dxkDirectCall then
      KindName := 'direct_call'
    else
      KindName := 'indirect_call';
    Result := Result + #13#10 + '    {' +
      '"sourceRoutineVa":' + JSONHex(Reference.SourceRoutineVA) + ',' +
      '"sourceInstructionVa":' +
        JSONHex(Reference.SourceInstructionVA) + ',' +
      '"kind":"' + KindName + '",' +
      '"targetVa":';
    if Reference.HasTarget then
      Result := Result + JSONHex(Reference.TargetVA)
    else
      Result := Result + 'null';
    Result := Result + ',"importIatVa":';
    if Reference.HasIndirectOperandVA then
      Result := Result + JSONHex(Reference.IndirectOperandVA)
    else
      Result := Result + 'null';
    Result := Result + ',"callerCleanupBytes":';
    if Reference.HasCallerCleanup then
      Result := Result + IntToStr(Reference.CallerCleanupBytes)
    else
      Result := Result + 'null';
    Result := Result + ',"callerCleanupConflict":' +
      LowerCase(BoolToStr(Reference.CallerCleanupConflict, True)) +
      ',"targetResolution":';
    if Reference.TargetResolution <> '' then
      Result := Result + JSONString(Reference.TargetResolution)
    else
      Result := Result + '"unresolved"';
    Result := Result + ',"targetName":';
    if Reference.TargetName <> '' then
      Result := Result + JSONString(Reference.TargetName)
    else
      Result := Result + 'null';
    Result := Result + ',"targetNameSource":';
    if Reference.TargetNameSource <> '' then
      Result := Result + JSONString(Reference.TargetNameSource)
    else
      Result := Result + 'null';
    Result := Result + ',"targetNameConfidence":';
    if Reference.TargetNameConfidence <> '' then
      Result := Result + JSONString(Reference.TargetNameConfidence)
    else
      Result := Result + 'null';
    Result := Result + ',"registerWritesBeforeCall":[';
    if Reference.HasEAXWriteBeforeCall then
      Result := Result + '{"register":"eax","instructionRva":' +
        JSONHex(Reference.EAXWriteInstructionVA) + '}';
    if Reference.HasEDXWriteBeforeCall then
    begin
      if Reference.HasEAXWriteBeforeCall then
        Result := Result + ',';
      Result := Result + '{"register":"edx","instructionRva":' +
        JSONHex(Reference.EDXWriteInstructionVA) + '}';
    end;
    if Reference.HasECXWriteBeforeCall then
    begin
      if Reference.HasEAXWriteBeforeCall or
        Reference.HasEDXWriteBeforeCall then
        Result := Result + ',';
      Result := Result + '{"register":"ecx","instructionRva":' +
        JSONHex(Reference.ECXWriteInstructionVA) + '}';
    end;
    Result := Result + ']';
    Result := Result + '}';
  end;
  if FItems.Count > 0 then
    Result := Result + #13#10 + '  ';
  Result := Result + ']';
end;

function TDeDeXRefList.RoutinesToJSON: string;
var
  I, J, K: Integer;
  Routine: TDeDeRoutineEvidence;
begin
  Result := '[';
  for I := 0 to FRoutines.Count - 1 do
  begin
    if I > 0 then
      Result := Result + ',';
    Routine := TDeDeRoutineEvidence(FRoutines[I]);
    Result := Result + #13#10 + '    {' +
      '"va":' + JSONHex(Routine.RoutineVA) +
      ',"hasDisassemblyBody":' +
        LowerCase(BoolToStr(Routine.HasDisassemblyBody, True)) +
      ',"isDirectCallTarget":' +
        LowerCase(BoolToStr(Routine.IsDirectCallTarget, True)) +
      ',"calleeCleanupBytes":';
    if Routine.HasCalleeCleanup then
      Result := Result + IntToStr(Routine.CalleeCleanupBytes)
    else
      Result := Result + 'null';
    Result := Result + ',"calleeCleanupConflict":' +
      LowerCase(BoolToStr(Routine.CalleeCleanupConflict, True)) +
      ',"callSiteCleanupBytes":';
    if Routine.HasCallSiteCleanup then
      Result := Result + IntToStr(Routine.CallSiteCleanupBytes)
    else
      Result := Result + 'null';
    Result := Result + ',"callSiteCleanupConflict":' +
      LowerCase(BoolToStr(Routine.CallSiteCleanupConflict, True)) +
      ',"callSiteCleanupCount":' +
      IntToStr(Routine.CallSiteCleanupCount) +
      ',"stackCleanupWordCountCandidate":';
    if Routine.StackCleanupWordCount >= 0 then
      Result := Result + IntToStr(Routine.StackCleanupWordCount)
    else
      Result := Result + 'null';
    Result := Result + ',"nameResolution":';
    if Routine.RoutineNameResolution <> '' then
      Result := Result + JSONString(Routine.RoutineNameResolution)
    else
      Result := Result + '"unresolved"';
    Result := Result + ',"name":';
    if Routine.RoutineName <> '' then
      Result := Result + JSONString(Routine.RoutineName)
    else
      Result := Result + 'null';
    Result := Result + ',"nameSource":';
    if Routine.RoutineNameSource <> '' then
      Result := Result + JSONString(Routine.RoutineNameSource)
    else
      Result := Result + 'null';
    Result := Result + ',"nameConfidence":';
    if Routine.RoutineNameConfidence <> '' then
      Result := Result + JSONString(Routine.RoutineNameConfidence)
    else
      Result := Result + 'null';
    Result := Result + ',"hasFramePointerPrologue":' +
      LowerCase(BoolToStr(Routine.HasFramePointerPrologue, True)) +
      ',"stackArgumentEvidence":';
    if Routine.StackArgumentEvidence <> '' then
      Result := Result + JSONString(Routine.StackArgumentEvidence)
    else
      Result := Result + 'null';
    Result := Result +
      ',"stackParameterAccesses":[';
    for J := 0 to Routine.FrameAccesses.Count - 1 do
    begin
      if J > 0 then
        Result := Result + ',';
      with TDeDeFrameAccess(Routine.FrameAccesses[J]) do
      begin
        Result := Result + '{"stackOffset":' + JSONHex(StackOffset) +
          ',"operandSize":' + IntToStr(OperandSize) +
          ',"stackWordSlotIndex":';
        if StackWordSlotIndex >= 0 then
          Result := Result + IntToStr(StackWordSlotIndex)
        else
          Result := Result + 'null';
        Result := Result + ',"accessCount":' + IntToStr(AccessCount) +
          ',"instructionVas":[';
        for K := 0 to InstructionVAs.Count - 1 do
        begin
          if K > 0 then
            Result := Result + ',';
          Result := Result + '"0x' + InstructionVAs[K] + '"';
        end;
        Result := Result + ']}';
      end;
    end;
    Result := Result + ']';
    Result := Result + '}';
  end;
  if FRoutines.Count > 0 then
    Result := Result + #13#10 + '  ';
  Result := Result + ']';
end;

end.
