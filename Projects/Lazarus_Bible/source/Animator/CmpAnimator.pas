unit cmpAnimator;

interface

uses types,{$IFnDEF FPC}

{$ELSE}
  windows, LMessages, LCLType,
{$ENDIF} CommCtrl, Graphics, Messages,  classes, Controls;

type
 TCommonAVI = (aviNone, aviFindFolder, aviFindFile, aviFindComputer, aviCopyFiles,
    aviCopyFile, aviRecycleFile, aviEmptyRecycle, aviDeleteFile);

  TAnimateParams = record
    FileName: string;
    CommonAVI: TCommonAVI;
    ResHandle: THandle;
    ResName: string;
    ResId: Integer;
  end;

{$IF DEFINED(CLR)}
  TAnimateResId = TObject;
{$ELSE}
  TAnimateResId = Integer;
{$IFEND}

  TAnimate = class(TWinControl)
  private
    FActive: Boolean;
    FFileName: string;
    FCenter: Boolean;
    FCommonAVI: TCommonAVI;
    FFrameCount: Integer;
    FFrameHeight: Integer;
    FFrameWidth: Integer;
    FOpen: Boolean;
    FRecreateNeeded: Boolean;
    FRepetitions: Integer;
    FResHandle: THandle;
    FResId: Integer;
    FResName: string;
    FStreamedActive: Boolean;
    FTimers: Boolean;
    FTransparent: Boolean;
    FStartFrame: Smallint;
    FStopFrame: Smallint;
    FStopCount: Integer;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    procedure CheckOpen;
    function InternalClose: Boolean;
    function InternalOpen: Boolean;
    procedure GetAnimateParams(var Params: TAnimateParams);
    procedure SetAnimateParams(const Params: TAnimateParams);
    function GetActualResId: TAnimateResId;
    function GetActualResHandle: THandle;
    procedure GetFrameInfo;
    procedure SetActive(Value: Boolean);
    procedure SetFileName(Value: string);
    procedure SetCenter(Value: Boolean);
    procedure SetCommonAVI(Value: TCommonAVI);
    procedure SetOpen(Value: Boolean);
    procedure SetRepetitions(Value: Integer);
    procedure SetResHandle(Value: THandle);
    procedure SetResId(Value: Integer);
    procedure SetResName(Value: string);
    procedure SetTimers(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
    procedure SetStartFrame(Value: Smallint);
    procedure SetStopFrame(Value: Smallint);
    procedure UpdateActiveState;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DoOpen; virtual;
    procedure DoClose; virtual;
    procedure DoStart; virtual;
    procedure DoStop; virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    property FrameCount: Integer read FFrameCount;
    property FrameHeight: Integer read FFrameHeight;
    property FrameWidth: Integer read FFrameWidth;
    property Open: Boolean read FOpen write SetOpen;
    procedure Play(FromFrame, ToFrame: Word; Count: Integer);
    procedure Reset;
    procedure Seek(Frame: Smallint);
    procedure Stop;
    property ResHandle: THandle read FResHandle write SetResHandle;
    property ResId: Integer read FResId write SetResId;
    property ResName: string read FResName write SetResName;
  published
    property Align;
    property Active: Boolean read FActive write SetActive default False;
    property Anchors;
    property AutoSize default True;
    property BorderWidth;
    property Center: Boolean read FCenter write SetCenter default True;
    property Color;
    property CommonAVI: TCommonAVI read FCommonAVI write SetCommonAVI default aviNone;
    property Constraints;
    property DoubleBuffered;
    property FileName: string read FFileName write SetFileName;
    property ParentColor;
 //   property ParentDoubleBuffered;
    property ParentShowHint;
    property Repetitions: Integer read FRepetitions write SetRepetitions default 0;
    property ShowHint;
    property StartFrame: Smallint read FStartFrame write SetStartFrame default 1;
    property StopFrame: Smallint read FStopFrame write SetStopFrame default 0;
    property Timers: Boolean read FTimers write SetTimers default False;
 //   property Touch;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property Visible;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
 //    property OnGesture;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
  end;

implementation

uses sysutils;

resourcestring
  SCannotOpenAVI = 'AVI-Datei kann nicht geöffnet werden';
{ TAnimate }

constructor TAnimate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReflector];
  Width := 100;
  Height := 80;
  AutoSize := True;
  FCenter := True;
  FStartFrame := 1;
  FTransparent := True;
