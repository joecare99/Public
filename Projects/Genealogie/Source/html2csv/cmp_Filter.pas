unit cmp_Filter;

{$mode delphi}

interface

uses
  Classes, SysUtils;

Type
   TComputeProc=procedure(CType: byte; Text: String) of object;

   { TBaseFilter }

   TBaseFilter = Class(TComponent)
   private
     FFilterMode: Boolean;
     FVerbose:Boolean;
     FOnLineChange: TNotifyEvent;
     FTestLine: integer;
     FSchema:TStrings;
     procedure SetFilterMode(AValue: boolean);
     procedure SetOnLineChange(AValue: TNotifyEvent);
     procedure SetSchema(AValue: TStrings);
     procedure SetTestLine(AValue: integer);
     procedure SetVerbose(AValue: boolean);
   public
     destructor Destroy; override;
     function TestFilter(s: string; ComputeFiltered: TComputeProc): boolean;
     PRocedure Reset;
     property OnLineChange:TNotifyEvent read FOnLineChange write SetOnLineChange;
     Property TestLine:integer read FTestLine write SetTestLine;
     property Schema:TStrings read FSchema write SetSchema;
     property FilterMode:boolean read FFilterMode write SetFilterMode;
     property Verbose:boolean read FVerbose write SetVerbose;
   end;


implementation

procedure TBaseFilter.SetOnLineChange(AValue: TNotifyEvent);
begin
  if @FOnLineChange=@AValue then Exit;
  FOnLineChange:=AValue;
end;

procedure TBaseFilter.SetFilterMode(AValue: boolean);
begin
  if FFilterMode=AValue then Exit;
  FFilterMode:=AValue;
end;

procedure TBaseFilter.SetSchema(AValue: TStrings);
begin
  if not assigned(FSchema) then
    FSchema := TStringList.Create;
  FSchema.Assign(AValue);
end;

procedure TBaseFilter.SetTestLine(AValue: integer);
begin
  if FTestLine=AValue then Exit;
  FTestLine:=AValue;
end;

procedure TBaseFilter.SetVerbose(AValue: boolean);
begin
  if FVerbose=AValue then Exit;
  FVerbose:=AValue;
end;

destructor TBaseFilter.Destroy;
begin
  FreeAndNil(FSchema);
  inherited Destroy;
end;

function TBaseFilter.TestFilter(s: string;ComputeFiltered:TComputeProc): boolean;

  procedure TestComputeFiltered;
  begin
    if FVerbose and assigned(FOnLineChange) then
      FOnLineChange(self);
    if (Ftestline < FSchema.Count) and (copy(FSchema[FTestLine], 1, 1) = '+') then
    begin
      if assigned(ComputeFiltered) then
        ComputeFiltered(0,copy(FSchema[TestLine], 2, 255));
      Inc(FTestLine);
      if FVerbose and assigned(FOnLineChange) then
        FOnLineChange(self);
    end;
  end;

begin
  if (FTestLine<FSchema.Count) then
  if   (copy(FSchema[FTestLine], 1, 1) <> 'j') and
   (uppercase(copy(FSchema[FTestLine], 2, length(s) + 1)) = uppercase(s)) then
  begin
    FFilterMode := copy(FSchema[FTestLine], 1, 1) = '[';
    Inc(FTestLine);
    TestComputeFiltered;
  end
  else if (copy(FSchema[TestLine], 1, 1) = 'j') and
        (uppercase(copy(FSchema[FTestLine], 4, length(s) + 1)) = uppercase(s)) then
      begin
        FTestLine := StrToInt(copy(FSchema[FTestLine], 2, 2));
        TestComputeFiltered;
      end
  else if (copy(FSchema[FTestLine], 1, 1) = 'j') and
        (FTestLine < FSchema.Count - 1) and
        (uppercase(copy(FSchema[FTestLine + 1], 2, length(s) + 1)) =
        uppercase(s)) then
      begin
        Inc(FTestLine);
        FilterMode := copy(FSchema[TestLine], 1, 1) = '[';
        Inc(FTestLine);
        TestComputeFiltered;
      end;
  Result := FFilterMode;
end;

procedure TBaseFilter.Reset;
begin
  FTestLine:=0;
  if assigned(FOnLineChange) then
    FOnLineChange(self);
end;

end.

