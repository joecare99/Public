unit Frm_CLIMAIN;

{ DDE-Color-Client als FPC-Variante: nimmt Farbtexte ueber fcl-simpleipc
  entgegen (SimpleIPCServer1, ServerID 'ddecolor') und faerbt das Edit.
  Der Server (CServer) sendet die gewaehlte Farbe. Unter Delphi bleibt die
  DDE-Variante erhalten. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, Ddeman,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, Classes, Graphics, Controls,
  Forms, Dialogs,  StdCtrls, Buttons, ExtCtrls
  {$IFDEF FPC}, simpleipc{$ENDIF};

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    ColorValueLabel: TLabel;
    BitBtn1: TBitBtn;
    Shape1: TShape;
    Timer1: TTimer;
{$IFDEF FPC}
    SimpleIPCServer1: TSimpleIPCServer;
    procedure SimpleIPCServer1Message(Sender: TObject);
{$ELSE}
    DdeClientConv1: TDdeClientConv;
    DdeClientItem1: TDdeClientItem;
    procedure DdeClientItem1Change(Sender: TObject);
    procedure DdeClientConv1Open(Sender: TObject);
    procedure DdeClientConv1Close(Sender: TObject);
{$ENDIF}
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    fOpen: Boolean;
    procedure ApplyColorText(const AText: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  asciiBlank = ' ';  { One blank between two single quotes }

{- Parse a color string and update the sample color and label. }
procedure TMainForm.ApplyColorText(const AText: string);
var
  S: String;
  C: TColor;
begin
  if Length(AText) = 0 then
    S := '$0'   { Default string }
  else
    S := AText;  { String from server }
  try
    while (Length(S) > 0) and (S[Length(S)] = asciiBlank) do  { Trailing blanks }
      System.Delete(S, Length(S), 1);
    C := StringToColor(S);              { Convert to color }
    ColorValueLabel.Caption := S;       { Assign to label }
    Edit1.Color := C;                   { Show color }
  except
    ShowMessage('Bad color format from server');
  end;
end;

{$IFDEF FPC}
procedure TMainForm.SimpleIPCServer1Message(Sender: TObject);
begin
  ApplyColorText(SimpleIPCServer1.StringMessage);
end;
{$ELSE}
procedure TMainForm.DdeClientConv1Close(Sender: TObject);
begin
  fOpen := false;
end;

procedure TMainForm.DdeClientConv1Open(Sender: TObject);
begin
  fOpen := true;
end;

procedure TMainForm.DdeClientItem1Change(Sender: TObject);
begin
  ApplyColorText(DdeClientItem1.Text);
end;
{$ENDIF}

{- Establish conversation with server. }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  {$IFDEF FPC}
  { Der IPC-Server dieses Formulars ist aktiv; die Verbindung gilt als offen. }
  fOpen := True;
  {$ELSE}
  if DdeClientConv1.SetLink('CSERVER', 'ColorServer') then
  begin
    DdeClientItem1.DdeItem := 'ColorItem';
    if DdeClientConv1.ConnectMode = ddeManual then
      DdeClientConv1.OpenLink;
  end;
  {$ENDIF}
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if fOpen then
    Shape1.Brush.Color := clLime
    else
    Shape1.Brush.Color := clMaroon;
end;

end.
