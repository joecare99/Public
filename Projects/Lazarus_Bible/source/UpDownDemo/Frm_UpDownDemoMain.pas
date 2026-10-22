unit Frm_UpDownDemoMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 Messages,
 SysUtils,
 Classes,
 Graphics,
 Controls,
 Forms,
 Dialogs,

  StdCtrls,
 Spin,
 ComCtrls,
 Buttons,
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages
{$ENDIF};

type
{$IFDEF FPC}
  { local replacement for the CLX-Demo TSpinButton on FPC }
  TSpinButton = class(TWinControl)
  private
    FUpBtn: TSpeedButton;
    FDownBtn: TSpeedButton;
    FUpGlyph: TBitmap;
    FDownGlyph: TBitmap;
    FOnUpClick: TNotifyEvent;
    FOnDownClick: TNotifyEvent;
    procedure UpdateButtons;
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  published
    property UpGlyph: TBitmap read FUpGlyph write FUpGlyph;
    property DownGlyph: TBitmap read FDownGlyph write FDownGlyph;
    property OnUpClick: TNotifyEvent read FOnUpClick write FOnUpClick;
    property OnDownClick: TNotifyEvent read FOnDownClick write FOnDownClick;
  end;
{$ENDIF}

  TfrmUpDownDemoMain = class(TForm)
    UpDown1: TUpDown;
    SpinButton1: TSpinButton;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure SpinButton1UpClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUpDownDemoMain: TfrmUpDownDemoMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
{ These constants and the two event handlers are needed
  by SpinButton components to associate them with another
  control, a StaticText object in this demonstration. The
  new UpDown component needs none of this programming because
  it can be automatically associated with another control. }
const
  Min = -10;
  Max = +10;

{$IFDEF FPC}
constructor TSpinButton.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FUpGlyph := TBitmap.Create;
  FDownGlyph := TBitmap.Create;
  FUpBtn := TSpeedButton.Create(Self);
  FUpBtn.OnClick := UpBtnClick;
  FUpBtn.Flat := True;
  FDownBtn := TSpeedButton.Create(Self);
  FDownBtn.OnClick := DownBtnClick;
  FDownBtn.Flat := True;
  Width := 20;
  Height := 33;
  UpdateButtons;
end;

destructor TSpinButton.Destroy;
begin
  FUpGlyph.Free;
  FDownGlyph.Free;
  inherited Destroy;
end;

procedure TSpinButton.UpBtnClick(Sender: TObject);
begin
  if Assigned(FOnUpClick) then FOnUpClick(Self);
end;

procedure TSpinButton.DownBtnClick(Sender: TObject);
begin
  if Assigned(FOnDownClick) then FOnDownClick(Self);
end;

procedure TSpinButton.UpdateButtons;
begin
  FUpBtn.Parent := Self;
  FDownBtn.Parent := Self;
  FUpBtn.Left := 0;
  FUpBtn.Top := 0;
  FUpBtn.Width := Self.Width;
  FUpBtn.Height := Self.Height div 2;
  FDownBtn.Left := 0;
  FDownBtn.Top := Self.Height div 2;
  FDownBtn.Width := Self.Width;
  FDownBtn.Height := Self.Height - Self.Height div 2;
  FUpBtn.Caption := #9650;
  FDownBtn.Caption := #9660;
end;
{$ENDIF}

{ Respond to user clicking the SpinButton's Up button }
procedure TfrmUpDownDemoMain.SpinButton1UpClick(Sender: TObject);
var
  V: Integer;
begin
  V := StrToInt(StaticText2.Caption);
  if V = Max
    then V := Min
    else inc(V);
  StaticText2.Caption := IntToStr(V);
end;

{ Respond to user clicking the SpinButton's Down button }
procedure TfrmUpDownDemoMain.SpinButton1DownClick(Sender: TObject);
var
  V: Integer;
begin
  V := StrToInt(StaticText2.Caption);
  if V = Min
    then V := Max
    else dec(V);
  StaticText2.Caption := IntToStr(V);
end;

end.