end;

procedure TAnimate.CreateParams(var Params: TCreateParams);
const
  CenterStyles: array[Boolean] of DWORD = (0, ACS_CENTER);
  TimerStyles: array[Boolean] of DWORD = (0, ACS_TIMER);
  TransparentStyles: array[Boolean] of DWORD = (0, ACS_TRANSPARENT);
begin
  InitCommonControl(ICC_ANIMATE_CLASS);
  inherited CreateParams(Params);
  { In versions of COMCTL32.DLL earlier than 4.71 the ANIMATE common control
    requires that it be created in the same instance address space as the AVI
    resource. }
  if GetComCtlVersion < ComCtlVersionIE4 then
    Params.WindowClass.hInstance := GetActualResHandle;
  CreateSubClass(Params, ANIMATE_CLASS);
  with Params do
  begin
    Style := Style or CenterStyles[FCenter] or
      TimerStyles[FTimers] or TransparentStyles[FTransparent];
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    { Make sure window class is unique per instance if running a version of
      COMCTl32.DLL which doesn't support loading an AVI resource from a separate
      address space. }
    if GetComCtlVersion < ComCtlVersionIE4 then
{$IF DEFINED(CLR)}
      WinClassName := Format('%s.%.8X:%.8X', [ClassName, HInstance, GetCurrentThreadID]);
{$ELSE}
      WinClassName := Format('%s.%.8X:%.8X', [ClassName, HInstance, GetCurrentThreadID]);
{$IFEND}
  end;
end;

//[UIPermission(SecurityAction.LinkDemand, Window=UIPermissionWindow.AllWindows)]
procedure TAnimate.CreateWnd;
begin
  FRecreateNeeded := False;
  FOpen := False;
  inherited CreateWnd;
  UpdateActiveState;
end;

procedure TAnimate.DestroyWnd;
var
  OldActive, OldOpen: Boolean;
begin
  OldActive := FActive;
  OldOpen := FOpen;
  SetOpen(False);
  inherited DestroyWnd;
  FOpen := OldOpen;
  FActive := OldActive;
end;

procedure TAnimate.UpdateActiveState;
begin
  if not (csLoading in ComponentState) then
  begin
    { Attempt to open AVI and set active if applicable }
    SetOpen(True);
    if FActive then
    begin
      FActive := False;
      SetActive(True);
    end;
  end;
end;

procedure TAnimate.WMNCCalcSize(var Message: TWMNCCalcSize);
{$IF DEFINED(CLR)}
var
  Temp: TNCCalcSizeParams;
begin
  if csDesigning in ComponentState then
  begin
    Temp := Message.CalcSize_Params;
    InflateRect(Temp.rgrc0, -1, -1);
    Message.CalcSize_Params := Temp;
  end;
  inherited;
{$ELSE}
begin
  if csDesigning in ComponentState then
    with Message.CalcSize_Params^ do
      InflateRect(rgrc[0], -1, -1);
  inherited;
{$IFEND}
end;

procedure TAnimate.WMNCHitTest(var Message: TWMNCHitTest);
begin
  with Message do
    if not (csDesigning in ComponentState) then
      Result := HTCLIENT
    else
      inherited;
end;

procedure TAnimate.WMNCPaint(var Message: TWMNCPaint);
var
  DC: HDC;
  R: TRect;
  Pen, SavePen: HPEN;
