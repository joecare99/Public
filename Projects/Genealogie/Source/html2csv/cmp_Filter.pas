unit cmp_Filter;

{$mode delphi}

interface

uses
  Classes, SysUtils;

Type
   TComputeProc=procedure(CType: byte; Text: String) of object;

   TEnumFiltertype=(
      ft_On,  // Ausgabe Einschalten
      ft_Off, // Ausgabe Ausschalten
      ft_jump, // Sprung
      ft_Out); // Ausgabe einer Kennung

   {TFilterDef}
   TFilterRule=record
     FType:TEnumFiltertype;
     JumpLine:integer;
     TestString:String;
   end;

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

Const CFilterOut='+';
      CFilterOn='[';
      CFilterOff=']';
      CFilterJump='j';

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
  var
    lTestLine: String;
  begin
    lTestLine:='';
    if (Ftestline < FSchema.Count) then
      lTestLine:=FSchema[FTestLine];
    if FVerbose and assigned(FOnLineChange) then
      FOnLineChange(self);
    if lTestLine.StartsWith(CFilterOut) then
    begin
      if assigned(ComputeFiltered) then
        ComputeFiltered(0,copy(lTestLine, 2));
      Inc(FTestLine);
      if FVerbose and assigned(FOnLineChange) then
        FOnLineChange(self);
    end;
  end;

var
  lActFilter, lNextFilter: String;
  lDest: Longint;

begin
  if (FTestLine>=FSchema.Count) then exit(false);
  lActFilter := FSchema[FTestLine];
  lNextFilter := '';
  if (FTestLine < FSchema.Count - 1) then
      lNextFilter := FSchema[FTestLine+1];
  if  not  lActFilter.StartsWith(CFilterJump) and
   uppercase(s).StartsWith(uppercase(copy(lActFilter, 2))) then
  begin
    FFilterMode := lActFilter.StartsWith(CFilterOn);
    Inc(FTestLine);
    TestComputeFiltered;
  end
  else if lActFilter.StartsWith(CFilterJump) and
        TryStrToInt(copy(FSchema[FTestLine], 2, 2),lDest) and
        (uppercase(copy(lActFilter, 4)) = uppercase(leftstr(s,length(lActFilter) - 3))) then
      begin
        FTestLine := lDest;
        TestComputeFiltered;
      end
  else if lActFilter.StartsWith(CFilterJump) and
        uppercase(s).StartsWith(uppercase(copy(lNextFilter, 2))) then
      begin
        Inc(FTestLine);
        FilterMode := leftstr(lNextFilter, 1) = CFilterOn;
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

