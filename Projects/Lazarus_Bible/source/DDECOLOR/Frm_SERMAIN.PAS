unit Frm_SERMAIN;

{ DDE-Color-Server als FPC-Variante: Statt DdeServerConv/DdeServerItem
  (Windows-only) sendet das Formular die gewaehlte Farbe als Text ueber
  fcl-simpleipc an den Client (SimpleIPCClient1, ServerID 'ddecolor').
  Unter Delphi bleibt die DDE-Variante erhalten. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 SysUtils,
 Messages,
 Classes,
 Graphics,
 Controls,

  Forms,
 Dialogs,
 StdCtrls,
 Buttons,
 ExtCtrls,
{$IFnDEF FPC}
  Windows,
  DdeMan,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages,
  simpleipc
{$ENDIF};

type
  TMainForm = class(TForm)
    RedLabel: TLabel;
    GreenLabel: TLabel;
    BlueLabel: TLabel;
    RedSB: TScrollBar;
    GreenSB: TScrollBar;
    BlueSB: TScrollBar;
    RedEdit: TEdit;
    GreenEdit: TEdit;
    BlueEdit: TEdit;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
{$IFDEF FPC}
    SimpleIPCClient1: TSimpleIPCClient;
{$ELSE}
    ColorServer: TDdeServerConv;
    ColorItem: TDdeServerItem;
{$ENDIF}
    procedure FormCreate(Sender: TObject);
    procedure SBChange(Sender: TObject);
    procedure EditChange(Sender: TObject);
  private
    EditControls: array[0 .. 2] of TEdit;
    ScrollBars: array[0 .. 2] of TScrollBar;
    procedure UpdateColor;
  public
    ColorResult: TColor;  { Selected color }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}

  {$R *.dfm}

{$ELSE}

  {$R *.lfm}

{$ENDIF}
{- Update ColorResult using scrollbar positions. Send
color information to any client applications. }
procedure TMainForm.UpdateColor;
begin
  ColorResult := RGB(
    RedSB.Position, GreenSB.Position, BlueSB.Position);
  {$IFDEF FPC}
  try
    if not SimpleIPCClient1.Active then
      SimpleIPCClient1.Connect;
    SimpleIPCClient1.SendStringMessage(ColorToString(ColorResult));
  except
    { Empfaenger nicht erreichbar - die Farbe geht verloren. }
  end;
  {$ELSE}
  ColorItem.Text := ColorToString(ColorResult);
  {$ENDIF}
end;

{- Initialize Edit and Scrollbar arrays for easy access }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  EditControls[0] := RedEdit;
  EditControls[1] := GreenEdit;
  EditControls[2] := BlueEdit;
  ScrollBars[0] := RedSB;
  ScrollBars[1] := GreenSB;
  ScrollBars[2] := BlueSB;
  {$IFDEF FPC}
  try
    SimpleIPCClient1.Connect;
  except
    { Der Empfaenger (CClient) laeuft noch nicht - bei Aenderung erneut. }
  end;
  {$ENDIF}
end;

{- Update values in Edit boxes for ScrollBar changes }
procedure TMainForm.SBChange(Sender: TObject);
begin
  with Sender as TScrollBar do
    EditControls[Tag].Text := IntToStr(Position);
  UpdateColor;
end;

{- Update scrollbar positions for Edit box changes }
procedure TMainForm.EditChange(Sender: TObject);
begin
  with Sender as TEdit do
    ScrollBars[Tag].Position := StrToInt(Text);
end;

end.