begin
  if csDesigning in ComponentState then
  begin
    { Get window DC that is clipped to the non-client area }
    DC := GetDCEx(Handle, 0, DCX_WINDOW or DCX_CACHE or DCX_CLIPSIBLINGS);
    try
      GetWindowRect(Handle, R);
      OffsetRect(R, -R.Left, -R.Top);
      with R do
      begin
        ExcludeClipRect(DC, Left+1, Top+1, Right-1, Bottom-1);
        Pen := CreatePen(PS_DASH, 1, clBlack);
        SavePen := SelectObject(DC, Pen);
        SetBkColor(DC, ColorToRGB(Color));
        Rectangle(DC, R.Left, R.Top, R.Right, R.Bottom);
        if SavePen <> 0 then SelectObject(DC, SavePen);
        DeleteObject(Pen);
      end;
    finally
      ReleaseDC(Handle, DC);
    end;
  end
  else inherited;
end;

procedure TAnimate.WMSize(var Message: TWMSize);
begin
  inherited;
end;

procedure TAnimate.WMWindowPosChanged(var Message: TWMWindowPosChanged);
var
  R: TRect;
begin
  inherited;
  InvalidateRect(Handle, nil, True);
  R := Rect(0, 0, FrameWidth, FrameHeight);
  if Center then
    OffsetRect(R, (ClientWidth - (R.Right - R.Left)) div 2,
      (ClientHeight - (R.Bottom - R.Top)) div 2);
  ValidateRect(Handle, R);
  UpdateWindow(Handle);
  InvalidateRect(Handle, R, False);
end;

procedure TAnimate.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    RecreateWnd;
end;

procedure TAnimate.CNCommand(var Message: TWMCommand);
begin
  inherited;
  case Message.NotifyCode of
    ACN_START: DoStart;
    ACN_STOP:
      if FStopCount = 0 then
        DoStop
      else
        Dec(FStopCount);
  end;
end;

procedure TAnimate.DoOpen;
begin
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TAnimate.DoClose;
begin
  if Assigned(FOnClose) then FOnClose(Self);
end;

procedure TAnimate.DoStart;
begin
  if Assigned(FOnStart) then FOnStart(Self);
  FActive := True;
end;

procedure TAnimate.DoStop;
begin
  if Assigned(FOnStop) then FOnStop(Self);
  FActive := False;
end;

procedure TAnimate.Loaded;
begin
  inherited Loaded;
  if FStreamedActive then SetActive(True);
end;

procedure TAnimate.GetAnimateParams(var Params: TAnimateParams);
begin
  with Params do
  begin
    FileName := FFileName;
    CommonAVI := FCommonAVI;
    ResHandle := FResHandle;
    ResName := FResName;
    ResId := FResId;
  end;
end;

procedure TAnimate.SetAnimateParams(const Params: TAnimateParams);
begin
  with Params do
  begin
    FFileName := FileName;
    FCommonAVI := CommonAVI;
    FResHandle := ResHandle;
    FResName := ResName;
    FResId := ResId;
  end;  
end;

type
{$IF DEFINED(CLR)}
  TResNameType = Integer;
{$ELSE}
  TResNameType = PChar;
{$IFEND}

function TAnimate.GetActualResHandle: THandle;
const
  CommonAVIId: array[TCommonAVI] of Integer = (0, 150, 151, 152, 160, 161, 162,
    163, 164);
  ResType = 'AVI';
begin
  if FCommonAVI <> aviNone then
  begin
    if (Win32MajorVersion >= 6) then
    begin
      if FindResource(MainInstance, TResNameType(CommonAVIId[FCommonAVI]), ResType) <> 0 then
        Result := MainInstance
      else if FindResource(HInstance, TResNameType(CommonAVIId[FCommonAVI]), ResType) <> 0 then
        Result := HInstance
      else Result := GetShellModule;
    end
    else Result := GetShellModule;
  end
  else if FResHandle <> 0 then Result := FResHandle
  else if MainInstance <> 0 then Result := MainInstance
  else Result := HInstance;
end;

function TAnimate.GetActualResId: TAnimateResId;
const
  CommonAVIId: array[TCommonAVI] of Integer = (0, 150, 151, 152, 160, 161, 162,
    163, 164);
begin
  if FCommonAVI <> aviNone then Result := TAnimateResId(CommonAVIId[FCommonAVI])
  else if FFileName <> '' then Result := TAnimateResId(FFileName)
  else if FResName <> '' then Result := TAnimateResId(FResName)
  else Result := TAnimateResId(FResId);
end;

procedure TAnimate.GetFrameInfo;

  function CreateResStream: TStream;
  const
    ResType = 'AVI';
  var
    Instance: THandle;
{$IF DEFINED(CLR)}
    ResourceID: TObject;
{$IFEND}
  begin
    { AVI is from a file }
    if FFileName <> '' then
      Result := TFileStream.Create(FFileName, fmShareDenyNone)
    else
    begin
      { AVI is from a resource }
      Instance := GetActualResHandle;
      if FResName <> '' then
        Result := TResourceStream.Create(Instance, FResName, ResType)
      else
{$IF DEFINED(CLR)}
      begin
        ResourceID := GetActualResId;
        if ResourceID is System.String then
          Result := TResourceStream.Create(Instance, string(ResourceID), ResType)
        else
          Result := TResourceStream.CreateFromID(Instance, Integer(ResourceID), ResType);
      end;
{$ELSE}
        Result := TResourceStream.CreateFromID(Instance, GetActualResId, ResType);
{$IFEND}
    end;
  end;

const
  CountOffset = 48;
  WidthOffset = 64;
  HeightOffset = 68;
begin
  with CreateResStream do
  try
    if Seek(CountOffset, soBeginning) = CountOffset then
      ReadBuffer(FFrameCount, SizeOf(FFrameCount));
    if Seek(WidthOffset, soBeginning) = WidthOffset then
      ReadBuffer(FFrameWidth, SizeOf(FFrameWidth));
    if Seek(HeightOffset, soBeginning) = HeightOffset then
      ReadBuffer(FFrameHeight, SizeOf(FFrameHeight));
  finally
    Free;
  end;
end;

procedure TAnimate.SetActive(Value: Boolean);
begin
  if (csReading in ComponentState) then
  begin
    if Value then FStreamedActive := True;
  end
  else
  begin
    if FActive <> Value then
    begin
      if Value then
        Play(FStartFrame, FStopFrame, FRepetitions)
      else
        Stop;
    end;
  end;
end;

procedure TAnimate.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    RecreateWnd;
  end;
end;

procedure TAnimate.SetCommonAVI(Value: TCommonAVI);
begin
  if FCommonAVI <> Value then
  begin
    FRecreateNeeded := (FCommonAVI = aviNone) and
      (GetComCtlVersion < ComCtlVersionIE4);
    FCommonAVI := Value;
    FFileName := '';
    FResHandle := 0;
    FResName := '';
    FResId := 0;
    if Value = aviNone then SetOpen(False) else Reset;
  end;
end;

procedure TAnimate.SetFileName(Value: string);
var
  Save: TAnimateParams;
begin
  if AnsiCompareText(FFileName, Value) <> 0 then
  begin
    GetAnimateParams(Save);
    try
      FFileName := Value;
      FCommonAVI := aviNone;
      FResHandle := 0;
      FResName := '';
      FResId := 0;
      if FFileName = '' then SetOpen(False) else Reset;
    except
      SetAnimateParams(Save);
      raise;
    end;
  end;
end;

procedure TAnimate.SetOpen(Value: Boolean);
begin
  if (FOpen <> Value) then
    if Value then
    begin
      FOpen := InternalOpen;
      if AutoSize then AdjustSize;
    end
    else FOpen := InternalClose;
end;

procedure TAnimate.SetRepetitions(Value: Integer);
begin
  if FRepetitions <> Value then
  begin
    FRepetitions := Value;
    if not (csLoading in ComponentState) then Stop;
  end;
end;

procedure TAnimate.SetResHandle(Value: THandle);
begin
  if FResHandle <> Value then       
  begin
    FResHandle := Value;
    FRecreateNeeded := GetComCtlVersion < ComCtlVersionIE4;
    FCommonAVI := aviNone;
    FFileName := '';
    SetOpen(False)
  end;
end;

procedure TAnimate.SetResId(Value: Integer);
begin
  if FResId <> Value then
  begin
    FResId := Value;
    FRecreateNeeded := ((FCommonAVI <> aviNone) or (FFileName <> '')) and
      (GetComCtlVersion < ComCtlVersionIE4);
    FCommonAVI := aviNone;
    FFileName := '';
    FResName := '';
    if Value = 0 then SetOpen(False) else Reset;
  end;
end;

procedure TAnimate.SetResName(Value: string);
begin
  if FResName <> Value then
  begin
    FResName := Value;
    FRecreateNeeded := (FCommonAVI <> aviNone) or (FFileName <> '') and
      (GetComCtlVersion < ComCtlVersionIE4);
    FCommonAVI := aviNone;
    FFileName := '';
    FResId := 0;
    if Value = '' then SetOpen(False) else Reset;
  end;
end;

procedure TAnimate.SetStartFrame(Value: Smallint);
begin
  if FStartFrame <> Value then
  begin
    FStartFrame := Value;
    if not (csLoading in ComponentState) then
    begin
      Stop;
      Seek(Value);
    end;
  end;
end;

procedure TAnimate.SetStopFrame(Value: Smallint);
begin
  if FStopFrame <> Value then
  begin
    FStopFrame := Value;
    if not (csLoading in ComponentState) then Stop;
  end;
end;

procedure TAnimate.SetTimers(Value: Boolean);
begin
  if FTimers <> Value then
  begin
    FTimers := Value;
    RecreateWnd();
  end;
end;

procedure TAnimate.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    RecreateWnd();
  end;
end;

procedure TAnimate.CheckOpen;
begin
  SetOpen(True);
  if not Open then
    raise Exception.CreateRes({$IFNDEF CLR}@{$ENDIF}SCannotOpenAVI);
end;

function TAnimate.InternalOpen: Boolean;
var
  R: TRect;
{$IF DEFINED(CLR)}
  ResId: TObject;
{$IFEND}
begin
  if FRecreateNeeded then RecreateWnd();
  HandleNeeded;
  { Preserve dimensions to prevent auto sizing }
  if not Center then R := BoundsRect;
{$IF DEFINED(CLR)}
  ResId := GetActualResId;
  if ResId is System.Int32 then
    Result := Perform(_ACM_OPEN, GetActualResHandle, Integer(ResId)) <> 0
  else
    Result := Perform(_ACM_OPEN, GetActualResHandle, string(ResId)) <> 0;
{$ELSE}
  Result := Perform(ACM_OPEN, GetActualResHandle, GetActualResId) <> 0;
{$IFEND}
  { Restore dimensions in case control was resized }
  if not Center then BoundsRect := R;
  if Result then
  begin
    GetFrameInfo;
    FStartFrame := 1;
    FStopFrame := FFrameCount;
    DoOpen;
  end;
end;

function TAnimate.InternalClose: Boolean;
begin
  if FActive then Stop;
  Result := SendMessage(Handle, _ACM_OPEN, 0, 0) <> 0;
  DoClose;
  Invalidate;
end;

procedure TAnimate.Play(FromFrame, ToFrame: Word; Count: Integer);
begin
  HandleNeeded;
  CheckOpen;
  FActive := True;
  { ACM_PLAY excpects -1 for repeated animations }
  if Count = 0 then Count := -1;
  if Perform(ACM_PLAY, Count, MakeLong(FromFrame - 1, ToFrame - 1)) <> 1 then
    FActive := False;
end;

procedure TAnimate.Reset;
begin
  if not (csLoading in ComponentState) then
  begin
    SetOpen(False);
    Seek(1);
  end;
end;

procedure TAnimate.Seek(Frame: Smallint);
begin
  CheckOpen;
  SendMessage(Handle, ACM_PLAY, 1, MakeLong(Frame - 1, Frame - 1));
end;

procedure TAnimate.Stop;
begin
  { Seek to first frame }
  SendMessage(Handle, ACM_PLAY, 1, MakeLong(StartFrame - 1, StartFrame - 1));
  FActive := False;
  Inc(FStopCount);
  DoStop;
end;

function TAnimate.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  if Open then
  begin
    Result := True;
    NewWidth := FrameWidth;
    NewHeight := FrameHeight;
  end
  else Result := False;
end;

end.
